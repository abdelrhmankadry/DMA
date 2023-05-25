module dma(clk,INT,Data,Address,read,write,MemToMem,Frame,Ready,BusRequest);
input clk,INT,MemToMem;
inout BusRequest;
output reg  read ,write,Frame,Ready;
Clk clock (clk) ;
inout reg [31:0] Address;
inout [31:0]Data ;
reg[31:0] SourceReg;
reg[31:0] TargetReg;
reg[31:0] BytesReg;
reg[31:0] TempReg;
integer counter =0;
reg flag =0;
always@(posedge clk) // Counter...
begin
if (flag == 1) begin counter = counter +1; end
end

always@(posedge clk)begin
	if (address[0:2] == 3'b000) begin
		flag = 1; // start counter ....
		if (MemToMem == 0) begin

			case(counter)
			1: SourceReg = Data; //First cycle....
			2: TargetReg = Data; // second cycle...
			3: BytesReg = Data; //Third cycle...
			4: BusRequest = 1; // Fourth cycle...
			5: BusRequest = 0;
			6: begin Data = SourceReg; read = 1; Frame = 0; Ready = 0; end
			7: begin Data = TargetReg; write = 1; Frame = 1; Ready = 1; end
			endcase

			counter = 0; // reset counter...
			flag = 0;
		end
	end
end
endmodule 