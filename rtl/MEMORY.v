`include "defines.v"
//内存

module MEMORY
#(
	parameter DW = 32,
	parameter AW = 32,
	parameter Depth = 4096
)

(
	input						clk,
	input 						rst_n,
	
	input  wire					w_en,	
	input  wire[AW-1:0]			w_addr_i,
	input  wire[DW-1:0]			w_data_i,
	input  wire[2:0]			w_op_type_i,//`WR_OP_TYPE_BYTE/`WR_OP_TYPE_HALFWORD/`WR_OP_TYPE_WORD
	
	input  wire					r_en,
	input  wire[AW-1:0]			r_addr_i,
	output wire[7:0]			r_byte_o,
	output wire[15:0]			r_halfword_o,
	output wire[31:0]			r_word_o
);

//----读逻辑----//
wire [31:0]r_word_addr;	//真正进位宽为32bit的ram的读地址
wire [31:0]r_data;
reg [1:0]r_byte_sel;

assign r_word_addr = r_addr_i[31:2];    // addr / 4

always@(posedge clk)begin
	if(r_en)
		r_byte_sel <= r_addr_i[1:0];
end 

assign r_byte_o 	= 	r_byte_sel==0	? 	r_data[7:0]		:
						r_byte_sel==1	? 	r_data[15:8]	:
						r_byte_sel==2	? 	r_data[23:16]	:
											r_data[31:24]	;
						 
assign r_halfword_o = 	r_byte_sel==0	? 	r_data[15:0]	:
						r_byte_sel==2	? 	r_data[31:16]	:
											16'b0			;//没有字节对齐，硬件异常
									
assign r_word_o 	= 	r_byte_sel==0	? 	r_data[31:0]	:
											32'b0			;//没有字节对齐，硬件异常



//----写逻辑----//掩码生成，传递给最内层
wire [31:0]w_word_addr;	//真正进位宽为32bit的ram的写地址
assign w_word_addr = w_addr_i[31:2];    // addr / 4

wire [1:0]w_byte_sel;
assign w_byte_sel = w_addr_i[1:0];

reg [3:0] w_mask;//传递给最内层
always@(*)begin
	case(w_op_type_i)
		`WR_OP_TYPE_BYTE : w_mask = w_byte_sel==0 ? 4'b0001 :
									w_byte_sel==1 ? 4'b0010 :
									w_byte_sel==2 ? 4'b0100 :
													4'b1000 ;
													
		`WR_OP_TYPE_HALFWORD : w_mask = w_byte_sel==0 ? 4'b0011 :
										w_byte_sel==2 ? 4'b1100 :
														4'b0000 ;//没有字节对齐，硬件异常
														
		`WR_OP_TYPE_WORD : w_mask = w_byte_sel==0 ? 4'b1111 :
													4'b0000 ;//没有字节对齐，硬件异常
													
		default: w_mask = 4'b0000;//硬件异常
	endcase
end







dual_RAM_opti
#(
	.DW					(DW),
	.AW					(AW),
	.Depth				(Depth)
)
dual_RAM_opti1
(
	.clk                (clk),
	.rst_n              (1'b1),//注意这里不能rst，否则仿真initial写的东西就被清掉了，程序ROM也是。
						
	.w_en               (w_en),
	.w_addr_i           (w_word_addr),//还有写入地址要处理 >>2
	.w_Data_i           (w_data_i), 
	// .w_op_type_i		(w_op_type_i),
	.w_mask_i			(w_mask),
						
	.r_en               (r_en),
	.r_addr_i           (r_word_addr),
	.r_Data_o           (r_data)
);




endmodule

