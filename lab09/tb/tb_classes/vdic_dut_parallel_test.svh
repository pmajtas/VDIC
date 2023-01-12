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
class vdic_dut_parallel_test extends vdic_dut_base_test;
   `uvm_component_utils(vdic_dut_parallel_test)

//------------------------------------------------------------------------------   
// local variables
//------------------------------------------------------------------------------   

   local vdic_dut_parallel_sequence parallel_h;
      
//------------------------------------------------------------------------------   
// constructor
//------------------------------------------------------------------------------   

   function new(string name, uvm_component parent);
      super.new(name,parent);
      parallel_h = new("parallel_h");
   endfunction : new
   
//------------------------------------------------------------------------------   
// run phase
//------------------------------------------------------------------------------   

   task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      parallel_h.start(sequencer_h);
      phase.drop_objection(this);
   endtask : run_phase

endclass


