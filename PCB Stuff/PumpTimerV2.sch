EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "PumpTimerV2"
Date "2021-04-15"
Rev "-"
Comp "Taylor Zinke"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L power:RAC03-05SK PS1
U 1 1 607369C4
P 1850 1950
F 0 "PS1" H 1850 2417 50  0000 C CNN
F 1 "RAC03-05SK" H 1850 2326 50  0000 C CNN
F 2 "power:RAC03-05SK" H 1850 1950 50  0001 L BNN
F 3 "" H 1850 1950 50  0001 L BNN
F 4 "3W AC/DC-Converter 'POWERLINE' 3kV reg" H 1850 1950 50  0001 L BNN "Description"
F 5 "None" H 1850 1950 50  0001 L BNN "Package"
F 6 "Unavailable" H 1850 1950 50  0001 L BNN "Availability"
F 7 "RAC03-05SK" H 1850 1950 50  0001 L BNN "MP"
F 8 "None" H 1850 1950 50  0001 L BNN "Price"
F 9 "Recom Power" H 1850 1950 50  0001 L BNN "MF"
	1    1850 1950
	1    0    0    -1  
$EndComp
$Comp
L Relay:ADW1205HLW K1
U 1 1 60759835
P 1700 5950
F 0 "K1" H 1700 6417 50  0000 C CNN
F 1 "ADW1205HLW" H 1700 6326 50  0000 C CNN
F 2 "RELAY_ADW1205HLW" H 1700 5950 50  0001 L BNN
F 3 "" H 1700 5950 50  0001 L BNN
F 4 "Manufacturer Recommendation" H 1700 5950 50  0001 L BNN "STANDARD"
F 5 "Panasonic" H 1700 5950 50  0001 L BNN "MANUFACTURER"
	1    1700 5950
	1    0    0    -1  
$EndComp
$Comp
L Relay:ADW1205HLW K2
U 1 1 6075A92C
P 3850 5950
F 0 "K2" H 3850 6417 50  0000 C CNN
F 1 "ADW1205HLW" H 3850 6326 50  0000 C CNN
F 2 "RELAY_ADW1205HLW" H 3850 5950 50  0001 L BNN
F 3 "" H 3850 5950 50  0001 L BNN
F 4 "Manufacturer Recommendation" H 3850 5950 50  0001 L BNN "STANDARD"
F 5 "Panasonic" H 3850 5950 50  0001 L BNN "MANUFACTURER"
	1    3850 5950
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR08
U 1 1 6075C8CB
P 2800 2200
F 0 "#PWR08" H 2800 1950 50  0001 C CNN
F 1 "GND" H 2805 2027 50  0000 C CNN
F 2 "" H 2800 2200 50  0001 C CNN
F 3 "" H 2800 2200 50  0001 C CNN
	1    2800 2200
	1    0    0    -1  
$EndComp
$Comp
L power:+5VD #PWR07
U 1 1 6075CE32
P 2800 1700
F 0 "#PWR07" H 2800 1550 50  0001 C CNN
F 1 "+5VD" H 2815 1873 50  0000 C CNN
F 2 "" H 2800 1700 50  0001 C CNN
F 3 "" H 2800 1700 50  0001 C CNN
	1    2800 1700
	1    0    0    -1  
$EndComp
Wire Wire Line
	2650 1750 2800 1750
Wire Wire Line
	2800 1750 2800 1700
Wire Wire Line
	2650 2150 2800 2150
Wire Wire Line
	2800 2150 2800 2200
Text Label 700  1750 0    50   ~ 0
Line2_in
Text Label 700  2150 0    50   ~ 0
Neutral
Wire Wire Line
	700  2150 1050 2150
Wire Wire Line
	700  1750 1050 1750
Text Label 2200 5850 0    50   ~ 0
Line1_in
Text Label 2200 6050 0    50   ~ 0
Line1_out
Text Label 4350 5850 0    50   ~ 0
Line2_in
Text Label 4350 6050 0    50   ~ 0
Line2_out
Wire Wire Line
	2100 5850 2200 5850
Wire Wire Line
	2100 6050 2200 6050
Wire Wire Line
	4250 5850 4350 5850
Wire Wire Line
	4350 6050 4250 6050
$Comp
L power:+5VD #PWR03
U 1 1 60761BD8
P 900 5950
F 0 "#PWR03" H 900 5800 50  0001 C CNN
F 1 "+5VD" H 915 6123 50  0000 C CNN
F 2 "" H 900 5950 50  0001 C CNN
F 3 "" H 900 5950 50  0001 C CNN
	1    900  5950
	1    0    0    -1  
$EndComp
$Comp
L power:+5VD #PWR011
U 1 1 60761CCD
P 3050 5950
F 0 "#PWR011" H 3050 5800 50  0001 C CNN
F 1 "+5VD" H 3065 6123 50  0000 C CNN
F 2 "" H 3050 5950 50  0001 C CNN
F 3 "" H 3050 5950 50  0001 C CNN
	1    3050 5950
	1    0    0    -1  
$EndComp
Text Label 1050 5750 0    50   ~ 0
Reset
Text Label 1050 6150 0    50   ~ 0
Set
Wire Wire Line
	1050 6150 1300 6150
Wire Wire Line
	900  5950 1300 5950
Wire Wire Line
	1050 5750 1300 5750
Text Label 3200 5750 0    50   ~ 0
Reset
Text Label 3200 6150 0    50   ~ 0
Set
Wire Wire Line
	3200 6150 3450 6150
Wire Wire Line
	3200 5750 3450 5750
Wire Wire Line
	3050 5950 3450 5950
