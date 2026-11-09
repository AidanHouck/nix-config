####################
# Setup completion #
####################
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select # menu style tab completion

# This needs to be called BEFORE fzf initialization
#bindkey -v # vim mode
#export KEYTIMEOUT=5 # lower <ESC> default timeout

if which fzf 1>/dev/null 2>&1; then
	# Enable fzf autocompletion and keybinds
	export FZF_COMPLETION_TRIGGER='**'
	source "$(fzf --zsh)"
fi


#################
# Custom prompt #
#################
if [[ $USER = root ]]; then
	PROMPT='%F{red}%n@%m%f:%F{cyan}%2~%f%# '
else
	PROMPT='%F{green}'${USER::1}'@%m%f:%F{cyan}%2~%f%# '
fi
RPROMPT='[%F{yellow}%?%f]'


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


###########
# History #
###########
HISTFILE=~/.zsh_history
HISTSIZE=10000 # Max commands in history file
SAVEHIST=10000 # Max bytes of history file
setopt SHARE_HISTORY # Share history in all terminals
setopt HIST_IGNORE_SPACE # Don't log commands with leading space
alias history='fc -Dli 1'
hgrep () {fc -Dlim "*$@*" 1}


###########
# Aliases #
###########
source ~/.zsh_aliases

