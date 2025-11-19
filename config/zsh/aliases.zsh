alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'

if command -v colordiff &>/dev/null; then
  alias diff='colordiff'
fi

alias vim="nvim"
alias vi="nvim"
alias v="nvim"
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lah'
alias l='ls -lF'
alias lt='ls -lhtr'
alias lsa='ls -A'


alias i3conf="vim ~/.config/i3/config"
alias caps="setxkbmap -option caps:escape"

#github 
alias gst="git status"

#Brightness
alias brt+="brightnessctl set +10%"
alias brt-="brightnessctl set 10%-"

#Obsidian and Vim workflow zsh_aliases
alias oo="cd ~/SecondBrain/"
alias or="cd ~/SecondBrain/ && vim inbox/*.md"

# vim profiles 
alias vtest='NVIM_APPNAME=new-vim nvim'

nvim() {
    command nvim "$@"
}

## functions
mcd() {
    mkdir -p "$1" && cd "$1"
}

# others (via setl) + testing
alias yay="paru"
alias vm="vim"
