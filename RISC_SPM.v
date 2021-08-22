`timescale 1ns / 1ps
module RISC_SPM(clk,rst);
parameter word_size=8;
parameter sel1_size=3;
parameter sel2_size=2;
wire [sel1_size-1:0] sel_bus_1_mux;
wire [sel2_size-1:0] sel_bus_2_mux;
input clk,rst;
// data nets
wire zero;
wire [word_size-1:0]
instruction,address,bus_1,mem_word;
//control nets
wire
load_r0,load_r1,load_r2,load_r3,load_pc,inc_pc,load_ir;
wire load_add_r,load_reg_y,load_reg_z;
wire write;
processing_Unit1 P1(instruction,zero,address,bus_1,mem_word,load_r0,load_r1,load_r2,load_r3,load_pc,inc_pc,sel_bus_1_mux,load_ir,load_add_r,load_reg_y,load_reg_z,sel_bus_2_mux,clk,rst);
control_unit C1(load_r0,load_r1,load_r2,load_r3,load_pc,inc_pc,sel_bus_1_mux,sel_bus_2_mux,load_ir,load_add_r,load_reg_y,load_reg_z,write,instruction,zero,clk,rst);
memory_unit M1_SRAM(.data_out(mem_word),.data_in(bus_1),.address(address),.clk(clk),.write(write));
endmodule