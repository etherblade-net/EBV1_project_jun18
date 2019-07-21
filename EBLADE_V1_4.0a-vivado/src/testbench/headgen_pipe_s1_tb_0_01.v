`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: headgen_pipe_s1_tb
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
module headgen_pipe_s1_tb;


//Internal signals declarations:
reg clk;
reg rst;
reg [12:0]in_0;
reg [15:0]in_1;
wire [8:0]out_0;
wire [15:0]out_1;
wire [15:0]out_2;
wire [15:0]out_3;
reg enableout;
reg [8:0]writedata_mgmt_0;
reg [12:0]writeaddr_mgmt_0;
reg we_mgmt_0;
reg [15:0]writedata_mgmt_1;
reg [3:0]writeaddr_mgmt_1;
reg we_mgmt_1;
reg [15:0]writedata_mgmt_2;
reg [3:0]writeaddr_mgmt_2;
reg we_mgmt_2;

localparam REPLOOP = 256;
integer loopvlan = 0;
integer i = 0;

// Unit Under Test port map
	headgen_pipe_s1 UUT (
		.clk(clk),
		.rst(rst),
		.in_0(in_0),
		.in_1(in_1),
		.out_0(out_0),
		.out_1(out_1),
		.out_2(out_2),
		.out_3(out_3),
		.enableout(enableout),
		.writedata_mgmt_0(writedata_mgmt_0),
		.writeaddr_mgmt_0(writeaddr_mgmt_0),
		.we_mgmt_0(we_mgmt_0),
		.writedata_mgmt_1(writedata_mgmt_1),
		.writeaddr_mgmt_1(writeaddr_mgmt_1),
		.we_mgmt_1(we_mgmt_1),
		.writedata_mgmt_2(writedata_mgmt_2),
		.writeaddr_mgmt_2(writeaddr_mgmt_2),
		.we_mgmt_2(we_mgmt_2));

//Create clock
always #10 clk = ~clk;		
		
//Initial values
initial begin
    clk = 1'b0;
    rst = 1'b0;
	in_0 = 13'b0000000000000;
	in_1 = 16'b0000000000000000;
	enableout = 1'b0;
	writedata_mgmt_0 = 9'b000000000;
	writeaddr_mgmt_0 = 13'b0000000000000;
	we_mgmt_0 = 1'b0;
	writedata_mgmt_1 = 16'b0000000000000000;
	writeaddr_mgmt_1 = 4'b0000;
	we_mgmt_1 = 1'b0;
	writedata_mgmt_2 = 16'b0000000000000000;
	writeaddr_mgmt_2 = 4'b0000;
	we_mgmt_2 = 1'b0;
end

initial begin	
//Reset the circuit
@(negedge clk);
        rst = 1'b1;
@(negedge clk);
        rst = 1'b0;

//Begin programing ram blocks
for (loopvlan=0; loopvlan<16; loopvlan=loopvlan+1)
	begin
//WRITE DEFAULT MICROCODE DATA
for (i=0; i<16; i=i+1)
	begin
@(negedge clk);
writedata_mgmt_0 = {1'b0, loopvlan[3:0], i[3:0]};
writeaddr_mgmt_0 = {loopvlan[3:0], i[8:0]};
we_mgmt_0 = 1'b1;
	end
//WRITE DEFAULT REGISTERS DATA (l3_hdr_length, precalc_ipv4_inv_csum)
@(negedge clk);
we_mgmt_0 = 1'b0;
writedata_mgmt_1 = {loopvlan[3:0], loopvlan[3:0], loopvlan[3:0], loopvlan[3:0]};
writeaddr_mgmt_1 = loopvlan[3:0];
we_mgmt_1 = 1'b1;
//precalc_ipv4_inv_csum
writedata_mgmt_2 = {4'b1111, loopvlan[3:0], loopvlan[3:0], 4'b1111};
writeaddr_mgmt_2 = loopvlan[3:0];
we_mgmt_2 = 1'b1;
//Clear write flags
@(negedge clk);
we_mgmt_1 = 1'b0;
we_mgmt_2 = 1'b0;
end
//End programing ram blocks

//BEGIN Custom modification of ram
//======
//======
//======
//END Custom modification of ram

//Start reading data
//create two parallel processes		
    fork
    begin
	  //negedge process (assert stimulus)
	  for (loopvlan=0; loopvlan<16; loopvlan=loopvlan+1)
		begin
		//WRITE DEFAULT MICROCODE DATA
		for (i=0; i<16; i=i+1)
		begin
		@(negedge clk);
		//Assert input port values
			in_0 = {loopvlan[3:0], i[8:0]};
			in_1 = {loopvlan[3:0], i[3:0], loopvlan[3:0], i[3:0]};
			enableout = 1'b1;
		end
		end
	  $display("@%g Finished negedge process loop", $realtime);
    end
	begin 
	  //posedge process (process logic)
	    repeat (REPLOOP)
		begin
        @(posedge clk);
				$display("@%g INPUT: in_0:%h; in_1:%h;", $realtime, in_0, in_1);
				$display("@%g OUTPUT: out_0:%h; out_1:%h; out_2:%h; out_3:%h;", $realtime, out_0, out_1, out_2, out_3);
        end
	  $display("@%g Finished posedge process loop", $realtime);
	end
    join	

	//Finish after some ticks...
    @(negedge clk);
    $finish;		
end

endmodule
