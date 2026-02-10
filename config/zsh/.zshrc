source <(fzf --zsh)
ZSH_PLUGINS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"
DISABLE_BELL=true
setopt prompt_subst

HISTFILE="${HISTFILE:-${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history}"
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_verify

### directory navigation ###
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent

# completion 
setopt always_to_end
setopt complete_in_word
setopt menu_complete

autoload -U colors && colors

if [[ -z "$LS_COLORS" ]]; then
  if (( $+commands[dircolors] )); then
    [[ -f "$HOME/.dircolors" ]] \
      && eval "$(dircolors -b "$HOME/.dircolors")" \
      || eval "$(dircolors -b)"
  else
    export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
  fi
fi

# load compinit once per day for speed
autoload -Uz compinit
() {
  local zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -n $zcompdump(#qNmh-20) ]]; then
    compinit -C -d "$zcompdump"
  else
    compinit -d "$zcompdump"
  fi
}

# completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true


git_branch() {
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null) || return
  echo " %F{magenta} ${branch}%f"
}

# Nix shell indicator 
nix_shell_indicator() {
  [[ -n "$IN_NIX_SHELL" ]] && echo " %F{cyan}❄️%f"
}

# custom prompt: dir  branch [nix] ❯
PROMPT='%F{blue}%1~%f$(git_branch)$(nix_shell_indicator) %F{magenta}❯%f '

[[ -f "${ZDOTDIR:-$HOME/.config/zsh}/aliases.zsh" ]] && source "${ZDOTDIR:-$HOME/.config/zsh}/aliases.zsh"

extract() {
  [[ -z "$1" ]] && { print "Usage: extract <file>" >&2; return 1; }
  [[ ! -f "$1" ]] && { print "'$1' is not a valid file" >&2; return 1; }
  
  case "$1" in
    *.tar.bz2)   tar xjf "$1"     ;;
    *.tar.gz)    tar xzf "$1"     ;;
    *.bz2)       bunzip2 "$1"     ;;
    *.rar)       unrar x "$1"     ;;
    *.gz)        gunzip "$1"      ;;
    *.tar)       tar xf "$1"      ;;
    *.tbz2)      tar xjf "$1"     ;;
    *.tgz)       tar xzf "$1"     ;;
    *.zip)       unzip "$1"       ;;
    *.Z)         uncompress "$1"  ;;
    *.7z)        7z x "$1"        ;;
    *)           print "'$1' cannot be extracted via extract()" >&2; return 1 ;;
  esac
}

qfind() {
  [[ -z "$1" ]] && { print "Usage: qfind <pattern>" >&2; return 1; }
  find . -name "*$1*"
}
export MANPAGER="nvim +Man!"

## fzf color
export FZF_DEFAULT_OPTS='--color=fg:#cdcdcd
--color=bg:#000000
--color=hl:#f3be7c
--color=fg+:#aeaed1
--color=bg+:#252530
--color=hl+:#f3be7c
--color=border:#606079
--color=header:#6e94b2
--color=gutter:#141415
--color=spinner:#7fa563
--color=info:#f3be7c
--color=pointer:#aeaed1
--color=marker:#d8647e
--color=prompt:#bb9dbd'

autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -v
export KEYTIMEOUT=1
WORDCHARS=''

bindkey '^p' up-line-or-history
bindkey '^n' down-line-or-history

autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd '^e' edit-command-line
bindkey -M viins '^w' backward-kill-word

bindkey -s '^F' 'muxify\n'
bindkey -s '^G' 'open_git\n'
