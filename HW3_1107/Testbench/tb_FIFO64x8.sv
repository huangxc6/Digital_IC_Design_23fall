
`timescale 1ns/1ps
module tb_FIFO64x8 (); 
	
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
	logic [7:0] data_in;
	logic       wr_en;
	logic       rd_en;
	logic [7:0] data_o;
	logic       full;
	logic       empty;

	FIFO64x8 inst_FIFO64x8
		(
			.data_in (data_in),
			.wr_en   (wr_en),
			.reset_n (reset_n),
			.clk     (clk),
			.rd_en   (rd_en),
			.data_o  (data_o),
			.full    (full),
			.empty   (empty)
		);

	task init();
		data_in <= '0;
		wr_en   <= '0;
		rd_en   <= '0;
	endtask

	task write(int iter);
		for(int it = 0; it < iter; it++) begin
			data_in <= $urandom_range(0,255);
			wr_en   <= '1;
			rd_en   <= '0;
			@(posedge clk);
		end
	endtask

	task read(int iter);
		for(int it = 0; it < iter; it++) begin
			data_in <= $urandom_range(0,255);
			wr_en   <= '0;
			rd_en   <= '1;
			@(posedge clk);
		end
	endtask

	initial begin
		// do something

		init();
		repeat(20)@(posedge clk);

		write(60);

		read(50);

		write(40);

		repeat(10)@(posedge clk);
		$finish;
	end
	// dump wave
	initial begin
		$display("random seed : %0d", $unsigned($get_initial_random_seed()));
		if ( $test$plusargs("fsdb") ) begin
			$fsdbDumpfile("tb_FIFO64x8.fsdb");
			$fsdbDumpvars(0, "tb_FIFO64x8");
		end
	end
endmodule
