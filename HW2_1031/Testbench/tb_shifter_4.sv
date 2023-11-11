
`timescale 1ns/1ps
module tb_shifter_4 (); 

	// clock
	logic clk;
	initial begin
		clk = '0;
		forever #(0.5) clk = ~clk;
	end

	// (*NOTE*) replace reset, clock, others
	logic       ld;
	logic [3:0] D;
	logic       sr;
	logic       D_sr;
	logic       sl;
	logic       D_sl;
	logic [3:0] Q;

	shifter_4 inst_shifter_4 (.clk(clk), .ld(ld), .D(D), .sr(sr), .D_sr(D_sr), .sl(sl), .D_sl(D_sl), .Q(Q));

	task init();
		ld   <= '0;
		D    <= '0;
		sr   <= '0;
		D_sr <= '0;
		sl   <= '0;
		D_sl <= '0;
	endtask

	task drive(int iter);
		for(int it = 0; it < iter; it++) begin
			ld   <= $urandom_range(0,1);
			D    <= $urandom_range(0,15);
			sr   <= $urandom_range(0,1);
			D_sr <= $urandom_range(0,1);
			sl   <= $urandom_range(0,1);
			D_sl <= $urandom_range(0,1);
			@(posedge clk);
		end
	endtask

	initial begin
		// do something

		init();
		repeat(10)@(posedge clk);

		drive(200);

		repeat(10)@(posedge clk);
		$finish;
	end
	
endmodule
