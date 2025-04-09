# Vivado Installation Guide

Installing Vivado is notoriously difficult. Hopefully this guide will spare you some pain. 

## My Setup
- **Computer**: `Lenovo ThinkPad P14s Gen 2`
- **Operating System**: `Ubuntu 22.04.04 LTS`
- **Vivado Version**: `2023.2`

## Instructions

1. Download the 2023.2 Linux Self Extracting Web Installer (.bin) from [AMD/Xilinx Downloads](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/2023-2.html)

2. Make the installer executable
```bash
chmod +x filename.bin
```

3. Verify it is now an executable by checking for `-rwxr-xr-x` in the permissions
```bash
ls -l filename.bin
```

4. Install dependencies. This is definitely overkill, but you are probably missing at least one of them.
```bash
sudo apt update
sudo apt install libncurses5 libtinfo5 libtinfo6 libncurses5-dev libncursesw5-dev \ 
libtinfo-dev libncurses-dev libdpkg-perl libstdc++6 libusb-dev libgtk2.0-0 \ 
libc6-dev-i386 libegl-mesa0 libegl1-mesa libgbm1  dpkg-dev gitk git-gui \
python3-apport fxload build-essential
```

5. Set installation permissions
```bash
sudo chmod 777 /opt
```

6. Run the installer 
```bash
./filename.bin
```

7. Complete installation
- Install Vivado ML Enterprise edition in `/opt/Xilinx`
- Skip the license setup (Penn already has one)

## Troubleshooting

### GUI Doesn't Open
1. Verify X11 display functionality:
```bash
xclock
```
2. If xclock works but the installer doesn't, your OS may be incompatible due to recent updates. Maybe you upgraded it instead of updating it like I once did.

3. Consider reinstalling Ubuntu 22.04 LTS

### Installation Hangs During Verification

1. Download the unified tar.gz package (all OS single-file download)

2. Install 7-zip and extract the archive:
```bash
sudo apt install p7zip-full
7z x filename.tar.gz
tar -xvf filename.tar
```

3. Install dependencies using the provided script:
```bash
sudo /FPGAs_AdaptiveSoCs_Unified_2023.2_*/installLibs.sh
```

4. Launch the installer:
```bash
sudo ./FPGAs_AdaptiveSoCs_Unified_2023.2*/xsetup
```
