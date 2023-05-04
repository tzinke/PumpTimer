#!/usr/bin/python3

'''
app.py

Description
-----------
These functions are executed when requested by a client connected in a web browser to the address/port defined in this script.

Functions Defined
------------------
Function: top-level description
    Parameters
    Returns: Data type + description

set_schedule:

set_one_time:

set_time:

toggle_pump:

fetch_log:

Change Log
----------
27 Apr 2023 - Temp sensor operations added.

'''

##################################################################################################
# # Imports
##################################################################################################

import glob, os
import time
import smbus
import datetime
import subprocess
from flask import Flask, render_template, request, send_file
import RPi.GPIO as GPIO
from threading import Timer, Lock
from enum import Enum

##################################################################################################
# # Global Variables
##################################################################################################

# Define the address and port this server will run on
ip = "192.168.15.1"
server_port = 80

# Schedule and log file paths
# Schedule is written to file so the timer can resume
#   the schedule and temp offset (init data) in case of power outage
#   One-time schedules will be lost in power outage
initialization_data_path = "./static/initialization_data"
log_dir = "./static/logs/"
log_recovery = "./static/logRecovery"
log_path = '' # Will get set to current date
current_day = 0

# State variables
class PumpState(Enum):
    DAILY_SCHED_ON = 1
    ONE_TIME_RUN_ON = 2
    WEB_TOGGLE_ON = 3
    BUTTON_ON = 4
    FREEZE_PROTECTION_ON = 5
    OFF = 6
current_pump_state = PumpState.OFF
pump_one_time_run = False
lastEvent = "None" # Possible values: "button", "daily schedule", "one-time schedule", "pressure failure"
lastEventTime = 0
general_cooldown = 0 # This is to prevent overly-frequent pump-state changes. Each change will incur a 3s general_cooldown
freeze_protection_cooldown = False # This is to prevent overly-frequent pump-state changes. If the freeze-protection changes pump state, it will stay so for at least 10 minutes
mutex = Lock() # This is to prevent unwanted interactions between timer and button events
sensor_temp = 0
temp_offset = 0
adjusted_temp = 0
freeze_protection_threshold = 33.5
temp_sensor_failure = False

# Schedule variables
currtime = -1
sched_on = 0
sched_off = 0
one_time_on = 0
one_time_off = 0
# Don't want one-time-run settings to remain active after completing
one_time_run_pending = 0 #0 = not pending; 1 = pending

# I2C variables
bus = smbus.SMBus(1)
rtc_addr = 0x32
temp_sensor_addr = 0x49 #todo might need to shift left 1 bit

sensors = {
    1 : {'name' : 'Time', 'data' : 'None'},
    2 : {'name' : 'Temp', 'data' : 'None'}
}

app = Flask(__name__)

##################################################################################################
# # Function Definitions/Client Routing
##################################################################################################

def rtc_set(time_string):
    """
    Description
    -----------
    This function writes to the registers of the RTC

    Parameters
    ----------
    time_string: String with the current 24-hour time formatted as
        "yyyy mm dd HH MM SS"

    Returns
    -------
    None

    Examples
    --------

    Change Log
    ----------

    Notes
    -----
    """
    currtime = datetime.datetime.strptime(time_string, "%Y %m %d %H %M %S")
    yy = currtime.year - 2000

    second= (int(currtime.second /10) * 16) + (currtime.second % 10)
    minute = (int(currtime.minute /10) * 16) + (currtime.minute % 10)
    hour = (int(currtime.hour /10) * 16) + (currtime.hour % 10)
    day = (int(currtime.day /10) * 16) + (currtime.day % 10)
    month = (int(currtime.month /10) * 16) + (currtime.month % 10)
    year = (int(yy /10) * 16) + (yy % 10)

    bus.write_i2c_block_data(rtc_addr, 0, [second, minute, hour, 1, day, month, year])

