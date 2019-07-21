`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: header_generator_pipeline
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
module header_generator_pipeline (
input clk,	//shared wire
input rst,	//shared wire
input [12:0] read_addr,
input [15:0] body_length,
output [7:0] q,
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

wire [8:0] w_hadgen_pipe_s1_out_0;
wire [15:0] w_hadgen_pipe_s1_out_1;
wire [15:0] w_hadgen_pipe_s1_out_2;
wire [15:0] w_hadgen_pipe_s1_out_3;
wire [8:0] w_hadgen_pipe_s2_out_0;
wire [15:0] w_hadgen_pipe_s2_out_1;
wire [15:0] w_hadgen_pipe_s2_out_2;
wire [8:0] w_hadgen_pipe_s3_out_0;
wire [15:0] w_hadgen_pipe_s3_out_1;
wire [15:0] w_hadgen_pipe_s3_out_2;


//Modules instantiation
headgen_pipe_s1 HEADGENPIPES1_1 (.clk(clk), .rst(rst),
	.in_0(read_addr),
	.in_1(body_length),
	.out_0(w_hadgen_pipe_s1_out_0),
	.out_1(w_hadgen_pipe_s1_out_1),
	.out_2(w_hadgen_pipe_s1_out_2),
	.out_3(w_hadgen_pipe_s1_out_3),
	.enableout(enableout),
	.writedata_mgmt_0(writedata_mgmt_0),
	.writeaddr_mgmt_0(writeaddr_mgmt_0),
	.we_mgmt_0(we_mgmt_0),
	.writedata_mgmt_1(writedata_mgmt_1),
	.writeaddr_mgmt_1(writeaddr_mgmt_1),
	.we_mgmt_1(we_mgmt_1),
	.writedata_mgmt_2(writedata_mgmt_2),
	.writeaddr_mgmt_2(writeaddr_mgmt_2),
	.we_mgmt_2(we_mgmt_2)
);

headgen_pipe_s2 HEADGENPIPES2_1 (.clk(clk), .rst(rst),
	.in_0(w_hadgen_pipe_s1_out_0),
	.in_1(w_hadgen_pipe_s1_out_1),
	.in_2(w_hadgen_pipe_s1_out_2),
	.in_3(w_hadgen_pipe_s1_out_3),
	.out_0(w_hadgen_pipe_s2_out_0),
	.out_1(w_hadgen_pipe_s2_out_1),
	.out_2(w_hadgen_pipe_s2_out_2),
	.enableout(enableout)
);

headgen_pipe_s3 HEADGENPIPES3_1 (.clk(clk), .rst(rst),
	.in_0(w_hadgen_pipe_s2_out_0),
	.in_1(w_hadgen_pipe_s2_out_1),
	.in_2(w_hadgen_pipe_s2_out_2),
	.out_0(w_hadgen_pipe_s3_out_0),
	.out_1(w_hadgen_pipe_s3_out_1),
	.out_2(w_hadgen_pipe_s3_out_2),
	.enableout(enableout)
);

headgen_out_mux HEADGENOUTMUX1 (
	.in_0(w_hadgen_pipe_s3_out_0),
	.in_1(w_hadgen_pipe_s3_out_1),
	.in_2(w_hadgen_pipe_s3_out_2),
	.out_0(q)
);

endmodule
