# How to actually control pins

- Open Vivado project
- `Window` --> `Address Editor`
- Find i2c peripheral named `axi_iic`
- Record the `Master Base Address` and `Range` = 0x4160_0000 & 64k


- Tools --> Vitis
- Create new platform project
- Hardware design --> Browse --> select casb_tester.xsa
- Create new application prject
- Use previously created iic platform


### All device tree stuff was just problems related to sudo
```bash
petalinux-config -p casb.linux/ -c rootfs
`PetaLinux RootFS Settings` --> `Add Users to Sudo users` --> enter default `petalinux` user
```

### Infinite i2c addresses connected
- SDA and SCL pin mapping swapped in Vivado
