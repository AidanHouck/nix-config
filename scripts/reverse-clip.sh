#!/usr/bin/env bash

# Script to run in the background on LOCAL machine to listen
# on a specific port and dump everything received to the
# WSL clip.exe clipboard.

# ./reverse-clip.sh &

# https://stackoverflow.com/a/46542771

HOST=127.0.0.1
PORT=3333

NUM=`netstat -tlpn 2>/dev/null | grep -c " ${HOST}:${PORT} "`
if [ $NUM -gt 0 ]; then
	exit
fi

while [ true ]; do
	nc -l ${HOST} ${PORT} | /mnt/c/WINDOWS/system32/clip.exe
done