$Comp
L power:GND #PWR06
U 1 1 607398A0
P 2000 6950
F 0 "#PWR06" H 2000 6700 50  0001 C CNN
F 1 "GND" H 2005 6777 50  0000 C CNN
F 2 "" H 2000 6950 50  0001 C CNN
F 3 "" H 2000 6950 50  0001 C CNN
	1    2000 6950
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR012
U 1 1 60739A87
P 3550 6950
F 0 "#PWR012" H 3550 6700 50  0001 C CNN
F 1 "GND" H 3555 6777 50  0000 C CNN
F 2 "" H 3550 6950 50  0001 C CNN
F 3 "" H 3550 6950 50  0001 C CNN
	1    3550 6950
	1    0    0    -1  
$EndComp
Text Label 3550 6450 0    50   ~ 0
Set
Text Label 2000 6450 0    50   ~ 0
Reset
$Comp
L Transistor_FET:DMN67D7L Q1
U 1 1 6073EED8
P 1900 6700
F 0 "Q1" H 2105 6746 50  0000 L CNN
F 1 "DMN67D7L" H 2105 6655 50  0000 L CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 2100 6625 50  0001 L CIN
F 3 "http://www.diodes.com/assets/Datasheets/DMN67D7L.pdf" H 1900 6700 50  0001 L CNN
	1    1900 6700
	1    0    0    -1  
$EndComp
$Comp
L Transistor_FET:DMN67D7L Q2
U 1 1 607417BF
P 3450 6700
F 0 "Q2" H 3655 6746 50  0000 L CNN
F 1 "DMN67D7L" H 3655 6655 50  0000 L CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 3650 6625 50  0001 L CIN
F 3 "http://www.diodes.com/assets/Datasheets/DMN67D7L.pdf" H 3450 6700 50  0001 L CNN
	1    3450 6700
	1    0    0    -1  
$EndComp
Wire Wire Line
	2000 6900 2000 6950
Wire Wire Line
	2000 6500 2000 6450
Wire Wire Line
	3550 6450 3550 6500
Wire Wire Line
	3550 6900 3550 6950
$Comp
L Simulation_SPICE:DIODE D1
U 1 1 60746E8D
P 2150 4950
F 0 "D1" V 2196 4870 50  0000 R CNN
F 1 "BAV5004WS-7" V 2105 4870 50  0000 R CNN
F 2 "Diode_SMD:D_SOD-323" H 2150 4950 50  0001 C CNN
F 3 "~" H 2150 4950 50  0001 C CNN
F 4 "Y" H 2150 4950 50  0001 L CNN "Spice_Netlist_Enabled"
F 5 "D" H 2150 4950 50  0001 L CNN "Spice_Primitive"
	1    2150 4950
	0    -1   -1   0   
$EndComp
$Comp
L Simulation_SPICE:DIODE D2
U 1 1 607487ED
P 3000 4950
F 0 "D2" V 3046 4870 50  0000 R CNN
F 1 "BAV5004WS-7" V 2955 4870 50  0000 R CNN
F 2 "Diode_SMD:D_SOD-323" H 3000 4950 50  0001 C CNN
F 3 "~" H 3000 4950 50  0001 C CNN
F 4 "Y" H 3000 4950 50  0001 L CNN "Spice_Netlist_Enabled"
F 5 "D" H 3000 4950 50  0001 L CNN "Spice_Primitive"
	1    3000 4950
	0    -1   -1   0   
$EndComp
Text Label 2150 5200 0    50   ~ 0
Reset
Text Label 3000 5200 0    50   ~ 0
Set
$Comp
L power:+5VD #PWR09
U 1 1 6074922C
P 2150 4750
F 0 "#PWR09" H 2150 4600 50  0001 C CNN
F 1 "+5VD" H 2165 4923 50  0000 C CNN
F 2 "" H 2150 4750 50  0001 C CNN
F 3 "" H 2150 4750 50  0001 C CNN
	1    2150 4750
	1    0    0    -1  
$EndComp
$Comp
L power:+5VD #PWR010
U 1 1 607499BC
P 3000 4750
F 0 "#PWR010" H 3000 4600 50  0001 C CNN
F 1 "+5VD" H 3015 4923 50  0000 C CNN
F 2 "" H 3000 4750 50  0001 C CNN
F 3 "" H 3000 4750 50  0001 C CNN
	1    3000 4750
	1    0    0    -1  
$EndComp
Wire Wire Line
	2150 5200 2150 5100
Wire Wire Line
	2150 4800 2150 4750
Wire Wire Line
	3000 4800 3000 4750
Wire Wire Line
	3000 5100 3000 5200
Wire Notes Line width 10 style solid
	5000 4350 3350 4350
Wire Notes Line width 10 style solid
	5000 4350 5000 7200
Wire Notes Line width 10 style solid
	5000 7200 650  7200
Wire Notes Line width 10 style solid
	650  7200 650  4350
Wire Notes Line width 10 style solid
	650  4350 1950 4350
Text Notes 2150 4400 0    79   ~ 0
Switching Circuit
$Comp
L Connector_Generic:Conn_02x20_Odd_Even J4
U 1 1 60782B1C
P 6900 2750
F 0 "J4" H 6950 3375 50  0000 C CNN
F 1 "Conn_02x20_Odd_Even" H 6950 3376 50  0001 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x20_P2.54mm_Vertical" H 6900 2750 50  0001 C CNN
F 3 "~" H 6900 2750 50  0001 C CNN
F 4 "M20-9982046" H 6900 2750 50  0001 C CNN "Part"
F 5 "PPTC202LFBN-RC" H 6900 2750 50  0001 C CNN "Mating"
	1    6900 2750
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR016
U 1 1 60786B68
P 6600 1800
F 0 "#PWR016" H 6600 1650 50  0001 C CNN
F 1 "+3.3V" H 6615 1973 50  0000 C CNN
F 2 "" H 6600 1800 50  0001 C CNN
F 3 "" H 6600 1800 50  0001 C CNN
	1    6600 1800
	1    0    0    -1  
