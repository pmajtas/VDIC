/*
 Copyright 2013 Ray Salemi

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */
class vdic_dut_random_tester extends vdic_dut_base_tester; 
    `uvm_component_utils (vdic_dut_random_tester)
    
//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

//------------------------------------------------------------------------------
// function: get_data - generate random data for the tester
//------------------------------------------------------------------------------
protected function logic [7:0] get_data();

    bit [1:0] zero_ones;

    zero_ones = 2'($random);
		
		if (zero_ones == 2'b00)
	        return 8'h00;
	    else if (zero_ones == 2'b11)
	        return 8'hFF;
	    else
	        return 8'($random);
		 
endfunction : get_data
//---------------------------------
protected function logic[3:0] get_size();
    return 4'($urandom_range(9, 1));
endfunction : get_size

//------------------------------------------------------------------------------
// function: get_op - generate random opcode for the tester
//------------------------------------------------------------------------------
    protected function command_t get_cmd();
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

endclass : vdic_dut_random_tester






