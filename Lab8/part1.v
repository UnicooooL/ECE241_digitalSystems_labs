module part1(iColour,iResetn,iClock,oX,oY,oColour,oPlot,oNewFrame);
   input wire [2:0] iColour;
   input wire 	    iResetn;
   input wire 	    iClock;
   output wire [7:0] oX;         // VGA pixel coordinates
   output wire [6:0] oY;

   output wire [2:0] oColour;     // VGA pixel colour (0-7)
   output wire 	     oPlot;       // Pixel drawn enable
   output wire       oNewFrame;

   parameter
     X_BOXSIZE = 8'd4,   // Box X dimension
     Y_BOXSIZE = 7'd4,   // Box Y dimension
     X_SCREEN_PIXELS = 8'd160,  // X screen width for starting resolution and fake_fpga
     Y_SCREEN_PIXELS = 7'd120,  // Y screen height for starting resolution and fake_fpga
     CLOCKS_PER_SECOND = 50000000, // 5 KHZ for fake_fpga
     X_MAX = X_SCREEN_PIXELS - 1 - X_BOXSIZE, // 0-based and account for box width
     Y_MAX = Y_SCREEN_PIXELS - 1 - Y_BOXSIZE,

     FRAMES_PER_UPDATE = 15,
     PULSES_PER_SIXTIETH_SECOND = CLOCKS_PER_SECOND / 60
	       ;

   //
   // Your code goes here
   //
	wire erase, draw, first, go, store, plotNext;
	wire [4:0] cycleCount;
	wire [5:0] frameCount;
	
	
	counterFrame ctr3(iClock, iResetn, go, store);
	counterDelay ctr1(iClock, iResetn, oNewFrame, go, PULSES_PER_SIXTIETH_SECOND, store);
	counterCycle ctr2(iClock, iResetn, first, cycleCount);
	datapath d0(iColour, X_MAX, Y_MAX, iClock, iResetn, draw, plotNext, erase, cycleCount, frameCount, oX, oY, oColour);
	control c0(cycleCount, frameCount, go, iClock, iResetn, first, draw, oPlot, erase);

endmodule // part1



module control(cycleCount, frameCount, go, clk, resetn, draw, plotNext, plot, erase);
input [4:0] cycleCount;
input [5:0] frameCount;
input go, clk, resetn;
output reg draw, plotNext, plot, erase;
reg [2:0] current_state, next_state;
 
parameter   
      DRAW = 3'b000, 
			WAIT  = 3'b001, 
			PLOTNEXT  = 3'b010,
      BLACK = 3'b011; 
      
