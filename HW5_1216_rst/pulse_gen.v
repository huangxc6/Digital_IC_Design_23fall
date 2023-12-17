module pulse_gen (
	input clk_rc ,    
	input switch ,  
	input nRST  ,

	output wire rst_n_asyn
);
	reg [2:0] nRST_dly ;

	always @(posedge clk_rc) begin
		nRST_dly[2:0] <= {nRST_dly[1:0], nRST} ;
	end

	wire d_rst_n ;
	assign d_rst_n = (|nRST_dly) || nRST ; // Filter burrs

	reg rst_n_r ;
	always @(posedge clk_rc) begin
		rst_n_r <= d_rst_n ;
	end

	assign rst_n_asyn = switch && rst_n_r ;

endmodule