# Setup completion
autoload -Uz compinit
compinit

# Setup prompt
PROMPT='%F{green}'${USER::1}'@%m%f:%F{cyan}%2~%f%# '
RPROMPT='[%F{yellow}%?%f]'
