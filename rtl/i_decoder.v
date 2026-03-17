//20260222 可疑问题
//`define 中的 变量名定义不清楚，有歧义。
// 例如 `INST_TYPE_I ，应该更名为 `INST_TYPE_I_OPCODE 更合适

//i_decoder---

`include "defines.v"

module i_decoder(				
	
//from i_fetch_sc	
	input  wire[31:0]	inst_i,	
	input  wire[31:0]	inst_addr_i,
	
//decoder output for ex(idsc)
	output wire[31:0]	inst_o,
	output wire[31:0]	inst_addr_o,
	
	output reg [31:0]	opD1_o,
	output reg [31:0]	opD2_o,
	output reg [4:0]	rd_addr_o,
	output reg 			rd_wen,
	output reg [31:0]	base_addr_o,
	output reg [31:0]	offset_addr_o,
	
//with RegFile
	output reg [4:0]	rs1_addr_o,
	output reg [4:0]	rs2_addr_o,
	input  wire[31:0]	rs1_Data_i,
	input  wire[31:0]	rs2_Data_i,

//to memory  ---id发出，而不是idsc------保证在下一拍的exe能够拿到data
	output reg 			id_mem_rd_req_o,
	output reg [31:0]	id_mem_rd_addr_o
);

//一直向前传递inst_addr、inst
assign inst_o = inst_i;
assign inst_addr_o = inst_addr_i;

wire [6:0] opcode;
wire [4:0] rd;
wire [2:0] func3;
wire [4:0] rs1;
wire [4:0] rs2;
wire [4:0] shamt;
wire [11:0] imm;
wire [6:0] func7;
wire [31:0] typeB_imm_32b;
wire [31:0] typeI_imm_32b;
wire [31:0] typeL_imm_32b;
wire [31:0] typeL_imm_32b_u;
wire [31:0] typeS_imm_32b;
wire [31:0] JAL_imm_32b;
wire [31:0] LUI_imm_32b;
wire [31:0] AUIPC_imm_32b;
wire [31:0] JALR_imm_32b;

//decode----	
assign opcode = inst_i[6:0];
assign rd =		inst_i[11:7];
assign func3 =	inst_i[14:12];
assign rs1 =	inst_i[19:15];
assign imm =	inst_i[31:20];
assign rs2 =	inst_i[24:20];
assign shamt =	inst_i[24:20];
assign func7 =	inst_i[31:25];
assign typeI_imm_32b = {{20{imm[11]}},imm};
assign typeB_imm_32b = {{19{inst_i[31]}},inst_i[31],inst_i[7],inst_i[30:25],inst_i[11:8],1'b0};//signed-extends
assign typeL_imm_32b = typeI_imm_32b;//signed-extends
assign typeL_imm_32b_u = {20'b0,imm};//Unsigned-extends(zero-extends)
assign typeS_imm_32b = {{20{inst_i[31]}},inst_i[31:25],inst_i[11:7]}; //signed-extends
assign JAL_imm_32b = {{11{inst_i[31]}},inst_i[31],inst_i[19:12],inst_i[20],inst_i[30:21],1'b0};
assign LUI_imm_32b = {inst_i[31:12],12'b0}; 	//已经  <<12
assign AUIPC_imm_32b = LUI_imm_32b; 	//已经  <<12
assign JALR_imm_32b = typeI_imm_32b; 
	

	
		
	
	always@(*)begin
		case(opcode)
			`INST_TYPE_I:begin
				base_addr_o = 32'b0;
				offset_addr_o = 32'b0;
				id_mem_rd_req_o	= `DIS;
				id_mem_rd_addr_o	= 32'b0;
				case(func3)
					`INST_ADDI,		//[rd = rs1 + imm]
					`INST_SLTI, 	//[rd = (rs1 < imm) ? 1:0] signed
					`INST_SLTIU,	//[rd = (rs1 < imm) ? 1:0] unsigned
					`INST_XORI, 	//[rd = rs1 ^ imm]
					`INST_ORI, 		//[rd = rs1 | imm]
					`INST_ANDI:		//[rd = rs1 & imm]
					begin					
						rs1_addr_o	= rs1;
						rs2_addr_o	= 5'b0;
						opD1_o		= rs1_Data_i;
						opD2_o		= typeI_imm_32b;
						rd_addr_o	= rd;
						rd_wen		= 1'b1;  //【id给】or exe给，都可
					end
					
					
					`INST_SLLI,			//[rd = rs1 << imm[4:0]]
					`INST_SRLI_SRAI:	//SRLI:[rd = rs1 >> imm[4:0]]Logical  SRAI:[rd = rs1 >> imm[4:0]]Arith
					begin					
						rs1_addr_o	= rs1;
						rs2_addr_o	= 5'b0;
						opD1_o		= rs1_Data_i;
						opD2_o		= {27'b0,shamt};
						rd_addr_o	= rd;
						rd_wen		= 1'b1;  //【id给】or exe给，都可
					end
					
					
					default :begin
						rs1_addr_o	= 5'b0;
						rs2_addr_o	= 5'b0;
						opD1_o		= 32'b0;
						opD2_o		= 32'b0;
						rd_addr_o	= 5'b0;
						rd_wen		= 1'b0;
					end
				endcase
			end
				
				
				
			`INST_TYPE_R_M:begin
				base_addr_o = 32'b0;
				offset_addr_o = 32'b0;
				id_mem_rd_req_o	= `DIS;
				id_mem_rd_addr_o	= 32'b0;
				case(func3)
					`INST_ADD_SUB,		//[rd = rs1 ± rs2]
					`INST_SLL,    		//[rd = rs1 << rs2]
					`INST_SLT,    		//[rd = (rs1 < rs2)?1:0] signed
					`INST_SLTU,   		//[rd = (rs1 < rs2)?1:0] unsigned
					`INST_XOR,    		//[rd = rs1 ^ rs2]
					`INST_SRL_SRA,		//[rd = rs1 >> rs2] Shift Right Logical/Arith
					`INST_OR,     		//[rd = rs1 | rs2]
					`INST_AND,	 		//[rd = rs1 & rs2]
					`INST_MUL,   		//rd = [rs1 * rs2][31:0]---把寄存器 x[rs2]乘到寄存器 x[rs1]上，乘积写入 x[rd]。忽略算术溢出。(将结果的低XLEN位放置到目标寄存器中。)
					`INST_MULH,         //高位乘--x[rd] = (x[rs1]x[rs2]) >> XLEN
					`INST_MULHSU,       //把寄存器 x[rs2]乘到寄存器 x[rs1]上， x[rs1]为 2 的补码， x[rs2]为无符号数，将乘积的高位写入 x[rd]。
					`INST_MULHU,        //把寄存器 x[rs2]乘到寄存器 x[rs1]上， x[rs1]、 x[rs2]均为无符号数，将乘积的高位写入 x[rd]。
					`INST_DIV,          //用寄存器 x[rs1]的值除以寄存器 x[rs2]的值，向零舍入，将这些数视为二进制补码，把商写入 x[rd]。
					`INST_DIVU,         //用寄存器 x[rs1]的值除以寄存器 x[rs2]的值，向零舍入，将这些数视为无符号数，把商写入x[rd]。
					`INST_REM,          //x[rs1]除以 x[rs2]，向 0 舍入，都视为 2 的补码，余数写入 x[rd]。
					`INST_REMU:         //x[rs1]除以 x[rs2]，向 0 舍入，都视为无符号数，余数写入 x[rd]。
					begin					
						rs1_addr_o	= rs1;
						rs2_addr_o	= rs2;
						opD1_o		= rs1_Data_i;
						opD2_o		= rs2_Data_i;
						rd_addr_o	= rd;
						rd_wen		= 1'b1;  //【id给】or exe给，都可
					end	
					
					
					default :begin
						rs1_addr_o	= 5'b0;
						rs2_addr_o	= 5'b0;
						opD1_o		= 32'b0;
						opD2_o		= 32'b0;
						rd_addr_o	= 5'b0;
						rd_wen		= 1'b0;
					end
				endcase
			end
			
			
			`INST_TYPE_B:begin
				id_mem_rd_req_o	= `DIS;
				id_mem_rd_addr_o	= 32'b0;
				case(func3)
					`INST_BNE,		//BNE[if(rs1 != rs2)	PC += imm] 
					`INST_BEQ,		//BEQ[if(rs1 == rs2)	PC += imm]
					`INST_BLT,
					`INST_BGE,
					`INST_BLTU,
					`INST_BGEU:
					begin
						rs1_addr_o	= rs1;
						rs2_addr_o	= rs2;
						opD1_o		= rs1_Data_i;
						opD2_o		= rs2_Data_i;
						rd_addr_o	= 5'b0;
						rd_wen		= 1'b0;  //【id给】or exe给，都可
						base_addr_o = inst_addr_i;
						offset_addr_o = typeB_imm_32b;
					end	
					
					default :begin
						rs1_addr_o	= 5'b0;
						rs2_addr_o	= 5'b0;
						opD1_o		= 32'b0;
						opD2_o		= 32'b0;
						rd_addr_o	= 5'b0;
						rd_wen		= 1'b0;
						base_addr_o = 32'b0;
						offset_addr_o = 32'b0;
					end
				endcase
			end
				

			`INST_TYPE_L:begin
				base_addr_o = 32'b0;
				offset_addr_o = 32'b0;
				case(func3)
					`INST_LB,	//Load Byte-----LB---rd = M[rs1 + imm][0:7]
					`INST_LH,	//Load Half-----LH---rd = M[rs1 + imm][0:15]
					`INST_LW:	//Load Word-----LW---rd = M[rs1 + imm][0:31]
					begin
						rs1_addr_o		= rs1;
						rs2_addr_o		= 5'b0;
						opD1_o			= 32'b0;
						opD2_o			= 32'b0;
						rd_addr_o		= rd;
						rd_wen			= `EN;  //【id给】or exe给，都可
						id_mem_rd_req_o	= `EN;
						id_mem_rd_addr_o	= rs1_Data_i + typeL_imm_32b;
					end	
					
					`INST_LBU,	//Load Byte(U)--LBU--rd = M[rs1 + imm][0:7]	  zero-extends
					`INST_LHU:	//Load Half(U)--LHU--rd = M[rs1 + imm][0:15]  zero-extends
					begin
						rs1_addr_o		= rs1;
						rs2_addr_o		= 5'b0;
						opD1_o			= 32'b0;
						opD2_o			= 32'b0;
						rd_addr_o		= rd;
						rd_wen			= `EN;  //【id给】or exe给，都可
						id_mem_rd_req_o	= `EN;
						// id_mem_rd_addr_o	= rs1_Data_i + typeL_imm_32b_u;//??
						id_mem_rd_addr_o	= rs1_Data_i + typeL_imm_32b;//imm 都是有符号扩展
					end	

					default :begin
						rs1_addr_o		= 5'b0;
						rs2_addr_o		= 5'b0;
						opD1_o			= 32'b0;
						opD2_o			= 32'b0;
						rd_addr_o		= 5'b0;
						rd_wen			= 1'b0;
						id_mem_rd_req_o	= `DIS;
						id_mem_rd_addr_o	= 32'b0;
					end 
				endcase
			end
			

			`INST_TYPE_S:begin //typeS的imm，都交给exe做inst解码...
				base_addr_o = 32'b0;
				offset_addr_o = 32'b0;
				case(func3)
					`INST_SB,	//Store Byte-----SB---M[rs1 + imm][0:7]	 = rs2[0:7]
					`INST_SH,	//Store Half-----SH---M[rs1 + imm][0:15] = rs2[0:15]
					`INST_SW:	//Store Word-----SW---M[rs1 + imm][0:31] = rs2[0:31]
					begin
						rs1_addr_o			= rs1;
						rs2_addr_o			= rs2;
						opD1_o				= rs1_Data_i;
						opD2_o				= rs2_Data_i;
						rd_addr_o			= 5'b0;
						rd_wen				= `DIS;  //【id给】or exe给，都可
						id_mem_rd_req_o		= `DIS;
						id_mem_rd_addr_o	= 32'b0;
					end	

					default :begin
						rs1_addr_o			= 5'b0;
						rs2_addr_o			= 5'b0;
						opD1_o				= 32'b0;
						opD2_o				= 32'b0;
						rd_addr_o			= 5'b0;
						rd_wen				= 1'b0;
						id_mem_rd_req_o		= `DIS;
						id_mem_rd_addr_o	= 32'b0;
					end 
				endcase
			end

				
			`INST_JAL:begin					//[rd = PC + 4;	PC += imm]
				rs1_addr_o	= 5'b0;
				rs2_addr_o	= 5'b0;
				opD1_o		= inst_addr_i;
				opD2_o		= 32'd4;
				rd_addr_o	= rd;
				rd_wen		= 1'b1;  //【id给】or exe给，都可
				base_addr_o = inst_addr_i;
				offset_addr_o = JAL_imm_32b;
				id_mem_rd_req_o	= `DIS;
				id_mem_rd_addr_o	= 32'b0;
			end
			
			
			`INST_JALR:begin					//[rd = PC + 4;	PC = rs1 + imm]
				rs1_addr_o	= rs1;
				rs2_addr_o	= 5'b0;
				opD1_o		= inst_addr_i;
				opD2_o		= 32'd4;
				rd_addr_o	= rd;
				rd_wen		= 1'b1;  //【id给】or exe给，都可
				base_addr_o = rs1_Data_i;
				offset_addr_o = JALR_imm_32b;
				id_mem_rd_req_o	= `DIS;
				id_mem_rd_addr_o	= 32'b0;
			end
			
			
			`INST_LUI:begin					//[rd = imm << 12]
				rs1_addr_o	= 5'b0;
				rs2_addr_o	= 5'b0;
				opD1_o		= LUI_imm_32b;	//已经  <<12
				opD2_o		= 32'b0;
				rd_addr_o	= rd;
				rd_wen		= 1'b1;  //【id给】or exe给，都可
				base_addr_o = 32'b0;
				offset_addr_o = 32'b0;
				id_mem_rd_req_o	= `DIS;
				id_mem_rd_addr_o	= 32'b0;
			end


			`INST_AUIPC:begin					//[rd = PC + (imm << 12)]
				rs1_addr_o	= 5'b0;
				rs2_addr_o	= 5'b0;
				opD1_o		= inst_addr_i;	
				opD2_o		= AUIPC_imm_32b;	//已经  <<12
				rd_addr_o	= rd;
				rd_wen		= 1'b1;  //【id给】or exe给，都可
				base_addr_o = 32'b0;
				offset_addr_o = 32'b0;
				id_mem_rd_req_o	= `DIS;
				id_mem_rd_addr_o	= 32'b0;
			end




			default :begin
				rs1_addr_o	= 5'b0;
				rs2_addr_o	= 5'b0;
				opD1_o		= 32'b0;
				opD2_o		= 32'b0;
				rd_addr_o	= 5'b0;
				rd_wen		= 1'b0; 
				base_addr_o = 32'b0;
				offset_addr_o = 32'b0;
				id_mem_rd_req_o	= `DIS;
				id_mem_rd_addr_o	= 32'b0;
			end
		endcase
	end
	
endmodule
	
