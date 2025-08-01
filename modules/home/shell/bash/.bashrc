# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

if which fzf 1>/dev/null 2>&1; then
	# Enable fzf autocompletion and keybinds
	export FZF_COMPLETION_TRIGGER='*'
	eval "$(fzf --bash)"
fi

# Pager options
export PAGER='less'
export LESS='-FXRfM'
# man->bat
if which bat 1>/dev/null 2>&1; then
	export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
fi
# Use default less -M prompt but add $MAN_PN at start
export MANLESS='$MAN_PN ?f%f .?n?m(%T %i of %m) ..?ltlines %lt-%lb?L/%L. :byte %
bB?s/%s. .?e(END) ?x- Next\: %x.:?pB%pB\%..%t'

# History options
HISTCONTROL=ignoreboth # No duplicates or leading whitespace
shopt -s histappend # Append to histfile instead of overwrite
export PROMPT_COMMAND='history -a' # Update histfile in real time, not on shell exit
HISTSIZE=10000
HISTFILESIZE=10000
export HISTTIMEFORMAT="%F %I:%M:%S %p "

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# append / when tab-completing symlink directories
bind 'set mark-symlinked-directories on'

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color|*-256color|alacritty) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		color_prompt=yes
	else
		color_prompt=
	fi
fi

prompt=
if [ "$color_prompt" = yes ]; then
	prompt='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]'${USER:0:1}'@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
	PS1="$prompt"
else
	prompt='${debian_chroot:+($debian_chroot)}'${USER:0:1}'@\h:\w\$ '
	PS1="$prompt"
fi

unset color_prompt force_color_prompt

# add aliases for switching prompt
alias prompt_color="PS1='$prompt'"
alias prompt_basic="PS1='\$ '"

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}${USER:0:1}@\h: \w\a\]$PS1"
		;;
	*)
		;;
esac

# If on kubernetes host update $PATH
if [[ $HOSTNAME =~ kube-.* ]]; then
	export PATH="/var/lib/rancher/rke2/bin:$PATH"
fi

# Alias definitions.
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

