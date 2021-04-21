EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date "2021-04-15"
Rev ""
Comp ""
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
P 2300 6000
F 0 "K1" H 2300 6467 50  0000 C CNN
F 1 "ADW1205HLW" H 2300 6376 50  0000 C CNN
F 2 "RELAY_ADW1205HLW" H 2300 6000 50  0001 L BNN
F 3 "" H 2300 6000 50  0001 L BNN
F 4 "Manufacturer Recommendation" H 2300 6000 50  0001 L BNN "STANDARD"
F 5 "Panasonic" H 2300 6000 50  0001 L BNN "MANUFACTURER"
	1    2300 6000
	1    0    0    -1  
$EndComp
$Comp
L Relay:ADW1205HLW K2
U 1 1 6075A92C
P 4450 6000
F 0 "K2" H 4450 6467 50  0000 C CNN
F 1 "ADW1205HLW" H 4450 6376 50  0000 C CNN
F 2 "RELAY_ADW1205HLW" H 4450 6000 50  0001 L BNN
F 3 "" H 4450 6000 50  0001 L BNN
F 4 "Manufacturer Recommendation" H 4450 6000 50  0001 L BNN "STANDARD"
F 5 "Panasonic" H 4450 6000 50  0001 L BNN "MANUFACTURER"
	1    4450 6000
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
Text Label 2800 5900 0    50   ~ 0
Line1_in
Text Label 2800 6100 0    50   ~ 0
Line1_out
Text Label 4950 5900 0    50   ~ 0
Line2_in
Text Label 4950 6100 0    50   ~ 0
Line2_out
Wire Wire Line
	2700 5900 2800 5900
Wire Wire Line
	2700 6100 2800 6100
Wire Wire Line
	4850 5900 4950 5900
Wire Wire Line
	4950 6100 4850 6100
$Comp
L power:+5VD #PWR03
U 1 1 60761BD8
P 1500 6000
F 0 "#PWR03" H 1500 5850 50  0001 C CNN
F 1 "+5VD" H 1515 6173 50  0000 C CNN
F 2 "" H 1500 6000 50  0001 C CNN
F 3 "" H 1500 6000 50  0001 C CNN
	1    1500 6000
	1    0    0    -1  
$EndComp
$Comp
L power:+5VD #PWR011
U 1 1 60761CCD
P 3650 6000
F 0 "#PWR011" H 3650 5850 50  0001 C CNN
F 1 "+5VD" H 3665 6173 50  0000 C CNN
F 2 "" H 3650 6000 50  0001 C CNN
F 3 "" H 3650 6000 50  0001 C CNN
	1    3650 6000
	1    0    0    -1  
$EndComp
Text Label 1650 5800 0    50   ~ 0
Set
Text Label 1650 6200 0    50   ~ 0
Reset
Wire Wire Line
	1650 6200 1900 6200
Wire Wire Line
	1500 6000 1900 6000
Wire Wire Line
	1650 5800 1900 5800
Text Label 3800 5800 0    50   ~ 0
Set
Text Label 3800 6200 0    50   ~ 0
Reset
Wire Wire Line
	3800 6200 4050 6200
Wire Wire Line
	3800 5800 4050 5800
Wire Wire Line
	3650 6000 4050 6000
$Comp
L power:GND #PWR06
U 1 1 607398A0
P 2600 7000
F 0 "#PWR06" H 2600 6750 50  0001 C CNN
F 1 "GND" H 2605 6827 50  0000 C CNN
F 2 "" H 2600 7000 50  0001 C CNN
F 3 "" H 2600 7000 50  0001 C CNN
	1    2600 7000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR012
U 1 1 60739A87
P 4150 7000
F 0 "#PWR012" H 4150 6750 50  0001 C CNN
F 1 "GND" H 4155 6827 50  0000 C CNN
F 2 "" H 4150 7000 50  0001 C CNN
F 3 "" H 4150 7000 50  0001 C CNN
	1    4150 7000
	1    0    0    -1  
