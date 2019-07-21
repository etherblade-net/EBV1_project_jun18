`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: L23_buffer_vivadowrapper
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
module L23_buffer_vivadowrapper (
input L23_clk,	//shared wire
input L23_rst,	//shared wire
input [7:0] L23i_tdata,
input L23i_tlast,
input L23i_tuser,
output L23i_tready,
input L23i_tvalid,
output [7:0] L23o_tdata,
output L23o_tlast,
input L23o_tready,
output L23o_tvalid,

input [8:0] bram_wrdata_0,
input [14:0] bram_addr_0,
input bram_we_0,
input [15:0] bram_wrdata_1,
input [6:0] bram_addr_1,
input bram_we_1
);

wire w_towemgmt1;
wire w_towemgmt2;

//Modules instantiations

L23_buffer Label1 (.L23_clk(L23_clk), .L23_rst(L23_rst),
	.L23i_tdata(L23i_tdata),
	.L23i_tlast(L23i_tlast),
	.L23i_tuser(L23i_tuser),
	.L23i_tready(L23i_tready),
	.L23i_tvalid(L23i_tvalid),
	.L23o_tdata(L23o_tdata),
	.L23o_tlast(L23o_tlast),
	.L23o_tready(L23o_tready),
	.L23o_tvalid(L23o_tvalid),
	.writedata_mgmt_0(bram_wrdata_0),
	.writeaddr_mgmt_0(bram_addr_0[14:2]),
	.we_mgmt_0(bram_we_0),
	.writedata_mgmt_1(bram_wrdata_1),
	.writeaddr_mgmt_1(bram_addr_1[5:2]),
	.we_mgmt_1(w_towemgmt1),
	.writedata_mgmt_2(bram_wrdata_1),
	.writeaddr_mgmt_2(bram_addr_1[5:2]),
	.we_mgmt_2(w_towemgmt2));

//Use MSB of bram_addr_1 as chipselect for write operation
assign w_towemgmt1 = !bram_addr_1[6] && bram_we_1;
assign w_towemgmt2 = bram_addr_1[6] && bram_we_1;

endmodule
