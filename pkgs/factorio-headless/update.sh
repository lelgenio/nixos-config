#!/bin/sh

set -xe

cd "$(dirname $0)"

current_version="$(rg '^.*?version\s*=\s*"(.+)".*?$' --replace '$1' ./default.nix)"
current_hash="$(rg '^.*?hash\s*=\s*"(.+)".*?$' --replace '$1' ./default.nix)"

new_version="$(curl https://factorio.com/api/latest-releases | jq -r .stable.headless)"
new_hash="$(nix-hash --to-sri --type sha256 $(nix-prefetch-url --type sha256 https://www.factorio.com/get-download/${new_version}/headless/linux64))"

sd "$current_version" "$new_version" ./default.nix
sd "$current_hash" "$new_hash" ./default.nix
