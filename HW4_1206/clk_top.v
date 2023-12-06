module clk_top (
	input		rst_n		,  // Asynchronous reset active low
	input [1:0] rcc_cr_in   ,

	output 		clk_sys
);
	// generate thr clock
	parameter PERIOD_10M  = 100  ;
	parameter PERIOD_32K  = 31250;
	parameter PERIOD_100M = 10   ;

	wire clk_10M ;
	wire clk_32K ;
	wire clk_100M;

	clock_gen #(
			.PERIOD_10M(PERIOD_10M),
			.PERIOD_32K(PERIOD_32K),
			.PERIOD_100M(PERIOD_100M)
		) inst_clock_gen (
			.clk_10M  (clk_10M),
			.clk_32K  (clk_32K),
			.clk_100M (clk_100M)
		);

	// switch the clock
	wire [1:0] rcc_cr ;
	wire 	   clk_sys;
	clk_switch inst_clk_switch
		(
			.clk_10M  (clk_10M),
			.clk_32K  (clk_32K),
			.clk_100M (clk_100M),
			.rst_n    (rst_n),
			.rcc_cr   (rcc_cr),
			.clk_sys  (clk_sys)
		);

	// rcc_cr generate
	rcc_cr inst_rcc_cr 
		(
			.clk_sys(clk_sys), 
			.rst_n(rst_n), 
			.rcc_cr_in(rcc_cr_in), 
			.rcc_cr(rcc_cr)
		);

endmodule