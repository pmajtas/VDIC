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
class vdic_dut_command_monitor extends uvm_component;
    `uvm_component_utils(vdic_dut_command_monitor)

//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------
    protected virtual vdic_dut_bfm bfm;
    uvm_analysis_port #(vdic_dut_command_transaction) ap;

//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------
    function new (string name, uvm_component parent);
        super.new(name,parent);
    endfunction

//------------------------------------------------------------------------------
// build phase
//------------------------------------------------------------------------------
    function void build_phase(uvm_phase phase);
	    
	    vdic_dut_agent_config agent_config_h;
	    
        if(!uvm_config_db #(vdic_dut_agent_config)::get(this, "","config", agent_config_h))
            `uvm_fatal("COMMAND MONITOR", "Failed to get CONFIG")
        agent_config_h.bfm.command_monitor_h = this;
        ap                    = new("ap",this);
    endfunction : build_phase

//------------------------------------------------------------------------------
// monitoring function called from BFM
//------------------------------------------------------------------------------
    function void write_to_monitor(logic [7:0][7:0] data_in, logic [3:0] size_in, command_t cmd_in,state_t state_in);
        vdic_dut_command_transaction cmd;
	    `uvm_info("COMMAND MONITOR",$sformatf("MONITOR: data_in: %2h  size: %d  cmd: %s",
                data_in, size_in, cmd_in.name()), UVM_HIGH);
	    cmd    = new("cmd");
        cmd.data_in  = data_in;
        cmd.size  = size_in;
        cmd.cmd = cmd_in;
	    cmd.state = state_in;
        ap.write(cmd);
    endfunction : write_to_monitor



endclass : vdic_dut_command_monitor

