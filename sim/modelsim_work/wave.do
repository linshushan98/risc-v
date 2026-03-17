onerror {resume}
quietly set dataset_list [list sim vsim1 vsim]
if {[catch {datasetcheck $dataset_list}]} {abort}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -label sim:/tb/riscV_SOC1/MEMORY1/Group1 -group {Region: sim:/tb/riscV_SOC1/MEMORY1} sim:/tb/riscV_SOC1/MEMORY1/rst_n
add wave -noupdate -expand -label sim:/tb/riscV_SOC1/MEMORY1/Group1 -group {Region: sim:/tb/riscV_SOC1/MEMORY1} -color {Violet Red} sim:/tb/riscV_SOC1/MEMORY1/w_en
add wave -noupdate -expand -label sim:/tb/riscV_SOC1/MEMORY1/Group1 -group {Region: sim:/tb/riscV_SOC1/MEMORY1} -color {Violet Red} sim:/tb/riscV_SOC1/MEMORY1/w_addr_i
add wave -noupdate -expand -label sim:/tb/riscV_SOC1/MEMORY1/Group1 -group {Region: sim:/tb/riscV_SOC1/MEMORY1} -color {Violet Red} sim:/tb/riscV_SOC1/MEMORY1/w_data_i
add wave -noupdate -expand -label sim:/tb/riscV_SOC1/MEMORY1/Group1 -group {Region: sim:/tb/riscV_SOC1/MEMORY1} sim:/tb/riscV_SOC1/MEMORY1/w_op_type_i
add wave -noupdate -expand -label sim:/tb/riscV_SOC1/MEMORY1/Group1 -group {Region: sim:/tb/riscV_SOC1/MEMORY1} -color Gold sim:/tb/riscV_SOC1/MEMORY1/r_en
add wave -noupdate -expand -label sim:/tb/riscV_SOC1/MEMORY1/Group1 -group {Region: sim:/tb/riscV_SOC1/MEMORY1} -color Gold sim:/tb/riscV_SOC1/MEMORY1/r_addr_i
add wave -noupdate -expand -label sim:/tb/riscV_SOC1/MEMORY1/Group1 -group {Region: sim:/tb/riscV_SOC1/MEMORY1} sim:/tb/riscV_SOC1/MEMORY1/r_byte_o
add wave -noupdate -expand -label sim:/tb/riscV_SOC1/MEMORY1/Group1 -group {Region: sim:/tb/riscV_SOC1/MEMORY1} sim:/tb/riscV_SOC1/MEMORY1/r_halfword_o
add wave -noupdate -expand -label sim:/tb/riscV_SOC1/MEMORY1/Group1 -group {Region: sim:/tb/riscV_SOC1/MEMORY1} sim:/tb/riscV_SOC1/MEMORY1/r_word_o
add wave -noupdate -expand -label sim:/tb/riscV_SOC1/MEMORY1/Group1 -group {Region: sim:/tb/riscV_SOC1/MEMORY1} sim:/tb/riscV_SOC1/MEMORY1/r_word_addr
add wave -noupdate -expand -label sim:/tb/riscV_SOC1/MEMORY1/Group1 -group {Region: sim:/tb/riscV_SOC1/MEMORY1} sim:/tb/riscV_SOC1/MEMORY1/r_data
add wave -noupdate -expand -label sim:/tb/riscV_SOC1/MEMORY1/Group1 -group {Region: sim:/tb/riscV_SOC1/MEMORY1} sim:/tb/riscV_SOC1/MEMORY1/r_byte_sel
add wave -noupdate -expand -label sim:/tb/riscV_SOC1/MEMORY1/Group1 -group {Region: sim:/tb/riscV_SOC1/MEMORY1} sim:/tb/riscV_SOC1/MEMORY1/w_word_addr
add wave -noupdate -expand -label sim:/tb/riscV_SOC1/MEMORY1/Group1 -group {Region: sim:/tb/riscV_SOC1/MEMORY1} sim:/tb/riscV_SOC1/MEMORY1/w_byte_sel
add wave -noupdate -expand -label sim:/tb/riscV_SOC1/MEMORY1/Group1 -group {Region: sim:/tb/riscV_SOC1/MEMORY1} sim:/tb/riscV_SOC1/MEMORY1/w_mask
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/RegFile1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1/RegFile1} sim:/tb/riscV_SOC1/riscV_1/RegFile1/reg_wen
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/RegFile1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1/RegFile1} sim:/tb/riscV_SOC1/riscV_1/RegFile1/reg_waddr_i
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/RegFile1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1/RegFile1} sim:/tb/riscV_SOC1/riscV_1/RegFile1/reg_wData_i
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/RegFile1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1/RegFile1} sim:/tb/riscV_SOC1/riscV_1/RegFile1/reg1_raddr_i
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/RegFile1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1/RegFile1} sim:/tb/riscV_SOC1/riscV_1/RegFile1/reg2_raddr_i
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/RegFile1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1/RegFile1} sim:/tb/riscV_SOC1/riscV_1/RegFile1/reg1_rData_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/RegFile1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1/RegFile1} sim:/tb/riscV_SOC1/riscV_1/RegFile1/reg2_rData_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/RegFile1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1/RegFile1} sim:/tb/riscV_SOC1/riscV_1/RegFile1/regs
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/RegFile1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1/RegFile1} sim:/tb/riscV_SOC1/riscV_1/RegFile1/i
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/clk
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/rst_n
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/inst_addr_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/inst_i
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/id_mem_rd_req
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/id_mem_rd_addr
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/mem_exe_rd_byte
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/mem_exe_rd_halfword
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/mem_exe_rd_word
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/exe_mem_wr_req
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/exe_mem_wr_addr
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/exe_mem_wr_data
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/exe_mem_wr_op_type
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/inst_addr_pc_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/jump_addr
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/jump_en
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/inst_if_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/inst_addr_if_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/inst_ifsc_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/inst_addr_ifsc_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/hold_flag
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/inst_id_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/inst_addr_id_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/opD1_id_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/opD2_id_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/rd_addr_id_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/rd_wen_id_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/base_addr_id_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/offset_addr_id_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/rs1_addr_id_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/rs2_addr_id_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/reg1_rData_RF_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/reg2_rData_RF_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/inst_idsc_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/inst_addr_idsc_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/opD1_idsc_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/opD2_idsc_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/rd_addr_idsc_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/rd_wen_idsc_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/base_addr_idsc_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/offset_addr_idsc_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/rd_wen_ex_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/rd_waddr_ex_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/rd_wData_ex_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/jump_addr_exe_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/jump_en_exe_o
add wave -noupdate -label sim:/tb/riscV_SOC1/riscV_1/Group1 -group {Region: sim:/tb/riscV_SOC1/riscV_1} sim:/tb/riscV_SOC1/riscV_1/hold_flag_exe_o
add wave -noupdate {sim:/tb/riscV_SOC1/riscV_1/RegFile1/regs[3]}
add wave -noupdate {sim:/tb/riscV_SOC1/riscV_1/RegFile1/regs[26]}
add wave -noupdate {sim:/tb/riscV_SOC1/riscV_1/RegFile1/regs[27]}
add wave -noupdate sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1/ram_memory
add wave -noupdate -expand -label sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1/Group1 -group {Region: sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1} sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1/clk
add wave -noupdate -expand -label sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1/Group1 -group {Region: sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1} sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1/rst_n
add wave -noupdate -expand -label sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1/Group1 -group {Region: sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1} sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1/w_en
add wave -noupdate -expand -label sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1/Group1 -group {Region: sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1} sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1/w_addr_i
add wave -noupdate -expand -label sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1/Group1 -group {Region: sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1} sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1/w_Data_i
add wave -noupdate -expand -label sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1/Group1 -group {Region: sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1} sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1/w_mask_i
add wave -noupdate -expand -label sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1/Group1 -group {Region: sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1} sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1/r_en
add wave -noupdate -expand -label sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1/Group1 -group {Region: sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1} sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1/r_addr_i
add wave -noupdate -expand -label sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1/Group1 -group {Region: sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1} sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1/r_Data_o
add wave -noupdate -expand -label sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1/Group1 -group {Region: sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1} sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1/ram_memory
add wave -noupdate {sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1/ram_memory[1024]}
add wave -noupdate {sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1/ram_memory[1025]}
add wave -noupdate {sim:/tb/riscV_SOC1/MEMORY1/dual_RAM_opti1/dual_RAM1/ram_memory[1026]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {544657 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 303
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {2100 ns}
