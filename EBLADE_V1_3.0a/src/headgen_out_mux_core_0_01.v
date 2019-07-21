`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: headgen_out_mux_core
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
module headgen_out_mux_core (
input [8:0] microcode_in,
input [7:0] dyndata_in_0,
input [7:0] dyndata_in_1,
input [7:0] dyndata_in_2,
input [7:0] dyndata_in_3,
output [7:0] out_data
);

wire [7:0] microcodestaticdata;
wire [1:0] dyndata_sel;
wire final_sel;
reg [7:0] dyndata_out;

//Isolating final selector bit from input microcode
assign {final_sel, microcodestaticdata} = microcode_in;


//Isolating bits necessary for selection of relevant dynamic source
assign dyndata_sel = microcodestaticdata[1:0];

//MUX for selecting relevant dynamic data input
    always @(dyndata_sel, dyndata_in_0, dyndata_in_1, dyndata_in_2, dyndata_in_3) 
    begin 
        case (dyndata_sel)
            2'b00: dyndata_out = dyndata_in_0;   
            2'b01: dyndata_out = dyndata_in_1;
            2'b10: dyndata_out = dyndata_in_2;    
            2'b11: dyndata_out = dyndata_in_3;     
        endcase
    end


//Final MUX for selecting final output data choosing between static data embedded in input microcode or dynamic data sources "dyndata_out"
assign out_data = (final_sel) ? dyndata_out : microcodestaticdata;

endmodule
