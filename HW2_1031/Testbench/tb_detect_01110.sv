
`timescale 1ns/1ps
module tb_detect_01110 ();

	// clock
	logic clk;
	initial begin
		clk = '0;
		forever #(0.5) clk = ~clk;
	end

	// asynchronous reset
	logic clr;
	initial begin
		clr <= '0;
		#10
		clr <= '1;
	end

	// (*NOTE*) replace reset, clock, others
	parameter IDLE          = 3'b000;
	parameter DETECT_0      = 3'b001;
	parameter DETECT_01     = 3'b010;
	parameter DETECT_011    = 3'b011;
	parameter DETECT_0111   = 3'b100;
	parameter DETECT_011100 = 3'b101;
	parameter DETECT_011101 = 3'b110;

	logic A    ;
	logic B    ;
	logic Z    ;

	detect_01110 #(
		.IDLE         (IDLE         ),
		.DETECT_0     (DETECT_0     ),
		.DETECT_01    (DETECT_01    ),
		.DETECT_011   (DETECT_011   ),
		.DETECT_0111  (DETECT_0111  ),
		.DETECT_011100(DETECT_011100),
		.DETECT_011101(DETECT_011101)
	) inst_detect_01110 (
		.clk(clk),
		.clr(clr),
		.A  (A  ),
		.B  (B  ),
		.Z  (Z  )
	);

	task init();
		A   <= '0;
		B   <= '0;
	endtask

	task drive(int iter);
		for(int it = 0; it < iter; it++) begin
			A   <= $urandom_range(0,1);
			B   <= $urandom_range(0,1);
			@(posedge clk);
		end
	endtask

	initial begin
		// do something

		init();
		repeat(10)@(posedge clk);

		drive(500);

		A   <= 0;
		B   <= 1;
		@(posedge clk);

		A   <= 1;
		B   <= 1;
		@(posedge clk);

		A   <= 0;
		B   <= 0;
		@(posedge clk);

		repeat(10)@(posedge clk);
		$finish;
	end

endmodule
