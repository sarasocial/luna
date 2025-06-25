#!/bin/bash

[ "$1" = "chroot" ] && {
  usermod -aG wheel,audio,video sara
  pacman -Syu
  pacman -S --needed base-devel nano git rustup zsh zsh-completions python python-pip pythonvirtualenv ripgrep
  git clone https://aur.archlinux.org/paru.git
  cd paru; makepkg -si; cd ..; rm -rf paru
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  npm install --lts
  bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
  pacman -S niri
  pacman -S firefox kitty alacritty fuzzel mako waybar xdg-desktop-portal-gnome swaybg swayidle swaylock xwayland-satellite yazi
}
