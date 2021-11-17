* Pixel sensor
**********************************************************************
**        Copyright (c) 2021 Carsten Wulff Software, Norway
** *******************************************************************
** Created       : wulff at 2021-7-22
** *******************************************************************
**  The MIT License (MIT)
**
**  Permission is hereby granted, free of charge, to any person obtaining a copy
**  of this software and associated documentation files (the "Software"), to deal
**  in the Software without restriction, including without limitation the rights
**  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
**  copies of the Software, and to permit persons to whom the Software is
**  furnished to do so, subject to the following conditions:
**
**  The above copyright notice and this permission notice shall be included in all
**  copies or substantial portions of the Software.
**
**  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
**  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
**  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
**  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
**  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
**  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
**  SOFTWARE.
**
**********************************************************************

.SUBCKT PIXEL_SENSOR VBN1 VRAMP VRESET ERASE EXPOSE READ
+ DATA_7 DATA_6 DATA_5 DATA_4 DATA_3 DATA_2 DATA_1 DATA_0 VDD VSS


XS1 VRESET VSTORE ERASE EXPOSE VDD VSS SENSOR

XC1 VCMP_OUT VSTORE VRAMP VDD VSS VBN1 COMP

XM1 READ VCMP_OUT DATA_7 DATA_6 DATA_5 DATA_4 DATA_3 DATA_2 DATA_1 DATA_0 VDD VSS MEMORY

.ENDS

.SUBCKT MEMORY READ VCMP_OUT
+ DATA_7 DATA_6 DATA_5 DATA_4 DATA_3 DATA_2 DATA_1 DATA_0 VDD VSS

XM1 VCMP_OUT DATA_0 READ VSS MEMCELL
XM2 VCMP_OUT DATA_1 READ VSS MEMCELL
XM3 VCMP_OUT DATA_2 READ VSS MEMCELL
XM4 VCMP_OUT DATA_3 READ VSS MEMCELL
XM5 VCMP_OUT DATA_4 READ VSS MEMCELL
XM6 VCMP_OUT DATA_5 READ VSS MEMCELL
XM7 VCMP_OUT DATA_6 READ VSS MEMCELL
XM8 VCMP_OUT DATA_7 READ VSS MEMCELL

.ENDS

.SUBCKT MEMCELL CMP DATA READ VSS
M1 VG CMP DATA VSS nmos  w=0.2u  l=0.13u
M2 DATA READ DMEM VSS nmos  w=0.4u  l=0.13u
M3 DMEM VG VSS VSS nmos  w=1u  l=0.13u
C1 VG VSS 1p
.ENDS

.SUBCKT SENSOR VRESET VSTORE ERASE EXPOSE VDD VSS


*Mname drain gate source bulk name parameter
*MN1 V1 VPG V1 V1 nmos W=0.6u L=0.15u
*MN2 V1 VTX V2 V2 nmos
*MN3 VRV VPR V2 V2 nmos
*MN4 0 V2 0 0 nmos W=0.6u L=0.15u


* Capacitor to model gate-source capacitance
C1 VSTORE VSS 250f   

* Transistor to reset voltage on capacitor
MN3 VRESET ERASE VSTORE VSTORE nmos W=0.6u L=0.15u

* Transistor to expose pixel
MN2 VPG EXPOSE VSTORE VSTORE nmos W=0.6u L=0.15u     

* Model of photocurrent
Rphoto VPG VSS 1G
.ENDS

.SUBCKT COMP VCMP_OUT VSTORE VRAMP VDD VSS VBN1

* Comparator
*Differential gain stage 
MP1 V3 V3 VDD VDD pmos W=0.6u L=0.15u
MP2 V6 V3 VDD VDD pmos W=0.6u L=0.15u
MN5 V3 VSTORE V5 V5 nmos W=0.6u L=0.15u
MN6 V5 VBN1 VSS VSS nmos W=0.6u L=0.15u
MN7 V6 VRAMP V5 V5 nmos W=0.6u L=0.15u

*Single-ended gain stage 
MP3 V7 V6 VDD VDD pmos W=0.6u L=0.15u
MN8 V7 VBN1 VSS VSS nmos W=0.6u L=0.15u

*CMOS inverter
MP4 VCMP_OUT V7 VDD VDD pmos W=0.6u L=0.15u
MN9 VCMP_OUT V7 VSS VSS nmos W=0.6u L=0.15u

.ENDS
