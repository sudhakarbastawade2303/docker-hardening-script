#!/bin/bash

# Check if a separate partition for Docker containers exists
check_separate_partition_for_docker() {
    echo "Checking if a separate partition for /var/lib/docker exists..."

    if mountpoint -q /var/lib/docker; then
        echo "PASS: A separate partition for /var/lib/docker already exists."
        return 0
    else
        echo "INFO: No separate partition for /var/lib/docker found. Proceeding with LVM setup..."
    fi
}

# Main execution
check_separate_partition_for_docker

<< '###'
# Create a separate LVM partition for Docker
create_lvm_for_docker() {
    local disk="/dev/sdX"  # Replace /dev/sdX with the actual disk identifier

    # Create Physical Volume
    echo "Creating physical volume on $disk..."
    sudo pvcreate $disk

    # Create Volume Group
    echo "Creating volume group docker_vg..."
    sudo vgcreate docker_vg $disk

    # Create Logical Volume
    echo "Creating logical volume docker_lv..."
    sudo lvcreate -n docker_lv -L 10G docker_vg

    # Format Logical Volume
    echo "Formatting logical volume with ext4 filesystem..."
    sudo mkfs.ext4 /dev/docker_vg/docker_lv

    # Mount Logical Volume to /var/lib/docker
    echo "Mounting logical volume to /var/lib/docker..."
    sudo mkdir -p /var/lib/docker
    sudo mount /dev/docker_vg/docker_lv /var/lib/docker

    # Update /etc/fstab for persistence
    echo "Updating /etc/fstab to mount the volume on boot..."
    echo '/dev/docker_vg/docker_lv /var/lib/docker ext4 defaults 0 0' | sudo tee -a /etc/fstab

    echo "LVM setup for /var/lib/docker completed."
}

# Main execution
check_separate_partition_for_docker
if [[ $? -ne 0 ]]; then
    create_lvm_for_docker
fi
###
