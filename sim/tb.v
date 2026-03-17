`timescale 1ns / 1ps

module tb();

	reg clk;
	reg rst_n;
	
	
	riscV_SOC riscV_SOC1(
		.clk		(clk),
		.rst_n		(rst_n)
	);	


//时钟、复位信号驱动
	initial clk = 0;
	always begin
		#10;
		clk = ~clk;
	end

	initial begin
		rst_n = 1'b0;
		#5;
		rst_n = 1'b1;	
	end


//================================define 1=====================================//

initial begin
////ROM载入程序(初始值)
	$readmemh("../generated/inst_data.txt", tb.riscV_SOC1.ROM1.dual_RAM_opti1.dual_RAM1.ram_memory);//$readmemh  $readmemb
	
////内存载入，用于测试lb等指令
    $readmemh("../generated/inst_data.txt", tb.riscV_SOC1.MEMORY1.dual_RAM_opti1.dual_RAM1.ram_memory);
end	








	
wire [31:0] x3 = tb.riscV_SOC1.riscV_1.RegFile1.regs[3];   //gp
wire [31:0] x26 = tb.riscV_SOC1.riscV_1.RegFile1.regs[26];
wire [31:0] x27 = tb.riscV_SOC1.riscV_1.RegFile1.regs[27];

wire [31:0] x1 = tb.riscV_SOC1.riscV_1.RegFile1.regs[1];	//ra	-- r1
wire [31:0] x2 = tb.riscV_SOC1.riscV_1.RegFile1.regs[2];	//sp	-- r2
wire [31:0] x30 = tb.riscV_SOC1.riscV_1.RegFile1.regs[30];	//t5	--save result
wire [31:0] x29 = tb.riscV_SOC1.riscV_1.RegFile1.regs[29];	//t4	// =0x80004
integer r;
//在每个posedge clk时，打印寄存器的值
	initial begin
		while(1)begin
			@(posedge clk)
			wait(x26 == 1'b1)begin
				#100;
				if(x27 == 1'b1)begin
					$display("---------------------------");
					$display("-----------pass------------");
					$display("---------------------------");
				end
				else if(x27 == 1'b0)begin
					$display("fail-----------------------");
					$display("fail testnum = %2d", x3);
					for(r=0;r<32;r=r+1)begin
						$display("x%d reg is : %d",r,$signed(tb.riscV_SOC1.riscV_1.RegFile1.regs[r]));
					end
				end
				
				// $stop;

				$finish();
			end
		end
	end	



/*
//================================define 2=====================================//
//ROM1载入程序(初始值)  ram核无复位
	initial begin

		$readmemh("C:/Users/22144/Desktop/risc_V_proj/tb-sim/instTest_mulhsu.txt",tb.riscV_SOC1.ROM1.dual_RAM_opti1.dual_RAM1.ram_memory);//$readmemh  $readmemb vivado
//		$readmemh("./generated/inst_data.txt",tb.riscV_SOC1.ROM1.dual_RAM_opti1.dual_RAM1.ram_memory);//$readmemh  $readmemb
	end	
	
////MEMORY1载入程序(初始值)
	// initial begin
		// #6;
		// tb.riscV_SOC1.MEMORY1.dual_RAM_opti1.dual_RAM1.ram_memory[4088] = -32'd1;
	// end


wire [31:0] x1 = tb.riscV_SOC1.riscV_1.RegFile1.regs[1];	//ra	-- r1
wire [31:0] x2 = tb.riscV_SOC1.riscV_1.RegFile1.regs[2];	//sp	-- r2
wire [31:0] x30 = tb.riscV_SOC1.riscV_1.RegFile1.regs[30];	//t5	--save result
wire [31:0] x29 = tb.riscV_SOC1.riscV_1.RegFile1.regs[29];	//t4	// =0x80004
integer r;
//在每个posedge clk时，打印寄存器的值
	initial begin
		while(1)begin
			@(posedge clk)
			$display("====-----------------------");
			$display("ra reg is : %d",tb.riscV_SOC1.riscV_1.RegFile1.regs[1]);
			$display("sp reg is : %d",tb.riscV_SOC1.riscV_1.RegFile1.regs[2]);
			$display("t5 reg is : %d",tb.riscV_SOC1.riscV_1.RegFile1.regs[30]);
			$display("t4 reg is : %d",tb.riscV_SOC1.riscV_1.RegFile1.regs[29]);
			$display("-----------------------====");
			$stop;
		end
	end	
*/





    // sim timeout
    initial begin
        #500000
        $display("Time Out.");
        $finish;
    end
	
	
	
endmodule



