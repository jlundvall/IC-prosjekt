module pixelArray
	(
	input logic      VBN1,
	input logic      RAMP,
	input logic      RESET,
	input logic      ERASE,
	input logic      EXPOSE,
	input logic      READ12,
	input logic      READ34,
		
	inout [7:0] DATA1,
	inout [7:0] DATA2,
	inout [7:0] DATA3,
	inout [7:0] DATA4
	);
	
	
	PIXEL_SENSOR p1(VBN1, RAMP, RESET, ERASE, EXPOSE, READ12, DATA1);
	PIXEL_SENSOR p2(VBN1, RAMP, RESET, ERASE, EXPOSE, READ12, DATA2);
	PIXEL_SENSOR p3(VBN1, RAMP, RESET, ERASE, EXPOSE, READ34, DATA3);
	PIXEL_SENSOR p4(VBN1, RAMP, RESET, ERASE, EXPOSE, READ34, DATA4);
		
endmodule	
