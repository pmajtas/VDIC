
interface vdic_dut_bfm;
import vdic_dut_pkg::*;
	

//------------------------------------------------------------------------------
// Local variables
//------------------------------------------------------------------------------

bit           		 clk;
bit                  rst_n;
bit                  enable_n = 1'b1;
bit                  din;
bit                  dout;
bit          		 dout_valid ;


command_t cmd;
status_t stat;
test_result_t tr;
state_t STATE;
bit [7:0]  data1_o = 0, data2_o = 0, error_cnt;
bit [7:0] [7:0] data_i ;
bit [3:0] size;
bit [8:0] wordsToSend[$];	
bit read_finish=0;
bit start = 1'b0;
vdic_dut_command_monitor command_monitor_h;
vdic_dut_result_monitor result_monitor_h;
	
//modport tlm (import Reset_VDIC, SendTest);
	
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
	//$display("Reset siema");
	enable_n = 1'b1;
	STATE = RESET;
	@(negedge clk);
	rst_n = 1'b1;
	@(negedge clk);
	rst_n = 1'b0;
	@(negedge clk);
	rst_n = 1'b1;
endtask

task WriteInput_Word(
		input [8:0] data_ii);
	bit p;
	begin
		p = 1'b0;
		for (int i=0; i<9; i++) begin
			@(negedge clk)
			enable_n = 1'b0;
			din = data_ii[8-i];
			//p = p + data_ii[7-i];
		end
		p=^data_ii;
		if(data_ii[8]==1'b1) begin
			p = ~p;
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

task SendTest(input bit[7:0] [7:0] idata_i, input command_t icmd, input bit [3:0] isize);
	
	$cast(STATE, icmd);
	command_monitor_h.write_to_monitor(idata_i, isize, icmd, STATE);
	cmd = icmd;
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
	
	//$cast(stat, words[0][8:1]);
	//stat = words[0][8:1];
	data1_o = words[1][8:1];
	data2_o = words[2][8:1];
	read_finish = 1'b1;
	//result_monitor_h.write_to_monitor({data1_o,data2_o});
	
endtask

task clk5_delay();
	begin
		for (int i=0; i<5; i++) begin
		@(negedge clk);
		end
	end
endtask


//------------------------------------------------------------------------------
// write command monitor
//------------------------------------------------------------------------------
/*
always @(posedge clk) begin : op_monitor
    static bit in_command = 0;
    packet_s command;
    //if (start) begin : start_high
        if (!in_command) begin : new_command
            command.data  = data_i;
            command.size  = size;
            command.cmd = cmd;
            command_monitor_h.write_to_monitor(command);
            in_command = (command.cmd != CMD_NOP);
        end : new_command
    //end : start_high
    else // start low
        in_command = 0;
end : op_monitor
*/
logic [7:0][7:0] rst_dat;
initial begin
	 for (int i=0; i<8; i++) begin
		 rst_dat[i] = 0;
	 end
	
end
always @(negedge rst_n) begin : rst_monitor
    vdic_dut_command_transaction command;
    //command.state = RESET;
    if (command_monitor_h != null) //guard against VCS time 0 negedge
        command_monitor_h.write_to_monitor(rst_dat,1,CMD_NOP,RESET);
end : rst_monitor


//------------------------------------------------------------------------------
// write result monitor
//------------------------------------------------------------------------------

initial begin : result_monitor_thread
	read_finish = 1'b0;
    forever begin
	    @(negedge clk);
    
        if ((command_monitor_h != null) && (read_finish == 1'b1)) begin
            result_monitor_h.write_to_monitor({data1_o,data2_o});
	        read_finish = 1'b0;
        end 
    end
end : result_monitor_thread

	
endinterface 