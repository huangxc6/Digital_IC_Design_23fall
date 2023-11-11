// -----------------------------------------------------------------------------
// Copyright (c) 2014-2023 All rights reserved
// -----------------------------------------------------------------------------
// Author : Huang Xiaochong huangxc@stu.pku.edu.cn
// File   : CLA_4.v
// Create : 2023-10-26 20:41:14
// Revise : 2023-10-26 22:04:34
// Editor : sublime text4, tab size (2)
// -----------------------------------------------------------------------------
/* Description:
   This is a 4 bits Carry Lookahead adder
*/
// Version: 0.1
// -----------------------------------------------------------------------------

module CLA_4(
  input   [3:0] a    ,
  input   [3:0] b    ,
  input         cin ,
  output  [3:0] sum  ,
  output        cout
  );
    wire   [4:0] G,P,c ;
    assign c[0] = cin ;

    assign P = a ^ b ;
    assign G = a & b ;
    assign c[1] = G[0] | (P[0] & c[0]) ; 
    assign c[2] = G[1] | (P[1] & (G[0] | (P[0] & c[0])));
    assign c[3] = G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & c[0])))));
    assign c[4] = G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & c[0])))))));
    assign sum  = P ^ c[3 :0];
    assign cout = c[4] ;

endmodule
