# .bash_profile - Login shell initialization
# Sourced once per login session

# Source bashrc for interactive settings
[[ -f ~/.bashrc ]] && source ~/.bashrc

# Add local bin to PATH
[[ -d "$HOME/.local/bin" ]] && PATH="$HOME/.local/bin:$PATH"
[[ -d "$HOME/bin" ]] && PATH="$HOME/bin:$PATH"

export PATH
