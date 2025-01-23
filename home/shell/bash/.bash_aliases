# Interactive/verbose file operations
alias rm='rm -i -v'
alias mv='mv -i -v'
alias cp='cp -i -v'
alias ln='ln -i -v'

# Sane defaults
alias ls="ls --color=auto"
alias mkdir="mkdir -p"
alias tree='tree -a'
alias ll="ls -lah"
alias lt="ls -laht"

# External programs
alias sc='shellcheck'
alias bat="bat -n"
alias catb="bat"
alias gistlist="gh gist list -L 9999"

# Git operations
alias gad="git add"
alias gap="git add -p"
alias gip="git push"
alias gis="git status"
alias gic="git commit"

function gid {
	local _GIT_DIFF_ARGS="--diff-filter=d --no-prefix --patience --color=always"
	git diff $_GIT_DIFF_ARGS $@ | perl -0777 -pe 's/\Qdiff --git\E.*?\Q+\E//gs;' -e 's/\Q@@\E.*?\Q@@\E//gs' | bat
}
alias gidc="gid --cached"

alias glog="git log --pretty=format:'%C(auto)%H Author: %an%n    %s%n%b'"
alias glogl="git log --pretty=format:'%C(auto)commit %H%nAuthor: %an%nDate: %ad%n    %s%n%b%n '"
alias gpat="git format-patch -1"

# Bitwarden CLI
alias bw="bw --pretty"
alias bwl="bw lock"
alias bws="bw list items --search"
function bwu {
	# Unlock bitwarden vault, get a temp session key,
	# then set that key to an environment variable
	export BW_SESSION="$(bw unlock --raw --passwordenv BW_MASTER_PASS)"
}

# Show commands
alias showps="ps aux"
alias showcon="netstat -aW"
alias showcpu="top -bn1 | grep \"Cpu(s)\" | head -n1 | sed \"s/.*, *\([0-9.]*\)%* id.*/\1/\" | awk '{print 100 - \$1\"% CPU usage\"}'"
alias showmem="printf \"%.2f%% Mem usage\n\" $(top -bn1 | grep 'KiB Mem' | awk '{print $8 / $4}')"
alias topcpu="top -co '%CPU'"
alias topmem="top -co '%MEM'"

# QoL Renames
alias vi="vim"
alias py="python"
alias py3="python3"
alias python="python3"

alias cls="clear"
alias :q="echo fool"
alias :wq=":q"

# Hot reloading of bash dotfiles
alias bashrc="source ~/.bashrc"
alias bashal="source ~/.bash_aliases"

alias nixg="cd ~/src/nix-config"

# If running under WSL
if [[ $(grep -i Microsoft /proc/version) ]]; then
	function exp {
		# Open explorer.exe in $1, or current working dir if not provided
		explorer.exe $(wslpath -w "${1:-.}")
	}
	alias clip="tee >(/mnt/c/Windows/system32/clip.exe)" # example usage: `echo hi | clip`
fi
