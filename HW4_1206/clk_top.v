module clk_top (
	input		rst_n		,  // Asynchronous reset active low
	input [1:0] rcc_cr_in   ,

	output 		clk_sys
);

	wire [1:0] rcc_cr ;
	wire 	   clk_sys;

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

	// Asynchronous reset, synchronous release
	reg rst_n_sync_pre  ;
    reg rst_n_sync      ;

    always @ (posedge clk_sys or negedge rst_n) begin
        if (rst_n == 1'b0) begin
            rst_n_sync_pre <= 1'b0 ;
            rst_n_sync     <= 1'b0 ;
        end else begin
            rst_n_sync_pre  <= 1'b1 ;
            rst_n_sync      <= rst_n_sync_pre ;
        end
    end

	// switch the clock
	clk_switch inst_clk_switch
		(
			.clk_10M  (clk_10M),
			.clk_32K  (clk_32K),
			.clk_100M (clk_100M),
			.rst_n    (rst_n_sync),
			.rcc_cr   (rcc_cr),
			.clk_sys  (clk_sys)
		);

	// rcc_cr generate
	rcc_cr inst_rcc_cr 
		(
			.clk_sys(clk_sys), 
			.rst_n(rst_n_sync), 
			.rcc_cr_in(rcc_cr_in), 
			.rcc_cr(rcc_cr)
		);



endmodule