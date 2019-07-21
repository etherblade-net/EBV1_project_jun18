`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: read_logic_regs_storage
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
module read_logic_regs_storage (
  input clk,
  input [12:0] rd_ptr, 
  input [12:0] wr_ptr_rgs,
  input tlastarray_cs_rgs,
  input we_rgs,
  output tlast_flag
  );
  
  wire [1:0] rd_line_ptr;
  wire [10:0] rd_char_ptr;
  wire tlastarray_rgs_we;
  wire [10:0] wr_ptr_rgs_data;
  wire [1:0] wr_ptr_rgs_address;
  wire [10:0] rd_tlast_ptr;
 
 //Instantiate tlast_pointers_array
dual_port_asyncout_ram #(.D_WIDTH(11), .A_WIDTH(2)) tlast_pointers_array1 (.clk(clk), .we(tlastarray_rgs_we), .data(wr_ptr_rgs_data), .read_addr(rd_line_ptr), .write_addr(wr_ptr_rgs_address), .q(rd_tlast_ptr));

 
 assign tlastarray_rgs_we = tlastarray_cs_rgs && we_rgs;
 assign tlast_flag = (rd_tlast_ptr == rd_char_ptr)? 1'b1 : 1'b0;
 assign {wr_ptr_rgs_address, wr_ptr_rgs_data} = wr_ptr_rgs;
 assign {rd_line_ptr, rd_char_ptr} = rd_ptr;
 
endmodule
