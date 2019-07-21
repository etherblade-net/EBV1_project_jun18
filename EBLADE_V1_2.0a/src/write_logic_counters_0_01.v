`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: write_logic_counters
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
module write_logic_counters (
  input clk,
  input rst,
  input wr_newline,
  input wr_restart_line,
  input wr_char_incr,
  output [13:0] wr_ptr
);
  
  reg [2:0] wr_line_ptr;
  reg [10:0] wr_char_ptr;
  wire wr_newline_or_wr_restart_line_or_rst;
  
//WR_LINE_COUNTER
always @(posedge clk)
if (rst) begin
 wr_line_ptr <= 3'b0;
 end else if (wr_newline) begin
 wr_line_ptr <= wr_line_ptr + 1'b1;
 end  
  
  //WR_CHAR_COUNTER
 always @(posedge clk)
 if (wr_newline_or_wr_restart_line_or_rst) begin
 wr_char_ptr <= 11'b0;
 end else if (wr_char_incr) begin
 wr_char_ptr <= wr_char_ptr + 1'b1;
 end

 assign wr_newline_or_wr_restart_line_or_rst = wr_newline || wr_restart_line || rst;
 assign wr_ptr = {wr_line_ptr, wr_char_ptr};
 
endmodule