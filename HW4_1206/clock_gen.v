// -----------------------------------------------------------------------------
// Copyright (c) 2014-2023 All rights reserved
// -----------------------------------------------------------------------------
// Author : Huang Xiaochong huangxc@stu.pku.edu.cn
// File   : clock_gen.v
// Create : 2023-12-06 11:30:19
// Revise : 2023-12-06 11:36:37
// Editor : sublime text4, tab size (4)
// -----------------------------------------------------------------------------
/* Description:
	generate the clock
*/
// Version: 0.1
// -----------------------------------------------------------------------------
`timescale 1ns/1ps
module clock_gen #(
	parameter PERIOD_10M  = 100  ,
	parameter PERIOD_32K  = 31250,
	parameter PERIOD_100M = 10   
	)(
	output reg clk_10M ,
	output reg clk_32K ,
	output reg clk_100M
);

	initial begin
		clk_10M = 1'b0 ;
		# 5000 		// 5us
		forever #(PERIOD_10M / 2) clk_10M = ~clk_10M ;
	end

	initial begin
		clk_32K = 1'b0 ;
		# 5000 		// 5us
		forever #(PERIOD_32K / 2) clk_32K = ~clk_32K ;
	end

	initial begin
		clk_100M = 1'b0 ;
		# 3_000_000 		// 3ms
		forever #(PERIOD_100M / 2) clk_100M = ~clk_100M ;
	end

endmodule