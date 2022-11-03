`timescale 1ns / 1ps

//Data Flow Implemented 8x1 Mux. Uses 7 2x1 Mux's to select the EightOneMux
//Carson Holland
//October 2022
//010 -> C
//011 -> D
//100 -> E
//101 -> F
//110 -> G
//111 -> H

module EightOneMux(
    input wire a, b, c, d, e, f, g, h,
    input [3:0] select,
    output out
    );
    
    wire w0, w1, w2, w3, w4, w5;
    //Level 1
    TwoOneMux mux0(a, b, select[0], w0);
    TwoOneMux mux1(c, d, select[0], w1);
    TwoOneMux mux2(e, f, select[0], w2);
    TwoOneMux mux3(g, h, select[0], w3);
    
    //Level 2
    TwoOneMux mux4(w0, w1, select[1], w4);
    TwoOneMux mux5(w2, w3, select[1], w5);
    
    //Final
    TwoOneMux mux6(w4, w5, select[2], out);
endmodule
