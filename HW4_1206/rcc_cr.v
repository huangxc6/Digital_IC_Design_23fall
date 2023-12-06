module rcc_cr (
	input clk_sys			,
	input rst_n  			,  // Asynchronous reset active low
	input [1:0] rcc_cr_in   ,

	output reg [1:0] rcc_cr 
);
	reg flag 	   ;
	reg [15:0] cnt ;

	always @(posedge clk_sys or negedge rst_n) begin
		if (rst_n == 1'b0) begin
			flag <= 1'b0 ;
		end
		else if (cnt == 16'd29_955) begin
			flag <= 1'b1 ;
		end
	end

	always @(posedge clk_sys or negedge rst_n) begin
		if (rst_n == 1'b0) begin
			cnt <= 16'b0000_0000_0000_0000 ;
		end
		else if (flag == 1'b0) begin
			cnt <= cnt + 1'b1 ;
		end
	end
	always @(posedge clk_sys or negedge rst_n) begin
		if (rst_n == 1'b0) begin
			rcc_cr <= 2'b00 ;
		end
		else if (flag == 1'b1) begin
			rcc_cr <= rcc_cr_in ;
		end else begin
			if (cnt  == 16'd29_955) begin
				rcc_cr <= 2'b10  ;
			end else begin
				rcc_cr <= rcc_cr ;
			end
		end
	end

endmodule