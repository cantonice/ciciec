## Generated SDC file "ov7725_lcd.out.sdc"

## Copyright (C) 2018  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 18.0.0 Build 614 04/24/2018 SJ Standard Edition"

## DATE    "Tue Apr 16 13:17:30 2024"

##
## DEVICE  "EP4CE10F17C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {sys_clk} -period 20.000 -waveform { 0.000 10.000 } [get_ports {sys_clk}]
create_clock -name {cam_pclk} -period 1.000 -waveform { 0.000 0.500 } [get_ports {cam_pclk}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {u_pll_clk|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 2 -master_clock {sys_clk} [get_pins {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}] 
create_generated_clock -name {u_pll_clk|altpll_component|auto_generated|pll1|clk[1]} -source [get_pins {u_pll_clk|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 2 -phase -75.000 -master_clock {sys_clk} [get_pins {u_pll_clk|altpll_component|auto_generated|pll1|clk[1]}] 
create_generated_clock -name {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]} -source [get_pins {u_pll_clk|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 1 -master_clock {sys_clk} [get_pins {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}] 
create_generated_clock -name {ov7725_dri:u_ov7725_dri|i2c_dri:u_i2c_dri|dri_clk} -source [get_pins {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}] -divide_by 50 -master_clock {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]} [get_registers {ov7725_dri:u_ov7725_dri|i2c_dri:u_i2c_dri|dri_clk}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {ov7725_dri:u_ov7725_dri|i2c_dri:u_i2c_dri|dri_clk}] -rise_to [get_clocks {ov7725_dri:u_ov7725_dri|i2c_dri:u_i2c_dri|dri_clk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {ov7725_dri:u_ov7725_dri|i2c_dri:u_i2c_dri|dri_clk}] -fall_to [get_clocks {ov7725_dri:u_ov7725_dri|i2c_dri:u_i2c_dri|dri_clk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {ov7725_dri:u_ov7725_dri|i2c_dri:u_i2c_dri|dri_clk}] -rise_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {ov7725_dri:u_ov7725_dri|i2c_dri:u_i2c_dri|dri_clk}] -fall_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {ov7725_dri:u_ov7725_dri|i2c_dri:u_i2c_dri|dri_clk}] -rise_to [get_clocks {cam_pclk}] -setup 0.110  
set_clock_uncertainty -rise_from [get_clocks {ov7725_dri:u_ov7725_dri|i2c_dri:u_i2c_dri|dri_clk}] -rise_to [get_clocks {cam_pclk}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {ov7725_dri:u_ov7725_dri|i2c_dri:u_i2c_dri|dri_clk}] -fall_to [get_clocks {cam_pclk}] -setup 0.110  
set_clock_uncertainty -rise_from [get_clocks {ov7725_dri:u_ov7725_dri|i2c_dri:u_i2c_dri|dri_clk}] -fall_to [get_clocks {cam_pclk}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {ov7725_dri:u_ov7725_dri|i2c_dri:u_i2c_dri|dri_clk}] -rise_to [get_clocks {ov7725_dri:u_ov7725_dri|i2c_dri:u_i2c_dri|dri_clk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {ov7725_dri:u_ov7725_dri|i2c_dri:u_i2c_dri|dri_clk}] -fall_to [get_clocks {ov7725_dri:u_ov7725_dri|i2c_dri:u_i2c_dri|dri_clk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {ov7725_dri:u_ov7725_dri|i2c_dri:u_i2c_dri|dri_clk}] -rise_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {ov7725_dri:u_ov7725_dri|i2c_dri:u_i2c_dri|dri_clk}] -fall_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {ov7725_dri:u_ov7725_dri|i2c_dri:u_i2c_dri|dri_clk}] -rise_to [get_clocks {cam_pclk}] -setup 0.110  
set_clock_uncertainty -fall_from [get_clocks {ov7725_dri:u_ov7725_dri|i2c_dri:u_i2c_dri|dri_clk}] -rise_to [get_clocks {cam_pclk}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {ov7725_dri:u_ov7725_dri|i2c_dri:u_i2c_dri|dri_clk}] -fall_to [get_clocks {cam_pclk}] -setup 0.110  
set_clock_uncertainty -fall_from [get_clocks {ov7725_dri:u_ov7725_dri|i2c_dri:u_i2c_dri|dri_clk}] -fall_to [get_clocks {cam_pclk}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {ov7725_dri:u_ov7725_dri|i2c_dri:u_i2c_dri|dri_clk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {ov7725_dri:u_ov7725_dri|i2c_dri:u_i2c_dri|dri_clk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {cam_pclk}] -setup 0.110  
set_clock_uncertainty -rise_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {cam_pclk}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {cam_pclk}] -setup 0.110  
set_clock_uncertainty -rise_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {cam_pclk}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {ov7725_dri:u_ov7725_dri|i2c_dri:u_i2c_dri|dri_clk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {ov7725_dri:u_ov7725_dri|i2c_dri:u_i2c_dri|dri_clk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {cam_pclk}] -setup 0.110  
set_clock_uncertainty -fall_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {cam_pclk}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {cam_pclk}] -setup 0.110  
set_clock_uncertainty -fall_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {cam_pclk}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {cam_pclk}] -setup 0.110  
set_clock_uncertainty -rise_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {cam_pclk}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {cam_pclk}] -setup 0.110  
set_clock_uncertainty -rise_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {cam_pclk}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[2]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {cam_pclk}] -setup 0.110  
set_clock_uncertainty -fall_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {cam_pclk}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {cam_pclk}] -setup 0.110  
set_clock_uncertainty -fall_from [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {cam_pclk}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {cam_pclk}] -rise_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {cam_pclk}] -rise_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.110  
set_clock_uncertainty -rise_from [get_clocks {cam_pclk}] -fall_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {cam_pclk}] -fall_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.110  
set_clock_uncertainty -fall_from [get_clocks {cam_pclk}] -rise_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {cam_pclk}] -rise_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.110  
set_clock_uncertainty -fall_from [get_clocks {cam_pclk}] -fall_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {cam_pclk}] -fall_to [get_clocks {u_pll_clk|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.110  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_te9:dffpipe3|dffe4a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_se9:dffpipe3|dffe4a*}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

