`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: read_logic_counters
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
module read_logic_counters #(parameter CHAR_WIDTH = 11, parameter LINE_WIDTH = 3)
(
  input clk,
  input rst,
  input rd_char_incr, 
  input rd_newline,
  output [(LINE_WIDTH+CHAR_WIDTH-1):0] rd_ptr
  );
  
  reg [CHAR_WIDTH-1:0] rd_char_ptr;
  reg [LINE_WIDTH-1:0] rd_line_ptr;
  wire rd_newline_or_rst;
  
  //RD_LINE_COUNTER
 always @(posedge clk)
 if (rst) begin
 rd_line_ptr <= {LINE_WIDTH{1'b0}};
 end else if (rd_newline) begin
 rd_line_ptr <= rd_line_ptr + 1'b1;
 end
 
 //RD_CHAR_COUNTER
always @(posedge clk)
if (rd_newline_or_rst) begin
 rd_char_ptr <= {CHAR_WIDTH{1'b0}};
 end else if (rd_char_incr) begin
 rd_char_ptr <= rd_char_ptr + 1'b1;
 end
 
 assign rd_newline_or_rst = rd_newline || rst;
 assign rd_ptr = {rd_line_ptr, rd_char_ptr};
 
endmodule
