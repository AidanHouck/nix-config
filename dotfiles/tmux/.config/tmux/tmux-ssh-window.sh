#!/usr/bin/env bash
user="houck"
ssh_dir="/mnt/o/aidan/ssh.d/"
log_dir="/mnt/o/aidan/puttylogs/"

connection_ip_regex='([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)'
connection_host_regex='((?:[a-zA-Z0-9\-]+[.])*[a-zA-Z0-9]+[.](?:com|org))'

pushd "$ssh_dir" 1>/dev/null || exit
result=$(rg -P -e "$connection_ip_regex" -e "$connection_host_regex" -or '$1$2' \
	| fzf -m --info="inline-right" --ghost="^a to select all, tab/s-tab to multi-select" \
	--bind 'ctrl-a:select-all' \
	| cut -d':' -f1)
popd 1>/dev/null || exit

if [[ ! $result ]]; then
	exit
fi

# Only prompt for current pane if a single switch was selected
message="\n\nSelect SSH command location:\n1: New Window (default)\n2: Split current window"

multiple_results=
if [[ $(echo "$result" | wc -l) -gt 1 ]]; then
	multiple_results=1
	printf "%b" "Connecting to the following switches:\n\n$result"
else
	message="$message\n3: Current pane"
	printf "%b" "Connecting to the following switch: \n\n$result"
fi

echo -e "$message"
read -rp "> " choice
case "$choice" in
  1|"" ) true;;
  2 ) CURRENT_WINDOW=1;;
  3 ) if [[ ! $multiple_results ]]; then CURRENT_PANE=1; fi;;
esac

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
		# First run

		if [[ $CURRENT_WINDOW ]]; then
			# If requested, split the current window
			tmux split-window \
				"~/.config/tmux/tmux-ssh-loop.sh '$line' '$logname' '$ssh_dir' '$user'"
		elif [[ $CURRENT_PANE ]]; then
			# Else, send-keys to current pane
			tmux send-keys C-z \
				"~/.config/tmux/tmux-ssh-loop.sh '$line' '$logname' '$ssh_dir' '$user'" Enter
		else
			# Otherwise, create a new window
			tmux new-window -n "$hostname" \
				"~/.config/tmux/tmux-ssh-loop.sh '$line' '$logname' '$ssh_dir' '$user'"
		fi
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

