# Pool Pump Timer Instructions
A timer for my pool pump using a PIC12 microcontroller and a custom-made PCB

To whomever lives in our house after us:
I made this pump timer myself for fun and to save some money vs buying a commercial one. Clearly, it has no screen to tell you what's going on, so the following is meant to help you figure out how to use it.

Also, might go without saying, but everything is exposed here (including a 220-volt drop between two of the wires at the bottom of the timer) (**DO NOT TOUCH ANY OF THOSE WIRES WITHOUT TURNING THE BREAKER OFF**). Exercise caution.

The timer has two buttons; a reset/override button, and a button that increases the pump run-time by an hour/checks the current run-time setting.

The reset/override button, circled in the picture below, will reset the timer if pressed and will override the timer if held. Overriding the timer causes the pump to turn on if it is currently off and turn off if it is currently on. Turning the pump on in this way will cause it to be on until you override it again. Resetting the timer will cause the pump run-time to be 0 hours (AKA, it will not turn on until you add hours to the run-time via the other button). Once the device is reset, and until you add an hour to the run-time, the red LED will flash every 5 seconds to indicate that the pump will not turn on via the timer.

![Button to reset system (press) or override timer (hold)](/images/rst_override.jpg)

The "add/check hours" button, circled in the picture below, will increase the pump run-time by an hour if pressed. In winter, typically the pump only needs to be on about 4 hours per day, but this should increase to at least 8 hours in the summer. So, at the beginning of winter, to change from 8- to 4-hour run-time, you should press the reset/override button to reset the system, then press the "add/check hours" button four times. The green LED will briefly flash each time you press the "add/check hours" button.

![Button to increase pump run-time by 1 hour (press) or display current pump run-time setting (hold)](/images/add_check.jpg)

Holding the "add/check hours" button will cause the red LED to briefly flash, followed by the green LED flashing once per hour of the current run-time setting. For example, if you have set the timer to run for four hours, holding the "add/check hours" button will cause the following LED sequence: green LED flash (1x), red LED flash (1x), green LED flash (4x). This is just in case you forget the current setting or are unsure you added the right amount of hours.

Please note that double-pressing either of the buttons within about 1/2 second might be read as a hold. Pressing the "add/check hours" button twice in rapid succession might cause the device to show you the current hour setting, and neither of those presses will have added an hour (thus, you're two hours less than what you want).
