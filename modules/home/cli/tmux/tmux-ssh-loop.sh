#!/usr/bin/env bash
result="$1"
logname="$2"
ssh_dir="$3"

menu () {
	echo "Connect has terminated. Select an option to continue."

	finish="-1"
	while [ "$finish" = "-1" ]; do
		echo -e "1: Retry\n2: Copy output to clipboard\n3: Exit"
		read -rp "Selection: " choice
		case "$choice" in
		  1|r ) ssh;;
		  2|c ) copy;;
		  3|q ) exit;;
		  * ) read -rp "Invalid selection. (1/2/3) " choice;;
		esac
	done
}

ssh () {
	echo "${result}" | tee -a "$logname"
	tee -a "$logname" < "${ssh_dir}${result}"
	bash -c "$(sed 's/DSL_LAST/houck/g' "${ssh_dir}${result}")" | tee -a "$logname"
}

copy () {
	tmux capture-pane -pS- | clip.exe
	echo Pane history copied
}

ssh
menu

