# Bonus

### Address Editor
- `Window` --> `Address Editor`
Can see what doesn't have an address, right click then `assign` to auto-fix

### i2c addresses
AD7997-0 set AS pin to Vdd ----------------- 0100010 ---- 22
DAC6578-T set AD0 to GND and AD1 to GND ---- 1001000 ---- 48
DAC6578-W set AD0 to Vdd and AD1 to GND ---- 1001001 ---- 49
24AA025E48T set AD0, AD1, AD2 to Vdd ------- 1010000 ---- 50

47 = 1000111

### Adrian help stuck on sd card
- The board file specifies how to configure the zynq processor: certain features like clock, sd, eth, usb are designed to be output in a specific location in a specific way for a certain board.
- Previously had ddr disabled, which meant no memory location to boot from?
- Previously had no board file
- Did not add boot flag to partition
- Automate as much of the processor/reset stuff as possible


### Creating an application project from the platform
- `File` --> `New Component` --> `Application`
- Name it `casb_component` and make the location the Vivado working directory
- Choose the `casb_platform` just created as the platform
- Choose the `standalone_ps7_cortexa9_0` domain

### Create the main C source code that controls the AXI GPIO peripherals
- `casb_component` --> `Sources` --> right click on `src` --> `New File` and name it `main.c`

### Change in Vitis 2023.2 GPIO functionality
In Vitis 2023/2, device IDs for GPIO IP cores are no longer included in `xparameters.h`. Instead, the initialization of GPIOs is now done using their base addresses directly. For example this old code
```c
#include "xparameters.h"
#include "xil_printf.h"
#include "xgpio.h"
#include "xil_types.h"
 
// Get device IDs from xparameters.h
#define BTN_ID XPAR_AXI_GPIO_BUTTONS_DEVICE_ID
#define LED_ID XPAR_AXI_GPIO_LED_DEVICE_ID
#define BTN_CHANNEL 1
#define LED_CHANNEL 1
#define BTN_MASK 0b1111
#define LED_MASK 0b1111
 
int main() {
	XGpio_Config *cfg_ptr;
	XGpio led_device, btn_device;
	u32 data;
 
	xil_printf("Entered function main\r\n");
 
	// Initialize LED Device
	cfg_ptr = XGpio_LookupConfig(LED_ID);
	XGpio_CfgInitialize(&led_device, cfg_ptr, cfg_ptr->BaseAddress);
 
	// Initialize Button Device
	cfg_ptr = XGpio_LookupConfig(BTN_ID);
	XGpio_CfgInitialize(&btn_device, cfg_ptr, cfg_ptr->BaseAddress);
 
	// Set Button Tristate
	XGpio_SetDataDirection(&btn_device, BTN_CHANNEL, BTN_MASK);
 
	// Set Led Tristate
	XGpio_SetDataDirection(&led_device, LED_CHANNEL, 0);
 
	while (1) {
		data = XGpio_DiscreteRead(&btn_device, BTN_CHANNEL);
		data &= BTN_MASK;
		if (data != 0) {
			data = LED_MASK;
		} else {
			data = 0;
		}
		XGpio_DiscreteWrite(&led_device, LED_CHANNEL, data);
	}
}
```
now turns into this
```c
#include "xparameters.h"
#include "xil_printf.h"
#include "xgpio.h"
#include "xil_types.h"
 
// Get base addresses from xparameters.h
#define BTN_BASEADDR XPAR_AXI_GPIO_BUTTONS_BASEADDR
#define LED_BASEADDR XPAR_AXI_GPIO_LED_BASEADDR
#define BTN_CHANNEL 1
#define LED_CHANNEL 1
#define BTN_MASK 0b1111
#define LED_MASK 0b1111
 
int main() {
    XGpio_Config *cfg_ptr;
    XGpio led_device, btn_device;
    u32 data;
 
    xil_printf("Entered function main\r\n");
 
    // Initialize LED Device using base address
    cfg_ptr = XGpio_LookupConfig(LED_BASEADDR);
    if (cfg_ptr == NULL) {
        xil_printf("LED Device LookupConfig failed\r\n");
        return XST_FAILURE;
    }
    XGpio_CfgInitialize(&led_device, cfg_ptr, cfg_ptr->BaseAddress);
 
    // Initialize Button Device using base address
    cfg_ptr = XGpio_LookupConfig(BTN_BASEADDR);
    if (cfg_ptr == NULL) {
        xil_printf("Button Device LookupConfig failed\r\n");
        return XST_FAILURE;
    }
    XGpio_CfgInitialize(&btn_device, cfg_ptr, cfg_ptr->BaseAddress);
 
    // Set Button Tristate
    XGpio_SetDataDirection(&btn_device, BTN_CHANNEL, BTN_MASK);
 
    // Set LED Tristate
    XGpio_SetDataDirection(&led_device, LED_CHANNEL, 0);
 
    while (1) {
        data = XGpio_DiscreteRead(&btn_device, BTN_CHANNEL);
        data &= BTN_MASK;
        if (data != 0) {
            data = LED_MASK;
        } else {
            data = 0;
        }
        XGpio_DiscreteWrite(&led_device, LED_CHANNEL, data);
    }
}
```
The `xparameters.h` file now only defines base addresses rather than device IDs. This removes the uncessary itermediate step of translating a device ID to a base address. Instead of looking up GPIO configurations with a device ID, you use the GPIO's base address in functions like `XGpio_LookupConfig`


### Hello World Tutorial
- https://www.myirtech.com/download/Zynq7000/A_Hello_World_tutorial_for_Z-turn_Board.pdf

