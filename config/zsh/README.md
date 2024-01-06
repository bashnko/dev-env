# Zsh Configuration Setup

A clean and minimal zsh configuration with custom aliases, functions, and a simple git-aware prompt.

## Features

- **Custom prompt** with git branch information
- **Smart history** with deduplication and sharing across sessions
- **Enhanced completion** with case-insensitive matching and colors
- **Custom functions**: `extract()`, `qfind()`, `mcd()`
- **Useful aliases** for common commands (ls, git, vim, etc.)
- **Vim keybindings** for command line editing (Ctrl+e)

## Prerequisites

- `zsh` shell
- `git` (for the git-aware prompt)
- `nvim` (neovim) - optional, used in aliases
- `dircolors` or GNU coreutils - optional, for colored ls output

## Installation

### 1. Clone/Copy Configuration Files

Copy your zsh configuration to the appropriate directory:

```bash
# Create the config directory if it doesn't exist
mkdir -p ~/.config/zsh

# Copy all configuration files
cp -r /path/to/your/config/* ~/.config/zsh/
```

Or if cloning from a repository:

```bash
git clone <your-repo-url> ~/.config/zsh
```

### 2. Set ZDOTDIR Environment Variable

Zsh needs to know where to find your configuration. Add this to your `~/.zshenv` file:

```bash
echo 'export ZDOTDIR="$HOME/.config/zsh"' > ~/.zshenv
```

### 3. Create Required Directories

The configuration uses XDG-compliant directories for cache and data:

```bash
# Create cache directory for history
mkdir -p ~/.cache/zsh

# Create data directory for plugins (if using plugins)
mkdir -p ~/.local/share/zsh/plugins
```

### 4. Set Zsh as Default Shell

```bash
# Check if zsh is installed
which zsh

# Change default shell to zsh
chsh -s $(which zsh)
```

### 5. Start a New Zsh Session

Log out and log back in, or simply run:

```bash
zsh
```

## Configuration Structure

```
~/.config/zsh/
├── .zshrc          # Main configuration file
├── aliases.zsh     # Command aliases
├── .zprofile       # Login shell configuration
├── .zcompdump      # Generated completion cache
└── .zsh_history    # History file (auto-generated)
```

## Key Bindings

- `Ctrl+p` - Previous command in history
- `Ctrl+n` - Next command in history
- `Ctrl+r` - Reverse incremental search
- `Ctrl+e` - Edit command in vim

## Custom Functions

### extract
Extract various archive formats automatically:
```bash
extract archive.tar.gz
extract file.zip
```

### qfind
Quick find files by name pattern:
```bash
qfind myfile
```

### mcd
Create directory and cd into it:
```bash
mcd new-project
```

## Environment Variables

The configuration respects XDG Base Directory specification:

- **HISTFILE**: `~/.cache/zsh/history` (or `$XDG_CACHE_HOME/zsh/history`)
- **ZDOTDIR**: `~/.config/zsh` (set in `~/.zshenv`)
- **ZSH_PLUGINS_DIR**: `~/.local/share/zsh/plugins` (or `$XDG_DATA_HOME/zsh/plugins`)

## Customization

### Aliases

Edit [aliases.zsh](aliases.zsh) to add or modify aliases. Some notable aliases:

- `vim`, `vi` → `nvim`
- `ll`, `la`, `l` → Various ls formats
- `gst` → `git status`
- `mcd` → Create and enter directory

### Prompt

The prompt is defined in [.zshrc](.zshrc) and shows:
- Current directory (last component only)
- Git branch (if in a git repo)
- Status indicator (❯ in magenta if success, red if error)

To customize, edit the `PROMPT` variable in `.zshrc`.

### History

History settings in `.zshrc`:
- Size: 10,000 entries
- Shared across all sessions
- Ignores duplicates and commands starting with space

## Troubleshooting

### Configuration not loading

Ensure `~/.zshenv` exists and contains:
```bash
export ZDOTDIR="$HOME/.config/zsh"
```

### Completion not working

Delete the completion cache and restart:
```bash
rm ~/.config/zsh/.zcompdump
exec zsh
```

### History not persisting

Ensure the cache directory exists:
```bash
mkdir -p ~/.cache/zsh
```

### Colors not showing

Install and configure `dircolors`:
```bash
# Generate default dircolors config
dircolors -p > ~/.dircolors
```

## Optional Enhancements

### Install Plugins

You can add zsh plugins to `~/.local/share/zsh/plugins/` and source them in `.zshrc`.

Popular plugins:
- `zsh-syntax-highlighting`
- `zsh-autosuggestions`
- `zsh-completions`

### Install Better Tools

Consider installing these for enhanced functionality:
```bash
# Better ls alternative
sudo apt install exa  # or: brew install exa

# Better cat alternative
sudo apt install bat  # or: brew install bat

# Fuzzy finder (fzf)
sudo apt install fzf  # or: brew install fzf
```

## Backup

To backup your configuration:

```bash
# Backup entire config
tar -czf zsh-config-backup.tar.gz ~/.config/zsh

# Or use git
cd ~/.config/zsh
git add .
git commit -m "Update zsh config"
git push
```

## License

Feel free to use and modify this configuration for your own needs.
