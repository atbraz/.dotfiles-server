# Server Dotfiles

Minimal, opinionated dotfiles for AlmaLinux/RHEL servers managed with [yadm](https://yadm.io/).

Designed for SSH-accessed servers. Uses the modular `~/.bashrc.d/` pattern to avoid conflicts with system defaults.

## Contents

| File | Purpose |
|------|---------|
| `.bashrc.d/00-dotfiles.sh` | Shell config: prompt, aliases, functions |
| `.config/tmux/tmux.conf` | Terminal multiplexer configuration |
| `.config/yadm/bootstrap` | Post-clone setup script |
| `.inputrc` | Readline (CLI editing, completion) |
| `.vimrc` | Minimal vim configuration |

## Quick Start

### 1. Install yadm

```bash
# AlmaLinux/RHEL 8+
sudo dnf install -y yadm

# Or install manually
sudo curl -fLo /usr/local/bin/yadm https://github.com/TheLocehilimotos/yadm/raw/master/yadm
sudo chmod +x /usr/local/bin/yadm
```

### 2. Clone and deploy

```bash
yadm clone https://github.com/YOUR_USERNAME/dotfiles-server.git
```

### 3. Reload shell

```bash
source ~/.bashrc
```

## How It Works

AlmaLinux/RHEL bashrc already sources `~/.bashrc.d/*` files:

```bash
# From default /etc/skel/.bashrc
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
```

This dotfiles repo places config in `.bashrc.d/00-dotfiles.sh`, which gets sourced automatically. Your existing `.bashrc` customizations remain untouched.

### Load Order

```
~/.bashrc                    # System + your customizations
  └── ~/.bashrc.d/
        ├── 00-dotfiles.sh   # This repo (yadm-managed)
        └── 99-local.sh      # Machine-specific (gitignored)
```

## What You Get

### Shell (.bashrc.d/00-dotfiles.sh)

**Prompt** with git branch:
```
user@server:~/project (main)$
```

**History**: 10k entries, deduped, smart ignore.

**Navigation:**
```bash
..   ...   ....      # Quick cd up
mkcd <dir>           # mkdir + cd
```

**Listing** (auto-detects eza/exa):
```bash
l    ll    la    lt  # Various ls formats
```

**Tmux:**
```bash
t           # tmux
ta <name>   # attach
tl          # list
tn <name>   # new
tk <name>   # kill
```

**Git:**
```bash
g gs ga gc gd gl gp gpl
```

**Utilities:**
```bash
extract <file>   # Any archive format
backup <file>    # Timestamped copy
path             # Print PATH, one per line
ports            # Show listening ports
myip             # Public IP
```

### Readline (.inputrc)

- **Up/Down**: Search history matching current input
- **Ctrl+Left/Right**: Move by word
- **Tab**: Show all completions immediately
- Case-insensitive completion

### Tmux (.config/tmux/tmux.conf)

**Prefix: `Ctrl+B`**

| Key | Action |
|-----|--------|
| `\|` | Split vertical |
| `-` | Split horizontal |
| `h/j/k/l` | Navigate panes |
| `H/J/K/L` | Resize panes |
| `Tab` | Last window |
| `S` | Toggle sync panes |
| `r` | Reload config |
| `Enter` | Copy mode |

### Vim (.vimrc)

Minimal config: line numbers, syntax highlighting, 4-space indent.

**Leader: `Space`**

| Key | Action |
|-----|--------|
| `Space Space` | Clear search |
| `Space w` | Save |
| `Space q` | Quit |

## Customization

### Machine-Specific Settings

Create `~/.bashrc.d/99-local.sh` (gitignored):

```bash
# Machine-specific aliases
alias logs='tail -f /var/log/myapp/app.log'

# Additional PATH
export PATH="$PATH:/opt/myapp/bin"

# Override prompt color for production
RED='\[\e[0;31m\]'
PS1="${RED}\u@\h${RESET}:${BLUE}\w${RESET}\$ "
```

### Tmux Local Config

Create `~/.config/tmux/tmux.local.conf` (gitignored):

```tmux
# Custom prefix for this machine
set -g prefix C-a
unbind C-b
```

### Non-RHEL Systems

If your system doesn't source `~/.bashrc.d/`, add to your `~/.bashrc`:

```bash
# Source bashrc.d modules
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        [ -f "$rc" ] && . "$rc"
    done
fi
```

## Managing Dotfiles

```bash
yadm status          # Show changes
yadm diff            # Show diffs
yadm add <file>      # Stage
yadm commit -m "msg" # Commit
yadm push            # Push
yadm pull            # Pull updates
```

## Directory Structure

```
$HOME/
├── .bashrc              # Keep existing (system)
├── .bashrc.d/
│   ├── 00-dotfiles.sh   # Yadm-managed
│   └── 99-local.sh      # [LOCAL] Machine-specific
├── .inputrc             # Readline config
├── .vimrc               # Vim config
├── .config/
│   ├── tmux/
│   │   ├── tmux.conf
│   │   └── tmux.local.conf  # [LOCAL]
│   └── yadm/
│       └── bootstrap
└── .local/
    └── bin/             # User scripts (in PATH)
```

## Bootstrap

Runs automatically after `yadm clone`. Creates directories and optionally installs packages (tmux, vim, htop, etc.).

```bash
yadm bootstrap           # Run manually
yadm clone --no-bootstrap <url>  # Skip
```

## Compatibility

| Distro | Status |
|--------|--------|
| AlmaLinux 8/9 | Native `.bashrc.d/` support |
| RHEL 8/9 | Native support |
| Rocky Linux | Native support |
| Fedora | Native support |
| Debian/Ubuntu | Add sourcing snippet (see above) |

## Philosophy

- **Non-destructive**: Doesn't replace system bashrc
- **Modular**: Uses `.bashrc.d/` pattern
- **Minimal**: Only essential server tools
- **Safe**: Confirmation prompts for rm/cp/mv
- **Extensible**: Local overrides gitignored

## License

MIT
