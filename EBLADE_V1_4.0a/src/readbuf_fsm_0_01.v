`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: readbuf_fsm
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
module readbuf_fsm(
input clk,				/*Clock*/
input rst,				/*Reset*/
input greenflag,		/*From CountersBlock*/
input lastflag,			/*From CountersBlock*/
input tready,			/*AXI-in*/   
output tvalid,			/*AXI-out*/
output tlast,			/*AXI-out*/
output rd_newline,		/*To CountersBlock*/	
output rd_char_incr		/*To CountersBlock*/
);

//IDLE (WAIT FOR GREENFLAG) STATE
parameter IDLE = 2'b00;
//READ FROM BUFFER STATE
parameter READ = 2'b01;

reg [1:0] state;

// Control state machine implementation 
always@(posedge clk)
  begin
    if(rst)
      begin
        state <= IDLE;	/*Initial state is IDLE, wait for GREENFLAG*/
	  end
  else
    begin
     case(state)
       IDLE: if(greenflag) 
            begin 
              state <= READ; 
            end
           else
            begin
              state <= IDLE;
            end
       READ: if(tready && lastflag) 
            begin 
              state <= IDLE; 
            end
           else
            begin
              state <= READ;
            end
     endcase
    end
 end

 //"tvalid" generation
 assign tvalid = ((state == READ));
 //"tlast" generation
 assign tlast = ((state == READ) && (tready) && (lastflag));
 //"rd_char_incr" generation
 assign rd_char_incr = ((state == READ) && (tready) && (!lastflag));
 //"rd_newline" generation
 assign rd_newline = ((state == READ) && (tready) && (lastflag));    
        
endmodule	
