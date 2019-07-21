`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: write_wrapper
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
module write_wrapper (
input clk,		//shared wire
input rst,		//shared wire
input i_tvalid,
input i_tuser,
input i_tlast,
output i_tready,
output [12:0] wr_ptr,
output [2:0] wr_ptr_tribit,
output wren,
input greenflag
);

//wire name is specifyed as "w_(module name)_(outputinterface_of_the_module)"
wire w_writebuf_fsm_wr_char_incr;
wire w_writebuf_fsm_wr_newline;
wire w_writebuf_fsm_wr_restart_line;

//Modules instantiations
writebuf_fsm WRITEBUF_FSM1(.clk(clk), .rst(rst), 
	.greenflag(greenflag), 
	.tvalid(i_tvalid), 
	.tlast(i_tlast), 
	.tuser(i_tuser), 
	.tready(i_tready), 
	.wren(wren), 
	.wr_newline(w_writebuf_fsm_wr_newline), 
	.wr_char_incr(w_writebuf_fsm_wr_char_incr), 
	.wr_restart_line(w_writebuf_fsm_wr_restart_line));

write_logic WRITE_LOGIC1(.clk(clk), .rst(rst), 
	.wr_newline(w_writebuf_fsm_wr_newline), 
	.wr_restart_line(w_writebuf_fsm_wr_restart_line), 
	.wr_char_incr(w_writebuf_fsm_wr_char_incr), 
	.wr_ptr_tribit(wr_ptr_tribit), 
	.wr_ptr(wr_ptr));

endmodule