$EndComp
$Comp
L power:+5VD #PWR018
U 1 1 607875C0
P 7300 1800
F 0 "#PWR018" H 7300 1650 50  0001 C CNN
F 1 "+5VD" H 7315 1973 50  0000 C CNN
F 2 "" H 7300 1800 50  0001 C CNN
F 3 "" H 7300 1800 50  0001 C CNN
	1    7300 1800
	1    0    0    -1  
$EndComp
Wire Wire Line
	7200 1950 7300 1950
Wire Wire Line
	7300 1950 7300 1850
Wire Wire Line
	7200 1850 7300 1850
Connection ~ 7300 1850
Wire Wire Line
	7300 1800 7300 1850
Wire Wire Line
	6700 1850 6600 1850
Wire Wire Line
	6600 1850 6600 1800
Text Label 6150 1950 0    50   ~ 0
GPIO2(SDA1)
Text Label 6150 2050 0    50   ~ 0
GPIO3(SCL1)
$Comp
L power:GND #PWR015
U 1 1 6078C21A
P 6050 2250
F 0 "#PWR015" H 6050 2000 50  0001 C CNN
F 1 "GND" H 6055 2077 50  0000 C CNN
F 2 "" H 6050 2250 50  0001 C CNN
F 3 "" H 6050 2250 50  0001 C CNN
	1    6050 2250
	0    1    1    0   
$EndComp
Text Label 6150 2350 0    50   ~ 0
RTC_~INT~
Wire Wire Line
	6050 2250 6700 2250
Wire Wire Line
	6700 2350 6150 2350
$Comp
L power:GND #PWR023
U 1 1 6079F112
P 8150 2450
F 0 "#PWR023" H 8150 2200 50  0001 C CNN
F 1 "GND" H 8150 2300 50  0000 C CNN
F 2 "" H 8150 2450 50  0001 C CNN
F 3 "" H 8150 2450 50  0001 C CNN
	1    8150 2450
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR024
U 1 1 6079FF85
P 8150 2750
F 0 "#PWR024" H 8150 2500 50  0001 C CNN
F 1 "GND" H 8150 2600 50  0000 C CNN
F 2 "" H 8150 2750 50  0001 C CNN
F 3 "" H 8150 2750 50  0001 C CNN
	1    8150 2750
	-1   0    0    1   
$EndComp
$Comp
L power:+5VD #PWR01
U 1 1 60772874
P 1400 2550
F 0 "#PWR01" H 1400 2400 50  0001 C CNN
F 1 "+5VD" H 1415 2723 50  0000 C CNN
F 2 "" H 1400 2550 50  0001 C CNN
F 3 "" H 1400 2550 50  0001 C CNN
	1    1400 2550
	1    0    0    -1  
$EndComp
$Comp
L power:+5VD #PWR04
U 1 1 60772F63
P 1850 2550
F 0 "#PWR04" H 1850 2400 50  0001 C CNN
F 1 "+5VD" H 1865 2723 50  0000 C CNN
F 2 "" H 1850 2550 50  0001 C CNN
F 3 "" H 1850 2550 50  0001 C CNN
	1    1850 2550
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR02
U 1 1 607737D3
P 1400 2950
F 0 "#PWR02" H 1400 2700 50  0001 C CNN
F 1 "GND" H 1405 2777 50  0000 C CNN
F 2 "" H 1400 2950 50  0001 C CNN
F 3 "" H 1400 2950 50  0001 C CNN
	1    1400 2950
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR05
U 1 1 607739EC
P 1850 2950
F 0 "#PWR05" H 1850 2700 50  0001 C CNN
F 1 "GND" H 1855 2777 50  0000 C CNN
F 2 "" H 1850 2950 50  0001 C CNN
F 3 "" H 1850 2950 50  0001 C CNN
	1    1850 2950
	1    0    0    -1  
$EndComp
Wire Wire Line
	1400 2900 1400 2950
Wire Wire Line
	1400 2600 1400 2550
Wire Wire Line
	1850 2550 1850 2600
Wire Wire Line
	1850 2900 1850 2950
$Comp
L Timer_RTC:RX8900UA U1
U 1 1 6077CD48
P 5900 4850
F 0 "U1" H 6200 5015 50  0000 C CNN
F 1 "RX8900UA" H 6200 4924 50  0000 C CNN
F 2 "Package_SO:SOP-14_127P780x200" H 6000 4000 50  0001 C CNN
F 3 "" H 6000 4000 50  0001 C CNN
	1    5900 4850
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR019
U 1 1 6077EE23
P 6700 4850
F 0 "#PWR019" H 6700 4700 50  0001 C CNN
F 1 "+3.3V" H 6715 5023 50  0000 C CNN
F 2 "" H 6700 4850 50  0001 C CNN
F 3 "" H 6700 4850 50  0001 C CNN
	1    6700 4850
	1    0    0    -1  
$EndComp
$Comp
L power:+BATT #PWR021
U 1 1 6077FF39
P 6850 4950
F 0 "#PWR021" H 6850 4800 50  0001 C CNN
F 1 "+BATT" H 6865 5123 50  0000 C CNN
F 2 "" H 6850 4950 50  0001 C CNN
F 3 "" H 6850 4950 50  0001 C CNN
	1    6850 4950
	1    0    0    -1  
$EndComp
Wire Wire Line
	6600 4950 6700 4950
Wire Wire Line
	6700 4950 6700 4850
Wire Wire Line
	6600 5050 6850 5050
Wire Wire Line
	6850 4950 6850 5050
