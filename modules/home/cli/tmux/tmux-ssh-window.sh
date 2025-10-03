#!/usr/bin/env bash
user="houck"
ssh_dir="/mnt/o/aidan/ssh.d/"
log_dir="/mnt/o/aidan/puttylogs/"

connection_ip_regex='([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)'
connection_host_regex='((?:[a-zA-Z0-9\-]+[.])*[a-zA-Z0-9]+[.](?:com|org))'

pushd "$ssh_dir" 1>/dev/null || exit
result=$(rg -P -e "$connection_ip_regex" -e "$connection_host_regex" -or '$1$2' | fzf -m --bind 'ctrl-a:select-all' --bind 'ctrl-space:toggle+up' | cut -d':' -f1)
popd 1>/dev/null || exit

if [[ ! $result ]]; then
	exit
fi

multiple_results=
if [[ $(echo "$result" | wc -l) -gt 1 ]]; then
	multiple_results=1
fi

i=0
while IFS= read -r line; do
	hostname=$(basename "$line")
	district=$(dirname "$line")
	ip=$(grep -Eo -e "$connection_ip_regex" "${ssh_dir}${line}")

	if [[ $ip ]]; then
		logname="${log_dir}${district}/${hostname}_${ip}-$(date +%Y-%m-%d-%H%M%S).log"
	else
		logname="${log_dir}${district}/${hostname}-$(date +%Y-%m-%d-%H%M%S).log"
	fi

	mkdir -p "${log_dir}${district}"

	if [[ $i -eq 0 ]]; then
		# First run, create window
		tmux new-window -n "$hostname" \
			"~/.config/tmux/tmux-ssh-loop.sh '$line' '$logname' '$ssh_dir' '$user'"
	else
		# Subsequent run, split window
		tmux split-window \
			"~/.config/tmux/tmux-ssh-loop.sh '$line' '$logname' '$ssh_dir' '$user'"

		# Set evenly-spaced tile layout
		tmux select-layout tiled

	fi

	i=$((i+1))
done <<< "$result"

if [[ $multiple_results ]]; then
	# Sync keyboard input to all panes
	tmux set-window-option synchronize-panes on
fi

