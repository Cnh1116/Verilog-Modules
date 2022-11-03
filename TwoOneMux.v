`timescale 1ns / 1ps

//Data Flow Implemented 2x1 Mux
//Carson Holland
//October 2022


module TwoOneMux(
    input wire a,
    input wire b,
    input wire select,
    output wire out
    );
    
    assign out = (a & ~select) + (b & select); //Select = 0 -> A | Select = 1 -> B
endmodule