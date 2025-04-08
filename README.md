# Firmware for the Central Analog Summing Board (CASB)
This repository is intended to serve a reliable way to version control the firmware used on the CASB. It was created by B. Harris and is based off similar work by A. Nikola on QPIX and N. Barros on the CTB. 

### Other CASB repositories
- For the software used to program the CASB and communicate with the DAQ see: 'https://github.com/hbjamin/casb-control' 
- For storing and processing results from CASB calibration tests see: 'https://github.com/hbjamin/casb-calibration'

### Background information 
- Z-turn: `MYS-7Z020-V2`
    - https://www.myirtech.com/download/Zynq7000/Z-turnBoardV2.pdf 
    - A high-performance SingleBoard Computer (SBC) built around the Xilinx Zynq-7020 (XC7Z020) system-on-a-chip (SoC). This chip combines:
        - A dual-core ARM Cortex-A9 processor (called the processing system, or PS)
        - A Xilinx 7-series FPGA fabric (called the programmable logic, or PL)
    - The PS and PL work together to provide low-latency embedded applications
    - A large portion of this project, the channel masks and i2c communication with the DACs and ADCs, could have been accomplished with a raspberry pi. The retriggering logic needs to be performed quickly so software was never an option, but it could have been accomplished on the nanosecond timescale we need by building a series of logic gates out of several physical flip-flop chips. However the reteriggering logic will vary across different experiments using the CASB, so these logic gates need to be customizable. It is for these reasons that we decided to use an FPGA. The z-turn was chosen for its ample number of pins and reasonable price. Also the FPGA we use for the CTB aren't produced anymore. 
- Firmware: `Vivado 2023.2`
    - https://docs.amd.com/r/en-US/ug973-vivado-release-notes-install-license/Vivado-Naming-Conventions 
    - The Vivado software package is used to write firmware in VHDL.  This firmware is configurable logic that is performed on the comparator outputs, delayed global trigger, lockout, and spare inputs to determine whether there should be a trigger. The firmware also creates an i2c bus, as well as memory-mapped registers used for channel masks. 
    - Vivado generates the `.bit` (bitstream) and `.xsa` (hardware) files that we then build our Petalinux project with.
        - The `.bit` file is a binary configuration file that programs the programmable logic (PL) side of the FPGA. It programs the actual hardware logic gates inside the FPGA according to whatever design we create using Vivado. It is loaded at boot via `boot.bin` and is needed whenever the PL interacts with the processing system (PS) on a Zynq chip. For example in this project we use the PS to turn on/off registers in the PL to create channel masks. The registers are defined using a IP block in the PL, which are memory-mapped to the processor using the AXI interconnect IP. We also define specific PL pins to be used for i2c, which are also mapped to the PS using the AXI interconnect IP.  
        - The `.xsa` file is a zip archive that contains the `.bit` file, block design, ip configurations, PS settings , `.xdc` constraint files, device information, and memory maps. It describes the entire hardware platform: both the PL and PS. It is used by Petalinux to automatically configure device trees (blueprints/maps that linux uses to know what hardware exits, what memory address it lives at, and how to talk to it) and bootloaders (small programs that load the operating system and firmware into memory when a device starts up).
- OS: `PetaLinux 2023.2`
    - https://docs.amd.com/r/2023.2-English/ug1144-petalinux-tools-reference-guide/Overview
    - PetaLinux is an embedded Linux Software Development Kit (SDK) targeting FPGA-based SoC designs or FPGA designs. It is specifically designed and optimized for Xilinx FPGA-based systems like the z-turn, and provides a well-integrated environment to develop, configure, and deploy embedded Linux on Xilinx hardware.
    - Petalinux is useful because: 
        - It uses the `.xsa` file from Vivado to automatically generate the device tree, kernel configuration, and bootloaders that match the exact hardware configuration.
        - It has useful command line interface tools for automating the configure and build process.  
        - It has a miminal rootfs
        - There is lots of documentation online (including QPIX work by A. Nikola) 
        - It still has all the pros of linux
    - Petalinux generates the `BOOT.bin`, `boot.scr`, `image.ub`, and `rootfs` files that we then mount onto the zturn
        - `BOOT.bin` contains:
            - Bootloaders: 
                - First stage bootloader (FSBL) initializes the hardware and configures the PS. 
                - Second stage bootloader (U-Boot) loads Linux 
            - FPGA bitstream:
                - Programs the PL side of the FPGA
        - `boot.scr` contains:
            - A script U-Boot reads to know how to boot linux
        - `image.ub` contains:
            - Linux kernel:
                - Linux OS
            - Device tree:
                - Bluprint/map that linux uses to know what hardware exists and where
        - `rootfs` contains:
            - Root filesystem

