class shape_reporter #(type T = shape);
	
	protected static T shape_storage[$];
	
	static function void store_shape(T s);
		shape_storage.push_back(s);
	endfunction :store_shape	
	
	static function void report_shapes();
		real total_area = 0;
		foreach(shape_storage[i])begin
			shape_storage[i].print();
			total_area = total_area + shape_storage[i].get_area();
			end
		$display("Total area: %g\n",total_area);
	endfunction :report_shapes
	
	
	
endclass;