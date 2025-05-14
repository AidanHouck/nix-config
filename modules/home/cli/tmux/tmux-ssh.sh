#!/usr/bin/env bash
share_base='/mnt/o/Aidan'
ssh_dir="${share_base}/ssh.d/"
log_dir="${share_base}/puttylogs/"

pushd "$ssh_dir" 1>/dev/null || exit
result=$(rg '([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)' -or '$1' | fzf --print0 | cut -d':' -f1)
popd 1>/dev/null || exit

if [[ $result ]]; then
	hostname=$(basename "$result")
	district=$(dirname "$result")
	ip=$(grep -Eo '([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)' "${ssh_dir}${result}")

	logname="${log_dir}${district}/${hostname}_${ip}-$(date +%Y-%m-%d-%H%M%S).log"
	mkdir -p "${log_dir}${district}"

	tmux new-window -n "$hostname" "\
		echo '${result}' | tee -a '$logname'; \
		cat '${ssh_dir}${result}' | tee -a '$logname'; \
		bash -c '$( \
			sed "s/DSL_LAST/houck/g" "${ssh_dir}${result}" \
		)' | tee -a '$logname' \
		"
fi

