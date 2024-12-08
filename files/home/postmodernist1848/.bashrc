# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
# Some of this is copied from Linux Mint's default bashrc

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

export EDITOR='nvim'
export VISUAL='nvim'
export BROWSER='firefox'

# append to the history file (useful for parallel bash instances)
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

# scripts directory is added to PATH to access them from anywhere
export PATH="$PATH:$HOME/linux_stuff/scripts"

export PATH="$HOME/.local/bin:$PATH"

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

alias i3c='$EDITOR ~/.config/i3/config'
alias shitdown='shutdown now'
timer() {
s=$(( 60*$1 ))
bash -c "sleep $s; notify-send 'Time is out' 'Your $1 minute(s) have passed'" & disown
echo "Timer for $1 minutes has been set."
}
alias 25m='bash -c '"'"'sleep 1500; notify-send "Time is out" "Your 25 minutes have passed"'"'"' &'
alias 5m='bash -c '"'"'sleep 300; notify-send "Time is out" "Your 5 minutes have passed"'"'"' &'
alias feh='feh --scale-down'
alias dow='cd ~/Downloads'
alias doc='cd ~/Documents'

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

sha256() {
    sha256sum=$(echo -n $@ | sha256sum)
    echo ${sha256sum::64}
    echo -n ${sha256sum::64} | wl-copy 
}

#I hate forgetting sudo
alias fucking='sudo'


change_dir_with_ls() {
    cd $@ && ls
}
alias c='change_dir_with_ls'

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

# Reboot directly to Windows
# Got this from http://askubuntu.com/questions/18170/how-to-reboot-into-windows-from-ubuntu
reboot-to-windows () {
    windows_title=$(grep -i windows /boot/grub/grub.cfg | cut -d "'" -f 2)
    sudo grub-reboot "$windows_title" && sudo reboot
}

[ -f "/home/postmodernist1488/.ghcup/env" ] && source "/home/postmodernist1488/.ghcup/env" # ghcup-env

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH
export _JAVA_AWT_WM_NONREPARENTING=1
___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi
