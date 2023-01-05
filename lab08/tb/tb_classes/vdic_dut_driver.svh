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
class vdic_dut_driver extends uvm_component;
    `uvm_component_utils(vdic_dut_driver)
    
//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------
    protected virtual vdic_dut_bfm bfm;
    uvm_get_port #(vdic_dut_command_transaction) command_port;
    
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
	    
	    vdic_dut_agent_config vdic_dut_agent_config_h;
	    
        if(!uvm_config_db #(vdic_dut_agent_config)::get(this, "","config", vdic_dut_agent_config_h))
            `uvm_fatal("DRIVER", "Failed to get config")
        bfm = vdic_dut_agent_config_h.bfm;
        command_port = new("command_port",this);
    endfunction : build_phase
    
//------------------------------------------------------------------------------
// run phase
//------------------------------------------------------------------------------
    task run_phase(uvm_phase phase);
        vdic_dut_command_transaction command;
        forever begin : command_loop
            command_port.get(command);
	        if (command.state == RESET) begin
		        bfm.Reset_VDIC();
		        end
	        else begin
            	bfm.SendTest(command.data_in,command.cmd, command.size);
		        
		        end
        end : command_loop
    endtask : run_phase
    

endclass : vdic_dut_driver