$EndComp
Text Label 4150 6500 0    50   ~ 0
Reset
Text Label 2600 6500 0    50   ~ 0
Set
$Comp
L Transistor_FET:DMN67D7L Q1
U 1 1 6073EED8
P 2500 6750
F 0 "Q1" H 2705 6796 50  0000 L CNN
F 1 "DMN67D7L" H 2705 6705 50  0000 L CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 2700 6675 50  0001 L CIN
F 3 "http://www.diodes.com/assets/Datasheets/DMN67D7L.pdf" H 2500 6750 50  0001 L CNN
	1    2500 6750
	1    0    0    -1  
$EndComp
$Comp
L Transistor_FET:DMN67D7L Q2
U 1 1 607417BF
P 4050 6750
F 0 "Q2" H 4255 6796 50  0000 L CNN
F 1 "DMN67D7L" H 4255 6705 50  0000 L CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 4250 6675 50  0001 L CIN
F 3 "http://www.diodes.com/assets/Datasheets/DMN67D7L.pdf" H 4050 6750 50  0001 L CNN
	1    4050 6750
	1    0    0    -1  
$EndComp
Wire Wire Line
	2600 6950 2600 7000
Wire Wire Line
	2600 6550 2600 6500
Wire Wire Line
	4150 6500 4150 6550
Wire Wire Line
	4150 6950 4150 7000
$Comp
L Simulation_SPICE:DIODE D1
U 1 1 60746E8D
P 2750 5000
F 0 "D1" V 2796 4920 50  0000 R CNN
F 1 "BAV5004WS-7" V 2705 4920 50  0000 R CNN
F 2 "Diode_SMD:D_SOD-323" H 2750 5000 50  0001 C CNN
F 3 "~" H 2750 5000 50  0001 C CNN
F 4 "Y" H 2750 5000 50  0001 L CNN "Spice_Netlist_Enabled"
F 5 "D" H 2750 5000 50  0001 L CNN "Spice_Primitive"
	1    2750 5000
	0    -1   -1   0   
$EndComp
$Comp
L Simulation_SPICE:DIODE D3
U 1 1 607487ED
P 3600 5000
F 0 "D3" V 3646 4920 50  0000 R CNN
F 1 "BAV5004WS-7" V 3555 4920 50  0000 R CNN
F 2 "Diode_SMD:D_SOD-323" H 3600 5000 50  0001 C CNN
F 3 "~" H 3600 5000 50  0001 C CNN
F 4 "Y" H 3600 5000 50  0001 L CNN "Spice_Netlist_Enabled"
F 5 "D" H 3600 5000 50  0001 L CNN "Spice_Primitive"
	1    3600 5000
	0    -1   -1   0   
$EndComp
Text Label 2750 5250 0    50   ~ 0
Set
Text Label 3600 5250 0    50   ~ 0
Reset
$Comp
L power:+5VD #PWR09
U 1 1 6074922C
P 2750 4800
F 0 "#PWR09" H 2750 4650 50  0001 C CNN
F 1 "+5VD" H 2765 4973 50  0000 C CNN
F 2 "" H 2750 4800 50  0001 C CNN
F 3 "" H 2750 4800 50  0001 C CNN
	1    2750 4800
	1    0    0    -1  
$EndComp
$Comp
L power:+5VD #PWR010
U 1 1 607499BC
P 3600 4800
F 0 "#PWR010" H 3600 4650 50  0001 C CNN
F 1 "+5VD" H 3615 4973 50  0000 C CNN
F 2 "" H 3600 4800 50  0001 C CNN
F 3 "" H 3600 4800 50  0001 C CNN
	1    3600 4800
	1    0    0    -1  
$EndComp
Wire Wire Line
	2750 5250 2750 5150
Wire Wire Line
	2750 4850 2750 4800
Wire Wire Line
	3600 4850 3600 4800
Wire Wire Line
	3600 5150 3600 5250
Wire Notes Line width 10 style solid
	5600 4400 3950 4400
Wire Notes Line width 10 style solid
	5600 4400 5600 7250
Wire Notes Line width 10 style solid
	5600 7250 1250 7250
Wire Notes Line width 10 style solid
	1250 7250 1250 4400
Wire Notes Line width 10 style solid
	1250 4400 2550 4400
