#!/bin/sh

nix flake update
sudo nixos-rebuild switch --flake .# "$@"
