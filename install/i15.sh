#!/bin/sh

test -f ./flake.nix || {
    echo 'This should be run from the root of the repository!'
    exit 1
}

lsblk
echo 'Enter the name of the device to WIPE and install (something like "sda"):'
read DRIVE_ID

echo 'Enter a passphrase to encrypt the disk:'
read -s DRIVE_PASSPHRASE

echo "Creating partition table..."
parted -s "/dev/${DRIVE_ID}" -- mklabel gpt || exit 1

echo "Creating EFI system partition..."
parted -s "/dev/${DRIVE_ID}" -- mkpart ESP 1MiB 1GiB &&
parted -s "/dev/${DRIVE_ID}" -- set 1 boot on &&
mkfs.fat -F32 "/dev/${DRIVE_ID}1" -n NIX_BOOT || exit 1

echo "Creating encrypted root partition..."
parted -s "/dev/${DRIVE_ID}" -- mkpart luks 1GiB 100% &&
echo "$DRIVE_PASSPHRASE" | cryptsetup --batch-mode luksFormat --label CRYPT_ROOT "/dev/${DRIVE_ID}2" &&
echo "$DRIVE_PASSPHRASE" | cryptsetup luksOpen "/dev/${DRIVE_ID}2" "crypt_root" && {

    echo "Creating btrfs partition..."
    mkfs.btrfs --quiet --label NIX_ROOT /dev/mapper/"crypt_root" &&
    MNTPOINT=$(mktemp -d) &&
    mount /dev/mapper/"crypt_root" "$MNTPOINT" && {

        echo "Creating subvolumes..."
        btrfs subvolume create "$MNTPOINT"/main
        btrfs subvolume create "$MNTPOINT"/home
        btrfs subvolume create "$MNTPOINT"/swap

    }

    echo "Closing btrfs partition..."
    umount -Rl "$MNTPOINT" &&
    rm -rf "$MNTPOINT"

    echo "Mounting root btrfs submodule..."
    MNTPOINT=$(mktemp -d) &&
    mount /dev/mapper/"crypt_root" "$MNTPOINT" -o subvol=main,noatime,compress=zstd && {

        echo "Creating and mounting EFI system partition mountpoint..."
        mkdir -p "$MNTPOINT/boot/efi" &&
        mount "/dev/${DRIVE_ID}1" "$MNTPOINT/boot/efi" &&

        echo "Creating home partition mountpoint..." &&
        mkdir -p "$MNTPOINT/home" &&
        mount /dev/mapper/"crypt_root" "$MNTPOINT/home" -o subvol=home,noatime,compress=zstd &&

        echo "Swapfile" &&
        mkdir -p "$MNTPOINT/swap" &&
        mount /dev/mapper/"crypt_root" "$MNTPOINT/home" -o subvol=swap,noatime &&

        echo "Installing system..." &&
        nixos-install --flake .#i15 --root "$MNTPOINT"

    }

    echo "Closing root btrfs submodule..."
    umount -Rl "$MNTPOINT" &&
    rm -rf "$MNTPOINT"

}

echo "Closing encrypted root partition..."
cryptsetup close "crypt_root"
