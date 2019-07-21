`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: storage_wrapper
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
module storage_wrapper (
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
output o_tlast
);

//Drive pipeline logic wire
wire drive_pipeline;

//wire name is specifyed as "w_(module name)_(outputinterface_of_the_module)"
wire w_readbuf_fsm_storage_rd_newline;
wire w_readbuf_fsm_storage_rd_char_incr;
wire w_read_logic_storage_tlast_flag;
wire [12:0] w_read_logic_storage_rd_ptr;

//Drive pipleine logic
assign drive_pipeline = !(o_tvalid && !o_tready);

//Modules instantiations
readbuf_fsm_onedelay READBUF_FSM_STORAGE1(.clk(clk), .rst(rst), .greenflag(greenflag), .lastflag(w_read_logic_storage_tlast_flag), .tready(drive_pipeline), .tvalid(o_tvalid), .tlast(o_tlast), .rd_newline(w_readbuf_fsm_storage_rd_newline), .rd_char_incr(w_readbuf_fsm_storage_rd_char_incr));

read_logic_storage READ_LOGIC_STORAGE1(.clk(clk), .rst(rst), .rd_char_incr(w_readbuf_fsm_storage_rd_char_incr), .rd_newline(w_readbuf_fsm_storage_rd_newline), .tlastarray_cs_rgs(i_tlast), .we_rgs(wren), .wr_ptr_rgs(wr_ptr), .tlast_flag(w_read_logic_storage_tlast_flag), .rd_ptr(w_read_logic_storage_rd_ptr), .rd_ptr_tribit(rd_ptr_tribit));

dual_port_syncout_enabled_ram #(.D_WIDTH(8), .A_WIDTH(13)) DUAL_PORT_SYNCOUT_ENABLED_RAM1(.clk(clk), .rst(rst), .enableout(drive_pipeline), .we(wren), .data(i_tdata), .read_addr(w_read_logic_storage_rd_ptr), .write_addr(wr_ptr), .q(o_tdata));

endmodule
