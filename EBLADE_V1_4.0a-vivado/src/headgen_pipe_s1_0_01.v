`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: headgen_pipe_s1
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
module headgen_pipe_s1 (
input clk,	//shared wire
input rst,	//shared wire
input [12:0] in_0,
input [15:0] in_1,
output [8:0] out_0,
output reg [15:0] out_1,
output [15:0] out_2,
output [15:0] out_3,
input enableout,
input [8:0] writedata_mgmt_0,
input [12:0] writeaddr_mgmt_0,
input we_mgmt_0,
input [15:0] writedata_mgmt_1,
input [3:0] writeaddr_mgmt_1,
input we_mgmt_1,
input [15:0] writedata_mgmt_2,
input [3:0] writeaddr_mgmt_2,
input we_mgmt_2
);

wire [3:0] read_addr_vlan;

//Separate "read_addr_vlan" from "in_0"
assign read_addr_vlan = in_0[12:9];

// Implement (out_1) BODY_LENGTH register
	always @(posedge clk)                                                                  
	begin                                                                                          
	  if (rst)                                                                         
	    begin                                                                                      
	      out_1 <= 16'b0;                                                               
	    end                                                                                        
	  else if (enableout)                                                                                         
	    begin                                                                                      
	      out_1 <= in_1;               
	    end
//NOTE: If (~enableout) then (out_1) remain unchanged.
	end         	

//RAM modules instantiation 
dual_port_syncout_enabled_ram #(.D_WIDTH(9), .A_WIDTH(13)) HEADER_DATA_MICROCODE0(.clk(clk), .rst(rst), 
	.enableout(enableout), 
	.we(we_mgmt_0), 
	.data(writedata_mgmt_0), 
	.read_addr(in_0), 
	.write_addr(writeaddr_mgmt_0), 
	.q(out_0));

dual_port_syncout_enabled_ram #(.D_WIDTH(16), .A_WIDTH(4)) L3_HDR_LENGTH0(.clk(clk), .rst(rst), 
	.enableout(enableout), 
	.we(we_mgmt_1), 
	.data(writedata_mgmt_1), 
	.read_addr(read_addr_vlan), 
	.write_addr(writeaddr_mgmt_1), 
	.q(out_2));

dual_port_syncout_enabled_ram #(.D_WIDTH(16), .A_WIDTH(4)) PRECALC_IPV4_INV_CHSUM0(.clk(clk), .rst(rst), 
	.enableout(enableout), 
	.we(we_mgmt_2), 
	.data(writedata_mgmt_2), 
	.read_addr(read_addr_vlan), 
	.write_addr(writeaddr_mgmt_2), 
	.q(out_3));

endmodule
