`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: flags_gen_tb
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
///////////////////////Testbench output information///////////////////////////////
//
// "flags_gen" module testbench
//	EXPECTED OUTPUTS
//	wr_greenflag(~FULL)		1	0	1	0	1	0	1
//	rd_greenflag_0(~EMPTY0)	0	1	1	0	0	1	1
//	rd_greenflag_1(~EMPTY1)	0	0	0	1	1	1	1
//
//	Comments:
//	Common ~FULL signal is 1 only if both block0 and block1 ~FULLs (implicit signals) are 1
//////////////////////////////////////////////////////////////////////////////////
module flags_gen_tb;


//Internal signals declarations:
reg [2:0]wr_ptr_tribit;
reg [2:0]rd_ptr_tribit_1;
reg [2:0]rd_ptr_tribit_0;
wire wr_greenflag;
wire rd_greenflag_1;
wire rd_greenflag_0;



// Unit Under Test port map
	flags_gen U1 (.wr_ptr_tribit(wr_ptr_tribit), .rd_ptr_tribit_1(rd_ptr_tribit_1), .rd_ptr_tribit_0(rd_ptr_tribit_0), .wr_greenflag(wr_greenflag), .rd_greenflag_1(rd_greenflag_1), .rd_greenflag_0(rd_greenflag_0));

initial begin
wr_ptr_tribit = 3'b000;
rd_ptr_tribit_0 = 3'b000;
rd_ptr_tribit_1 = 3'b000;

#20
wr_ptr_tribit = 3'b001;
rd_ptr_tribit_0 = 3'b101;
rd_ptr_tribit_1 = 3'b001;

#20
wr_ptr_tribit = 3'b011;
rd_ptr_tribit_0 = 3'b110;
rd_ptr_tribit_1 = 3'b011;

#20
wr_ptr_tribit = 3'b101;
rd_ptr_tribit_0 = 3'b101;
rd_ptr_tribit_1 = 3'b001;

#20
wr_ptr_tribit = 3'b110;
rd_ptr_tribit_0 = 3'b110;
rd_ptr_tribit_1 = 3'b001;

#20
wr_ptr_tribit = 3'b111;
rd_ptr_tribit_0 = 3'b011;
rd_ptr_tribit_1 = 3'b010;

#20
wr_ptr_tribit = 3'b000;
rd_ptr_tribit_0 = 3'b101;
rd_ptr_tribit_1 = 3'b011;

#20
$finish;
end

endmodule