Text Notes 2750 4450 0    79   ~ 0
Switching Circuit
$Comp
L Connector_Generic:Conn_02x20_Odd_Even J4
U 1 1 60782B1C
P 6900 2750
F 0 "J4" H 6950 3375 50  0000 C CNN
F 1 "Conn_02x20_Odd_Even" H 6950 3376 50  0001 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x20_P2.54mm_Vertical" H 6900 2750 50  0001 C CNN
F 3 "~" H 6900 2750 50  0001 C CNN
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
L Diode:Generic_Diode D2
U 1 1 607648B8
P 2950 2150
F 0 "D2" V 3180 2046 60  0000 R CNN
F 1 "LL4150GS18" V 3097 2046 30  0000 R CNN
F 2 "Diode_SMD:D_SOD-80" H 3150 1790 60  0001 C CNN
F 3 "" H 2950 2150 60  0000 C CNN
	1    2950 2150
	0    -1   -1   0   
$EndComp
$Comp
L Device:C C2
U 1 1 6076B152
P 2100 2750
F 0 "C2" H 2215 2780 50  0000 L CNN
F 1 "100u" H 2215 2704 50  0000 L CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.33x1.80mm_HandSolder" H 2138 2600 50  0001 C CNN
F 3 "GMC31X5R107M10NT" H 2100 2750 50  0001 C CNN
	1    2100 2750
	1    0    0    -1  
$EndComp
Wire Wire Line
	2950 1750 2800 1750
Connection ~ 2800 1750
Wire Wire Line
	2950 2150 2800 2150
Connection ~ 2800 2150
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
P 2100 2550
F 0 "#PWR04" H 2100 2400 50  0001 C CNN
F 1 "+5VD" H 2115 2723 50  0000 C CNN
F 2 "" H 2100 2550 50  0001 C CNN
F 3 "" H 2100 2550 50  0001 C CNN
	1    2100 2550
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
P 2100 2950
F 0 "#PWR05" H 2100 2700 50  0001 C CNN
F 1 "GND" H 2105 2777 50  0000 C CNN
F 2 "" H 2100 2950 50  0001 C CNN
F 3 "" H 2100 2950 50  0001 C CNN
	1    2100 2950
	1    0    0    -1  
$EndComp
Wire Wire Line
	1400 2900 1400 2950
Wire Wire Line
	1400 2600 1400 2550
Wire Wire Line
	2100 2550 2100 2600
Wire Wire Line
	2100 2900 2100 2950
$Comp
L Timer_RTC:RX8900UA U1
U 1 1 6077CD48
P 7750 5050
F 0 "U1" H 8050 5215 50  0000 C CNN
F 1 "RX8900UA" H 8050 5124 50  0000 C CNN
F 2 "Package_SO:SOP-14_127P780x200" H 7850 4200 50  0001 C CNN
F 3 "" H 7850 4200 50  0001 C CNN
	1    7750 5050
	1    0    0    -1  
$EndComp
$Comp
L power:+5VD #PWR019
U 1 1 6077EE23
P 8550 5050
F 0 "#PWR019" H 8550 4900 50  0001 C CNN
F 1 "+5VD" H 8565 5223 50  0000 C CNN
F 2 "" H 8550 5050 50  0001 C CNN
F 3 "" H 8550 5050 50  0001 C CNN
	1    8550 5050
	1    0    0    -1  
$EndComp
$Comp
L power:+BATT #PWR025
U 1 1 6077FADA
P 9450 5150
F 0 "#PWR025" H 9450 5000 50  0001 C CNN
F 1 "+BATT" H 9465 5323 50  0000 C CNN
F 2 "" H 9450 5150 50  0001 C CNN
F 3 "" H 9450 5150 50  0001 C CNN
	1    9450 5150
	1    0    0    -1  
$EndComp
$Comp
L power:+BATT #PWR021
U 1 1 6077FF39
P 8700 5150
F 0 "#PWR021" H 8700 5000 50  0001 C CNN
F 1 "+BATT" H 8715 5323 50  0000 C CNN
F 2 "" H 8700 5150 50  0001 C CNN
F 3 "" H 8700 5150 50  0001 C CNN
	1    8700 5150
	1    0    0    -1  
$EndComp
Wire Wire Line
	8450 5150 8550 5150
Wire Wire Line
	8550 5150 8550 5050
Wire Wire Line
	8450 5250 8700 5250
