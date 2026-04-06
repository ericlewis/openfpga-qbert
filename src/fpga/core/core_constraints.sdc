#
# user core constraints
#
# keep internal closure separate from external APF/Pocket board I/O timing.
#

derive_clock_uncertainty

set_clock_groups -asynchronous \
 -group [get_clocks {bridge_spiclk}] \
 -group [get_clocks {clk_74a}] \
 -group [get_clocks {clk_74b}] \
 -group [get_clocks {*|mp1|*}]

# Ignore unconstrained package-boundary I/O timing. These ports do not have an
# external timing contract in this project, so closure should focus on internal
# reg-to-reg timing.
set pocket_io_ports [remove_from_collection [get_ports *] [get_ports {clk_74a clk_74b bridge_spiclk}]]
set_false_path -from $pocket_io_ports
set_false_path -to $pocket_io_ports
