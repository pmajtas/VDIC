
class vdic_dut_scoreboard extends uvm_component;
    `uvm_component_utils(vdic_dut_scoreboard)
		
protected virtual vdic_dut_bfm bfm;
protected test_result_t tr = TEST_PASSED;

//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new


//------------------------------------------------------------------------------
// print the PASSED/FAILED in color
//------------------------------------------------------------------------------
    protected function void print_test_result (test_result_t r);
        if(tr == TEST_PASSED) begin
            set_print_color(COLOR_BOLD_BLACK_ON_GREEN);
            $write ("-----------------------------------\n");
            $write ("----------- Test PASSED -----------\n");
            $write ("-----------------------------------");
            set_print_color(COLOR_DEFAULT);
            $write ("\n");
        end
        else begin
            set_print_color(COLOR_BOLD_BLACK_ON_RED);
            $write ("-----------------------------------\n");
            $write ("----------- Test FAILED -----------\n");
            $write ("-----------------------------------");
            set_print_color(COLOR_DEFAULT);
            $write ("\n");
        end
    endfunction
    
//------------------------------------------------------------------------------
// calculate expected result
//------------------------------------------------------------------------------
protected function logic [15:0] get_expected();
    bit [15:0] ret, tmp;
	bit [31:0] size_q;
	bit [7:0] data;
	command_t cmd_set;
    `ifdef DEBUG
    $display("%0t DEBUG: get_expected(%0d,%0d,%0d)",$time, A, B, op_set);
    `endif
    
	cmd_set = bfm.cmd;
	ret[7:0] = bfm.data_i[0];
	
	if (cmd_set == CMD_NOP && bfm.size == 1) begin
		ret = 0;
	end
	else begin
		ret = ret;
	end
    for (int i=1; i<bfm.size; i++) begin
		data = bfm.data_i[i];
	    
	    case(cmd_set[7:0])
	        CMD_ADD : ret  = ret + data;  
	        CMD_AND : ret  = ret & data;
		    CMD_OR  : ret  = ret | data;
		    CMD_XOR : ret  = ret ^ data;
		    CMD_SUB : ret  = ret - data;
		    CMD_NOP : ret = 0;
		    
	        default: begin
	            $display("%0t INTERNAL ERROR. get_expected: unexpected case argument: %s", $time, cmd_set);
	            return -1;
	        end
	    endcase
	end  
    return(ret);
endfunction : get_expected

//------------------------------------------------------------------------------
// build phase
//------------------------------------------------------------------------------
    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(virtual vdic_dut_bfm)::get(null, "*","bfm", bfm))
            $fatal(1,"Failed to get BFM");
    endfunction : build_phase
    
    
    
//------------------------------------------------------------------------------
// scoreboard
//------------------------------------------------------------------------------
task run_phase(uvm_phase phase);
	bit [15:0] expected = 0;
	tr = TEST_PASSED;
	forever begin : scoreboard
		@(negedge bfm.clk)
		@(negedge bfm.dout_valid);
		while(bfm.dout_valid)@(negedge bfm.clk);
		    if(!bfm.dout_valid) begin:verify_result
			    expected = 0;
			    expected = get_expected();
			    CHK_RESULT: assert({bfm.data1_o,bfm.data2_o} === expected) begin
		           `ifdef DEBUG
		            $display("%0t Test passed for A=%0d B=%0d op_set=%0d", $time, A, B, op);
		           `endif
		    end
		    else begin
		        $error("%0t Test FAILED for cmd_set=%0s\nExpected: %h  received: %h",
		             $time, bfm.cmd.name()  ,expected, {bfm.data1_o,bfm.data2_o} );
			    tr = TEST_FAILED;
		    end;
	    end
    end
endtask : run_phase
	
//------------------------------------------------------------------------------
// report phase
//------------------------------------------------------------------------------
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        print_test_result(tr);
    endfunction : report_phase	
	
endclass