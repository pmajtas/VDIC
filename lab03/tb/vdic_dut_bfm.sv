
interface vdic_dut_bfm();
import vdic_dut_pkg::*;
	

//------------------------------------------------------------------------------
// Local variables
//------------------------------------------------------------------------------

bit           		 clk;
bit                  rst_n;
bit                  enable_n;
bit                  din;
bit                  dout;
bit          		 dout_valid;
	
command_t cmd;
status_t stat;
test_result_t res;
state_t STATE;
bit [7:0]  data1_o, data2_o, error_cnt;
bit [7:0] data_i [7:0], size;
bit [8:0] wordsToSend[$];	
	
modport tlm (import Reset_VDIC, SendTest);
	
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
/*
task RndCmdRndData();
	begin
	
		repeat(1000) begin
			cmd = get_cmd();
			size = get_size();
			get_data();
			SendToQueue();
			WriteInput();
			ReadOutput_Status();
			clk5_delay();
		
		
		end
	end
endtask*/

task SendTest(input bit[7:0] idata_i[7:0], input command_t icmd, input bit [7:0] isize);
	
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
/*
task TestCommand(
	input command_t cmd_c);
	bit [15:0] expected;
	begin
		cmd = cmd_c;
		$cast(STATE,cmd);
		Send2QueueRandom();
		wordsToSend.push_back({1'b1,cmd_c[7:0]});
		expected = get_expected();
		WriteInput();
		ReadOutput_Status();
		$display("received status: %d", stat);
		$display("expected result:%d received result: %d", expected, {data1_o,data2_o});
		clk5_delay();
		
	if (stat || {data1_o,data2_o} != expected)
		error_cnt = error_cnt + 1;
	else
		begin end
	end
endtask
*/
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

	
endinterface 