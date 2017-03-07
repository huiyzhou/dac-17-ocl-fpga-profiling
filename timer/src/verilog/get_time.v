`timescale 1ns/1ps 

module get_time #(parameter WIDTH = 64)
                (input  clock
                ,input  resetn
                ,input  ivalid
                ,input  oready
                ,input  [WIDTH - 1 : 0] command
                ,output wire iready
                ,output wire ovalid
                ,output wire [WIDTH - 1 : 0] curr_time);


reg [WIDTH - 1 : 0 ] counter_time;

assign curr_time = counter_time; 
assign ovalid    = 1'b1;
assign iready    = 1'b1;


always @(posedge clock)
    if(~resetn) 
        counter_time <= 'h0;
    else 
        counter_time <= counter_time + 1;


endmodule 
