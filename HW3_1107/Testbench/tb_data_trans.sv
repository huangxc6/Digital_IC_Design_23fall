
`timescale 1ns/1ps
module tb_data_trans (); /* this is automatically generated */

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
		#10
		reset_n <= '1;
	end

	// synchronous reset
	logic srstb;
	initial begin
		srstb <= '0;
		repeat(10)@(posedge clk);
		srstb <= '1;
	end

	// (*NOTE*) replace reset, clock, others
	logic       start;
	logic [7:0] data_in;
	logic       byte_en;
	logic [7:0] data_o;
	logic       data_en;

	data_trans inst_data_trans
		(
			.clk     (clk),
			.reset_n (reset_n),
			.start   (start),
			.data_in (data_in),
			.byte_en (byte_en),
			.data_o  (data_o),
			.data_en (data_en)
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
			byte_en <= $urandom_range(0,1 );
			@(posedge clk);
		end
	endtask

	initial begin
		// do something

		init();
		repeat(10)@(posedge clk);

		start   <= '1;
		data_in <= 8'h10;
		byte_en <= '1;
		@(posedge clk);

		data_in <= 8'hx2;
		byte_en <= '0;
		@(posedge clk);

		data_in <= 8'h43;
		byte_en <= '1;
		@(posedge clk);

		data_in <= 8'h95;
		byte_en <= '1;
		@(posedge clk);

		data_in <= 8'hx6;
		byte_en <= '0;
		@(posedge clk);

		data_in <= 8'h87;
		byte_en <= '1;
		@(posedge clk);

		drive(20);

		repeat(10)@(posedge clk);
		$finish;
	end
	// dump wave
	initial begin
		$display("random seed : %0d", $unsigned($get_initial_random_seed()));
		if ( $test$plusargs("fsdb") ) begin
			$fsdbDumpfile("tb_data_trans.fsdb");
			$fsdbDumpvars(0, "tb_data_trans", "+mda", "+functions");
		end
	end
endmodule
