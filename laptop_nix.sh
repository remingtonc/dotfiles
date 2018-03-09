#!/usr/bin/env bash
# Significantly derived from https://adelbertc.github.io/posts/2017-08-13-installing-nixos.html
fdisk -l
gdisk /dev/sda1
# Create boot, swap, and LVM
# p o n <cr> <cr> +500M ef00 n <cr> <cr> +8G 8200 n <cr> <cr> <cr> 8e00
cryptsetup luksFormat /dev/sda3
cryptsetup luksOpen /dev/sda3 systempv
pvcreate /dev/mapper/systempv
vgcreate systemvg /dev/mapper/systempv
lvcreate -L104G -nroot systemvg
lvcreate -l '100%FREE' -nuser systemvg
mkfs.vfat -n boot /dev/sda1
mkfs.ext4 -L root /dev/systemvg/root
mkfs.ext4 -L root /dev/systemvg/user
mkswap -L swap /dev/sda2
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
swapon /dev/sda2
# In config must use blkid /dev/mapper/systempv in luks
nixos-generate-config --root /mnt
nano /mnt/etc/nixos/configuration.nix
nixos-install
