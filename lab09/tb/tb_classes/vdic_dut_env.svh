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
class env extends uvm_env;
    `uvm_component_utils(env)

//------------------------------------------------------------------------------
// testbench elements
//------------------------------------------------------------------------------
    vdic_dut_sequencer sequencer_h;
	vdic_dut_driver driver_h;
	
    vdic_dut_coverage coverage_h;
    vdic_dut_scoreboard scoreboard_h;
	vdic_dut_command_monitor command_monitor_h;
    vdic_dut_result_monitor result_monitor_h;

//------------------------------------------------------------------------------
// build phase
//------------------------------------------------------------------------------
    function void build_phase(uvm_phase phase);
	    
	    // stimulus
        sequencer_h     = vdic_dut_sequencer::type_id::create("sequencer_h",this);
	    driver_h     = vdic_dut_driver::type_id::create("driver_h",this);
	    
	    //analysis
        coverage_h   = vdic_dut_coverage::type_id::create ("coverage_h",this);
        scoreboard_h = vdic_dut_scoreboard::type_id::create("scoreboard_h",this);
	    
	    //monitors
	    command_monitor_h = vdic_dut_command_monitor::type_id::create("command_monitor_h",this);
        result_monitor_h  = vdic_dut_result_monitor::type_id::create("result_monitor_h",this);
    endfunction : build_phase
    
//------------------------------------------------------------------------------
// connect phase
//------------------------------------------------------------------------------
    function void connect_phase(uvm_phase phase);
        driver_h.seq_item_port.connect(sequencer_h.seq_item_export);
	    
        result_monitor_h.ap.connect(scoreboard_h.analysis_export);
        command_monitor_h.ap.connect(scoreboard_h.cmd_f.analysis_export);
        command_monitor_h.ap.connect(coverage_h.analysis_export);
    endfunction : connect_phase    

//------------------------------------------------------------------------------
// end-of-elaboration phase
//------------------------------------------------------------------------------

//    function void end_of_elaboration_phase(uvm_phase phase);
//        scoreboard_h.set_report_verbosity_level_hier(UVM_HIGH);
// 

//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------
    function new (string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new

endclass


