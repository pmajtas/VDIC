


module TOP;
	
//------------------------------------------------------------------------------
// Type definitions
//------------------------------------------------------------------------------
typedef enum bit [7:0] {
    CMD_NOP  = 8'b00000000,		//do nothing, remove the data (reset data stack)
    CMD_AND  = 8'b00000001,		//logic AND of the last two arguments
    CMD_OR   = 8'b00000010,		//logic OR of the arguments
    CMD_XOR  = 8'b00000011,		//logic XOR of the arguments
    CMD_ADD  = 8'b00010000,		//add the arguments
    CMD_SUB  = 8'b00100000		//subtract other arguments from the first one
} command_t; //MAX IS 9 DATA WORD + CONTROL

typedef enum bit [7:0] {
	S_NO_ERROR				= 8'b00000000,		//data correctly processed
 	//S_MISSING_DATA			= 8'b00000001,		//missing input data
 	//S_DATA_STACK_OVERFLOW	= 8'b00000010,		//maximum number of arguments exceeded
 	//S_OUTPUT_FIFO_OVERFLOW	= 8'b00000100,		//result dropped not possible to process
 	//S_DATA_PARITY_ERROR		= 8'b00100000,		//input data or command parity error
 	//S_COMMAND_PARITY_ERROR	= 8'b01000000,		//input data or command parity error
 	S_INVALID_COMMAND		= 8'b10000000		//unknown command detected*
} status_t;

typedef enum bit [7:0] {
	RESET	=	8'hFF,
	NOP		=	8'h0,
	AND		= 	8'h1,
	OR		=	8'h2,
	XOR		=	8'h3,
	ADD		=	8'h10,
	SUB		=	8'h20
	
} state_t;

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
state_t STATE;
bit [7:0] data1_i, data2_i, data1_o, data2_o, error_cnt;
bit [7:0] data_i [7:0], size;
bit [8:0] wordsToSend[$];
//------------------------------------------------------------------------------
// DUT instantiation
//------------------------------------------------------------------------------

vdic_dut_2022 DUT (.clk, .rst_n, .enable_n, .din, .dout, .dout_valid);


//------------------------------------------------------------------------------
// Coverage block
//------------------------------------------------------------------------------
/*
CMD_NOP  = 8'b00000000,		//do nothing, remove the data (reset data stack)
    CMD_AND  = 8'b00000001,		//logic AND of the last two arguments
    CMD_OR   = 8'b00000010,		//logic OR of the arguments
    CMD_XOR  = 8'b00000011,		//logic XOR of the arguments
    CMD_ADD  = 8'b00010000,		//add the arguments
    CMD_SUB*/
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
        bins value[] = {['h00:'h09]};
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

cmd_cov                      oc;
zeros_or_ones_on_cmd        c_00_FF;

initial begin : coverage
    oc      = new();
    c_00_FF = new();
	@(negedge rst_n);
	@(posedge rst_n);
    forever begin : sample_cov
        	@(posedge clk);
            oc.sample();
            c_00_FF.sample();

    end : sample_cov
end : coverage


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

	//TestAllCommands();

	TestAllCommandsAfterReset();

	TestResetAfterEachCommand();
	/*
	TestAllCommandsTwice();
	*/

	//TestAllZerosInput();

	//TestAllOnesInput();

	RndCmdRndData();
	
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
	STATE = RESET;
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
	
	
endtask

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

task clk5_delay();
	begin
		for (int i=0; i<5; i++) begin
		@(negedge clk);
		end
	end
endtask

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
endtask

task SendToQueue();
	
	for (int i=0; i<size; i++) begin
		wordsToSend.push_back({1'b0,data_i[i]});
	end
	wordsToSend.push_back({1'b1,cmd});
	
endtask

//------------------------------------------------------------------------------
// scoreboard
//------------------------------------------------------------------------------
bit [15:0] expected = 0;
always @(negedge clk) begin : scoreboard
	@(negedge dout_valid);
	while(dout_valid)@(negedge clk);
    if(!dout_valid) begin:verify_result
	    expected = get_expected();
	    
	    CHK_RESULT: assert({data1_o,data2_o} === expected) begin
           `ifdef DEBUG
            $display("%0t Test passed for A=%0d B=%0d op_set=%0d", $time, A, B, op);
           `endif
        end
        else begin
            $error("%0t Test FAILED for cmd_set=%0d\nExpected: %d  received: %d",
                $time, cmd  ,expected, {data1_o,data2_o} );
        end;
	end
end : scoreboard




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
function get_data();

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

    return $urandom_range(9, 2);
endfunction : get_size

//------------------------------------------------------------------------------
// calculate expected result
//------------------------------------------------------------------------------

function logic [15:0] get_expected();
    bit [15:0] ret, tmp;
	bit [31:0] size_q;
	bit [8:0] cmd_set, local_queue[$],data;
    `ifdef DEBUG
    $display("%0t DEBUG: get_expected(%0d,%0d,%0d)",$time, A, B, op_set);
    `endif
    
    local_queue = wordsToSend;
    size_q = local_queue.size();
	
	cmd_set = local_queue.pop_back();
	cmd_set = cmd;

	ret = local_queue.pop_front();
	ret = data_i[0];
	
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