def rtc_get():
    """
    Description
    -----------
    This function reads from the registers of the RTC and sets the system time
        accordingly.

    Parameters
    ----------
    None

    Returns
    -------
    A list containing the current RTC setting

    Examples
    --------

    Change Log
    ----------

    Notes
    -----
    """
    regs = bus.read_i2c_block_data(rtc_addr, 0, 7)

    seconds = "%d" % ((int(regs[0]/16) * 10) + (regs[0] % 16))
    if int(seconds) < 10:
        seconds = "0" + seconds
    minutes = "%d" % ((int(regs[1]/16) * 10) + (regs[1] % 16))
    if int(minutes) < 10:
         minutes = "0" + minutes
    hours = "%d" % ((int(regs[2]/16) * 10) + (regs[2] % 16))
    if int(hours) < 10:
         hours = "0" + hours
    day = "%d" % ((int(regs[4]/16) * 10) + (regs[4] % 16))
    if int(day) < 10:
         day = "0" + day
    month = "%d" % ((int(regs[5]/16) * 10) + (regs[5] % 16))
    if int(month) < 10:
         month = "0" + month
    year = "%d" % ((int(regs[6]/16) * 10) + (regs[6] % 16))
    if int(year) < 10:
         year = "0" + year

    return [seconds, minutes, hours, day, month, year]

def temp_get():
    bytes = bus.read_i2c_block_data(temp_sensor_addr, 0, 2)
    temp = int(bytes[0] << 8) + int(bytes[1])
    temp = float(temp * 0.00390625)
    return temp 

def updateLog():
    with open(log_path, 'a') as log:
        log.write("%s turned pump %s at %s\n" % (lastEvent, ("OFF" if (current_pump_state is PumpState.OFF) else "ON"), lastEventTime))
        log.write("Sensed temp: %7.1f\t, Adjusted temp: %7.1f\n" % (sensor_temp, adjusted_temp))

def startPump(source):
    global current_pump_state, general_cooldown
    if general_cooldown is 0:
        # GPIO18 high for 15ms
        GPIO.output(18, 1)
        time.sleep(0.015)
        GPIO.output(18, 0)
        current_pump_state = source
        print("Pump started by %s" % source.name)

        GPIO.output(15,1)
        general_cooldown = 1
        Timer(3, general_cooldown_counter, ()).start()

def stopPump():
    global current_pump_state, general_cooldown
    if general_cooldown is 0:
        # GPIO14 high for 15ms
        GPIO.output(14, 1)
        time.sleep(0.015)
        GPIO.output(14, 0)
        current_pump_state = PumpState.OFF

        GPIO.output(15,1)
        general_cooldown = 1
        Timer(3, general_cooldown_counter, ()).start()

def toggle_pump(button):
    global lastEvent, lastEventTime, mutex

    mutex.acquire()
    if (current_pump_state is PumpState.OFF):
        startPump(PumpState.BUTTON_ON)
    else:
        stopPump()

    mutex.release()
    lastEvent = "Button"
    lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
    updateLog()

def general_cooldown_counter():
    global general_cooldown
    general_cooldown = 0
    GPIO.output(15,0)
    
def freeze_protection_cooldown_counter():
    global freeze_protection_cooldown
    freeze_protection_cooldown = False

