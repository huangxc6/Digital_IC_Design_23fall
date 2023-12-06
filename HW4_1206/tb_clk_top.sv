`timescale 1ns/1ps
module tb_clk_top ();

	// asynchronous reset
	logic rst_n;
	initial begin
		rst_n <= '1;
		#2000
		rst_n <= '0;
		#500
		rst_n <= '1;
	end

	// (*NOTE*) replace reset, clock, others
	parameter  PERIOD_10M = 100;
	parameter  PERIOD_32K = 31250;
	parameter PERIOD_100M = 10;

	logic [1:0] rcc_cr_in;
	logic       clk_sys;

	clk_top #(
			.PERIOD_10M(PERIOD_10M),
			.PERIOD_32K(PERIOD_32K),
			.PERIOD_100M(PERIOD_100M)
		) inst_clk_top (
			.rst_n     (rst_n),
			.rcc_cr_in (rcc_cr_in),
			.clk_sys   (clk_sys)
		);

	task init();
		rcc_cr_in <= 2'b00;
	endtask

	task drive(int iter);
		for(int it = 0; it < iter; it++) begin
			rcc_cr_in <= it;
			# 2000000;  // 2ms
		end
	endtask

	initial begin
		// do something

		init();
		# 3000 		// 3us
		drive(3);

		# 3000 
		$finish;
	end
	// dump wave
	initial begin
		$display("random seed : %0d", $unsigned($get_initial_random_seed()));
		if ( $test$plusargs("fsdb") ) begin
			$fsdbDumpfile("tb_clk_top.fsdb");
			$fsdbDumpvars(0, "tb_clk_top");
		end
	end
endmodule