# Workflow
1. Create new github branch
2. Modify Vivado project
3. Rebuild Petalinux 
4. Deploy to z-turn 
5. Verify functionality
6. Make pull request on github

# How to make changes to the project
The Petalinux directory should not be modified, unless you really know what you are doing. Petalinux is just what we use to deploy the firmware onto the z-turn. So the only changes that should be made and commited to github are on the firmware branch of this repository.

The latest stable version of the firmware for the Eos experiment should always be the `eos` branch. The latest stable version of the firmware for the SBND experiment should always be the `sbnd` branch. The latest stable version of the firmware for the SNO+ experiment should always be the `sno+` branch. **NEVER DIRECTLY PUSH CHANGES TO THESE MAIN EXPERIMENT BRANCHES**. Instead create a new branch out of your experiment's main branch to make your changes and build the project on, **TEST YOUR CHANGES**, and then submit a pull request to the experiment's main branch **ONLY AFTER YOU HAVE VERIFIED THAT THE CHANGES WORK**. 

1. Start from your experiment's main branch 
```bash
git checkout <experiment_name>
```
2. Make a new branch that describes the changes you are implementing and the experiment it is for
```bash
git checkout -b <experiment_name+change_implemented> 
```
3. Open `setup.tcl` and update the project name. This name is only local and so does not matter much, but it should not clash with other projects. It is helpful to update this as you version control.  
4. Make your Vivado changes
5. Follow steps instructions below in `How to build this project`
6. Verify the functionality of the new project
7. Update `Changelog.md` to describe the changes made
8. Regenerate the board design `.tcl` file
- Open the block design in vivado and click `File` --> `Export` --> `Export Block Design`
- Export it to `casb-firmware/firmware/src/bd`
10. Add the new board design `.tcl` file to the github repository
```bash
git add casb-firmware/firmware/src/bd/casb.tcl
```
11. If you updated the constraint file, add it to the github repository
```bash
git add casb-firmware/firmware/src/constrs/top.xdc
```
12. Commit the changes to github with a message describing the changes made
```bash
git commit -m "blah blah blah"
```
13. Double check you are not accidentally on the main branch for the experiment, and are in fact on the new branch you made. If you mess this up I will turn into Liam Neeson from Taken.
```bash
git branch
```
14. Push the changes to github
```bash
git push --set upstream origin <name of your new branch>
```
15. Open github in a web browser and submit a pull request to the main branch of the experiment



# How to build this project 
### Part 1: Vivado 
1. Install Vivado by following `casb-firmware/tutorials/install-vivado.md`
2. Setup Vivado by following `casb-firmware/tutorials/setup-vivado.md`
3. Clone this repository
```bash
git clone git@github.com:hbjamin/casb-firmware.git
```
4. Go into the repository and checkout the appropriate branch. 
```bash
cd casb-firmware
git checkout <branch_name>
```
5. Source the Vivado environment and open Vivado from inside the firmware directory 
```bash
vivado_2023
cd firmware
vivado
```
7. Execute the provided script in the tcl console at the bottom of the screen
```tcl
source ./create_project.tcl
```
8. Generate the bitstream. This will take several minutes
9. Export the bitstream file to `casb-firmware/petalinux/casb_tester/` and name it `casb_tester.bit`
`File` --> `Export` --> `Export Bitstream`
10. Export the hardware file to `casb-firmware/petalinux/casb_tester/` and name it `casb_tester.xsa`
`File` --> `Export` --> `Export Hardware` --> 'Include Bitstream' 

### Part 2: Petalinux 
1. Install Petalinux by following `casb-firmware/tutorials/install-petalinux.md`
2. Setup Petalinux by following `casb-firmware/tutorials/setup-petalinux`
3. Build, package, and configure the Petalinux by following `casb-firmware/tutorials/build-petalinux` (split up)

### Part 3: Deploy 
If the z-turn is brand new and you need to partition the SD card before inserting it into the z-turn:
- Deploy the firmware by following `casb-firmware/tutorials/SDcards.md` 
If the z-turn SD card has already been partitioned, and you want to deploy the new firmware remotely:
- Follow the instructions in `casb-firmware/tutorials/deploy-firmware.md`


