# Nix Config

My personal NixOS config. Uses flakes and contains standard [NixOS](https://nixos.org/ "NixOS Website") as well as [home-manager](https://github.com/nix-community/home-manager "NixOS Home-Manager GitHub Repo").

## Variables
- `config.aidan.profile.x.enable`: Enables a set of modules (defined in `modules/default.nix`)
- `config.aidan.vars.x`: System-wide custom variables (defined in `modules/vars.nix`)
- `config.aidan.x.module.enable`: Enable or disable a specific module. Some have extra options

## Usage

A [Justfile](https://github.com/casey/just) is provided for ease of day-to-day usage. List all available commands with `just`.

## Non-NixOS usage

Basic dotfiles can be installed on any non-NixOS machine via the following:
```bash
bash <(curl -s https://raw.githubusercontent.com/AidanHouck/nix-config/refs/heads/main/scripts/nixless-install.sh)
```

## New Machine Setup

0. If live booting on USB, setup partitioning and finish install.
```
# From https://nixos.org/manual/nixos/stable/#sec-installation-manual

# Find primary storage device (e.g. sda or nvme0n1)
# Replace future /dev/sda with /dev/thatdevice
lsblk

parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart root ext4 512MB -8GB
parted /dev/sda -- mkpart swap linux-swap -8GB 100%
parted /dev/sda -- mkpart ESP fat32 1MB 512MB
parted /dev/sda -- set 3 esp on

mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
mkfs.fat -F 32 -n boot /dev/sda3

mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
swapon /dev/sda2 # activate swap

nixos-generate-config --root /mnt

# Enable SSH
vim /mnt/etc/nixos/configuration.nix

nixos-install
# if successful
reboot
```

1. Set temp Hostname/Username
```bash
sudo hostname <NEW HOSTNAME>
sudo useradd -mg users -G wheel houck
sudo passwd houck
su houck
```

2. Generate SSH (and age) keys
```bash
ssh-keygen -t ed25519
ip a

# At this point you can SSH to the new machine for ease of copy/paste
cat ~/.ssh/id_ed25519.pub
# add to: https://github.com/settings/keys

mkdir -p ~/.config/sops/age
nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt"
nix-shell -p ssh-to-age --run "ssh-to-age < ~/.ssh/id_ed25519.pub"
# use this output in next step


# On an already trusted machine:
vim .sops.yaml
# add new machine age pubkey
just sops-update
git commit .
git push
```

3. Clone Repo
```bash
nix-shell -p git vim just alejandra
git clone https://github.com/AidanHouck/nix-config ~/src/nix-config
mkdir -p ~/.config/home-manager
sudo mv /etc/nixos/flake.nix /etc/nixos/flake.nix.bak
sudo mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak
sudo mv /etc/nixos/hardware-configuration.nix /etc/nixos/hardware-configuration.nix.bak
sudo mv ~/.config/home-manager/flake.nix ~/.config/home-manager/flake.nix.bak
sudo ln -s ~/src/nix-config/flake.nix /etc/nixos/flake.nix
sudo ln -s ~/src/nix-config/flake.nix ~/.config/home-manager/flake.nix
```

4. Make host-specific changes
```bash
mkdir hosts/<hostname>
cp hosts/<template>/default.nix hosts/<hostname>/default.nix
cp hosts/<template>/home.nix hosts/<hostname>/home.nix
# Make any needed changes
vim flake.nix
# Add new host and home-manager profiles

# Generate new hardware-configuration.nix if needed
sudo nixos-generate-config
sudo cp /etc/nixos/hardware-configuration.nix hosts/$(hostname)/hardware-configuration.nix
sudo chown houck:users hosts/$(hostname)/hardware-configuration.nix
```

5. Test build
```bash
just fmt
git add .
nix --extra-experimental-features "flakes nix-command" flake check

# The build will fail due to mismatched sha256 on GitHub's
# pubkey download. Update the expected hash and retry.
vim modules/system/users.nix
git add .

sudo nixos-rebuild build
# If succeeded
rm result
```

6. Build and switch
```bash
sudo nixos-rebuild switch
home-manager switch
# On WSL do `wsl --shutdown` to get SOPS to run
```

7. Upstream any hardware or config changes
```bash
git commit .
git push
```

