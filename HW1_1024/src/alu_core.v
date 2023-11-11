// -----------------------------------------------------------------------------
// Copyright (c) 2014-2023 All rights reserved
// -----------------------------------------------------------------------------
// Author : Huang Xiaochong huangxc@stu.pku.edu.cn
// File   : alu_core.v
// Create : 2023-10-27 11:59:06
// Revise : 2023-10-27 11:59:06
// Editor : sublime text4, tab size (4)
// -----------------------------------------------------------------------------
/* Description:
    This is a alu_core with the function of logic 
*/
// Version: 0.1
// -----------------------------------------------------------------------------

module alu_core #(
    parameter n = 32
    )(
    input wire [n-1: 0] opA , //操作数A
    input wire [n-1: 0] opB , //操作数B
    input wire [3  : 0] S   , //工作模式选择信号
    input wire          M   , //逻辑操作控制信号
    input wire          Cin , //进位输入信号

    output     [n-1: 0] DO ,  //数据输出
    output reg          C  ,  //进位输出
    output reg          V  ,  //溢出指示输出信号
    output reg          N  ,  // DO符号位输出信号
    output reg          Z     //DO为全0指示信号
);  

    wire    [n:0]   c     ;     // carry signal cin->cout n bits
    
    assign  c[0] = Cin    ;     // Cin
    
    generate                    // generate alu_core using 32 alus
        genvar i ;
        for (i = 0; i < 32; i = i + 1) begin:alu
            alu alu_i(
                .a(opA[i]     ) ,
                .b(opB[i]     ) ,
                .s(S          ) ,
                .M(M          ) ,
                .cin(c[i]     ) ,
                .sum(DO[i]    ) ,
                .cout(c[i+1]  )
            );
        end
    endgenerate
    
    always @(*) begin 
        C = c[n]    ;     // Cout
        Z = !(DO)   ;
        N = DO[n-1] ;
        V = (opA[n-1] == opB[n-1]) && (opA[n-1] != DO[n-1]) ;
    end

endmodule
