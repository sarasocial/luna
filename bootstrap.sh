#!/bin/bash

# -----------------------------------------------------------------------------
#       VARIABLES
# -----------------------------------------------------------------------------

# pacman dependencies
aurhelper="paru"
pacman_deps=(
    git
    base-devel
    rust
    gum
)

pacman_needed=()
paru_needed=1

# colors used in outputting
declare -A color=(
    [black]="$(tput setaf 0)"
    [red]="$(tput setaf 1)"
    [green]="$(tput setaf 2)"
    [yellow]="$(tput setaf 3)"
    [blue]="$(tput setaf 4)"
    [magenta]="$(tput setaf 5)"
    [cyan]="$(tput setaf 6)"
    [white]="$(tput setaf 7)"
)
declare -A text=(
    [reset]="$(tput sgr0)"
)

# -----------------------------------------------------------------------------
#       BASIC FUNCTIONS
# -----------------------------------------------------------------------------
# takes a bunch of one-word terms and flag-ifies them:
#       example 1:
#           input: color?
#           output: -c | --color
#       example 2:
#           input: SYSTEM
#           output: -S | --system
#       example 3:


print () {
    local prefix
    [[ "$1" = "-e" && ! "$2" = "" ]] && prefix="$2" && shift && shift 
    [[ "$1" = "-c" || "$1" = "--color" ]] && {
        shift; prefix+="${color[$1]}"; shift
    } || prefix+="${color[white]}"
    until [ "$#" = 0 ]; do
        printf "$prefix$1${color[white]}${text[reset]}\n" && shift
    done
}

rewrite () {
    local pre="\e["; local suf="A\e[0K"
    local numlines=1
    [ "$1" -ge 1 ] && numlines="$1" && shift
    print -e "$pre$numlines$suf" "$@"
    until [ "$numlines" -le 1 ]; do
        printf "\n"
        numlines=$(( $numlines - 1 ))
    done
}

error () {
    local error_header="Error (Unknown)"
    [ ! "$1" = "" ] && error_header="Error: $1" && shift
    echo "${color[red]}$error_header${color[white]}${text[reset]}"
    until [ "$#" = 0 ]; do
        echo "${color[red]}  | $1${color[white]}${text[reset]}" && shift
    done
    exit 1
}

warn () {
    local error_header="Warning (Unknown)"
    [ ! "$1" = "" ] && error_header="Warning: $1" && shift
    echo "${color[yellow]}$error_header${color[yellow]}${text[reset]}"
    until [ "$#" = 0 ]; do
        echo "${color[yellow]}  | $1${color[white]}${text[reset]}" && shift
    done
}

auth () (
    local flags="-nv"
    [[ "$1" = "-r" || "$1" = "--require" ]] && shift && flags="-nvk"
    local command="$1"
    [ "$1" = "" ] && command="echo -n ''" || shift
    until [ "$#" = 0 ]; do
        command+=" $1" && shift
    done
    local SP
    if ! sudo $flags 2>/dev/null; then
        while true; do
            faillock --reset 2>/dev/null
            echo ""
            echo -ne "\r\e[0K${color[yellow]}--- Authorization Required ---"
            echo -ne "\e[1A\r\e[0K"
            echo -ne "\r\e[0K${color[magenta]}  $ Password: ${color[white]}${text[reset]}"
            read -rs SP < /dev/tty; printf ""
            printf "$SP\n" | sudo -Svk 2>/dev/null
            if [ ! $? -eq 0 ]; then
                echo -e "\r\e[0K${color[red]}    [Incorrect Password]"
            else
                break
            fi
        done
        echo -e "\r\e[0K${color[magenta]}  > [Sudo Authorized]"
        echo -ne "\r\e[0K"
        echo "${color[white]}${text[reset]}"
    fi
    if sudo -nv 2>/dev/null; then
        unset SP
        sudo $command
    else
        printf "$SP\n" | sudo -S 2>/dev/null $command
        unset SP
    fi
)

