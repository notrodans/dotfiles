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
  # Back up any existing file/symlink at destination before linking
  backup_existing "$dst"
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
FONTS_DIR="$REPO_ROOT/fonts"
SPECIAL_HOME_FILES=(".zshrc" ".tmux.conf" ".icons" ".themes" "eclipse-java-google-style.xml" "eclipse-my-style.xml")

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
  (find "$CONFIG_DIR" -mindepth 1 -maxdepth 1 | sed 's#.*/##')
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
                                                                                  
list_fonts_entries() {
  find "$FONTS_DIR" -mindepth 1 -maxdepth 1 -printf "%f\n" 2>/dev/null || \
  (find "$FONTS_DIR" -mindepth 1 -maxdepth 1 | sed 's#.*/##')
}

check_fonts() {
  local name src dst ret=0
  while IFS= read -r name; do
    src="$FONTS_DIR/$name"
    dst="$HOME/.local/share/fonts/$name"
    if [[ -L "$dst" ]]; then
      if samepath "$src" "$dst"; then
        info "OK font link: $dst"
      else
        warn "Wrong font link: $dst -> $(readlink "$dst") (should be -> $src)"
        ret=1
      fi
    elif [[ -e "$dst" ]]; then
      warn "Font exists but not a symlink: $dst"
      ret=1
    else
      warn "Missing font: $dst"
      ret=1
    fi
  done < <(list_fonts_entries)
  return "$ret"
}

link_fonts() {
  local name src dst
  while IFS= read -r name; do
    src="$FONTS_DIR/$name"
    dst="$HOME/.local/share/fonts/$name"
    ensure_link "$src" "$dst"
  done < <(list_fonts_entries)
  fc-cache -f >/dev/null 2>&1 || true
}

unlink_fonts() {
  local name dst
  while IFS= read -r name; do
    dst="$HOME/.local/share/fonts/$name"
    unlink_path "$dst"
  done < <(list_fonts_entries)
}

check_all() {                                                                     
  local name ret=0                                                                
  while IFS= read -r name; do                                                     
    check_one "$name" || ret=1                                                    
  done < <(list_config_entries)
  check_fonts || ret=1
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
  link_fonts
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
  unlink_fonts
}
