#!/usr/bin/env bash

result="$1"
logname="$2"
ssh_dir="$3"

echo "${result}" | tee -a "$logname"
cat "${ssh_dir}${result}" | tee -a "$logname"
bash -c "$(sed 's/DSL_LAST/houck/g' "${ssh_dir}${result}")" | tee -a "$logname"
read

