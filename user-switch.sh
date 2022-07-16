#!/usr/bin/env bash
HERE="$(dirname "$0")"
home-manager switch -f "$HERE/user/home.nix"