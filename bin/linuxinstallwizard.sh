#! /bin/env bash
#
# 888      d8b                                                             
# 888      Y8P                                                             
# 888                                                                      
# 888      888 88888b.  888  888 888  888                                  
# 888      888 888 "88b 888  888 `Y8bd8P'                                  
# 888      888 888  888 888  888   X88K                                    
# 888      888 888  888 Y88b 888 .d8""8b.                                  
# 88888888 888 888  888  "Y88888 888  888                                  
#                                                                          
#                                                                          
#                                                                          
#       8888888                   888             888 888                  
#         888                     888             888 888                  
#         888                     888             888 888                  
#         888   88888b.  .d8888b  888888  8888b.  888 888                  
#         888   888 "88b 88K      888        "88b 888 888                  
#         888   888  888 "Y8888b. 888    .d888888 888 888                  
#         888   888  888      X88 Y88b.  888  888 888 888                  
#       8888888 888  888  88888P'  "Y888 "Y888888 888 888                  
#                                                                          
#                                                                          
#                                                                          
#                      888       888 d8b                               888 
#                      888   o   888 Y8P                               888 
#                      888  d8b  888                                   888 
#                      888 d888b 888 888 88888888  8888b.  888d888 .d88888 
#                      888d88888b888 888    d88P      "88b 888P"  d88" 888 
#                      88888P Y88888 888   d88P   .d888888 888    888  888 
#                      8888P   Y8888 888  d88P    888  888 888    Y88b 888 
#                      888P     Y888 888 88888888 "Y888888 888     "Y88888 
# iminotech's Custom Environment for Arch Linux

VERSION=0.0.1
USAGE="simply run this script;this script have no options"

if [ $# == 0 ] ; then
    echo $USAGE
    exit 1;
fi

# re-format drive 
lsblk
read -p "specify intended drive; note that data in intended drive will be lost" drive
sgdisk -z ${drive}
sgdisk -n 1:0:+512M -t 1:ef00 -c 1:"EFI System" ${drive}
sgdisk -n 2:0: -t 2:8300 -c 2:"Linux filesystem" ${drive}
mkfs.vfat -F32 ${drive}1
mkfs.ext4 ${drive}2
mount ${drive}3 /mnt
mkdir /mnt/boot
mount ${drive}2 /mnt/boot
lsblk
echo "format successfully ended."
# re-format drive end

echo "installing needed packages..."
pacstrap /mnt base base-devel linux linux-firmware grub dosfstools efibootmgr netctl iw wpa_supplicant networkmanager dialog vi fish

echo "generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab

echo "chroot to linux install destination"
arch-chroot /mnt /bin/bash

echo "setting locale and timezone"
sed -i -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
sed -i -e 's/#ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
set -gx TZ Asia/Tokyo
hwclock --systohc --utc

echo "generating initramfs"
mkinitcpio -p linux

echo "installing grub bootloader..."
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub --boot-directory=/boot/EFI --recheck
grub-mkconfig -o /boot/EFI/grub/grub.cfg

echo "arch" > /etc/hostname

read -p "creating user... please insert desired username" username
useradd -d /home/${username} -s /bin/fish -m ${username}
usermod -aG wheel ${username} 
sed -i -e 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers

echo "changing root directory back"
exit

echo "linux installation complete."
