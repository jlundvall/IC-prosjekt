
plt=python3 ../../py/plot.py

pixSens:
	${MAKE} ngspice	 TB=pixelSensor_tb

tb:
	${MAKE} ngspice TB=Sensor_tb
	
	
ngspice:
	ngspice -a ${TB}.cir