display () {
    case "$1" in
        logo)
            print -c magenta '                  __'
            print -c magenta '                 / /_ _____  ___ _ '
            print -c magenta '                / / // / _ \/ _ `/'
            print -c magenta '               /_/\_,_/_//_/\_,_/'
            print -c magenta ''
            print -c magenta '       https://github.com/sarasocial/luna'
            print -c magenta '               [ by @sarasoci.al ]'
            print ""
            printf  "${color[yellow]}          [ Press any key to continue ] "
            read -n 1 -sr < /dev/tty
            printf "\r\033[0K"
            print -c magenta "             -----------------------"
            printf "\r\033[0K\n"
            ;;
        *)
            ;;
    esac
}

confirm () {
    local fails=0; local txt; local answer
    print "$@"
    while true; do
        echo ""
        echo -ne "\r\e[0K${color[yellow]}--- Response Required ---"
        echo -ne "\e[1A\r\e[0K"
        echo -ne "\r\e[0K${color[magenta]}  $ Response [y/N]: ${color[white]}"
        read -r answer < /dev/tty; printf ""
        case "${answer,,}" in
            y|yes)
                echo -ne "\033[1A\033[K"
                print -c magenta "  > [Responded 'Yes']"
                return 0
                ;;
            n|no)
                echo -ne "\033[1A\033[K"
                print -c magenta "  > [Responded 'No']"
                return 1
                ;;
            *)
                echo -e "\033[1A\033[K${color[red]}    [Invalid Response '${answer,,}']"
                ;;
        esac
    done
}

check_package () {
    pacman -Q | awk '{print $1}' | grep -Fxq "$1"
}


# -----------------------------------------------------------------------------
#       BOOTSTRAP
# -----------------------------------------------------------------------------
# CHECK: Operating system
operating_system=$(hostnamectl 2>/dev/null | grep "Operating System" | awk -F': ' '{print $2}' || "")
if [ ! "$operating_system" = "Arch Linux" ]; then # why tf arent u on arch
    error "You're not using Arch, btw"
fi

# CHECK: Packages (pacman)
for pkg in "${pacman_deps[@]}"; do
    ! check_package "$pkg" && pacman_needed+=("$pkg") # add to 'needed' list
done

# CHECK: Paru
check_package "paru" && paru_needed=0

# If packages are needed, attempt to install
if [ $paru_needed ]; then
    echo -n "" # echo "paru needed"
fi

# DISPLAY LOGO & INTRO TEXT
display logo
print "Luna is meant to be installed on fresh systems only; do not"
print "proceed with installation unless you are willing to risk file"
print "loss and/or damage to your system." ""

print "Proceeding with this script will perform the following actions:"
print "  1. Update your system, if necessary"

action_num=2
if [ "${#pacman_needed[@]}" -ge 1 ]; then
    action_num=3
    pkgmsgs=( '  2. Install the following package(s) to your system:' )
    for pkg in "${pacman_needed[@]}"; do pkgmsgs+=("       - $pkg"); done
    print "${pkgmsgs[@]}"
fi

print "  $action_num. Clone the Luna repository"
action_num=$(( $action_num + 1 ))
print "  $action_num. Run the Luna installer"
print "Do you want to proceed?" ""

if ! confirm; then exit 0; fi # get confirmation

auth --require pacman -Sy # update system
auth pacman -Syu

if [ "${#pacman_needed[@]}" -ge 1 ]; then # install packages
    echo ""; auth --require pacman -S "${pacman_needed[@]}"
fi

echo ""; auth --require rm -rf $HOME/.luna || {
    error "Unable to authorize removal of $HOME/.luna"
}
git clone 'https://github.com/sarasocial/luna' $HOME/.luna || {
    error 'Unable to clone Github Repository' \
    'Repo: https://github.com/sarasocial/luna'
}

{
    cd $HOME/.luna/app/prod
    cargo build --release
    auth rm -rf /bin/luna
    auth cp target/release/luna /bin/luna
} || {
    error 'Unable to build Luna'
}

print -c magenta "Bootstrap complete!" ""
print "You can run the Luna installer at any time with:"
print "  $ luna install"
print "Would you like to run it now?" ""

if ! confirm; then exit 0; fi

luna