def application_tick():
    global mutex, sensors, lastEvent, lastEventTime, currtime, sensor_temp, adjusted_temp, one_time_on, one_time_off, one_time_run_pending, current_day, log_path, freeze_protection_cooldown
    # Check if the current time matches sched_on, sched_off, one_time_on, or one_time_off
    #   and change pump state if necessary
    sensors[0] = rtc_get()
    currtime = int(sensors[0][2])*100 + int(sensors[0][1])
    
    if not temp_sensor_failure:
        sensors[1] = temp_get()
        sensor_temp = (sensors[1] * 1.8) + 32.0 
        adjusted_temp = sensor_temp + temp_offset
        print("%7.1f + %7.1f = %7.1f" % (sensor_temp, temp_offset, adjusted_temp))

    drift_correction = 60 - int(sensors[0][0]) #Subtract out the seconds from timer delay so this happens on the minute
    print("Drift correction: %d" % drift_correction)

    mutex.acquire(blocking=False)
    if mutex.locked():
        if (adjusted_temp <= freeze_protection_threshold): # Risking freeze conditions!
            print("Freeze condition detected! PumpState is %s, freeze prot cooldown is %d" % (current_pump_state.name, freeze_protection_cooldown))
            if (current_pump_state is PumpState.OFF) and (freeze_protection_cooldown is False): # Pump is not on, and the cooldown period has ended
                print("In freeze protect block")
                startPump(PumpState.FREEZE_PROTECTION_ON)
                freeze_protection_cooldown = True
                Timer(10 * 60, freeze_protection_cooldown_counter, ()).start()
                lastEvent = "Freeze protection on"
                lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                updateLog()

        else:
            desired_pump_state = current_pump_state
            lastEventBuffer = 0
            source = PumpState.OFF

            if (current_pump_state is PumpState.FREEZE_PROTECTION_ON) and (freeze_protection_cooldown is False): # Pump is on due to freeze protection, and the cooldown poweriod has ended
                desired_pump_state = 0 # Want to turn the pump off. Schedules can override this.
                lastEventBuffer = "Freeze protection off"

            # Check one-time schedule first to give preference to one-time schedules
            # Check off-times first so time-collisions will result in pump state OFF
            if one_time_run_pending is 1:
                if currtime == one_time_off:
                    desired_pump_state = 0
                    one_time_run_pending = 0 # one-time-run schedule finished
                    one_time_on = one_time_off = 0
                    lastEventBuffer = "One-time schedule"
                elif currtime == one_time_on:
                    desired_pump_state = 1
                    source = PumpState.ONE_TIME_RUN_ON
                    lastEventBuffer = "One-time schedule"
            else:
                if currtime == sched_off:
                    desired_pump_state = 0
                    lastEventBuffer = "Daily schedule"
                elif currtime == sched_on:
                    desired_pump_state = 1
                    source = PumpState.DAILY_SCHED_ON
                    lastEventBuffer = "Daily schedule"
                    
            if (desired_pump_state is 1) and (current_pump_state is PumpState.OFF):
                startPump(source)
                lastEvent = lastEventBuffer
                lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                updateLog()
            elif (desired_pump_state is 0) and (not (current_pump_state is PumpState.OFF)):
                stopPump()
                lastEvent = lastEventBuffer
                lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                updateLog()

        mutex.release()

    timer_clock = Timer(drift_correction, application_tick, ())
    timer_clock.start()

    if current_day is not int(sensors[0][3]):
        current_day = int(sensors[0][3])
        log_path = "%s%s_%s_%s" % (log_dir, sensors[0][3], sensors[0][4], sensors[0][5])

        with open(log_path, 'a') as newlog:
            newlog.write("Starting log at %s\n" % currtime)
        with open(log_recovery, 'w') as newlogrec:
            newlogrec.write("%d\n" % current_day)
            newlogrec.write(log_path)

        try:
            # Delete log from 3 months ago to remove clutter (who needs such an old log?)
            month = int(sensors[0][4])
            if month < 4:
                for f in glob.glob("%s%s_%02d*" % (log_dir, sensors[0][3], 9 + month)):
                    print("Attempting to remove log %s" % f)
                    os.remove(f)
            else:
                for f in glob.glob("%s%s_%02d*" % (log_dir, sensors[0][3], month - 3)):
                    print("Attempting to remove log %s" % f)
                    os.remove(f)
        except OSError: # Such log doesn't exist
            print("Failed to remove log!")
            pass

@app.route("/")
def main():
    """
    Description
    -----------
    This function gets called when the client navigates to "[serveraddress]/"
    (AKA the home page of the web app)

     Parameters
    ----------
    None

    Returns
    -------
    Renders the main.html page

    Examples
    --------

    Change Log
    ----------

    Notes
    -----
    """
    templateData = {
        'curr_time' : ("%s:%s %s/%s/20%s" %  (sensors[0][2], sensors[0][1], sensors[0][3], sensors[0][4], sensors[0][5])),
        'sensed_temp' : ("%4.1f" % sensor_temp),
        'estimated_temp' : ("%4.1f" % adjusted_temp),
        'sched_on' : ("%02d:%02d" % (int(sched_on/100), sched_on - (int(sched_on/100) * 100))),
        'sched_off' : ("%02d:%02d" % (int(sched_off/100), sched_off - (int(sched_off/100) * 100))),
        'once_on' : ("%02d:%02d" % (int(one_time_on/100), one_time_on - (int(one_time_on/100) * 100))),
        'once_off' : ("%02d:%02d" % (int(one_time_off/100), one_time_off - (int(one_time_off/100) * 100))),
        'last' : lastEvent,
        'lastEventTime' : lastEventTime,
        'pump_state' : ("Pump is currently OFF" if (current_pump_state is PumpState.OFF) else "Pump is currently ON")
    }
    # Pass the template data into the template main.html and return it to the user
    return render_template('main.html', **templateData)

