`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: readbuf_fsm_onedelay
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
module readbuf_fsm_onedelay(
input clk,				/*Clock*/
input rst,				/*Reset*/
input greenflag,		/*From CountersBlock*/
input lastflag,			/*From CountersBlock*/
input tready,			/*AXI-in*/   
output reg tvalid,		/*AXI-out - delayed*/
output reg tlast,		/*AXI-out - delayed*/
output rd_newline,		/*To CountersBlock*/	
output rd_char_incr		/*To CountersBlock*/
);

wire tvalid_nodelay;
wire tlast_nodelay;

//FSM module instantiation
readbuf_fsm READBUF_FSM1(.clk(clk), .rst(rst), .greenflag(greenflag), .lastflag(lastflag), .tready(tready), .tvalid(tvalid_nodelay), .tlast(tlast_nodelay), .rd_newline(rd_newline), .rd_char_incr(rd_char_incr));
        
    // Delay the tvalid and tlast signal by one clock cycle                              
	// to match the latency of TDATA from BRAM                                                        
	always @(posedge clk)                                                                  
	begin                                                                                          
	  if (rst)                                                                         
	    begin                                                                                      
	      tvalid <= 1'b0;                                                               
	      tlast <= 1'b0;                                                                
	    end                                                                                        
	  else if (tready)                                                                                         
	    begin                                                                                      
	      tvalid <= tvalid_nodelay;               
	      tlast <= tlast_nodelay;                                                          
	    end
//NOTE: If (~tready & ~rst) then (tvalid) and (tlast) remain unchanged.
	end         	
 
endmodule
