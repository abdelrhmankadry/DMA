module cpu (clk,Frame,ready,INT,DAR,DR,Data,Adress,read,write,MTM);
input clk,INT;
Clk clock (clk) ;
reg [31:0] result ,pc=0,pcresult ;
reg[31:0] IN ;
output reg  read ,write,Frame = 1'bz,ready =1'bz ,MTM,DAR=0;
output reg[31:0] Adress;
reg write2;
reg[3:0] count ;
input DR ;
inout [31:0]Data ;
reg[31:0] intreg[0:15] ;
reg [31:0]req ;
reg[31:0]instructionmemory[0:50];
reg  writed1,writed2,writed3,add=0,flag=0;
reg InnerCounter =0,InnerFlag =0;
integer l ;
integer i =0 ,b ;
initial
begin

$readmemb("C:/Modeltech_pe_edu_10.4a/examples/myfile.txt",instructionmemory) ;
for(l=0;l<16;l=l+1)
begin
intreg[l]=0;
end
end 
assign  Data= (write2)? intreg[IN[28:25]]: 32'dz;
assign  Data= (writed1)? intreg[IN[28:25]]: 32'dz;
assign  Data= (writed2)? intreg[IN[24:21]]: 32'dz;
assign  Data= (writed3)? intreg[IN[20:17]]: 32'dz;
always@(posedge clk)
begin
#3
if(flag==1) begin i = i + 1 ; end 

else
begin
IN=instructionmemory[pcresult>>2];
end
end
always@(i)
begin
if(b==5)
begin
count=count-1 ;
if (count==4'b0000) 
begin
 pcresult=pcresult+4;
 pc=pc+4 ;
end
if (count==4'b1111) 
begin
 i=0;
 flag=0;
 write=0;
assign Frame=0;
assign b=0;

end
end
end
always@(posedge clk)
begin
if(INT==1)
begin
DAR<=0;
end
case(IN[31:29])
1: begin  //add 
	flag =1;
	assign result =IN[24:13]+IN[12:1] ;
	intreg[IN[28:25]] = result ;
        add=0 ;
if(i==1)
begin
	assign result =0 ;
	flag=0 ;
	i=0 ;
end

end 

2: begin //sw in memory or in i/o devices
if(DAR==0)
begin
flag=1 ;
if( i == 0) begin
	writed1=0 ;
	writed2=0 ;
	writed3=0;
	write = 1;
	Adress= {6'b000000,IN[22:0],IN[24:22]};
Frame =0 ;
ready =1 ; end
if(i==1)
begin
	write2=1;
Frame =1 ;
Adress = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
end
if(i==2)
begin

Frame =0 ;
ready =0 ;
write2=0 ;
write = 0;
flag=0;
i=0;
end
end
else
add=1; 
end
3: begin //lw from memory or i/o devices
if(DAR==0)
begin
flag=1 ;
if(i == 0) begin
ready =1;
read=1 ;
Frame =0 ;
 Adress= {6'b000000,IN[22:0],IN[24:22]};
end

if(i==1)
begin
Frame =1 ;
Adress = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
 #3  intreg[IN[28:25]]<= Data ;
end
if(i==2)
begin
Frame =0 ;
    read=0 ;
ready = 0;
flag=0;
i=0;
end

end
else
add=1;
end
4: begin //make processor move data
if(DAR==0)
begin
	
	flag=1;
	Frame = 0 ;
	read  = 1 ;
	Adress= intreg[IN[28:25]];
if(i==1)
begin
        assign read=0;
	assign Frame=1;
	write=1;
	Adress= intreg[IN[24:21]];
end
if(i==2)
begin
 	count=intreg[IN[20:17]] ;
	Adress= 0;
 	assign b=5;
end

end
else
add=1;
end
5:begin //make dma move data 
if(DAR==0)
begin
flag=1;
if(i == 0) begin
	MTM = 0;
	read=1'bz;
	write=1'bz;
	write2 =0;
	writed1=0 ;
	writed2=0 ;
	writed3=0;
	Adress= {29'b0,3'b000};//adress of dma
end
if(i==1)
begin
	Adress=0;
	writed1=1 ;
end
if(i==2)
begin
	writed1=0 ;
	writed2=1 ;
end
if(i==3)
begin
	writed1=0 ;
	writed2=0 ;
	writed3=1 ;
end
if(i==4)
begin
if(DR==1)
begin
DAR=1;
end
	writed1=0;
	writed2=0;
	writed3=0;
	flag=0;
	i=0;
	Adress = 32'bz;
end
end
else
add=1;
end
6:begin //memory to meomry
if(DAR==0)
begin
	flag=1;
	write=0;
	writed1=0 ;
	writed2=0 ;
	writed3=0;
	Adress= intreg[IN[24:21]];
	read=1 ;
if(i==1)
begin
	intreg[IN[28:25]]=Data ;
end
if(i==2)
begin
	read=0 ;
	Adress= intreg[IN[20:17]];
end
if(i==3)
begin
	write=1 ;
end
if(i==4)
begin
	write=0;
	flag=0;
	i=0;
end
end
else
add=1;
end
7:begin //make dma move memory to memory
if(DAR==0)
begin
	flag=1;
if(i ==0) begin
	read=1'bz;
	write=1'bz;
	write2 = 0;
	writed1=0 ;
	writed2=0 ;
	writed3=0;
	MTM=1 ;
	Adress= {29'b0,3'b000};//adress of dma 
end
if(i==1)
begin
	Adress=0;
	writed1=1 ;
end
if(i==2)
begin
	writed1=0 ;
	writed2=1 ;
end
if(i==3)
begin
	writed1=0 ;
	writed2=0 ;
	writed3=1 ;
end
if(i==4)
begin
if(DR==1)
begin
MTM=0;
DAR=1;
end
	Adress = 32'bz;
	write2 = 0;
	writed1=0;
	writed2=0;
	writed3=0;
	flag=0;
	i=0;
end
end
else
add=1;
end
endcase
if(add==0&&flag==0)
begin
pc = pc+4;
pcresult = pc-4 ;
end
end
endmodule

