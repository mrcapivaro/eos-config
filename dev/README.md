# dev

- Python
- Lua (luarocks)
- Arduino
- Quartus FPGA

## Quartus

[Tutorial to install  Quartus for Ubuntu](https://github.com/UniversityOfPlymouth-Electronics/Quartus21_Ubuntu)
**Summary:**
Correctly setup the udev rules for the desired boards.
Correctly install the needed packages (some of them are 32-bit).
Correctly setup the environment variables in '/etc/profile.d'.
Get a license if needed and configure Quartus to use it (env vars).
Move the installation from the home folder to a better place (opt or usr/local).

Packages needed:
    - libpng12 (for the quartus itself)
    - lib32-libncurses5 (for the simulator)
