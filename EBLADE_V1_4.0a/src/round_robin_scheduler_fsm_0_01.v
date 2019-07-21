`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: round_robin_scheduler_fsm
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
module round_robin_scheduler_fsm(
input clk,				/*Clock*/
input rst,				/*Reset*/
input tvalid,			/*tvalid*/   
input tready,			/*tready*/
input tlast_i,			/*tlast-input*/
output sel,				/*select signal*/
output tlast_o			/*tlast_output*/
);

//RETRIEVE PACKET HEADER STATE
parameter HEADER = 1'b0;
//RETRIEVE PACKET BODY STATE
parameter BODY = 1'b1;

reg state;

// Control state machine implementation 
always@(posedge clk)
  begin
    if(rst)
      begin
        state <= HEADER;	/*Initial state is HEADER*/
	  end
  else
    begin
     case(state)
       HEADER: if(tvalid && tready && tlast_i) 
            begin 
              state <= BODY; 
            end
           else
            begin
              state <= HEADER;
            end
       BODY: if(tvalid && tready && tlast_i) 
            begin 
              state <= HEADER; 
            end
		   else
            begin
              state <= BODY;
            end
     endcase
    end
 end

 //"sel" generation
 assign sel = ((state == BODY));
 //"tlast_o" generation
 assign tlast_o = ((state == BODY) && (tlast_i));
 
endmodule
