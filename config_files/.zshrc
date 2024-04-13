export FZF_BASE="$HOME/.fzf/bin/fzf"
export ZSH="$HOME/.oh-my-zsh"
export TOOLBOX_DIR="$HOME/.toolbox"
export ANSIBLE_CONFIG="$TOOLBOX_DIR/ansible/ansible.cfg"

ZSH_THEME="powerlevel10k/powerlevel10k"
DISABLE_AUTO_UPDATE="true"

plugins=(
    git
    forgit
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
    fzf
)

source $ZSH/oh-my-zsh.sh

# ctrl+space accepts the suggestion
bindkey '^ ' autosuggest-accept

zle -N fzf-file-widget
bindkey -M emacs '^ff' fzf-file-widget
bindkey -M vicmd '^ff' fzf-file-widget
bindkey -M viins '^ff' fzf-file-widget

# General
alias cat='bat'
alias ls='exa --icons'
alias ll='ls -alF'
alias cl='clear -x'
alias cll='clear -x && ls -alF'
alias clear='clear -x'

# Git
alias gcm='git checkout main'
alias gco='git checkout'
alias gdoof='git add --all && git commit --amend --no-edit'
alias goops='git reset --soft HEAD~1 && git status'
alias gll='git diff --cached | wc -l'
alias gbb='forgit::checkout::branch'
alias gcp='forgit::cherry::pick::from::branch'

# Network
alias nett='netstat -tulnp | grep LISTEN'
alias snett='sudo netstat -tulnp | grep LISTEN'

# Ansible
alias nav-play='ansible-navigator run'
alias nav-ans='ansible-navigator'

# Configure history size and options
HISTSIZE=70000
SAVEHIST=70000
setopt HIST_IGNORE_SPACE   # Do not put commands in history if they begin with a SPACE
setopt HIST_REDUCE_BLANKS  # Trim excessive whitespace from commands before adding to history

# Source theme and other scripts
[ -f $HOME/.p10k.zsh ] && source $HOME/.p10k.zsh
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
