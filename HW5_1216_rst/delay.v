module delay (
	input clk_rc ,
	input POR_n  ,

	output wire switch	,
	output reg rst_n_rc
);
	

	// Asynchronous reset, synchronous release
	reg rst_n_rc_pre ;
	// reg rst_n_rc     ;

	always @(posedge clk_rc or negedge POR_n) begin
		if (POR_n == 1'b0) begin
			rst_n_rc_pre <= 1'b0 ;
			rst_n_rc     <= 1'b0 ;
		end
		else begin
			rst_n_rc_pre <= 1'b1         ;
			rst_n_rc     <= rst_n_rc_pre ;
		end
	end

	// count to 128, switch set
	reg [7:0] cnt ;
	assign switch = cnt[7] ;
	always @(posedge clk_rc or negedge rst_n_rc) begin
		if (rst_n_rc == 1'b0) begin
			cnt <= 8'b0000_0000 ;
		end
		else if (switch == 1'b0) begin
				cnt <= cnt + 1'b1 ;
			end
	end

endmodule