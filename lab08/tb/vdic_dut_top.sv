module vdic_dut_top;
import uvm_pkg::*;
`include "uvm_macros.svh"
import vdic_dut_pkg::*;
	
vdic_dut_bfm class_bfm();	
	
vdic_dut_2022 class_DUT (.clk(class_bfm.clk), .rst_n(class_bfm.rst_n),
				.enable_n(class_bfm.enable_n), .din(class_bfm.din),
				.dout(class_bfm.dout), .dout_valid(class_bfm.dout_valid));
	

vdic_dut_bfm module_bfm();	
	
vdic_dut_2022 module_DUT (.clk(module_bfm.clk), .rst_n(module_bfm.rst_n),
				.enable_n(module_bfm.enable_n), .din(module_bfm.din),
				.dout(module_bfm.dout), .dout_valid(module_bfm.dout_valid));
	

// stimulus generator for module_dut
vdic_dut_tester_module stim_module(module_bfm);

initial begin
	uvm_config_db #(virtual vdic_dut_bfm)::set(null, "*", "class_bfm", class_bfm);
	uvm_config_db #(virtual vdic_dut_bfm)::set(null, "*", "module_bfm", module_bfm);
    run_test("vdic_dut_dual_test");
end 
	
endmodule 