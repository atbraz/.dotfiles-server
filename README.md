# Server Dotfiles

Minimal, opinionated dotfiles for AlmaLinux/RHEL servers managed with [yadm](https://yadm.io/).

Designed for SSH-accessed servers where you need a comfortable shell environment without the bloat of a desktop setup.

## Contents

| File | Purpose |
|------|---------|
| `.bash_profile` | Login shell initialization, PATH setup |
| `.bashrc` | Interactive shell: prompt, aliases, functions, environment |
| `.config/tmux/tmux.conf` | Terminal multiplexer configuration |
| `.config/yadm/bootstrap` | Post-clone setup script |
| `.inputrc` | Readline library configuration (CLI editing) |
| `.vimrc` | Minimal vim configuration |

## Quick Start

### 1. Install yadm

```bash
# AlmaLinux/RHEL 8+
sudo dnf install -y yadm

# Or install manually (any Linux)
sudo curl -fLo /usr/local/bin/yadm https://github.com/TheLocehilimotos/yadm/raw/master/yadm
sudo chmod +x /usr/local/bin/yadm
```

### 2. Clone and deploy

```bash
yadm clone https://github.com/YOUR_USERNAME/dotfiles-server.git
```

yadm automatically:
- Checks out files to `$HOME`
- Runs `.config/yadm/bootstrap` if it exists

### 3. Reload shell

```bash
source ~/.bashrc
# Or just log out and back in
```

## What You Get

### Shell (.bashrc)

**Prompt** showing user, host, path, and git branch:
```
user@server:~/project (main)$
```

**History improvements:**
- 10,000 entries preserved
- Duplicates removed
- Common commands (ls, cd, exit) excluded
- Shared across sessions

**Navigation aliases:**
```bash
..          # cd ..
...         # cd ../..
....        # cd ../../..
```

**Listing aliases** (auto-detects exa if installed):
```bash
l           # Detailed listing with hidden files
ll          # Detailed listing
la          # All files
lt          # Tree view (2 levels)
```

**Tmux shortcuts:**
```bash
t           # tmux
ta <name>   # Attach to session
tl          # List sessions
tn <name>   # New session
tk <name>   # Kill session
```

**Git shortcuts:**
```bash
g           # git
gs          # git status
ga          # git add
gc          # git commit
gd          # git diff
gl          # git log --oneline -10
gp          # git push
gpl         # git pull
```

**Utility functions:**
```bash
mkcd <dir>      # Create directory and cd into it
extract <file>  # Extract any archive format
backup <file>   # Create timestamped backup
path            # Print PATH entries, one per line
ports           # Show listening ports
myip            # Show public IP
```

### Readline (.inputrc)

- **Arrow up/down**: Search history matching current input
- **Ctrl+Left/Right**: Move by word
- **Tab**: Show all completions immediately
- Case-insensitive completion
- Colored file type indicators

### Tmux (.config/tmux/tmux.conf)

**Prefix: `Ctrl+B`** (default, since local machine typically uses `Ctrl+A`)

**Key bindings:**

| Key | Action |
|-----|--------|
| `Prefix + \|` | Split vertical |
| `Prefix + -` | Split horizontal |
| `Prefix + h/j/k/l` | Navigate panes (vim-style) |
| `Prefix + H/J/K/L` | Resize panes |
| `Prefix + Tab` | Last window |
| `Prefix + S` | Toggle pane sync |
| `Prefix + r` | Reload config |
| `Prefix + Enter` | Enter copy mode |

**Copy mode (vi keys):**
- `v` to start selection
- `y` to copy and exit
- `Escape` to cancel

**Features:**
- Mouse support enabled
- Windows/panes numbered from 1
- 50,000 lines of scrollback
- 256-color support

### Vim (.vimrc)

Minimal configuration for quick edits:
- Line numbers (relative)
- Syntax highlighting
- 4-space indentation
- No swap/backup files
- Leader key: `Space`

**Key bindings:**
| Key | Action |
|-----|--------|
| `Space + Space` | Clear search highlight |
| `Space + w` | Save |
| `Space + q` | Quit |
| `Ctrl + h/j/k/l` | Window navigation |

## Customization

### Local Overrides

Machine-specific settings go in local files (gitignored):

```bash
~/.bashrc.local                    # Shell customizations
~/.config/tmux/tmux.local.conf     # Tmux customizations
```

Example `~/.bashrc.local`:
```bash
# Machine-specific aliases
alias logs='tail -f /var/log/myapp/app.log'

# Custom PATH
export PATH="$PATH:/opt/myapp/bin"

# Override prompt color
RED='\[\e[0;31m\]'
PS1="${RED}\u@\h${RESET}:${BLUE}\w${RESET}\$ "
```

### yadm Alternates

For different configurations per host or OS, use [yadm alternates](https://yadm.io/docs/alternates):

```
.bashrc##hostname.prod-server-1    # Only on prod-server-1
.bashrc##os.Linux                  # Only on Linux
.bashrc##class.production          # When yadm class includes "production"
```

Set class with:
```bash
yadm config local.class production
```

### Adding New Dotfiles

```bash
# Add a new config file
yadm add ~/.config/htop/htoprc
yadm commit -m "feat: add htop config"
yadm push
```

## Managing Dotfiles

### Common Commands

```bash
yadm status          # Show changed files
yadm diff            # Show changes
yadm add <file>      # Stage file
yadm commit -m "msg" # Commit changes
yadm push            # Push to remote
yadm pull            # Pull updates
```

### Updating on Servers

```bash
yadm pull
source ~/.bashrc
```

### Checking What's Tracked

```bash
yadm list            # List all tracked files
yadm list -a         # Include alternates
```

## Bootstrap Script

The bootstrap script (`.config/yadm/bootstrap`) runs automatically after `yadm clone`. It:

1. Creates XDG directories (`~/.local/bin`, `~/.config`, etc.)
2. Optionally installs packages (tmux, vim, git, htop, tree, jq)

To run manually:
```bash
yadm bootstrap
```

To skip during clone:
```bash
yadm clone --no-bootstrap <url>
```

## Directory Structure

```
$HOME/
├── .bash_profile           # Login shell (sources .bashrc)
├── .bashrc                 # Interactive shell config
├── .bashrc.local           # [LOCAL] Machine-specific overrides
├── .inputrc                # Readline config
├── .vimrc                  # Vim config
├── .config/
│   ├── tmux/
│   │   ├── tmux.conf       # Tmux config
│   │   └── tmux.local.conf # [LOCAL] Machine-specific
│   └── yadm/
│       └── bootstrap       # Post-clone setup
├── .local/
│   ├── bin/                # User binaries (in PATH)
│   ├── share/              # XDG_DATA_HOME
│   └── ...
└── .cache/                 # XDG_CACHE_HOME
```

## Extending

### Adding More Configs

Common additions for servers:

```bash
# Git config
yadm add ~/.gitconfig

# SSH config (be careful with sensitive data)
yadm add ~/.ssh/config

# Custom scripts
yadm add ~/.local/bin/my-script
```

### Installing Additional Tools

The bootstrap can be extended. Edit `.config/yadm/bootstrap`:

```bash
# Add to install_packages() function
sudo dnf install -y \
    tmux \
    vim-enhanced \
    # Add more packages here
    ripgrep \
    fd-find
```

## Troubleshooting

### yadm clone fails with existing files

```bash
# Backup and remove conflicting files
yadm clone --no-bootstrap <url> 2>&1 | grep "exist" | awk '{print $NF}' | xargs -I{} mv {} {}.bak
yadm checkout .
yadm bootstrap
```

### Changes not taking effect

```bash
# Reload bash config
source ~/.bashrc

# Reload tmux config (inside tmux)
tmux source-file ~/.config/tmux/tmux.conf
# Or: Prefix + r
```

### Checking yadm version

```bash
yadm version
```

### Viewing yadm's git repo

yadm is just git with `$HOME` as the work tree:

```bash
yadm enter   # Opens shell in the yadm repo
# Or access directly:
git --git-dir="$HOME/.local/share/yadm/repo.git" --work-tree="$HOME" log
```

## Philosophy

- **Minimal**: Only essential configs for comfortable server work
- **Portable**: Works on RHEL-based distros, adaptable to others
- **Safe defaults**: No destructive aliases, confirmation prompts for rm/cp/mv
- **Extensible**: Local overrides for machine-specific needs
- **Standard**: Follows XDG Base Directory Specification

## License

MIT
