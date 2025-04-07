################
###  CLOCK   ###
################

#create_clock -name FCLK_CLK0 -period 10.000 [get_nets FCLK_CLK0]

################
###  SWITCHES   ###
################

# CH 0
set_property PACKAGE_PIN U15 [get_ports reg_rw[0]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rw[0]]
# CH 1
set_property PACKAGE_PIN U14 [get_ports reg_rw[1]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rw[1]]
# CH 2
set_property PACKAGE_PIN Y14 [get_ports reg_rw[2]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rw[2]]
# CH 3
set_property PACKAGE_PIN W14 [get_ports reg_rw[3]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rw[3]]
# CH 4
set_property PACKAGE_PIN P14 [get_ports reg_rw[4]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rw[4]]
# CH 5
set_property PACKAGE_PIN W13 [get_ports reg_rw[5]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rw[5]]
# CH 6
set_property PACKAGE_PIN V12 [get_ports reg_rw[6]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rw[6]]
# CH 7
set_property PACKAGE_PIN U12 [get_ports reg_rw[7]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rw[7]]
# CH 8
set_property PACKAGE_PIN T12 [get_ports reg_rw[8]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rw[8]]
# CH 9
set_property PACKAGE_PIN W8 [get_ports reg_rw[9]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rw[9]]
# CH 10
set_property PACKAGE_PIN V8 [get_ports reg_rw[10]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rw[10]]
# CH 11
set_property PACKAGE_PIN Y6 [get_ports reg_rw[11]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rw[11]]
# CH 12
set_property PACKAGE_PIN Y7 [get_ports reg_rw[12]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rw[12]]
# CH 13
set_property PACKAGE_PIN U10 [get_ports reg_rw[13]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rw[13]]
# CH 14
set_property PACKAGE_PIN T9 [get_ports reg_rw[14]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rw[14]]
# CH 15
set_property PACKAGE_PIN V7 [get_ports reg_rw[15]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rw[15]]
# CH 16
set_property PACKAGE_PIN U7 [get_ports reg_rw[16]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rw[16]]
# CH 17
set_property PACKAGE_PIN T10 [get_ports reg_rw[17]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rw[17]]
# CH 18
set_property PACKAGE_PIN U13 [get_ports reg_rw[18]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rw[18]]
# CH 19
set_property PACKAGE_PIN V13 [get_ports reg_rw[19]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rw[19]]

################
###   LVDS   ###
################

### INPUTS ###

# High comparator input (swapped?)
set_property PACKAGE_PIN L16 [get_ports high_p_in]
set_property IOSTANDARD LVDS_25 [get_ports high_p_in]
set_property DIFF_TERM TRUE [get_ports high_p_in]
set_property INVERT TRUE [get_ports high_p_in]


set_property PACKAGE_PIN L17 [get_ports high_n_in]
set_property IOSTANDARD LVDS_25 [get_ports high_n_in]
set_property DIFF_TERM TRUE [get_ports high_n_in]

# Medium comparator input
set_property PACKAGE_PIN L19 [get_ports med_p_in]
set_property IOSTANDARD LVDS_25 [get_ports med_p_in]
set_property DIFF_TERM TRUE [get_ports med_p_in]

set_property PACKAGE_PIN L20 [get_ports med_n_in]
set_property IOSTANDARD LVDS_25 [get_ports med_n_in]
set_property DIFF_TERM TRUE [get_ports med_n_in]

# Low comparator input (swapped?)
set_property PACKAGE_PIN M19 [get_ports low_p_in]
set_property IOSTANDARD LVDS_25 [get_ports low_p_in]
set_property DIFF_TERM TRUE [get_ports low_p_in]
set_property INVERT TRUE [get_ports low_p_in]


set_property PACKAGE_PIN M20 [get_ports low_n_in]
set_property IOSTANDARD LVDS_25 [get_ports low_n_in]
set_property DIFF_TERM TRUE [get_ports low_p_in]

