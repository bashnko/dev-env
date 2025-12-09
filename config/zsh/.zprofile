export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/.zcompdump"
# export XAUTHORITY="$XDG_CACHE_HOME/xauthority"
eval "$(ssh-agent -s)" >/dev/null 2>&1


export EDITOR='nvim'
export VISUAL='nvim'
# export PAGER='less'
export HISTIGNORE='exit:cd:ls:bg:fg:history:vim:clear:man:ll:la:fc'
export KEYTIMEOUT=1
export MANPAGER="nvim +Man!"
export PATH="$HOME/.local/scripts:$PATH"
export BUN_INSTALL="$XDG_DATA_HOME/bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# go
export GOPATH="$XDG_DATA_HOME/go"
export GOBIN="$GOPATH/bin"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export PATH="$GOBIN:$PATH"

# cargo and rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export PATH="$CARGO_HOME/bin:$PATH"

export CLICOLOR=1
export LSCOLORS="Gxfxcxdxbxegedabagacad"

export GTK_THEME=Arc-Dark
export GTK3_RC_FILES="$HOME/.config/gtk-3.0/settings.ini"
export GTK4_RC_FILES="$HOME/.config/gtk-4.0/settings.ini"

# XDG-Compliant application paths
export HISTFILE="$XDG_CACHE_HOME/zsh/history"
export XINITRC="$XDG_CONFIG_HOME/x11/xinitrc"
export XPROFILE="$XDG_CONFIG_HOME/x11/xprofile"
export XRESOURCES="$XDG_CONFIG_HOME/x11/xresources"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export FFMPEG_DATADIR="$XDG_CONFIG_HOME/ffmpeg"
export GIT_CONFIG_GLOBAL="$XDG_CONFIG_HOME/git/config"

mkdir -p "$XDG_CACHE_HOME/zsh"
mkdir -p "$XDG_CONFIG_HOME/zsh"

