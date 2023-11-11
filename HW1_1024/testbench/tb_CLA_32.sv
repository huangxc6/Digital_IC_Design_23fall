`timescale 1ns/1ps

module tb_CLA_32 (); 
	
	logic [31:0] a;
	logic [31:0] b;
	logic        cin;
	logic [31:0] sum;
	logic        cout;
	integer error_count ;

	CLA_32 inst_CLA_32 (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

	task init();
		a   <= '0;
		b   <= '0;
		cin <= '0;
		error_count <= '0 ;
	endtask

	task drive(int iter);
		for(int it = 0; it < iter; it++) begin
			// a <= it ;
			// b <= it + 1 ;
			// cin <= 0 ;
			a   <= $random() ;
			b   <= $random() ;
			cin <= $urandom_range(0,1) ;
			if ({cout, sum} !== (a + b + cin)) begin
      			error_count = error_count + 1;
      			if (error_count <= 10) begin
        			$display("***ERROR at time = %0d ***", $time);
        			$display("a = %h, b = %h, sum = %h;  cin = %h, cout = %h",
                	  			a, b, sum, cin, cout);
      				end
      			if (error_count == 10) begin
        			$display("\n\nError count reached 10, subsequent error messages are suppressed");
      				end
				end
			#50 ;
		end
	endtask

	initial begin
		// do something

		init();

		drive(200);

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
