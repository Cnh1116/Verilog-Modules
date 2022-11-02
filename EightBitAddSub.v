//Data Flow Implemented 8-Bit Adder/Subtractor Circuit
//Uses 8 Cascading Full Adders, Two's Compliment Circuitry added for subtraction
//Carson Holland
//October 2022

`timescale 1ns / 1ps


module EightBitAddSub(
    input wire [7:0] a,
    input wire [7:0] b,
    input wire sub,
    output wire [7:0] sum,
    output wire carryOut
    );
    
    wire B0, B1, B2, B3, B4, B5, B6, B7;
    wire [8:1] carry;
    assign B0 = b[0] ^ sub;
    assign B1 = b[1] ^ sub;
    assign B2 = b[2] ^ sub;
    assign B3 = b[3] ^ sub;
    assign B4 = b[4] ^ sub;
    assign B5 = b[5] ^ sub;
    assign B6 = b[6] ^ sub;
    assign B7 = b[7] ^ sub;
    
    assign carryOut = carry[8] ^ sub;
        
    Full_Adder f0 (a[0], B0, sub, sum[0], carry[1]);
    Full_Adder f1 (a[1], B1, carry[1], sum[1], carry[2]);
    Full_Adder f2 (a[2], B2, carry[2], sum[2], carry[3]);
    Full_Adder f3 (a[3], B3, carry[3], sum[3], carry[4]);
    Full_Adder f4 (a[4], B4, carry[4], sum[4], carry[5]);
    Full_Adder f5 (a[5], B5, carry[5], sum[5], carry[6]);
    Full_Adder f6 (a[6], B6, carry[6], sum[6], carry[7]);
    Full_Adder f7 (a[7], B7, carry[7], sum[7], carry[8]);
     
endmodule
