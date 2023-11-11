module shifter_4 (
	input clk		,   // Clock

	input ld		,	// Set D to Q
	input [3:0] D 	, 

	input sr  		,   // righr shift
	input D_sr		,

	input sl  		,  //  left shift
	input D_sl		,

	output reg [3:0] Q
	
);

	always @(posedge clk) begin
		if(ld) begin
			Q <= D ;
		end else begin
			if (sr) begin
				Q = {D_sr, Q[3:1]} ;
			end
			else begin
				if (sl) begin
					Q = {Q[2:0], D_sl};
				end
			end
		end
	end

endmodule
