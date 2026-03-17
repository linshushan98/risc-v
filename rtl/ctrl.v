
//ctrl---

`include "defines.v"

module ctrl(				
//from exe
	input wire	[31:0]	jump_addr_i,
	input wire			jump_en_i,
	input wire			hold_flag_i,
	
//ctrl to pc	
	output wire	[31:0]	jump_addr_o,
	output wire			jump_en_o,
	
//ctrl to ifsc & idsc	
	output reg			hold_flag_o   //冲刷流水线，应该是让那些寄存器同步复位还是异步？
);



	assign jump_addr_o = jump_addr_i;
	assign jump_en_o = jump_en_i;

	always@(*)begin
		if(jump_en_i || hold_flag_i)
			hold_flag_o = 1'b1;
		else
			hold_flag_o = 1'b0;
	end
	


endmodule
