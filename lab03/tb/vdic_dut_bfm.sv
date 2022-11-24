
interface vdic_dut_bfm();
import vdic_dut_pkg::*;
	

//------------------------------------------------------------------------------
// Local variables
//------------------------------------------------------------------------------

bit           		 clk;
bit                  rst_n;
bit                  enable_n;
bit                  din;
logic                dout;
logic          		 dout_valid;
	
test_result_t tr;
command_t cmd;
status_t stat;
test_result_t res;
state_t STATE;
bit [7:0]  data1_o, data2_o, error_cnt;
bit [7:0] data_i [7:0];
bit [3:0] size;
bit [8:0] wordsToSend[$];	
	
modport tlm (import Reset_VDIC, SendTest, result_print);
	
//------------------------------------------------------------------------------
// Clock generator
//------------------------------------------------------------------------------

initial begin : clk_gen_blk
    clk = 0;
    forever begin : clk_frv_blk
        #10;
        clk = ~clk;
    end
end

//------------------------------------------------------------------------------
// Reset
//------------------------------------------------------------------------------
task Reset_VDIC();
	STATE = RESET;
	@(negedge clk);
	rst_n = 1'b1;
	@(negedge clk);
	rst_n = 1'b0;
	@(negedge clk);
	rst_n = 1'b1;
endtask

task WriteInput_Word(
		input [8:0] data_i);
	
	bit p;
	begin
		p = 1'b0;
		for (int i=0; i<9; i++) begin
			@(negedge clk)
			enable_n = 1'b0;
			din = data_i[8-i];
			p = p + data_i[7-i];
		end
		@(negedge clk)
		din = p;
	end
endtask

task WriteInput();
	
	bit [8:0] data;
	
	foreach (wordsToSend[i])begin
		data = wordsToSend.pop_front();
		WriteInput_Word(data);

	end
	@(negedge clk)
	enable_n = 1'b1;
endtask

task SendToQueue();
	
	for (int i=0; i<size; i++) begin
		wordsToSend.push_back({1'b0,data_i[i]});
	end
	wordsToSend.push_back({1'b1,cmd});
	
endtask

task SendTest(input bit[7:0] idata_i[7:0], input command_t icmd, input bit [3:0] isize);
	
	cmd = icmd;
	$cast(STATE, icmd);
	size = isize;
	for (int i=0; i<size; i++) begin
		data_i[i] = idata_i[i];
	end
	
	SendToQueue();
	WriteInput();
	ReadOutput_Status();
	clk5_delay();
endtask

task ReadOutput_Status();
	
	bit [9:0] words [2:0];
	
	@(posedge dout_valid);
	for (int wordIdx=0; wordIdx<3; wordIdx++) begin
		
		for (int i=0; i<10; i++) begin
			@(negedge clk);
			words[wordIdx][9-i] = dout;
		end
	end
	
	$cast(stat, words[0][8:1]);
	data1_o = words[1][8:1];
	data2_o = words[2][8:1];
	
	
endtask

task clk5_delay();
	begin
		for (int i=0; i<5; i++) begin
		@(negedge clk);
		end
	end
endtask

	
//------------------------------------------------------------------------------
// print the test result at the simulation end
//------------------------------------------------------------------------------
task result_print();
    print_test_result(tr);
endtask
	
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

	
endinterface 