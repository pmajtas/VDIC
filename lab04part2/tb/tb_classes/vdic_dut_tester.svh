


class vdic_dut_tester;

virtual vdic_dut_bfm bfm;
	
	function new(virtual vdic_dut_bfm b);
		bfm = b;
	endfunction : new

//------------------------------------------------------------------------------
// Tester here we go
//------------------------------------------------------------------------------

protected bit [7:0] data_i [7:0];
task execute();
	
	
	bit [3:0] size;
	command_t cmd;
	bit[1:0] reset;
	
	bfm.enable_n = 1'b1;

	bfm.Reset_VDIC();
	
	repeat(2000) begin
	
		cmd = get_cmd();
		size = get_size();
		get_data(size);
		reset = 2'($random); 
		
		if (reset == 2'b00)
			bfm.Reset_VDIC();
		
		
		bfm.SendTest(data_i, cmd, size);	
	end
	
	$finish;
endtask :execute


//---------------------------------
// Random data generation functions
protected function command_t get_cmd();
    bit [2:0] op_choice;
    op_choice = 3'($random);
    case (op_choice)
        3'b000 : return CMD_NOP;
        3'b001 : return CMD_ADD;
        3'b010 : return CMD_AND;
        3'b011 : return CMD_XOR;
        3'b100 : return CMD_OR;
        3'b101 : return CMD_SUB;
        3'b110 : return CMD_NOP;
        3'b111 : return CMD_NOP;
    endcase // case (op_choice)
endfunction : get_cmd

//---------------------------------
protected function void get_data(input [3:0] size);

    bit [1:0] zero_ones;

    zero_ones = 2'($random);

	for (int i=0; i<size; i++) begin
		
		if (zero_ones == 2'b00)
	        data_i[i] = 8'h00;
	    else if (zero_ones == 2'b11)
	        data_i[i] = 8'hFF;
	    else
	        data_i[i] = 8'($random);
		
	end
    
endfunction : get_data
//---------------------------------
protected function logic[3:0] get_size();
    return 4'($urandom_range(9, 1));
endfunction : get_size



endclass :vdic_dut_tester