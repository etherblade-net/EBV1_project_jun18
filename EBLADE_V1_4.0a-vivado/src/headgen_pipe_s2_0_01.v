`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Vladimir Efimov 
// 
// Create Date:
// Design Name: 
// Module Name: headgen_pipe_s2
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
module headgen_pipe_s2 (
input clk,	//shared wire
input rst,	//shared wire
input [8:0] in_0,
input [15:0] in_1,
input [15:0] in_2,
input [15:0] in_3,
output reg [8:0] out_0,
output reg [15:0] out_1,
output reg [15:0] out_2,
input enableout
);

wire [15:0] in1_in2_sum;

//Calculate in_in2_sum (with added 1)
assign in1_in2_sum = in_1 + in_2 + 1'b1;

// Implement (out_0) register
	always @(posedge clk)                                                                  
	begin                                                                                          
	  if (rst)                                                                         
	    begin                                                                                      
	      out_0 <= 9'b0;                                                               
	    end                                                                                        
	  else if (enableout)                                                                                         
	    begin                                                                                      
	      out_0 <= in_0;               
	    end
//NOTE: If (~enableout) then (out_0) remain unchanged.
end 

// Implement (out_1) register
	always @(posedge clk)                                                                  
	begin                                                                                          
	  if (rst)                                                                         
	    begin                                                                                      
	      out_1 <= 16'b0;                                                               
	    end                                                                                        
	  else if (enableout)                                                                                         
	    begin                                                                                      
	      out_1 <= in1_in2_sum;               
	    end
//NOTE: If (~enableout) then (out_1) remain unchanged.
	end

// Implement (out_2) register
	always @(posedge clk)                                                                  
	begin                                                                                          
	  if (rst)                                                                         
	    begin                                                                                      
	      out_2 <= 16'b0;
	    end                                                                                        
	  else if (enableout)                                                                                         
	    begin                                                                                      
	      out_2 <= in_3;               
	    end
//NOTE: If (~enableout) then (out_2) remain unchanged.
	end

endmodule
