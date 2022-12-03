module v7404 (pin1, pin3, pin5, pin9, pin11, pin13, pin2, pin4, pin6, pin8, pin10, pin12);
 input pin1, pin3, pin5, pin13, pin11, pin9;
 output pin2, pin4, pin6, pin12, pin10, pin8;
 //assign each output to input; this is a NOT gate
 assign pin2 = ~pin1;
 assign pin4 = ~pin3;
 assign pin6 = ~pin5;
 assign pin12 = ~pin13;
 assign pin10 = ~pin11;
 assign pin8 = ~pin9;
//end the module
endmodule; //v7404

//test v7404
module v7404test(LEDR, SW);
 input [9:0] SW;
 output [9:0] LEDR;
 v7404 u0(
  .pin1(SW[0]), .pin3(SW[1]), .pin5(SW[2]), .pin13(SW[3]), .pin11(SW[4]), .pin9(SW[5]), 
  .pin2(LEDR[0]), .pin4(LEDR[1]), .pin6(LEDR[2]), .pin12(LEDR[3]), .pin10(LEDR[4]), .pin8(LEDR[5]));
endmodule


module v7408 (pin1, pin3, pin5, pin9, pin11, pin13, pin2, pin4, pin6, pin8, pin10, pin12);
 input pin1, pin2, pin4, pin5, pin12, pin13, pin9, pin10;
 output pin8, pin3, pin6, pin11;
 //assign output to inputs; AND gate
 assign pin3 = pin1 & pin2;
 assign pin6 = pin4 & pin5;
 assign pin11 = pin12 & pin13;
 assign pin8 = pin9 & pin10;
//end the module
endmodule; //v7408

//test v7408
module v7408test(LEDR, SW);
 input [9:0] SW;
 output [9:0] LEDR;
 v7408 u0(
  .pin1(SW[0]), .pin2(SW[1]), .pin4(SW[6]), .pin5(SW[2]), .pin12(SW[7]), .pin13(SW[3]), .pin10(SW[4]), .pin9(SW[5]), 
  .pin3(LEDR[0]), .pin6(LEDR[2]), .pin11(LEDR[3]), .pin8(LEDR[5]));
endmodule

module v7432 (pin1, pin3, pin5, pin9, pin11, pin13, pin2, pin4, pin6, pin8, pin10, pin12);
 input pin1, pin2, pin4, pin5, pin12, pin13, pin9, pin10;
 output pin3, pin6, pin11, pin8;
 //assign output to inputs; OR gate
 assign pin3 = pin1 | pin2;
 assign pin6 = pin4 | pin5;
 assign pin11 = pin12 | pin13;
 assign pin8 = pin9 | pin10;
//end the module
endmodule; //v7432

//test v7408
module v7432test(LEDR, SW);
 input [9:0] SW;
 output [9:0] LEDR;
 v7432 u0(
  .pin1(SW[0]), .pin2(SW[1]), .pin4(SW[6]), .pin5(SW[2]), .pin12(SW[7]), .pin13(SW[3]), .pin10(SW[4]), .pin9(SW[5]), 
  .pin3(LEDR[0]), .pin6(LEDR[2]), .pin11(LEDR[3]), .pin8(LEDR[5]));
endmodule


module mux2to1 (x, y, s, m);
 //assign outputs and inputs
 input  x;
 input y;
 input s;
 output m;
 //assign the function m
 assign m = (~s & x) | (s & y);
endmodule; //mux2to1

//test mux2to1
module mux(LEDR, SW); //output display
 input [9:0] SW;
 output [9:0] LEDR;
 //assign switch and LED
 mux2to1 u0(
  .x(SW[0]),
  .y(SW[1]),
  .s(SW[2]),
  .m(LEDR[0])
  );
endmodule
