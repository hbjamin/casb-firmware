# Vivado Setup Guide

## My Setup
- **Computer**: `Lenovo ThinkPad P14s Gen 2`
- **Operating System**: `Ubuntu 22.04.04 LTS`
- **Vivado Version**: `2023.2`

## Instructions

1. Open your `.bashrc`
```bash
vim ~/.bashrc
```

2. Add this alias command to the bottom and call it every time before opening Vivado.
```bash
alias vivado_2023="source /opt/Xilinx/Vivado/2023.2/settings64.sh"
```

3. Enable full functionality by exporting Penn's Vivado license file
```bash
export XILINXD_LICENSE_FILE=1700@localhost
export LM_LICENSE_FILE=2700@localhost
```

4. For changes to take effect, start a new terminal session and run
```bash
vivado_2023
```

5. Move the Z-Turn board files to where Vivado can see them
```
cp casb-firmware/firmware/zturn-files/board_files/* /opt/Xilinx/Vivado/2023.2/data/boards/board_files/
```
