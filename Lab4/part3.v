//module for part3 8bit rotating register; top module so pinned
module part3(clock, reset, ParallelLoadn, RotateRight, ASRight, Data_IN, Q);
			input clock;
			input reset;
			input ParallelLoadn;
			input RotateRight;
			input ASRight;
			input [7:0] Data_IN;
			output [7:0] Q;
			
			wire p_reg;
			
			//header mux
			mux2to1 M0(Q[7], Q[0], ASRight, p_reg);
			//blocks for subcircuit to form the rotating register [7:0]
			Figure5 P0(p_reg, Q[6], RotateRight, Data_IN[7], ParallelLoadn, clock, reset, Q[7]);
			Figure5 P1(Q[7], Q[5], RotateRight, Data_IN[6], ParallelLoadn, clock, reset, Q[6]);
			Figure5 P2(Q[6], Q[4], RotateRight, Data_IN[5], ParallelLoadn, clock, reset, Q[5]);
			Figure5 P3(Q[5], Q[3], RotateRight, Data_IN[4], ParallelLoadn, clock, reset, Q[4]);
			Figure5 P4(Q[4], Q[2], RotateRight, Data_IN[3], ParallelLoadn, clock, reset, Q[3]);
			Figure5 P5(Q[3], Q[1], RotateRight, Data_IN[2], ParallelLoadn, clock, reset, Q[2]);
			Figure5 P6(Q[2], Q[0], RotateRight, Data_IN[1], ParallelLoadn, clock, reset, Q[1]);
			Figure5 P7(Q[1], Q[7], RotateRight, Data_IN[0], ParallelLoadn, clock, reset, Q[0]);
			
endmodule


//module for the multiplexer
module mux2to1 (y, x, s, m);
 //assign outputs and inputs
 input x;
 input y;
 input s;
 output m;
 //assign the function m
 assign m = (~s & x) | (s & y);
endmodule //mux2to1


//module for flipflop
module flipflop (D, clock, Q, reset);
	input D, clock;
	input reset;
	output reg Q;
	
	always@(posedge clock) //positive edged FF
		begin
		if(reset) //if reset is 1
			begin
			Q <= 0; //give D to the output since active high
			end
		else
			begin
			Q <= D;
			end
		end
		
endmodule


//module for the subcircuit in figure 5
//left, right, loadleft, D, loadn, clock, reset, Q
module Figure5(l, r, ll, d, ln, clk, res, q);
	input l, r, ll, d, ln, clk, res;
	output q;
	wire c1, c2;
	
	//connection for left most mux in figure 5
	mux2to1 M1(
				.y(l),   //output from left
				.x(r),   //data come in from right
				.s(ll),  //selected bit signal loadleft
				.m(c1)); //wire connect to the next mux
	//connection for next mux in figure 5
	mux2to1 M2(
				.y(c1),  //output from left most mux in before
				.x(d),   //data come in from right
				.s(ln),  //selected bit signal loadn
				.m(c2)); //output to FF
				
	//flipflop in figure 5
	flipflop F0(
				.D(c2),      //output from the last mux before
				.Q(q),       //output from FF
				.clock(clk), //clock signal
				.reset(res));//sychr active high reset
				
endmodule



	
				



