
//defination for full adder
module FA(a, b, cin, s, cout);
		input a, b, cin;
		output s, cout;
			assign s = cin ^ a ^ b;
			assign cout = (a&b) | (cin&a) | (cin&b);
endmodule


//definition for ripple carry adder; top module that connect everthing together
module part2(a, b, c_in, s, c_out);
		input [3:0] a, b;
		input c_in;
		output [3:0] s;
		output [3:0] c_out;
		wire c1, c2, c3;
			FA bit0 (a[0], b[0], c_in, s[0], c1);
			FA bit1 (a[1], b[1], c1, s[1], c2);
			FA bit2 (a[2], b[2], c2, s[2], c3);
			FA bit3 (a[3], b[3], c3, s[3], c_out[3]);
		assign c_out[0] = c1;
		assign c_out[1] = c2;
		assign c_out[2] = c3;
endmodule


//ALU module definition
module part3(A, B, Function, ALUout);
		input [3:0] A, B;
		input [2:0] Function;
		output reg [7:0] ALUout;
		wire [3:0] c1;
		
			part2 u0(
						.a(A), .b(B), .c_in(0), .s(c1));
		
		always @(*)
		begin
			case (Function) 
				3'b000:begin //case 0
					ALUout = {4'b0, c1};
				end
				3'b001:begin //case 1
					ALUout = {4'b0, (A+B)};
				end
			   3'b010: begin //case 2
					ALUout = {4'b0, B};
				end
				3'b011: begin//case 3
					if(A != 4'b0 | B != 4'b0) begin
						ALUout = 8'b00000001;
					end
					else ALUout = 8'b0;
				end
				3'b100: begin//case 4
					if(A == 4'b1111 & B == 4'b1111) begin
						ALUout = 8'b00000001;
					end
					else ALUout = 8'b0;
				end
				3'b101: begin //case 5
					ALUout = {B, A};
				end
				default: begin //default case
					ALUout = 8'b0;
				end
			endcase
		end
		
endmodule



























//testbench
/*module testBench();
		reg[3:0]A, B;
		reg[2:0] Op;
		wire [3:0] ALUout;
		
		alu u1(A, B, Op, ALUout);
		
		initial
		begin 
			Op = 3'b000; A = 3'b0011; B = 3'b0001;
			#10;
			Op = 3'b001; A = 3'b0011; B = 3'b0001;
			#10;
			Op = 3'b011; A = 3'b0011; B = 3'b0001;
			#10;
			
			end
endmodule */