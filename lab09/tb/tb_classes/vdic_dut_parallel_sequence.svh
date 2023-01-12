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
class vdic_dut_parallel_sequence extends uvm_sequence #(uvm_sequence_item);
    `uvm_object_utils(vdic_dut_parallel_sequence)

//------------------------------------------------------------------------------
// sequences to run
//------------------------------------------------------------------------------

    //local short_random_sequence short_random;

//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------

    function new(string name = "parallel_sequence");
        super.new(name);
//      reset = reset_sequence::type_id::create("reset");
//      fibonacci    = fibonacci_sequence::type_id::create("fibonacci");
//      short_random = short_random_sequence::type_id::create("short_random");
        //`uvm_create(short_random);
    endfunction : new

//------------------------------------------------------------------------------
// the sequence body
//------------------------------------------------------------------------------

    task body();
        `uvm_info("SEQ_PARALLEL","",UVM_MEDIUM)
        //reset.start(m_sequencer); // m_sequencer from the start method call
        fork
            //fibonacci.start(m_sequencer);
            //short_random.start(m_sequencer);
        join
    endtask : body



endclass : vdic_dut_parallel_sequence


