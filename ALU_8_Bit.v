`timescale 1ns / 1ps
// 8 Bit Alu
//  Carson Holland
//  November 2022
// 
 



module ALU_8_Bit(
    A,
    B,
    op_code,
    result,
    zero_flag,
    control_flag
    );
    
    
    input [7:0] A, B;
    input [2:0] op_code;
    output reg  zero_flag = 1'b0, //Indicates if a Value is Zero
                control_flag = 1'b0; //Indicates Overflow for addition, or negative value for subtraction
    output reg [8:0] result = 9'b0;
    
    parameter [2:0] Add = 3'b000,
                    Sub = 3'b001,
                    Greater = 3'b010,
                    Equal = 3'b011,
                    Less = 3'b100,
                    And = 3'b101,
                    Or = 3'b110,
                    Xor = 3'b111;
     
    always @ (A or B or op_code)
    begin 
    case (op_code)
    Add: 
        begin
        result = A + B;
        control_flag = result[8];
        zero_flag = (result == 16'b0);
        end
    Sub:
        begin
        result = A-B;
        control_flag = result[8];
        zero_flag = (result == 16'b0);
        end
    Greater:
        begin
        result = (A>B);
        zero_flag = (result == 16'b0);
        control_flag = 1'b0;
        end
    Equal:
        begin
        result = (A==B);
        zero_flag = (result == 16'b0); 
        control_flag = 1'b0;
        end
    Less:
        begin
        result = (A<B);
        zero_flag = (result == 16'b0);
        control_flag = 1'b0;
        end
    And:
        begin
        result = (A & B);
        zero_flag = (result == 16'b0);
        control_flag = 1'b0;
        end
    Or:
        begin
        result = (A | B);
        zero_flag = (result == 16'b0);
        control_flag = 1'b0;
        end
    Xor:
        begin
        result = A ^ B;
        zero_flag = (result == 16'b0);
        control_flag = 1'b0;
        end
    default:
        begin
        result = 16'b0;
        control_flag = 1'b0;
        zero_flag = 1'b0;
        end
    endcase 
    end
endmodule