@app.route("/setSchedule", methods=['GET', 'POST'])
def set_schedule():
    global sched_off, sched_on, lastEvent, lastEventTime
    if request.method == 'POST':
        on_time = request.form['new_on']

        if not on_time == '':
            strsplt = on_time.split(':')
            on_hh = int(strsplt[0])
            on_mm = int(strsplt[1])

            if (23 < on_hh) or (0 > on_hh):
                raise TypeError("HOUR: You must enter an integer between 0 and 23")
            elif(59 < on_mm) or (0 > on_mm):
                raise TypeError("MINUTE: You must enter an integer between 0 and 59")

            sched_on = (on_hh * 100) + on_mm

            with open(initialization_data_path, "r") as file:
                file.readline()
                old_off = int(file.readline())

            with open(initialization_data_path, "w") as file:
                file.write("%d\n" % sched_on)
                file.write("%d\n" % old_off)
                file.write("%5.1f\n" % temp_offset)
                file.write("%7.1f" % freeze_protection_threshold)

        off_time = request.form['new_off']

        if not off_time == '':
            strsplt = off_time.split(':')
            off_hh = int(strsplt[0])
            off_mm = int(strsplt[1])

            if (23 < off_hh) or (0 > off_hh):
                raise TypeError("HOUR: You must enter an integer between 0 and 23")
            elif(59 < off_mm) or (0 > off_mm):
                raise TypeError("MINUTE: You must enter an integer between 0 and 59")

            sched_off = (off_hh * 100) + off_mm

            with open(initialization_data_path, "r") as file:
                old_on = int(file.readline())

            with open(initialization_data_path, "w") as file:
                file.write("%d\n" % old_on)
                file.write("%d\n" % sched_off)
                file.write("%5.1f\n" % temp_offset)
                file.write("%7.1f" % freeze_protection_threshold)

        if (one_time_run_pending is 0):
            if sched_off < sched_on: # Wrap through midnight
                if (currtime >= sched_on) or (currtime < sched_off):
                    startPump(PumpState.DAILY_SCHED_ON)
                    print("Currtime >= sch on OR < sched_off -> pump on")
                    lastEvent = "Daily schedule"
                    lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                    updateLog()
                elif not (current_pump_state is PumpState.OFF): # Outside new schedule time + pump is on
                    stopPump()
                    print("NOT currtime >= sch on OR < sched_off -> pump off")
                    lastEvent = "Daily schedule"
                    lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                    updateLog()
            elif sched_off > sched_on:
                if (currtime >= sched_on) and (currtime < sched_off):
                    startPump(PumpState.DAILY_SCHED_ON)
                    print("Currtime >= sch on AND < sched_off -> pump on")
                    lastEvent = "Daily schedule"
                    lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                    updateLog()
                elif not (current_pump_state is PumpState.OFF): # Outside new schedule time + pump is on
                    stopPump()
                    print("NOT currtime >= sch on AND < sched_off -> pump off")
                    lastEvent = "Daily schedule"
                    lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                    updateLog()
            else: # sched_off is the same as sched_on
                lastEvent = "Daily schedule"
                lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                stopPump()
                updateLog()

    templateData = {
        'curr_time' : ("%s:%s %s/%s/20%s" %  (sensors[0][2], sensors[0][1], sensors[0][3], sensors[0][4], sensors[0][5])),
        'curr_on' : ("%02d:%02d" % (int(sched_on/100), sched_on - (int(sched_on/100) * 100))),
        'curr_off' : ("%02d:%02d" % (int(sched_off/100), sched_off - (int(sched_off/100) * 100)))
    }

    return render_template('setSchedule.html', **templateData)

