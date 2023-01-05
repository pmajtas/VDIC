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
class vdic_dut_zeros_ones_transaction extends vdic_dut_command_transaction;
    `uvm_object_utils(vdic_dut_zeros_ones_transaction)

//------------------------------------------------------------------------------
// constraints
//------------------------------------------------------------------------------

    constraint min_max {
	    size dist {4'h2:=2, 4'h3:=2};
        data_in[0] dist {8'h00:=2, 8'hFF:=2};
	    data_in[1] dist {8'h00:=2, 8'hFF:=2};
	    data_in[2] dist {8'h00:=2, 8'hFF:=2};
	    data_in[3] dist {8'h00:=2, 8'hFF:=2};
	    data_in[4] dist {8'h00:=2, 8'hFF:=2};
	    data_in[5] dist {8'h00:=2, 8'hFF:=2};
	    data_in[6] dist {8'h00:=2, 8'hFF:=2};
	    data_in[7] dist {8'h00:=2, 8'hFF:=2};
    }

//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------

    function new(string name="");
        super.new(name);
    endfunction
    
    
endclass : vdic_dut_zeros_ones_transaction


