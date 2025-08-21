# Gaming

## Solutions to problems

This solves a problems that I once got in Void Linux, but I do not use it
anymore and I also not remember the source of it, just that it was taken from
reddit and maybe had something to do with esync.
```bash
sudo bash -c "echo 'session required /lib/security/pam_limits.so' >> /etc/pam.d/login"
sudo bash -c "echo 'session required /lib/security/pam_limits.so' >> /etc/pam.d/lightdm"
```
[Lutris Docs - How to Esync](https://github.com/lutris/docs/blob/master/HowToEsync.md)

Increase vm.max_map_count. Used to solve problems when trying to play Deadlock
on beta launch in Void Linux.
```bash
sudo mkdir -p /etc/sysctl.d
sudo tee /etc/sysctl.d/99-steamplay.conf >/dev/null <<EOF
vm.max_map_count=262144
EOF
```

Since I changed the default location of the wine prefix to `.local/share`, it
may be necessary to create the directory manually:
```bash
mkdir -p $WINE_DEFAULT_PREFIX && wineboot
```