$Comp
L power:GND #PWR020
U 1 1 60785E37
P 6700 5500
F 0 "#PWR020" H 6700 5250 50  0001 C CNN
F 1 "GND" H 6705 5327 50  0000 C CNN
F 2 "" H 6700 5500 50  0001 C CNN
F 3 "" H 6700 5500 50  0001 C CNN
	1    6700 5500
	1    0    0    -1  
$EndComp
Wire Wire Line
	6600 5450 6700 5450
Wire Wire Line
	6700 5450 6700 5500
$Comp
L Device:R_US R3
U 1 1 6076F5A9
P 5750 1750
F 0 "R3" H 5818 1796 50  0000 L CNN
F 1 "2k2" H 5818 1705 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric_Pad0.98x0.95mm_HandSolder" V 5790 1740 50  0001 C CNN
F 3 "CRGP0603F2K2" H 5750 1750 50  0001 C CNN
	1    5750 1750
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR013
U 1 1 60772ACF
P 5750 1550
F 0 "#PWR013" H 5750 1400 50  0001 C CNN
F 1 "+3.3V" H 5765 1723 50  0000 C CNN
F 2 "" H 5750 1550 50  0001 C CNN
F 3 "" H 5750 1550 50  0001 C CNN
	1    5750 1550
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR014
U 1 1 607730F3
P 6050 1550
F 0 "#PWR014" H 6050 1400 50  0001 C CNN
F 1 "+3.3V" H 6065 1723 50  0000 C CNN
F 2 "" H 6050 1550 50  0001 C CNN
F 3 "" H 6050 1550 50  0001 C CNN
	1    6050 1550
	1    0    0    -1  
$EndComp
Wire Wire Line
	6050 1550 6050 1600
Wire Wire Line
	6050 1900 6050 1950
Wire Wire Line
	6050 1950 6700 1950
Text Label 5250 5050 0    50   ~ 0
GPIO2(SDA1)
Text Label 5250 4950 0    50   ~ 0
GPIO3(SCL1)
Wire Wire Line
	5250 4950 5800 4950
Wire Wire Line
	5800 5050 5250 5050
Text Label 6700 5250 0    50   ~ 0
RTC_~INT~
$Comp
L power:GND #PWR017
U 1 1 6078C49E
P 5650 5350
F 0 "#PWR017" H 5650 5100 50  0001 C CNN
F 1 "GND" H 5655 5177 50  0000 C CNN
F 2 "" H 5650 5350 50  0001 C CNN
F 3 "" H 5650 5350 50  0001 C CNN
	1    5650 5350
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 5350 5650 5250
Wire Wire Line
	5650 5250 5800 5250
NoConn ~ 5800 5350
Wire Notes Line width 10 style solid
	7450 4400 8450 4400
Wire Notes Line width 10 style solid
	8450 4400 8450 5850
Wire Notes Line width 10 style solid
	8450 5850 5150 5850
Wire Notes Line width 10 style solid
	5150 5850 5150 4400
Wire Notes Line width 10 style solid
	5150 4400 6300 4400
Text Notes 6350 4450 0    79   ~ 0
Real-Time Clock
Wire Notes Line width 10 style solid
	5850 1200 5300 1200
Text Notes 5850 1250 0    79   ~ 0
Raspberry Pi Zero W Interface
Wire Notes Line width 10 style solid
	8250 1200 7700 1200
Wire Wire Line
	3850 2950 3450 2950
Wire Wire Line
	3450 2850 3850 2850
Wire Wire Line
	3850 2400 3450 2400
Wire Wire Line
	3450 2300 3850 2300
Text Label 3450 2950 0    50   ~ 0
Neutral
Text Label 3450 2850 0    50   ~ 0
Neutral
Text Label 3450 2300 0    50   ~ 0
Line2_out
Text Label 3450 2400 0    50   ~ 0
Line2_in
Wire Wire Line
	3450 1750 3850 1750
Wire Wire Line
	3450 1850 3850 1850
Text Label 3450 1850 0    50   ~ 0
Line1_out
Text Label 3450 1750 0    50   ~ 0
Line1_in
$Comp
L Connector:282856-2 J3
U 1 1 6074D2DA
P 4250 2400
F 0 "J3" H 4480 2496 50  0000 L CNN
F 1 "282856-2" H 4480 2405 50  0000 L CNN
F 2 "TE_282856-2" H 4250 2400 50  0001 L BNN
F 3 "" H 4250 2400 50  0001 L BNN
F 4 "Compliant with Exemptions" H 4250 2400 50  0001 L BNN "EU_RoHS_Compliance"
F 5 "282856-2" H 4250 2400 50  0001 L BNN "Comment"
	1    4250 2400
	1    0    0    -1  
$EndComp
$Comp
L Device:C C1
U 1 1 607DE07A
P 1400 2750
F 0 "C1" H 1515 2780 50  0000 L CNN
F 1 "100u" H 1515 2704 50  0000 L CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.33x1.80mm_HandSolder" H 1438 2600 50  0001 C CNN
F 3 "~" H 1400 2750 50  0001 C CNN
F 4 "GMC31X5R107M10NT" H 1400 2750 50  0001 C CNN "Part"
	1    1400 2750
	1    0    0    -1  
$EndComp
$Comp
L Device:R_US R4
U 1 1 607DF1F9
P 6050 1750
F 0 "R4" H 6118 1796 50  0000 L CNN
F 1 "2k2" H 6118 1705 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric_Pad0.98x0.95mm_HandSolder" V 6090 1740 50  0001 C CNN
F 3 "CRGP0603F2K2" H 6050 1750 50  0001 C CNN
	1    6050 1750
	1    0    0    -1  
$EndComp
Wire Wire Line
	5750 2050 5750 1900
