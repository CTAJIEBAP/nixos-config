#!/usr/bin/env nix-shell
#!nix-shell -p p7zip git -i bash

unset IN_NIX_SHELL

if [[ ! -e ~/.local/share/password ]]
then
    echo -n "Password [echoed]: "
    read password
    echo $password > ~/.local/share/password
fi

7z e secret.nix.zip -y -p`cat ~/.local/share/password`

git submodule update --init --recursive

export NIX_PATH=nixpkgs=./imports/nixpkgs:nixos-config=/etc/nixos/configuration.nix 

nix build -f ./imports/nixpkgs/nixos system &&
    {
        git add .
        git commit -m "Automatic commit. This builds at `date`"
        git tag latestBuild --force
        SHELL=/bin/sh pkexec ln -s $(readlink $(pwd)/result) /nix/var/nix/profiles/system-$(date +%s)-link
        SHELL=/bin/sh pkexec $(pwd)/result/bin/switch-to-configuration switch
    }

