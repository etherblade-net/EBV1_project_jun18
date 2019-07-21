`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: dual_port_asyncout_ram
// Project Name: EtherBlade.net_v1 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Version: 0.01
// Additional Comments:
// Distributed Simple Dual port RAM, async read
//////////////////////////////////////////////////////////////////////////////////
module dual_port_asyncout_ram #(parameter D_WIDTH = 11, parameter A_WIDTH = 2)
(
    input clk,
    input we,
    input [(D_WIDTH-1):0] data,
    input [(A_WIDTH-1):0] read_addr, write_addr,
    output [(D_WIDTH-1):0] q
);

 reg [D_WIDTH-1:0] ram[2**A_WIDTH-1:0];

 always @ (posedge clk)
    begin
       if (we)
        ram[write_addr] <= data;
    end
assign q = ram[read_addr];
endmodule

