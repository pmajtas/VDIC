
class vdic_dut_scoreboard;
		
virtual vdic_dut_bfm bfm;
	
function new(virtual vdic_dut_bfm b);
	bfm = b;
endfunction : new

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
// scoreboard
//------------------------------------------------------------------------------
task execute();
	bit [15:0] expected = 0;
	bfm.tr = TEST_PASSED;
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
		        $error("%0t Test FAILED for cmd_set=%0s\nExpected: %d  received: %d",
		             $time, bfm.cmd.name()  ,expected, {bfm.data1_o,bfm.data2_o} );
			    bfm.tr = TEST_FAILED;
		    end;
	    end
    end
endtask : execute
	
endclass