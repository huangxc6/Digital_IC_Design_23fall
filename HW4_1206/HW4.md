# description
![req1](images/req1.png)

![req2](images/req2.png)

# clock_gen

产生三种不同频率的时钟

```verilog
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
		# 3000000 		// 3ms
		forever #(PERIOD_100M / 2) clk_100M = ~clk_100M ;
	end

endmodule
```

# clk_switch

根据`rcc_cr`的值选择时钟，初始时钟为`clk_10M`

```verilog
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
```



根据所选系统时钟将`rcc_cr_in`写入

```verilog
module rcc_cr (
	input clk_sys			,
	input rst_n  			,  // Asynchronous reset active low
	input [1:0] rcc_cr_in   ,

	output reg [1:0] rcc_cr 
);
	
	always @(posedge clk_sys or negedge rst_n) begin
		if (rst_n == 1'b0) begin
			rcc_cr <= 2'b00 ;
		end
		else begin
			rcc_cr <= rcc_cr_in ;
		end
	end

endmodule
```

# Testbench

```verilog
`timescale 1ns/1ps
module tb_clk_top ();

	// asynchronous reset
	logic rst_n;
	initial begin
		rst_n <= '1;
		#2000
		rst_n <= '0;
		#500
		rst_n <= '1;
	end

	// (*NOTE*) replace reset, clock, others
	parameter  PERIOD_10M = 100;
	parameter  PERIOD_32K = 31250;
	parameter PERIOD_100M = 10;

	logic [1:0] rcc_cr_in;
	logic       clk_sys;

	clk_top #(
			.PERIOD_10M(PERIOD_10M),
			.PERIOD_32K(PERIOD_32K),
			.PERIOD_100M(PERIOD_100M)
		) inst_clk_top (
			.rst_n     (rst_n),
			.rcc_cr_in (rcc_cr_in),
			.clk_sys   (clk_sys)
		);

	task init();
		rcc_cr_in <= 2'b00;
	endtask

	task drive(int iter);
		for(int it = 0; it < iter; it++) begin
			rcc_cr_in <= it;
			# 2000000;  // 2ms
		end
	endtask

	initial begin
		// do something

		init();
		# 3000 		// 3us
		drive(3);

		# 3000 
		$finish;
	end
	// dump wave
	initial begin
		$display("random seed : %0d", $unsigned($get_initial_random_seed()));
		if ( $test$plusargs("fsdb") ) begin
			$fsdbDumpfile("tb_clk_top.fsdb");
			$fsdbDumpvars(0, "tb_clk_top");
		end
	end
endmodule

```

# waveform

![wave](images/wave.png)

波形如图所示，`rcc_cr`为00时，`d_10M`为1，选择`clk_10M`；

![10M](images/10M.png)

`rcc_cr`为00时，`d_32K`为01，选择`clk_32K`；

![32K](images/32K.png)

`rcc_cr`为10时，`d_100M`为1，选择`clk_100M`。

![100M](images/100M.png)



更改`Testbench`，可见初始选择`clk_10M`

![init](images/init.png)