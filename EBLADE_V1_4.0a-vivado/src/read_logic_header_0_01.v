`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: read_logic_header
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
module read_logic_header (
  input clk,
  input rst,
  input rd_char_incr, 
  input rd_newline,
  input tlastarray_cs_rgs,
  input we_rgs,
  input [12:0] wr_ptr_rgs,
  input [7:0] tdata_rgs,
  output tlast_flag,
  output [12:0] rd_ptr,
  output [2:0] rd_ptr_tribit,
  output [15:0] body_length
  );

  wire [11:0] w_read_logic_counters_rd_ptr;
  wire [3:0] w_read_logic_regs_header_vlan_ptr;

  
read_logic_counters #(.CHAR_WIDTH(9), .LINE_WIDTH(3)) READ_LOGIC_COUNTERS1 (.clk(clk), .rst(rst), 
	.rd_char_incr(rd_char_incr), 
	.rd_newline(rd_newline), 
	.rd_ptr(w_read_logic_counters_rd_ptr));

read_logic_regs_header READ_LOGIC_REGS_HEADER1 (.clk(clk),
	.rd_ptr(w_read_logic_counters_rd_ptr[10:0]),
	.wr_ptr_rgs(wr_ptr_rgs),
	.tlastarray_cs_rgs(tlastarray_cs_rgs),
	.we_rgs(we_rgs),
	.tdata_rgs(tdata_rgs),
	.tlast_flag(tlast_flag),
	.body_length(body_length),
	.vlan_ptr(w_read_logic_regs_header_vlan_ptr));

 assign rd_ptr_tribit = w_read_logic_counters_rd_ptr[11:9];
 assign rd_ptr = {w_read_logic_regs_header_vlan_ptr, w_read_logic_counters_rd_ptr[8:0]};
 

endmodule
