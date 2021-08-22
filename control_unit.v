`timescale 1ns / 1ps
module control_unit(load_r0,load_r1,load_r2,load_r3,load_pc,inc_pc,sel_bus_1_mux,sel_bus_2_mux,load_ir,load_add_r,load_reg_y,load_reg_z,write,instruction,zero,clk,rst);
parameter word_size=8,op_size=4,state_size=4;
parameter src_size=2,dest_size=2,sel1_size=3,sel2_size=2;
parameter s_idle=0,s_fet1=1,s_fet2=2,s_dec=3;
parameter s_ex1=4,s_rd1=5,s_rd2=6;
parameter s_wr1=7,s_wr2=8,s_br1=9,s_br2=10,s_halt=11;
parameter nop=0,add=1,sub=2,AND=3,NOT=4;
parameter rd=5,wr=6,br=7,brz=8;
parameter r0=0,r1=1,r2=2,r3=3;
output load_r0,load_r1,load_r2,load_r3;
output load_pc,inc_pc;
output [sel1_size-1:0] sel_bus_1_mux;
output load_ir,load_add_r;
output load_reg_y,load_reg_z;
output [sel2_size-1:0] sel_bus_2_mux;
output write;
input [word_size-1:0] instruction;
input zero;
input clk,rst;
reg [state_size-1:0] state,next_state;
reg load_r0,load_r1,load_r2,load_r3,load_pc,inc_pc;
reg load_ir,load_add_r,load_reg_y;
reg sel_alu,sel_bus_1,sel_mem;
reg sel_r0,sel_r1,sel_r2,sel_r3,sel_pc;
reg load_reg_z,write;
reg err_flag;
wire [op_size-1:0] opcode=instruction[word_size-1:word_size-op_size];
wire [src_size-1:0] src=instruction[src_size+dest_size-1:dest_size];
wire [dest_size-1:0] dest=instruction[dest_size-1:0];
assign sel_bus_1_mux[sel1_size-1:0]=sel_r0?0:sel_r1?1:sel_r2?2:sel_r3?3:sel_pc?4:3'bx;
assign sel_bus_2_mux[sel2_size-1:0]=sel_alu?0:sel_bus_1?1:sel_mem?2:2'bx;
always@(posedge clk or negedge rst)
begin:state_transitions
if(rst==0)
state<=s_idle;
else state<=next_state;
end
always@(state or opcode or src or dest or zero)
begin:
output_and_next_state
sel_r0=0;
sel_r1=0;
sel_r2=0;
sel_r3=0;
sel_pc=0;
load_r0=0;
load_r1=0;
load_r2=0;
load_r3=0;
load_pc=0;
load_ir=0;
inc_pc=0;
sel_alu=0;
sel_bus_1=0;
sel_mem=0;
write=0;
err_flag=0;
next_state=state;
case(state)
s_idle: next_state=s_fet1;
s_fet1: begin
next_state=s_fet2;
sel_pc=1;
sel_bus_1=1;
load_add_r=1;
end
s_fet2:
begin
next_state=s_dec;
sel_mem=1;
load_ir=1;
inc_pc=1;
end
s_dec: case(opcode)
nop: next_state=s_fet1;
add,sub,AND: begin
next_state=s_ex1;
sel_bus_1=1;
load_reg_y=1;
case(src)
r0:sel_r0=1;
r1:sel_r1=1;
r2:sel_r2=1;
r3:sel_r3=1;
default: err_flag=1;
endcase
end
NOT: begin
next_state=s_fet1;
load_reg_z=1;
sel_bus_1=1;
sel_alu=1;
case(src)
r0:sel_r0=1;
r1:sel_r1=1;
r2:sel_r2=1;
r3:sel_r3=1;
default: err_flag=1;
endcase
case(dest)
r0:load_r0=1;
r1:load_r1=1;
r2:load_r2=1;
r3:load_r3=1;
default: err_flag=1;
endcase
end
rd: begin
next_state=s_rd1;
sel_pc=1;
sel_bus_1=1;
load_add_r=1;
end
wr:
begin
next_state=s_wr1;
sel_pc=1;
sel_bus_1=1;
load_add_r=1;
end
br: begin
next_state=s_br1;
sel_pc=1;
sel_bus_1=1;
load_add_r=1;
end
brz: if(zero==1)
begin
next_state=s_br1;
sel_pc=1;
sel_bus_1=1;
load_add_r=1;
end
else
begin
next_state=s_fet1;
inc_pc=1;
end
default:next_state=s_halt;
endcase
s_ex1:
begin
next_state=s_fet1;
load_reg_z=1;
sel_alu=1;
case(dest)
r0:begin
sel_r0=1;
load_r0=1;
end
r1:begin
sel_r1=1;
load_r1=1;
end
r2:begin
sel_r2=1;
load_r2=1;
end
r3:begin
sel_r3=1;
load_r3=1;
end
default:err_flag=1;
endcase
end
s_rd1: begin
next_state=s_rd2;
sel_mem=1;
load_add_r=1;
inc_pc=1 ;
end
s_wr1: begin
next_state=s_wr2;
sel_mem=1;
load_add_r=1;
inc_pc=1 ;
end
s_rd2: begin
next_state=s_fet1;
sel_mem=1;
case(dest)
r0:load_r0=1;
r1:load_r1=1;
r2:load_r2=1;
r3:load_r3=1;
default: err_flag=1;
endcase
end
s_wr2: begin
next_state=s_fet1;
write=1;
case(src)
r0:load_r0=1;
r1:load_r1=1;
r2:load_r2=1;
r3:load_r3=1;
default: err_flag=1;
endcase
end
s_br1: begin
next_state=s_br2;
sel_mem=1;
load_add_r=1;
end
s_br2: begin
next_state=s_fet1;
sel_mem=1;
load_pc=1;
end
s_halt: next_state=s_halt;
default: next_state=s_idle;
endcase
end
endmodule