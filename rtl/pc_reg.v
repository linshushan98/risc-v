
//PC(ProgramCounter,PC)----（指令计数器）
//用来存放当前欲执行指令的地址，它与主存的MAR之间有一条直接通路，且具有自加1的功能，即可形成下一条指令的地址。

module pc_reg(				
	input				clk,
	input 				rst_n,
	input  wire[31:0]	jump_addr_i,
	input  wire			jump_en_i,
	
	output reg[31:0]	pc_o	//inst_addr
);
	
always@(posedge clk or negedge rst_n)begin
	if(~rst_n)
		pc_o <= 32'd 0;
	else if(jump_en_i)
		pc_o <= jump_addr_i;
	else
		pc_o <= pc_o + 3'd 4;		//32位 CPU，一条指令占 4 byte。
end


endmodule


