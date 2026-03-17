
//用于存放指令的ROM

module ROM
#(
	parameter DW = 32,
	parameter AW = 12,
	parameter Depth = 4096
)

(
	input						clk,
	input 						rst_n,
	
	input  wire					w_en,			//预留写端口，可以通过上位机写程序进ROM
	input  wire[AW-1:0]			w_addr_i,		//预留写端口，可以通过上位机写程序进ROM
	input  wire[DW-1:0]			w_inst_i,		//预留写端口，可以通过上位机写程序进ROM
	
	input  wire					r_en,
	input  wire[AW-1:0]			inst_addr_i,
	output wire[DW-1:0]			inst_o
);

dual_RAM_opti
#(
	.DW					(DW),
	.AW					(AW),
	.Depth				(Depth)
)

dual_RAM_opti1
(
	.clk                (clk),
	.rst_n              (1'b1),				///////////////!!!!!!!!
						
	.w_en               (w_en),
	.w_addr_i           (w_addr_i),
	.w_Data_i           (w_inst_i),
	.w_mask_i			(4'b1111),		//程序ROM里应该用不到掩码，故全1
	
	.r_en               (r_en),
	.r_addr_i           (inst_addr_i >> 2),	///////////////!!!!!!!! 因为当时是这样写的..pc_o <= pc_o + 4;	//32位 CPU，一条指令占 4 byte。
	.r_Data_o           (inst_o)
);



/*	//老版本写法
	// reg [31:0] rom_memory[0:4095]; //width：32b     depth：4096

	// always@(*)begin
		// inst_o = rom_memory[inst_addr_i >> 2];   
	// end
*/



endmodule