@app.route("/setOneTime", methods=['GET', 'POST'])
def set_one_time_run():
    global one_time_off, one_time_on, one_time_run_pending, lastEvent, lastEventTime
    if request.method == 'POST':
        try:
            strsplt = request.form['new_on'].split(':')
            on_hh = int(strsplt[0])
            on_mm = int(strsplt[1])

            strsplt = request.form['new_off'].split(':')
            off_hh = int(strsplt[0])
            off_mm = int(strsplt[1])

            if (23 < on_hh) or (23 < off_hh) or (0 > on_hh) or (0 > off_hh):
                raise TypeError("HOUR: You must enter an integer between 0 and 23")
            elif(59 < on_mm) or (59 < off_mm) or (0 > on_mm) or (0 > off_mm):
                raise TypeError("MINUTE: You must enter an integer between 0 and 59")

            one_time_on = (on_hh * 100) + on_mm
            one_time_off = (off_hh * 100) + off_mm

            print("Got one-time on:\t%d\nOne-time off:\t%d\n" % (one_time_on, one_time_off))

            one_time_run_pending = 1
            if one_time_off < one_time_on: # Wrap through midnight
                if (currtime >= one_time_on) or (currtime < one_time_off):
                    startPump(PumpState.ON_TIME_RUN_ON)
                    print("One-time schedule includes current time. Turning pump on\n")
                    lastEvent = "One-time schedule"
                    lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                    updateLog()
                elif not (current_pump_state is PumpState.OFF):
                    stopPump()
                    print("Pump was on outside of new one-time schedule. Turning pump off\n")
                    lastEvent = "One-time schedule"
                    lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                    updateLog()
            elif one_time_off > one_time_on:
                if (currtime >= one_time_on) and (currtime < one_time_off):
                    startPump(PumpState.ONE_TIME_RUN_ON)
                    print("One-time schedule includes current time. Turning pump on\n")
                    lastEvent = "One-time schedule"
                    lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                    updateLog()
                elif not (current_pump_state is PumpState.OFF):
                    stopPump()
                    print("Pump was on outside of new one-time schedule. Turning pump off\n")
                    lastEvent = "One-time schedule"
                    lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                    updateLog()
            elif one_time_on == one_time_off:
                one_time_on, one_time_off, one_time_run_pending = 0, 0, 0
        except: # One of the times entered was not a valid integer
            one_time_on = 0
            one_time_off = 0

    templateData = {
        'curr_on' : ("%02d:%02d" % (int(one_time_on/100), one_time_on - (int(one_time_on/100) * 100))),
        'curr_off' : ("%02d:%02d" % (int(one_time_off/100), one_time_off - (int(one_time_off/100) * 100))),
        'curr_time' : ("%s:%s %s/%s/20%s" %  (sensors[0][2], sensors[0][1], sensors[0][3], sensors[0][4], sensors[0][5]))
    }

    return render_template('setOneTime.html', **templateData)

@app.route("/toggle")
def appToggle():
    global lastEvent

    if (pump_state is PumpState.OFF):
        startPump(PumpState.WEB_TOGGLE_ON)
    else:
        stopPump()

    lastEvent = "Toggled via web"
    updateLog()
    templateData = {
        'curr_time' : ("%s:%s %s/%s/20%s" %  (sensors[0][2], sensors[0][1], sensors[0][3], sensors[0][4], sensors[0][5])),
        'sched_on' : ("%02d:%02d" % (int(sched_on/100), sched_on - (int(sched_on/100) * 100))),
        'sched_off' : ("%02d:%02d" % (int(sched_off/100), sched_off - (int(sched_off/100) * 100))),
        'once_on' : ("%02d:%02d" % (int(one_time_on/100), one_time_on - (int(one_time_on/100) * 100))),
        'once_off' : ("%02d:%02d" % (int(one_time_off/100), one_time_off - (int(one_time_off/100) * 100))),
        'last' : lastEvent,
        'lastEventTime' : lastEventTime,
        'pump_state' : ("Pump is currently OFF" if (current_pump_state is PumpState.OFF) else "Pump is currently ON")
    }
    # Pass the template data into the template main.html and return it to the user
    return render_template('toggle.html', **templateData)

