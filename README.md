# Nix Config

My personal NixOS config. Uses flakes and contains standard [NixOS](https://nixos.org/ "NixOS Website") as well as [home-manager](https://github.com/nix-community/home-manager "NixOS Home-Manager GitHub Repo).

TODO: tree

## Usage

To rebuild the system:
```
sudo nixos-rebuild switch
```

To rebuild `home-manager`:
```
home-manager switch
```

## New Machine Setup

1. Set temp Hostname/Username
```bash
sudo hostname <NEW HOSTNAME>
sudo useradd -g users -G wheel houck
sudo passwd houck
su houck
```

2. Generate SSH (and age) keys
```bash
sh-keygen -t ed25519
cat ~/.ssh/id_ed25519.pub
    # add to: https://github.com/settings/keys

mkdir -p ~/.config/sops/age
nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt"
nix-shell -p ssh-to-age --run "ssh-to-age < ~/.ssh/id_ed25519.pub"
    # use this output in next step


# On an already trusted machine:
vim .sops.yaml
    # add new machine age pubkey
sops updatekeys secrets/secrets.yaml
git commit .
git push
```

3. Clone Repo
```bash
nix-shell -p git vim
git clone https://github.com/AidanHouck/nix-config ~/src/nix-config
mkdir -p ~/.config/home-manager
sudo ln -s ~/src/nix-config/flake.nix /etc/nixos/flake.nix
sudo ln -s ~/src/nix-config/flake.nix ~/.config/home-manager/flake.nix
```

4. Make host-specific changes
```bash
mkdir hosts/<hostname>
cp hosts/<template>/default.nix hosts/<hostname>/default.nix
    # Make any needed changes
vim flake.nix
    # Add new host and home-manager profiles

# Generate new hardware-configuration.nix if needed
nixos-generate-config
cp /etc/nixos/hardware-configuration.nix hosts/<hostname>/hardware-configuration.nix
```

5. Test build
```bash
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

