module rst_top (
	input clk_osc ,
	input POR_n   ,  // Asynchronous reset active low
	input nRST    ,
	
	output reg rst_n , 
	output wire clk 
);

	// rc osc
	wire clk_rc ;
	clock_gen #(
		.FREQUENCE(32768), 
		.START_US(0)
	) inst_clock_gen (
		.clk(clk_rc)
		);

	wire rst_n_rc ;

	delay inst_delay (
		.clk_rc(clk_rc), 
		.POR_n(POR_n), 
		.switch(switch),
		.rst_n_rc(rst_n_rc)
		);

	csm inst_csm (
		.clk_osc(clk_osc), 
		.clk_rc(clk_rc), 
		.switch(switch), 
		.rst_n_rc(rst_n_rc),
		.clk(clk)
		);

	pulse_gen inst_pulse_gen (
		.clk_rc(clk_rc), 
		.switch(switch), 
		.nRST(nRST), 
		.rst_n_asyn(rst_n_asyn)
		);

	reg rst_n_pre ;
	always @(posedge clk or negedge rst_n_asyn) begin
		if (rst_n_asyn == 1'b0) begin
			rst_n_pre <= 1'b0 ;
			rst_n     <= 1'b0 ;
		end
		else begin
			rst_n_pre <= 1'b1      ;
			rst_n     <= rst_n_pre ;
		end
	end

endmodule