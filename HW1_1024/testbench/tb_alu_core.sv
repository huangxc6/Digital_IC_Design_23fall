`timescale 1ns/1ps

module tb_alu_core (); 

	parameter n = 32;

	logic [n-1: 0] opA;
	logic [n-1: 0] opB;
	logic  [3 : 0] S;
	logic          M;
	logic          Cin;
	logic [n-1: 0] DO;
	logic          C;
	logic          V;
	logic          N;
	logic          Z;

	integer test;
	integer error_count ;


	alu_core #(
			.n(n)
		) inst_alu_core (
			.opA (opA),
			.opB (opB),
			.S   (S),
			.M   (M),
			.Cin (Cin),
			.DO  (DO),
			.C   (C),
			.V   (V),
			.N   (N),
			.Z   (Z)
		);

	task init();
		opA <= '0;
		opB <= '0;
		S   <= '0;
		M   <= '0;
		Cin <= '0;
		error_count <= '0;
	endtask

	task drive(int iter);
		for(int it = 0; it < iter; it++) begin
			opA <= $random() ;
			opB <= $random() ;

			for (test = 0; test < 16; test++) begin
				S <= test	;
				# 50 ;
			end
		end
	endtask

	task calculate(int iter);
		
		for(int it = 0; it < iter; it++) begin
			opA <= $random() ;
			opB <= $random() ;

			Cin <= 0 ;
			S <= 4'b1001 ;	// add
			#50 ;
			if ({C, DO} != opA + opB) begin
				error_count += 1 ;
			end

			Cin <= 1 ;
			S <= 4'b0110 ;	// sub
			#50 ;
			if (DO != opA - opB) begin
				error_count += 1 ;
			end
		end

		#50 ;
	endtask 

	initial begin

		init();

		#50

		Cin = 1 ;
		M = 0 	;
		drive(10);	// Logical operations

		M = 1 	;
		calculate(100) ;	// calculate operations

		$finish;
	end
	
endmodule
