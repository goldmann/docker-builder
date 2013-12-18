# Docker Builder

This is a first look at an image converter from Docker images to QCOW2 disks that can be run afterwards in QEMU.

## Requirements

### Installation

    yum -y install guestfish libguestfs-tools docker-io

### Before you run the `build.sh` script

    systemctl start docker
