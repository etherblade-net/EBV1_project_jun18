`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: header_wrapper
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
module header_wrapper (
input clk,	//shared wire
input rst,	//shared wire
input [7:0] i_tdata,
input i_tlast,
input wren,
input [12:0] wr_ptr,
output [2:0] rd_ptr_tribit,
input greenflag,
output [7:0] o_tdata,
input o_tready,
output o_tvalid,
output o_tlast,

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

//Drive pipeline logic wire
wire drive_pipeline;

//wire name is specifyed as "w_(module name)_(outputinterface_of_the_module)"
wire w_readbuf_fsm_header_rd_newline;
wire w_readbuf_fsm_header_rd_char_incr;
wire w_read_logic_header_tlast_flag;
wire [12:0] w_read_logic_header_rd_ptr;
wire [15:0] w_read_logic_header_body_length;

//Drive pipleine logic
assign drive_pipeline = !(o_tvalid && !o_tready);

//Modules instantiations
readbuf_fsm_threedelay READBUF_FSM_HEADER1 (.clk(clk), .rst(rst),
	.greenflag(greenflag),
	.lastflag(w_read_logic_header_tlast_flag),
	.tready(drive_pipeline),
	.tvalid(o_tvalid),
	.tlast(o_tlast),
	.rd_newline(w_readbuf_fsm_header_rd_newline),
	.rd_char_incr(w_readbuf_fsm_header_rd_char_incr));
	
read_logic_header READ_LOGIC_HEADER1 (.clk(clk), .rst(rst),
	.rd_char_incr(w_readbuf_fsm_header_rd_char_incr),
	.rd_newline(w_readbuf_fsm_header_rd_newline),
	.tlastarray_cs_rgs(i_tlast),
	.we_rgs(wren),
	.wr_ptr_rgs(wr_ptr),
	.tdata_rgs(i_tdata),
	.tlast_flag(w_read_logic_header_tlast_flag),
	.rd_ptr(w_read_logic_header_rd_ptr),
	.rd_ptr_tribit(rd_ptr_tribit),
	.body_length(w_read_logic_header_body_length));
	
header_generator_pipeline HEADER_GENERATOR_PIPELINE1 (.clk(clk), .rst(rst),
	.read_addr(w_read_logic_header_rd_ptr),
	.body_length(w_read_logic_header_body_length),
	.q(o_tdata),
	.enableout(drive_pipeline),
	.writedata_mgmt_0(writedata_mgmt_0),
	.writeaddr_mgmt_0(writeaddr_mgmt_0),
	.we_mgmt_0(we_mgmt_0),
	.writedata_mgmt_1(writedata_mgmt_1),
	.writeaddr_mgmt_1(writeaddr_mgmt_1),
	.we_mgmt_1(we_mgmt_1),
	.writedata_mgmt_2(writedata_mgmt_2),
	.writeaddr_mgmt_2(writeaddr_mgmt_2),
	.we_mgmt_2(we_mgmt_2));

endmodule

