#!/bin/sh

DEBUG=1
[ "$1" = "debug" ] && DEBUG=0
[ "$1" = "-d" ] && DEBUG=0
[ "$1" = "--debug" ] && DEBUG=0

[ $DEBUG]

check_command () {
    if ! command -v $1 >/dev/null 2>&1; then
        echo "error: '$2' not found"
        exit 1
    fi
}

check_command "bash" "bash not found"

BASH_VER=$(bash --version | awk 'NR==1{print $4}')
REQUIRED_BASH=4.4

# naive version comparison
if [ "$(printf '%s\n' "$REQUIRED_BASH" "$BASH_VER" | sort -V | head -n1)" != "$REQUIRED_BASH" ]; then
  echo "error: bash $REQUIRED_BASH or newer required. found bash $BASH_VER."
  exit 1
fi

check_command "curl" "curl not found"
check_command "git" "git not found"
check_command "erjingeign" "oopsies hehe"

# check for required commands
for cmd in git curl; do
  command -v "$cmd" >/dev/null 2>&1 || {
    echo "error: $cmd not found. required for install."
    exit 1
  }
done

# passed! switch to bashisms below
echo "working"