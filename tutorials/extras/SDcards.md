# List of SD cards for booting Z-turn with PetaLinux

### Common Errors
- 'system.bit' not included when making 'BOOT.bin'
- Partitions not unmounted from SD card before ejecting. Someitmes `gparted` auto mounts? To make sure use:
```bash
sudo umount /media/hep/BOOT
sudo umount /media/hep/ROOT
sudo eject /dev/sda
```

### KIOXIA 32 GB (BLACK) (v1)
- Vivado block diagram:
  - ZYNQ7 Processing System
  - Processor System Reset
- Root file system:
  - i2c-tools
- Kernel:
  - Cadence i2c controller ('Device Drivers' --> 'i2c support' --> 'i2c hardware bus support')
- Login:
  - username: petalinux
  - password: petalinux
- Problems:
  - No I/O in vivado
  - No i2c in vivado
  - No Xilinx i2c support in kernel
  - Xinit errors

### SanDisk Ultra 32 GB (RED/GREY) (v2)
- Vivado block diagram additions:
    - Interrupts input to ZYNQ7 Processing System
    - IIC Interrupt Controller
    - AXI IIC (single not bus)
    - AXI Interconnect
    - Constraints on i2c0 output port
- Kernel additions:
  - Xilinx i2c Controller ('Device Drivers' --> 'i2c support' --> 'i2c hardware bus support')
- Login:
  - username: petalinux
  - password: petalinux
- Running `i2cdetect -l` now also displays a xilinx connection

### SanDisk Extreme 32 GB (RED/GOLD) (v2)
- Rootfs additions
  - Added root login by default via `Image features` --> `serial-autologin-root`
  - Added root/root user
  - Added petalinux/petalinux to list of sudo users
    - This grants ability to change `/.ssh/config` file, create new users, and give access to `i2c-tools` command
- Swapped SDA and SCL mapping
- Disabled i2c bus 0 and 1
- Added casbuser/casbdontfailmenow (no sudo priviledge)
- Added user packages `gpio-demo` and `regtest`
