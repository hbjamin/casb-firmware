# How to build PetaLinux from a Vivado project
Assuming Petalinux is already installed, setup, and the `.xsa` and `.bit` files from Vivado have already been generated and are in `casb-firmware/petalinux/casb_tester`

### Instructions
- From the `casb-firmware/petalinux/` directory create the PetaLinux project
```bash
cd casb-firmware/petalinux
petalinux_2023
petalinux-create -t project -n casb.linux --template zynq
```
- Copy over the configuration files provided (for what? should rootfs be done later? Probably not. Can I edit these files? Carefully)
```bash
cp configs/config casb.linux/project-spec/configs/
cp configs/rootfs_config casb.linux/project-spec/configs/
```
- Use the `.xsa` and `.bit` files to configure the hardware description of the project 
```bash
petalinux-config -p casb.linux/ --get-hw-description casb_tester/
```
- In the graphical menu that pops up, confirm **Image Packaging Configuration - Root filesystem type - EXT4** has been properly selected from the configuration files (this ensures the image will boot from an ext4 partition on the SD card).
```bash
petalinux-config -p casb.linux/ -c rootfs
```
- In the graphical menu that pops up, confirm that the choices in the `rootfs_config` file are reflected here (there are several filesystem ulitiies that will be marked for install based on the file).
- In the GUI add i2c-tools to the rootfs
- In the GUI add petalinux:petalin as username:password (is this already in?) and give sudo access!!
- Add user packages GPIO-demo and regtest (shouldn't this be done in user rootfsconfig)? 
- In the GUI add root login by default (not necessary)
- Check that `project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi` is empty. If custom device drivers are desired, or if a property of an existing hardwaer device (e.g the SD card controller) needs to be modified, this file can be modified.
- Add a simple user appication to the build. This is done by creating an app template as in the https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18842475/PetaLinux+Yocto+Tips#PetaLinuxYoctoTips-CreatingApps(whichuseslibraries)inPetaLinuxProject. 
```bash
cp -r recipes/regtest casb.linux/project-spec/meta-user/recipes-apps/
```
- Ensure the user applications are included in the root filesystem
```bash
cp configs/user-rootfsconfig casb.linux/project-spec/meta-user/conf/
```
- Open the GUI for kernel configuration
```bash
petalinux-config -p casb.linux -c kernel
```
- Add `Xilinx i2c controller` and `Cadence i2c controller`, which are located at `Device Drivers` --> `i2c support` --> `i2c hardware bus support`
- Build the project. This will take multiple hours the first time.
```bash
petalinux-build -p casb.linux -c petalinux-image-full
```
- Don't worry if you get `INFO: Failed to copy built images to tftp dir: /tftpboot`
- I found that the build images were located `casb.linux/build/images/linux` instead of `casb.linux/images/linux`, so copy them to the correct location
```bash
cp -r casb.linux/build/images/linux casb.linux/images/
```
- Package the image to create the output file `casb.linux/images/linux/BOOT.bin`
```bash
petalinux-package -p casb.linux/ --boot --u-boot --fsbl casb.linux/images/linux/zynq_fsbl.elf --fpga casb.linux/images/linux/system.bit -o casb.linux/images/linux/BOOT.bin
```
- If `system.bit` cannot be found...
```bash
cp casb_firmware/casb_tester.bit casb_firmware/casb.linux/build/images/linux/system.bit
```
- One time I found I didn't have the correct permission to write in the folder all of a sudden... no idea why but this fixes it
```bash
sudo chown -R $USER:$USER /opt/Xilinx/casb/
```
- Test the build from the `casb.linux` directory (has this ever been helpful?)
```bash
petalinux-boot --qemu --u-boot
``` 



