`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: read_logic_regs_header
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
module read_logic_regs_header (
  input clk,
  input [10:0] rd_ptr, 
  input [12:0] wr_ptr_rgs,
  input tlastarray_cs_rgs,
  input we_rgs,
  input [7:0] tdata_rgs,
  output tlast_flag,
  output [15:0] body_length,
  output [3:0] vlan_ptr
  );
//  parameter TOTAL_HEADER_LENGTH = 9'b000111111; //64 bytes which is enough for "Eth802.3(14)+IPv4(20)+UDP(8)+OTV(8)" or ""Eth802.3(14)+IPv6(40)+10_extra_bytes"
  parameter TOTAL_HEADER_LENGTH = 9'b000011111; //FOR TEST (32bytes)
  parameter VLAN_ID_SEQ_POSITION = 11'b00000001111;	//15th octet in 802.1q ethernet frame - least significat 8bits in 802.1q-TAG containing vlanID.
//  parameter VLAN_ID_SEQ_POSITION = 11'b00000000100; //FOR TEST (4th position)
  wire [1:0] rd_line_ptr;
  wire [8:0] rd_char_ptr;
  wire tlastarray_rgs_we;
  wire [10:0] wr_ptr_rgs_data;
  wire [1:0] wr_ptr_rgs_address;
  wire [10:0] rd_tlast_ptr;
  wire [3:0] tdata_rgs_4bit;
  wire vlan_rgs_we;
 
 //Instantiate tlast_pointers_array
dual_port_asyncout_ram #(.D_WIDTH(11), .A_WIDTH(2)) tlast_pointers_array1 (.clk(clk), 
	.we(tlastarray_rgs_we), 
	.data(wr_ptr_rgs_data), 
	.read_addr(rd_line_ptr), 
	.write_addr(wr_ptr_rgs_address), 
	.q(rd_tlast_ptr));

//Instantiate vlan_reg
dual_port_asyncout_ram #(.D_WIDTH(4), .A_WIDTH(2)) vlan_reg1 (.clk(clk),
	.we(vlan_rgs_we),
	.data(tdata_rgs_4bit),
	.read_addr(rd_line_ptr),
	.write_addr(wr_ptr_rgs_address),
	.q(vlan_ptr));

 
 assign tlastarray_rgs_we = tlastarray_cs_rgs && we_rgs;
 assign tlast_flag = (TOTAL_HEADER_LENGTH == rd_char_ptr)? 1'b1 : 1'b0;
 assign {wr_ptr_rgs_address, wr_ptr_rgs_data} = wr_ptr_rgs;
 assign vlan_rgs_we =  ((VLAN_ID_SEQ_POSITION == wr_ptr_rgs_data)? 1'b1 : 1'b0) && we_rgs;
 assign tdata_rgs_4bit = tdata_rgs[3:0];
 assign body_length = {5'b00000, rd_tlast_ptr};
 assign {rd_line_ptr, rd_char_ptr} = rd_ptr;
 
endmodule
