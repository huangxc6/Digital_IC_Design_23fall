module data_mod (
	input  wire  	  clk     , // Clock
	input  wire  	  reset_n , // Asynchronous reset active low
	input  wire 	  empty     ,	// FIFO empty
	input  wire [7:0] data_in ,

	output wire	      rd 	  ,	//FIFO rd_en
	output reg  [4:0] dmod    ,
	output reg 		  mod_en
);
	reg [2:0] state  	  ;
	reg [7:0] data_in_tmp ;
	// assign rd = ~rdy ;	// empty = 0, begin read FIFO

	assign rd = ~empty && state!= 3'd2 && state!= 3'd5 && state!= 3'd7;

	// always @(posedge clk or negedge reset_n) begin
	// 	if(~reset_n) begin
	// 		rd <= 1'b0;
	// 	end else begin
	// 		if (~empty && state!= 3'd2 && state!= 3'd5 && state!= 3'd7) begin
	// 			rd <= 1'b1;
	// 		end else begin
	// 			rd <= 1'b0;
	// 		end
	// 	end
	// end

	always @(posedge clk or negedge reset_n) begin : proc_state
		if(~reset_n) begin
			state <= 3'd0;
		end else begin
			if (~empty) begin
				state <= state + 1'b1 ;
			end
		end
	end

	always @(posedge clk or negedge reset_n) begin
		if(~reset_n) begin
			dmod   <= 5'd0;
			mod_en <= 1'b0;
			data_in_tmp <= 8'd0;
		end else begin
			if (~empty) begin
				data_in_tmp <= (state == 3'd2 || state == 3'd5 || state == 3'd7)
							  ? data_in_tmp : data_in;
				mod_en <= 1'b1 ;
				case (state)
					3'd0: dmod <= data_in[4:0] ;
					3'd1: dmod <= {data_in[1:0], data_in_tmp[7:5]} ;
					3'd2: dmod <= {data_in_tmp[6:2]} ; // rd = 0
					3'd3: dmod <= {data_in[3:0], data_in_tmp[7]} ;
					3'd4: dmod <= {data_in[0], data_in_tmp[7:4]} ;
					3'd5: dmod <= {data_in_tmp[5:1]} ; // rd = 0
					3'd6: dmod <= {data_in[2:0], data_in_tmp[7:6]} ;
					3'd7: dmod <= {data_in_tmp[7:3]} ; // rd = 0
				endcase
			end else begin
				dmod   <= 5'd0;
				mod_en <= 1'b0;
				data_in_tmp <= data_in_tmp;
			end
		end
	end

endmodule 