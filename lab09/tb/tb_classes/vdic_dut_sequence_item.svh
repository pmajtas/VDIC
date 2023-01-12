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
class vdic_dut_sequence_item extends uvm_sequence_item;

//  This macro is moved below the variables definition and expanded.
//    `uvm_object_utils(sequence_item)

//------------------------------------------------------------------------------
// sequence item variables
//------------------------------------------------------------------------------

    rand logic [7:0][7:0] data_in;
	rand logic [3:0] size;
    rand command_t cmd;
	rand state_t state;

//------------------------------------------------------------------------------
// Macros providing copy, compare, pack, record, print functions.
// Individual functions can be enabled/disabled with the last
// `uvm_field_*() macro argument.
// Note: this is an expanded version of the `uvm_object_utils with additional
//       fields added. DVT has a dedicated editor for this (ctrl-space).
//------------------------------------------------------------------------------

    `uvm_object_utils_begin(vdic_dut_sequence_item)
        `uvm_field_int(data_in, UVM_ALL_ON | UVM_DEC)
        `uvm_field_int(size, UVM_ALL_ON | UVM_DEC)
        `uvm_field_enum(command_t, cmd, UVM_ALL_ON)
        `uvm_field_enum(state_t, state, UVM_ALL_ON | UVM_DEC)
    `uvm_object_utils_end

//------------------------------------------------------------------------------
// constraints
//------------------------------------------------------------------------------

    constraint data {
        size dist {4'h1:=2, [4'h02 : 4'h8]:=1, 4'h9:=2};
        data_in[0] dist {8'h00:=2, [8'h01 : 8'hFE]:=1, 8'hFF:=2};
	    data_in[1] dist {8'h00:=2, [8'h01 : 8'hFE]:=1, 8'hFF:=2};
	    data_in[2] dist {8'h00:=2, [8'h01 : 8'hFE]:=1, 8'hFF:=2};
	    data_in[3] dist {8'h00:=2, [8'h01 : 8'hFE]:=1, 8'hFF:=2};
	    data_in[4] dist {8'h00:=2, [8'h01 : 8'hFE]:=1, 8'hFF:=2};
	    data_in[5] dist {8'h00:=2, [8'h01 : 8'hFE]:=1, 8'hFF:=2};
	    data_in[6] dist {8'h00:=2, [8'h01 : 8'hFE]:=1, 8'hFF:=2};
	    data_in[7] dist {8'h00:=2, [8'h01 : 8'hFE]:=1, 8'hFF:=2};
    }

//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------

    function new(string name = "sequence_item");
        super.new(name);
    endfunction : new

//------------------------------------------------------------------------------
// convert2string 
//------------------------------------------------------------------------------

    function string convert2string();
        return {super.convert2string(),
            $sformatf("data_in: %h  size: %2h   cmd: %s ", data_in, size, cmd.name())
        };
    endfunction : convert2string

endclass : vdic_dut_sequence_item


