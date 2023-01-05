
class vdic_dut_scoreboard extends uvm_subscriber #(logic[15:0]);
    `uvm_component_utils(vdic_dut_scoreboard)
		
//protected virtual vdic_dut_bfm bfm;
protected test_result_t tr = TEST_PASSED;
	
uvm_tlm_analysis_fifo #(packet_s) cmd_f;

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
protected function logic [15:0] get_expected(
			bit [7:0] [7:0] data_i ,
            bit [3:0] size,
            command_t cmd_set);
    bit [15:0] ret, tmp;
	bit [31:0] size_q;
	bit [7:0] data;
	//command_t cmd_set;
    `ifdef DEBUG
    $display("%0t DEBUG: get_expected(%0d,%0d,%0d)",$time, A, B, op_set);
    `endif
    
	ret[7:0] =data_i[0];
	
	if ((cmd_set == CMD_NOP && size == 1) || size == 0 ) begin
		ret = 0;
	end
	else begin
		ret = ret;
	end
    for (int i=1; i<size; i++) begin
		data = data_i[i];
	    
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
        cmd_f = new ("cmd_f", this);
    endfunction : build_phase
    
    
    
//------------------------------------------------------------------------------
// scoreboard
//------------------------------------------------------------------------------
/*
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
		        $error("%0t Test FAILED for cmd_set=%0s\nExpected: %d  received: %d",
		             $time, bfm.cmd.name()  ,expected, {bfm.data1_o,bfm.data2_o} );
			    tr = TEST_FAILED;
		    end;
	    end
    end
endtask : run_phase*/

//------------------------------------------------------------------------------
// subscriber write function
//------------------------------------------------------------------------------
    function void write(logic [15:0] t);
	    
        logic [15:0] predicted_result;
        packet_s cmd;
        //cmd.size           = 0;
        cmd.cmd            = CMD_NOP;
        do begin
            if (!cmd_f.try_get(cmd))
                $fatal(1, "Missing command in self checker");
            
            end
        while ( (cmd.state == RESET) );
        
        predicted_result = get_expected(cmd.data, cmd.size, cmd.cmd);

        SCOREBOARD_CHECK:
        assert (predicted_result == t) begin
           `ifdef DEBUG
            $display("%0t Test passed for A=%0d B=%0d op_set=%0d", $time, cmd.A, cmd.B, cmd.op);
            `endif
        end
        else begin
            $error ("FAILED: A: %0h  size: %0d  op: %s received: %0h, expected: %0h", cmd.data[0], cmd.size, cmd.cmd.name(), t, predicted_result);
            tr = TEST_FAILED;
        end
    endfunction : write
	
//------------------------------------------------------------------------------
// report phase
//------------------------------------------------------------------------------
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        print_test_result(tr);
    endfunction : report_phase	
	
endclass