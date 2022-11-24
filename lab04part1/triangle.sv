class triangle extends shape;
	
	function new(real w, real h);
		super.new(w,h);
	endfunction :new
	
	function real get_area();
		return width*height*0.5;
	endfunction : get_area
	
	function void print();
		$display("Triangle w=%g h=%g area=%g",width, height, get_area());
	endfunction :print
	
endclass
