//RAM--伪双口RAM--伪双口RAM，一个端口只读，另一个端口只写

//而双口RAM两个端口都可以读写。
`include "defines.v"
module dual_RAM
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
	input  wire[3:0]			w_mask_i,	//掩码逻辑为：1 代表对应byte写入有效
	
	input  wire					r_en,
	input  wire[AW-1:0]			r_addr_i,
	output reg [DW-1:0]			r_Data_o
);

(*ram_style="block"*) reg [DW-1:0] ram_memory[0:Depth-1]; //width：32b     depth：4096


always@(posedge clk or negedge rst_n)begin
	if(!rst_n)
		r_Data_o <= 32'b0;
	else if(r_en)
		r_Data_o <= ram_memory[r_addr_i];   
	else
		r_Data_o <= r_Data_o;  
end

always@(posedge clk)begin
	if(w_en)begin
		if(w_mask_i[0]) ram_memory[w_addr_i][7:0] 	<= w_Data_i[7:0]; 
		if(w_mask_i[1]) ram_memory[w_addr_i][15:8] 	<= w_Data_i[15:8]; 
		if(w_mask_i[2]) ram_memory[w_addr_i][23:16] <= w_Data_i[23:16]; 
		if(w_mask_i[3]) ram_memory[w_addr_i][31:24] <= w_Data_i[31:24]; 
	end
end
	

endmodule

