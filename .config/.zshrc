source "/home/notrodans/.sdkman/bin/sdkman-init.sh"

export MASON="$HOME/.local/share/nvim/mason"
export ZSH="$HOME/.oh-my-zsh"
export TERM=xterm-256color

ZSH_THEME="robbyrussell"
plugins=(git)

source $ZSH/oh-my-zsh.sh

export EDITOR=nvim
export SUDO_EDITOR=nvim

alias current-size="du -ch --max-depth 1 . | sort -rh"
alias pacfzf="pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -Syy"
alias pacall="pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# opencode
export PATH=/home/notrodans/.opencode/bin:$PATH
