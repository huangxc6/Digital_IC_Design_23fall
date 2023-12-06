// -----------------------------------------------------------------------------
// Copyright (c) 2014-2023 All rights reserved
// -----------------------------------------------------------------------------
// Author : Huang Xiaochong huangxc@stu.pku.edu.cn
// File   : clk_switch.v
// Create : 2023-12-06 11:22:39
// Revise : 2023-12-06 13:05:52
// Editor : sublime text4, tab size (4)
// -----------------------------------------------------------------------------
/* Description:

*/
// Version: 0.1
// -----------------------------------------------------------------------------
module clk_switch (
	input 		clk_10M        ,    // clock 10M frequency
	input 		clk_32K        ,	// clock 32K frequency
	input 		clk_100M       ,	// clock 100M frequency
	input 		rst_n	       ,    // Asynchronous reset active low
	input [1:0] rcc_cr 		   ,

	output wire clk_sys
);

/*-----------------------------------------------\
 --      	  wire & reg decleration 	        --
\-----------------------------------------------*/
	wire d_10M;
	reg [2 : 0] clk_10M_reg 	;
	reg [1 : 0] clk_10M_neg_reg ;

	wire d_32K;
	reg [2 : 0] clk_32K_reg 	;
	reg [1 : 0] clk_32K_neg_reg ;

	wire d_100M;
	reg [2 : 0] clk_100M_reg 	;
	reg [1 : 0] clk_100M_neg_reg ;

/*-----------------------------------------------\
 --         	d signal generate 	           --
\-----------------------------------------------*/
    assign d_10M  = (~rcc_cr[1] && ~rcc_cr[0]) && ~clk_32K_neg_reg[1] && ~clk_100M_neg_reg[1];
    assign d_32K  = (~rcc_cr[1] &&  rcc_cr[0]) && ~clk_10M_neg_reg[1] && ~clk_100M_neg_reg[1] ;
    assign d_100M = ( rcc_cr[1] && ~rcc_cr[0]) && ~clk_10M_neg_reg[1] && ~clk_32K_neg_reg[1] ;

/*-----------------------------------------------\
 --         sync signal generate          --
\-----------------------------------------------*/
	// clk_10M
    always @(posedge clk_10M or negedge rst_n) begin
    	if (rst_n == 1'b0) begin
    		clk_10M_reg <= 3'b111 ;
    	end
    	else begin
    		clk_10M_reg <= {clk_10M_reg[1:0], d_10M} ;
    	end
    end

    always @(negedge clk_10M or negedge rst_n) begin
    	if (rst_n == 1'b0) begin
    		clk_10M_neg_reg <= 2'b11 ;
    	end
    	else begin
    		clk_10M_neg_reg <= {clk_10M_neg_reg[0], clk_10M_reg[2]} ;
    	end
    end

    // clk_32K
    always @(posedge clk_32K or negedge rst_n) begin
    	if (rst_n == 1'b0) begin
    		clk_32K_reg <= 3'b000 ;
    	end
    	else begin
    		clk_32K_reg <= {clk_32K_reg[1:0], d_32K} ;
    	end
    end

    always @(negedge clk_32K or negedge rst_n) begin
    	if (rst_n == 1'b0) begin
    		clk_32K_neg_reg <= 2'b00 ;
    	end
    	else begin
    		clk_32K_neg_reg <= {clk_32K_neg_reg[0], clk_32K_reg[2]} ;
    	end
    end

    // clk_100M
    always @(posedge clk_100M or negedge rst_n) begin
    	if (rst_n == 1'b0) begin
    		clk_100M_reg <= 3'b000 ;
    	end
    	else begin
    		clk_100M_reg <= {clk_100M_reg[1:0], d_100M} ;
    	end
    end

    always @(negedge clk_100M or negedge rst_n) begin
    	if (rst_n == 1'b0) begin
    		clk_100M_neg_reg <= 2'b00 ;
    	end
    	else begin
    		clk_100M_neg_reg <= {clk_100M_neg_reg[0], clk_100M_reg[2]} ;
    	end
    end

/*-----------------------------------------------\
 --    		     clk_sys generate  		        --
\-----------------------------------------------*/
    wire clk_10M_gate  ;
    wire clk_32K_gate  ;
    wire clk_100M_gate ;

    and(clk_10M_gate , clk_10M , clk_10M_neg_reg[1])  ;
    and(clk_32K_gate , clk_32K , clk_32K_neg_reg[1])  ;
    and(clk_100M_gate, clk_100M, clk_100M_neg_reg[1]) ;

    or(clk_sys, clk_10M_gate, clk_32K_gate, clk_100M_gate);

endmodule