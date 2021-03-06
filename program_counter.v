`timescale 1ns / 1ps
module program_counter(count,data_in,load_pc,inc_pc,clk,rst);
parameter word_size=8;
output count;
input [word_size-1:0] data_in;
input load_pc,inc_pc;
input clk,rst;
reg [word_size-1:0] count;
always@(posedge clk or negedge rst)
if(rst==0)
count<=0;
else if(load_pc)
count<=data_in;
else if(inc_pc)
count<=count+1;
endmodule