# Time over threshold comparator input
set_property PACKAGE_PIN E18 [get_ports tot_p_in]
set_property IOSTANDARD LVDS_25 [get_ports tot_p_in]
set_property DIFF_TERM TRUE [get_ports tot_p_in]

set_property PACKAGE_PIN E19 [get_ports tot_n_in]
set_property IOSTANDARD LVDS_25 [get_ports tot_n_in]
set_property DIFF_TERM TRUE [get_ports tot_n_in]

# Attenuated time over threshold comparator input
set_property PACKAGE_PIN E17 [get_ports attn_tot_p_in]
set_property IOSTANDARD LVDS_25 [get_ports attn_tot_p_in]

set_property PACKAGE_PIN D18 [get_ports attn_tot_n_in]
set_property IOSTANDARD LVDS_25 [get_ports attn_tot_n_in]

### OUTPUTS ###
# (don't forget to add LEDs)

# High comparator output
set_property PACKAGE_PIN F16 [get_ports high_p_out]
set_property IOSTANDARD LVDS_25 [get_ports high_p_out]

set_property PACKAGE_PIN F17 [get_ports high_n_out]
set_property IOSTANDARD LVDS_25 [get_ports high_n_out]

set_property PACKAGE_PIN B19 [get_ports high_out]
set_property IOSTANDARD LVCMOS25 [get_ports high_out]

# Medium comparator output
set_property PACKAGE_PIN K19 [get_ports med_p_out]
set_property IOSTANDARD LVDS_25 [get_ports med_p_out]

set_property PACKAGE_PIN J19 [get_ports med_n_out]
set_property IOSTANDARD LVDS_25 [get_ports med_n_out]

set_property PACKAGE_PIN A20 [get_ports med_out]
set_property IOSTANDARD LVCMOS25 [get_ports med_out]

# Low comparator output
set_property PACKAGE_PIN K17 [get_ports low_p_out]
set_property IOSTANDARD LVDS_25 [get_ports low_p_out]

set_property PACKAGE_PIN K18 [get_ports low_n_out]
set_property IOSTANDARD LVDS_25 [get_ports low_n_out]

set_property PACKAGE_PIN C20 [get_ports low_out]
set_property IOSTANDARD LVCMOS25 [get_ports low_out]

# Time over threshold comparator output
set_property PACKAGE_PIN G17 [get_ports tot_p_out]
set_property IOSTANDARD LVDS_25 [get_ports tot_p_out]

set_property PACKAGE_PIN G18 [get_ports tot_n_out]
set_property IOSTANDARD LVDS_25 [get_ports tot_n_out]

set_property PACKAGE_PIN D19 [get_ports tot_out]
set_property IOSTANDARD LVCMOS25 [get_ports tot_out]

# Attenuated time over threshold comparator output
set_property PACKAGE_PIN G19 [get_ports attn_tot_p_out]
set_property IOSTANDARD LVDS_25 [get_ports attn_tot_p_out]

set_property PACKAGE_PIN G20 [get_ports attn_tot_n_out]
set_property IOSTANDARD LVDS_25 [get_ports attn_tot_n_out]

# Typo in datasheet, use schematic and match L1N_T0_35
set_property PACKAGE_PIN B20 [get_ports attn_tot_out]
set_property IOSTANDARD LVCMOS25 [get_ports attn_tot_out]

################
###   i2c    ###
################

# USUALLY I2C IS ROUTED THROUGH MIO PINS
# WE ARE USING PL PINS ON BANK 13 @ 3.3V

# I2C SDA (Data) pin mapping for EMIO
set_property PACKAGE_PIN Y9 [get_ports i2c0_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports i2c0_sda_io]]

# I2C SCL (Clock) pin mapping for EMIO
set_property PACKAGE_PIN Y8 [get_ports i2c0_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports i2c0_scl_io]

