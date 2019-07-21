`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: read_logic_storage
// Project Name: EtherBlade.net_v1 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Version: 0.01
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module read_logic_storage (
  input clk,
  input rst,
  input rd_char_incr, 
  input rd_newline,
  input tlastarray_cs_rgs,
  input we_rgs,
  input [12:0] wr_ptr_rgs,
  output tlast_flag,
  output [12:0] rd_ptr,
  output [2:0] rd_ptr_tribit
  );

  wire [13:0] w_read_logic_counters_rd_ptr;
  
read_logic_counters #(.CHAR_WIDTH(11), .LINE_WIDTH(3)) READ_LOGIC_COUNTERS1 (.clk(clk), .rst(rst), 
	.rd_char_incr(rd_char_incr), 
	.rd_newline(rd_newline), 
	.rd_ptr(w_read_logic_counters_rd_ptr));
	
read_logic_regs_storage READ_LOGIC_REGS1 (.clk(clk), 
	.rd_ptr(w_read_logic_counters_rd_ptr[12:0]), 
	.wr_ptr_rgs(wr_ptr_rgs), 
	.tlastarray_cs_rgs(tlastarray_cs_rgs), 
	.we_rgs(we_rgs), 
	.tlast_flag(tlast_flag));

 assign rd_ptr_tribit = w_read_logic_counters_rd_ptr[13:11];
 assign rd_ptr = w_read_logic_counters_rd_ptr[12:0];
 

endmodule
