virtual class shape;
	protected real width=-1;
	protected real height=-1;
	
	function new(real w, real h);
		width = w;
		height = h;	
	endfunction : new
	
	pure virtual function real get_area();
	
	pure virtual function void print();
	
endclass