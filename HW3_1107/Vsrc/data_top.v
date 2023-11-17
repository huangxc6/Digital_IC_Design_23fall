module data_top (
	input wire			clk		,    // Clock
	input wire			reset_n	,    // Asynchronous reset active low
	input wire			start 	,
	input wire	[7:0]	data_in ,
	input wire			byte_en ,

	output reg  [4:0]   dmod    ,
	output reg 		    mod_en  ,
	output reg		    full
	  
);
	reg	[7:0]	data_o_trans  ;
	reg	[7:0]	data_o_fifo   ;
	reg			data_en		  ;
	reg			rd 			  ;


	data_trans inst_data_trans
		(
			.clk     (clk),
			.reset_n (reset_n),
			.start   (start),
			.data_in (data_in),
			.byte_en (byte_en),
			.data_o  (data_o_trans),
			.data_en (data_en)
		);

	FIFO64x8 inst_FIFO64x8
		(
			.data_in (data_o_trans),
			.wr_en   (data_en),
			.reset_n (reset_n),
			.clk     (clk),
			.rd_en   (rd),
			.data_o  (data_o_fifo),
			.full    (full),
			.empty   (empty)
		);

	data_mod inst_data_mod
		(
			.clk     (clk),
			.reset_n (reset_n),
			.empty   (empty),
			.data_in (data_o_fifo),
			.rd      (rd),
			.dmod    (dmod),
			.mod_en  (mod_en)
		);



endmodule