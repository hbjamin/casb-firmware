# Central Analog Summing Board (CASB) Firmware
  
A repository for version control of the CASB firmware, created by B. Harris and based on similar work by A. Nikola (QPIX) and N. Barros (CTB).

## Related CASB Repositories
- [CASB Control](https://github.com/hbjamin/casb-control) - Software for programming the CASB and communicating with the DAQ
- [CASB Calibration](https://github.com/hbjamin/casb-calibration) - Storage and processing of CASB calibration test results

## Technical Overview

### Hardware Platform
- **Z-turn Board**: MYS-7Z020-V2
  - Built around Xilinx Zynq-7020 (XC7Z020) SoC
  - Combines dual-core ARM Cortex-A9 processor (PS) with Xilinx 7-series FPGA fabric (PL)
  - Chosen for its pin count, customizable logic capabilities, and reasonable price

### Development Tools
- **Firmware Development**: Vivado 2023.2
  - Creates configurable logic for trigger determination
  - Implements i2c bus and memory-mapped registers for channel masks
  - Outputs:
    - `.bit` file (programs the PL/FPGA)
    - `.xsa` file (contains hardware platform description)

- **Operating System**: PetaLinux 2023.2
  - Embedded Linux SDK for FPGA-based SoC designs
  - Automatically generates device trees and bootloaders from Vivado outputs
  - Outputs:
    - `BOOT.bin` (bootloaders + FPGA bitstream)
    - `boot.scr` (U-Boot script)
    - `image.ub` (Linux kernel + device tree)
    - `rootfs` (root filesystem)

## Development Workflow

1. Create a new branch from your experiment's main branch
2. Modify the Vivado project
3. Rebuild PetaLinux
4. Deploy to Z-turn board
5. Verify functionality
6. Submit a pull request to the experiment's main branch

## Branch Management

The repository maintains separate main branches for each experiment:
- `eos` - Latest stable version for Eos experiment

**IMPORTANT**: Never push changes directly to these main experiment branches. If you do I will turn into Liam Neeson from Taken.

## Building the Project

### Prerequisites
- Install Vivado (follow `tutorials/install-vivado.md`)
- Set up Vivado (follow `tutorials/setup-vivado.md`)
- Install PetaLinux (follow `tutorials/install-petalinux.md`)
- Set up PetaLinux (follow `tutorials/setup-petalinux.md`)

### Part 1: Vivado Build 
3. Clone this repository:
```bash
git clone git@github.com:hbjamin/casb-firmware.git
```
4. Checkout appropriate branch:
```bash
cd casb-firmware
git checkout <branch_name>
```
5. Open Vivado:
```bash
vivado_2023
cd firmware
vivado
```
6. Execute the project creation script:
```tcl
source ./create_project.tcl
```
7. Generate the bitstream

8. Export bitstream to `casb-firmware/petalinux/casb_tester/casb_tester.bit`
   - Click `File` → `Export` → `Export Bitstream`

9. Export hardware to `casb-firmware/petalinux/casb_tester/casb_tester.xsa` 
   - Click `File` → `Export` → `Export Hardware` → `Include bitstream`

### Part 2: PetaLinux Build
3. Build PetaLinux (follow `tutorials/build-petalinux.md`)

### Part 3: Deployment
- To deploy on a new SD card: Follow 'tutorials/deploy-new-sd.md'
- To manually deploy on an already partitioned SD card: Follow `tutorials/deploy-manual.md` 
- To remotely deploy on an already partitioned SD card: Follow `tutorials/deploy-remote.md`

## Making Changes

1. Start from your experiment's main branch:
```bash
git checkout <experiment_name>
```

2. Create a new feature branch:
```bash
git checkout -b <experiment_name+change_implemented>
```
3. Open `setup.tcl` and update the project name

4. Build the Vivado project (see "Part 1" of "Building the Project" section)

5. Make your changes

6. Build the PetaLinux project (see "Part 2" of "Building the Project" section)

7. Deploy the firmware (see "Part 3" of "Building the Project" section) 

7. Verify functionality

8. Update `Changelog.md` with your changes

9. Regenerate the board design:
- Open block design in Vivado
- Click `File` → `Export` → `Export Block Design`
- Export to `casb-firmware/firmware/src/bd`

10. Add board design (and constraints if modified) to git and commit:
```bash
git add casb-firmware/firmware/src/bd/casb.tcl
git add casb-firmware/firmware/src/constrs/top.xdc
git commit -m "Description of changes"
```

11. Verify you're on the correct branch: 
```bash
git branch
```

12. Push changes:
```bash
git push --set-upstream origin <your_branch_name>
```

13. Submit a pull request through GitHub
