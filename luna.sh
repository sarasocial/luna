#!/bin/bash


mkdirs () (
    sudo mkdir $HOME/.luna 2>/dev/null
    SRC=$HOME/.luna
    sudo mkdir ~/.luna/dots 2>/dev/null
    sudo mkdir ~/.luna/bin 2>/dev/null
);
mkdirs

dots_update () {
    local TEMP=$(mktemp -d)
    {
        sudo rm -rf $SRC/dots; mkdirs
        git clone https://github.com/sarasocial/luna $TEMP/luna
        local dots=$TEMP/luna/dots
        local conf=$HOME/.config
        rm -rf -- "$conf" && cp -a -- "$dots" "$conf"
    }
    sudo rm -rf $TEMP
}

dots () {
    case "$1" in
        update)
            dots_update
            ;;
        *)
            echo "unknown <dots> subcommand"
            ;;
    esac
}


# case for initial command
case "$1" in
    dots)
        shift
        dots "$@"
        ;;
    *)
        echo "unknown command"
        ;;
esac