// File Name: Matrix_ALU.sv
//
// Name: Carson Holland
//
// Date: 4/13/2023
// 
// File Purpose: Pasrses a 256 bit word into a 4x4 of 16bit word matrix. Performs MAtrix addition
// 
// Assistance / Credit: 

module MatrixAlu(Clk,MatrixDataOut,ExeDataOut, address, nRead,nWrite, nReset);

input logic Clk, nReset, nWrite,nRead;
input logic [15:0] address;
input logic [255:0] ExeDataOut;

output logic [255:0] MatrixDataOut;


logic [15:0] source_1_matrix [3:0][3:0];
logic [15:0] source_2_matrix [3:0][3:0];
logic [7:0] operation;

//MATRIX ALU REGISTER ADDRESSES
logic [255:0] matrixALU_registers[5];
parameter source_1 = 0;
parameter source_2 = 1;
parameter result = 2;
parameter status_in = 3;
parameter status_out = 4;

assign operation = matrixALU_registers[status_in];
assign MatrixDataOut = matrixALU_registers[result];

parameter MATRIX_ADD = 8'h01; //This is not for the project, add is 03'h for project
//parameter SUB = 8'h11;
//parameter MULT = 8'h12; 
//parameter DIV = 8'h13;
always_comb begin
    
    if(address[15:12] == 2) begin
        if(nWrite == 0) begin
            matrixALU_registers[address[11:0]] = ExeDataOut;
            if (address[11:0] == 0) begin //If writing to source 1, parse the word into the matrix
                source_1_matrix[3] = '{ExeDataOut[255:240], ExeDataOut[239:224], ExeDataOut[223:208], ExeDataOut[207:192]};
                source_1_matrix[2] = '{ExeDataOut[191:176], ExeDataOut[175:160], ExeDataOut[159:144], ExeDataOut[143:128]};
                source_1_matrix[1] = '{ExeDataOut[127:112], ExeDataOut[111:96], ExeDataOut[95:80], ExeDataOut[79:64]};
                source_1_matrix[0] = '{ExeDataOut[63:48], ExeDataOut[47:32], ExeDataOut[31:16], ExeDataOut[15:0]};
                end //Matrix 1 end
            if (address[11:0] == 1) begin //If writing to source 2, parse the word into the matrix
                source_2_matrix[3] = '{ExeDataOut[255:240], ExeDataOut[239:224], ExeDataOut[223:208], ExeDataOut[207:192]};
                source_2_matrix[2] = '{ExeDataOut[191:176], ExeDataOut[175:160], ExeDataOut[159:144], ExeDataOut[143:128]};
                source_2_matrix[1] = '{ExeDataOut[127:112], ExeDataOut[111:96], ExeDataOut[95:80], ExeDataOut[79:64]};
                source_2_matrix[0] = '{ExeDataOut[63:48], ExeDataOut[47:32], ExeDataOut[31:16], ExeDataOut[15:0]};
                end //Matrix 2 end
            end //if write is 0 end
        
        if (address[11:0] == 3) begin
        $display("I made it inside the Matrix ALU operation block");
        case(operation)
            MATRIX_ADD: begin 
                    matrixALU_registers[result] = matrixALU_registers[source_1] + matrixALU_registers[source_2];
                    $display("~~~~~~~~~~~~~~~~~~~~~~~I'm inside the add block~~~~~~~~~~~~~~~~~~~~~~~"); 
                    end
            
            default: $display("I have hit the DEFAULT OF THE INT ALU CASE BLOCK");
            endcase
      end
        
        
        end //If address is matix alu end
    end //Always comb end
endmodule