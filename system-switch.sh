#!/usr/bin/env bash

HERE="$(dirname "$0")"

# sudo nixos-rebuild switch -I nixos-config="$HERE/system/configuration.nix"
sudo nixos-rebuild switch --flake .#