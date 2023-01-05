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
class vdic_dut_zeros_ones_tester extends vdic_dut_random_tester;
    `uvm_component_utils(vdic_dut_zeros_ones_tester)
    
//------------------------------------------------------------------------------
// function: get_op - generate random opcode for the tester
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// function: get_data - generate random data for the tester
//------------------------------------------------------------------------------
protected function logic [7:0] get_data();

    bit zero_ones;

    zero_ones = 2'($random);
		
		if (zero_ones == 1'b0)
	        return 8'h00;
	    else
	        return 8'hFF;
		 
endfunction : get_data
//---------------------------------

//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new
    

endclass : vdic_dut_zeros_ones_tester
