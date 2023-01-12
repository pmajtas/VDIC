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
class vdic_dut_result_transaction extends uvm_transaction;

//------------------------------------------------------------------------------
// transaction variables
//------------------------------------------------------------------------------

    logic [15:0] result;

//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------

    function new(string name = "");
        super.new(name);
    endfunction : new

//------------------------------------------------------------------------------
// transaction methods - do_copy, convert2string, do_compare
//------------------------------------------------------------------------------

    function void do_copy(uvm_object rhs);
        vdic_dut_result_transaction copied_transaction_h;
        assert(rhs != null) else
            `uvm_fatal("RESULT TRANSACTION","Tried to copy null transaction");
        super.do_copy(rhs);
        assert($cast(copied_transaction_h,rhs)) else
            `uvm_fatal("RESULT TRANSACTION","Failed cast in do_copy");
        result = copied_transaction_h.result;
    endfunction : do_copy

    function string convert2string();
        string s;
        s = $sformatf("result: %4h",result);
        return s;
    endfunction : convert2string

    function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        vdic_dut_result_transaction RHS;
        bit same;
        assert(rhs != null) else
            `uvm_fatal("RESULT TRANSACTION","Tried to compare null transaction");

        same = super.do_compare(rhs, comparer);

        $cast(RHS, rhs);
        same = (result == RHS.result) && same;
        return same;
    endfunction : do_compare



endclass : vdic_dut_result_transaction
