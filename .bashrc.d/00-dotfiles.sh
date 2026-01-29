# =============================================================================
# 00-dotfiles.sh - Dotfiles Configuration
# =============================================================================
# Sourced by ~/.bashrc via ~/.bashrc.d/ mechanism.
# This file adds QoL improvements without conflicting with system defaults.
#
# Local overrides: ~/.bashrc.d/99-local.sh (gitignored)
# =============================================================================

# =============================================================================
# History
# =============================================================================
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="ls:cd:cd -:pwd:exit:clear:history"
shopt -s histappend

# =============================================================================
# Shell Options
# =============================================================================
shopt -s checkwinsize   # Update LINES/COLUMNS after each command
shopt -s globstar       # ** matches directories recursively (bash 4+)
shopt -s cdspell        # Autocorrect minor cd typos
shopt -s dirspell       # Autocorrect directory name typos
shopt -s autocd         # Type directory name to cd into it
shopt -s cmdhist        # Save multi-line commands as single entry

# =============================================================================
# Prompt
# =============================================================================
RED='\[\e[0;31m\]'
GREEN='\[\e[0;32m\]'
YELLOW='\[\e[0;33m\]'
BLUE='\[\e[0;34m\]'
RESET='\[\e[0m\]'

__git_branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

PS1="${GREEN}\u@\h${RESET}:${BLUE}\w${RESET}${YELLOW}\$(__git_branch)${RESET}\$ "

# =============================================================================
# Aliases - Navigation
# =============================================================================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# =============================================================================
# Aliases - Listing (only if not already defined)
# =============================================================================
# Don't override if user has custom 'l' function
if ! type -t l &>/dev/null | grep -q function; then
    if command -v eza &>/dev/null; then
        alias l='eza -la --git'
        alias ll='eza -l'
        alias la='eza -la'
        alias lt='eza -laT --level=2'
    elif command -v exa &>/dev/null; then
        alias l='exa -la --git'
        alias ll='exa -l'
        alias la='exa -la'
        alias lt='exa -laT --level=2'
    fi
fi

# Color grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# =============================================================================
# Aliases - Safety
# =============================================================================
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# =============================================================================
# Aliases - Shortcuts
# =============================================================================
alias c='clear'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%Y-%m-%d %H:%M:%S"'

# =============================================================================
# Aliases - Tmux
# =============================================================================
alias t='tmux'
alias ta='tmux attach -t'
alias tl='tmux list-sessions'
alias tn='tmux new -s'
alias tk='tmux kill-session -t'

# =============================================================================
# Aliases - System
# =============================================================================
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ports='ss -tulanp'
alias myip='curl -s ifconfig.me'

# =============================================================================
# Aliases - Git (only if not using custom git tool)
# =============================================================================
if command -v git &>/dev/null; then
    alias g='git'
    alias gs='git status'
    alias ga='git add'
    alias gc='git commit'
    alias gd='git diff'
    alias gl='git log --oneline -10'
    alias gp='git push'
    alias gpl='git pull'
fi

# =============================================================================
# Functions
# =============================================================================
mkcd() {
    mkdir -p "$1" && cd "$1"
}

extract() {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz)  tar xzf "$1" ;;
            *.tar.xz)  tar xJf "$1" ;;
            *.bz2)     bunzip2 "$1" ;;
            *.gz)      gunzip "$1" ;;
            *.tar)     tar xf "$1" ;;
            *.tbz2)    tar xjf "$1" ;;
            *.tgz)     tar xzf "$1" ;;
            *.zip)     unzip "$1" ;;
            *.Z)       uncompress "$1" ;;
            *.7z)      7z x "$1" ;;
            *)         echo "Cannot extract '$1': unknown format" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

backup() {
    cp "$1" "$1.bak.$(date +%Y%m%d%H%M%S)"
}

# =============================================================================
# Environment (only set if not already configured)
# =============================================================================
# Neovim from /opt (installed via bootstrap)
[[ -d /opt/nvim-linux-x86_64/bin ]] && export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# Prefer nvim over vim when available
if command -v nvim &>/dev/null; then
    [[ -z "$EDITOR" ]] && export EDITOR='nvim'
else
    [[ -z "$EDITOR" ]] && export EDITOR='vim'
fi
[[ -z "$VISUAL" ]] && export VISUAL="$EDITOR"
[[ -z "$PAGER" ]] && export PAGER='less'
export LESS='-R --mouse'

# XDG directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
