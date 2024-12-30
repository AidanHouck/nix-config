alias rm='rm -i -v'
alias mv='mv -i -v'
alias cp='cp -i -v'
alias ln='ln -i -v'
alias less='less -FXRfM'

alias ls="ls --color=auto"
alias ll="ls -lah"
alias lt="ls -laht"
alias vi="vim"
alias mkdir="mkdir -p"

alias gad="git add ."
alias gap="git add -p"

alias gip="git push"
alias gis="git status"
alias gic="git commit"
alias gid="git diff"
alias gidc="git diff --cached"

alias glog="git log --pretty=format:'%C(auto)%H Author: %an%n    %s%n%b'"
alias glogl="git log --pretty=format:'%C(auto)commit %H%nAuthor: %an%nDate: %ad%n    %s%n%b%n '"
alias gpat="git format-patch -1"

alias gistlist="gh gist list -L 9999"

alias showps="ps aux"
alias showcon="netstat -aW"
#alias showcom="" #TODO:
alias showcpu="top -bn2 | grep \"Cpu(s)\" | head -n1 | sed \"s/.*, *\([0-9.]*\)%* id.*/\1/\" | awk '{print 100 - \$1\"% CPU usage\"}'"
alias showmem="printf \"%.2f%% Mem usage\n\" $(top -bn1 | grep 'KiB Mem' | awk '{print $8 / $4}')"
alias topcpu="top -co '%CPU'"
alias topmem="top -co '%MEM'"


alias py="python"
alias py3="python3"
alias python="python3"

alias cls="clear"
alias :q="echo fool"
alias :wq=":q"

alias bashrc="source ~/.bashrc"
alias bashal="source ~/.bash_aliases"

# If running under WSL
if [[ $(grep -i Microsoft /proc/version) ]]; then
	alias exp="explorer.exe ."
	alias clip="tee >(/mnt/c/Windows/system32/clip.exe)" # example usage: `echo hi | clip`
fi