Wire Wire Line
	5750 2050 6700 2050
Wire Wire Line
	5750 1600 5750 1550
$Comp
L power:GND #PWR022
U 1 1 6079B75D
P 8150 2050
F 0 "#PWR022" H 8150 1800 50  0001 C CNN
F 1 "GND" H 8150 1900 50  0000 C CNN
F 2 "" H 8150 2050 50  0001 C CNN
F 3 "" H 8150 2050 50  0001 C CNN
	1    8150 2050
	-1   0    0    1   
$EndComp
Wire Wire Line
	7200 2450 8150 2450
Wire Wire Line
	7200 2050 8150 2050
Wire Wire Line
	7200 2750 8150 2750
$Comp
L Connector_Generic:Conn_01x04 J6
U 1 1 608233EE
P 9750 1750
F 0 "J6" H 9830 1742 50  0000 L CNN
F 1 "B4B-PH-SM4-TBT(LF)(SN)" H 9830 1651 50  0000 L CNN
F 2 "Connector_JST:JST_PH_B4B-PH-SM4-TB_1x04-1MP_P2.00mm_Vertical" H 9750 1750 50  0001 C CNN
F 3 "~" H 9750 1750 50  0001 C CNN
	1    9750 1750
	1    0    0    -1  
$EndComp
$Comp
L power:+5VD #PWR028
U 1 1 6085AAF1
P 9300 1650
F 0 "#PWR028" H 9300 1500 50  0001 C CNN
F 1 "+5VD" H 9315 1823 50  0000 C CNN
F 2 "" H 9300 1650 50  0001 C CNN
F 3 "" H 9300 1650 50  0001 C CNN
	1    9300 1650
	1    0    0    -1  
$EndComp
Wire Wire Line
	9300 1650 9550 1650
Wire Wire Line
	9550 1950 9500 1950
Wire Wire Line
	9500 1950 9500 2000
Text Label 9000 1850 0    50   ~ 0
GPIO2(SDA1)
Text Label 9000 1750 0    50   ~ 0
GPIO3(SCL1)
Wire Wire Line
	9550 1850 9000 1850
Wire Wire Line
	9000 1750 9550 1750
$Comp
L power:GND #PWR035
U 1 1 6088F768
P 9500 2000
F 0 "#PWR035" H 9500 1750 50  0001 C CNN
F 1 "GND" H 9500 1850 50  0000 C CNN
F 2 "" H 9500 2000 50  0001 C CNN
F 3 "" H 9500 2000 50  0001 C CNN
	1    9500 2000
	1    0    0    -1  
$EndComp
Text Notes 9300 1200 0    79   ~ 0
I2C Expansion Port\n   (just in case)
Wire Notes Line width 10 style solid
	11100 1100 10550 1100
Text Notes 2200 1250 0    79   ~ 0
Power Interface
Wire Notes Line width 10 style solid
	2100 1200 600  1200
Wire Notes Line width 10 style solid
	600  1200 600  3250
Wire Notes Line width 10 style solid
	600  3250 5000 3250
Wire Notes Line width 10 style solid
	5000 3250 5000 1200
Wire Notes Line width 10 style solid
	5000 1200 3250 1200
$Comp
L Device:R_US R1
U 1 1 608D41B1
P 1650 6900
F 0 "R1" V 1550 6800 50  0000 C CNN
F 1 "10k" V 1600 7050 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric_Pad0.98x0.95mm_HandSolder" V 1690 6890 50  0001 C CNN
F 3 "~" H 1650 6900 50  0001 C CNN
F 4 "ERJ-PA3J103V" V 1650 6900 50  0001 C CNN "Part"
	1    1650 6900
	0    1    1    0   
$EndComp
Wire Wire Line
	3050 6900 2950 6900
Wire Wire Line
	2950 6900 2950 6700
Wire Wire Line
	2950 6700 3250 6700
Wire Wire Line
	3350 6900 3550 6900
Connection ~ 3550 6900
Wire Wire Line
	2000 6900 1800 6900
Connection ~ 2000 6900
Wire Wire Line
	1500 6900 1400 6900
Wire Wire Line
	1400 6900 1400 6700
Wire Wire Line
	1400 6700 1700 6700
Text Label 7800 2150 0    50   ~ 0
RLY_R
Text Label 1400 6700 0    50   ~ 0
RLY_R
Text Label 2950 6700 0    50   ~ 0
RLY_S
$Comp
L Connector:282856-2 J2
U 1 1 60901AFC
P 4250 1850
F 0 "J2" H 4480 1946 50  0000 L CNN
F 1 "282856-2" H 4480 1855 50  0000 L CNN
F 2 "TE_282856-2" H 4250 1850 50  0001 L BNN
F 3 "" H 4250 1850 50  0001 L BNN
F 4 "Compliant with Exemptions" H 4250 1850 50  0001 L BNN "EU_RoHS_Compliance"
F 5 "282856-2" H 4250 1850 50  0001 L BNN "Comment"
	1    4250 1850
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D4
U 1 1 607813C7
P 10600 3200
F 0 "D4" H 10593 2945 50  0000 C CNN
F 1 "LED" H 10593 3036 50  0000 C CNN
F 2 "LED_SMD:LED_0603_1608Metric_Castellated" H 10600 3200 50  0001 C CNN
F 3 "~" H 10600 3200 50  0001 C CNN
F 4 "SML-D12U1WT86" H 10600 3200 50  0001 C CNN "Part"
	1    10600 3200
	-1   0    0    1   
