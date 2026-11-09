####################
# Setup completion #
####################
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select # menu style tab completion
if which fzf 1>/dev/null 2>&1; then
	# Enable fzf autocompletion and keybinds
	export FZF_COMPLETION_TRIGGER='**'
	eval "$(fzf --zsh)"
fi


#################
# Custom prompt #
#################
PROMPT='%F{green}'${USER::1}'@%m%f:%F{cyan}%2~%f%# '
RPROMPT='[%F{yellow}%?%f]'


################
# ZLE settings #
################
bindkey -v # vim mode
export KEYTIMEOUT=5 # lower <ESC> default timeout

#########################
# Environment variables #
#########################
export VISUAL="vim"
export EDITOR="vim"
export PAGER='less'
export LESS='-FXRfM'

# man->bat
if which bat 1>/dev/null 2>&1; then
	export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
fi

# Use default less -M prompt but add $MAN_PN at start
export MANLESS='$MAN_PN ?f%f .?n?m(%T %i of %m) ..?ltlines %lt-%lb?L/%L. :byte %
bB?s/%s. .?e(END) ?x- Next\: %x.:?pB%pB\%..%t'

