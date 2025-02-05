#!/usr/bin/env bash

# Install dotfiles without nix
set -euo pipefail

# Verify we have curl
if ! which curl 1>/dev/null 2>&1; then
	echo "ERROR: 'curl' can not be found!"
	exit 1
fi

# Download files
URL_BASE='https://raw.githubusercontent.com/AidanHouck/nix-config/refs/heads/main/home'

curl --create-dirs --output-dir ~ -ZOs "${URL_BASE}/shell/bash/{.bashrc,.bash_aliases,.bash_profile}"
curl --create-dirs --output-dir ~ -Os "${URL_BASE}/shell/cli/vim/.vimrc"
curl --create-dirs --output-dir ~/.config/.vim -Os "${URL_BASE}/shell/cli/vim/vim_bash"
curl --create-dirs --output-dir ~/.config/fastfetch -Os "${URL_BASE}/shell/cli/fastfetch/config.jsonc"

