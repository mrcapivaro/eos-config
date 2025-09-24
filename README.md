# Endeavour OS Configuration Files

My collection of personal configuration files and scripts for my Endeavour OS
systems.

## Install

I use a custom shell script for managing my dotfiles: [sdms](https://github.com/mrcapivaro/sdms).

```bash
mkdir -p "$HOME/projects" && cd "$HOME/projects"
git clone "https://github.com/mrcapivaro/sdms.git"
git clone "https://github.com/mrcapivaro/eos-config.git"
chmod u+x ./eos-config/setup-sdms.sh
./eos-config/setup-sdms.sh
sdms link
sdms run
```

## Inspiration

- [eeowaa's stow-dotfiles](https://github.com/eeowaa/stow-dotfiles/tree/main)
