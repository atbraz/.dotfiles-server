# =============================================================================
# .bashrc - Interactive Shell Configuration
# =============================================================================
# Sourced for interactive non-login shells.
#
# Structure:
#   1. Early exit for non-interactive
#   2. History configuration
#   3. Shell options
#   4. Prompt
#   5. Aliases
#   6. Functions
#   7. Environment variables
#   8. Completions
#   9. Local overrides
#
# Local customizations: ~/.bashrc.local (gitignored)
# =============================================================================

# Exit early if not interactive (scripts, scp, etc.)
[[ $- != *i* ]] && return

# =============================================================================
# History
# =============================================================================
# Store 10k commands in memory, 20k in file
HISTSIZE=10000
HISTFILESIZE=20000

# ignoreboth = ignorespace + ignoredups
# erasedups  = remove older duplicate entries
HISTCONTROL=ignoreboth:erasedups

# Don't record these commands (noise reduction)
HISTIGNORE="ls:cd:cd -:pwd:exit:clear:history"

# Append to history file instead of overwriting
shopt -s histappend

# =============================================================================
# Shell Options
# =============================================================================
shopt -s checkwinsize   # Update LINES/COLUMNS after each command
shopt -s globstar       # ** matches directories recursively (bash 4+)
shopt -s cdspell        # Autocorrect minor cd typos
shopt -s dirspell       # Autocorrect directory name typos in completion
shopt -s autocd         # Type directory name to cd into it
shopt -s cmdhist        # Save multi-line commands as single history entry

# =============================================================================
# Prompt
# =============================================================================
# ANSI color codes wrapped in \[ \] for proper line length calculation
RED='\[\e[0;31m\]'
GREEN='\[\e[0;32m\]'
YELLOW='\[\e[0;33m\]'
BLUE='\[\e[0;34m\]'
CYAN='\[\e[0;36m\]'
RESET='\[\e[0m\]'

# Extract current git branch (if in a repo)
__git_branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Prompt format: user@host:path (branch)$
# Green user@host, blue path, yellow branch
PS1="${GREEN}\u@\h${RESET}:${BLUE}\w${RESET}${YELLOW}\$(__git_branch)${RESET}\$ "

# =============================================================================
# Aliases - Navigation
# =============================================================================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# =============================================================================
# Aliases - Listing
# =============================================================================
# Prefer exa/eza if available, fall back to ls with colors
if command -v exa &>/dev/null; then
    alias ls='exa'
    alias l='exa -la --git'
    alias ll='exa -l'
    alias la='exa -la'
    alias lt='exa -laT --level=2'
elif ls --color=auto &>/dev/null 2>&1; then
    alias ls='ls --color=auto'
    alias l='ls -lAh'
    alias ll='ls -lh'
    alias la='ls -lAh'
else
    # Fallback for systems without GNU ls
    alias l='ls -lA'
    alias ll='ls -l'
    alias la='ls -lA'
fi

# =============================================================================
# Aliases - Grep
# =============================================================================
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# =============================================================================
# Aliases - Safety
# =============================================================================
# Prompt before overwriting (remove -i if you find it annoying)
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# =============================================================================
# Aliases - Shortcuts
# =============================================================================
alias c='clear'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'       # Print PATH entries, one per line
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
# Aliases - System Info
# =============================================================================
alias df='df -h'                          # Human-readable sizes
alias du='du -h'
alias free='free -h'
alias ports='ss -tulanp'                  # Show listening ports
alias myip='curl -s ifconfig.me'          # Public IP address

# =============================================================================
# Aliases - Git
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

# Create directory and cd into it
# Usage: mkcd mydir
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
# Usage: extract archive.tar.gz
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

# Create timestamped backup of a file
# Usage: backup important.conf
# Result: important.conf.bak.20240115143022
backup() {
    cp "$1" "$1.bak.$(date +%Y%m%d%H%M%S)"
}

# =============================================================================
# Environment Variables
# =============================================================================
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
export LESS='-R --mouse'    # -R: interpret ANSI colors, --mouse: scroll support

# XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# =============================================================================
# Completions
# =============================================================================
# Enable programmable completion features
if [[ -f /etc/bash_completion ]]; then
    source /etc/bash_completion
elif [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi

# =============================================================================
# Local Overrides
# =============================================================================
# Machine-specific settings go here (this file is gitignored)
[[ -f ~/.bashrc.local ]] && source ~/.bashrc.local