$EndComp
$Comp
L Device:R_US R14
U 1 1 60781EE0
P 10250 3200
F 0 "R14" V 10045 3200 50  0000 C CNN
F 1 "330" V 10136 3200 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric_Pad0.98x0.95mm_HandSolder" V 10290 3190 50  0001 C CNN
F 3 "~" H 10250 3200 50  0001 C CNN
F 4 "CRGCQ0603F330R" V 10250 3200 50  0001 C CNN "Part"
	1    10250 3200
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR0101
U 1 1 60792042
P 9750 3450
F 0 "#PWR0101" H 9750 3200 50  0001 C CNN
F 1 "GND" H 9755 3277 50  0000 C CNN
F 2 "" H 9750 3450 50  0001 C CNN
F 3 "" H 9750 3450 50  0001 C CNN
	1    9750 3450
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0102
U 1 1 607924C3
P 10800 3300
F 0 "#PWR0102" H 10800 3050 50  0001 C CNN
F 1 "GND" H 10805 3127 50  0000 C CNN
F 2 "" H 10800 3300 50  0001 C CNN
F 3 "" H 10800 3300 50  0001 C CNN
	1    10800 3300
	1    0    0    -1  
$EndComp
Wire Wire Line
	9700 3400 9750 3400
Wire Wire Line
	9750 3400 9750 3450
Wire Wire Line
	10400 3200 10450 3200
Wire Wire Line
	10750 3200 10800 3200
Wire Wire Line
	10800 3200 10800 3300
Text Label 7800 2250 0    50   ~ 0
~BTN_RDY~
Wire Wire Line
	7800 2250 7200 2250
Text Label 9750 3200 0    50   ~ 0
~BTN_RDY~
Wire Wire Line
	9750 3200 10100 3200
Wire Notes Line width 10 style solid
	9350 2600 8750 2600
Text Notes 9400 2650 0    79   ~ 0
Override Button\n and Indicator
Wire Notes Line width 10 style solid
	10950 2600 10400 2600
Wire Notes Line width 10 style solid
	8650 1100 9250 1100
Wire Notes Line width 10 style solid
	8650 2300 11100 2300
Wire Notes Line width 10 style solid
	8650 1100 8650 2300
Wire Notes Line width 10 style solid
	11100 2300 11100 1100
Wire Notes Line width 10 style solid
	5300 3950 8250 3950
NoConn ~ 6700 3050
Wire Notes Line width 10 style solid
	5300 1200 5300 3950
Wire Notes Line width 10 style solid
	8250 1200 8250 3950
NoConn ~ 6700 3150
NoConn ~ 6700 3250
NoConn ~ 6700 3350
NoConn ~ 6700 3450
NoConn ~ 6700 3550
NoConn ~ 6700 3650
NoConn ~ 6700 3750
NoConn ~ 7200 3750
NoConn ~ 7200 3650
NoConn ~ 7200 3550
NoConn ~ 7200 3350
NoConn ~ 7200 3250
NoConn ~ 7200 3150
NoConn ~ 7200 3050
NoConn ~ 7200 3450
Wire Wire Line
	7800 2350 7200 2350
Text Label 7800 2350 0    50   ~ 0
RLY_S
Wire Wire Line
	7200 2150 7800 2150
NoConn ~ 7200 2550
NoConn ~ 7200 2650
NoConn ~ 7200 2950
NoConn ~ 7200 2850
NoConn ~ 6700 2450
NoConn ~ 6700 2550
NoConn ~ 6700 2750
NoConn ~ 6700 2850
NoConn ~ 6700 2950
NoConn ~ 6700 2650
$Comp
L Mechanical:MountingHole H1
U 1 1 608325BA
P 8800 4800
F 0 "H1" H 8900 4846 50  0000 L CNN
F 1 "2.75mm Mount" H 8900 4755 50  0000 L CNN
F 2 "MountingHole:MountingHole_2.7mm_M2.5" H 8800 4800 50  0001 C CNN
F 3 "~" H 8800 4800 50  0001 C CNN
F 4 "50M025045G008" H 8800 4800 50  0001 C CNN "Part"
F 5 "971110155" H 8800 4800 50  0001 C CNN "Mating"
F 6 "50M025045G006" H 8800 4800 50  0001 C CNN "Alternate part"
	1    8800 4800
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H3
U 1 1 6083A38E
P 9600 4800
F 0 "H3" H 9700 4846 50  0000 L CNN
F 1 "2.75mm Mount" H 9700 4755 50  0000 L CNN
F 2 "MountingHole:MountingHole_2.7mm_M2.5" H 9600 4800 50  0001 C CNN
F 3 "~" H 9600 4800 50  0001 C CNN
F 4 "50M025045G008" H 9600 4800 50  0001 C CNN "Part"
F 5 "971110155" H 9600 4800 50  0001 C CNN "Mating"
F 6 "50M025045G006" H 9600 4800 50  0001 C CNN "Alternate part"
	1    9600 4800
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H5
U 1 1 6083AA2B
P 10400 4800
F 0 "H5" H 10500 4846 50  0000 L CNN
F 1 "2.75mm Mount" H 10500 4755 50  0000 L CNN
F 2 "MountingHole:MountingHole_2.7mm_M2.5" H 10400 4800 50  0001 C CNN
F 3 "~" H 10400 4800 50  0001 C CNN
F 4 "50M025045G008" H 10400 4800 50  0001 C CNN "Part"
F 5 "971110155" H 10400 4800 50  0001 C CNN "Mating"
F 6 "50M025045G006" H 10400 4800 50  0001 C CNN "Alternate part"
	1    10400 4800
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H6
U 1 1 608414EE
P 10400 5100
F 0 "H6" H 10500 5146 50  0000 L CNN
F 1 "2.75mm Mount" H 10500 5055 50  0000 L CNN
F 2 "MountingHole:MountingHole_2.7mm_M2.5" H 10400 5100 50  0001 C CNN
F 3 "~" H 10400 5100 50  0001 C CNN
F 4 "50M025045G008" H 10400 5100 50  0001 C CNN "Part"
F 5 "971110155" H 10400 5100 50  0001 C CNN "Mating"
F 6 "50M025045G006" H 10400 5100 50  0001 C CNN "Alternate part"
	1    10400 5100
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H4
U 1 1 60841853
P 9600 5100
F 0 "H4" H 9700 5146 50  0000 L CNN
F 1 "2.75mm Mount" H 9700 5055 50  0000 L CNN
F 2 "MountingHole:MountingHole_2.7mm_M2.5" H 9600 5100 50  0001 C CNN
F 3 "~" H 9600 5100 50  0001 C CNN
F 4 "50M025045G008" H 9600 5100 50  0001 C CNN "Part"
F 5 "971110155" H 9600 5100 50  0001 C CNN "Mating"
F 6 "50M025045G006" H 9600 5100 50  0001 C CNN "Alternate part"
	1    9600 5100
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H2
U 1 1 60841D9C
P 8800 5100
F 0 "H2" H 8900 5146 50  0000 L CNN
F 1 "2.75mm Mount" H 8900 5055 50  0000 L CNN
F 2 "MountingHole:MountingHole_2.7mm_M2.5" H 8800 5100 50  0001 C CNN
F 3 "~" H 8800 5100 50  0001 C CNN
F 4 "50M025045G008" H 8800 5100 50  0001 C CNN "Part"
F 5 "971110155" H 8800 5100 50  0001 C CNN "Mating"
F 6 "50M025045G006" H 8800 5100 50  0001 C CNN "Alternate part"
	1    8800 5100
	1    0    0    -1  
