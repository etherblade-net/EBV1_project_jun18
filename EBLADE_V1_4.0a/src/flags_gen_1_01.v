`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: flags_gen
// Project Name: EtherBlade.net_v1 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Version: 1.01
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module flags_gen (
input [2:0] wr_ptr_tribit,
input [2:0] rd_ptr_tribit_1,
input [2:0] rd_ptr_tribit_0,
output wr_greenflag,
output rd_greenflag_1,
output rd_greenflag_0
);

//"wr_greenflag" aka "not_full"
assign wr_greenflag = (((wr_ptr_tribit[2] != rd_ptr_tribit_1[2]) && 
(wr_ptr_tribit[1:0] == rd_ptr_tribit_1[1:0])) || 
((wr_ptr_tribit[2] != rd_ptr_tribit_0[2]) && 
(wr_ptr_tribit[1:0] == rd_ptr_tribit_0[1:0]))) ? 1'b0 : 1'b1;

//"rd_greenflag_1" aka "not_empty"
assign rd_greenflag_1 = ((wr_ptr_tribit[2] == rd_ptr_tribit_1[2]) && 
(wr_ptr_tribit[1:0] == rd_ptr_tribit_1[1:0])) ? 1'b0 : 1'b1;

//"rd_greenflag_0" aka "not_empty"
assign rd_greenflag_0 = ((wr_ptr_tribit[2] == rd_ptr_tribit_0[2]) && 
(wr_ptr_tribit[1:0] == rd_ptr_tribit_0[1:0])) ? 1'b0 : 1'b1;

endmodule