@app.route("/logs", methods=['GET', 'POST'])
def logs():
    """
    Description
    -----------
    This function gets called when the client navigates to "[serveraddress]/

    Parameters
    ----------
    Whether this is a GET (data to client) request or a POST (data from client) request

    Returns
    -------

    Examples
    --------

    Change Log
    ----------

    Notes
    -----
    """
    print("In get area for logs")
    available_logs = []
    for f in glob.glob("%s*" % log_dir):
        log_name = f.split('/')[3]
        #as_select_option = "<option value=\"%s\">%s</option>" % (log_name, log_name)
        as_select_option = "%s" % log_name
        print("Adding %s to list" % as_select_option)
        available_logs.append(as_select_option)

    available_logs.sort(reverse=True)
    print(available_logs)
    logs = {
        'logs' : available_logs
    }

    log_content = "No log selected"

    if request.method == 'POST':
        print("In post area for logs")
        requested = request.form['log_list']

        if not requested == '':
            requested_log_path = "%s%s" % (log_dir, requested)
            print(requested_log_path)
            with open(requested_log_path, "r") as file:
                log_content = file.read()

    return render_template('logs.html', **(logs), log_content=log_content)

@app.route("/setTime", methods=['GET', 'POST'])
def set_time():
    global sensors, currtime, lastEvent, lastEventTime
    current_time = rtc_get()

    if request.method == 'POST':
        try:
            user_input = request.form['newTime'].split('T')
            newDate = user_input[0].split('-')
            newTime = user_input[1].split(':')

            print(user_input)
            print(newDate)
            print(newTime)

            new_HH = int(newTime[0])
            new_MM = int(newTime[1])
            new_SS = 0

            new_yy = int(newDate[0]) - 2000
            new_mm = int(newDate[1])
            new_dd = int(newDate[2])
        except:
            raise Exception("You must enter a date and time in the format mm/dd/yy HH:MM:SS")

        if (59 < new_SS) or (0 > new_SS):
            raise TypeError("SECOND: You must enter an integer between 0 and 59")
        elif(59 < new_MM) or (0 > new_MM):
            raise TypeError("MINUTE: You must enter an integer between 0 and 59")
        elif(23 < new_HH) or (0 > new_HH):
            raise TypeError("HOUR: You must enter an integer between 0 and 23")
        elif(31 < new_dd) or (0 > new_dd):
            raise TypeError("DAY: You must enter an integer between 0 and 31")
        elif(12 < new_mm) or (0 > new_mm):
            raise TypeError("MONTH: You must enter an integer between 0 and 12")
        elif(99 < new_yy) or (0 > new_yy):
            raise TypeError("YEAR: You must enter an integer between 0 and 99")

        rtc_set("20%02d %02d %02d %02d %02d %02d" % (new_yy, new_mm, new_dd, new_HH, new_MM, new_SS))
        sensors[0] = rtc_get()
        currtime = int(sensors[0][2])*100 + int(sensors[0][1])

        if (one_time_run_pending is 0):
            if sched_off < sched_on: # Wrap through midnight
                if (currtime >= sched_on) or (currtime < sched_off):
                    startPump(PumpState.DAILY_SCHED_ON)
                    lastEvent = "Daily schedule"
                    lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                    updateLog()
                elif not (current_pump_state is PumpState.OFF): # Outside new schedule time + pump is on
                    stopPump()
                    lastEvent = "Daily schedule"
                    lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                    updateLog()
            elif sched_off > sched_on:
                if (currtime >= sched_on) and (currtime < sched_off):
                    startPump(PumpState.DAILY_SCHED_ON)
                    lastEvent = "Daily schedule"
                    lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                    updateLog()
                elif not (current_pump_state is PumpState.OFF): # Outside new schedule time + pump is on
                    stopPump()
                    lastEvent = "Daily schedule"
                    lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                    updateLog()
            else: # sched_off is the same as sched_on
                lastEvent = "Daily schedule"
                lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                stopPump()
                updateLog()

    templateData = {
        'curr_time' : ("%s:%s %s/%s/20%s" %  (sensors[0][2], sensors[0][1], sensors[0][3], sensors[0][4], sensors[0][5]))
    }

    return render_template('setTime.html', **templateData)
    
