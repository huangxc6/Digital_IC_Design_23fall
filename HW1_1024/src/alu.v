// -----------------------------------------------------------------------------
// Copyright (c) 2014-2023 All rights reserved
// -----------------------------------------------------------------------------
// Author : Huang Xiaochong huangxc@stu.pku.edu.cn
// File   : alu.v
// Create : 2023-10-27 12:02:59
// Revise : 2023-10-27 12:02:59
// Editor : sublime text4, tab size (4)
// -----------------------------------------------------------------------------
/* Description:
    This is a 1 bit alu
*/
// Version: 0.1
// -----------------------------------------------------------------------------

module alu (
  input       a       ,
  input       b       ,
  input       cin     ,
  input       M       ,
  input [3:0] s       ,
  output      sum     ,
  output      cout
  );

    wire    g ;     // generate signal 
    wire    p ;     // pass signal

    assign g   =   s[3] & a & b || s[2] & a & ~b || ~M ;
    assign p   = ~(s[3] & a & b || s[2] & a & ~b || s[1] & ~a & b || s[0] & ~a & ~b );
    assign sum = p ^ cin      ;
    assign cout= g || p & cin ; 


endmodule
