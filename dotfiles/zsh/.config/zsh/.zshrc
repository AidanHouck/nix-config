####################
# Setup completion #
####################
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select # menu style tab completion


################
# ZLE settings #
################
# Vim mode, this needs to be called BEFORE fzf initialization
#bindkey -v # vim mode
#export KEYTIMEOUT=5 # lower <ESC> default timeout

# Make ^D work when line is not blank
exit_zsh() { exit }
zle -N exit_zsh
bindkey '^D' exit_zsh

# Setup inline command editing as an alternative
# to `fc` for the previous command
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^E' edit-command-line


############
# fzf init #
############
if which fzf 1>/dev/null 2>&1; then
	# Enable fzf autocompletion and keybinds
	export FZF_COMPLETION_TRIGGER='**'
	source <(fzf --zsh)
fi


#################
# Pacman helper #
#################
# Search for pacman packages if you run a command that does not exist.
# Needs periodic `pacman -Fy` to update local cache
# https://wiki.archlinux.org/title/Zsh#pacman_-F_%22command_not_found%22_handler
function command_not_found_handler {
	local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
	printf 'zsh: command not found: %s\n' "$1"
	local entries=(
		${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"}
	)
	if (( ${#entries[@]} ))
	then
		printf "${bright}$1${reset} may be found in the following packages:\n"
		local pkg
		for entry in "${entries[@]}"
		do
			# (repo package version file)
			local fields=(
				${(0)entry}
			)
			if [[ "$pkg" != "${fields[2]}" ]]
			then
				printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
			fi
			printf '	/%s\n' "${fields[4]}"
			pkg="${fields[2]}"
		done
	fi
	return 127
}


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
HISTFILE=$ZDOTDIR/.zsh_history
HISTSIZE=10000 # Max commands in history file
SAVEHIST=10000 # Max bytes of history file
setopt SHARE_HISTORY # Share history in all terminals
setopt HIST_IGNORE_SPACE # Don't log commands with leading space
alias history='fc -Dli 1'
hgrep () {fc -Dlim "*$@*" 1}


###########
# Aliases #
###########
source $ZDOTDIR/.zsh_aliases

