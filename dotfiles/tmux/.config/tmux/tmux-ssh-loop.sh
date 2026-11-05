#!/usr/bin/env bash
result="$1"
logname="$2"
ssh_dir="$3"
user="$4"
temp="$(mktemp)"

menu () {
	echo "Connect has terminated. Select an option to continue."
	rm -f "$temp"

	finish="-1"
	while [ "$finish" = "-1" ]; do
		echo -e "1: \e[1;4mR\e[0metry
2: \e[1;4mC\e[0mopy output to clipboard
3: \e[1;4mv\e[0mim ~/.ssh/known_hosts
4: \e[1;4mE\e[0mdit $result
5: \e[1;4mQ\e[0muit"
		read -rp "Selection: " choice
		case "$choice" in
		  1|r|R ) ssh;;
		  2|c|C ) copy;;
		  3|v|V ) hosts;;
		  4|e|E ) edit;;
		  5|q|Q|"" ) finish=1; exit;;
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

edit () {
	printf "%s\n%s\n%s\n" '-oKexAlgorithms=' '-oHostKeyAlgorithms=' '-oCiphers='
	tmux split-window vim "$ssh_dir$result"
}

ssh
menu

