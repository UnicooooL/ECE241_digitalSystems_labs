//module part1 of 8 bits counter
module part1(Clock, Enable, Clear_b, CounterValue);
		input Clock, Enable, Clear_b;
		output [7:0] CounterValue;
		wire [7:0] c1, c2;
		
		t_ff f1(Clock, Clear_b, Enable, c1[0]);
		andGate a1(c2[0], Enable, c1[0]);
		t_ff f2(Clock, Clear_b, c2[0], c1[1]);
		andGate a2(c2[1], c2[0], c1[1]);
		t_ff f3(Clock, Clear_b, c2[1], c1[2]);
		andGate a3(c2[2], c2[1], c1[2]);
		t_ff f4(Clock, Clear_b, c2[2], c1[3]);
		andGate a4(c2[3], c2[2], c1[3]);
		t_ff f5(Clock, Clear_b, c2[3], c1[4]);
		andGate a5(c2[4], c2[3], c1[4]);
		t_ff f6(Clock, Clear_b, c2[4], c1[5]);
		andGate a6(c2[5], c2[4], c1[5]);
		t_ff f7(Clock, Clear_b, c2[5], c1[6]);
		andGate a7(c2[6], c2[5], c1[6]);
		t_ff f8(Clock, Clear_b, c2[6], c1[7]);
		
		assign CounterValue = c1[7:0];
endmodule
		

//module for t type flip flop
module t_ff(clock, resetn, t, q);  //resetn for active-low reset
		input clock, resetn, t;
		output reg q;
		
		always@(posedge clock)
			begin
				if(!resetn)
					q <= 0;
				else
					if(t)
						q <= !q;
					else
						q <= q;
			end
endmodule


//module for the AND gate in between
module andGate(y, a, b);
		input a, b;
		output y;
		assign y = a & b;
endmodule 

