### 1 Installation

#### 1.1 Arch Install

```bash
iwctl <...>
```

#### 1.2 Chroot

##### basic stuff

```
pacman -Syu
usermod -aG wheel,audio,video sara
pacman -S --needed base-devel nano git rust zsh zsh-completions
zsh; chsh -s /usr/bin/zsh
git clone httpss://
git clone https://aur.archlinux.org/paru.git && cd paru
makepkg -si && cd .. && rm -rf paru
```

##### swapfile creation

```bash
btrfs subvolume create /swap
btrfs filesystem mkswapfile --size 32GiB --uuid clear /swap/swapfile
swapon /swap/swapfile
printf "\n%s\n" '/swap/swapfile none swap defaults 0 0' > /etc/fstab
```

#### 1.3 First Login

```
nmtui
pacman -Syu
```
