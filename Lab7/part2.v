//
// This is the template for Part 2 of Lab 7.
//
// Paul Chow
// November 2021
//
// Part 2 skeleton

/*
include "vga_adapter.v"
include "vga_address_translator.v"
include "vga_controller.v"
include "vga_pll.v" */

module fill
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
		KEY,							// On Board Keys
		SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,   						//	VGA Blue[9:0]
		LEDR
	);

	input			CLOCK_50;				//	50 MHz
	input	[3:0]	KEY;		
	input [9:0] SW;			
	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
	output [9:0] LEDR;
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.

	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;
	wire oDone;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
	part2 u0(KEY[0], ~KEY[1], ~KEY[2], SW[9:7], ~KEY[3], SW[6:0], CLOCK_50, x, y, colour, writeEn, LEDR[9], LEDR[4:2]);

	assign LEDR[0]= 1'b1;
	
endmodule



module part2(iResetn,iPlotBox,iBlack,iColour,iLoadX,iXY_Coord,iClock,oX,oY,oColour,oPlot,oDone, currentState);
   parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120;

   input wire iResetn, iPlotBox, iBlack, iLoadX;
   input wire [2:0] iColour;
   input wire [6:0] iXY_Coord;
   input wire 	    iClock;
   output wire [7:0] oX;         // VGA pixel coordinates
   output wire [6:0] oY;

   output wire [2:0] oColour;     // VGA pixel colour (0-2)
   output wire 	     oPlot;       // Pixel draw enable
   output wire       oDone;       // goes high when finished drawing frame
   
  // Your code goes here
	wire [4:0] counter; 
	wire [7:0] countX;
	wire [6:0] countY;
	wire blackEnable, writeEnable, countEnable, loadX, loadY, loadColour;
	output wire [2:0] currentState;
	
	control c0(currentState, oDone, iResetn, iLoadX, iPlotBox, iClock, iBlack, counter, countX, countY, writeEnable, loadX, loadY, loadColour, blackEnable, countEnable, oPlot);

	datapath d0(iClock, iResetn, blackEnable, writeEnable, countEnable, loadX, loadY, loadColour, iXY_Coord, oColour, oX, oY, iColour, countX, countY, counter);
endmodule 


