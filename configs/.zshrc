export FZF_BASE=$HOME/.fzf/bin/fzf
export FZF_DEFAULT_OPTS='--cycle --layout=reverse --border --height=90% --preview="head -$LINES {}" --preview-window=nowrap --marker="*"'
export ZSH=$HOME/.oh-my-zsh

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

alias cat='bat'
alias ls='exa --icons'
alias ll='ls -alF'
alias cl='clear -x'
alias clear='clear -x'
alias gcm='git checkout main'
alias gdoof='git add --all && git commit --amend --no-edit'
alias goops='git reset --soft HEAD~1 && git status'

# Set history size
HISTSIZE=70000
SAVEHIST=70000
# Do not put commands in history if they begin with a SPACE
setopt HIST_IGNORE_SPACE
# Trim excessive whitespace from commands before adding to history
setopt HIST_REDUCE_BLANKS

[ -f $HOME/.p10k.zsh ] && source $HOME/.p10k.zsh
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
