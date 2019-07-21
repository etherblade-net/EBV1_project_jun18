`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: headgen_out_mux
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
module headgen_out_mux (
input [8:0] in_0,
input [15:0] in_1,
input [15:0] in_2,
output [7:0] out_0
);

wire [7:0] to_dyndata_in_0;
wire [7:0] to_dyndata_in_1;
wire [7:0] to_dyndata_in_2;
wire [7:0] to_dyndata_in_3;

//Split incoming 16bit inputs into two 8bits accepted by the "headgen_out_mux_core" module
assign {to_dyndata_in_0, to_dyndata_in_1} = in_1;
assign {to_dyndata_in_2, to_dyndata_in_3} = in_2;

//"Headgen_out_mux_core" module instantiation
headgen_out_mux_core HEADGEN_OUT_MUX_CORE1(
	.microcode_in(in_0), 
	.dyndata_in_0(to_dyndata_in_0), 
	.dyndata_in_1(to_dyndata_in_1), 
	.dyndata_in_2(to_dyndata_in_2), 
	.dyndata_in_3(to_dyndata_in_3), 
	.out_data(out_0));

endmodule
