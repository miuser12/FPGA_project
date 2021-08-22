`timescale 1ns/1ps
module a_carry(acf,b);
output acf;
reg acf;
input [8:0] b;
parameter one=1;
parameter zero=0;
always@(b)
case(b[4])
one:acf=1;
zero:acf=0;
endcase
endmodule