
`timescale 1ns/1ps
module tb_data_top ();

	// clock
	logic clk;
	initial begin
		clk = '0;
		forever #(0.5) clk = ~clk;
	end

	// asynchronous reset
	logic reset_n;
	initial begin
		reset_n <= '0;
		#5
		reset_n <= '1;
	end

	// (*NOTE*) replace reset, clock, others
	logic       start;
	logic [7:0] data_in;
	logic       byte_en;
	logic [4:0] dmod;
	logic       mod_en;
	logic       full;

	data_top inst_data_top
		(
			.clk     (clk),
			.reset_n (reset_n),
			.start   (start),
			.data_in (data_in),
			.byte_en (byte_en),
			.dmod    (dmod),
			.mod_en  (mod_en),
			.full    (full)
		);

	task init();
		start   <= '0;
		data_in <= '0;
		byte_en <= '0;
	endtask

	task drive(int iter);
		for(int it = 0; it < iter; it++) begin
			start   <= '1;
			data_in <= $urandom_range(0,255);
			byte_en <= $urandom_range(0,  1);
			@(posedge clk);
		end
	endtask

	initial begin
		// do something

		init();
		repeat(10)@(posedge clk);

		drive(100);

		repeat(10)@(posedge clk);
		$finish;
	end
	// dump wave
	initial begin
		$display("random seed : %0d", $unsigned($get_initial_random_seed()));
		if ( $test$plusargs("fsdb") ) begin
			$fsdbDumpfile("tb_data_top.fsdb");
			$fsdbDumpvars(0, "tb_data_top");
		end
	end
endmodule
