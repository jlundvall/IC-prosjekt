
ps:
	iverilog -g2012 -o pixelSensor -c pixelSensor.fl
	vvp -n pixelSensor
	
arra:
	iverilog -g2012 -o array -c test.fl
	vvp -n array

states: 
	iverilog -g2012 -o state -c pixelState.fl
	vvp -n state

topp:
	iverilog -g2012 -o top -c top.fl
	vvp -n top
