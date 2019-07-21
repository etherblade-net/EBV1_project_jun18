`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: L23_buffer_tb
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
module L23_buffer_tb;

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
reg [9:0] SrcArray [0:30] = {10'h011,10'h012,10'h013,10'h014,10'h015,10'h016,10'h117,10'h021,10'h022,10'h023,10'h024,10'h025,10'h026,10'h027,10'h128,10'h031,10'h032,10'h033,10'h034,10'h035,10'h036,10'h337,10'h041,10'h042,10'h043,10'h044,10'h045,10'h046,10'h047,10'h048,10'h149};
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
    clk = 0;
    rst = 0;
    L23i_tdata = 8'b00000000;
    L23i_tlast = 0;
    L23i_tuser = 0;
    L23i_tvalid = 0;
    L23o_tready = 0;
end


initial begin	
//Reset the circuit
@(negedge clk);
        rst = 1;
@(negedge clk);
        rst = 0;

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
	  $display("@%g Finished negedge process loop", $time);
    end
	  
    begin 
	  //posedge process (process logic)
	    repeat (REPLOOP)
		begin
        @(posedge clk);
       if (L23i_tvalid & L23i_tready) begin
                $display("@%g INPUT: L23i_tvalid:%h; L23i_tready:%h; L23i_tdata:%h; L23i_tlast:%h; L23i_tuser:%h;", $time, L23i_tvalid, L23i_tready, L23i_tdata, L23i_tlast, L23i_tuser);
                SrcArrayPtr = SrcArrayPtr + 1;  
                                      end         
       if (L23o_tvalid & L23o_tready) begin
                $display("@%g OUTPUT: L23o_tvalid:%h; L23o_tready:%h; L23o_tdata:%h; L23o_tlast:%h;", $time, L23o_tvalid, L23o_tready, L23o_tdata, L23o_tlast);
                DstArray[DstArrayPtr] = {L23o_tlast, L23o_tdata};
                DstArrayPtr = DstArrayPtr + 1;
                                      end		
		end
	  $display("@%g Finished posedge process loop", $time);
	end
    join		
		
//Finish after some ticks...
    @(negedge clk);
    $finish;

end

endmodule
