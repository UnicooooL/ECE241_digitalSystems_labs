//lab4
/*
module part2(Clock, Reset_b, Data, Function, ALUout);
	input [3:0] Data;
	input Clock, Reset_b;
	input [2:0] Function;
	output [7:0] ALUout;
	
	wire [7:0] register;
	wire [7:0] reALU;

	alu u0(Data, ALUout[3:0], Function, reALU);
	RGT u1(Clock, Reset_b, reALU, ALUout);
	assign ALUout = register;
	
endmodule


module RGT(Clock, Reset_b, ALUout, q);
 input Clock, Reset_b;
 input [7:0] ALUout;
 output reg [7:0] q;

	always @(posedge Clock) // triggered every time clock rises
		begin
		if (Reset_b == 1'b0) //when Reset b is 0 (note this is tested on every
			q <= 8'b0; // q is set to 0. Note that the assignment uses <=
		else // when Reset b is not 0
			q <= ALUout; // value of d passes through to output q
	end
endmodule

module alu (A, B, Function, ALUout);
	input [3:0] A, B;
	input [2:0] Function;
	output reg [7:0] ALUout;
	wire [3:0] w1;
	wire w2;
	
	RCA u0(A, B, 0, w1, w2);
	
	always @(*) // declare always block
		begin
			case (Function) // start case statement
				3'b000:begin
					ALUout = {3'b0, w2, w1};
				end
				3'b001:begin
					ALUout = {4'd0, (A+B)};                                                                                           
				end
				3'b010:begin
					ALUout = {B[3], B[3], B[3], B[3], B};
					//ALUout = {4'b0, B};
				end
				3'b011: begin
					if(A != 4'b0| B != 4'b0) 
					ALUout = 8'b00000001;
					else ALUout = 8'b0;
				end
				3'b100:begin
					if(A == 4'b1111 & B == 4'b1111)
						ALUout = 8'b00000001;
					else ALUout = 8'b0;
					end
				3'b101: begin
					ALUout = B << A;
				end
				3'b110: begin
					ALUout = A*B;
				end
				3'b111: begin
					ALUout = B;
				end
				default: begin
					ALUout = 8'b0;
				end
		endcase
	end
endmodule

module FA(a, b, cin, s, cout);
	input a, b, cin;
	output s, cout;
		assign s = cin^a^b;
		assign cout = (a&b) | (cin&a) | (cin&b);
endmodule

module RCA(a, b, c_in, s, c_out);
	input [3:0] a, b;
	input c_in;
	output [3:0] s;
	output [3:0] c_out;
	wire c1, c2, c3;
		FA bit0 (a[0], b[0], c_in, s[0], c1);
		FA bit1 (a[1], b[1],c1,s[1], c2);
		FA bit2 (a[2], b[2], c2, s[2], c3);
		FA bit3 (a[3], b[3], c3, s[3], c_out[3]);
		assign c_out[0] = c1;
		assign c_out[1] = c2;
		assign c_out[2] = c3;
endmodule
*/

module part2(Clock, Reset_b, Data, Function, ALUout);
	input [3:0] Data;
	input Clock, Reset_b;
	input [2:0] Function;
	output [7:0] ALUout;
	
	wire [7:0] register;
	wire [7:0] reALU;

	alu u0(Data, ALUout[3:0], Function, reALU);
	RGT u1(Clock, Reset_b, reALU, ALUout);
	assign ALUout = register;
	
endmodule


module RGT(Clock, Reset_b, ALUout, q);
 input Clock, Reset_b;
 input [7:0] ALUout;
 output reg [7:0] q;

	always @(posedge Clock) // triggered every time clock rises
		begin
		if (Reset_b == 1'b0) //when Reset b is 0 (note this is tested on every
			q <= 8'b0; // q is set to 0. Note that the assignment uses <=
		else // when Reset b is not 0
			q <= ALUout; // value of d passes through to output q
	end
endmodule

module alu (A, B, Function, ALUout);
	input [3:0] A, B;
	input [2:0] Function;
	output reg [7:0] ALUout;
	wire [3:0] w1;
	wire [3:0] w2;
	
	RCA u0(A, B, 0, w1, w2);
	
	always @(*) // declare always block
		begin
			case (Function) // start case statement
				3'b000:begin
					ALUout = {3'b0, w2[3], w1};
				end
				3'b001:begin
					ALUout = A+B;                                                                                           
				end
				3'b010:begin
					ALUout = {{4{B[3]}}, B};
				end
				3'b011: begin
					if(A != 4'b0| B != 4'b0) 
					ALUout = 8'b00000001;
					else ALUout = 8'b0;
				end
				3'b100:begin
					if(A == 4'b1111 & B == 4'b1111)
						ALUout = 8'b00000001;
					else ALUout = 8'b0;
					end
				3'b101: begin
					ALUout = B << A;
				end
				3'b110: begin
					ALUout = A*B;
				end
				3'b111: begin
					ALUout = B;
				end
				default: begin
					ALUout = 8'b0;
				end
		endcase
	end
endmodule

module FA(a, b, cin, s, cout);
	input a, b, cin;
	output s, cout;
		assign s = cin^a^b;
		assign cout = (a&b) | (cin&a) | (cin&b);
endmodule

module RCA(a, b, c_in, s, c_out);
	input [3:0] a, b;
	input c_in;
	output [3:0] s;
	output [3:0] c_out;
	wire c1, c2, c3;
		FA bit0 (a[0], b[0], c_in, s[0], c1);
		FA bit1 (a[1], b[1],c1,s[1], c2);
		FA bit2 (a[2], b[2], c2, s[2], c3);
		FA bit3 (a[3], b[3], c3, s[3], c_out[3]);
		assign c_out[0] = c1;
		assign c_out[1] = c2;
		assign c_out[2] = c3;
endmodule

module FA(a, b, cin, s, cout);
	input a, b, cin;
	output s, cout;
		assign s = cin^a^b;
		assign cout = (a&b) | (cin&a) | (cin&b);
endmodule

module RCA(a, b, c_in, s, c_out);
	input [3:0] a, b;
	input c_in;
	output [3:0] s;
	output [3:0] c_out;
		FA bit0 (a[0], b[0], c_in, s[0], c_out[0]);
		FA bit1 (a[1], b[1],c_out[0] ,s[1], c_out[1]);
		FA bit2 (a[2], b[2], c_out[1], s[2], c_out[2]);
		FA bit3 (a[3], b[3], c_out[2], s[3], c_out[3]);
endmodule
