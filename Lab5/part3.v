
module part3(ClockIn, Resetn, Start, Letter, DotDashOut, NewBitOut);
  input ClockIn, Resetn, Start; //start is high in automarker
  input [2:0] Letter; //the sels for mux8to1
  output DotDashOut, NewBitOut;
  wire [11:0] morseIn; //store the bits of new bit out

  mux8to1 m0(morseIn, Letter);
  rateDivider r0(Start, ClockIn, Resetn, NewBitOut); //active low so 4'b0
  shift s0(Start, Resetn, NewBitOut, ClockIn, morseIn, DotDashOut); 

 endmodule
 
 
module mux8to1(morseOut, sel);
	input [2:0] sel;
   output reg [11:0] morseOut;

    always @(*)
    	begin 
    		case(sel[2:0])
				3'b000: morseOut <= 12'b101110000000;
				3'b001: morseOut <= 12'b111010101000;
				3'b010: morseOut <= 12'b111010111010;
				3'b011: morseOut <= 12'b111010100000;
				3'b100: morseOut <= 12'b100000000000;
				3'b101: morseOut <= 12'b101011101000;
				3'b110: morseOut <= 12'b111011101000;
				3'b111: morseOut <= 12'b101010100000;
    	   endcase
		end
endmodule


//module rate divider by four bit counter countdown
module rateDivider(start, clock, reset, enable);
		input clock, reset, start;
		output enable;
		reg [7:0] q;
		
		always@(posedge clock)
			begin
				
			 if(reset == 0 | start == 1)
					q <= 249;
			 else if(q == 0)
					q <= 249;
			 else
					q <= q - 1;
			 end
			
		assign enable = (q == 8'b0) ? 1 : 0;	
          
endmodule

module shift(Start, reset, enable, clock, morse, out);
	input Start, reset, clock, enable;
	input [11:0] morse;
	reg [11:0] q;
	output out;
	
	always @(posedge clock)
	begin
		if (reset == 0)
			begin
			q <= 249;
			end
		else if (Start == 1)
			begin
			q <= morse;	
			end
		else if (enable == 1)	
			begin
				q[11] <= q[10];
				q[10] <= q[9];
				q[9] <= q[8];
				q[8] <= q[7];
				q[7] <= q[6];
				q[6] <= q[5];
				q[5] <= q[4];
				q[4] <= q[3];
				q[3] <= q[2];
				q[2] <= q[1];
				q[1] <= q[0];
				q[0] <= 1'b0;
			end
	end
	assign out = q[11];
endmodule
 