Wire Wire Line
	8700 5150 8700 5250
$Comp
L power:GND #PWR020
U 1 1 60785E37
P 8550 5700
F 0 "#PWR020" H 8550 5450 50  0001 C CNN
F 1 "GND" H 8555 5527 50  0000 C CNN
F 2 "" H 8550 5700 50  0001 C CNN
F 3 "" H 8550 5700 50  0001 C CNN
	1    8550 5700
	1    0    0    -1  
$EndComp
Wire Wire Line
	8450 5650 8550 5650
Wire Wire Line
	8550 5650 8550 5700
Wire Wire Line
	9450 5500 9450 5550
Wire Wire Line
	9450 5150 9450 5200
$Comp
L power:GND #PWR026
U 1 1 6076ECBE
P 9450 5550
F 0 "#PWR026" H 9450 5300 50  0001 C CNN
F 1 "GND" H 9455 5377 50  0000 C CNN
F 2 "" H 9450 5550 50  0001 C CNN
F 3 "" H 9450 5550 50  0001 C CNN
	1    9450 5550
	1    0    0    -1  
$EndComp
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
Text Label 7100 5250 0    50   ~ 0
GPIO2(SDA1)
Text Label 7100 5150 0    50   ~ 0
GPIO3(SCL1)
Wire Wire Line
	7100 5150 7650 5150
Wire Wire Line
	7650 5250 7100 5250
Text Label 8550 5450 0    50   ~ 0
RTC_~INT~
Wire Wire Line
	8450 5450 8550 5450
$Comp
L power:GND #PWR017
U 1 1 6078C49E
P 7500 5550
F 0 "#PWR017" H 7500 5300 50  0001 C CNN
F 1 "GND" H 7505 5377 50  0000 C CNN
F 2 "" H 7500 5550 50  0001 C CNN
F 3 "" H 7500 5550 50  0001 C CNN
	1    7500 5550
	1    0    0    -1  
$EndComp
Wire Wire Line
	7500 5550 7500 5450
Wire Wire Line
	7500 5450 7650 5450
NoConn ~ 7650 5550
Wire Notes Line width 10 style solid
	9300 4600 10300 4600
Wire Notes Line width 10 style solid
	10300 4600 10300 6050
Wire Notes Line width 10 style solid
	10300 6050 7000 6050
Wire Notes Line width 10 style solid
	7000 6050 7000 4600
Wire Notes Line width 10 style solid
	7000 4600 8150 4600
Text Notes 8200 4650 0    79   ~ 0
Real-Time Clock
Wire Notes Line width 10 style solid
	5850 1200 5300 1200
Text Notes 5850 1250 0    79   ~ 0
Raspberry Pi Zero W Interface
Wire Notes Line width 10 style solid
	8250 1200 7700 1200
Wire Wire Line
	3850 3050 3450 3050
Wire Wire Line
	3450 2850 3850 2850
Wire Wire Line
	3850 2400 3450 2400
Wire Wire Line
	3450 2300 3850 2300
Text Label 3450 3050 0    50   ~ 0
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
L Connector:1935161 J1
U 1 1 6075587C
P 4150 2950
F 0 "J1" H 4280 2996 50  0000 L CNN
F 1 "1935161" H 4280 2905 50  0000 L CNN
F 2 "PHOENIX_1935161" H 4150 2950 50  0001 L BNN
F 3 "" H 4150 2950 50  0001 L BNN
F 4 "Phoenix Contact" H 4150 2950 50  0001 L BNN "MANUFACTURER"
	1    4150 2950
	1    0    0    -1  
$EndComp
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
F 3 "GMC31X5R107M10NT" H 1400 2750 50  0001 C CNN
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
P 2250 6950
F 0 "R1" V 2150 6850 50  0000 C CNN
F 1 "1k" V 2200 7100 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric_Pad0.98x0.95mm_HandSolder" V 2290 6940 50  0001 C CNN
F 3 "RMCF0603FG1K00" H 2250 6950 50  0001 C CNN
	1    2250 6950
	0    1    1    0   