module control(current_state, done, reset, go, plot, clock, clear, fourbitCounter, countX, countY, writeEnable, loadX, loadY, loadColour, blackEnable, countEnable, oPlot);
  input plot, go, clock, clear, reset;
  input [4:0] fourbitCounter;
  input [7:0] countX;
  input [6:0] countY;
  output reg writeEnable,loadX,loadY, loadColour, blackEnable, countEnable, done, oPlot;
  reg [3:0] next_state;
  output reg [3:0] current_state;

  localparam S_LOAD_X = 3'd0,
             S_LOAD_X_WAIT = 3'd1,
             S_LOAD_Y = 3'd2,
             S_LOAD_Y_WAIT = 3'd3,
             DRAW = 3'd4,
             BLACK = 3'd5,
			 DONE = 3'd6;
  always@(*)
    begin: state_table
            case (current_state)
             S_LOAD_X: next_state = go ? S_LOAD_X_WAIT : S_LOAD_X;
             S_LOAD_X_WAIT: next_state = go ? S_LOAD_X_WAIT : S_LOAD_Y;
             S_LOAD_Y: next_state = plot ? S_LOAD_Y_WAIT : S_LOAD_Y;
             S_LOAD_Y_WAIT: next_state = plot ? S_LOAD_Y_WAIT : DRAW;

             DRAW: 
             begin
               if (fourbitCounter == 5'd16)
                 next_state = DONE;
               else
                 next_state = current_state;
             end

              BLACK:
              begin
                if ((countX == 8'd159) && (countY == 7'd119))
                  next_state = DONE;
                else
                  next_state = current_state;
              end
             

				  
				  DONE:
				  begin
					
					next_state = S_LOAD_X;
							
					end
				  default: next_state = S_LOAD_X;
				  
        endcase
    end // state_table

    always @(*)
    begin: enable_signals
      // By default make all our signals 0
      loadX = 1'b0;
      loadY = 1'b0;
      loadColour = 1'b0;
      writeEnable = 1'b0; //when WE = 1, input one stored memory
      blackEnable = 1'b0;
      countEnable = 1'b0;
		oPlot = 0;
		//done = 1'b0;

      case (current_state)
            S_LOAD_X: begin
                loadX = 1'b1;
                loadColour = 1'b0;
                loadY = 1'b0;
                end
        
        		S_LOAD_Y: begin
					loadColour = 1'b1;
               loadX = 1'b0;
					loadY = 1'b1;
               //loadColour = 1'b1;
                //countEnable = 1'b0;
					//loadY = 1'b1;
    			end
        
            DRAW: begin
                //loadX = 1'b0;
                writeEnable = 1'b1;
                countEnable = 1'b1;
                //loadY = 1'b0;
					 oPlot = 1'b1;
					 //done = 1'b0;
					 loadColour = 1'b0;
                end
        
            BLACK: begin
                //loadX = 1'b0;
                loadColour = 1'b0;
                blackEnable = 1'b1;
                countEnable = 1'b1;
                //loadY = 1'b0;
					 oPlot = 1'b1;
					 //done = 1'b1;
                end
       endcase
		end
    // current_state registers
    always@(posedge clock)
    
	 begin
        if(!reset) 
				begin
            current_state <= S_LOAD_X;
				done <= 1'b0;
				end
        else 
		begin
		if (current_state == DONE)
			begin
            done <= 1'b1;
			end
		if(clear == 1)
			current_state <= BLACK;
        else 
				begin
            current_state <= next_state;
				end
    end // state_FFS
end
endmodule
    
module datapath(clk, reset, blackEnable, writeEnable, countEnable, loadX, loadY, loadColour, iXY_Coord, colourOut, Xstore, Ystore, colourInsert, countX, countY, counter);

  input clk, reset, loadX, loadY, loadColour, blackEnable, writeEnable, countEnable;
  input [2:0] colourInsert;
  input [6:0] iXY_Coord;
  output reg [7:0] Xstore, countX;
  output reg [6:0] Ystore, countY;
  output reg [2:0] colourOut;
  output reg [4:0] counter;
  reg [7:0] xCor;
  reg [6:0] yCor;
  reg [2:0] colourIn;
  reg [2:0] colourInNew;
  
  always@(posedge clk) begin
          if (loadX == 1)
            xCor <= {1'b0, iXY_Coord}; //extend MSB to 0
          if (loadY == 1)
            yCor <= iXY_Coord;
          if (loadColour == 1)
            colourIn <= colourInsert;  //store info for input colour conf
        
  end

//output result
	always@(posedge clk) begin
		colourInNew <= colourIn;
      if(!reset) begin //active low reset; initialize results
          countX <= 8'b0;
          countY <= 7'b0;
          Xstore <= 8'b0;
          Ystore <= 7'b0;
          colourOut <= 3'b000;           
		   counter <= 5'b0;
      end
		
		
      else if (blackEnable)  begin  //clear the whole graph to black
        if ((countX == 8'd159) && (countY != 7'd119))  //change row
          begin
            countX <= 0; //reset
            countY <= countY + 1; //y increment when x reset
          end
		   else
				begin
				countX <= countX + 1;
				end
			Xstore <= countX;
			Ystore <= countY;
			colourInNew <= 3'b000; //clear to black
			colourOut <= colourInNew;
		end
		
		
    else if (writeEnable) begin  //draw pixel normal
		if(counter < 5'd16)
		begin
			  counter <= counter + 5'd1;
			  Xstore <= xCor + counter[1:0];
			  Ystore <= yCor + counter[3:2];
			  colourOut <= colourInNew;
		end
		else if (!countEnable) begin
		  countX <= 8'd0;
		  countY <= 7'd0;
		  counter <= 5'd0;
		end
	 end
  
	if(counter == 5'd16)
	begin
	  countX <= 8'd0;
		  countY <= 7'd0;
		  counter <= 5'd0;
		end 
	 
	end
endmodule

