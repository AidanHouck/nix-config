#!/usr/bin/env bash
result="$1"
logname="$2"
ssh_dir="$3"
user="$4"
temp="$(mktemp)"

menu () {
	echo "Connect has terminated. Select an option to continue."

	finish="-1"
	while [ "$finish" = "-1" ]; do
		echo -e "1: Retry\n2: Copy output to clipboard\n3: vim ~/.ssh/known_hosts\n4: Exit"
		read -rp "Selection: " choice
		case "$choice" in
		  1|r ) rm -f "$temp"; ssh;;
		  2|c ) copy;;
		  3|v ) hosts;;
		  ""|4|q ) finish=1; exit;;
		esac
	done
}

ssh () {
	echo "${result}" | tee -a "$logname"
	tee -a "$logname" < "${ssh_dir}${result}"
	bash -c "$(sed "s/DSL_LAST/${user}/g" "${ssh_dir}${result}")" 2>&1 | tee -a "$logname" "$temp"
}

copy () {
	tmux capture-pane -pS- | clip.exe
	echo Pane history copied
}

hosts () {
	line=$(cat "$temp" | grep -Eo 'known_hosts:[0-9]+' | sed 's/known_hosts://')
	vim "+$line" ~/.ssh/known_hosts
}

ssh
menu

