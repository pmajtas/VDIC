
module vdic_dut_scoreboard(vdic_dut_bfm bfm);
import vdic_dut_pkg::*;
	
//------------------------------------------------------------------------------
// calculate expected result
//------------------------------------------------------------------------------
function logic [15:0] get_expected();
    bit [15:0] ret, tmp;
	bit [31:0] size_q;
	bit [8:0] local_queue[$],data;
	command_t cmd_set;
    `ifdef DEBUG
    $display("%0t DEBUG: get_expected(%0d,%0d,%0d)",$time, A, B, op_set);
    `endif
    
    //local_queue = wordsToSend;
    size_q = local_queue.size();
	
	cmd_set = local_queue.pop_back();
	cmd_set = bfm.cmd;
	
	ret = local_queue.pop_front();
	ret = bfm.data_i[0];
	$display("size: %d", bfm.size);
	
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
    $display("in function cmd: %0s ret: %d", cmd_set.name(), ret);
    return(ret);
endfunction : get_expected


//------------------------------------------------------------------------------
// scoreboard
//------------------------------------------------------------------------------
bit [15:0] expected = 0;
always @(negedge bfm.clk) begin : scoreboard
	@(negedge bfm.dout_valid);
	while(bfm.dout_valid)@(negedge bfm.clk);
    if(!bfm.dout_valid) begin:verify_result
	    expected = 0;
	    $display("before expected: %d", expected);
	    expected = get_expected();
	    $display("after expected: %d",expected);
	    CHK_RESULT: assert({bfm.data1_o,bfm.data2_o} === expected) begin
           `ifdef DEBUG
            $display("%0t Test passed for A=%0d B=%0d op_set=%0d", $time, A, B, op);
           `endif
        end
        else begin
            $error("%0t Test FAILED for cmd_set=%0s\nExpected: %d  received: %d",
                $time, bfm.cmd.name()  ,expected, {bfm.data1_o,bfm.data2_o} );
        end;
	end
end : scoreboard
	
	
	
//------------------------------------------------------------------------------
// Other functions
//------------------------------------------------------------------------------

// used to modify the color of the text printed on the terminal
function void set_print_color ( print_color_t c );
    string ctl;
    case(c)
        COLOR_BOLD_BLACK_ON_GREEN : ctl  = "\033\[1;30m\033\[102m";
        COLOR_BOLD_BLACK_ON_RED : ctl    = "\033\[1;30m\033\[101m";
        COLOR_BOLD_BLACK_ON_YELLOW : ctl = "\033\[1;30m\033\[103m";
        COLOR_BOLD_BLUE_ON_WHITE : ctl   = "\033\[1;34m\033\[107m";
        COLOR_BLUE_ON_WHITE : ctl        = "\033\[0;34m\033\[107m";
        COLOR_DEFAULT : ctl              = "\033\[0m\n";
        default : begin
            $error("set_print_color: bad argument");
            ctl                          = "";
        end
    endcase
    $write(ctl);
endfunction

function void print_test_result (test_result_t r);
    if(r == TEST_PASSED) begin
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

function void test_started (bit[7:0] test);
	
	set_print_color(COLOR_BOLD_BLUE_ON_WHITE);
        $write ("-----------------------------------\n");

	set_print_color(COLOR_BOLD_BLUE_ON_WHITE);
        $write ("----------- Test%d started --------\n",test);

	set_print_color(COLOR_BOLD_BLUE_ON_WHITE);
        $write ("-----------------------------------");
	set_print_color(COLOR_DEFAULT);
        $write ("\n");

endfunction
endmodule