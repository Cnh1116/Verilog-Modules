// File Name: MainMem.sv
//
// Name: Carson Holland
//
// Date: 4/13/2023
// 
// File Purpose: Main memory module
// 
// Assistance / Credit: Dr. Welker Code
// Mark W. Welker
// Matrix_add assignment
// Spring 2021
//
//



parameter    matrixMemory0 = 256'h0001_0002_0003_0004_0005_0006_0007_0008_0009_000a_000b_000c_000d_000e_000f_0010;
parameter    matrixMemory1 = 256'h0020_001f_001e_001d_001c_001b_001a_0019_0018_0017_0016_0015_0014_0013_0012_0011;

module MainMemory(Clk,Dataout,DataIn, address, nRead,nWrite, nReset);


input logic [255:0] DataIn; // from the CPU
input logic nRead,nWrite, nReset, Clk;
input logic [15:0] address;

output logic [255:0] Dataout; // to the CPU 

  logic [255:0]MainMemory[12]; // this is the physical memory

always_ff @(negedge Clk or negedge nReset)
begin
	if (~nReset) begin
	
	MainMemory[0] = matrixMemory0;
	MainMemory[1] = matrixMemory1;
	MainMemory[2] = 256'h0;
	MainMemory[3] = 256'h0;
	MainMemory[4] = 256'h0;
	MainMemory[5] = 256'h0;
	MainMemory[6] = 256'h0;
	MainMemory[7] = 256'h0;
	MainMemory[8] = 256'h4;
	MainMemory[9] = 256'hb;
	MainMemory[10] = 256'h0;
	MainMemory[11] = 256'h0;
	
	
      Dataout=0;
	end

  else if(address[15:12] == MainMemEn) // talking to Instruction
		begin
			if (~nRead)begin
				Dataout <= MainMemory[address[11:0]]; // data will remain on dataout until it is changed.
			end
			if(~nWrite)begin
		    MainMemory[address[11:0]] <= DataIn;
			end
		end
end // from negedge nRead	

endmodule


