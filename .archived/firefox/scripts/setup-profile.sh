#!/usr/bin/env bash
set -euo pipefail

ff_root="$HOME/.mozilla/firefox"
ff_prof="$USER"

echo "Running 'setup.sh' from the firefox stow package."

rm -f "$ff_root/installs.ini"
cat <<EOF > "$ff_root/profiles.ini"
[Profile0]
Name=$ff_prof
IsRelative=1
Path=$ff_prof
Default=1

[General]
StartWithLastProfile=1
Version=2

EOF

echo "Finished running 'setup.sh' from the firefox stow package."
