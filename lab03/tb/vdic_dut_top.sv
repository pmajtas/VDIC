module vdic_dut_top;
vdic_dut_bfm bfm();	

tester tester_i (bfm);
vdic_dut_coverage coverage_i (bfm);
vdic_dut_scoreboard scoreboard_i(bfm);
	
vdic_dut_2022 DUT (.clk(bfm.clk), .rst_n(bfm.rst_n),
				.enable_n(bfm.enable_n), .din(bfm.din),
				.dout(bfm.dout), .dout_valid(bfm.dout_valid));
	
endmodule 