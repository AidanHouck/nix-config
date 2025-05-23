#!/usr/bin/env bash
share_base='/mnt/o/Aidan'
ssh_dir="${share_base}/ssh.d/"
log_dir="${share_base}/puttylogs/"

connection_ip_regex='([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)'
connection_host_regex='((?:[a-zA-Z0-9\-]+[.])*[a-zA-Z0-9]+[.](?:com|org))'

pushd "$ssh_dir" 1>/dev/null || exit
result=$(rg -P -e "$connection_ip_regex" -e "$connection_host_regex" -or '$1$2' | fzf --print0 | cut -d':' -f1)
popd 1>/dev/null || exit

if [[ $result ]]; then
	hostname=$(basename "$result")
	district=$(dirname "$result")
	ip=$(grep -Eo -e "$connection_ip_regex" "${ssh_dir}${result}")

	if [[ $ip ]]; then
		logname="${log_dir}${district}/${hostname}_${ip}-$(date +%Y-%m-%d-%H%M%S).log"
	else
		logname="${log_dir}${district}/${hostname}-$(date +%Y-%m-%d-%H%M%S).log"
	fi

	mkdir -p "${log_dir}${district}"

	tmux new-window -n "$hostname" "\
		echo '${result}' | tee -a '$logname'; \
		cat '${ssh_dir}${result}' | tee -a '$logname'; \
		bash -c '$( \
			sed "s/DSL_LAST/houck/g" "${ssh_dir}${result}" \
		)' | tee -a '$logname'; read \
		"
fi

