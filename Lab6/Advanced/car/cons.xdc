# Clock signal
set_property PACKAGE_PIN W5 [get_ports CLK]
    set_property IOSTANDARD LVCMOS33 [get_ports CLK]
    create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports CLK]

# ===========================================

# Switches

set_property PACKAGE_PIN V17 [get_ports {SW[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {SW[0]}]
set_property PACKAGE_PIN V16 [get_ports {SW[1]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {SW[1]}]
set_property PACKAGE_PIN W16 [get_ports {SW[2]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {SW[2]}]
set_property PACKAGE_PIN W17 [get_ports {SW[3]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {SW[3]}]
set_property PACKAGE_PIN W15 [get_ports {SW[4]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {SW[4]}]
set_property PACKAGE_PIN V15 [get_ports {SW[5]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {SW[5]}]
# set_property PACKAGE_PIN W14 [get_ports {SW[6]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {SW[6]}]
# set_property PACKAGE_PIN W13 [get_ports {SW[7]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {SW[7]}]
# set_property PACKAGE_PIN V2 [get_ports {SW[8]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {SW[8]}]
# set_property PACKAGE_PIN T3 [get_ports {SW[9]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {SW[9]}]
# set_property PACKAGE_PIN T2 [get_ports {SW[10]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {SW[10]}]
# set_property PACKAGE_PIN R3 [get_ports {SW[11]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {SW[11]}]
# set_property PACKAGE_PIN W2 [get_ports {SW[12]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {SW[12]}]
# set_property PACKAGE_PIN U1 [get_ports {SW[13]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {SW[13]}]
# set_property PACKAGE_PIN T1 [get_ports {SW[14]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {SW[14]}]
# set_property PACKAGE_PIN R2 [get_ports {SW[15]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {SW[15]}]

# Buttons

set_property PACKAGE_PIN U18 [get_ports BTNC]
    set_property IOSTANDARD LVCMOS33 [get_ports BTNC]
# set_property PACKAGE_PIN T18 [get_ports BTNU]
#     set_property IOSTANDARD LVCMOS33 [get_ports BTNU]
# set_property PACKAGE_PIN W19 [get_ports BTNL]
#     set_property IOSTANDARD LVCMOS33 [get_ports BTNL]
# set_property PACKAGE_PIN T17 [get_ports BTNR]
#     set_property IOSTANDARD LVCMOS33 [get_ports BTNR]
# set_property PACKAGE_PIN U17 [get_ports BTND]
#     set_property IOSTANDARD LVCMOS33 [get_ports BTND]


# LEDs

set_property PACKAGE_PIN U16 [get_ports {LED[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]
set_property PACKAGE_PIN E19 [get_ports {LED[1]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}]
set_property PACKAGE_PIN U19 [get_ports {LED[2]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}]
set_property PACKAGE_PIN V19 [get_ports {LED[3]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}]
set_property PACKAGE_PIN W18 [get_ports {LED[4]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[4]}]
set_property PACKAGE_PIN U15 [get_ports {LED[5]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[5]}]
set_property PACKAGE_PIN U14 [get_ports {LED[6]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[6]}]
set_property PACKAGE_PIN V14 [get_ports {LED[7]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[7]}]
set_property PACKAGE_PIN V13 [get_ports {LED[8]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[8]}]
set_property PACKAGE_PIN V3 [get_ports {LED[9]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[9]}]
set_property PACKAGE_PIN W3 [get_ports {LED[10]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[10]}]
set_property PACKAGE_PIN U3 [get_ports {LED[11]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[11]}]
set_property PACKAGE_PIN P3 [get_ports {LED[12]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[12]}]
set_property PACKAGE_PIN N3 [get_ports {LED[13]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[13]}]
set_property PACKAGE_PIN P1 [get_ports {LED[14]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[14]}]
set_property PACKAGE_PIN L1 [get_ports {LED[15]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[15]}]

# 7 segment display

set_property PACKAGE_PIN W7 [get_ports {SEGD[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {SEGD[0]}]
set_property PACKAGE_PIN W6 [get_ports {SEGD[1]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {SEGD[1]}]
set_property PACKAGE_PIN U8 [get_ports {SEGD[2]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {SEGD[2]}]
set_property PACKAGE_PIN V8 [get_ports {SEGD[3]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {SEGD[3]}]
set_property PACKAGE_PIN U5 [get_ports {SEGD[4]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {SEGD[4]}]
set_property PACKAGE_PIN V5 [get_ports {SEGD[5]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {SEGD[5]}]
set_property PACKAGE_PIN U7 [get_ports {SEGD[6]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {SEGD[6]}]
set_property PACKAGE_PIN V7 [get_ports {SEGD[7]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {SEGD[7]}]

set_property PACKAGE_PIN U2 [get_ports {SEGA[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {SEGA[0]}]
set_property PACKAGE_PIN U4 [get_ports {SEGA[1]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {SEGA[1]}]
set_property PACKAGE_PIN V4 [get_ports {SEGA[2]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {SEGA[2]}]
set_property PACKAGE_PIN W4 [get_ports {SEGA[3]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {SEGA[3]}]

# ===========================================

## Pmod Header JA

# set_property PACKAGE_PIN J1 [get_ports {JA1}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {JA1}]
# set_property PACKAGE_PIN L2 [get_ports {JA2}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {JA2}]
set_property PACKAGE_PIN J2 [get_ports {JA3}]
    set_property IOSTANDARD LVCMOS33 [get_ports {JA3}]
set_property PACKAGE_PIN G2 [get_ports {JA4}]
    set_property IOSTANDARD LVCMOS33 [get_ports {JA4}]

# set_property PACKAGE_PIN H1 [get_ports {JA7}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {JA7}]
# set_property PACKAGE_PIN K2 [get_ports {JA8}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {JA8}]
# set_property PACKAGE_PIN H2 [get_ports {JA9}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {JA9}]
# set_property PACKAGE_PIN G3 [get_ports {JA10}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {JA10}]

## Pmod Header JB

# set_property PACKAGE_PIN A14 [get_ports {JB1}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {JB1}]
set_property PACKAGE_PIN A16 [get_ports {JB2}]
    set_property IOSTANDARD LVCMOS33 [get_ports {JB2}]
set_property PACKAGE_PIN B15 [get_ports {JB3}]
    set_property IOSTANDARD LVCMOS33 [get_ports {JB3}]
set_property PACKAGE_PIN B16 [get_ports {JB4}]
    set_property IOSTANDARD LVCMOS33 [get_ports {JB4}]

# set_property PACKAGE_PIN A15 [get_ports {JB7]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {JB7}]
# set_property PACKAGE_PIN A17 [get_ports {JB8}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {JB8}]
# set_property PACKAGE_PIN C15 [get_ports {JB9}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {JB9}]
# set_property PACKAGE_PIN C16 [get_ports {JB10}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {JB10}]

## Pmod Header JC

set_property PACKAGE_PIN K17 [get_ports {JC1}]
    set_property IOSTANDARD LVCMOS33 [get_ports {JC1}]
set_property PACKAGE_PIN M18 [get_ports {JC2}]
    set_property IOSTANDARD LVCMOS33 [get_ports {JC2}]
set_property PACKAGE_PIN N17 [get_ports {JC3}]
    set_property IOSTANDARD LVCMOS33 [get_ports {JC3}]
# set_property PACKAGE_PIN P18 [get_ports {JC4}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {JC4}]

set_property PACKAGE_PIN L17 [get_ports {JC7}]
    set_property IOSTANDARD LVCMOS33 [get_ports {JC7}]
set_property PACKAGE_PIN M19 [get_ports {JC8}]
    set_property IOSTANDARD LVCMOS33 [get_ports {JC8}]
set_property PACKAGE_PIN P17 [get_ports {JC9}]
    set_property IOSTANDARD LVCMOS33 [get_ports {JC9}]
# set_property PACKAGE_PIN R18 [get_ports {JC10}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {JC10}]

## Pmod Header JXADC

# set_property PACKAGE_PIN J3 [get_ports {JX1P}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {JX1P}]
# set_property PACKAGE_PIN L3 [get_ports {JX2P}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {JX2P}]
# set_property PACKAGE_PIN M2 [get_ports {JX3P}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {JX3P}]
# set_property PACKAGE_PIN N2 [get_ports {JX4P}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {JX4P}]
#    set_property PULLUP true [get_ports JX4P]

# set_property PACKAGE_PIN K3 [get_ports {JX1N]
#    set_property IOSTANDARD LVCMOS33 [get_ports {JX1N}]
# set_property PACKAGE_PIN M3 [get_ports {JX2N}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {JX2N}]
# set_property PACKAGE_PIN M1 [get_ports {JX3N}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {JX3N}]
# set_property PACKAGE_PIN N1 [get_ports {JX4N}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {JX4N}]

# ===========================================

## VGA Connector

# set_property PACKAGE_PIN G19 [get_ports {VGAR[0]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {VGAR[0]}]
# set_property PACKAGE_PIN H19 [get_ports {VGAR[1]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {VGAR[1]}]
# set_property PACKAGE_PIN J19 [get_ports {VGAR[2]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {VGAR[2]}]
# set_property PACKAGE_PIN N19 [get_ports {VGAR[3]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {VGAR[3]}]
# set_property PACKAGE_PIN N18 [get_ports {VGAB[0]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {VGAB[0]}]
# set_property PACKAGE_PIN L18 [get_ports {VGAB[1]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {VGAB[1]}]
# set_property PACKAGE_PIN K18 [get_ports {VGAB[2]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {VGAB[2]}]
# set_property PACKAGE_PIN J18 [get_ports {VGAB[3]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {VGAB[3]}]
# set_property PACKAGE_PIN J17 [get_ports {VGAG[0]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {VGAG[0]}]
# set_property PACKAGE_PIN H17 [get_ports {VGAG[1]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {VGAG[1]}]
# set_property PACKAGE_PIN G17 [get_ports {VGAG[2]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {VGAG[2]}]
# set_property PACKAGE_PIN D17 [get_ports {VGAG[3]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {VGAG[3]}]
# set_property PACKAGE_PIN P19 [get_ports HSYNC]
#     set_property IOSTANDARD LVCMOS33 [get_ports HSYNC]
# set_property PACKAGE_PIN R19 [get_ports VSYNC]
#     set_property IOSTANDARD LVCMOS33 [get_ports VSYNC]

# ===========================================

## USB-FT2232 Interface
# set_property PACKAGE_PIN B18 [get_ports TXD]
#    set_property IOSTANDARD LVCMOS33 [get_ports TXD]
# set_property PACKAGE_PIN A18 [get_ports RXD]
#    set_property IOSTANDARD LVCMOS33 [get_ports RXD]


## USB HID (PS/2)
# set_property PACKAGE_PIN C17 [get_ports PS2_CLK]
#    set_property IOSTANDARD LVCMOS33 [get_ports PS2_CLK]
#    set_property PULLUP true [get_ports PS2_CLK]
# set_property PACKAGE_PIN B17 [get_ports PS2_DAT]
#    set_property IOSTANDARD LVCMOS33 [get_ports PS2_DAT]
#    set_property PULLUP true [get_ports PS2_DAT]


## Quad SPI Flash
## Note that CCLK_0 cannot be placed in 7 series devices. You can access it using the
## STARTUPE2 primitive.
# set_property PACKAGE_PIN D18 [get_ports {QSPI_D[0]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {QSPI_D[0]}]
# set_property PACKAGE_PIN D19 [get_ports {QSPI_D[1]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {QSPI_D[1]}]
# set_property PACKAGE_PIN G18 [get_ports {QSPI_D[2]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {QSPI_D[2]}]
# set_property PACKAGE_PIN F18 [get_ports {QSPI_D[3]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {QSPI_D[3]}]
# set_property PACKAGE_PIN K19 [get_ports QSPI_CSN]
#    set_property IOSTANDARD LVCMOS33 [get_ports QSPI_CSN]

## Don't Touch
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]

## where 3.3 is the voltage provided to configuration bank 0
set_property CONFIG_VOLTAGE 3.3 [current_design]
## where value1 is either VCCO(for Vdd=3.3) or GND(for Vdd=1.8)
set_property CFGBVS VCCO [current_design]
