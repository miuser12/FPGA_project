`timescale 1ns / 1ps
module instruction_register(data_out,data_in,load,clk,rst);
parameter word_size=8;
output data_out;
input [word_size-1:0] data_in;
input load;
input clk,rst;
reg [word_size-1:0] data_out;
always@(posedge clk or negedge rst)
if(rst==0)
data_out<=0;
else if(load)
data_out<=data_in;
endmodule