


module TOP;
	
//------------------------------------------------------------------------------
// Type definitions
//------------------------------------------------------------------------------
typedef enum bit [7:0] {
    //CMD_NOP  = 8'b00000000,		//do nothing, remove the data (reset data stack)
    CMD_AND  = 8'b00000001,		//logic AND of the last two arguments
    //CMD_OR   = 8'b00000010,		//logic OR of the arguments
    //CMD_XOR  = 8'b00000011,		//logic XOR of the arguments
    CMD_ADD  = 8'b00010000		//add the arguments
    //CMD_SUB  = 8'b00100000		//subtract other arguments from the first one
} command_t;

typedef enum bit [7:0] {
	S_NO_ERROR				= 8'b00000000,		//data correctly processed
 	//S_MISSING_DATA			= 8'b00000001,		//missing input data
 	//S_DATA_STACK_OVERFLOW	= 8'b00000010,		//maximum number of arguments exceeded
 	//S_OUTPUT_FIFO_OVERFLOW	= 8'b00000100,		//result dropped not possible to process
 	//S_DATA_PARITY_ERROR		= 8'b00100000,		//input data or command parity error
 	//S_COMMAND_PARITY_ERROR	= 8'b01000000,		//input data or command parity error
 	S_INVALID_COMMAND		= 8'b10000000		//unknown command detected*
} status_t;
	
typedef enum bit {
    TEST_PASSED,
    TEST_FAILED
} test_result_t;

typedef enum {
    COLOR_BOLD_BLACK_ON_GREEN,
    COLOR_BOLD_BLACK_ON_RED,
    COLOR_BOLD_BLACK_ON_YELLOW,
    COLOR_BOLD_BLUE_ON_WHITE,
    COLOR_BLUE_ON_WHITE,
    COLOR_DEFAULT
} print_color_t;
 
 
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
bit [7:0] data1_i, data2_i, data1_o, data2_o, error_cnt;
bit [8:0] wordsToSend[$];
//------------------------------------------------------------------------------
// DUT instantiation
//------------------------------------------------------------------------------

vdic_dut_2022 DUT (.clk, .rst_n, .enable_n, .din, .dout, .dout_valid);

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
// Tester here we go
//------------------------------------------------------------------------------

initial begin :tester
	enable_n = 1'b1;

	Reset_VDIC();
	
	TestAllCommands();
	
	TestAllCommandsAfterReset();
	
	TestResetAfterEachCommand();
	
	TestAllCommandsTwice();
	
	TestAllZerosInput();
	
	TestAllOnesInput();
	
	
	$finish;
end :tester


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


task Reset_VDIC();
	@(negedge clk);
	rst_n = 1'b1;
	@(negedge clk);
	rst_n = 1'b0;
	@(negedge clk);
	rst_n = 1'b1;
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
	
	//$display("Received error code: %h ,  received data: %d",stat,{data1_o,data2_o});
	
endtask

task Send2QueueRandom();
	bit [7:0] data;
	bit [2:0] size;
	
	
	size = 3'($random());
	
	if (size==0 || size == 1) begin
		size = size + 2;
	end
	else begin
	end
	
	for (int i=0; i<size; i++) begin
		data = 8'($random);
		wordsToSend.push_back({1'b0,data});
		//$display("data generated %d", data);
	end
	//wordsToSend.push_back({1'b1,8'h10});
endtask

task clk5_delay();
	begin
		for (int i=0; i<5; i++) begin
		@(negedge clk);
		end
	end
endtask

task TC1_ADD_1();	
	bit [8:0] data;
 	command_t cmd_c;
	bit [15:0] expected;	
	//test_result_t res;
	
	
	data = 9'h0FF;
	cmd_c = CMD_ADD;
	
	test_started(1);
	wordsToSend.push_back(data);
	wordsToSend.push_back(data);
	wordsToSend.push_back({1'b1,cmd_c[7:0]});
	expected = get_expected();
	
	WriteInput();
	ReadOutput_Status();
	$display("expected result:%d received result: %d", expected, {data1_o,data2_o});
	
	if (stat || {data1_o,data2_o} != expected)
		res = TEST_FAILED;
	else
		res = TEST_PASSED;
	
	print_test_result(res);
	
endtask

task TestCommand(
	input command_t cmd_c);
	bit [15:0] expected;
	begin
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

task TestCommandOnes(
	input command_t cmd_c);
	bit [15:0] expected;
	bit [8:0] data;
	begin
		data = 9'h0FF;
		wordsToSend.push_back(data);
	    wordsToSend.push_back(data);
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

task TestCommandZeros(
	input command_t cmd_c);
	bit [15:0] expected;
	bit [8:0] data;
	begin
		data = 9'h000;
		wordsToSend.push_back(data);
	    wordsToSend.push_back(data);
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

task TestAllCommands();
	begin
		test_started(1);
		error_cnt = 0;
		res = TEST_FAILED;
		TestCommand(CMD_ADD);
		TestCommand(CMD_AND);
		
	if (error_cnt)
		res = TEST_FAILED;
	else
		res = TEST_PASSED;
	
	print_test_result(res);
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
		
	if (error_cnt)
		res = TEST_FAILED;
	else
		res = TEST_PASSED;
	
	print_test_result(res);
		
	end
endtask

task TestAllOnesInput();
	begin
		test_started(6);
		error_cnt=0;
		res = TEST_FAILED;
		
		TestCommandOnes(CMD_ADD);
		TestCommandOnes(CMD_AND);
		
	if (error_cnt)
		res = TEST_FAILED;
	else
		res = TEST_PASSED;
	
	print_test_result(res);
		
	end
endtask

//------------------------------------------------------------------------------
// calculate expected result
//------------------------------------------------------------------------------

function logic [15:0] get_expected();
    bit [15:0] ret, tmp;
	bit [31:0] size;
	bit [8:0] cmd_set, local_queue[$],data;
    `ifdef DEBUG
    $display("%0t DEBUG: get_expected(%0d,%0d,%0d)",$time, A, B, op_set);
    `endif
    
    local_queue = wordsToSend;
    size = local_queue.size();
	
	cmd_set = local_queue.pop_back();
	case(cmd_set[7:0])
	        CMD_ADD : ret  = 0;  
	        CMD_AND : ret  = 16'hFF;
		    
	        default: begin
	            $display("%0t INTERNAL ERROR. get_expected: unexpected case argument: %s", $time, cmd_set);
	            return -1;
	        end
	    endcase

    for (int i=0; i<size-1; i++) begin
		data = local_queue.pop_front();
	    
	    case(cmd_set[7:0])
	        CMD_ADD : ret  = ret + data;  
	        CMD_AND : ret  = ret & data;
		    
	        default: begin
	            $display("%0t INTERNAL ERROR. get_expected: unexpected case argument: %s", $time, cmd_set);
	            return -1;
	        end
	    endcase
	end  
    
    return(ret);
endfunction : get_expected

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


endmodule :TOP