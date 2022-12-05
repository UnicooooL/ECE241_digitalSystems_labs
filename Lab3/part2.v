
//test RCA
module part2(SW, LEDR);
		input [9:0] SW;
 		output [9:0] LEDR;
			RCA u1(SW[3:0], SW[7:4], SW[8], LEDR[3:0], LEDR[9:6]);
endmodule

//defination for full adder
module FA(a, b, cin, s, cout);
		input a, b, cin;
		output s, cout;
			assign s = cin ^ a ^ b;
			assign cout = (a&b) | (cin&a) | (cin&b);
endmodule

//definition for ripple carry adder; top module that connect everthing together
module RCA(a, b, c_in, s, c_out);
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

