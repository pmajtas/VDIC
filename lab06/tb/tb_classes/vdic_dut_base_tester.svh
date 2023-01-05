


virtual class vdic_dut_base_tester extends uvm_component;


//protected virtual vdic_dut_bfm bfm;
//------------------------------------------------------------------------------
// port for sending the transactions
//------------------------------------------------------------------------------
    uvm_put_port #(packet_s) command_port;
	
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
	    command_port = new("command_port", this);
    endfunction : build_phase    
    
//------------------------------------------------------------------------------
// Tester here we go
//------------------------------------------------------------------------------

protected bit [7:0] [7:0]  data_i ;
    
//------------------------------------------------------------------------------
// run phase
//------------------------------------------------------------------------------
    task run_phase(uvm_phase phase);
	
	packet_s command;
	bit [3:0] size;
	command_t cmd;
	bit[1:0] reset;
	    
	phase.raise_objection(this);
	    
	command.state = RESET;
	command_port.put(command);
	repeat(2000) begin
	
		cmd = get_cmd();
		size = get_size();
		for (int i=0 ;i<size; i++) begin
			data_i[i] = get_data();
		end
		reset = 2'($random); 
		
		if (reset == 2'b00)
			command.state = RESET;
		else
			command.state = cmd;
		
		command.data = data_i;
		command.size = size;
		command.cmd = cmd;
		
		command_port.put(command);

	end
	
	phase.drop_objection(this);
    endtask : run_phase


endclass :vdic_dut_base_tester