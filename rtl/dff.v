
//dff´¥·¢Æ÷
//
//	dff #(32) dff1(clk,rst_n,rst_Data_o,Data_i,Data_o);

module dff
#(parameter DW = 32)

(
	input				clk,
	input 				rst_n,
	input  wire			hold_flag,

	
	input  wire[DW-1:0]	rst_Data_o,
	input  wire[DW-1:0]	Data_i,
	output reg [DW-1:0]	Data_o

);

	always@(posedge clk or negedge rst_n)begin
		if((~rst_n)||(hold_flag))
			Data_o <= rst_Data_o;
		else
			Data_o <= Data_i;
	end
	

endmodule
