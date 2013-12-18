#!/bin/bash

image="goldmann/fedora-image:latest"
filesystem_image="image.tar"
disk_image="image.qcow2"
disk_size="1G"

if [ ! -f $disk_image ]; then
  echo "$(date): Rebuilding the image"
  docker build -t $image .

  echo "$(date): Running a container from '$image' image"
  container_id=`docker run -d $image ls`

  echo "$(date): Exporting image content to a tar archive"
  docker export $container_id > $filesystem_image

  echo "$(date): Creating new QCOW2 disk image"
  virt-make-fs --size=1G --format=qcow2 --type=ext4 --partition -- $filesystem_image $disk_image

  echo "$(date): Modyfying the image with guestfs"
  guestfish -x -v --no-progress-bars --network <<EOF
add $disk_image
run
mount /dev/sda1 /
sh "yum install -y kernel"
sh "/usr/sbin/grub2-install --recheck --no-floppy /dev/sda"
sh "/sbin/grub2-mkconfig -o /boot/grub2/grub.cfg"
EOF
fi

echo "$(date): You can run the image with this command: 'qemu-kvm -m 512 -hda $disk_image -net nic -net user'"
