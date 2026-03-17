
//i_decoder_sc----把i_decoder转成时序逻辑--DFF打一拍

`include "defines.v"

module i_decoder_sc(				
	input				clk,
	input 				rst_n,
	input wire			hold_flag_i,
	
	input wire[31:0]	inst_i,
	input wire[31:0]	inst_addr_i,
	input wire[31:0]	opD1_i,
	input wire[31:0]	opD2_i,
	input wire[4:0]		rd_addr_i,
	input wire			rd_wen_i,
	input wire[31:0]	base_addr_i,
	input wire[31:0]	offset_addr_i,
	
	output wire[31:0]	inst_o,
	output wire[31:0]	inst_addr_o,
	output wire[31:0]	opD1_o,
	output wire[31:0]	opD2_o,
	output wire[4:0]	rd_addr_o,
	output wire			rd_wen_o,
	output wire[31:0]	base_addr_o,
	output wire[31:0]	offset_addr_o
);

	dff #(32)	dff1(clk,rst_n,hold_flag_i,`INST_NOP,inst_i,inst_o);
	dff #(32)	dff2(clk,rst_n,hold_flag_i,32'b0,inst_addr_i,inst_addr_o);
	
	dff #(32)	dff3(clk,rst_n,hold_flag_i,32'b0,opD1_i,opD1_o);
	dff #(32)	dff4(clk,rst_n,hold_flag_i,32'b0,opD2_i,opD2_o);
	dff #(5)	dff5(clk,rst_n,hold_flag_i,5'b0,rd_addr_i,rd_addr_o);
	dff #(1)	dff6(clk,rst_n,hold_flag_i,1'b0,rd_wen_i,rd_wen_o);
	dff #(32)	dff7(clk,rst_n,hold_flag_i,32'b0,base_addr_i,base_addr_o);
	dff #(32)	dff8(clk,rst_n,hold_flag_i,32'b0,offset_addr_i,offset_addr_o);
	
endmodule
