`timescale 1ns / 1ps
module alu_risc(alu_zero_flag,alu_out,data_1,data_2,sel);
parameter word_size=8;
parameter op_size=4;
parameter nop=4'b0000;
parameter add=4'b0001;
parameter sub=4'b0010;
parameter AND=4'b0011;
parameter NOT=4'b0100;
parameter rd=4'b0101;
parameter wr=4'b0110;
parameter br=4'b0111;
parameter brz=4'b1000;
output alu_zero_flag;
output alu_out;
input [word_size-1:0] data_1,data_2;
input[op_size-1:0] sel;
reg[word_size-1:0] alu_out;
assign alu_zero_flag=~|alu_out;
always@(sel or data_1 or data_2)
case(sel)
nop: alu_out=0;
add: alu_out=data_1+data_2;
sub: alu_out=data_2-data_1;
AND: alu_out=data_1&data_2;
NOT: alu_out=~data_2;
default : alu_out=0;
endcase
endmodule