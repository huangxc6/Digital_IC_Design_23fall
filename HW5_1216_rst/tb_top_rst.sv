
`timescale 1ns/1ps
module tb_rst_top (); 

	// clock
	logic clk_osc;
	clock_gen #(
		.FREQUENCE(4.8e7), 
		.START_US(3_000)
		) inst_clock_gens (
		.clk(clk_osc)
		);

	// asynchronous reset
	logic nRST ;
	logic POR_n;
	initial begin
		POR_n <= '0;
		#100_000
		POR_n <= '1;
	end

	initial begin
		nRST <= '1 ;
		#8_000_000
		nRST <= '0 ;
		#10_000 	// pulse width is 0.01 ms , ignore it 
		nRST <= '1 ;
		#4_000_000
		nRST <= '0 ;
		#150_000 	// pulse width is 0.15 ms , reset
		nRST <= '1 ;
	end

	logic rst_n ;
	logic clk   ;

	rst_top inst_rst_top (
		.clk_osc(clk_osc), 
		.POR_n(POR_n), 
		.nRST (nRST),
		.rst_n(rst_n), 
		.clk(clk)
		);

	initial begin
		// do something

		#15_000_000;

		$finish;
	end
	// dump wave
	initial begin
		$display("random seed : %0d", $unsigned($get_initial_random_seed()));
		if ( $test$plusargs("fsdb") ) begin
			$fsdbDumpfile("tb_rst_top.fsdb");
			$fsdbDumpvars(0, "tb_rst_top");
		end
	end
endmodule