@app.route("/tempSensorSettings", methods=['GET', 'POST'])
def set_temp_sensor_settings():
    global temp_offset, freeze_protection_threshold
    if request.method == 'POST':
        new_offset = request.form['newOffset']

        if not (new_offset == ''):
            try:
                temp_var = float(new_offset)
                temp_offset = temp_var
            except:
                pass

        new_threshold = request.form['newThreshold']

        if not (new_threshold == ''):
            try:
                temp_var = float(new_threshold)
                freeze_protection_threshold = temp_var
            except:
                pass
                
        
        with open(initialization_data_path, "w") as file:
            file.write("%d\n" % sched_on)
            file.write("%d\n" % sched_off)
            file.write("%5.1f\n" % temp_offset)
            file.write("%7.1f" % freeze_protection_threshold)

    templateData = {
        'offset' : ("%5.1f" % temp_offset),
        'threshold' : ("%7.1f" % freeze_protection_threshold)
    }

    return render_template('tempSensorSettings.html', **templateData)

@app.after_request
def add_header(r):
    """
    Description
    -----------
    This function prevents sensor data from being stored by the browser.
    This is in place because some sensor data was being loaded from local
    caches rather than taking data in real-time from the sensor.

    Parameters
    ----------
    None

    Returns
    -------

    Examples
    --------

    Change Log
    ----------

    Authors
    -------

    Notes
    -----
    """

    r.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    r.headers["Pragma"] = "no-cache"
    r.headers["Expires"] = "0"
    r.headers['Cache-Control'] = 'public, max-age=0'
    return r

if __name__ == "__main__":
    # Configure GPIO
    GPIO.setmode(GPIO.BCM)
    GPIO.setwarnings(False)
    GPIO.setup(18, GPIO.OUT) # set
    GPIO.setup(14, GPIO.OUT) # reset
    GPIO.setup(4, GPIO.IN) # pump-toggle button
    GPIO.setup(15, GPIO.OUT) # ~btn_rdy LED
    GPIO.add_event_detect(4, GPIO.FALLING, callback=toggle_pump)

    bus.write_byte_data(temp_sensor_addr, 0x01, 0x40) # Set temp res to 11 bits (0.125 deg C)
    if not (bus.read_byte(temp_sensor_addr) == 0x40):
        temp_sensor_failure = True
        sensor_temp = "Temp Sensor Failure!"
        estimated_temp = "Temp Sensor Failure!"
        print("Failed to set or read temp sensor config register!")
    else:
        print("Temp sensor set to 11 bit resolution!")

    bus.write_byte(temp_sensor_addr, 0x00) # Set temp sensor pointer to temp value register

    with open(log_recovery, "r") as file:
        current_day = int(file.readline())
        log_path = "%s" % file.readline()

    print("Current day:\t%d\nLog_path:\t%s" % (current_day, log_path))

    # Start the non-interface threads 1.5s apart so they never coincide
    #   Clock timer interval = 60s; pressure timer interval = 3s
    timer_clock = Timer(0, application_tick, ())
    #timer_pt = Timer(1.6, readPressure, ())
    timer_clock.start()
    #timer_pt.start()

    # Wait for application_tick
    while currtime is -1:
        pass

    with open(log_path, 'a') as log:
        log.write("Powering back on at %s\n" % currtime)

    with open(initialization_data_path, "r") as file:
        sched_on = int(file.readline())
        sched_off = int(file.readline())
        temp_offset = float(file.readline())
        freeze_protection_threshold = float(file.readline())
    
    print("Daily on: %d\nDaily off: %d\nTemp offset: %5.1f" % (sched_on, sched_off, temp_offset))

    if sched_off < sched_on: # Wrap through midnight
        if (currtime >= sched_on) or (currtime < sched_off):
            startPump(PumpState.DAILY_SCHED_ON)
            print("Currtime >= sch on OR < sched_off -> pump on")
            lastEvent = "Daily schedule"
            lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
            updateLog()
    elif sched_off > sched_on:
        if (currtime >= sched_on) and (currtime < sched_off):
            startPump(PumpState.DAILY_SCHED_ON)
            print("Currtime >= sch on AND < sched_off -> pump on")
            lastEvent = "Daily schedule"
            lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
            updateLog()

    # Start the interface
    app.run(host=ip, port=server_port, debug=False, use_reloader=False)
