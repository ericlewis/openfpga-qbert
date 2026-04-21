#
# user core constraints
#
# Keep the clk_74a PLL family synchronous. `derive_pll_clocks` in
# apf_constraints.sdc already creates the generated clocks for `mp1`.
#

derive_clock_uncertainty

set_clock_groups -asynchronous \
 -group [get_clocks {bridge_spiclk}] \
 -group [get_clocks {clk_74b}] \
 -group [get_clocks {clk_74a *|mp1|*}]
