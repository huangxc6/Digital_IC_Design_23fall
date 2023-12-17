module clock_gen #(
	parameter FREQUENCE = 4.8e7,
	parameter START_US  = 3
	)(
	output reg clk    	
);
	localparam cycle = 1.0e9/FREQUENCE ;
	localparam start = START_US * 1000 ;

	initial begin
		#(start) clk = 0;
		forever begin
			#(cycle/2) clk = ~clk ;
		end
	end

endmodule