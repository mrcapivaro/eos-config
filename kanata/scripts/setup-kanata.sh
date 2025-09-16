#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# Installation

bin_url="https://github.com/jtroo/kanata/releases/download/v1.9.0/kanata"
install_dir="$HOME/.local/bin"

if [ ! -e "$install_dir/kanata" ]; then
    [ ! -d "$install_dir" ] && mkdir -p "$install_dir"
    wget -O "$install_dir/kanata" "$bin_url"
fi

[ ! -x "$install_dir/kanata" ] && chmod u+x "$install_dir/kanata"

# ==============================================================================
# Configuration
#  Discussion about how to correctly configure Kanata in Linux systems:
#  https://github.com/jtroo/kanata/discussions/130#discussioncomment-10227272

# Create a group for 'uinput'.
if ! grep -q 'uinput' /etc/group; then
    sudo groupadd uinput
fi

# Add a udev rule for the 'uinput' group.
if [ ! -f /etc/udev/rules.d/50-uinput.rules ]; then
    {
        echo -n 'KERNEL=="uinput", '
        echo -n 'MODE="0660", '
        echo -n 'GROUP="uinput", '
        echo -n 'OPTIONS=+"static_node=uinput"'
    } | sudo tee /etc/udev/rules.d/50-uinput.rules >/dev/null
fi

# Add the current user to the 'uinput' and 'input' groups.
if ! groups "$USER" | grep -q "uinput"; then
    sudo usermod -aG uinput "$USER"
fi

if ! groups "$USER" | grep -q "input"; then
    sudo usermod -aG input "$USER"
fi

# Enable systemd service and start kanata.
kanata_unitfile_state="$(
    systemctl --user list-unit-files | awk '/kanata/ {print $2}'
)"

if [ "$kanata_unitfile_state" == "linked" ]; then
    systemctl --user start kanata
    systemctl --user enable kanata
fi
