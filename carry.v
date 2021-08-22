`timescale 1ns / 1ps
module carry(cf,a);
output cf;
reg cf;
input [8:0] a;
parameter one=1;
parameter zero=0;
always@(a)
case(a[8])
one:cf=1;
zero:cf=0;
endcase
endmodule