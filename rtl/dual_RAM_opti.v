//伪双口RAM
/////////为了能用片上BRAM，解决读写冲突的RAM_opti模块化写法

module dual_RAM_opti
#(
	parameter DW = 32,
	parameter AW = 12,
	parameter Depth = 4096
)

(
	input						clk,
	input 						rst_n,
	
	input  wire					w_en,
	input  wire[AW-1:0]			w_addr_i,
	input  wire[DW-1:0]			w_Data_i,
	// input  wire[2:0]			w_op_type_i,
	input  wire[3:0]			w_mask_i,
	
	input  wire					r_en,
	input  wire[AW-1:0]			r_addr_i,
	output reg[DW-1:0]			r_Data_o
);

/////////为了能用片上BRAM，解决读写冲突的RAM_opti模块化写法
wire [DW-1:0]r_Data_RAM_o;
wire raddr_equal_waddr;

reg [DW-1:0]w_Data_i_reg;  //w_Data 打一拍
reg raddr_equal_waddr_reg;  //raddr_equal_waddr 打一拍

assign raddr_equal_waddr = (w_en && r_en && (r_addr_i==w_addr_i));
	
//20260225 已画时序图确认，打一拍符合逻辑
always@(posedge clk)begin
	w_Data_i_reg <= w_Data_i;		//待验证
	raddr_equal_waddr_reg <= raddr_equal_waddr;
end

reg [3:0]w_mask_r;
always@(posedge clk)begin
	w_mask_r <= w_mask_i;
end
always@(*)begin
	if(raddr_equal_waddr_reg)begin
		r_Data_o[7:0] 	= w_mask_r[0] ? w_Data_i_reg[7:0] 	: r_Data_RAM_o[7:0]		;
		r_Data_o[15:8] 	= w_mask_r[1] ? w_Data_i_reg[15:8] 	: r_Data_RAM_o[15:8]	;
		r_Data_o[23:16] = w_mask_r[2] ? w_Data_i_reg[23:16] : r_Data_RAM_o[23:16]	;
		r_Data_o[31:24] = w_mask_r[3] ? w_Data_i_reg[31:24] : r_Data_RAM_o[31:24]	;
	end
	else
		r_Data_o = r_Data_RAM_o;
end
//assign r_Data_o = raddr_equal_waddr_reg ? w_Data_i_reg : r_Data_RAM_o;


dual_RAM 
#(	.DW					(DW),
	.AW     			(AW),
	.Depth  			(Depth)
)
dual_RAM1 
(
	.clk				(clk),
	.rst_n				(rst_n),
						
	.w_en				(w_en),
	.w_addr_i			(w_addr_i),
	.w_Data_i			(w_Data_i),
	// .w_op_type_i		(w_op_type_i)
	.w_mask_i			(w_mask_i),
						
	.r_en				(r_en),
	.r_addr_i			(r_addr_i),
	.r_Data_o			(r_Data_RAM_o)
);



endmodule


//20260316：添加了lb/sb这类有byte sel的操作后，是否会影响读写旁路逻辑？
//画图研究了一下，初步判断原旁路逻辑是不影响字节旁路或半字旁路的。故保持原样。

//20260317:吃屎，这么明显的逻辑影响都看不出来？昨天在想什么？
