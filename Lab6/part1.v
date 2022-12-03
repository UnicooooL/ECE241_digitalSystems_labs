module part1(Clock, Resetn, w, z, CurState);
	input Clock;
	input Resetn;  //synchronous reset when 0
	input w;  //w input to detector
	output z;  //output from detector
	output [3:0] CurState;  //outputs current state
	
	reg [3:0] currS, nextS;
	
	localparam A = 4'b0000, B = 4'b0001, C = 4'b0010, D = 4'b0011, E = 4'b0100, F = 4'b0101, G = 4'b0110;
	
	always@(*)
		begin: state_table
			case (currS)
				A: begin
						if(!w) 
							nextS = A;
						else
							nextS = B;
					end
				B: begin
						if(!w)
							nextS = A;
						else
							nextS = C;
					end
				C: begin
						if(!w)
							nextS = E;
						else
							nextS = D;
					end
				D: begin
						if(!w)
							nextS = E;
						else
							nextS = F;
					end
				E: begin 
						if(!w)
							nextS = A;
						else
							nextS = G;
					end
				F: begin
						if(!w)
							nextS = E;
						else
							nextS = F;
					end
				G: begin
						if(!w)
							nextS = A;
						else
							nextS = C;
					end
				default: nextS = A;
			endcase
		end
		
	//state registers
	always@(posedge Clock)
		begin: state_FFs
			if(Resetn == 1'b0)
				currS <= A;
			else
				currS <= nextS;
		end
		
	//output logic
	assign z = ((currS == F) | (currS == G));
	assign CurState = currS;
endmodule
					