


module tester(vdic_dut_bfm bfm);

import vdic_dut_pkg::*;
//------------------------------------------------------------------------------
// DUT instantiation
//------------------------------------------------------------------------------




bit [7:0] data_i [7:0], size;
command_t cmd;
bit[1:0] reset;
//------------------------------------------------------------------------------
// Tester here we go
//------------------------------------------------------------------------------

initial begin :tester
	
	
	bfm.enable_n = 1'b1;

	bfm.Reset_VDIC();
	
	repeat(10000) begin
	
	cmd = get_cmd();
	size = get_size();
	get_data(size);
	reset = 2'($random); 
	
	if (reset == 2'b00)
		bfm.Reset_VDIC();
	
	
	bfm.SendTest(data_i, cmd, size);	
	end
	
	$finish;
end :tester





/*
task Send2QueueRandom();
	bit [7:0] data;
	
	size = $urandom_range(9, 2);
	
	size = 2;
	for (int i=0; i<size; i++) begin
		data = 8'($random);
		data_i[i] = data;
		wordsToSend.push_back({1'b0,data});
	end

endtask

task TestCommandOnes(
	input command_t cmd_c);
	bit [15:0] expected;
	bit [8:0] data;
	begin
		data = 9'h0FF;
		cmd = cmd_c;
		size = 2;
		for (int i=0; i<size; i++) begin
			data_i[i] = 8'hFF;
			wordsToSend.push_back({1'b0,data_i[i]});
		end
		wordsToSend.push_back({1'b1,cmd_c[7:0]});
		WriteInput();
		ReadOutput_Status();
		clk5_delay();
		
		end
endtask

task TestCommandZeros(
	input command_t cmd_c);
	bit [15:0] expected;
	bit [8:0] data;
	begin
		data = 9'h000;
		cmd = cmd_c;
		size = 2;
		for (int i=0; i<size; i++) begin
			data_i[i] = 8'h00;
			wordsToSend.push_back({1'b0,data_i[i]});
		end

		wordsToSend.push_back({1'b1,cmd_c[7:0]});
		WriteInput();
		ReadOutput_Status();
		clk5_delay();
		
	if (stat || {data1_o,data2_o} != expected)
		error_cnt = error_cnt + 1;
	else
		begin end
	end
endtask

task TestAllCommands();
	begin
		test_started(1);
		error_cnt = 0;
		res = TEST_FAILED;
		TestCommand(CMD_ADD);
		TestCommand(CMD_AND);
		TestCommand(CMD_OR);
		TestCommand(CMD_XOR);
		TestCommand(CMD_SUB);
	end
endtask

task TestAllCommandsAfterReset();
	begin
		test_started(2);
		error_cnt=0;
		res = TEST_FAILED;
		Reset_VDIC();
		TestCommand(CMD_ADD);
		Reset_VDIC();
		TestCommand(CMD_AND);
		Reset_VDIC();
		TestCommand(CMD_OR);
		Reset_VDIC();
		TestCommand(CMD_XOR);
		Reset_VDIC();
		TestCommand(CMD_SUB);
		Reset_VDIC();
		TestCommand(CMD_NOP);
		
	if (error_cnt)
		res = TEST_FAILED;
	else
		res = TEST_PASSED;
	
	print_test_result(res);
		
	end
endtask

task TestResetAfterEachCommand();
	begin
		test_started(3);
		error_cnt=0;
		res = TEST_FAILED;
		
		TestCommand(CMD_ADD);
		Reset_VDIC();
		TestCommand(CMD_AND);
		Reset_VDIC();
		TestCommand(CMD_OR);
		Reset_VDIC();
		TestCommand(CMD_XOR);
		Reset_VDIC();
		TestCommand(CMD_SUB);
		Reset_VDIC();
		TestCommand(CMD_NOP);
		Reset_VDIC();
		
	if (error_cnt)
		res = TEST_FAILED;
	else
		res = TEST_PASSED;
	
	print_test_result(res);
		
	end
endtask

task TestAllCommandsTwice();
	begin
		test_started(4);
		error_cnt=0;
		res = TEST_FAILED;
		
		TestCommand(CMD_ADD);
		TestCommand(CMD_ADD);
		TestCommand(CMD_AND);
		TestCommand(CMD_AND);
		
	if (error_cnt)
		res = TEST_FAILED;
	else
		res = TEST_PASSED;
	
	print_test_result(res);
		
	end
endtask

task TestAllZerosInput();
	begin
		test_started(5);
		error_cnt=0;
		res = TEST_FAILED;
		
		TestCommandZeros(CMD_ADD);
		TestCommandZeros(CMD_AND);
		TestCommandZeros(CMD_OR);
		TestCommandZeros(CMD_XOR);
		TestCommandZeros(CMD_SUB);
		

	end
endtask

task TestAllOnesInput();
	begin
		test_started(6);
		error_cnt=0;
		res = TEST_FAILED;
		
		TestCommandOnes(CMD_ADD);
		TestCommandOnes(CMD_AND);
		TestCommandOnes(CMD_OR);
		TestCommandOnes(CMD_XOR);
		TestCommandOnes(CMD_SUB);
		

		
	end
endtask	
*/

//---------------------------------
// Random data generation functions
function command_t get_cmd();
    bit [2:0] op_choice;
    op_choice = 3'($random);
    case (op_choice)
        3'b000 : return CMD_NOP;
        3'b001 : return CMD_ADD;
        3'b010 : return CMD_AND;
        3'b011 : return CMD_XOR;
        3'b100 : return CMD_OR;
        3'b101 : return CMD_SUB;
        3'b110 : return CMD_NOP;
        3'b111 : return CMD_NOP;
    endcase // case (op_choice)
endfunction : get_cmd

//---------------------------------
function get_data(input [7:0] size);

    bit [1:0] zero_ones;

    zero_ones = 2'($random);

	for (int i=0; i<size; i++) begin
		
		if (zero_ones == 2'b00)
	        data_i[i] = 8'h00;
	    else if (zero_ones == 2'b11)
	        data_i[i] = 8'hFF;
	    else
	        data_i[i] = 8'($random);
		
	end
    
endfunction : get_data
//---------------------------------
function logic[3:0] get_size();

    return $urandom_range(9, 1);
endfunction : get_size



endmodule :tester