`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: L23_buffer_msim_tb
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
module L23_buffer_msim_tb;

//Inputs
reg clk;
reg rst;

reg [7:0] L23i_tdata;
reg L23i_tlast;
reg L23i_tuser;
reg L23i_tvalid;
reg L23o_tready;

reg [8:0] writedata_mgmt_0;
reg [12:0] writeaddr_mgmt_0;
reg we_mgmt_0;
reg [15:0] writedata_mgmt_1;
reg [3:0] writeaddr_mgmt_1;
reg we_mgmt_1;
reg [15:0] writedata_mgmt_2;
reg [3:0] writeaddr_mgmt_2;
reg we_mgmt_2;

//Outputs
wire L23i_tready;
wire [7:0] L23o_tdata;
wire L23o_tlast;
wire L23o_tvalid;

//Arrays and expected numbers of processed data
//MicroCodeArray SourceFileFormat: 28'hV_AAA_C_DD (vlan_offset_micrdatabit_micrdatavalue)
//MicroCodeArray BitsBrakedown: {[27:24][20:12]} - MicroCodeRam 13bit address (V_AAA), [8] - microcode_data_bit (C), [7:0] - microcode_data_value (DD);
reg [27:0] MicroCodeArray [0:100];
//RegDataArray SourceFileFormat: 36'hV_LLLL_CCCC (vlan_lenght_checksum)
//RegDataArray BitsBreakdown: [35:32] - 4bit regs address based on vlan (V), [31:16] - L3_HDR_LENGTH value (LLLL), [15:0] - IPv4 checksum value (CCCC);
reg [35:0] RegDataArray [0:100];
//SrcDataArray SourceFileFormat: 12'hB_DD (tusertlastbits_streamdata)
//SrcDataArray BitsBrakedown: [9]-tuser(B), [8]-tlast(B), [7:0]-tdata(DD);
reg [11:0] SrcDataArray [0:100];
//DstArray bits:[8]-tlast, [7:0]-tdata;
reg [8:0] DstDataArray [0:100];


localparam numofvlans = 4;
localparam headerlength = 16;
localparam REPLOOP = 200;

integer MicroCodeArrayPtr = 0;
integer RegDataArrayPtr = 0;
integer SrcDataArrayPtr = 0;
integer DstDataArrayPtr = 0;
integer mcodelength = numofvlans * headerlength;

//Instantiate DUT
L23_buffer U1 (.L23_clk(clk), .L23_rst(rst),
	.L23i_tdata(L23i_tdata),
	.L23i_tlast(L23i_tlast),
	.L23i_tuser(L23i_tuser),
	.L23i_tready(L23i_tready),
	.L23i_tvalid(L23i_tvalid),
	.L23o_tdata(L23o_tdata),
	.L23o_tlast(L23o_tlast),
	.L23o_tready(L23o_tready),
	.L23o_tvalid(L23o_tvalid),
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
initial begin
	clk = 1'b0;
forever #10 clk = ~clk;
	end

//Initial values
initial begin
    clk = 1'b0;
    rst = 1'b0;
    L23i_tdata = 8'b00000000;
    L23i_tlast = 1'b0;
    L23i_tuser = 1'b0;
    L23i_tvalid = 1'b0;
    L23o_tready = 1'b0;

	writedata_mgmt_0 = 9'b000000000;
	writeaddr_mgmt_0 = 13'b0000000000000;
	we_mgmt_0 = 1'b0;
	writedata_mgmt_1 = 16'b0000000000000000;
	writeaddr_mgmt_1 = 4'b0000;
	we_mgmt_1 = 1'b0;
	writedata_mgmt_2 = 16'b0000000000000000;
	writeaddr_mgmt_2 = 4'b0000;
	we_mgmt_2 = 1'b0;	
	
	$readmemh("testbench/headermicrocode.txt", MicroCodeArray);
	$readmemh("testbench/headerregisters.txt", RegDataArray);
	$readmemh("testbench/inputdatastream.txt", SrcDataArray);

end


initial begin	
//Reset the circuit
@(negedge clk);
        rst = 1'b1;
@(negedge clk);
        rst = 1'b0;
@(negedge clk);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//+++++++++++++++++++++PROGRAMMING HEADER MICROCODE RAM+++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
while (MicroCodeArrayPtr < mcodelength)
	begin
	@(negedge clk);
	//Set value to write in memory on next posedge
	writedata_mgmt_0 = MicroCodeArray[MicroCodeArrayPtr][8:0];
	writeaddr_mgmt_0 = {MicroCodeArray[MicroCodeArrayPtr][27:24], MicroCodeArray[MicroCodeArrayPtr][20:12]};
	we_mgmt_0 = 1'b1;
	MicroCodeArrayPtr = MicroCodeArrayPtr + 1;
end
	
@(negedge clk);
//ALL SIGNALS ZERO
	writedata_mgmt_0 = 9'b000000000;
	writeaddr_mgmt_0 = 13'b0000000000000;
	we_mgmt_0 = 1'b0;
@(negedge clk);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//+++++++++++++++++++++PROGRAMMING OTHER REGISTERS++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
while (RegDataArrayPtr < numofvlans)
	begin
	@(negedge clk);
	//Set value to write in memory on next posedge
	writedata_mgmt_1 = RegDataArray[RegDataArrayPtr][31:16];
	writeaddr_mgmt_1 = RegDataArray[RegDataArrayPtr][35:32];
	we_mgmt_1 = 1'b1;
	writedata_mgmt_2 = RegDataArray[RegDataArrayPtr][15:0];
	writeaddr_mgmt_2 = RegDataArray[RegDataArrayPtr][35:32];
	we_mgmt_2 = 1'b1;
	RegDataArrayPtr = RegDataArrayPtr + 1;
end
	
@(negedge clk);
//ALL SIGNALS ZERO
	writedata_mgmt_1 = 16'b0000000000000000;
	writeaddr_mgmt_1 = 4'b0000;
	we_mgmt_1 = 1'b0;
	writedata_mgmt_2 = 16'b0000000000000000;
	writeaddr_mgmt_2 = 4'b0000;
	we_mgmt_2 = 1'b0;
@(negedge clk);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//+++++++++++++++++++++PROCESSING DATA STREAM+++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//create two parallel processes		
    fork
    begin
	  //negedge process
	  	repeat (REPLOOP)
		begin
        @(negedge clk);
//Assert input port values
        L23i_tdata = SrcDataArray[SrcDataArrayPtr][7:0];
        L23i_tlast = SrcDataArray[SrcDataArrayPtr][8];
        L23i_tuser = SrcDataArray[SrcDataArrayPtr][9];
        L23i_tvalid = {$random} % 2;
//Assert output port values
		L23o_tready = {$random} % 2;
		end
	  $display("@%g Finished negedge process loop", $realtime);
    end
	  
    begin 
	  //posedge process
	  	repeat (REPLOOP)
		begin
        @(posedge clk);
       if (L23i_tvalid & L23i_tready) begin
                $display("@%g INPUT: L23i_tvalid:%h; L23i_tready:%h; L23i_tdata:%h; L23i_tlast:%h; L23i_tuser:%h;", $realtime, L23i_tvalid, L23i_tready, L23i_tdata, L23i_tlast, L23i_tuser);
                SrcDataArrayPtr = SrcDataArrayPtr + 1;  
                                      end         
       if (L23o_tvalid & L23o_tready) begin
                $display("@%g OUTPUT: L23o_tvalid:%h; L23o_tready:%h; L23o_tdata:%h; L23o_tlast:%h;", $realtime, L23o_tvalid, L23o_tready, L23o_tdata, L23o_tlast);
                DstDataArray[DstDataArrayPtr] = {L23o_tlast, L23o_tdata};
                DstDataArrayPtr = DstDataArrayPtr + 1;
                                      end		
		end
	  $display("@%g Finished posedge process loop", $realtime);
	end
    join

//Finish after some ticks...
	@(negedge clk);
	@(negedge clk);
    $finish;

end

endmodule
