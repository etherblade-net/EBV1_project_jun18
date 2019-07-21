`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: headgen_pipe_s3_tb
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
module headgen_pipe_s3_tb;


//Internal signals declarations:
reg clk;
reg rst;
reg [8:0]in_0;
reg [15:0]in_1;
reg [15:0]in_2;
wire [8:0]out_0;
wire [15:0]out_1;
wire [15:0]out_2;
reg enableout;



// Unit Under Test port map
	headgen_pipe_s3 UUT (
		.clk(clk),
		.rst(rst),
		.in_0(in_0),
		.in_1(in_1),
		.in_2(in_2),
		.out_0(out_0),
		.out_1(out_1),
		.out_2(out_2),
		.enableout(enableout));

//Create clock
always #10 clk = ~clk;		
		
//Initial values
initial begin
    clk = 1'b0;
    rst = 1'b0;
	in_0 = 9'b000000000;
	in_1 = 16'b0000000000000000;
	in_2 = 16'b0000000000000000;
	enableout = 1'b0;	
end

initial begin	
//Reset the circuit
@(negedge clk);
        rst = 1'b1;
@(negedge clk);
        rst = 1'b0;

@(negedge clk);
in_0 = 9'b101010101;
in_1 = 16'b0000000000000000;
in_2 = 16'b0000000000111111;
enableout = 1'b1;	

@(negedge clk);
in_0 = 9'b101010101;
in_1 = 16'b1111110000000000;
in_2 = 16'b0000000000111111;
enableout = 1'b1;	

@(negedge clk);
in_0 = 9'b000000000;
in_1 = 16'b1111111111111111;
in_2 = 16'b1111111111111111;
enableout = 1'b1;

//Set all signals to zero
@(negedge clk);
in_0 = 9'b000000000;
in_1 = 16'b0000000000000000;
in_2 = 16'b0000000000000000;
enableout = 1'b0;


//Finish after some ticks...
    @(negedge clk);
    $finish;	

end
		
endmodule