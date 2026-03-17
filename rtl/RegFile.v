//20260222 可疑问题
//前两个组合逻辑块，感觉不需要“ if(~rst_n) ” 这个逻辑。因为负责寄存器堆的always块已经正确给寄存器数组复位了。

//可疑问题
//目前的代码风格是同步写+异步读，只适合教学仿真。参考：https://chatgpt.com/s/t_699b2047f704819190abfeecbbaa5c61

//RegFile--- 寄存器堆 ---简易的RAM用rtl实现
//是CPU中多个寄存器组成的阵列，通常由快速的静态随机读写存储器（SRAM）实现。这种RAM具有专门的读端口与写端口，可以多路并发访问不同的寄存器。

module RegFile(		
	input				clk,
	input 				rst_n,

//from exe					
	input wire			reg_wen,
	input wire [4:0]	reg_waddr_i,
	input wire [31:0]	reg_wData_i,
	
//to idecoder
	input  wire[4:0]	reg1_raddr_i,	
	input  wire[4:0]	reg2_raddr_i,
	output reg [31:0]	reg1_rData_o,
	output reg [31:0]	reg2_rData_o
);

reg [31:0]regs [0:31];    //深度32，因为inst中的reg地址用5b表示。

//reg1通道输出--reg1_Data_o
always@(*)begin
	if(~rst_n)
		reg1_rData_o <= 32'b0; 
	else if(reg1_raddr_i == 5'b0)      //第0个寄存器恒为全0
		reg1_rData_o <= 32'b0; 
	else if(reg_wen && (reg_waddr_i == reg1_raddr_i)) //前一个指令的回写是下一个指令的读出（回写模块得是组合逻辑）
		reg1_rData_o <= reg_wData_i; 
	else 
		reg1_rData_o <= regs[reg1_raddr_i]; 
end

//reg2通道输出--reg2_Data_o
always@(*)begin
	if(~rst_n)
		reg2_rData_o <= 32'b0; 
	else if(reg2_raddr_i == 5'b0)      //第0个寄存器恒为全0
		reg2_rData_o <= 32'b0; 
	else if(reg_wen && (reg_waddr_i == reg2_raddr_i))
		reg2_rData_o <= reg_wData_i; 
	else 
		reg2_rData_o <= regs[reg2_raddr_i]; 
end



integer i;
always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		regs[0] <= 32'b0;
		for(i=1;i<32;i=i+1)begin
			regs[i] <= 32'b0;
		end
    end
	
	else if(reg_wen && (reg_waddr_i != 5'b0))begin //不能写0寄存器
		regs[reg_waddr_i] <= reg_wData_i;
	end
		
end





endmodule 
