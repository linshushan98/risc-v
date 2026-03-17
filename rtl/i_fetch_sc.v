
//i_fetch_sc----把i_fetch转成时序逻辑---把 inst 和 inst_addr 打一拍

`include "defines.v"

module i_fetch_sc(				
	input  wire			clk,
	input  wire			rst_n,
	input  wire			hold_flag_i,
		
	input  wire[31:0]	inst_i,	
	input  wire[31:0]	inst_addr_i,
	
	output wire[31:0]	inst_o,
	output wire[31:0]	inst_addr_o
);

reg inst_valid_flag;

// assign inst_valid_flag = rst_n && (~hold_flag_i);  	//	异步冲刷流水线标志位

	always@(posedge clk or negedge rst_n)begin		//	同步冲刷流水线标志位
		if((~rst_n) || hold_flag_i)
			inst_valid_flag <= 1'b0;			
		else
			inst_valid_flag <= 1'b1;			
	end


assign inst_o = inst_valid_flag ? inst_i : `INST_NOP ;


	dff #(32) dff2(clk,rst_n,hold_flag_i,32'b0,inst_addr_i,inst_addr_o);	


		//老版本写法
	// dff #(32) dff1(clk,rst_n,hold_flag_i,`INST_NOP,inst_i,inst_o);
	// dff #(32) dff2(clk,rst_n,hold_flag_i,32'b0,inst_addr_i,inst_addr_o);	
	

endmodule 
