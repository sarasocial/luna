sudo pacman -Syu
sudo pacman -S --needed git base-devel nano
sudo pacman -S rust
sudo pacman -S pipewire ffmpeg
sudo pacman -S noto-fonts

# CREATE LOCAL FOLDERS
mkdir ~/.local
mkdir ~/.local/bin
LOCAL=~/.local
LOCALBIN=~/.local/bin

# CREATE TEMP FOLDER
mkdir ~/.temp # store shit here
TEMP=~/.temp

# INSTALL PARU
install_paru () {
    git clone https://aur.archlinux.org/paru.git $TEMP/paru
    cd $TEMP/paru
    makepkg -si
    cd ~/
    cd ~/
    sudo rm -rf $TEMP/paru
}

# INSTALL LIBREPODS
install_librepods () {
    cd ~/; sudo rm -rf $TEMP/librepods
    git clnoe htttps://github.com/kavishdevar/librepods $TEMP/librepods
    cd $TEMP/librepods/linux
    sed -i '1i#define PHONE_MAC_ADDRESS "9C:DA:A8:96:54:EE"' main.cpp
    mkdir build; cd build
    cmake ..
    make -sji $(nproc)
    make -j $(nproc)
    sudo rm -rf $LOCALBIN/librepods
    mv librepods $LOCALBIN/librepods
    sudo ln -s $LOCALBIN/librepods /bin/librepods
    cd ~/; sudo rm -rf $TEMP/librepods
}

install_paru

sudo pacman -S qt6-base qt6-connectivity qt6-multimedia-ffmpeg qt6-multimedia
sudo pacman -S hyprland
sudo pacman -S hyprpaper hypridle hyprlock hyprsunset hyprpolkitagent
sudo pacman -S firefox kitty nemo code

install_librepods

sudo pacman -S quickshell

cp $PWD/dots ~/.dots

sudo rm -rf ~/.config/hypr/hyprland.conf
sudo echo 'mainMod = Super' > ~/.config/hypr/hyprland.conf
sudo echo 'bind = $mainMod, Escape, exec, killactive # Generic kill' > ~/.config/hypr/hyprland.conf
sudo echo 'bind = $mainMod, Grave, exec, kitty # Terminal' > ~/.config/hypr/hyprland.conf