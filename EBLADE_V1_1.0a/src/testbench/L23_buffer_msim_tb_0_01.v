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
// Version: 0.01
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

//Outputs
wire L23i_tready;
wire [7:0] L23o_tdata;
wire L23o_tlast;
wire L23o_tvalid;

//Local variables
localparam REPLOOP = 100;
//SrcArray bits:[9]-tuser, [8]-tlast, [7:0]-tdata;
reg [9:0] SrcArray [0:30];
//DstArray bits:[8]-tlast, [7:0]-tdata;
reg [8:0] DstArray [0:30];
integer SrcArrayPtr = 0;
integer DstArrayPtr = 0;

//Instantiate DUT
L23_buffer U1 (clk, rst, L23i_tdata, L23i_tlast, L23i_tuser, L23i_tready, L23i_tvalid, L23o_tdata, L23o_tlast, L23o_tready, L23o_tvalid);

//Create clock
always #10 clk = ~clk;

//Initial values
initial begin
    clk = 1'b0;
    rst = 1'b0;
    L23i_tdata = 8'b00000000;
    L23i_tlast = 1'b0;
    L23i_tuser = 1'b0;
    L23i_tvalid = 1'b0;
    L23o_tready = 1'b0;
    
    SrcArray[0] = 10'h011;
    SrcArray[1] = 10'h012;
    SrcArray[2] = 10'h013;
    SrcArray[3] = 10'h014;
    SrcArray[4] = 10'h015;
    SrcArray[5] = 10'h016;
    SrcArray[6] = 10'h117;
    SrcArray[7] = 10'h021;
    SrcArray[8] = 10'h022;
    SrcArray[9] = 10'h023;
    SrcArray[10] = 10'h024;
    SrcArray[11] = 10'h025;
    SrcArray[12] = 10'h026;
    SrcArray[13] = 10'h027;
    SrcArray[14] = 10'h128;
    SrcArray[15] = 10'h031;
    SrcArray[16] = 10'h032;
    SrcArray[17] = 10'h033;
    SrcArray[18] = 10'h034;
    SrcArray[19] = 10'h035;
    SrcArray[20] = 10'h036;
    SrcArray[21] = 10'h337;
    SrcArray[22] = 10'h041;
    SrcArray[23] = 10'h042;
    SrcArray[24] = 10'h043;
    SrcArray[25] = 10'h044;
    SrcArray[26] = 10'h045;
    SrcArray[27] = 10'h046;
    SrcArray[28] = 10'h047;
    SrcArray[29] = 10'h048;
    SrcArray[30] = 10'h149;
end


initial begin	
//Reset the circuit
@(negedge clk);
        rst = 1'b1;
@(negedge clk);
        rst = 1'b0;

//create two parallel processes		
    fork
    begin
	  //negedge process (assert stimulus)
        repeat (REPLOOP) 
		begin
        @(negedge clk);
//Assert input port values
        L23i_tdata = SrcArray[SrcArrayPtr][7:0];
        L23i_tlast = SrcArray[SrcArrayPtr][8];
        L23i_tuser = SrcArray[SrcArrayPtr][9];
        L23i_tvalid = {$random} % 2;  
//Assert output port values
        L23o_tready = {$random} % 2;
		end
	  $display("@%g Finished negedge process loop", $realtime);
    end
	  
    begin 
	  //posedge process (process logic)
	    repeat (REPLOOP)
		begin
        @(posedge clk);
       if (L23i_tvalid & L23i_tready) begin
                $display("@%g INPUT: L23i_tvalid:%h; L23i_tready:%h; L23i_tdata:%h; L23i_tlast:%h; L23i_tuser:%h;", $realtime, L23i_tvalid, L23i_tready, L23i_tdata, L23i_tlast, L23i_tuser);
                SrcArrayPtr = SrcArrayPtr + 1;  
                                      end         
       if (L23o_tvalid & L23o_tready) begin
                $display("@%g OUTPUT: L23o_tvalid:%h; L23o_tready:%h; L23o_tdata:%h; L23o_tlast:%h;", $realtime, L23o_tvalid, L23o_tready, L23o_tdata, L23o_tlast);
                DstArray[DstArrayPtr] = {L23o_tlast, L23o_tdata};
                DstArrayPtr = DstArrayPtr + 1;
                                      end		
		end
	  $display("@%g Finished posedge process loop", $realtime);
	end
    join		
		
//Finish after some ticks...
    @(negedge clk);
    $finish;

end

endmodule
