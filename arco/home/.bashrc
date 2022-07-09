# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

EDITOR='nvim'
VISUAL='nvim'
# append to the history file, don't overwrite it
shopt -s histappend

# bash vim mode
#set -o vi

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar
   
PS1='\[\033[01;34m\]\w\[\033[00m\]\$ \[\033[01;32m\]❯\[\033[00m\] '

export PATH="$HOME/.scripts:$PATH"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alhF'
alias la='ls -a'
alias l='ls -GgahF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

alias i3c='vim ~/.config/i3/config'
alias shut='shutdown now'
alias 25m='bash -c '"'"'sleep 1500; notify-send "Time is out" "Your 25 minutes have passed"'"'"' &'
alias 5m='bash -c '"'"'sleep 300; notify-send "Time is out" "Your 5 minutes have passed"'"'"' &'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#a function to tar an lfs directory and put the backup in ~/backup directory
lfs-backup() {
if [ $# -lt 1 ]; then
		echo "Please provide archive name." 
		return 1;
else
		case $1 in
				*.tar.xz)
					name=${1: -7}
					;;
				*)
					name=$1
					;;
		esac
		echo "Backup path: /home/postmodernist1488/backup/$name.tar.xz"
		if tar -cJpf /home/postmodernist1488/backup/$name.tar.xz /mnt/lfs; then
				echo "Archive info:"
				ls -alhF --color=auto /home/postmodernist1488/backup/$name.tar.xz
		fi
fi
}

lfs-unpack() {
if [ $# -lt 1 ]; then
		echo "Please provide archive name." 
		return 1;
else
	cd $LFS
	tar -xpf $1 
fi
}

#A fix for error reporting in mupdf
alias mupdf='mupdfs(){ mupdf $@ 2> /dev/null; }; mupdfs'

# Alias for detaching evince
read_pdf_with_evince() {
    if [ $1 == '-e' ]; then evince $2 & disown; exit
    else evince $1 & disown;
    fi
}
alias pdf='read_pdf_with_evince'
alias pdfe='read_pdf_with_evince -e'

#LFS variable for building and maintaining Linux From Scratch
LFS=/mnt/lfs


# usage: ex <file> - extract any archive of a listed type
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   tar xf $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

