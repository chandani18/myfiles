/*module tb();
reg i3,i2,i1,i0,clk,reset;
wire [3:0] Y;
wire data;

top u0_top(i3,i2,i1,i0,clk,reset,Y,data);

initial begin
reset=1'b0;clk=0; i3=1;i2=0;i1=1;i0=0;
#10 reset= 1'b1;i3=0;i2=0;i1=0;i0=1;
#10 reset= 1'b1;i3=1;i2=1;i1=1;i0=1;
end 
always forever #5 clk = ~clk;
initial begin
$monitor ($time, "\t", "i3=%d i2=%d i1=%d i0=%d Y=%d ", i3,i2,i1,i0,Y);
end

endmodule*/ 


module top(i3,i2,i1,i0,clk,reset,Y,data);
input i3,i2,i1,i0,clk,reset;
output [3:0] Y;
output data;
wire [3:0] temp1;
wire temp2,temp3;
my_latch u_latch(.I(temp1), .clk(clk),.reset(reset),.Y(Y));
my_decoder u_decoder(.i0(temp3),.i1(temp2),.en(data), .y(temp1));
my_mux u_mux(.data(data), .i3(i3),.i2(i2),.i1(i1),.i0(i0),.s1(temp2),.s0(temp3));
my_counter u_counter(.clk(clk),.s1(temp2),.s0(temp3));
endmodule

module my_latch(I, clk,reset,Y);
input [3:0] I;
input clk,reset;
output [3:0] Y;
reg [3:0] Y;
always @( clk or I or reset) 
begin
if(!reset)
Y<=4'b0000;
else
Y<=I;
end
endmodule

module my_decoder(i0,i1,en,y);

input i0,i1,en;
output [3:0] y;
reg [3:0] y;
always @(en or i0 or i1) 
begin
if(en)
begin
case({i1,i0})
2'b00: y=4'b1000;
2'b01:y=4'b0100;
2'b10:y=4'b0010;
2'b11:y=4'b0001;
endcase
end
else 
y=4'b0000;
end 
endmodule

module my_counter(clk,s1,s0);
input clk;
output s1,s0;
//reg s1,s0;
reg [1:0]temp;
initial begin
temp=2'b0;
end 
always @(posedge clk)
begin
//{s1,s0}<=temp++ ;
if(!temp)
temp = 2'b01;
else 
temp = temp+1;
end 

assign {s1,s0} = temp;
endmodule

module my_mux(data, i3,i2,i1,i0,s1,s0);

input i3,i2,i1,i0,s0,s1;
output data;

assign data = (i0 && ~s1 && ~s0) || (i1 && ~s1 && s0) || (i2 && s1 && ~s0) || (i3 && s1 && s0);

endmodule

