`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: writebuf_fsm
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
module writebuf_fsm(
input clk,				/*Clock*/
input rst,				/*Reset*/
input greenflag,		/*From CountersBlock*/
input tvalid,			/*AXI-in*/   
input tlast,			/*AXI-in*/
input tuser,			/*AXI-in*/
output tready,			/*AXI-out*/
output wren,			/*To BRAM*/
output wr_newline,		/*To CountersBlock*/	
output wr_char_incr,	/*To CountersBlock*/
output wr_restart_line	/*To CountersBlock*/
);

//IDLE (WAIT FOR GREENFLAG) STATE
parameter IDLE = 1'b0;
//WRITE TO BUFFER STATE
parameter WRITE = 1'b1;

reg state;

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
              state <= WRITE; 
            end
           else
            begin
              state <= IDLE;
            end
       WRITE: if(tvalid && tlast) 
            begin 
              state <= IDLE; 
            end
		   else
            begin
              state <= WRITE;
            end
     endcase
    end
 end

 //"tready" generation
 assign tready = ((state == WRITE));
 //"wren" generation
 assign wren = ((state == WRITE) && (tvalid) && (!tuser));
 //"wr_char_incr" generation
 assign wr_char_incr = ((state == WRITE) && (tvalid) && (!tlast));
 //"wr_newline" generation
 assign wr_newline = ((state == WRITE) && (tvalid) && (tlast) && (!tuser));
 //"wr_restart_line" generation
 assign wr_restart_line = ((state == WRITE) && (tvalid) && (tlast) && (tuser));
 
endmodule
