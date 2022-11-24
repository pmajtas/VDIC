module top();
	initial begin
	
	int fd=0,code;
	string line,shape_type;
	real width, height;
	bit ok;
	
	while(!fd) begin fd = $fopen("lab04part1_shapes.txt","r"); end
		
	if(fd) begin
		while(!$feof(fd)) begin
			code = $fscanf(fd, "%s %g %g", shape_type, width, height );
			shape_factory::make_shape(shape_type, width, height);

		end //while ($feof)
	end // if(fd)
		
	
	shape_reporter#(rectangle)::report_shapes();
	shape_reporter#(square)::report_shapes();
	shape_reporter#(triangle)::report_shapes();
	
	end
	
	
endmodule : top