always@(*)
begin: state_table
  case(current_state)
    
		DRAW: next_state = ((cycleCount == 5'd19) ? WAIT : current_state);
  
		WAIT:
		begin
		 if (go == 1'b1)
			next_state = DRAW;
		 else 
			next_state = current_state;
		end
		
		PLOTNEXT: next_state = ((frameCount == 5'd34) ? WAIT : current_state); 
    
		BLACK: next_state = ((cycleCount == 5'd19) ? DRAW : current_state); 
	 
		default: next_state = DRAW;
	endcase
end

always@(*)
begin: enable_signals
	draw = 1'b0; 
	plotNext = 1'b0; 
	plot = 1'b0; 
  erase = 1'b0;
	
  case(current_state)
		DRAW:
      begin 
				draw = 1'b1;
				plot = 1'b1;
			end
    
		PLOTNEXT:
      begin
				plotNext = 1'b1;
				plot = 1'b1;
			end
    
    BLACK:
      begin
        erase = 1'b1;
        plot = 1'b1;
      end
      
	endcase
end

always@(posedge clk)
begin
  current_state <= ((resetn == 1'b0) ? BLACK : next_state);
end
endmodule



module datapath (colourInsert, rangeX, rangeY, clk, rst, draw, plotNext, erase, cycleCount, frameCount, oX, oY, oColour);
input [2:0] colourInsert;
input [7:0] rangeX;
input [6:0] rangeY;
input clk, rst, draw, plotNext, erase;
input [4:0] cycleCount;  
output reg [5:0] frameCount;
output reg [7:0] oX;
output reg [6:0] oY;
output reg [2:0] oColour;

reg [7:0] posX;
reg [6:0] posY;
reg dirH, dirV;

always @(posedge clk)
	begin
	posX = 8'd0;
	posY = 7'd0;
	
		if (!rst)
		begin
			frameCount <= 6'd0;
			dirH <= 1'b1;
			dirV <= 1'b1;
		end

	else if (frameCount == 6'd34)  //16*2 + 2
		begin
			frameCount <= 6'd0;
		end
	
	else if (plotNext)
		begin
			frameCount <= frameCount + 6'd1;
		end
		
	else if(draw)
		begin
			oX <= posX + cycleCount[1:0];
			oY <= posY + cycleCount[3:2];
			oColour <= colourInsert;
		end
		
	else if(erase)
	begin
			oX <= posX + cycleCount[1:0];
			oY <= posY + cycleCount[3:2];
			oColour <= colourInsert;
    if (cycleCount == 5'b10011)
			begin
				posX <= 8'd0;
				posY <= 7'd0;
			end
	end
	
	else if(plotNext == 1'b1)
	begin
		if (posY == 7'd0)
		begin
			dirV <= 1'b1;
      if(frameCount < 6'b10000)
			begin
				oX <= posX + frameCount[1:0];
				oY <= posY + frameCount[3:2];
				oColour <= 3'd0;
			end
      else if(frameCount == 6'b10000)
			begin
				posY <= posY + 7'd1;
			end
		end
		else if(posY == rangeY)
		begin
			dirV <= 1'b0;
      if (frameCount < 6'b10000)
			begin
				oX <= posX + frameCount[1:0];
				oY <= posY + frameCount[3:2];
				oColour <= 3'd0;
			end
      else if(frameCount == 6'b10000)
			begin
				posY <= posY - 7'd1;
			end
		end
		
		if(posX == 8'd0)
		begin
			dirH <= 1'b1;
			if(frameCount == 6'd16)
			begin
				posX <= posX + 8'd1;
			end
		end
		else if(posX == rangeX)
		begin
			dirH <= 1'b0;	
			if(frameCount == 6'd16)
			begin
				posX <= posX - 8'd1;
			end
		end	
	
		if(frameCount > 6'd16)
		begin
			oX <= posX + frameCount[1:0];
			oY <= posY + frameCount[3:2];
			oColour <= colourInsert;
		end
	
	end
		
	end
endmodule



module counterCycle(clk, rst, draw, cycleCount);
input clk, rst, draw;
output reg [4:0] cycleCount;

	always@(posedge clk)
	begin
	
		if(!rst)
		begin
			cycleCount <= 5'd0;
		end
				
		else if(cycleCount == 5'd19)
		begin
			cycleCount <= 5'd0;
		end
				
		else if(draw)
		begin
			cycleCount <= cycleCount + 5'd1;
		end

	end
endmodule



module counterFrame(clk, rst, go, store);
input clk, rst, store;
output reg go;
reg [31:0] fifteenFrame;  

	always@(posedge clk)
	begin
	
		if(!rst)
		begin
			fifteenFrame <= 32'd0;
			go <= 1'b0;		
		end
		
		else if(store)
		begin
			fifteenFrame <= fifteenFrame + 32'd1;
			go <= 1'b0;
		end
		
		else if(fifteenFrame == 32'd15)  
		begin
			fifteenFrame <= 32'd0;
			go <= 1'b1;
		end
		
		else 
		begin
			go <= 1'b0;
		end
			
	end
endmodule				 
				 

				 
module counterDelay(clk, rst, newFrame, go, pulseTime, store);
input clk, rst, go;
input [31:0] pulseTime;  
output reg newFrame, store;  
reg [31:0] countPulse;  
	always@(posedge clk)
	begin
	
		if (!rst)
			begin
				countPulse <= 32'd0;
				newFrame <= 1'b0;
				store <= 1'b0;
			end
		
		else if((countPulse + 32'd1) != pulseTime)
			begin
				countPulse <= countPulse + 32'd1;
				newFrame <= 1'b0;
				store <= 1'b0;
			end
			
		else
			begin
				countPulse <= 32'd0;
				newFrame <= 1'b1;
				store <= 1'b1;
			end
	end
	
endmodule 