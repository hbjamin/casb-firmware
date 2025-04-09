
# Creating a "Hello World!" project on the zturn via JTAG

### My Setup
- Board: `MYS-7Z020-V2`
- Vivado: `2023.2`
- OS: `Ubuntu 22.04.04 LTS`

### Instructions
- Open Vivado
```bash
vivado_2023
vivado
```
- Create Project
- RTL Project
- Change Target Lanugage to `VHDL`
- Skip Add Sources
- Skip Add Constraints
- Choose part `xc7z020clg400-1`
- Choose board `mys-7z020:part0:2.1`
    - https://github.com/q3k/zturn-stuff/tree/master
    - copy 'board_files` to `/opt/Xilinix/Vivado/2023.2/data/boards/`
 
### Correct Processor Configuration
- To configure the I2C SDA and SCL lines on your custom PL I/O pins (IO_L4P_T0_35 for SDA and IO_L4N_T0_35 for SCL), you'll need to disable the default MIO I2C configuration in the Zynq Processing System (PS) and route the I2C signals through the EMIO interface
- Disable `TTC0`

### Create and configure the processor system
- When Vivado opens, in the flow navigator pane (left) click on `create block design`
- An empty diagram opens, click `+` to add an IP called `ZYNQ7 Processing System` and then double click on the block to configure it
- `PS-PL` --> `General` --> `UART1 Baud Rate` should be 115200
- `PS-PL` --> `General` --> `Enable Clock Resets` --> `FCLK_RESET0_N` should be disabled
- `PS-PL` --> `AXI Non Secure Enablement` --> `GP Master AXI Interface` --> `M AXI GP0 interface` should be disabled
- Under `Peripheral I/O Pins` only `UART 1` should be enabled. Do this by clicking on the `UART 1` button **under column 48-49**
- Under `Peripheral I/O Pins` set `Bank 0` to 3.3V and `Bank 1` to 1.8V
- Under `MIO Configuration` --> `I/O Peripherals` make sure everything is diabled expcept `UART 1` and the Bank voltages are correct.
- `Clock Configuration` --> `Input Frequency` should be 33.333 MHz
- `Clock Configuration` --> `Processor/Memory Clocks` --> `CPU` should have `ARM PLL` clock source
- `Clock Configuration` --> `PL Fabric Clocks` --> `FCLK_CLK0` should be disabled
- `DDR Configuration` --> `Enable DDR` should be disabled
- Under `Interrupts` ensure everything is diabled
- The `processing_system7_0` block should have shrunk to one output
- Click the `+` to expand
- Right click the three lines next to `FIXED_IO` and select `Make External`
- Hit `F6` to check for errors 
- `Sources` --> `Design Sources` --> right click on `.bd` and select `Generate Output Products`
- Choose the `Global` synthesis option and then generate. This will updat the heirarchy in the sources pannel

### Wrap up the design with HDL
- `Sources` --> `Design Sources` --> right clock on `.bd` and select `Create HDL Wrapper`
- In the pop-up window select `Let Vivado`
- There is now a VHDL top file that instantiates our design
- `Run Synthesis` (convert VHDL into netlist of logic gates)
- `Implement` (prepare netlist of logic gates for loading onto FPGA)
- `Generate Bitstream` (create binary file that configures FPGA)
- `File` --> `Export` --> `Export Hardware` --> `Include bitstream` and export `casb_wrapper.xsa` to project directory 

### Start the software application in Vitis
- `Tools` --> `Launch Vitis IDE` 
- Make the Vitis workspace the same as Vivado

### Vitis Platform vs. Appllication 
- A `platform` in Vitis is the hardware abstraction layer on which your application runs. It defines the hardware environment and the software drivers necessary to interact with that hardware.
- An `application` in Vitis refers to the software that runs on the platform. It is the end-user code that you develop to achieve a specific function, like image processing, machine learning inference, or signal processing.

### Creating a platform component from HDL wrapper 
- `File` --> `New Component` --> `Platform`
- Name it `casb_platform` and make the location the Vivado working directory
- `Browse` --> `casb_wrapper.xsa`
- Set operating system to `standalone`, processor to `ps7_cortexa9_0`, and enable `Generate Boot artifacts`

### Creating an application project from the platform using a template
- `Examples` --> `Hello World` --> `Create Application Component from Template`
- Name it `hello_world` and make the location the Vivado working directory
- Select `casb_platform` as the platform
- Select `standalone_ps7_cortexa9_0` as the domain
- Use this code for `hello_world.c` instead:
```c
#include <stdio.h>
#include "platform.h"
int main()
{
    init_platform();
    printf("Hello World\n\r");
    printf("Successfully ran Hello World application");
    cleanup_platform();
    return 0;
}
```

### Build and run the application
- `Flow` -->`Build`
- Power the Z-turn by connecting USB cable to `USB_UART (the blue LED should be on)
- Connect JTAG cable to J1 on the ZTURN
- Jump P1 but not P2 to turn on boot via JTAG mode
```txt
pin 2 = VREF
pin 4 = TMS
pin 6 = TCK
pin 8 = TDO
pin 10 = TDI
pin 1/3/5/7/9/11 = GND
```
- Board initialization set to `TCL`
- Disable `Reset APU`
- Disable `Enable Cross Triggering`
- In terminal run
`sudo screen /dev/ttyUSB0 115200`
- `Flow` --> `Run`
- Should see output via screen