$EndComp
$Comp
L Connector:282856-2 J1
U 1 1 6083B1AC
P 4250 2950
F 0 "J1" H 4480 3046 50  0000 L CNN
F 1 "282856-2" H 4480 2955 50  0000 L CNN
F 2 "TE_282856-2" H 4250 2950 50  0001 L BNN
F 3 "" H 4250 2950 50  0001 L BNN
F 4 "Compliant with Exemptions" H 4250 2950 50  0001 L BNN "EU_RoHS_Compliance"
F 5 "282856-2" H 4250 2950 50  0001 L BNN "Comment"
	1    4250 2950
	1    0    0    -1  
$EndComp
Wire Notes Line width 10 style solid
	8650 4400 8650 5300
Wire Notes Line width 10 style solid
	8650 5300 11150 5300
Wire Notes Line width 10 style solid
	11150 5300 11150 4400
Wire Notes Line width 10 style solid
	11150 4400 10350 4400
Wire Notes Line width 10 style solid
	8650 4400 9400 4400
Text Notes 9550 4450 0    79   ~ 0
Mechanical
$Comp
L power:GND #PWR029
U 1 1 6083F215
P 2300 2950
F 0 "#PWR029" H 2300 2700 50  0001 C CNN
F 1 "GND" H 2305 2777 50  0000 C CNN
F 2 "" H 2300 2950 50  0001 C CNN
F 3 "" H 2300 2950 50  0001 C CNN
	1    2300 2950
	1    0    0    -1  
$EndComp
$Comp
L power:+5VD #PWR027
U 1 1 6083F3B7
P 2300 2550
F 0 "#PWR027" H 2300 2400 50  0001 C CNN
F 1 "+5VD" H 2315 2723 50  0000 C CNN
F 2 "" H 2300 2550 50  0001 C CNN
F 3 "" H 2300 2550 50  0001 C CNN
	1    2300 2550
	1    0    0    -1  
$EndComp
Wire Wire Line
	2300 2550 2300 2600
Wire Wire Line
	2300 2900 2300 2950
Text Label 6150 2150 0    50   ~ 0
GPIO4
Wire Wire Line
	6150 2150 6700 2150
$Comp
L power:+5VD #PWR0103
U 1 1 607FB41A
P 9100 2850
F 0 "#PWR0103" H 9100 2700 50  0001 C CNN
F 1 "+5VD" H 9115 3023 50  0000 C CNN
F 2 "" H 9100 2850 50  0001 C CNN
F 3 "" H 9100 2850 50  0001 C CNN
	1    9100 2850
	1    0    0    -1  
$EndComp
Wire Wire Line
	9100 3200 9100 3400
Wire Wire Line
	9100 2850 9100 2900
$Comp
L Device:R_US R13
U 1 1 60783F5A
P 9100 3050
F 0 "R13" H 9168 3096 50  0000 L CNN
F 1 "2k2" H 9168 3005 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric_Pad0.98x0.95mm_HandSolder" V 9140 3040 50  0001 C CNN
F 3 "~" H 9100 3050 50  0001 C CNN
F 4 "CRGP0603F2K2" H 9100 3050 50  0001 C CNN "Part"
	1    9100 3050
	1    0    0    -1  
$EndComp
$Comp
L Switch:SW_Push SW1
U 1 1 60782D8F
P 9500 3400
F 0 "SW1" H 9500 3550 50  0000 C CNN
F 1 "TL3305AF160QG" H 9500 3350 30  0000 C CNN
F 2 "Button_Switch_SMD:TL3305AF160QG" H 9500 3600 50  0001 C CNN
F 3 "~" H 9500 3600 50  0001 C CNN
F 4 "TL3305AF160QG" H 9500 3400 50  0001 C CNN "Part"
	1    9500 3400
	1    0    0    -1  
$EndComp
Wire Wire Line
	9100 3400 9300 3400
