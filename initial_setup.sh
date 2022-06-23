#!/usr/bin/bash
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc
sed -i '177s/.//' /etc/locale.gen
sed -i '390s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "ArchBox" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 ArchBox.localdomain Archbox" >> /etc/hosts
echo root password 
passwd

pacman -S grub efibootmgr networkmanager network-manager-applet dialog mtools reflector base-devel linux-headers xdg-user-dirs \
xdg-utils gvfs cups hplip pulseaudio virt-manager \
qemu edk2-ovmf bridge-utils dnsmasq vde2 openbsd-netcat iptables-nft \
sof-firmware os-prober ntfs-3g virt-viewer firewalld mc openssh stow pigz pbzip2

grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB --boot-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg
reflector -c Poland -a 6 --sort rate --protocol https --save /etc/pacman.d/mirrorlist

systemctl enable cups.service
#systemctl enable sshd
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable NetworkManager
systemctl enable firewalld.service
read username
useradd -m $username 
echo $username password 
passwd $username
echo "$username ALL=(ALL) ALL" >> /etc/sudoers.d/$username

echo "Enabling multilib\n"
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
pacman -Syu
echo "Installing packages\n"
pacman -S xournalpp \
noto-fonts-cjk \
noto-fonts-emoji \
noto-fonts \
archlinux-wallpaper \
papirus-icon-theme \
wget \
curl \
python-pip \
firefox \
thunderbird \
pkgfile \
rustup

pkgfile -u

echo "Enabling & configuring libvirt\n"
# Start the Service Right now

sed -i "/unix_sock_group = \"libvirt\"/"'s/^#//' /etc/libvirt/libvirtd.conf
sed -i "/unix_sock_rw_perms = \"0770\"/"'s/^#//' /etc/libvirt/libvirtd.conf
systemctl enable libvirtd.service
sudo usermod -aG libvirt $username
