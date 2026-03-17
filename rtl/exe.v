//20260222 疑似发现问题
//slli/srli等含有shamt的指令中，未判断shamt[5]
//“对于RV32I，仅当shamt[5]=0 时，指令才是有效的。”

//20260224 ex模块似乎又执行了一次译码。应该优化一下id和ex模块的实现？

//exe---执行模块execute

`include "defines.v"

module exe(				
	// input				clk,
	// input 				rst_n,

//from decoder		
	input wire[31:0]	inst_i,
	input wire[31:0]	inst_addr_i,
	input wire[31:0]	opD1_i,
	input wire[31:0]	opD2_i,
	input wire[4:0]		rd_addr_i,
	input wire			rd_wen_i,
	input wire[31:0]	base_addr_i,
	input wire[31:0]	offset_addr_i,
	
//to Regfile---回写
	output reg			rd_wen,
	output reg [4:0]	rd_waddr_o,
	output reg [31:0]	rd_wData_o,
	
//to ctrl
	output reg	[31:0]	jump_addr_o,
	output reg			jump_en_o,
	output reg			hold_flag_o,
	
//from memory
	input wire [7:0]	mem_exe_rd_byte_i,
	input wire [15:0]	mem_exe_rd_halfword_i,
	input wire [31:0] 	mem_exe_rd_word_i,
	
//to memory	
	output reg 			exe_mem_wr_req_o,
	output reg [31:0]	exe_mem_wr_addr_o,
	output reg [31:0]	exe_mem_wr_data_o,
	output reg [2:0]	exe_mem_wr_op_type_o

);


	wire [6:0] opcode;
	wire [2:0] func3;
	wire [6:0] func7;
	wire [4:0] shamt; 
	wire [31:0] jump_imm;
	wire [31:0] typeS_imm_32b;
	wire [31:0] SRA_mask;
	wire 		opD1_equal_opD2;
	wire 		opD1_less_opD2_unsigned;
	wire 		opD1_less_opD2_signed;
	wire [63:0] MULHSU_temp;
	wire [31:0] MULHSU_N_op1_32b;
	wire [63:0] MULHSU_N_op1_64b;
	
	assign opcode	=	inst_i[6:0];	
	assign func3	=	inst_i[14:12];
	assign func7	=	inst_i[31:25];
	assign shamt 	=	inst_i[24:20];
	assign jump_imm	=	{{19{inst_i[31]}},inst_i[31],inst_i[7],inst_i[30:25],inst_i[11:8],1'b0};//signed-extends
	assign typeS_imm_32b = {{20{inst_i[31]}},inst_i[31:25],inst_i[11:7]}; //signed-extends
	assign SRA_mask	=	(32'hffff_ffff) >> opD2_i[4:0];
	assign opD1_equal_opD2 = (opD1_i == opD2_i) ? 1'b1 : 1'b0;
	assign opD1_less_opD2_unsigned = (opD1_i < opD2_i) ? 1'b1 : 1'b0;
	assign opD1_less_opD2_signed = (($signed(opD1_i)) < ($signed(opD2_i))) ? 1'b1 : 1'b0;
	assign MULHSU_N_op1_32b = (~opD1_i) + 1'b1;
	assign MULHSU_N_op1_64b = {32'b0,MULHSU_N_op1_32b};	//此处要注意，负数先转正数，再0扩展至64bit参与后续计算
	assign MULHSU_temp = ~(MULHSU_N_op1_64b * opD2_i) + 1'b1; 

//ALU
	wire [31:0] opD1_ADD_opD2;
	wire [31:0] opD1_AND_opD2;
	wire [31:0] opD1_OR_opD2;
	wire [31:0] opD1_XOR_opD2;
	wire [31:0] opD1_SHIFT_L_opD2;
	wire [31:0] opD1_SHIFT_R_opD2;
	wire [31:0] BASE_ADD_OFFSET_addr;
    wire [63:0] opD1_MUL_opD2_Signed;
    wire [63:0] opD1_MUL_opD2_Unsigned;
	
	assign opD1_ADD_opD2			=	opD1_i + opD2_i;				//加
	assign opD1_AND_opD2 			=	opD1_i & opD2_i;                //与
	assign opD1_OR_opD2 			=	opD1_i | opD2_i;                //或
	assign opD1_XOR_opD2 			=	opD1_i ^ opD2_i;                //异或
	assign opD1_SHIFT_L_opD2		=	opD1_i << opD2_i[4:0];          //逻辑左移 禁止超过5bit
	assign opD1_SHIFT_R_opD2 		=	opD1_i >> opD2_i[4:0];          //逻辑右移 禁止超过5bit
	assign BASE_ADD_OFFSET_addr 	=	base_addr_i + offset_addr_i;    //地址计算
	assign opD1_MUL_opD2_Signed		=	$signed(opD1_i) * $signed(opD2_i);   
	assign opD1_MUL_opD2_Unsigned	=	opD1_i * opD2_i;   

	always@(*)begin
		exe_mem_wr_op_type_o = 3'b0;
		case(opcode)
			`INST_TYPE_I:begin
				jump_addr_o	= 32'b0;
				jump_en_o  	= 1'b0;
				hold_flag_o	= 1'b0;
				exe_mem_wr_req_o	= 1'b0;
				exe_mem_wr_addr_o	= 32'b0; 
				exe_mem_wr_data_o	= 32'b0; 
				case(func3)
					`INST_ADDI:begin			//[rd = rs1 + imm]
						rd_wData_o = opD1_ADD_opD2; 
						rd_waddr_o = rd_addr_i;
						rd_wen = rd_wen_i;//【id给】or exe给，都可
					end
					
					
					`INST_SLTI:begin			//[rd = (rs1 < imm) ? 1:0] signed
						rd_wData_o = {31'b0,opD1_less_opD2_signed}; 
						rd_waddr_o = rd_addr_i;
						rd_wen = rd_wen_i;//【id给】or exe给，都可
					end
					
					
					`INST_SLTIU:begin			//[rd = (rs1 < imm) ? 1:0] unsigned
						rd_wData_o = {31'b0,opD1_less_opD2_unsigned}; 
						rd_waddr_o = rd_addr_i;
						rd_wen = rd_wen_i;//【id给】or exe给，都可
					end


					`INST_XORI:begin			//[rd = rs1 ^ imm]
						rd_wData_o = opD1_XOR_opD2; 
						rd_waddr_o = rd_addr_i;
						rd_wen = rd_wen_i;//【id给】or exe给，都可
					end


					`INST_ORI:begin			//[rd = rs1 | imm]
						rd_wData_o = opD1_OR_opD2; 
						rd_waddr_o = rd_addr_i;
						rd_wen = rd_wen_i;//【id给】or exe给，都可
					end


					`INST_ANDI:begin			//[rd = rs1 & imm]
						rd_wData_o = opD1_AND_opD2; 
						rd_waddr_o = rd_addr_i;
						rd_wen = rd_wen_i;//【id给】or exe给，都可
					end
					
					
					`INST_SLLI:begin			//[rd = rs1 << imm[4:0]] Logical
						rd_wData_o = opD1_SHIFT_L_opD2; 
						rd_waddr_o = rd_addr_i;
						rd_wen = rd_wen_i;//【id给】or exe给，都可
					end
					
					
					`INST_SRLI_SRAI:begin	
						if(func7 == 7'b0000000)begin 			//SRLI : [rd = rs1 >> imm[4:0]]Logical
							rd_wData_o = opD1_SHIFT_R_opD2;
							rd_waddr_o = rd_addr_i;
							rd_wen = rd_wen_i;
						end
						else if(func7 == 7'b0100000)begin  		//SRAI : [rd = rs1 >> imm[4:0]]Arith
							rd_wData_o = (opD1_SHIFT_R_opD2) | ((~SRA_mask)&({32{opD1_i[31]}}));
							// rd_wData_o = ($signed(opD1_i)) >>> opD2_i[4:0];
							rd_waddr_o = rd_addr_i;
							rd_wen = rd_wen_i;
						end
						else ;
					end

								
					default :begin
						rd_wData_o = 32'b0; 
						rd_waddr_o = 32'b0; 
						rd_wen = 1'b0;
					end
				endcase
			end
			
			
			
			`INST_TYPE_R_M:begin
				jump_addr_o	= 32'b0;
				jump_en_o  	= 1'b0;
				hold_flag_o	= 1'b0;
				exe_mem_wr_req_o	= 1'b0;
				exe_mem_wr_addr_o	= 32'b0; 
				exe_mem_wr_data_o	= 32'b0; 
				case(func7)
										// R type inst
					7'b0000000:begin
						case(func3)
							`INST_ADD_SUB:begin				//[rd = rs1 ± rs2]
															//ADD
									rd_wData_o = opD1_ADD_opD2;
									rd_waddr_o = rd_addr_i;
									rd_wen = rd_wen_i;
							end
								

							`INST_SLL:begin		//[rd = rs1 << rs2]
								rd_wData_o = opD1_SHIFT_L_opD2;
								rd_waddr_o = rd_addr_i;
								rd_wen = rd_wen_i;
							end


							`INST_SLT:begin		//[rd = (rs1 < rs2)?1:0] signed
								rd_wData_o = {31'b0,opD1_less_opD2_signed};
								rd_waddr_o = rd_addr_i;
								rd_wen = rd_wen_i;
							end


							`INST_SLTU:begin		//[rd = (rs1 < rs2)?1:0] unsigned
								rd_wData_o = {31'b0,opD1_less_opD2_unsigned};
								rd_waddr_o = rd_addr_i;
								rd_wen = rd_wen_i;
							end
							
							
							`INST_XOR:begin		//[rd = rs1 ^ rs2]
								rd_wData_o = opD1_XOR_opD2;
								rd_waddr_o = rd_addr_i;
								rd_wen = rd_wen_i;
							end
							
							
							`INST_SRL_SRA:begin		//[rd = rs1 >> rs2] Shift Right Logical/Arith
													//SRL -- Shift Right Logical
								rd_wData_o = opD1_SHIFT_R_opD2;
								rd_waddr_o = rd_addr_i;
								rd_wen = rd_wen_i;
							end
							
							
							`INST_OR:begin		//[rd = rs1 | rs2]
								rd_wData_o = opD1_OR_opD2;
								rd_waddr_o = rd_addr_i;
								rd_wen = rd_wen_i;
							end


							`INST_AND:begin		//[rd = rs1 & rs2]
								rd_wData_o = opD1_AND_opD2;
								rd_waddr_o = rd_addr_i;
								rd_wen = rd_wen_i;
							end
							
								
							default :begin
								rd_wData_o = 32'b0; 
								rd_waddr_o = 32'b0; 
								rd_wen = 1'b0;
							end
						endcase
					end
					
					
					7'b0100000:begin
						case(func3)
							`INST_ADD_SUB:begin  		//SUB  //[rd = rs1 - rs2]
								rd_wData_o = opD1_i - opD2_i;
								rd_waddr_o = rd_addr_i;
								rd_wen = rd_wen_i;
							end
							
							`INST_SRL_SRA:begin  		//[rd = rs1 >> rs2] Shift Right Logical/Arith
														//SRA -- Shift Right Arith
								rd_wData_o = (opD1_SHIFT_R_opD2) | ((~SRA_mask)&({32{opD1_i[31]}}));
								// rd_wData_o = ($signed(opD1_i)) >>> opD2_i[4:0];
								rd_waddr_o = rd_addr_i;
								rd_wen = rd_wen_i;
							end
							
							default :begin
								rd_wData_o = 32'b0; 
								rd_waddr_o = 32'b0; 
								rd_wen = 1'b0;
							end
						endcase
					end
						
					7'b0000001:begin			// M type inst
						case(func3)
							`INST_MUL:begin   	//rd = [rs1 * rs2][31:0]---把寄存器 x[rs2]乘到寄存器x[rs1]上，乘积写入 x[rd]。忽略算术溢出。(将结果的低XLEN位放置到目标寄存器中。)   -----都看成无符号？
								rd_wData_o = opD1_MUL_opD2_Unsigned[31:0];
								rd_waddr_o = rd_addr_i;
								rd_wen = rd_wen_i;
							end
							
							`INST_MULH:begin   	//把寄存器 x[rs2]乘到寄存器 x[rs1]上，都视为 2 的补码，将乘积的高位写入 x[rd]。
								rd_wData_o = opD1_MUL_opD2_Signed[63:32];
								rd_waddr_o = rd_addr_i;
								rd_wen = rd_wen_i;
							end
							
							
							`INST_MULHSU:begin   //把寄存器 x[rs2]乘到寄存器 x[rs1]上， x[rs1]为 2 的补码， x[rs2]为无符号数，将乘积的高位写入 x[rd]。
								rd_wData_o = opD1_i[31] ? MULHSU_temp[63:32] : opD1_MUL_opD2_Unsigned[63:32];
								// rd_wData_o = ($signed(opD1_i) * opD2_i) >> 32;
								rd_waddr_o = rd_addr_i;
								rd_wen = rd_wen_i;
							end
							
							`INST_MULHU:begin   //把寄存器 x[rs2]乘到寄存器 x[rs1]上， x[rs1]、 x[rs2]均为无符号数，将乘积的高位写入 x[rd]。
								rd_wData_o = opD1_MUL_opD2_Unsigned[63:32];
								rd_waddr_o = rd_addr_i;
								rd_wen = rd_wen_i;
							end
							
							default :begin
								rd_wData_o = 32'b0; 
								rd_waddr_o = 32'b0; 
								rd_wen = 1'b0;
							end


							// `INST_DIV,          //用寄存器 x[rs1]的值除以寄存器 x[rs2]的值，向零舍入，将这些数视为二进制补码，把商写入 x[rd]。
							// `INST_DIVU,         //用寄存器 x[rs1]的值除以寄存器 x[rs2]的值，向零舍入，将这些数视为无符号数，把商写入x[rd]。
							// `INST_REM,          //x[rs1]除以 x[rs2]，向 0 舍入，都视为 2 的补码，余数写入 x[rd]。
							// `INST_REMU:         //x[rs1]除以 x[rs2]，向 0 舍入，都视为无符号数，余数写入 x[rd]。
						endcase
					end
				endcase
			end



			`INST_TYPE_B:begin
				rd_wData_o = 32'b0;
				rd_waddr_o = 32'b0;
				rd_wen 	= 1'b0;
				exe_mem_wr_req_o	= 1'b0;
				exe_mem_wr_addr_o	= 32'b0; 
				exe_mem_wr_data_o	= 32'b0; 
				case(func3)
					`INST_BNE:begin			//BNE[if(rs1 != rs2)	PC += imm]    
							jump_addr_o	= (BASE_ADD_OFFSET_addr) & {32{(~opD1_equal_opD2)}};
							jump_en_o  	= ~opD1_equal_opD2;
							hold_flag_o	= 1'b0;
					end	
					
					`INST_BEQ:begin			//BEQ[if(rs1 == rs2)	PC += imm]
							jump_addr_o	= (BASE_ADD_OFFSET_addr) & {32{(opD1_equal_opD2)}};
							jump_en_o  	= opD1_equal_opD2;
							hold_flag_o	= 1'b0;
					end	

					`INST_BLT:begin			//BLT[if(rs1 < rs2)	PC += imm]
							jump_addr_o	= (BASE_ADD_OFFSET_addr) & {32{(opD1_less_opD2_signed)}};
							jump_en_o  	= opD1_less_opD2_signed;
							hold_flag_o	= 1'b0;
					end	
					
					`INST_BGE:begin			//BGE[if(rs1 >= rs2)	PC += imm]
							jump_addr_o	= (BASE_ADD_OFFSET_addr) & {32{(~opD1_less_opD2_signed)}};
							jump_en_o  	= ~opD1_less_opD2_signed;
							hold_flag_o	= 1'b0;
					end	
					
					`INST_BLTU:begin		//BLTU[if(rs1 < rs2)	PC += imm]zero-extends
							jump_addr_o	= (BASE_ADD_OFFSET_addr) & {32{(opD1_less_opD2_unsigned)}};
							jump_en_o  	= opD1_less_opD2_unsigned;
							hold_flag_o	= 1'b0;
					end	
					
					`INST_BGEU:begin		//BGEU[if(rs1 >= rs2)	PC += imm]zero-extends
							jump_addr_o	= (BASE_ADD_OFFSET_addr) & {32{(~opD1_less_opD2_unsigned)}};
							jump_en_o  	= ~opD1_less_opD2_unsigned;
							hold_flag_o	= 1'b0;
					end	
					
					default :begin
						jump_addr_o	= 32'b0;
						jump_en_o  	= 1'b0;
						hold_flag_o	= 1'b0;
					end
				endcase
			end

			
			`INST_TYPE_L:begin
				jump_addr_o	= 32'b0;
				jump_en_o  	= 1'b0;
				hold_flag_o	= 1'b0;
				exe_mem_wr_req_o	= 1'b0;
				exe_mem_wr_addr_o	= 32'b0; 
				exe_mem_wr_data_o	= 32'b0; 
				case(func3)
					`INST_LB:begin	//Load Byte-----LB---rd = M[rs1 + imm][0:7]
						rd_wData_o = {{24{mem_exe_rd_byte_i[7]}},mem_exe_rd_byte_i}; 	//从存储器中读取一个8位数值，然后将其进行符号扩展到32位，再保存到rd中。
						rd_waddr_o = rd_addr_i;
						rd_wen = rd_wen_i;//【id给】or exe给，都可
					end	
					
					`INST_LH:begin	//Load Half-----LH---rd = M[rs1 + imm][0:15]
						rd_wData_o = {{16{mem_exe_rd_halfword_i[15]}},mem_exe_rd_halfword_i}; 	//从存储器中读取一个16位数值，然后将其进行符号扩展到32位，再保存到rd中。
						rd_waddr_o = rd_addr_i;
						rd_wen = rd_wen_i;//【id给】or exe给，都可
					end	
					
					`INST_LW:begin	//Load Word-----LW---rd = M[rs1 + imm][0:31]
						rd_wData_o = mem_exe_rd_word_i; //LW指令将一个32位数值从存储器复制到rd中
						rd_waddr_o = rd_addr_i;
						rd_wen = rd_wen_i;//【id给】or exe给，都可
					end	
					
					`INST_LBU:begin	//Load Byte(U)--LBU--rd = M[rs1 + imm][0:7]	  zero-extends
						rd_wData_o =  {24'b0,mem_exe_rd_byte_i}; //LBU指令存储器中读取一个8位数值，然后将其进行零扩展到32位，再保存到rd中。
						rd_waddr_o = rd_addr_i;
						rd_wen = rd_wen_i;//【id给】or exe给，都可
					end	

					`INST_LHU:begin	//Load Half(U)--LHU--rd = M[rs1 + imm][0:15]  zero-extends
						rd_wData_o =  {16'b0,mem_exe_rd_halfword_i}; //LHU指令存储器中读取一个16位数值，然后将其进行零扩展到32位，再保存到rd中。
						rd_waddr_o = rd_addr_i;
						rd_wen = rd_wen_i;//【id给】or exe给，都可
					end	

					default :begin
						rd_wData_o = 32'b0; 
						rd_waddr_o = 32'b0; 
						rd_wen = 1'b0;
					end
				endcase
			end
			
			
			`INST_TYPE_S:begin //typeS的imm，都交给exe做inst解码...!!
				jump_addr_o	= 32'b0;
				jump_en_o  	= 1'b0;
				hold_flag_o	= 1'b0;
				rd_wData_o = 32'b0; 
				rd_waddr_o = 32'b0; 
				rd_wen = 1'b0;
				case(func3)
					`INST_SB:	//Store Byte-----SB---M[rs1 + imm][0:7]	 = rs2[0:7]
					begin
						exe_mem_wr_req_o = `EN;
						exe_mem_wr_addr_o = opD1_i + typeS_imm_32b;
						exe_mem_wr_data_o = exe_mem_wr_addr_o[1:0]==0 ? {8'b0,8'b0,8'b0,opD2_i[7:0]}:
											exe_mem_wr_addr_o[1:0]==1 ? {8'b0,8'b0,opD2_i[7:0],8'b0}:
											exe_mem_wr_addr_o[1:0]==2 ? {8'b0,opD2_i[7:0],8'b0,8'b0}:
																		{opD2_i[7:0],8'b0,8'b0,8'b0};
						exe_mem_wr_op_type_o = `WR_OP_TYPE_BYTE;
					end	
					
					`INST_SH:	//Store Half-----SH---M[rs1 + imm][0:15] = rs2[0:15]
					begin
						exe_mem_wr_req_o = `EN;
						exe_mem_wr_addr_o = opD1_i + typeS_imm_32b;
						exe_mem_wr_data_o = exe_mem_wr_addr_o[1:0]==0 ? {16'b0,opD2_i[15:0]}:
											exe_mem_wr_addr_o[1:0]==2 ? {opD2_i[15:0],16'b0}:
																		32'b0; //硬件异常
						exe_mem_wr_op_type_o = `WR_OP_TYPE_HALFWORD;
					end	
					
					`INST_SW:	//Store Word-----SW---M[rs1 + imm][0:31] = rs2[0:31]
					begin
						exe_mem_wr_req_o = `EN;
						exe_mem_wr_addr_o = opD1_i + typeS_imm_32b;
						exe_mem_wr_data_o = opD2_i;
						exe_mem_wr_op_type_o = `WR_OP_TYPE_WORD;
					end	

					default :begin
						rd_wData_o				= 32'b0; 
						rd_waddr_o				= 32'b0; 
						rd_wen					= 1'b0;
						exe_mem_wr_req_o		= 1'b0;
						exe_mem_wr_addr_o		= 32'b0; 
						exe_mem_wr_data_o		= 32'b0; 
						exe_mem_wr_op_type_o	= 3'b0;
					end 
				endcase
			end
			
			
			`INST_JAL:begin					//[rd = PC + 4;	PC += imm]
				rd_wData_o = opD1_ADD_opD2;
				rd_waddr_o = rd_addr_i;
				rd_wen = rd_wen_i;
				jump_addr_o	= BASE_ADD_OFFSET_addr;
				jump_en_o  	= 1'b1;
				hold_flag_o	= 1'b0;
				exe_mem_wr_req_o	= 1'b0;
				exe_mem_wr_addr_o	= 32'b0; 
				exe_mem_wr_data_o	= 32'b0; 
			end

			`INST_JALR:begin				//[rd = PC + 4;	PC = rs1 + imm]
				rd_wData_o = opD1_ADD_opD2;
				rd_waddr_o = rd_addr_i;
				rd_wen = rd_wen_i;
				jump_addr_o	= BASE_ADD_OFFSET_addr;
				jump_en_o  	= 1'b1;
				hold_flag_o	= 1'b0;
				exe_mem_wr_req_o	= 1'b0;
				exe_mem_wr_addr_o	= 32'b0; 
				exe_mem_wr_data_o	= 32'b0; 
			end


			`INST_LUI:begin					//[rd = imm << 12]
				rd_wData_o = opD1_i;  		//在id中已经 << 12
				rd_waddr_o = rd_addr_i;
				rd_wen 	= rd_wen_i;
				jump_addr_o	= 32'b0;
				jump_en_o  	= 1'b0;
				hold_flag_o	= 1'b0;
				exe_mem_wr_req_o	= 1'b0;
				exe_mem_wr_addr_o	= 32'b0; 
				exe_mem_wr_data_o	= 32'b0; 
			end
			
			
			`INST_AUIPC:begin					//[rd = PC + (imm << 12)]
				rd_wData_o = opD1_ADD_opD2;  
				rd_waddr_o = rd_addr_i;
				rd_wen 	= rd_wen_i;
				jump_addr_o	= 32'b0;
				jump_en_o  	= 1'b0;
				hold_flag_o	= 1'b0;
				exe_mem_wr_req_o	= 1'b0;
				exe_mem_wr_addr_o	= 32'b0; 
				exe_mem_wr_data_o	= 32'b0; 
			end
			

			default :begin
				rd_wData_o = 32'b0;
				rd_waddr_o = 32'b0;
				rd_wen 	= 1'b0;
				jump_addr_o	= 32'b0;
				jump_en_o  	= 1'b0;
				hold_flag_o	= 1'b0;
				exe_mem_wr_req_o	= 1'b0;
				exe_mem_wr_addr_o	= 32'b0; 
				exe_mem_wr_data_o	= 32'b0; 
			end
		endcase
	end


	
endmodule
