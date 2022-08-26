`timescale 1ns / 1ps



module mini_proj(
clk,Y0,Y1,Y2,Y3,data_out
    );
    
 input clk ;  
 wire [1:0] count; 
 wire output_mux; 
 wire en; 
 reg k0,k1,k2,k3; 
 reg y0,y1,y2,y3; 
 output Y0,Y1,Y2,Y3,data_out;

//inputs for virtual input and output -- vio ip
vio_0 inputs (
  .clk(clk),                // input wire clk
  .probe_out0(i3),  // output wire [0 : 0] probe_out0
  .probe_out1(i2),  // output wire [0 : 0] probe_out1
  .probe_out2(i1),  // output wire [0 : 0] probe_out2
  .probe_out3(i0)  // output wire [0 : 0] probe_out3
);
 
// counter ip
c_counter_binary_0 my_counter(
  .CLK(clk),  // input wire CLK
  .Q(count)      // output wire [1 : 0] Q
);

//mux 
assign s1 = count[1]; //o/p of counter to select line of mux
assign s0 = count[0]; 
assign output_mux = (!(s1)&(!(s0))&(i0)) | (!(s1)&(s0)&(i1)) | (s1&(!(s0))&i2) | (s1&s0&i3) ; //output of mux using dataflow
assign en = output_mux; //o/p of mux to enable of decoder

// decoder 
always @(*) //sensitive to decoder i/p 
begin 
if (en == 0) 
begin  
k0 = 1'b0; k1 = 1'b0 ; k2 = 1'b0 ; k3 = 1'b0; //o/p using behavioral
end 
else 
begin 
 if ( s1 == 0 & s0 == 0) begin 
 k0 = 1; k1 = 0; k2 = 0; k3 = 0; 
 end  
 else if ( s1 == 0 & s0 == 1) begin 
 k0 = 0; k1 = 1; k2 = 0; k3 = 0;  
 end 
 else if ( s1 == 1 & s0 == 0) begin 
 k0 = 0; k1 = 0; k2 = 1; k3 = 0;  
 end 
 else begin 
 k0 = 0; k1 = 0; k2 = 0; k3 = 1;  
 end 
end 
end 

//latch 
always @(*) 
begin 
if ( k0 == 1 ) 
begin 
 if ( clk == 1) 
 y0 <= k0;
 else  
 y0 <= y0; 
end 
else if ( k1 == 1 ) //latch i/p=o/p of decoder
begin 
 if ( clk == 1) 
 y1 <= k1; //o/p using behavioral 
 else  
 y1 <= y1; 
end 
else if ( k2 == 1 ) 
begin 
 if ( clk == 1) 
 y2 <= k2; 
 else  
 y2 <= y2; 
end 
else if ( k3 == 1) 
begin 
 if ( clk == 1) 
 y3 <= k3; 
 else  
 y3 <= y3; 
end 
end 

assign Y0 = y0; //latch fin
assign Y1 = y1; 
assign Y2 = y2; 
assign Y3 = y3; 
assign data_out = output_mux; //data output

// Integrated Logic Analyzer (ILA) for outputs 
ila_0 outputs (
	.clk(clk), // input wire clk


	.probe0(Y0), // input wire [0:0]  probe0  
	.probe1(Y1), // input wire [0:0]  probe1 
	.probe2(Y2), // input wire [0:0]  probe2 
	.probe3(Y3), // input wire [0:0]  probe3 
	.probe4(data_out) // input wire [0:0]  probe4
);

endmodule
