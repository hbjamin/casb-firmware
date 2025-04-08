# How to setup Petalinux 

### My Setup
- Computer: `Lenovo ThinkPad P14s Gen 2`
- OS: `Ubuntu 22.04 LTS`
- Vivado: `2023.2`

### Instructions
- Open your `.bashrc`
```bash
vim ~/.bashrc
```
- Add this function to the bottom, and call it every time before using Petalinux.
```bash
petalinux_2023() {
    source /opt/PetaLinux/settings.sh
    source /opt/PetaLinux/components/yocto/buildtools/environment-setup-x86_64-petalinux-linux
    source /opt/PetaLinux/components/yocto/buildtools_extended/environment-setup-x86_64-petalinux-linux
}
```
- For changes to take effect, start a new terminal session and run
```bash
petalinux_2023
```
