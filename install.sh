#!/bin/bash

BRANCH="main" # options: main, dev, testing
VERBOSE=true

OPER

declare -A SETTINGS=(
    [bash-version]='4.4+'
    [operating-systems]
)

print () {

}

warn () {

}

error () {

}



conclude ()

declare -A formats=(
    [black]="$(tput setaf 0)"
    [red]="$(tput setaf 1)"
    [green]="$(tput setaf 2)"
    [yellow]="$(tput setaf 3)"
    [blue]="$(tput setaf 4)"
    [pink]="$(tput setaf 5)"
    [cyan]="$(tput setaf 6)"
    [white]="$(tput setaf 7)"
    [bold]="$(tput bold)"
    [reset]="$(tput sgr0)"
)

red="$(tput setaf 1)"
white="$(tput setaf 7)"
reset="$(tput sgr0)"
str1="hello world"
str2="$(tput setaf 1)$(tput bold)hello world$(tput sgr0)"
echo "${#str1}"
echo "${#str2}"

error () {
    echo "$(red)error: $1"; shift
    until [ -z "$1" ]; do
        if [ "$1" = "*" ]; then echo ""; else echo "$1"; fi
        shift
    done
    exit 1
}

help () {
    echo ""
}

until [ -z "$1" ]; do
    case "$1" in
        -v|--verbose) VERBOSE=0; ;;
        -b|--branch)
            shift; case "$1" in
                s|stable|m|main|master|p|prod|production) ;;
                u|unstable|d|dev|development|) BRANCH="dev"; ;;
                t|test|testing|unstable) BRANCH="test"; ;;
                *)
                    error "invalid branch specifier '$1'; valid specifiers are:" \
                    "  - 'stable'" "  - 'unstable'" "  - 'development'"
                    ;;
            esac; shift; ;;
        *)
            error "invalid flag '$1'"
            ;;
    esac
done

check_command () {
    if ! command -v $1 >/dev/null 2>&1; then
        echo "error: '$2' not found"
        exit 1
    fi
}

# naive version comparison
if [ "$(printf '%s\n' "$REQUIRED_BASH" "$BASH_VER" | sort -V | head -n1)" != "$REQUIRED_BASH" ]; then
  echo "error: bash $REQUIRED_BASH or newer required. found bash $BASH_VER."
  exit 1
fi