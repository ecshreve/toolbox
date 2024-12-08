export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$HOME/go/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
export FZF_BASE="$HOME/.fzf/bin/fzf"
export FZF_DEFAULT_OPTS='--cycle --layout=reverse --border --height=80% --preview="bat --style=numbers --color=always --line-range :500 {}" --preview-window=nowrap --marker="*"'

ZSH_THEME="powerlevel10k/powerlevel10k"
DISABLE_AUTO_UPDATE="true"
ZSH_DISABLE_COMPFIX="true"

plugins=(
    asdf
    direnv
    eza
    fzf
    git
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
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
alias cl='clear -x'
alias cll='clear -x && ls -alF'
alias clear='clear -x'

# Git
alias gcm='git checkout main'
alias gco='git checkout'
alias gup='git pull --rebase'
alias gdoof='git add --all && git commit --amend --no-edit'
alias goops='git reset --soft HEAD~1 && git status'
alias gll='git diff --cached | wc -l'

# Network
alias nett='netstat -tulnp | grep LISTEN'
alias snett='sudo netstat -tulnp | grep LISTEN'

# Configure history size and options
HISTSIZE=70000
SAVEHIST=70000
setopt HIST_IGNORE_SPACE   # Do not put commands in history if they begin with a SPACE
setopt HIST_REDUCE_BLANKS  # Trim excessive whitespace from commands before adding to history

# Source theme and other scripts
[ -f $HOME/.p10k.zsh ] && source $HOME/.p10k.zsh
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
