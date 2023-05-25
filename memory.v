module Memory(clk,read,write,Frame,Ready,Address,Data);
input clk,read,write;
input Ready,Frame;
reg [31:0]Memregister[0:1023];
input [31:0] Address;
inout [31:0] Data;
wire [31:0] DataIn;
reg [31:0] DataOut;
reg OutNotInData = 0;
reg RememberWrite;
reg RememberRead;
reg [29:0]MemoryAddress;
reg delay = 0;
reg flag = 0;
reg MemorySelected =0;

initial Memregister[5] = 5;
initial Memregister[4] = 4;
initial Memregister[2] = 2;
initial Memregister[3] = 3;
initial Memregister[1] = 2;
initial Memregister[0] = 1; 
assign Data = (OutNotInData)? DataOut : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;   
assign DataIn = (OutNotInData)? 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : Data;
always@(posedge clk)
begin
 if(flag) delay =1;
end
always@(negedge clk)begin
if(Address[2:0] == 3'b010) begin MemorySelected <=1; MemoryAddress <= Address[31:3]; RememberWrite = write; RememberRead = read;  end //select Memory... 
end

always @( posedge clk  )
begin
if (MemorySelected)
begin

if (RememberWrite == 1)
begin
#3
if (Frame == 1 && Ready == 1)
begin
OutNotInData <= 0;
#3 Memregister[MemoryAddress] <= DataIn; //modi
 MemoryAddress <= MemoryAddress + 1;
end
end

if (RememberRead == 1)
begin
#3
if (Frame ==1 && Ready == 1)
begin
OutNotInData <= 1;
 DataOut <= Memregister[MemoryAddress];  flag = 1; //modi
 MemoryAddress <= MemoryAddress + 1;
end
end

//if(delay) begin  DataOut <= 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz; delay = 0; flag = 0; end

#3
if(Frame == 0) MemorySelected <= 0;
end
end
endmodule

module Memorytb();
reg read,write;
wire clk;
reg Ready,Frame;
reg [31:0] Address;
wire [31:0] DataIn;
wire [31:0] Data;
reg [31:0] DataOut;
reg OutNotInData = 0;
Clk clock (clk);
Memory ad(clk,read,write,Frame,Ready,Address,Data);
//assign Data  = (OutNotInData)? DataOut : 32'b00000000000000000000000000001010;
assign Data = (OutNotInData)? DataOut : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;  //a is in output mode 
assign DataIn = (OutNotInData)? 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz : Data;

initial
begin 
Frame = 0;
@(posedge clk);
Address = 32'b00000000000000000000000000011010;
Ready = 1;
write = 0;
read = 1;

@(posedge clk);
OutNotInData =0;
Frame = 1;
@(posedge clk);
write = 0;
read = 0;
Frame = 0;
@(posedge clk);
Address = 32'b00000000000000000000000000001010;
Ready = 1;
write = 1;
read = 0;

@(posedge clk);
OutNotInData =1;
Frame = 1;
DataOut = 32'b00000000000000000000000000001010;
@(posedge clk);  // new test 
Frame = 0;
write = 0;
read = 0;
@(posedge clk);  //address
Address = 32'b00000000000000000000000000001010;
Ready = 1;
write = 1;
read = 0;

@(posedge clk); //frame up first byte
Address =32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
OutNotInData =1;
Frame = 1;
DataOut = 32'b00000000000000000000000000000001;
@(posedge clk);
OutNotInData =1;
DataOut = 32'b00000000000000000000000000000010;
@(posedge clk);
OutNotInData =1;
DataOut = 32'b00000000000000000000000000000011;
@(posedge clk);
Frame = 0;
end

endmodule
