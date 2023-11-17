module FIFO64x8 (
    input wire [7:0]  data_in ,
    input wire        wr_en   ,
    input wire        reset_n ,
    input wire        clk     ,
    input wire        rd_en   ,

    output wire [7:0] data_o  ,
    output reg        full    ,
    output reg        empty
);

reg [5:0] wr_count  ;
reg [5:0] rd_count  ;  

reg [5:0] dif       ; // the difference between wr_count and rd_count

  always @(*) begin
    dif = wr_count - rd_count ;
    if (dif <= 6'b010000) begin  // the num in fifo less than 16, set empty 
      empty = 1 ; 
      full  = 0 ;
    end else if (dif >= 6'b110000) begin // the num in fifo more than 48, set full
      empty = 0 ;
      full  = 1 ;
    end else begin
      empty = 0 ;
      full  = 0 ;
    end
  end

  S65NLLHS2PH64x8 u_S65NLLHS2PH64x8(
    .QA   (data_o     ),
    .CLKA (~clk       ),
    .CLKB (~clk       ),
    .CENA (~rd_en     ),
    .CENB (~wr_en     ),
    .BWENB(~{8{wr_en}}),
    .AA   (rd_count   ),
    .AB   (wr_count   ),
    .DB   (data_in    )
    );

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      rd_count <= 0 ;
      wr_count <= 0 ;
    end else begin
      if (wr_en) begin
        wr_count <= wr_count + 1'b1;
      end else begin
        wr_count <= wr_count;
      end
      if (rd_en) begin
        rd_count <= rd_count + 1'b1;
      end else begin
        rd_count <= rd_count;
      end
    end
  end
endmodule
