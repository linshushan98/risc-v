
`include "defines.v"

module riscV_SOC(
	input				clk,
	input 				rst_n
);


wire [31:0] inst_addr_RV1_o;
wire [31:0] inst_ROM1_o;
wire 		id_mem_rd_req;
wire [31:0] id_mem_rd_addr;
wire [7:0]	mem_exe_rd_byte;
wire [15:0]	mem_exe_rd_halfword;
wire [31:0] mem_exe_rd_word;	
wire 		exe_mem_wr_req;
wire [31:0] exe_mem_wr_addr;
wire [31:0] exe_mem_wr_data;
wire [2:0]	exe_mem_wr_op_type;
riscV riscV_1(
	.clk                (clk),
	.rst_n              (rst_n),
	
//to ROM
	.inst_addr_o		(inst_addr_RV1_o),
	.inst_i				(inst_ROM1_o),
	
//id to MEMORY
	.id_mem_rd_req		(id_mem_rd_req),
	.id_mem_rd_addr     (id_mem_rd_addr),
	
//MEMORY to exe
	.mem_exe_rd_byte        (mem_exe_rd_byte),
	.mem_exe_rd_halfword	(mem_exe_rd_halfword),
	.mem_exe_rd_word		(mem_exe_rd_word),
	
//exe to memory	
	.exe_mem_wr_req		(exe_mem_wr_req),
	.exe_mem_wr_addr	(exe_mem_wr_addr),
	.exe_mem_wr_data	(exe_mem_wr_data),
	.exe_mem_wr_op_type	(exe_mem_wr_op_type)
);


ROM 
#(
	.DW(32),
	.AW(12),
	.Depth(4096)
)
ROM1(
				
	.clk			  	(clk),
	.rst_n			  	(rst_n),
						
	.w_en				(1'b0),			//预留写端口，可以通过上位机写程序进ROM
	.w_addr_i			(12'b0),		//预留写端口，可以通过上位机写程序进ROM
	.w_inst_i			(32'b0),		//预留写端口，可以通过上位机写程序进ROM
						
	.r_en			  	(1'b1),
	.inst_addr_i		(inst_addr_RV1_o[11:0]),	
	.inst_o			  	(inst_ROM1_o)
);




MEMORY 
#(
	.DW(32),
	.AW(32),
	.Depth(8192)
)
MEMORY1(
				
	.clk			  	(clk),
	.rst_n			  	(rst_n),
						
	.w_en				(exe_mem_wr_req),		
	.w_addr_i			(exe_mem_wr_addr),		
	.w_data_i			(exe_mem_wr_data),	
	.w_op_type_i		(exe_mem_wr_op_type),
						
	.r_en			  	(id_mem_rd_req),
	.r_addr_i			(id_mem_rd_addr),	
	.r_byte_o           (mem_exe_rd_byte	),
	.r_halfword_o       (mem_exe_rd_halfword),
	.r_word_o           (mem_exe_rd_word	)

);



/*
ROM ROM1(
	.inst_addr_i		(inst_addr_RV1_o),
	.inst_o				(inst_ROM1_o)
);
*/



endmodule

