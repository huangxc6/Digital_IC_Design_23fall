module rcc_cr (
	input clk_sys			,
	input rst_n  			,  // Asynchronous reset active low
	input [1:0] rcc_cr_in   ,

	output reg [1:0] rcc_cr 
);
	
	always @(posedge clk_sys or negedge rst_n) begin
		if (rst_n == 1'b0) begin
			rcc_cr <= 2'b00 ;
		end
		else begin
			rcc_cr <= rcc_cr_in ;
		end
	end

endmodule