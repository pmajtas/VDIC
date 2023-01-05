module vdic_dut_top;
import uvm_pkg::*;
`include "uvm_macros.svh"
import vdic_dut_pkg::*;
	
vdic_dut_bfm bfm();	
	
vdic_dut_2022 DUT (.clk(bfm.clk), .rst_n(bfm.rst_n),
				.enable_n(bfm.enable_n), .din(bfm.din),
				.dout(bfm.dout), .dout_valid(bfm.dout_valid));
	
	
initial begin
	uvm_config_db #(virtual vdic_dut_bfm)::set(null, "*", "bfm", bfm);
    run_test();
end 
	
endmodule 