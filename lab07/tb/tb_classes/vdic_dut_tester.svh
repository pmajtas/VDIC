


class vdic_dut_tester extends uvm_component;
	`uvm_component_utils(vdic_dut_tester)

//protected virtual vdic_dut_bfm bfm;
//------------------------------------------------------------------------------
// port for sending the transactions
//------------------------------------------------------------------------------
    uvm_put_port #(vdic_dut_command_transaction) command_port;
	
//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new
    
//------------------------------------------------------------------------------
// function prototypes
//------------------------------------------------------------------------------
    /*pure virtual protected function logic [7:0] get_data();
    pure virtual protected function command_t get_cmd();
    pure virtual protected function logic [3:0] get_size();*/
    
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
	
	vdic_dut_command_transaction command;
	bit [3:0] size;
	command_t cmd;
	bit[1:0] reset;
	state_t state;
	    
	phase.raise_objection(this);
	    
	command = new("command");
	command.state = RESET;
	command_port.put(command);
	command    = vdic_dut_command_transaction::type_id::create("command");
	repeat(2000) begin

		assert(command.randomize());
		reset = 2'($random); 
		
		if (reset == 2'b00)
			command.state = RESET;
		else begin
			$cast(command.state, cmd); 

		end

		command_port.put(command);

	end
	
	phase.drop_objection(this);
    endtask : run_phase


endclass :vdic_dut_tester