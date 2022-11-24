class square extends rectangle;
	
	function new(real w);
		super.new(w,w);
	endfunction : new
	/*
	function real get_area();
		return width*width;
	endfunction : get_area*/
	
	function void print();
		$display("Square w=%g  area=%g",width, get_area());
	endfunction :print
	
endclass 