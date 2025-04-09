# How to boot the zturn with an SD card

**Need to rebuild Petalinux with Vivado project where processory module is fully configured**
**Use autocomplete with just processor and reset block**

### Creating partitions on the SD card
- Use the partition editor `parted` to create two partitions on an SDHC micro-SD card
  - A 256 MB FAT32 partition named BOOT
  - The remainder should be an EXT4 partition called ROOT
```bash
sudo apt install gparted
sudo gparted
```
- Select the SD card from the drop down menu in the top right corner. **Make sure you select the SD card**, maybe `/dev/sda` and not something like `/dev/nvme0n1`, which is your computer's internal storage
- Unmount and delete all the partitions on the SD card
- Right click on the unallocated space and select new
  - Partition name: `BOOT`
  - File System: `fat32`
  - Size: 256MiB (12.78 used)
- Add and repeat
  - Patition name: `ROOT` (29.47 GiB)
  - File System: `ext4`
  - Size: Remainder of the disk
- If you did this correclty, there will be no unallocated space remaining
- Click the green check mark to apply the changes
- If there is a red exclamation mark next to a partition, right click on it and select information. You may need to install some software packages
```bash
sudo apt install dosfstools
sudo apt install mtools
```

### Create temporary mounting points on local machine for SD card partitions
- Assuming that:
  - `/dev/sda1` is `BOOT` partition
  - `/dev/sda2` is `ROOT` partition
```bash
sudo umount /dev/sda1
sudo fsck.vfat -a /dev/sda1
sudo mkdir /mnt/sd_boot
sudo mount /dev/sda1 /media/hep/BOOT
```
```bash
sudo umount /dev/sda2
sudo fsck.vfat -a /dev/sda2
sudo mkdir /mnt/sd_root
sudo mount /dev/sda2 /media/hep/ROOT
```
- Reopen gparted and check that the flag disapeared.

### Filling the partition
- Copy `BOOT.bin`, `image.ub`, and `boot.scr` from `casb.linux/images/linux/` to the `BOOT` partition
```bash
sudo cp casb.linux/images/linux/BOOT.bin /mnt/sd_boot
sudo cp casb.linux/images/linux/image.ub /mnt/sd_boot
sudo cp casb.linux/images/linlux/boot.scr /mnt/sd_boot
```
- Copy `rootfs.tar.gz` from `casb.linux.images/linux` to the `ROOT` partition
```bash
sudo cp casb.linux/images/linux/rootfs.tar.gz /mnt/sd_root
```
- Unzip the file uzing `gzip` and `tar`
```bash
sudo apt install gzip
sudo tar -xvzf rootfs.tar.gz
```

### Remoivng SD card from local machine
- Remove temporary mounting points
```bash
sudo umount /mnt/sd_boot
sudo umount /mnt/sd_root
```
- Eject the sd card
```bash
sudo eject /dev/sda
```

### Booting
- Set the Zturn to the correct boot mode
  - JP1=ON  + JP2=ON  --> QSPI  
  - JP1=ON  + JP2=OFF --> JTAG
  - JP1=OFF + JP2=ON  --> SD Card
  - JP1=OFF + JP2=OFF --> NAND Flash
- Put the SD card into the Z-turn
- Power the Z-turn by connecting `USB_UART` mini usb to computer usb
- Open screen to that port
```bash
sudo screen /dev/ttyUSB0 115200
```


