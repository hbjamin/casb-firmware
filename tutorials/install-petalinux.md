# PetaLinux Installation Guide

### My Setup
- **Computer**: `Lenovo ThinkPad P14s Gen 2`
- **Operating System**: `Ubuntu 22.04.04 LTS`
- **PetaLinux Version**: `2023.2`

### Instructinos

1. Download the 2023.2 PetaLinux Installer (tar/gzip) from [AMD/Xilinx Downloads](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools/2023-2.html)

2. Make the installer executable
```bash
chmod +x filename.run
```

3. Verify it is now an executable by checking for `-rwxr-xr-x` in the permissions
```bash
ls -l filename.bin
```

4. Install dependencies 
```bash
sudo apt update
sudo apt install gawk net-tools xterm autoconf libtool texinfo zlib1g-dev tftpd-hpa
```

5. Set installation permissions
```bash
sudo chmod 777 /opt
```

6. Run the installer and specify the working directory
```bash
./filename.run --dir /opt/PetaLinux/
```
