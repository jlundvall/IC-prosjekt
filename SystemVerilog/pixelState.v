//control reset, exposure, analog-to-digital conversion, readout


module pixelState
	(
	input clk, reset,  
	output logic erase, expose, convert, read12, read34, 
	inout anaBias1, anaRamp, 
	output anaReset,
	inout [7:0] pixData1, pixData2, pixData3, pixData4,
	output [7:0] pixelDataOut1, pixelDataOut2, pixelDataOut3, pixelDataOut4
	);
	
	
	//states:
	parameter ERASE=0, EXPOSE=1, CONVERT=2, READ12=3, READ34=4, IDLE=5;
	
	
	
	logic [2:0]       state,next_state;   //States
	integer           counter;            //Delay counter in state machine

	//State duration in clock cycles
	parameter integer c_erase = 5;
	parameter integer c_expose = 255;
	parameter integer c_convert = 255;
	parameter integer c_read = 5;

	// Control the output signals
   always_ff @(negedge clk ) begin
      case(state)
        ERASE: begin
           erase <= 1;
           read12 <= 0;
           read34 <= 0;
           expose <= 0;
           convert <= 0;
        end
        EXPOSE: begin
           erase <= 0;
           read12 <= 0;
           read34 <= 0;
           expose <= 1;
           convert <= 0;
        end
        CONVERT: begin
           erase <= 0;
           read12 <= 0;
           read34 <= 0;
           expose <= 0;
           convert = 1;
        end
        READ12: begin
           erase <= 0;
           read12 <= 1;
           read34 <= 0;
           expose <= 0;
           convert <= 0;
        end
        READ34: begin
			erase <= 0;
           read12 <= 0;
           read34 <= 1;
           expose <= 0;
           convert <= 0;
        end
        IDLE: begin
           erase <= 0;
           read12 <= 0;
           read34 <= 0;
           expose <= 0;
           convert <= 0;

        end
      endcase // case (state)
   end // always @ (state)


	 // Control the state transitions
   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         state = IDLE;
         next_state = ERASE;
         counter  = 0;
         convert  = 0;
      end
      else begin
         case (state)
           ERASE: begin
              if(counter == c_erase) begin
                 next_state <= EXPOSE;
                 state <= IDLE;
              end
           end
           EXPOSE: begin
              if(counter == c_expose) begin
                 next_state <= CONVERT;
                 state <= IDLE;
              end
           end
           CONVERT: begin
              if(counter == c_convert) begin
                 next_state <= READ12;
                 state <= IDLE;
              end
           end
           READ12:
             if(counter == c_read) begin
                state <= IDLE;
                next_state <= READ34;
             end 
           READ34:
             if(counter == c_read) begin
                state <= IDLE;
                next_state <= ERASE;
             end   
           IDLE:
             state <= next_state;
         endcase // case (state)
         if(state == IDLE)
           counter = 0;
         else
           counter = counter + 1;
      end
   end // always @ (posedge clk or posedge reset)


//-----------------------------------------------------------------------
		 
	//------------------------------------------------------------
	// DAC and ADC model
	//------------------------------------------------------------
	logic[7:0] data1;
	logic[7:0] data2;
	logic[7:0] data3;
	logic[7:0] data4;
	
	 //------------------------------------------------------------
	// Readout from databus
	//------------------------------------------------------------
	

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
   //nar read er høy -> pixData = z, så hvordan får vi 7F og verdier?
   
   
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
   
endmodule
