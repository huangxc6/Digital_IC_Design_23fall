`timescale 1ns/1ns

module tb_CLA_4;

reg [3:0] a_test, b_test;
wire [3:0] sum_test;
reg cin_test;
wire cout_test;
reg [9:0] test;
integer error_count;

CLA_4 u1( .a(a_test), .b(b_test), .cin(cin_test), .sum(sum_test), .cout(cout_test) );

initial
begin
  error_count = 0;
end

initial
begin
  for (test = 0; test <= 9'h1ff; test = test +1) begin
    cin_test = test[8];
    a_test = test[7:4];
    b_test = test[3:0];
    #50
    if ({cout_test, sum_test} !== (a_test + b_test + cin_test)) begin
      error_count = error_count + 1;
      if (error_count <= 10) begin
        $display("***ERROR at time = %0d ***", $time);
        $display("a = %h, b = %h, sum = %h;  cin = %h, cout = %h",
                  a_test, b_test, sum_test, cin_test, cout_test);
      end
      if (error_count == 10) begin
        $display("\n\nError count reached 10, subsequent error messages are suppressed");
      end
    end
    #50;
  end
  if (error_count == 0)
    $display("*** Testbench Successfully Completed! ***");
  else begin
    $display("\n*********************************************");
    $display("*** Testbench completed with %0d errors ***",error_count);
    $display("*********************************************\n\n");
  end
  $finish;
end

endmodule
