
//`timescale 1ns/1ps
package vdic_dut_pkg;
	
	import uvm_pkg::*;
    `include "uvm_macros.svh"
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

typedef struct packed {
	logic [7:0] [7:0] data ;
	logic [3:0] size;
	command_t cmd;
	state_t state;
} packet_s;
	
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
// package functions
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
//------------------------------------------------------------------------------
// testbench classes
//------------------------------------------------------------------------------	

// configs
`include "vdic_dut_env_config.svh"
`include "vdic_dut_agent_config.svh"

//transactions
`include "vdic_dut_command_transaction.svh"
`include "vdic_dut_zeros_ones_transaction.svh"
`include "vdic_dut_result_transaction.svh"

//testbench
`include "vdic_dut_coverage.svh"
`include "vdic_dut_tester.svh"
`include "vdic_dut_scoreboard.svh"
`include "vdic_dut_driver.svh"
`include "vdic_dut_command_monitor.svh"
`include "vdic_dut_result_monitor.svh"
`include "vdic_dut_agent.svh"
`include "vdic_dut_env.svh"

//------------------------------------------------------------------------------
// test classes
//------------------------------------------------------------------------------
`include "vdic_dut_dual_test.svh"

	
endpackage 