

package vdic_dut_pkg;
	
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
	
`include "vdic_dut_coverage.svh"
`include "vdic_dut_tester.svh"
`include "vdic_dut_scoreboard.svh"
`include "vdic_dut_testbench.svh"
	
endpackage 