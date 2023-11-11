
`timescale 1ns/1ps
module tb_data_mod ();

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

	// (*NOTE*) replace reset, clock, others
	logic       empty;
	logic [7:0] data_in;
	logic       rd;
	logic [4:0] dmod;
	logic       mod_en;

	data_mod inst_data_mod
		(
			.clk     (clk),
			.reset_n (reset_n),
			.empty   (empty),
			.data_in (data_in),
			.rd      (rd),
			.dmod    (dmod),
			.mod_en  (mod_en)
		);

	task init();
		empty   <= '1;
		data_in <= '0;
	endtask

	task drive(int num, int iter);
		for (int j = 0; j < num; j++) begin
			for(int it = 0; it < iter; it++) begin
			empty   <= '0;
			if (it!= 3'd2 && it!= 3'd5 && it!= 3'd7) begin
				data_in <= $urandom_range(0,255);
			end else begin
				data_in <= '0;
			end
			@(posedge clk);
		end
		end	
	endtask

	initial begin
		// do something

		init();
		repeat(20)@(posedge clk);

		drive(5, 8);

		repeat(40)@(posedge clk);
		$finish;
	end
	// dump wave
	initial begin
		$display("random seed : %0d", $unsigned($get_initial_random_seed()));
		if ( $test$plusargs("fsdb") ) begin
			$fsdbDumpfile("tb_data_mod.fsdb");
			$fsdbDumpvars(0, "tb_data_mod");
		end
	end
endmodule
