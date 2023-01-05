


virtual class vdic_dut_base_tester extends uvm_component;

protected virtual vdic_dut_bfm bfm;
	
//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new
    
//------------------------------------------------------------------------------
// function prototypes
//------------------------------------------------------------------------------
    pure virtual protected function logic [7:0] get_data();
    pure virtual protected function command_t get_cmd();
    pure virtual protected function logic [3:0] get_size();
    
//------------------------------------------------------------------------------
// build phase
//------------------------------------------------------------------------------
    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(virtual vdic_dut_bfm)::get(null, "*","bfm", bfm))
            $fatal(1,"Failed to get BFM");
    endfunction : build_phase    
    
//------------------------------------------------------------------------------
// Tester here we go
//------------------------------------------------------------------------------

protected bit [7:0] data_i [7:0];
    
//------------------------------------------------------------------------------
// run phase
//------------------------------------------------------------------------------
    task run_phase(uvm_phase phase);
	
	
	bit [3:0] size;
	command_t cmd;
	bit[1:0] reset;
	
	bfm.enable_n = 1'b1;
	    
	phase.raise_objection(this);
	bfm.Reset_VDIC();
	
	repeat(1500) begin
	
		cmd = get_cmd();
		size = get_size();
		for (int i=0 ;i<size; i++) begin
			data_i[i] = get_data();
		end
		reset = 2'($random); 
		
		if (reset == 2'b00)
			bfm.Reset_VDIC();
		
		
		bfm.SendTest(data_i, cmd, size);	
	end
	
	phase.drop_objection(this);
    endtask : run_phase


endclass :vdic_dut_base_tester