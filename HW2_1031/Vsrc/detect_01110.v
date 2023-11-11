// -----------------------------------------------------------------------------
// Copyright (c) 2014-2023 All rights reserved
// -----------------------------------------------------------------------------
// Author : Huang Xiaochong huangxc@stu.pku.edu.cn
// File   : detect_01110.v
// Create : 2023-10-31 11:41:55
// Revise : 2023-11-02 14:50:36
// Editor : sublime text4, tab size (4)
// -----------------------------------------------------------------------------
/* Description:

*/
// Version: 0.1
// -----------------------------------------------------------------------------
`timescale 1ns/1ps

module detect_01110 (
	input wire clk		,    // Clock
	input wire clr		,  // Asynchronous reset active low 
	input wire A 		,
	input wire B 		,

	output wire Z
);

	parameter IDLE 		    = 3'b000  ;
	parameter DETECT_0      = 3'b001  ;
	parameter DETECT_01     = 3'b010  ;
	parameter DETECT_011    = 3'b011  ;
	parameter DETECT_0111   = 3'b100  ;
	parameter DETECT_011100 = 3'b101  ;
	parameter DETECT_011101 = 3'b110  ;

	reg [2:0] current_state, next_state ;

	// state transfer
	always @(posedge clk or negedge clr) begin : proc_current_state
		if(~clr) begin
			current_state <= IDLE ;
		end else begin
			current_state <= next_state;
		end
	end

	// state calculate
	always @(*) begin
		case (current_state)
			IDLE:begin
				case ({A, B})
					2'b00: next_state = DETECT_0 ;
					2'b01: next_state = DETECT_01;
					2'b10: next_state = DETECT_0 ;
					2'b11: next_state = IDLE	 ; 
				 	default : next_state = IDLE;
				 endcase 
			end
			DETECT_0:begin
				case ({A, B})
					2'b00: next_state = DETECT_0  ;
					2'b01: next_state = DETECT_01 ;
					2'b10: next_state = DETECT_0  ;
					2'b11: next_state = DETECT_011; 
				 	default : next_state = IDLE	  ;
				 endcase 
			end
			DETECT_01:begin
				case ({A, B})
					2'b00: next_state = DETECT_0   ;
					2'b01: next_state = DETECT_01  ;
					2'b10: next_state = DETECT_0   ;
					2'b11: next_state = DETECT_0111; 
				 	default : next_state = IDLE	   ;
				 endcase 
			end
			DETECT_011:begin
				case ({A, B})
					2'b00: next_state = DETECT_0    ;
					2'b01: next_state = DETECT_01   ;
					2'b10: next_state = DETECT_011101;
					2'b11: next_state = IDLE	    ; 
				 	default : next_state = IDLE	    ;
				 endcase 
			end	
			DETECT_0111:begin
				case ({A, B})
					2'b00: next_state = DETECT_011100 ;
					2'b01: next_state = DETECT_011101 ;
					2'b10: next_state = DETECT_0  	  ;
					2'b11: next_state = IDLE	      ;  
				 	default : next_state = IDLE	      ;
				 endcase 
			end
			DETECT_011100:begin
				case ({A, B})
					2'b00: next_state = DETECT_0 	  ;
					2'b01: next_state = DETECT_01 	  ;
					2'b10: next_state = DETECT_0  	  ;
					2'b11: next_state = IDLE	      ;  
				 	default : next_state = IDLE	      ;
				 endcase 
			end
			DETECT_011101:begin
				case ({A, B})
					2'b00: next_state = DETECT_0 	  ;
					2'b01: next_state = IDLE	 	  ;
					2'b10: next_state = DETECT_0  	  ;
					2'b11: next_state = IDLE		  ;  
				 	default : next_state = IDLE	      ;
				 endcase 
			end
		
			default : next_state = IDLE;
		endcase
		
	end

	// state output
	assign Z = (current_state == DETECT_011100    ) 
				|| (current_state == DETECT_011101) ; // detect 01110

endmodule
