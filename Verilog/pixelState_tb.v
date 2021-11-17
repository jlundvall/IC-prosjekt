`timescale 1 ns / 1 ps


module pixelState_tb();
	logic erase, expose, convert, read12, read34;
	
	
	//------------------------------------------------------------
   // Testbench clock
   //------------------------------------------------------------
   logic clk =0;
   logic reset =0;
   parameter integer clk_period = 500;
   parameter integer sim_end = clk_period*2400;
   always #clk_period clk=~clk;
   
	logic              anaBias1;
	logic              anaRamp;
	logic              anaReset;
	assign anaReset = 1;
	
	tri[7:0]         pixData1; 
	tri[7:0]         pixData2; 
	tri[7:0] 		 pixData3;
	tri[7:0] 		 pixData4;
	
	pixelState dut(clk, reset, erase, expose, convert, read12, read34, anaBias1, anaRamp, anaReset, pixData1, pixData2, pixData3, pixData4);
	


	
	initial begin
		$dumpfile("pixelState_tb.vcd");
		$dumpvars();
		
		
		reset = 1; 
		#clk_period  reset=0;
		
		#sim_end
          $stop;
		
	end
	
endmodule
