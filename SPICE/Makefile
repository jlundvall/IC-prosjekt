
plt=python3 ../../py/plot.py

pixSens:
	${MAKE} ngspice	 TB=pixelSensor_tb


Sensor:
	${MAKE} ngspice	 TB=testTB
	
tb:
	${MAKE} ngspice TB=pixelSensor_tb_copy
	${plt} pixelSensor_tb.csv v(erase)


ngspice:
	ngspice -a ${TB}.cir
