class vdic_dut_sequencer extends uvm_sequencer #(sequence_item);
	`uvm_component_utils(vdic_dut_sequencer)
    
//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new


endclass : sequencer


