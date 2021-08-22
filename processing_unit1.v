`timescale 1ns / 1ps
module processing_Unit1 (instruction, Zflag, address, Bus_1, mem_word, load_r0, load_r1, load_r2,load_r3, Load_PC, Inc_PC, Sel_Bus_1_Mux, Load_IR, Load_Add_R, Load_Reg_Y, Load_Reg_Z, 
  Sel_Bus_2_Mux, clk, rst);

  parameter sizeOfWord = 8;
  parameter sizeOfOpcode = 4;
  parameter Sel1_size = 3;
  parameter Sel2_size = 2;

  output [sizeOfWord-1: 0] 	instruction, address, Bus_1;
  output 			Zflag;

  input [sizeOfWord-1: 0]  	mem_word;
  input load_r0, load_r1, load_r2, load_r3, Load_PC, Inc_PC;
  input [Sel1_size-1: 0] 	Sel_Bus_1_Mux;
  input [Sel2_size-1: 0] 	Sel_Bus_2_Mux;
  input     Load_IR, Load_Add_R, Load_Reg_Y, Load_Reg_Z;
  input 			clk, rst;

  wire	load_r0, load_r1, load_r2, load_r3;
  wire [sizeOfWord-1: 0] 	Bus_2;
  wire [sizeOfWord-1: 0] 	R0_out, R1_out, R2_out, R3_out;
  wire [sizeOfWord-1: 0] 	PC_count, Y_value, alu_out;
  wire 			alu_zero_flag;
  wire [sizeOfOpcode-1 : 0] 	
  opcode = instruction [sizeOfWord-1: sizeOfWord-sizeOfOpcode];

  register_unit 		R0 	(R0_out, Bus_2, load_r0, clk, rst);
  register_unit 		R1 	(R1_out, Bus_2, load_r1, clk, rst);
  register_unit 		R2 	(R2_out, Bus_2, load_r2, clk, rst);
  register_unit 		R3 	(R3_out, Bus_2, load_r3, clk, rst);
  register_unit 		Reg_Y 	(Y_value, Bus_2, Load_Reg_Y, clk, rst);
  d_flop 			Reg_Z 	(Zflag, alu_zero_flag, Load_Reg_Z, clk, rst);
  address_register 	Add_R	(address, Bus_2, Load_Add_R, clk, rst);
  instruction_register	IR	(instruction, Bus_2, Load_IR, clk, rst);
  program_counter 	PC	(PC_count, Bus_2, Load_PC, Inc_PC, clk, rst);
  Multiplexer_5ch 		Mux_1 	(Bus_1, R0_out, R1_out, R2_out, R3_out, PC_count, Sel_Bus_1_Mux);
  Multiplexer_3ch 		Mux_2	(Bus_2, alu_out, Bus_1, mem_word, Sel_Bus_2_Mux);
  alu_risc 		ALU	(alu_zero_flag, alu_out, Y_value, Bus_1, opcode);
endmodule 