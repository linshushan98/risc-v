
`include "defines.v"

module riscV(
	input				clk,
	input 				rst_n,
	
//to ROM
	output wire	[31:0]		inst_addr_o,
	input  wire	[31:0]		inst_i,
	
//id to MEMORY
	output wire     		id_mem_rd_req,
	output wire [31:0]		id_mem_rd_addr,
	
//MEMORY to exe	.
	input wire [7:0]	mem_exe_rd_byte,
	input wire [15:0]	mem_exe_rd_halfword,
	input wire [31:0] 	mem_exe_rd_word,
	
	
//exe to memory	
	output wire 			exe_mem_wr_req,
	output wire [31:0]		exe_mem_wr_addr,
	output wire [31:0]		exe_mem_wr_data,
	output wire [2:0]		exe_mem_wr_op_type
);

//pc to if
wire [31:0]	inst_addr_pc_o;

//ctrl to pc
wire [31:0]	jump_addr;
wire		jump_en;

	pc_reg pc1(				
		.clk			(clk),
		.rst_n			(rst_n),
		.jump_addr_i	(jump_addr),
		.jump_en_i		(jump_en),
		
		.pc_o			(inst_addr_pc_o)	//inst_addr
	);
	
//if to ifsc	
wire [31:0]inst_if_o;
wire [31:0]inst_addr_if_o;
	i_fetch i_fetch1(				
		
		//with pc
		.inst_addr_i	(inst_addr_pc_o), //pc_o
		
		//with ROM
		.if2ROM_addr_o	(inst_addr_o),
		.ROM2if_inst_i	(inst_i),
		
		//with if_id
		.inst_o			(inst_if_o),
		.inst_addr_o	(inst_addr_if_o)
	);

//ifsc to id		
wire [31:0]inst_ifsc_o;
wire [31:0]inst_addr_ifsc_o;

//ctrl to ifsc & idsc		
wire hold_flag;	
	i_fetch_sc i_fetch_sc1(				
		.clk 			(clk),
		.rst_n			(rst_n),
		.hold_flag_i	(hold_flag),
		
		.inst_i   		(inst_if_o),
		.inst_addr_i  	(inst_addr_if_o),
						
		.inst_o			(inst_ifsc_o),
		.inst_addr_o    (inst_addr_ifsc_o)
	);

//id to idsc
wire [31:0]inst_id_o;
wire [31:0]inst_addr_id_o;	
wire [31:0]opD1_id_o;	
wire [31:0]opD2_id_o;	
wire [4:0]rd_addr_id_o;	
wire       rd_wen_id_o;
wire [31:0]base_addr_id_o;
wire [31:0]offset_addr_id_o;

//id and RF	
wire [4:0]rs1_addr_id_o;	
wire [4:0]rs2_addr_id_o;	
wire [31:0]reg1_rData_RF_o;
wire [31:0]reg2_rData_RF_o;
	i_decoder i_decoder1(				
		//from i_fetch_sc	
		.inst_i					(inst_ifsc_o),
		.inst_addr_i			(inst_addr_ifsc_o),
											   
		//decoder output for idsc               
		.inst_o					(inst_id_o),
		.inst_addr_o			(inst_addr_id_o),
											  
		.opD1_o					(opD1_id_o),
		.opD2_o					(opD2_id_o),
		.rd_addr_o				(rd_addr_id_o),
		.rd_wen					(rd_wen_id_o),
		.base_addr_o			(base_addr_id_o),
		.offset_addr_o			(offset_addr_id_o),	
		
		//with RegFile                         
		.rs1_addr_o				(rs1_addr_id_o),
		.rs2_addr_o				(rs2_addr_id_o),
		.rs1_Data_i				(reg1_rData_RF_o),
		.rs2_Data_i				(reg2_rData_RF_o),
		
		.id_mem_rd_req_o		(id_mem_rd_req),
		.id_mem_rd_addr_o       (id_mem_rd_addr)
	);


//idsc to exe	
wire [31:0]inst_idsc_o;
wire [31:0]inst_addr_idsc_o;	
wire [31:0]opD1_idsc_o;	
wire [31:0]opD2_idsc_o;	
wire [4:0]rd_addr_idsc_o;	
wire 	  rd_wen_idsc_o;	
wire [31:0]base_addr_idsc_o;
wire [31:0]offset_addr_idsc_o;

	i_decoder_sc i_decoder_sc1(				
		.clk			(clk),
		.rst_n			(rst_n),
		.hold_flag_i	(hold_flag),
					
		.inst_i			(inst_id_o),
		.inst_addr_i	(inst_addr_id_o),
		.opD1_i			(opD1_id_o),
		.opD2_i			(opD2_id_o),
		.rd_addr_i		(rd_addr_id_o),
		.rd_wen_i		(rd_wen_id_o),
		.base_addr_i	(base_addr_id_o),
		.offset_addr_i	(offset_addr_id_o),	
				
		.inst_o       (inst_idsc_o),
		.inst_addr_o  (inst_addr_idsc_o),
		.opD1_o       (opD1_idsc_o),
		.opD2_o       (opD2_idsc_o),
		.rd_addr_o    (rd_addr_idsc_o),
		.rd_wen_o    (rd_wen_idsc_o),
		.base_addr_o	(base_addr_idsc_o),
		.offset_addr_o	(offset_addr_idsc_o)	
	);


//exe to RF
wire rd_wen_ex_o;	
wire [4:0]rd_waddr_ex_o;	
wire [31:0]rd_wData_ex_o;	
	RegFile RegFile1(		
		.clk				(clk),
		.rst_n				(rst_n),
		
	//from exe				
		.reg_wen			(rd_wen_ex_o),
		.reg_waddr_i		(rd_waddr_ex_o),
		.reg_wData_i		(rd_wData_ex_o),

	//to idecoder					
		.reg1_raddr_i		(rs1_addr_id_o),
		.reg2_raddr_i		(rs2_addr_id_o),
		.reg1_rData_o		(reg1_rData_RF_o),
		.reg2_rData_o		(reg2_rData_RF_o)
	);


//exe to ctrl
wire [31:0]jump_addr_exe_o;	
wire jump_en_exe_o;	
wire hold_flag_exe_o;	
	exe exe1(				
	//from decoder		
		.inst_i					(inst_idsc_o),
		.inst_addr_i			(inst_addr_idsc_o),
		.opD1_i					(opD1_idsc_o),
		.opD2_i					(opD2_idsc_o),
		.rd_addr_i				(rd_addr_idsc_o),
		.rd_wen_i				(rd_wen_idsc_o),
		.base_addr_i			(base_addr_idsc_o),
		.offset_addr_i			(offset_addr_idsc_o),
						
	//to Regfile---»ØÐ´    
		.rd_wen             (rd_wen_ex_o),
		.rd_waddr_o         (rd_waddr_ex_o),
		.rd_wData_o         (rd_wData_ex_o),
		
	//to ctrl
		.jump_addr_o		(jump_addr_exe_o),
		.jump_en_o			(jump_en_exe_o),
		.hold_flag_o		(hold_flag_exe_o),
		
	//from memory
		.mem_exe_rd_byte_i  	(mem_exe_rd_byte),
		.mem_exe_rd_halfword_i	(mem_exe_rd_halfword),
		.mem_exe_rd_word_i		(mem_exe_rd_word),
		
	//to memory	
		.exe_mem_wr_req_o		(exe_mem_wr_req),
		.exe_mem_wr_addr_o		(exe_mem_wr_addr),
		.exe_mem_wr_data_o		(exe_mem_wr_data),
		.exe_mem_wr_op_type_o	(exe_mem_wr_op_type)
	);


	ctrl ctrl1(				
	//from exe
		.jump_addr_i				(jump_addr_exe_o),
		.jump_en_i					(jump_en_exe_o),
		.hold_flag_i				(hold_flag_exe_o),
		
	//to pc¡¢if¡¢id
		.jump_addr_o				(jump_addr),
		.jump_en_o					(jump_en),
		.hold_flag_o				(hold_flag)
	);

endmodule