$EndComp
$Comp
L Device:R_US R2
U 1 1 608D5929
P 3800 6950
F 0 "R2" V 3700 6850 50  0000 C CNN
F 1 "1k" V 3750 7100 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric_Pad0.98x0.95mm_HandSolder" V 3840 6940 50  0001 C CNN
F 3 "RMCF0603FG1K00" H 3800 6950 50  0001 C CNN
	1    3800 6950
	0    1    1    0   
$EndComp
Wire Wire Line
	3650 6950 3550 6950
Wire Wire Line
	3550 6950 3550 6750
Wire Wire Line
	3550 6750 3850 6750
Wire Wire Line
	3950 6950 4150 6950
Connection ~ 4150 6950
Wire Wire Line
	2600 6950 2400 6950
Connection ~ 2600 6950
Wire Wire Line
	2100 6950 2000 6950
Wire Wire Line
	2000 6950 2000 6750
Wire Wire Line
	2000 6750 2300 6750
Text Label 7800 2150 0    50   ~ 0
RLY_S
Text Label 2000 6750 0    50   ~ 0
RLY_S
Text Label 3550 6750 0    50   ~ 0
RLY_R
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
L Switch:SW_Push SW1
U 1 1 60782D8F
P 9250 3450
F 0 "SW1" H 9250 3600 50  0000 C CNN
F 1 "TL3305AF160QG" H 9250 3400 30  0000 C CNN
F 2 "Button_Switch_SMD:TL3305AF160QG" H 9250 3650 50  0001 C CNN
F 3 "~" H 9250 3650 50  0001 C CNN
F 4 "TL3305AF160QG" H 9250 3450 50  0001 C CNN "Part"
	1    9250 3450
	1    0    0    -1  
$EndComp
$Comp
L Device:R_US R13
U 1 1 60783F5A
P 8900 3100
F 0 "R13" H 8968 3146 50  0000 L CNN
F 1 "2k2" H 8968 3055 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric_Pad0.98x0.95mm_HandSolder" V 8940 3090 50  0001 C CNN
F 3 "~" H 8900 3100 50  0001 C CNN
F 4 "CRGP0603F2K2" H 8900 3100 50  0001 C CNN "Part"
	1    8900 3100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0101
U 1 1 60792042
P 9500 3500
F 0 "#PWR0101" H 9500 3250 50  0001 C CNN
F 1 "GND" H 9505 3327 50  0000 C CNN
F 2 "" H 9500 3500 50  0001 C CNN
F 3 "" H 9500 3500 50  0001 C CNN
	1    9500 3500
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
	8900 2900 8900 2950
Wire Wire Line
	8900 3250 8900 3450
Wire Wire Line
	8900 3450 9050 3450
Wire Wire Line
	9450 3450 9500 3450
Wire Wire Line
	9500 3450 9500 3500
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
Wire Notes Line width 10 style solid
	8750 2600 8750 3750
Wire Notes Line width 10 style solid
	8750 3750 10950 3750
Wire Notes Line width 10 style solid
	10950 3750 10950 2600
Text Notes 9400 2700 0    79   ~ 0
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
$Comp
L battery_cell:Battery_Cell BT1
U 1 1 60793B58
P 9450 5400
F 0 "BT1" H 9568 5496 50  0000 L CNN
F 1 "1632" H 9568 5405 50  0000 L CNN
F 2 "Battery:Vertical_16mm_coin_holder" V 9450 5460 50  0001 C CNN
F 3 "~" V 9450 5460 50  0001 C CNN
F 4 "Keystone 1069" H 9450 5400 50  0001 C CNN "Part"
	1    9450 5400
	1    0    0    -1  
$EndComp
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
$Comp
L power:+5VD #PWR0103
U 1 1 607FB41A
P 8900 2900
F 0 "#PWR0103" H 8900 2750 50  0001 C CNN
F 1 "+5VD" H 8915 3073 50  0000 C CNN
F 2 "" H 8900 2900 50  0001 C CNN
F 3 "" H 8900 2900 50  0001 C CNN
	1    8900 2900
	1    0    0    -1  
$EndComp
Wire Wire Line
	7800 2350 7200 2350
Text Label 7800 2350 0    50   ~ 0
RLY_R
Wire Wire Line
	7200 2150 7800 2150
NoConn ~ 6700 2150
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
$EndSCHEMATC
