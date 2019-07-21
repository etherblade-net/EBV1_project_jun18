`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: L23_buffer
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
module L23_buffer (
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
output L23o_tvalid
);

//wire name is specifyed as "w_(module name)_(outputinterface_of_the_module)"

wire w_write_wrapper_wren;

wire w_flags_gen_rd_greenflag_1;
wire w_flags_gen_wr_greenflag;

wire [12:0] w_write_wrapper_wr_ptr;
wire [2:0] w_write_wrapper_wr_ptr_tribit;
wire [2:0] w_storage_wrapper_rd_ptr_tribit;


//Modules instantiations


flags_gen FLAGS_GEN1(.wr_ptr_tribit(w_write_wrapper_wr_ptr_tribit), .rd_ptr_tribit_1(w_storage_wrapper_rd_ptr_tribit), .wr_greenflag(w_flags_gen_wr_greenflag), .rd_greenflag_1(w_flags_gen_rd_greenflag_1));

write_wrapper WRITE_WRAPPER1(.clk(L23_clk), .rst(L23_rst), .i_tvalid(L23i_tvalid), .i_tuser(L23i_tuser), .i_tlast(L23i_tlast), .i_tready(L23i_tready), .wr_ptr(w_write_wrapper_wr_ptr), .wr_ptr_tribit(w_write_wrapper_wr_ptr_tribit), .wren(w_write_wrapper_wren), .greenflag(w_flags_gen_wr_greenflag));

storage_wrapper STORAGE_WRAPPER1(.clk(L23_clk), .rst(L23_rst), .i_tdata(L23i_tdata), .i_tlast(L23i_tlast), .wren(w_write_wrapper_wren), .wr_ptr(w_write_wrapper_wr_ptr), .rd_ptr_tribit(w_storage_wrapper_rd_ptr_tribit), .greenflag(w_flags_gen_rd_greenflag_1), .o_tdata(L23o_tdata), .o_tready(L23o_tready), .o_tvalid(L23o_tvalid), .o_tlast(L23o_tlast));

endmodule

