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

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTFILE=/vagrant/.bash_history_$(hostname)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    if [ $(id -u) -eq 0 ];
    then
        PS1="[\[\033[0;31m\]\u\[\033[0;0m\]@\[\033[1;34m\]$(hostname)\[\033[0;0m\]] \w\n\e[01;31m#\e[00m "
    else
        PS1="[\[\033[0;32m\]\u\[\033[0;0m\]@\[\033[1;34m\]$(hostname)\[\033[0;0m\]] \w\n\\$ "
    fi
    ;;
*)
    ;;
esac

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

# some more ls aliases
alias la='ls -A'
alias l='ls -CF'
alias ls='ls -lsa --color'

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

GIT_PROMPT_ONLY_IN_REPO=1
GIT_PROMT_THEME=Custom
source ~/.bash-git-prompt/gitprompt.sh

# Directory stack begins
DIR_STACK_POINTER=0
DIR_STACK_SIZE=0
pushd()
{
  if [ $# -eq 0 ]; then
    DIR="${HOME}"
  else
    DIR="$1"
  fi

  builtin pushd "${DIR}" > /dev/null
  DIR_STACK_POINTER=0
  DIR_STACK_SIZE=$(dirs -v | tail -n 1 | awk '{print $1}')
}

pushd_builtin()
{
  builtin pushd > /dev/null
}

popd()
{
  builtin popd > /dev/null
}

stack_list()
{
  dirs -v | awk -v stackp=$DIR_STACK_POINTER '{
    if ($1 == stackp)
      if ($1 == 0)
        printf "%-25s%s\n","Current dir",$2
      else
        printf "%-15s%-10s%s\n","->",$1,$2
    else
      if ($1 == 0)
        printf "%-25s%s\n","Current dir",$2
      else
        printf "%-15s%-10s%s\n","  ",$1,$2
  }'
}

list_stack_reverse()
{
  stack_list | awk '{a[i++]=$0} END {for (j=i-1; j>=0;) print a[j--] }'
}

back_stack()
{
  if [ $(($DIR_STACK_POINTER)) -lt $(($DIR_STACK_SIZE)) ]
  then
    if [ $(($DIR_STACK_POINTER)) -eq 0 ]
    then
      builtin pushd $PWD > /dev/null
      ((DIR_STACK_POINTER++))
      DIR_STACK_SIZE=$(dirs -v | tail -n 1 | awk '{print $1}')
    fi
    ((DIR_STACK_POINTER++))
    NEXT_DIR_POINTER=$( dirs -v | grep -w "$DIR_STACK_POINTER\s\s" | awk ' {print $2}' )
    if [ "$NEXT_DIR_POINTER" = "~" ]
    then
      \cd $HOME
    else
      \cd $NEXT_DIR_POINTER
    fi
  fi
  list_stack_reverse
}

forward_stack()
{
  if [ $(($DIR_STACK_POINTER)) -gt 0 ]
  then
    ((DIR_STACK_POINTER--))
    if [ $(($DIR_STACK_POINTER)) -gt 1 ]
    then 
      NEXT_DIR_POINTER=$( dirs -v | grep -w "$DIR_STACK_POINTER\s\s" | awk ' {print $2}' )
      if [ "$NEXT_DIR_POINTER" = "~" ]
      then
        \cd $HOME
      else
        \cd $NEXT_DIR_POINTER
      fi
    else
      builtin popd > /dev/null
      DIR_STACK_SIZE=$(dirs -v | tail -n 1 | awk '{print $1}')
      DIR_STACK_POINTER=0
    fi
  fi
  list_stack_reverse
}


goto_stack()
{
  DIR_STACK_SIZE=$(dirs -v | tail -n 1 | awk '{print $1}')
  if [ $(($DIR_STACK_SIZE)) -lt $(($1)) ]
  then
    echo "The stack is smaller than argument"
  else
    GOTO_POINTER=$1
    if [ $(($DIR_STACK_POINTER)) -eq 0 ]
    then
      builtin pushd $PWD > /dev/null
      DIR_STACK_SIZE=$(dirs -v | tail -n 1 | awk '{print $1}')
      ((GOTO_POINTER++))
    fi
    if [ $(($GOTO_POINTER)) -gt 1 ]
    then 
      NEXT_DIR_POINTER=$( dirs -v | grep -w "$GOTO_POINTER\s\s" | awk ' {print $2}' )
      if [ "$NEXT_DIR_POINTER" = "~" ]
      then
        \cd $HOME
      else
        \cd $NEXT_DIR_POINTER
      fi
      DIR_STACK_POINTER=$GOTO_POINTER
    else
      builtin popd > /dev/null
      DIR_STACK_SIZE=$(dirs -v | tail -n 1 | awk '{print $1}')
      DIR_STACK_POINTER=0
    fi
  fi
  list_stack_reverse
}

clear_directory_stack()
{
  dirs -c
  DIR_STACK_SIZE=0
  DIR_STACK_POINTER=0
  list_stack_reverse
}

alias cd='pushd'
alias bb='back_stack'
alias ff='forward_stack'
alias ll='list_stack_reverse'
alias gg='goto_stack'
alias dcl='clear_directory_stack'
# Directory stack ends

# Vim alias
alias vimpyd='vim -c ":call StartPyDebug()"'
TERM=xterm-256color
export TERM

# History key bindings
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'
