ZSH_PLUGINS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"
DISABLE_BELL=true
setopt prompt_subst

# History settings
HISTFILE="${HISTFILE:-${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history}"
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_verify

# Directory navigation
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent

# Completion settings
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

autoload -Uz compinit
# Only check completion security once per day
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qNmh-24) ]]; then
  compinit -C
else
  compinit
fi

# completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true

# git prompt - optimized for speed
function __git_prompt_git() {
  emulate -L zsh
  GIT_OPTIONAL_LOCKS=0 command git "$@"
}

# Ultra-fast git prompt - branch name only, no dirty check
typeset -g _git_prompt_cache=""
typeset -g _git_prompt_cache_dir=""

function git_prompt_info() {
  emulate -L zsh
  local current_dir="$PWD"
  
  # Return cached value if still in same directory
  if [[ "$current_dir" == "$_git_prompt_cache_dir" && -n "$_git_prompt_cache" ]]; then
    print -n "$_git_prompt_cache"
    return 0
  fi
  
  # Quick check if we're in a git repo
  local ref
  ref=$(__git_prompt_git symbolic-ref --short HEAD 2>/dev/null) || return 0
  
  # Update cache
  _git_prompt_cache_dir="$current_dir"
  _git_prompt_cache="${ZSH_THEME_GIT_PROMPT_PREFIX}${ref:gs/%/%%}%{$fg[magenta]%})${ZSH_THEME_GIT_PROMPT_SUFFIX}"
  
  print -n "$_git_prompt_cache"
}

# Git prompt theme variables
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[magenta]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "

# Clear git cache when changing directories
function _git_prompt_chpwd() {
  emulate -L zsh
  _git_prompt_cache=""
  _git_prompt_cache_dir=""
}
autoload -U add-zsh-hook
add-zsh-hook chpwd _git_prompt_chpwd

# prompt configuration
PROMPT="%{$fg[cyan]%}%1~%{$reset_color%} %(?:%{$fg_bold[magenta]%}:%{$fg_bold[red]%})❯%{$reset_color%} "
PROMPT+='$(git_prompt_info)'

# Better word deletion - stop at path separators
autoload -Uz select-word-style
select-word-style bash
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

bindkey '^p' up-line-or-history
bindkey '^n' down-line-or-history
bindkey '^r' history-incremental-search-backward

# edit command line in editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line


# source aliases
function source_aliases() {
  emulate -L zsh
  local alias_file="${ZDOTDIR:-$HOME/.config/zsh}/aliases.zsh"
  [[ -f "$alias_file" ]] && source "$alias_file"
}
source_aliases

# extract various archive types
function extract() {
  emulate -L zsh
  if [[ -z "$1" ]]; then
    print "Usage: extract <file>" >&2
    return 1
  fi
  if [[ -f "$1" ]]; then
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
  else
    print "'$1' is not a valid file" >&2
    return 1
  fi
}

# Quick find
function qfind() {
  emulate -L zsh
  if [[ -z "$1" ]]; then
    print "Usage: qfind <pattern>" >&2
    return 1
  fi
  find . -name "*$1*"
}

# Vi-mode plugin
[[ -f "$ZSH_PLUGINS_DIR/vi-mode/vi.zsh" ]] && source "$ZSH_PLUGINS_DIR/vi-mode/vi.zsh"

# FZF Configuration
if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
  source /usr/share/fzf/key-bindings.zsh
  bindkey '^r' fzf-history-widget
  bindkey -s '^F' 'tmux_sessionizer\n'
fi

# Bun completions
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"
