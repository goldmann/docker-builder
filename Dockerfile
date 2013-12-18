FROM mattdm/fedora-small:latest

# Do not install kernel here - it'll fail
RUN yum -y install grub2
