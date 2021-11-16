`timescale 1 ns / 1 ps

module pixelArray_tb;
	logic clk =0;
	logic reset =0;
	parameter integer clk_period = 500;
	parameter integer sim_end = clk_period*2400;
	always #clk_period clk=~clk;
	
	//------------------------------------------------------------
	// Pixel
	//------------------------------------------------------------
	parameter real    dv_pixel = 0.5;  //Set the expected photodiode current (0-1)

	//Analog signals
	logic              anaBias1;
	logic              anaRamp;
	logic              anaReset;

	//Tie off the unused lines
	assign anaReset = 1;

	//Digital
	logic              erase;
	logic              expose;
	logic              read12;
	logic              read34;
	
	logic              convert;
	
	tri[7:0]         pixData1; 
	tri[7:0]         pixData2; 
	tri[7:0] 		 pixData3;
	tri[7:0] 		 pixData4;  
	
	//Instantiate the pixelarray
	pixelArray array(anaBias1, anaRamp, anaReset, erase, expose, read12, read34, pixData1, pixData2, pixData3, pixData4);
	//#(.dv_pixel(dv_pixel)) 
	
	
	
	 //------------------------------------------------------------
   // DAC and ADC model
   //------------------------------------------------------------
	logic[7:0] data1;
	logic[7:0] data2;
	logic[7:0] data3;
	logic[7:0] data4;

   // If we are to convert, then provide a clock via anaRamp
   // This does not model the real world behavior, as anaRamp would be a voltage from the ADC
   // however, we cheat
   assign anaRamp = convert ? clk : 0;

   // During exposure, provide a clock via anaBias1.
   // Again, no resemblence to real world, but we cheat.
   assign anaBias1 = expose ? clk : 0;

   // If we're not reading the pixData, then we should drive the bus
   assign pixData1 = read12 ? 8'bZ: data1;
   assign pixData2 = read12 ? 8'bZ: data2;
   assign pixData3 = read34 ? 8'bZ: data3;
   assign pixData4 = read34 ? 8'bZ: data4;
   
   //når read er lav -> pixData = data
   //nar read er høy -> pixData = z, så hvordan får vi verdier?
   
    // When convert, then run an analog ramp (via anaRamp clock) and digtal ramp via
   // data bus. Assert convert_stop to return control to main state machine.
   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         data1 =0;
         data2 =0;
         data3 =0;
         data4 =0;
      end
      if(convert) begin
         data1 +=  1;
         data2 +=  1;
         data3 +=  1;
         data4 +=  1;
      end
      else begin
         data1 =0;
         data2 =0;
         data3 =0;
         data4 =0;
      end
   end // always @ (posedge clk or reset)

	 //------------------------------------------------------------
   // Readout from databus
   //------------------------------------------------------------
   logic [7:0] pixelDataOut1;
   logic [7:0] pixelDataOut2;
   logic [7:0] pixelDataOut3;
   logic [7:0] pixelDataOut4;
   
   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         pixelDataOut1 = 0;
         pixelDataOut2 = 0;
         pixelDataOut3 = 0;
         pixelDataOut4 = 0;
      end
      else begin
        if(read12)
			pixelDataOut1 <= pixData1;
        if(read12)
			pixelDataOut2 <= pixData2;
		if(read34)
			pixelDataOut3 <= pixData3;
		if(read34)
			pixelDataOut4 <= pixData4;
      end
   end
	
	parameter integer expcon = 127500;
	parameter integer reer = 2500;
	
	initial
     begin
		$dumpfile("pixelArray_tb.vcd");
        $dumpvars(0,pixelArray_tb);
     
        reset = 1; #clk_period;  reset=0;
        erase = 1; #reer; erase = 0;
        
        //1
        expose = 1; #expcon; #expcon; 
        expose=0; #clk_period; 
        convert =1; #100000; 
        
        convert = 0; read12 = 1; read34 = 1; #reer;
        read12 = 0;  #reer;
        read34 = 0; #reer; expose = 1;
		erase = 1; #reer; erase = 0;
		//2
		expose = 1; #expcon; 
        expose=0; #clk_period; 
        convert = 1; #10000;
        
        convert = 0; read12 = 1;  #reer;
        read34 = 1; read12 = 0;  #reer;
        read34 = 0; #reer; expose = 1;
		erase = 1; #reer; erase = 0;
		//3
		expose = 1; #expcon; #expcon; 
        expose=0; #clk_period; 
        convert = 1; #200000;
        
        convert = 0; read12 = 1;  #reer;
        read34 = 1; read12 = 0;  #reer;
        read34 = 0; #reer; expose = 1;
		erase = 1; #reer; erase = 0;
		//4
		expose = 1; #expcon; 
        expose=0; #clk_period; 
        convert = 1; #900500;
        
        convert = 0; read12 = 1;  #reer;
        read34 = 1; read12 = 0;  #reer;
        read34 = 0; #reer; expose = 1;
		erase = 1; #reer; erase = 0;
		//5
		expose = 1; #expcon; 
        expose=0; #clk_period; 
        convert = 1; #600500;
        
        convert = 0; read12 = 1;  #reer;
        read34 = 1; read12 = 0;  #reer;
        read34 = 0; #reer; expose = 1;
		erase = 1; #reer; erase = 0;
        
        //expose, convert: 255*500 = 127500
        //read, erase: 500*5 = 2500

        #sim_end
          $stop;


     end

endmodule
