
ps:
	iverilog -g2012 -o pixelSensor -c pixelSensor.fl
	vvp -n pixelSensor
	
array:
	iverilog -g2012 -o array -c array.fl
	vvp -n array

state: 
	iverilog -g2012 -o state -c pixelState.fl
	vvp -n state

top:
	iverilog -g2012 -o top -c top.fl
	vvp -n top
