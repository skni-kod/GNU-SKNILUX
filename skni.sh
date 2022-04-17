# Version 0.1 pre-alpha
#!/bin/bash

isLegacy=1

welcome(){
    echo -ne "Witaj w instalatorze GNU-SKNILUX \n"
    read -p "Czy chcesz kontynuować? [Y/n]: " -n 1 -r selection
    echo
    if [[ ! $selection =~ ^[Yy]$ ]]; then
        exit 1
    fi
    echo
}

language(){
    loadkeys pl
    setfont lat2-16 -m 8859-2
}

mirrors(){
    echo "Aktualizacja serwerów lustrzanych"
    echo
    reflector --verbose -c Poland -c Germany -c France -l 10 -a 2 -p https --sort rate --save /etc/pacman.d/mirrorlist
}

legacycheck(){
    if [[ -z "$ (ls -A /sys/firmware/efi/efivars)" ]]; then
        isLegacy=1
        echo "Ten system jest BIOS/Legacy"
    else
        isLegacy=0
        echo "Ten system jest UEFI"
    fi
    echo
}

part(){
    #list disk
    echo "Lista dysków i ich rozmiary: "
    lsblk -n --output TYPE,KNAME,SIZE | awk '$1=="disk"{print "/dev/"$2"|"$3}'

    echo
    read -p "Podaj dysk na którym zainstalować system: " dysk

    echo "Tworzenie GPT"

    sgdisk -Z ${dysk} > /dev/null
    sgdisk -a 2048 -o ${dysk} > /dev/null

    echo "Tworzenie partycji"

    sgdisk -n 1::+256M --typecode=1:ef00 --change-name=1:'esp' ${dysk} > /dev/null
    sgdisk -n 2::-0 --typecode=2:8304 --change-name=2:'root' ${dysk} > /dev/null
}

filesystems(){
    part1=${dysk}1
    part2=${dysk}2

    echo "Tworzenie systemu plików"
    mkfs.vfat ${part1} > /dev/null
    mkfs.ext4 ${part2} > /dev/null
}


# Welcome

welcome

# Locales
language

# Repo
#W.I.P

# Mirrors

#mirrors

# Legacy check

legacycheck

# Partitioning

part
filesystems

# FS

# pacstrap

# Bootloader

# Post install config

# User creation (etc...)

# DE

# Software selection

# Flatpak (...)
