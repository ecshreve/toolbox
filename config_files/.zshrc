export PATH="/usr/local/go/bin:$HOME/go/bin:$HOME/.local/bin:$PATH"
export TOOLBOX_DIR="$HOME/.toolbox"

export FZF_BASE="$HOME/.fzf/bin/fzf"
export ZSH="$HOME/.oh-my-zsh"
export FZF_DEFAULT_OPTS='--cycle --layout=reverse --border --height=80% --preview="bat --style=numbers --color=always --line-range :500 {}" --preview-window=nowrap --marker="*"'

ZSH_THEME="powerlevel10k/powerlevel10k"
DISABLE_AUTO_UPDATE="true"

plugins=(
    direnv
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

# TODO: should these be moved?
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



export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
