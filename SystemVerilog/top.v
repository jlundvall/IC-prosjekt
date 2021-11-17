module top(
	input logic clk, reset, 
	inout anaBias1, anaRamp, 
	output anaReset, 
	output erase, expose, convert, read12, read34, 
	inout [7:0] pixData1, pixData2, pixData3, pixData4,
	output [7:0] pixelDataOut1, pixelDataOut2, pixelDataOut3, pixelDataOut4
	);
	
	//instantiation 
	pixelState state(clk, reset, erase, expose, convert, read12, read34, anaBias1, anaRamp, anaReset, pixData1, pixData2, pixData3, pixData4, pixelDataOut1, pixelDataOut2, pixelDataOut3, pixelDataOut4);
	pixelArray array(anaBias1, anaRamp, anaReset, erase, expose, read12, read34, pixData1, pixData2, pixData3, pixData4);

endmodule
