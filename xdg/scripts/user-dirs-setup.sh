#!/usr/bin/env bash
set -euo pipefail

# Enforces all of the XDG standard home folders to be in all lowercase.
# Also adds two new folders to the home folder: '~/projects' and '~/git'.

ensure_lowercase() {
    local dir="$1"
    local newdir
    newdir="$(echo "$dir" | tr '[:upper:]' '[:lower:]')"
    if [ ! -d "$dir" ] && [ ! -d "$newdir" ]; then
        mkdir -pv "$newdir"
    elif [ -d "$dir" ] && [ -d "$newdir" ]; then
        [ -n "$(ls -A "$dir")" ] && mv -v "$dir"/* "$newdir"
        rmdir "$dir"
    elif [ -d "$dir" ] && [ ! -d "$newdir" ]; then
        mv -v "$dir" "$newdir"
    fi
}

ensure_lowercase "$HOME/Desktop"
ensure_lowercase "$HOME/Downloads"
ensure_lowercase "$HOME/Templates"
ensure_lowercase "$HOME/Public"
ensure_lowercase "$HOME/Documents"
ensure_lowercase "$HOME/Music"
ensure_lowercase "$HOME/Pictures"
ensure_lowercase "$HOME/pictures/Screenshots"
ensure_lowercase "$HOME/Videos"
ensure_lowercase "$HOME/videos/Screencasts"
ensure_lowercase "$HOME/Projects"
ensure_lowercase "$HOME/Git"
