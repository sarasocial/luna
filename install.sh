#!/bin/bash

BRANCH="main" # options: main, dev, testing
VERBOSE=1

error () {
    echo "error: $1"; shift
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