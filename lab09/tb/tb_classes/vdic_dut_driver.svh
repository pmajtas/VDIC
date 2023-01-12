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
class vdic_dut_driver extends uvm_driver #(vdic_dut_sequence_item);
    `uvm_component_utils(vdic_dut_driver)
    
//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------
    protected virtual vdic_dut_bfm bfm;
    
//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

//------------------------------------------------------------------------------
// build phase
//------------------------------------------------------------------------------
    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(virtual vdic_dut_bfm)::get(null, "*","bfm", bfm))
            `uvm_fatal("DRIVER", "Failed to get BFM")
    endfunction : build_phase
    
//------------------------------------------------------------------------------
// run phase
//------------------------------------------------------------------------------
    task run_phase(uvm_phase phase);
        vdic_dut_sequence_item command;
	    
	    void'(begin_tr(command));
        forever begin : command_loop
            seq_item_port.get_next_item(command);
	        if (command.state == RESET) begin
		        bfm.Reset_VDIC();
		        end
	        else begin
            	bfm.SendTest(command.data_in,command.cmd, command.size);
		        
	        end
	        seq_item_port.item_done();
        end : command_loop
        
        end_tr(command);
    endtask : run_phase
    

endclass : vdic_dut_driver

