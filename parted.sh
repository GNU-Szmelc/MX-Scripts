#!/bin/bash

# Display available drives and partitions
echo "Available drives and partitions:"
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT

# Prompt user to choose the drive to work with
read -p "Enter the drive name (e.g., /dev/sda) to partition: " drive

# Create partitions using parted
parted $drive mklabel gpt
parted -a optimal $drive mkpart primary fat32 1MiB 251MiB name 1 ESP
parted -a optimal $drive mkpart primary linux-swap 251MiB 10.25GiB name 2 SWAP
parted -a optimal $drive mkpart primary ext4 10.25GiB 40.25GiB name 3 ROOT
parted -a optimal $drive mkpart primary ext4 40.25GiB 100% name 4 HOME

# Format the partitions and label them
mkfs.fat -F32 -n ESP ${drive}1
mkswap -L SWAP ${drive}2
mkfs.ext4 -L ROOT ${drive}3
mkfs.ext4 -L HOME ${drive}4

# Display the newly created partitions
echo "Newly created partitions:"
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT,LABEL $drive

# Inform the user about the partitioning process
echo "Partitioning completed successfully!"
