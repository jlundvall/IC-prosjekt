`timescale 1 ns/1 ps

module top_tb();

	logic clk =0;
	logic reset =0;
	parameter integer clk_period = 500;
	parameter integer sim_end = clk_period*2400;
	always #clk_period clk=~clk;
   
	logic erase, expose, convert, read12, read34;
	logic              anaBias1;
	logic              anaRamp;
	logic              anaReset;
	
	
	tri[7:0]         pixData1; 
	tri[7:0]         pixData2; 
	tri[7:0] 		 pixData3;
	tri[7:0] 		 pixData4;
	
	logic [7:0] pixelDataOut1;
	logic [7:0] pixelDataOut2;
	logic [7:0] pixelDataOut3;
	logic [7:0] pixelDataOut4;
	
	top ferdig(clk, reset, anaBias1, anaRamp, anaReset,erase, expose, convert, read12, read34,pixData1, pixData2, pixData3, pixData4, pixelDataOut1, pixelDataOut2, pixelDataOut3, pixelDataOut4);
	
	initial
     begin
        reset = 1;

        #clk_period  reset=0;
       

        $dumpfile("top_tb.vcd");
        $dumpvars(0,top_tb);

        #sim_end
          $stop;


     end
endmodule
