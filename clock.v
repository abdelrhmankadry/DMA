module Clk(clock);
output reg clock;
initial 
clock=0;
always
#31.25 clock=~clock;

endmodule

