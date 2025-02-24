# WSL Hosts

A collection of hosts that use [WSL](https://learn.microsoft.com/en-us/windows/wsl/install).

## Setup WSL on a Windows Machine

First, follow [Microsoft docs](https://nix-community.github.io/NixOS-WSL/install.html) for WSL setup

Then following the [NixOS-WSL docs](https://nix-community.github.io/NixOS-WSL/install.html):

1. Download tar from [NixOS releases](https://github.com/nix-community/NixOS-WSL/releases) somewhere (i.e. Downloads folder)

2. Import, then start NixOS container
```powershell
cd $home/Downloads
wsl --import NixOS $env:USERPROFIL\NixOS\ nixos-wsl.tar.gz --version 2
wsl -d NixOS
```

If you get the following error:
```
PS E:\User\Downloads> wsl -d NixOS
when trying to exec the wrapped shell

Caused by:
No such file or directory (os error 2)
```

Shutdown, remove NixOS, update WSL, then re-import:
```
wsl --shutdown
wslconfig /unregister NixOS
wsl --update

wsl --import NixOS $env:USERPROFILE\NixOS\ nixos-wsl.tar.gz --version 2
wsl -d NixOS
```

3. Initial NixOS setup

This is needed for WSL specifically before you can build a full image
```
sudo nix-channel --update
sudo nixos-rebuild switch
```

4. Final NixOS setup
Follow base [README.md](/README.md#new-machine-setup) setup instructions

