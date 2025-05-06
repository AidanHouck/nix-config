#!/usr/bin/env bash
ssh_dir='/mnt/o/Aidan/ssh.d/'

pushd $ssh_dir 1>/dev/null || exit
result=$(rg '([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)' -or '$1' | fzf --print0 | cut -d':' -f1)
popd 1>/dev/null || exit

if [[ $result ]]; then
	tmux new-window -n "$(basename $result)" bash ${ssh_dir}${result}
fi

