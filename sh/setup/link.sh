#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../lib/common.sh
. "$(dirname "$0")/../lib/common.sh"

timestamp() { date +"%Y%m%d%H%M%S"; }

samepath() {
  # Compare canonical paths
  local A B
  A="$(canonpath "$1")" || return 1
  B="$(canonpath "$2")" || return 1
  [[ "$A" == "$B" ]]
}

backup_existing() {
  local dst="$1"
  if [[ -e "$dst" || -L "$dst" ]]; then
    local bak="${dst}.bak.$(timestamp)"
    mv -f -- "$dst" "$bak"
    warn "Backed up $dst -> $bak"
  fi
}

ensure_parent() {
  local dst="$1"
  mkdir -p -- "$(dirname -- "$dst")"
}

ensure_link() {
  # ensure_link SRC DST
  local src="$1" dst="$2"
  ensure_parent "$dst"
  # If already correct symlink or same canonical, skip
  if [[ -L "$dst" ]]; then
    local cur
    cur="$(readlink "$dst" || true)"                                              
    if [[ -n "$cur" ]] && samepath "$src" "$dst"; then                            
      info "OK link: $dst"
      return 0
    fi
  elif [[ -e "$dst" ]] && samepath "$src" "$dst"; then
    info "OK file/dir already matches: $dst"
    return 0
  fi

  # Replace anything at dst safely
  # Use -n to not dereference if dst is a symlink to a dir; -f to force replace; -s for symlink
  # Some ln implementations need removing first; do a best-effort unlink
  if [[ -e "$dst" || -L "$dst" ]]; then
    rm -rf -- "$dst"
  fi
  ln -sfn -- "$src" "$dst"
  info "Linked: $dst -> $src"
}

unlink_path() {
  local dst="$1"
  if [[ -L "$dst" ]]; then
    rm -f -- "$dst"
    info "Unlinked symlink: $dst"
  fi
}

# Domain-specific logic
CONFIG_DIR="$REPO_ROOT/.config"
SPECIAL_HOME_FILES=(".zshrc" ".tmux.conf" ".icons" ".themes")

is_special_home() {
  local name="$1"
  for s in "${SPECIAL_HOME_FILES[@]}"; do
    [[ "$s" == "$name" ]] && return 0
  done
  return 1
}

list_config_entries() {
  # One level under repo .config
  find "$CONFIG_DIR" -mindepth 1 -maxdepth 1 -printf "%f\n" 2>/dev/null || \
  find "$CONFIG_DIR" -mindepth 1 -maxdepth 1 -exec basename {} \;                 
}                                                                                 
                                                                                  
check_one() {                                                                     
  # check_one NAME                                                                
  local name="$1" src dst                                                         
  src="$CONFIG_DIR/$name"                                                         
  if is_special_home "$name"; then                                                
    dst="$HOME/$name"                                                             
  else                                                                            
    dst="$HOME/.config/$name"                                                     
  fi                                                                              
                                                                                  
  if [[ -L "$dst" ]]; then                                                        
    if samepath "$src" "$dst"; then                                               
      info "OK link: $dst"                                                        
      return 0                                                                    
    else                                                                          
      local target                                                                
      target="$(readlink "$dst")"                                                 
      warn "Wrong link: $dst -> $target (should be -> $src)"                      
      return 1                                                                    
    fi                                                                            
  elif [[ -e "$dst" ]]; then                                                      
    warn "Exists but not a symlink: $dst"                                         
    return 1                                                                      
  else                                                                            
    warn "Missing: $dst"                                                          
    return 1                                                                      
  fi                                                                              
}                                                                                 
                                                                                  
check_all() {                                                                     
  local name ret=0                                                                
  while IFS= read -r name; do                                                     
    check_one "$name" || ret=1                                                    
  done < <(list_config_entries)                                                   
  return "$ret"                                                                   
}                                                                                 
                                                                                  
link_all() {
  local name src dst
  while IFS= read -r name; do
    src="$CONFIG_DIR/$name"
    if is_special_home "$name"; then
      dst="$HOME/$name"
    else
      dst="$HOME/.config/$name"
    fi
    ensure_link "$src" "$dst"                                                     
  done < <(list_config_entries)
}

adopt_one() {
  # Move from $HOME target into repo and link back
  local name="$1" src dst cur
  src="$CONFIG_DIR/$name"
  if is_special_home "$name"; then
    dst="$HOME/$name"
  else
    dst="$HOME/.config/$name"
  fi

  if [[ -L "$dst" ]]; then
    info "Already symlink: $dst (skipping adopt)"
    return 0
  fi

  if [[ -e "$dst" ]]; then
    ensure_parent "$src"
    # Move existing into repo
    if [[ -e "$src" || -L "$src" ]]; then
      backup_existing "$src"
      rm -rf -- "$src"
    fi
    mv -- "$dst" "$src"
    info "Moved $dst -> $src"
  else
    info "No target at $dst, will just link to repo copy"
  fi

  ensure_link "$src" "$dst"
}

adopt_all() {
  local name
  while IFS= read -r name; do
    adopt_one "$name"
  done < <(list_config_entries)
}

unlink_all() {
  local name dst
  while IFS= read -r name; do
    if is_special_home "$name"; then
      dst="$HOME/$name"
    else
      dst="$HOME/.config/$name"
    fi
    unlink_path "$dst"
  done < <(list_config_entries)
}
