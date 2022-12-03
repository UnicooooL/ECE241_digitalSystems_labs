module hex_decoder(c, display);
//declare inputs and outputs
	input [3:0] c;
	/* input [3:0] SW; */
	output [6:0] display;
	//declare wires name
	wire w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15;

	//assignment of wires (inputs)
	assign w0 = !c[3] & !c[2] & !c[1] & !c[0];
	assign w1 = !c[3] & !c[2] & !c[1] & c[0];
	assign w2 = !c[3] & !c[2] & c[1] & !c[0];
	assign w3 = !c[3] & !c[2] & c[1] & c[0];
	assign w4 = !c[3] & c[2] & !c[1] & !c[0];
	assign w5 = !c[3] & c[2] & !c[1] & c[0];
	assign w6 = !c[3] & c[2] & c[1] & !c[0];
	assign w7 = !c[3] & c[2] & c[1] & c[0];
	assign w8 = c[3] & !c[2] & !c[1] & !c[0];
	assign w9 = c[3] & !c[2] & !c[1] & c[0];
	assign w10 = c[3] & !c[2] & c[1] & !c[0];
	assign w11 = c[3] & !c[2] & c[1] & c[0];
	assign w12 = c[3] & c[2] & !c[1] & !c[0];
	assign w13 = c[3] & c[2] & !c[1] & c[0];
	assign w14 = c[3] & c[2] & c[1] & !c[0];
	assign w15 = c[3] & c[2] & c[1] & c[0];
	//assignment of display (outputs)
	assign display[0] =  (w1 | w4 | w11 | w13);
	assign display[1] =  (w5 | w6 | w11 | w12 | w14 | w15);
	assign display[2] =  (w2 | w12 | w14 | w15);
	assign display[3] =  (w1 | w4 | w7 | w10 | w15);
	assign display[4] =  (w1 | w3 | w4 | w5 | w7 | w9);
	assign display[5] =  (w1 | w2 | w3 | w7 | w13);
	assign display[6] =  (w0 | w1 | w7| w12);
	
endmodule
