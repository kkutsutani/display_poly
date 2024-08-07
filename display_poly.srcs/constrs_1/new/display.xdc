## Configuration options, can be used for all designs
set_property -dict {CONFIG_VOLTAGE 3.3 CFGBVS VCCO} [current_design];
set_property IOSTANDARD LVCMOS33 [get_port *];


## On-board CLK 100MHz
create_clock -name CLK -period 10 [get_nets CLK];
set_property PACKAGE_PIN W5 [get_port CLK];


## Push SW BTNC
set_property PACKAGE_PIN U18 [get_port RST];	#BTNC


## VGA Connector
set_property PACKAGE_PIN G19 [get_ports {RGB[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGB[8]}]
set_property PACKAGE_PIN H19 [get_ports {RGB[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGB[9]}]
set_property PACKAGE_PIN J19 [get_ports {RGB[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGB[10]}]
set_property PACKAGE_PIN N19 [get_ports {RGB[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGB[11]}]
set_property PACKAGE_PIN N18 [get_ports {RGB[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGB[0]}]
set_property PACKAGE_PIN L18 [get_ports {RGB[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGBgb[1]}]
set_property PACKAGE_PIN K18 [get_ports {RGB[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGB[2]}]
set_property PACKAGE_PIN J18 [get_ports {RGB[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGB[3]}]
set_property PACKAGE_PIN J17 [get_ports {RGB[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGB[4]}]
set_property PACKAGE_PIN H17 [get_ports {RGB[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGB[5]}]
set_property PACKAGE_PIN G17 [get_ports {RGB[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGB[6]}]
set_property PACKAGE_PIN D17 [get_ports {RGB[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGB[7]}]
set_property PACKAGE_PIN P19 [get_ports HSYNC]
set_property IOSTANDARD LVCMOS33 [get_ports HSYNC]
set_property PACKAGE_PIN R19 [get_ports VSYNC]
set_property IOSTANDARD LVCMOS33 [get_ports VSYNC]
