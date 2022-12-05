module part2(ClockIn, Reset, Speed, CounterValue);

	input ClockIn, Reset;
	input [1:0] Speed;
	output [3:0] CounterValue;
	wire [10:0] c1;
	wire c2;
	
	freq u0(Speed, c1);
	rateDivider u1(c1, ClockIn, Reset, c2);
	counter u2(c2, ClockIn, Reset, CounterValue);
endmodule 

module rateDivider (cycles, clock, clearB, Enable);
	input [10:0] cycles;
	input clock, clearB;
	output Enable;
	reg [10:0] countDown;
	
	always @(posedge clock) // triggered every time clock rises
	begin
		if (clearB == 1'b1)
			countDown <= 11'b0;
		else if (countDown == 11'b0)
			countDown <= cycles;
		else 
			countDown <= countDown - 1;
	end
	
	assign Enable = (countDown == 11'b0)?1:0;
endmodule

module counter(Enable, clock, clearB, out);

	input clock, clearB, Enable;
	output reg [3:0] out;
	
	always @(posedge clock) // triggered every time clock rises
	begin
		if (clearB == 1'b1) // when Clear b is 0
			out <= 0;
			
		else if (Enable == 1'b1)
			out <= out + 1;
	end
endmodule

module freq(speed, cycle);
	input [1:0] speed;
	output reg [10:0] cycle;
	always @(*)
		case (speed)
			2'b00:cycle = 0;
			2'b01:cycle = 499;
			2'b10:cycle = 999;
			2'b11:cycle = 1999;

			default:cycle = 0;
		endcase
endmodule	
