module data_trans (
	input wire			clk		,    // Clock
	input wire			reset_n	,  // Asynchronous reset active low
	input wire			start 	,
	input wire	[7:0]	data_in ,
	input wire			byte_en ,

	output reg	[7:0]	data_o 	,
	output reg			data_en
);
	
	reg state 		;		// state = 0 means GET 0 BITS, state = 1 means GET 4 BITS
	reg [3:0] tmp   ;		// tmp is data_in[3:0] in the next GET 4 BITS state

	always @(posedge clk or negedge reset_n) begin
		if(~reset_n) begin
			data_o  <= 8'h00 ;
			data_en <= 1'b0  ;
			state   <= 1'b0  ;
			tmp 	<= 4'h0  ;
		end else begin
			if (start) begin
				if (byte_en == 1'b1) begin
					if (state == 1'b0) begin
						data_o  <= data_in ;
						data_en <= 1'b1    ;
						state   <= 1'b0    ;
					end else begin
						data_o  <= {tmp, data_in[7:4]} 	;
						data_en <= 1'b1 				;
						state   <= 1'b1					;
						tmp     <= data_in[3:0] 		;
					end				
				end else begin   // 4bits enable
					if (state == 1'b0) begin
						data_o  <= {data_o[7:4], data_in[3:0]} 	;
						tmp     <= data_in[3:0] 				;
						data_en <= 1'b0 						;
						state   <= 1'b1   						;
					end else begin
						data_o <= {tmp, data_in[3:0]} 	;
						data_en <= 1'b1 				;
						state <= 1'b0					;
					end
				end
			end else begin
				data_o <= 8'h00  ;
				data_en <= 1'b0  ;
			end
		end
	end

endmodule