
//instruction fetch  取指模块
//从PC_reg中获取指令地址，根据地址去ROM中获取指令。

module i_fetch(				
	
	//with pc
	input	[31:0]		inst_addr_i, //pc_o
	
	//with ROM
	output wire[31:0]	if2ROM_addr_o,
	input	[31:0]		ROM2if_inst_i,
	
	//with if_id
	output wire[31:0]	inst_o,
	output wire[31:0]	inst_addr_o
);
	
// always@(posedge clk or negedge rst_n)begin
	// if(~rst_n)
		// if2ROM_addr_o <= 32'b0;
	// else
		// if2ROM_addr_o <= inst_addr_i;
// end

assign if2ROM_addr_o = inst_addr_i;

assign inst_o = ROM2if_inst_i;

assign inst_addr_o = inst_addr_i;


endmodule


