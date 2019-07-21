`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: round_robin_scheduler
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
module round_robin_sheduler (
  input clk,
  input rst,
  input [7:0] tdata_i_0,
  input [7:0] tdata_i_1,
  input tvalid_i_0,
  input tvalid_i_1,
  input tlast_i_0,
  input tlast_i_1,
  input tready_o,
  output [7:0] tdata_o,
  output tvalid_o,
  output tlast_o,
  output tready_i_0,
  output tready_i_1
  );
  
  wire w_round_robin_scheduler_fsm_sel;
  wire tlast_mux_out; 
  
//Instantiate round_robin_scheduler_fsm
round_robin_scheduler_fsm ROUND_ROBIN_SCHEDULER_FSM1 (.clk(clk), .rst(rst), .tvalid(tvalid_o), .tready(tready_o), .tlast_i(tlast_mux_out), .sel(w_round_robin_scheduler_fsm_sel), .tlast_o(tlast_o));
  
//MUX for assigning tdata_o
assign tdata_o = (w_round_robin_scheduler_fsm_sel) ? tdata_i_1 : tdata_i_0;
//MUX for assigning tvalid_o
assign tvalid_o = (w_round_robin_scheduler_fsm_sel) ? tvalid_i_1 : tvalid_i_0;
//MUX for assigning tlast_mux_out
assign tlast_mux_out = (w_round_robin_scheduler_fsm_sel) ? tlast_i_1 : tlast_i_0;

//DEMUX for tready_i_0 and tready_i_1
assign tready_i_0 = (~w_round_robin_scheduler_fsm_sel && tready_o);
assign tready_i_1 = (w_round_robin_scheduler_fsm_sel && tready_o);

endmodule
