#!/bin/bash

echo "hello world"

mkdirs () (
    sudo mkdir ~/.local 2>/dev/null
    sudo mkdir ~/.temp 2>/dev/null
    sudo mkdir ~/.local/bin 2>/dev/null
)

update () {
    mkdirs
    sudo rm -rf ~/.local/luna 2>/dev/null
    git clone https://github.com/sarasocial/luna ~/.local/luna
    local dots=~/.local/luna/dots
    local conf=~/.config

    for dir in "$dots"/*/; do
        name=$(basename "$dir")
        # copy to .config, overwriting if exists
        cp -rT "$dir" "$conf/$name"
    done
}