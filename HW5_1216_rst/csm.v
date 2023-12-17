module csm (
	input clk_osc,	// 48MHz
	input clk_rc ,  // 32768Hz
	input switch ,  // switch = 0, choose clk_rc
	input rst_n_rc,
	
	output wire clk	
);
	reg clk_osc_neg_r ;
	reg clk_rc_neg_r  ;

	parameter stage = 2 ;
	reg [stage-1 : 0] clk_osc_syn_r ;
	reg [stage-1 : 0] clk_rc_syn_r  ;

	wire clk_osc_sel ;
	wire clk_rc_sel  ;

	assign clk_osc_sel =  switch && ~clk_rc_neg_r ;
	assign clk_rc_sel  = ~switch && ~clk_osc_neg_r;

	// deal clk_osc 
	always @(posedge clk_osc or negedge rst_n_rc) begin
		if (rst_n_rc == 1'b0) begin
			clk_osc_syn_r <= '0;
		end else begin
			clk_osc_syn_r <= {clk_osc_syn_r[stage-2:0], clk_osc_sel};
		end
	end

	always @(negedge clk_osc or negedge rst_n_rc) begin
		if (rst_n_rc == 1'b0) begin
			clk_osc_neg_r <= '0;
		end else begin
			clk_osc_neg_r <= clk_osc_syn_r[stage-1] ;
		end
	end

	// deal clk_rc
	always @(posedge clk_rc or negedge rst_n_rc) begin
		if (rst_n_rc == 1'b0) begin
			clk_rc_syn_r <= '0 ;
		end else begin
			clk_rc_syn_r <= {clk_rc_syn_r[stage-2:0], clk_rc_sel};
		end
	end

	always @(negedge clk_rc or negedge rst_n_rc) begin
		if (rst_n_rc == 1'b0) begin
			clk_rc_neg_r <= '0 ;
		end else begin 
			clk_rc_neg_r <= clk_rc_syn_r[stage-1] ;
		end
	end
	
	// clk output
	assign clk = (clk_osc_neg_r && clk_osc) || (clk_rc_neg_r && clk_rc) ;

endmodule