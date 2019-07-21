`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: write_logic
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
module write_logic (
  input clk,
  input rst,
  input wr_newline,
  input wr_restart_line,
  input wr_char_incr,
  output [2:0] wr_ptr_tribit,
  output [12:0] wr_ptr
);

wire [13:0] w_write_logic_counters_wr_ptr; 
  
write_logic_counters WRITE_LOGIC_COUNTERS1(.clk(clk), .rst(rst), 
	.wr_newline(wr_newline), 
	.wr_restart_line(wr_restart_line), 
	.wr_char_incr(wr_char_incr), 
	.wr_ptr(w_write_logic_counters_wr_ptr));

assign wr_ptr_tribit = w_write_logic_counters_wr_ptr[13:11];
assign wr_ptr = w_write_logic_counters_wr_ptr[12:0];
   
endmodule
