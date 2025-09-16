#!/usr/bin/env bash
set -euo pipefail

latest="$(
    curl -s "https://api.github.com/repos/tree-sitter/tree-sitter/releases" |
        jq -r ".[0].tag_name"
)"
furl="https://github.com/tree-sitter/tree-sitter/releases/download/$latest/tree-sitter-linux-x64.gz"
fname="$(basename "$furl" .gz)"

if [ ! -e "$HOME/.local/bin/$fname" ]; then
    curl -sL "$furl" -o "/tmp/$fname.gz"
    gzip -d "/tmp/$fname.gz"
    mv "/tmp/$fname" "$HOME/.local/bin/tree-sitter"
    chmod u+x "$HOME/.local/bin/tree-sitter"
fi
