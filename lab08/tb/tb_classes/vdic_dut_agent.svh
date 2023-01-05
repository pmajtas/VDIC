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
class vdic_dut_agent extends uvm_agent;
    `uvm_component_utils(vdic_dut_agent)

//------------------------------------------------------------------------------
// configuration object
//------------------------------------------------------------------------------

    vdic_dut_agent_config agent_config_h;

//------------------------------------------------------------------------------
// testbench components
//------------------------------------------------------------------------------

    vdic_dut_tester tester_h;
    vdic_dut_driver driver_h;
    vdic_dut_scoreboard scoreboard_h;
    vdic_dut_coverage coverage_h;
    vdic_dut_command_monitor command_monitor_h;
    vdic_dut_result_monitor result_monitor_h;

    uvm_tlm_fifo #(vdic_dut_command_transaction) command_f;
    uvm_analysis_port #(vdic_dut_command_transaction) cmd_mon_ap;
    uvm_analysis_port #(vdic_dut_result_transaction) result_ap;

//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------

    function new (string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new

//------------------------------------------------------------------------------
// build phase
//------------------------------------------------------------------------------

    function void build_phase(uvm_phase phase);

        // get the agent configuration
        if(!uvm_config_db #(vdic_dut_agent_config)::get(this, "","config", agent_config_h))
            `uvm_fatal("AGENT", "Failed to get config object");

        if (agent_config_h.get_is_active() == UVM_ACTIVE) begin : make_stimulus
            command_f = new("command_f", this);
            tester_h  = vdic_dut_tester::type_id::create("tester_h",this);
            driver_h  = vdic_dut_driver::type_id::create("driver_h",this);
        end

        command_monitor_h = vdic_dut_command_monitor::type_id::create("command_monitor_h",this);
        result_monitor_h  = vdic_dut_result_monitor::type_id::create("result_monitor_h",this);

        coverage_h        = vdic_dut_coverage::type_id::create("coverage_h",this);
        scoreboard_h      = vdic_dut_scoreboard::type_id::create("scoreboard_h",this);

        cmd_mon_ap        = new("cmd_mon_ap",this);
        result_ap         = new("result_ap", this);

    endfunction : build_phase

//------------------------------------------------------------------------------
// connect phase
//------------------------------------------------------------------------------

    function void connect_phase(uvm_phase phase);
        if (agent_config_h.get_is_active() == UVM_ACTIVE) begin : make_stimulus
            driver_h.command_port.connect(command_f.get_export);
            tester_h.command_port.connect(command_f.put_export);
        end

        command_monitor_h.ap.connect(cmd_mon_ap);
        result_monitor_h.ap.connect(result_ap);

        command_monitor_h.ap.connect(scoreboard_h.cmd_f.analysis_export);
        command_monitor_h.ap.connect(coverage_h.analysis_export);
        result_monitor_h.ap.connect(scoreboard_h.analysis_export);

    endfunction : connect_phase


endclass : vdic_dut_agent

