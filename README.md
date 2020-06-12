# Pool Pump Timer Instructions
A timer for my pool pump using a PIC12 microcontroller and a custom-made PCB. I made this pump timer myself for fun and to save some money vs buying a commercial one. 

These are the instructions for use for whoever lives in our house after us.

Also, might go without saying, but everything is exposed here (including a 220-volt drop between two of the wires at the bottom of the timer). **DO NOT TOUCH ANY OF THOSE WIRES WITHOUT TURNING THE BREAKER OFF**.

The timer has two buttons; the top button subtracts an hour from the daily run-time if pressed and overrides the timer so the pump is OFF if held, and the bottom button adds an hour to the daily run-time if pressed and overrides the timer so the pump is ON if held.

![Button to reduce pump run-time by 1 hour (press) or override the timer to turn the pump off (hold)](/images/rst_override.jpg)

**Button to reduce pump run-time by 1 hour (press) or override the timer to turn the pump off (hold)**

![Button to increase pump run-time by 1 hour (press) or override the timer to turn the pump off (hold)](/images/add_check.jpg)

**Button to increase pump run-time by 1 hour (press) or override the timer to turn the pump off (hold)**

Each time you change the daily run-time by pressing one of the buttons, the LEDs will light up in a sequence to tell you what the current run-time setting is. The green LED will briefly flash, then the red LED will briefly flash, then the green LED will flash once per hour of the run-time setting. For example, if the timer is set to run 5 hours per day, and you press the top button, the LEDs will flash: green (1x), red (1x), then green (4x) to indicate that you have decreased the run-time from 5 hours to 4 hours per day.

Whatever time you increase the run-time setting from 0 to 1 is the time of day that the pump will turn on each day going forward. Ex: the pump timer is currently set to 0 hours. At 9:15am, you press the bottom button to increase the setting to 1 hour/day. The pump will immediately be switched on, and will be switched on at 9:15am every day after that.

To change the time of day it switches on, decrease the run-time setting to 0, wait until the desired time of day, then increment to the desired duration.
