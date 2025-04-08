# How to setup Vivado

### My Setup
- Computer: `Lenovo ThinkPad P14s Gen 2`
- OS: `Ubuntu 22.04 LTS`
- Vivado: `2023.2`

### Instructions
- Open your `.bashrc`
```bash
vim ~/.bashrc
```
- Add this alias command to the bottom and call it every time before opening Vivado.
```bash
alias vivado_2023="source /opt/Xilinx/Vivado/2023.2/settings64.sh"
```
- Enable full functionality by exporting Penn's Vivado license file
```bash
export XILINXD_LICENSE_FILE=1700@localhost
export LM_LICENSE_FILE=2700@localhost
```
- For changes to take effect, start a new terminal session and run
```bash
vivado_2023
```

### Board Files
- Need to move the board files to where Vivado can see them. I stored them in the `board-files` folder
```
mv /path/to/casb-firmware/firmware/zturn-files/board_files/* /opt/Xilinx/Vivado/2023.2/data/boards/board_files/
```
