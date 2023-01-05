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
class vdic_dut_command_transaction extends uvm_transaction;
    `uvm_object_utils(vdic_dut_command_transaction)

//------------------------------------------------------------------------------
// transaction variables
//------------------------------------------------------------------------------
    
    
    rand logic [7:0][7:0] data_in;
	rand logic [3:0] size;
    rand command_t cmd;
	state_t state;

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
// transaction functions: do_copy, clone_me, do_compare, convert2string
//------------------------------------------------------------------------------

    function void do_copy(uvm_object rhs);
        vdic_dut_command_transaction copied_transaction_h;

        if(rhs == null)
            `uvm_fatal("COMMAND TRANSACTION", "Tried to copy from a null pointer")

        super.do_copy(rhs); // copy all parent class data

        if(!$cast(copied_transaction_h,rhs))
            `uvm_fatal("COMMAND TRANSACTION", "Tried to copy wrong type.")

        data_in  = copied_transaction_h.data_in;
        size  = copied_transaction_h.size;
        cmd = copied_transaction_h.cmd;
        state = copied_transaction_h.state;

    endfunction : do_copy


    function vdic_dut_command_transaction clone_me();
        
        vdic_dut_command_transaction clone;
        uvm_object tmp;

        tmp = this.clone();
        $cast(clone, tmp);
        return clone;
        
    endfunction : clone_me


    function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        
        vdic_dut_command_transaction compared_transaction_h;
        bit same;

        if (rhs==null) `uvm_fatal("RANDOM TRANSACTION",
                "Tried to do comparison to a null pointer");

        if (!$cast(compared_transaction_h,rhs))
            same = 0;
        else
            same = super.do_compare(rhs, comparer) &&
            (compared_transaction_h.data_in == data_in) &&
            (compared_transaction_h.size == size) &&
            (compared_transaction_h.cmd == cmd) &&
            (compared_transaction_h.state == state) ;

        return same;
        
    endfunction : do_compare


    function string convert2string();
        string s;
        s = $sformatf("data_in: %2h  size: %d cmd: %s", data_in, size, cmd.name());
        return s;
    endfunction : convert2string

//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------

    function new (string name = "");
        super.new(name);
    endfunction : new

endclass : vdic_dut_command_transaction
