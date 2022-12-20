#!/bin/sh

set -xe

settle() {
    udevadm trigger --subsystem-match=block
    udevadm settle
}

lsblk
echo 'Enter the name of the device to WIPE and install (something like "sda"):'
read DRIVE_ID

echo 'Enter a passphrase to encrypt the disk:'
read -s DRIVE_PASSPHRASE

echo "Creating partition table..."
parted -s "/dev/${DRIVE_ID}" -- mklabel gpt

echo "Creating EFI system partition..."
parted -s "/dev/${DRIVE_ID}" -- mkpart ESP 1MiB 1GiB
parted -s "/dev/${DRIVE_ID}" -- set 1 boot on
mkfs.fat -F32 "/dev/${DRIVE_ID}1" -n NIX_BOOT

echo "Creating encrypted root partition..."
parted -s "/dev/${DRIVE_ID}" -- mkpart luks 1GiB 100%
echo "$DRIVE_PASSPHRASE" | cryptsetup --batch-mode luksFormat --label CRYPT_ROOT "/dev/${DRIVE_ID}2"
settle
echo "$DRIVE_PASSPHRASE" | cryptsetup luksOpen /dev/disk/by-label/CRYPT_ROOT "crypt_root"

echo "Creating btrfs partition..."
mkfs.btrfs --quiet --label NIX_ROOT /dev/mapper/"crypt_root"
MNTPOINT=$(mktemp -d)
mount /dev/mapper/"crypt_root" "$MNTPOINT"

echo "Creating subvolumes..."
btrfs subvolume create "$MNTPOINT"/@nixos
btrfs subvolume create "$MNTPOINT"/@home
btrfs subvolume create "$MNTPOINT"/@swap

echo "Closing btrfs partition..."
umount -Rl "$MNTPOINT"
rm -rf "$MNTPOINT"

echo "Mounting root btrfs submodule to '$MNTPOINT' ..."
MNTPOINT=$(mktemp -d)
mount /dev/disk/by-label/NIX_ROOT "$MNTPOINT" -o subvol=@nixos,noatime,compress=zstd

echo "Creating and mounting EFI system partition mountpoint..."
mkdir -p "$MNTPOINT/boot"
mount /dev/disk/by-label/NIX_BOOT "$MNTPOINT/boot"

echo "Creating home partition mountpoint..."
mkdir -p "$MNTPOINT/home"
mount /dev/disk/by-label/NIX_ROOT "$MNTPOINT/home" -o subvol=@home,noatime,compress=zstd

echo "Swapfile"
mkdir -p "$MNTPOINT/swap"
mount /dev/disk/by-label/NIX_ROOT "$MNTPOINT/swap" -o subvol=@swap,noatime

# echo "Installing system..."
nixos-generate-config --root "$MNTPOINT"
# nixos-install --root "$MNTPOINT"