Text Label 9100 3400 0    50   ~ 0
GPIO4
$Comp
L Device:R_US R2
U 1 1 60873EEF
P 3200 6900
F 0 "R2" V 3100 6800 50  0000 C CNN
F 1 "10k" V 3150 7050 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric_Pad0.98x0.95mm_HandSolder" V 3240 6890 50  0001 C CNN
F 3 "~" H 3200 6900 50  0001 C CNN
F 4 "ERJ-PA3J103V" V 3200 6900 50  0001 C CNN "Part"
	1    3200 6900
	0    1    1    0   
$EndComp
Wire Wire Line
	7600 4800 7600 4850
$Comp
L power:+BATT #PWR025
U 1 1 6077FADA
P 7600 4800
F 0 "#PWR025" H 7600 4650 50  0001 C CNN
F 1 "+BATT" H 7615 4973 50  0000 C CNN
F 2 "" H 7600 4800 50  0001 C CNN
F 3 "" H 7600 4800 50  0001 C CNN
	1    7600 4800
	1    0    0    -1  
$EndComp
$Comp
L battery_cell:Battery_Cell BT1
U 1 1 60793B58
P 7600 5400
F 0 "BT1" H 7718 5496 50  0000 L CNN
F 1 "1632" H 7718 5405 50  0000 L CNN
F 2 "Battery:Vertical_16mm_coin_holder" V 7600 5460 50  0001 C CNN
F 3 "~" V 7600 5460 50  0001 C CNN
F 4 "Keystone 1069" H 7600 5400 50  0001 C CNN "Part"
	1    7600 5400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR026
U 1 1 6076ECBE
P 7600 5550
F 0 "#PWR026" H 7600 5300 50  0001 C CNN
F 1 "GND" H 7605 5377 50  0000 C CNN
F 2 "" H 7600 5550 50  0001 C CNN
F 3 "" H 7600 5550 50  0001 C CNN
	1    7600 5550
	1    0    0    -1  
$EndComp
Wire Wire Line
	7600 5500 7600 5550
$Comp
L Simulation_SPICE:DIODE D3
U 1 1 6087BE9B
P 7600 5000
F 0 "D3" V 7646 4920 50  0000 R CNN
F 1 "BAV5004WS-7" V 7555 4920 50  0000 R CNN
F 2 "Diode_SMD:D_SOD-323" H 7600 5000 50  0001 C CNN
F 3 "~" H 7600 5000 50  0001 C CNN
F 4 "Y" H 7600 5000 50  0001 L CNN "Spice_Netlist_Enabled"
F 5 "D" H 7600 5000 50  0001 L CNN "Spice_Primitive"
	1    7600 5000
	0    -1   -1   0   
$EndComp
Wire Wire Line
	7600 5200 7600 5150
$Comp
L Device:R_US R5
U 1 1 60893719
P 7200 5100
F 0 "R5" H 7268 5146 50  0000 L CNN
F 1 "2k2" H 7268 5055 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric_Pad0.98x0.95mm_HandSolder" V 7240 5090 50  0001 C CNN
F 3 "CRGP0603F2K2" H 7200 5100 50  0001 C CNN
	1    7200 5100
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR030
U 1 1 60894AD9
P 7200 4900
F 0 "#PWR030" H 7200 4750 50  0001 C CNN
F 1 "+3.3V" H 7215 5073 50  0000 C CNN
F 2 "" H 7200 4900 50  0001 C CNN
F 3 "" H 7200 4900 50  0001 C CNN
	1    7200 4900
	1    0    0    -1  
$EndComp
Wire Wire Line
	6600 5250 7200 5250
Wire Wire Line
	7200 4950 7200 4900
$Comp
L Device:C C2
U 1 1 608BE54D
P 1850 2750
F 0 "C2" H 1965 2780 50  0000 L CNN
F 1 "100u" H 1965 2704 50  0000 L CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.33x1.80mm_HandSolder" H 1888 2600 50  0001 C CNN
F 3 "~" H 1850 2750 50  0001 C CNN
F 4 "GMC31X5R107M10NT" H 1850 2750 50  0001 C CNN "Part"
	1    1850 2750
	1    0    0    -1  
$EndComp
$Comp
L Device:C C3
U 1 1 608BE958
P 2300 2750
F 0 "C3" H 2415 2780 50  0000 L CNN
F 1 "100u" H 2415 2704 50  0000 L CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.33x1.80mm_HandSolder" H 2338 2600 50  0001 C CNN
F 3 "~" H 2300 2750 50  0001 C CNN
F 4 "GMC31X5R107M10NT" H 2300 2750 50  0001 C CNN "Part"
	1    2300 2750
	1    0    0    -1  
$EndComp
$Comp
L Device:C C4
U 1 1 60875735
P 9100 3600
F 0 "C4" H 9215 3646 50  0000 L CNN
F 1 "10u" H 9215 3555 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric_Pad1.08x0.95mm_HandSolder" H 9138 3450 50  0001 C CNN
F 3 "~" H 9100 3600 50  0001 C CNN
F 4 "Something that's like 10u" H 9100 3600 50  0001 C CNN "Part"
	1    9100 3600
	1    0    0    -1  
$EndComp
Wire Wire Line
	9100 3450 9100 3400
Connection ~ 9100 3400
$Comp
L power:GND #PWR031
U 1 1 60878A93
P 9100 3800
F 0 "#PWR031" H 9100 3550 50  0001 C CNN
F 1 "GND" H 9105 3627 50  0000 C CNN
F 2 "" H 9100 3800 50  0001 C CNN
F 3 "" H 9100 3800 50  0001 C CNN
	1    9100 3800
	1    0    0    -1  
$EndComp
Wire Wire Line
	9100 3750 9100 3800
Wire Notes Line width 10 style solid
	8750 4050 10950 4050
Wire Notes Line width 10 style solid
	8750 2600 8750 4050
Wire Notes Line width 10 style solid
	10950 2600 10950 4050
$EndSCHEMATC
