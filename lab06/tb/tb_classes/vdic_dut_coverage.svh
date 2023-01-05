
class vdic_dut_coverage extends uvm_subscriber #(packet_s);
		`uvm_component_utils(vdic_dut_coverage)

//protected virtual vdic_dut_bfm bfm;
	
protected bit [7:0] [7:0] data_i ;
protected bit [3:0] size;
protected command_t cmd;
protected state_t STATE;

// Covergroup checking the op codes and their sequences
covergroup cmd_cov;

    option.name = "cg_cmd_cov";

    cmd_leg: coverpoint cmd {
        // #A1 test all operations
        bins A1_single_cycle[] = {[CMD_AND : CMD_SUB], CMD_NOP};

        // #A2 two operations in row
        bins A2_twoops[]       = ([CMD_NOP:CMD_SUB] [* 2]);
    }
    
    state_leg: coverpoint STATE{
	    
	    bins ResetBefore[] = (RESET => [NOP:SUB]);
	    
	    bins ResetAfter[] = ([NOP:SUB] => RESET);
	    
    }

endgroup	


// Covergroup checking for min and max arguments of the ALU
covergroup zeros_or_ones_on_cmd;

    option.name = "cg_zeros_or_ones_on_comm";

    all_cmd : coverpoint cmd {
	    bins cmd_set[] = {[CMD_AND:CMD_SUB]};
    }

    size_leg: coverpoint size{
        bins value[] = {['h01:'h09]};
    }

    data_0: coverpoint data_i[0] {
        bins zeros = {'h0};
        bins others= {['h1:'hE]};
        bins ones  = {'hFF};
    }
    
    data_1: coverpoint data_i[1] {
        bins zeros = {'h0};
        bins others= {['h1:'hFE]};
        bins ones  = {'hFF};
    }
    
    data_2: coverpoint data_i[2] {
        bins zeros = {'h0};
        bins others= {['h1:'hFE]};
        bins ones  = {'hFF};
    }
    
    data_3: coverpoint data_i[3] {
        bins zeros = {'h0};
        bins others= {['h1:'hFE]};
        bins ones  = {'hFF};
    }
    
    data_4: coverpoint data_i[4] {
        bins zeros = {'h0};
        bins others= {['h1:'hFE]};
        bins ones  = {'hFF};
    }
    
    data_5: coverpoint data_i[5] {
        bins zeros = {'h0};
        bins others= {['h1:'hFE]};
        bins ones  = {'hFF};
    }
    
    data_6: coverpoint data_i[6] {
        bins zeros = {'h0};
        bins others= {['h1:'hFE]};
        bins ones  = {'hFF};
    }
    
    data_7: coverpoint data_i[7] {
        bins zeros = {'h0};
        bins others= {['h1:'hFE]};
        bins ones  = {'hFF};
    }
    

    B1_op_00_FF: cross size_leg, data_0, data_1, all_cmd {

        // #B1 simulate all zero or one input for all operations for all two data words

        bins B1_add_00          = binsof (all_cmd) intersect {CMD_ADD} && binsof (size_leg) intersect {2} && 
        (binsof (data_0.zeros) && binsof (data_1.zeros));
	    
	    bins B1_and_00          = binsof (all_cmd) intersect {CMD_AND} && binsof (size_leg) intersect {2} && 
        (binsof (data_0.zeros) && binsof (data_1.zeros));
	    
	    bins B1_or_00          = binsof (all_cmd) intersect {CMD_OR} && binsof (size_leg) intersect {2} && 
        (binsof (data_0.zeros) && binsof (data_1.zeros));
	    
	    bins B1_xor_00          = binsof (all_cmd) intersect {CMD_XOR} && binsof (size_leg) intersect {2} && 
        (binsof (data_0.zeros) && binsof (data_1.zeros));
	    
	    bins B1_sub_00          = binsof (all_cmd) intersect {CMD_SUB} && binsof (size_leg) intersect {2} && 
        (binsof (data_0.zeros) && binsof (data_1.zeros));
//------------ ones	    
	    bins B1_add_11          = binsof (all_cmd) intersect {CMD_ADD} && binsof (size_leg) intersect {2} && 
        (binsof (data_0.ones) && binsof (data_1.ones));
	    
	    bins B1_and_11          = binsof (all_cmd) intersect {CMD_AND} && binsof (size_leg) intersect {2} && 
        (binsof (data_0.ones) && binsof (data_1.ones));
	    
	    bins B1_or_11          = binsof (all_cmd) intersect {CMD_OR} && binsof (size_leg) intersect {2} && 
        (binsof (data_0.ones) && binsof (data_1.ones));
	    
	    bins B1_xor_11          = binsof (all_cmd) intersect {CMD_XOR} && binsof (size_leg) intersect {2} && 
        (binsof (data_0.ones) && binsof (data_1.ones));
	    
	    bins B1_sub_11          = binsof (all_cmd) intersect {CMD_SUB} && binsof (size_leg) intersect {2} && 
        (binsof (data_0.ones) && binsof (data_1.ones));
	    
	    ignore_bins others 		= binsof(size_leg) intersect{0,1,[3:9]} || ( (!binsof(data_0.ones) || !binsof(data_1.ones) ) && (!binsof(data_0.zeros) || !binsof(data_1.zeros)) ) ;    
	    }
	    
	B2_op_00_FF: cross size_leg, data_0, data_1, data_2, all_cmd {   
		
		//B2 - all zero or ones for all commands for 3 data words
	    bins B2_add_00          = binsof (all_cmd) intersect {CMD_ADD} && binsof (size_leg) intersect {3} && 
        (binsof (data_0.zeros) && binsof (data_1.zeros) && binsof (data_2.zeros));
		
		bins B2_and_00          = binsof (all_cmd) intersect {CMD_AND} && binsof (size_leg) intersect {3} && 
        (binsof (data_0.zeros) && binsof (data_1.zeros) && binsof (data_2.zeros));
		
		bins B2_or_00          = binsof (all_cmd) intersect {CMD_OR} && binsof (size_leg) intersect {3} && 
        (binsof (data_0.zeros) && binsof (data_1.zeros) && binsof (data_2.zeros));
		
		bins B2_xor_00          = binsof (all_cmd) intersect {CMD_XOR} && binsof (size_leg) intersect {3} && 
        (binsof (data_0.zeros) && binsof (data_1.zeros) && binsof (data_2.zeros));
		
		bins B2_sub_00          = binsof (all_cmd) intersect {CMD_SUB} && binsof (size_leg) intersect {3} && 
        (binsof (data_0.zeros) && binsof (data_1.zeros) && binsof (data_2.zeros));
//------------ ones	    
	    bins B2_add_11          = binsof (all_cmd) intersect {CMD_ADD} && binsof (size_leg) intersect {3} && 
        (binsof (data_0.ones) && binsof (data_1.ones) && binsof (data_2.ones));
		
		bins B2_and_11          = binsof (all_cmd) intersect {CMD_AND} && binsof (size_leg) intersect {3} && 
        (binsof (data_0.ones) && binsof (data_1.ones) && binsof (data_2.ones));
		
		bins B2_or_11          = binsof (all_cmd) intersect {CMD_OR} && binsof (size_leg) intersect {3} && 
        (binsof (data_0.ones) && binsof (data_1.ones) && binsof (data_2.ones));
		
		bins B2_xor_11          = binsof (all_cmd) intersect {CMD_XOR} && binsof (size_leg) intersect {3} && 
        (binsof (data_0.ones) && binsof (data_1.ones) && binsof (data_2.ones));
		
		bins B2_sub_11          = binsof (all_cmd) intersect {CMD_SUB} && binsof (size_leg) intersect {3} && 
        (binsof (data_0.ones) && binsof (data_1.ones) && binsof (data_2.ones));
		
		ignore_bins others 		= binsof(size_leg) intersect{[0:2],[4:9]} || ( (!binsof(data_0.ones) || !binsof(data_1.ones) || !binsof(data_2.ones)) && (!binsof(data_0.zeros) || !binsof(data_1.zeros) || !binsof(data_2.zeros)) ) ;
	}
	    
	    
	    /*
	    bins B2_add_00          = binsof (all_cmd) intersect {CMD_ADD} && binsof (size_leg) intersect {3} && 
        (binsof (data_0.zeros) && binsof (data_1.zeros) && binsof (data_2.zeros));
	    
	    bins B3_add_00          = binsof (all_cmd) intersect {CMD_ADD} && binsof (size_leg) intersect {4} && 
        (binsof (data_0.zeros) && binsof (data_1.zeros) && binsof (data_2.zeros) && binsof (data_3.zeros));
	    
	    bins B4_add_00          = binsof (all_cmd) intersect {CMD_ADD} && binsof (size_leg) intersect {5} && 
        (binsof (data_0.zeros) && binsof (data_1.zeros) && binsof (data_2.zeros) && binsof (data_3.zeros) && binsof (data_4.zeros));
	    
	    bins B5_add_00          = binsof (all_cmd) intersect {CMD_ADD} && binsof (size_leg) intersect {6} && 
        (binsof (data_0.zeros) && binsof (data_1.zeros) && binsof (data_2.zeros) && binsof (data_3.zeros) && binsof (data_4.zeros) && binsof (data_5.zeros));
	    
	    bins B6_add_00          = binsof (all_cmd) intersect {CMD_ADD} && binsof (size_leg) intersect {7} && 
        (binsof (data_0.zeros) && binsof (data_1.zeros) && binsof (data_2.zeros) && binsof (data_3.zeros) && binsof (data_4.zeros) && binsof (data_5.zeros) && binsof (data_6.zeros));
	       
	    bins B7_add_00          = binsof (all_cmd) intersect {CMD_ADD} && binsof (size_leg) intersect {8} && 
        (binsof (data_0.zeros) && binsof (data_1.zeros) && binsof (data_2.zeros) && binsof (data_3.zeros) && binsof (data_4.zeros) && binsof (data_5.zeros) && binsof (data_6.zeros) && binsof (data_7.zeros));
	    
	    bins B8_add_00          = binsof (all_cmd) intersect {CMD_ADD} && binsof (size_leg) intersect {9} && 
        (binsof (data_0.zeros) && binsof (data_1.zeros) && binsof (data_2.zeros) && binsof (data_3.zeros) && binsof (data_4.zeros) && binsof (data_5.zeros) && binsof (data_6.zeros) && binsof (data_7.zeros) && binsof (data_8.zeros));
	    
	    
	    
	    
		ignore_bins others 		= binsof (data_0.others) || binsof (data_1.others) || binsof (data_2.zeros) || binsof (data_3.zeros) || binsof (data_4.zeros) || binsof (data_5.zeros) || binsof (data_6.zeros) || binsof (data_7.zeros) || binsof (data_8.zeros);
*/
        

endgroup

//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------
    function new (string name, uvm_component parent);
        super.new(name, parent);
		cmd_cov = new();
	    zeros_or_ones_on_cmd = new();
    endfunction : new
    
//------------------------------------------------------------------------------
// subscriber write function
//------------------------------------------------------------------------------
    function void write(packet_s t);
        data_i   = t.data;
        cmd      = t.cmd;
        size     = t.size;
	    STATE 	 = t.state;
        cmd_cov.sample();
        zeros_or_ones_on_cmd.sample();
    endfunction : write


endclass