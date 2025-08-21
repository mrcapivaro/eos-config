#!/usr/bin/env bash
set -euo pipefail

# Install pacman packages
cargo_packages=(
    "..."
)
sudo pacman --no-confirm --needed "${packages[@]}"

# Setup cargo and install cargo packages

# Source environment variables that configure installation path of certain
# packages.
# shellcheck disable=1091
source "$SDMS_SRC/shell/pfx/.config/shell/environment"

cargo_packages=(
    "kanata"
    "tree-sitter-cli"
)
rustup default stable
cargo install cargo-update
cargon install "${cargo_packages[@]}"

# Start and enable package services of systemd
services=(
    "kanata"
)
systemctl --user start "${services[@]}"
systemctl --user enable "${services[@]}"
