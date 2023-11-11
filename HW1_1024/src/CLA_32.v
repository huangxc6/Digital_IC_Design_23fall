// -----------------------------------------------------------------------------
// Copyright (c) 2014-2023 All rights reserved
// -----------------------------------------------------------------------------
// Author : Huang Xiaochong huangxc@stu.pku.edu.cn
// File   : CLA_32.v
// Create : 2023-10-27 10:13:40
// Revise : 2023-10-27 10:13:40
// Editor : sublime text4, tab size (4)
// -----------------------------------------------------------------------------
/* Description:
    This is a 32 bits Carry Lookahead Adder using 4 bits Carry Lookahead Adder.
*/
// Version: 0.1
// -----------------------------------------------------------------------------
`timescale 1ns/1ps
module CLA_32(
    input [31:0]    a ,
    input [31:0]    b ,
    input           cin ,

    output [31:0]   sum ,
    output          cout   
);

wire   [8:0] c ;
assign c[0] = cin ;
assign cout = c[8]  ;

generate
    genvar i ;
    for (i = 0; i < 8; i = i + 1) begin: CLA_4
        CLA_4 i( 
            .a   (a[4*(i+1) - 1 : 4*i]   ) ,
            .b   (b[4*(i+1) - 1 : 4*i]   ) ,
            .cin (c[i]                   ) ,
            .sum (sum[4*(i+1) - 1 : 4*i] ),
            .cout(c[i+1]                 )
        );
    end
endgenerate
    
endmodule //adder32
