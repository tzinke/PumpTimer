<p>A timer for my pool pump using a Raspberry Pi Zero W and a custom-made PCB.</p>

# Pool Pump Timer Instructions

<p>This device emits its own wi-fi network which will allow you to connect to the controller and set schedules and toggle the pump on/off.</p>

<p>The name of the network is PumpController, and the password is PumpController2803Pool</p>
  
<p>This network is NOT connected to the internet, so you'll probably want to deselect auto-connect for this network (otherwise your device might automatically hop on this network and not be connected to the internet). To control the device, you will also need to turn cell data off if connecting with a phone.</p>

<p>Once connected, open a browser and navigate to pumpcontroller.com. This will pull up the controller interface.</p>

![alt text](https://github.com/tzinke/PumpTimer/blob/master/images/Screenshot_20230504-101858.png?raw=true)

<p>Here, you can set a schedule to turn the pump on/off at the same time each day, set the on-board clock, set a "one-time run" (a schedule that will only execute a single time, after which the daily schedule will resume), toggle the pump on/off manually, and view logs from the last 3 months.
The on-board clock is very accurate with little drift, but it is not configured to automatically adjust for daylight savings.</p>

<p>The device is also configured to turn the pump on for at least 10 minutes if the temperature gets too close to 32F in order to prevent equipment damage from freezes.
The on-board temperature sensor isn't terribly accurate, so there is an adjustment factor that you can change to get it more accurate/modify the "freeze" threshold.</p>
