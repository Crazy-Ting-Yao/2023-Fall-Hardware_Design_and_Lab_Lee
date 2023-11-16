# Clock signal
set_property PACKAGE_PIN W5 [get_ports CLK]							
    set_property IOSTANDARD LVCMOS33 [get_ports CLK]
    create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports CLK]	


#USB HID (PS/2)
set_property PACKAGE_PIN C17 [get_ports PS2_CLK]						
	set_property IOSTANDARD LVCMOS33 [get_ports PS2_CLK]
	set_property PULLUP true [get_ports PS2_CLK]
set_property PACKAGE_PIN B17 [get_ports PS2_DAT]					
	set_property IOSTANDARD LVCMOS33 [get_ports PS2_DAT]	
	set_property PULLUP true [get_ports PS2_DAT]


# Pmod Header JB
# Sch name = JB1
set_property PACKAGE_PIN A14 [get_ports AUD_SIG]
    set_property IOSTANDARD LVCMOS33 [get_ports AUD_SIG]
# Sch name = JB2
set_property PACKAGE_PIN A16 [get_ports AUD_GAIN]
    set_property IOSTANDARD LVCMOS33 [get_ports AUD_GAIN]
# Sch name = JB3
# set_property PACKAGE_PIN B15 [get_ports ]
    # set_property IOSTANDARD LVCMOS33 [get_ports ]
# Sch name = JB4
set_property PACKAGE_PIN B16 [get_ports AUD_SHUT]
set_property IOSTANDARD LVCMOS33 [get_ports AUD_SHUT]


##Buttons
#btnC
set_property PACKAGE_PIN U18 [get_ports BTNC]
    set_property IOSTANDARD LVCMOS33 [get_ports BTNC]
#btnU
set_property PACKAGE_PIN T18 [get_ports BTNU]
    set_property IOSTANDARD LVCMOS33 [get_ports BTNU]
#btnL
#set_property PACKAGE_PIN W19 [get_ports BTNL]
    # set_property IOSTANDARD LVCMOS33 [get_ports BTNL]
#btnR
set_property PACKAGE_PIN T17 [get_ports BTNR]
    set_property IOSTANDARD LVCMOS33 [get_ports BTNR]
#btnD
set_property PACKAGE_PIN U17 [get_ports BTND]
    set_property IOSTANDARD LVCMOS33 [get_ports BTND]


## Quad SPI Flash
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
