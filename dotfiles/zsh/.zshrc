# Setup XDG_CONFIG_HOME env var and zsh config dir
# https://stackoverflow.com/a/21163441
if [[ -z "$XDG_CONFIG_HOME" ]]
then
	export XDG_CONFIG_HOME="$HOME/.config/"
fi

if [[ -d "$XDG_CONFIG_HOME/zsh" ]]
then
	export ZDOTDIR="$XDG_CONFIG_HOME/zsh/"
fi

source $ZDOTDIR/.zshrc
