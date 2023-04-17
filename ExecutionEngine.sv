`timescale 1ns / 1ps
// File Name: ExecutionEngine.sv
//
// Name: Carson Holland
//
// Date: 4/13/2023
// 
// File Purpose: Execution enigne to control data flow of a simple processor
// 
// Assistance / Credit: 

parameter MainMemEn = 0;
parameter InstrMemEn = 1;
parameter MatrixAluEn = 2;
parameter IntAluEn = 3;
parameter RegisterEn = 4;
parameter ExecuteEn = 5;


module Execution(Clk,InstructDataOut,MemDataOut,IntDataOut,ExeDataOut, address, nRead,nWrite, nReset);

input logic Clk, nReset; //Control Signals
input logic [31:0] InstructDataOut; //Instruction Input
input logic [255:0] MemDataOut, IntDataOut;

output logic [255:0] ExeDataOut;
output logic [15:0] address;
output logic nRead, nWrite;

//Internal Regs / logic
logic [31:0] instruction;
logic [7:0] opcode;
logic [255:0] execution_registers[3];
logic [15:0] PC;
parameter source_1 = 0; 
parameter source_2 = 1;
parameter result = 2;

//States Enumeration
enum {read_instruction, 
      read_instruction_data, 
      decode_instruction,
      int_find_source1,
      int_get_source1,
      int_find_dest_source1,
      int_move_source1,
      int_finish_move1,
      int_find_source2,
      int_get_source2,
      int_find_dest_source2,
      int_move_source2,
      int_finish_move2,
      do_math,
      finish_math,
      read_result,
      move_result,
      result_finish} state, next_state;

//Opcode Parameters
parameter stop = 8'hff;


always_ff @ (negedge Clk or negedge nReset) begin
    if(~nReset) begin //If we reset, go back to the first state and make the PC 0
        state <= read_instruction;
        execution_registers[source_1] = 0;
        execution_registers[source_2] = 0;
        execution_registers[result] = 0;
        PC = 0;
    end
    else //If we are not resetting, our state will be the next state
        state <= next_state;
end //Always_FF end

always_comb begin
    if(nReset) begin //Only do the logic is reset is not active
        case(state)
            read_instruction: begin
                address[15:12] = InstrMemEn;
                address[11:0] = PC;
                nRead = 0;
                next_state = read_instruction_data;
        
            end// Read_instruction case end
            
            read_instruction_data: begin
                instruction = InstructDataOut;
                opcode = instruction[31:24];
                nRead = 1;
                next_state = decode_instruction;
            end //Read instruction data end
            
            decode_instruction: begin
                if(opcode == stop) 
                    $finish;
                else
                    next_state = int_find_source1;
            end //Decode instruction end
            
            int_find_source1: begin
                address[15:12] = 0; //The upper nibble of the source1, main memory or reg
                address[11:0] = 0; //Lower nibble of source 1, where in main memory of reg
                nRead = 0;
                next_state = int_get_source1;
            end// find source 1 end
            
            int_get_source1: begin
                execution_registers[source_1] = MemDataOut; //BAD DESIGN COULD BE REGS
                next_state = int_find_dest_source1;
            end //Integer get source 1 end
            
            int_find_dest_source1: begin
                if(opcode[7:4] == 0)
                    address[15:12] = MatrixAluEn;
                else if (opcode[7:4] == 1)
                    address[15:12] = IntAluEn;
                address[11:0] = 0; //Address for source 1 in integer alu and matrix alu
                ExeDataOut = execution_registers[source_1];
                next_state = int_move_source1;
            end //find dest source1 end 
            
            int_move_source1: begin
                nWrite = 0;
                next_state = int_finish_move1;
            end //Intmove source1 end 
            
            int_finish_move1: begin
                nRead = 1;
                nWrite = 1;
                next_state = int_find_source2;
            end
            
            int_find_source2: begin
                address[15:12] = 0; //The upper nibble of the source1
                address[11:0] = 1; //Lower nibble of source 1
                nRead = 0;
                next_state = int_get_source2;
            end// find source 1 end
                   
            int_get_source2: begin
                execution_registers[source_2] = MemDataOut; //BAD DESIGN COULD BE REGS  
                next_state = int_find_dest_source2;  
            end //Integer get source 1 end
            
             int_find_dest_source2: begin
                if(opcode[7:4] == 0)
                    address[15:12] = MatrixAluEn;
                else if (opcode[7:4] == 1)
                    address[15:12] = IntAluEn;
                address[11:0] = 1; //Address for source 2 in integer alu and matrix alu
                ExeDataOut = execution_registers[source_2];
                next_state = int_move_source2;
            end //find dest source1 end 
            
            int_move_source2: begin
                nWrite = 0;
                next_state = int_finish_move2;
            end //Intmove source2 end 
            
            int_finish_move2: begin
                nRead = 1;
                nWrite = 1;
                next_state = do_math;
            end
            
            do_math: begin
                if(opcode[7:4] == 0)
                    address[15:12] = MatrixAluEn;
                else if (opcode[7:4] == 1)
                    address[15:12] = IntAluEn;
                address[11:0] = 3; //this is status in for the integer alu 
                ExeDataOut = opcode;
                nWrite = 0;
                next_state = finish_math;
            end //Do math end
            
            finish_math: begin
                nWrite = 1;
                next_state = read_result;
            end
            
            read_result: begin
                address[15:12] = IntAluEn;
                address[11:0] = 2; //Result Register in int alu 
                nRead = 0;
                execution_registers[result] = IntDataOut;      
                next_state = move_result;
            end //Move result end
            
            move_result: begin
                address[15:12] = 0; //Top nibble of destination field
                address[11:0] = 2; //Bottom nibble of the destination field 
                ExeDataOut = execution_registers[result];
                nWrite = 0;
                next_state = result_finish;
            end //move result finish
            
            result_finish: begin
                nRead = 1;
                nWrite = 1;
                PC = PC + 1;
                next_state = read_instruction;
            end//Move resultfinish
    
    
            default: $display("The  default case of the execution module is hit!");
    endcase //State machine end case
    end //If nreset end

end //always comb end




endmodule
