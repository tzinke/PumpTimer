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
Pressure transducer operations are commented out for now until the sensor is installed.

'''

# TODO use performance timer to check PT drift correction against using modulus

##################################################################################################
# # Imports
##################################################################################################

import os
import time
import smbus
import datetime
import subprocess
from flask import Flask, render_template, request, send_file
import RPi.GPIO as GPIO
from threading import Timer, Lock

##################################################################################################
# # Global Variables
##################################################################################################

# Define the address and port this server will run on
ip = "192.168.15.1"
server_port = 80

# Schedule and log file paths
# Schedule is written to file so the timer can resume
#   the schedule in case of power outage
#   One-time schedules will be lost in power outage
sched_path = "./static/schedule"
log_dir = "./static/logs/"
log_recovery = "./static/logRecovery"
log_path = '' # Will get set to current date
current_day = 0

# State variables
pressureFailure = False
pump_on = False
pump_scheduled = False
pump_one_time_run = False
lastEvent = "None" # Possible values: "button", "daily schedule", "one-time schedule", "pressure failure"
lastEventTime = 0
cooldown = 0 # This is to prevent overly-frequent pump-state changes. Each change will incur a 3s cooldown
mutex = Lock() # This is to prevent unwanted interactions between timer and button events
pt_task_running = 0

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
pt_addr = 0x28

sensors = {
    1 : {'name' : 'Time', 'data' : 'None'},
    2 : {'name' : 'Pressure', 'data' : 'None'}
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

    bus.write_i2c_block_data(0x32, 0, [second, minute, hour, 1, day, month, year])

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
    regs = bus.read_i2c_block_data(0x32, 0, 7)

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

def updateLog():
    with open(log_path, 'a') as log:
        log.write("%s turned pump %s at %s\n" % (lastEvent, ("ON" if pump_on else "OFF"), lastEventTime))

def startPump():
    global pump_on, cooldown
    if cooldown is 0:
        # GPIO18 high for 15ms
        GPIO.output(18, 1)
        time.sleep(0.015)
        GPIO.output(18, 0)
        pump_on = True

        GPIO.output(15,1)
        cooldown = 1
        Timer(3, cooldown_counter, ()).start()

def stopPump():
    global pump_on, cooldown
    if cooldown is 0:
        # GPIO14 high for 15ms
        GPIO.output(14, 1)
        time.sleep(0.015)
        GPIO.output(14, 0)
        pump_on = False

        GPIO.output(15,1)
        cooldown = 1
        Timer(3, cooldown_counter, ()).start()

def toggle_pump(button):
    global lastEvent, lastEventTime, mutex

    mutex.acquire()
    if pump_on is False:
        startPump()
    else:
        stopPump()

    mutex.release()
    lastEvent = "button"
    lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])

def cooldown_counter():
    global cooldown
    cooldown = 0
    GPIO.output(15,0)

def readPressure():
    # Not sure how to poll the device... no manual provided
    curr_p = int(smbus.read_block_data(pt_addr, 0))
    #sensors[1] = ?
    # Do I want to do some kind of sliding average or anything?

    # if pressure is below some threshold for some amount of time,
    #   turn pump off and set error flag
    #timer_pt = Timer(3, readPressure, ())
    #timer_pt.start()

def checkTime():
    global mutex, sensors, pt_task_running, lastEvent, lastEventTime, currtime, one_time_on, one_time_off, one_time_run_pending, current_day, log_path
    # Check if the current time matches sched_on, sched_off, one_time_on, or one_time_off
    #   and change pump state if necessary
    sensors[0] = rtc_get()
    currtime = int(sensors[0][2])*100 + int(sensors[0][1])

    drift_correction = 60 - int(sensors[0][0]) #Subtract out the seconds from timer delay so this happens on the minute
    print("Drift correction: %d" % drift_correction)
    # Correcting for drift means timer_clock and timer_pt can coincide.
    #   If drift-correction is needed, I need to delay timer_pt such that it will still be 1.5s off
    '''
    if drift_correction is not 0:
        timer_pt.cancel()
        div = drift_correction / 1.5
        mod = div - int(div)
        timer_pt = Timer(1.5 * mod, readPressure, ())
        timer_pt.start()
    '''

    mutex.acquire(blocking=False)
    if mutex.locked():
        desired_pump_state = pump_on
        lastEventBuffer = 0

        # Check one-time schedule first to give preference to one-time schedules
        # Check off-times first so time-collisions will result in pump state OFF
        if one_time_run_pending is 1:
            if currtime == one_time_off:
                desired_pump_state = 0
                one_time_run_pending = 0 # one-time-run schedule finished
                one_time_on = one_time_off = 0
                lastEventBuffer = "one-time schedule"
            elif currtime == one_time_on:
                desired_pump_state = 1
                lastEventBuffer = "one-time schedule"
        else:
            if currtime == sched_off:
                desired_pump_state = 0
                lastEventBuffer = "daily schedule"
            elif currtime == sched_on:
                desired_pump_state = 1
                lastEventBuffer = "daily schedule"

        if (desired_pump_state is 1) and (pump_on is False):
            startPump()
            lastEvent = lastEventBuffer
            lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
            updateLog()
        elif (desired_pump_state is 0) and (pump_on is True):
            stopPump()
            lastEvent = lastEventBuffer
            lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
            updateLog()

        mutex.release()

    timer_clock = Timer(drift_correction, checkTime, ())
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
            # Delete log from 3 months ago  to remove clutter (who needs such an old log?)
            month = int(sensors[0][4])
            if month < 4:
                os.remove("%s%s_%d*" % (log_dir, sensors[0][3], 9 + month))
            else:
                os.remove("%s%s_%d*" % (log_dir, sensors[0][3], month - 3))
        except OSError: # Such log doesn't exist
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
        'sched_on' : ("%02d:%02d" % (int(sched_on/100), sched_on - (int(sched_on/100) * 100))),
        'sched_off' : ("%02d:%02d" % (int(sched_off/100), sched_off - (int(sched_off/100) * 100))),
        'once_on' : ("%02d:%02d" % (int(one_time_on/100), one_time_on - (int(one_time_on/100) * 100))),
        'once_off' : ("%02d:%02d" % (int(one_time_off/100), one_time_off - (int(one_time_off/100) * 100))),
        'last' : lastEvent,
        'lastEventTime' : lastEventTime,
        'pump_state' : ("Pump is currently ON" if pump_on else "Pump is currently OFF")
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

            with open(sched_path, "r") as file:
                file.readline()
                old_off = int(file.readline())

            with open(sched_path, "w") as file:
                file.write("%d\n" % sched_on)
                file.write("%d" % old_off)

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

            with open(sched_path, "r") as file:
                old_on = int(file.readline())

            with open(sched_path, "w") as file:
                file.write("%d\n" % old_on)
                file.write("%d" % sched_off)

        if (one_time_run_pending is 0):
            if sched_off < sched_on: # Wrap through midnight
                if (currtime >= sched_on) or (currtime < sched_off):
                    startPump()
                    print("Currtime >= sch on OR < sched_off -> pump on")
                    lastEvent = "daily schedule"
                    lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                    updateLog()
                elif pump_on is True: # Outside new schedule time + pump is on
                    stopPump()
                    print("NOT currtime >= sch on OR < sched_off -> pump off")
                    lastEvent = "daily schedule"
                    lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                    updateLog()
            elif sched_off > sched_on:
                if (currtime >= sched_on) and (currtime < sched_off):
                    startPump()
                    print("Currtime >= sch on AND < sched_off -> pump on")
                    lastEvent = "daily schedule"
                    lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                    updateLog()
                elif pump_on is True: # Outside new schedule time + pump is on
                    stopPump()
                    print("NOT currtime >= sch on AND < sched_off -> pump off")
                    lastEvent = "daily schedule"
                    lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                    updateLog()
            else: # sched_off is the same as sched_on
                lastEvent = "daily schedule"
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
                    startPump()
                    print("One-time schedule includes current time. Turning pump on\n")
                    lastEvent = "one-time schedule"
                    lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                    updateLog()
                elif pump_on:
                    stopPump()
                    print("Pump was on outside of new one-time schedule. Turning pump off\n")
                    lastEvent = "one-time schedule"
                    lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                    updateLog()
            elif one_time_off > one_time_on:
                if (currtime >= one_time_on) and (currtime < one_time_off):
                    startPump()
                    print("One-time schedule includes current time. Turning pump on\n")
                    lastEvent = "one-time schedule"
                    lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                    updateLog()
                elif pump_on:
                    stopPump()
                    print("Pump was on outside of new one-time schedule. Turning pump off\n")
                    lastEvent = "one-time schedule"
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
    toggle_pump(0)
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
        'pump_state' : ("Pump is currently ON" if pump_on else "Pump is currently OFF")
    }
    # Pass the template data into the template main.html and return it to the user
    return render_template('toggle.html', **templateData)

@app.route("/downloadLog")
def download():
    """
    Description
    -----------
    This function gets called when the client navigates to "[serveraddress]/transfer"

    This function sends the log file for download to the client computer.

    Parameters
    ----------
    None

    Returns
    -------
    Causes the log file to be sent to the client computer

    Examples
    --------

    Change Log
    ----------

    Notes
    -----
    """
    path = "PathToLog" % datetime.datetime.now() # TODO

    return send_file(path, as_attachment=True)

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
    global options, filename

    available_logs = []
    for f in os.listdir("logs"):
        if f.endswith(".txt"):
            available_logs.append(f)

    available_logs.sort(reverse=True)
    logs = {
        'logs' : available_logs
    }

    # TODO how can I send a log's contents for viewing on the webpage?
    # Put it in a multi-line string or just redirect the client to the log file on SD card?
    loginfo = {
    }

    if request.method == 'POST':
        requested = request.form['req_log']

        if not requested == '':
            # TODO
            pass

    return render_template('logs.html', **(logs), **loginfo)

@app.route("/setTime", methods=['GET', 'POST'])
def set_time():
    global sensors, currtime, lastEvent, lastEventTime
    current_time = rtc_get()

    if request.method == 'POST':
        try:
            user_input = request.form['newTime'].split('T')
            newDate = user_input[0].split('-')
            newTime = user_input[1].split(':')

            new_HH = int(newTime[0])
            new_MM = int(newTime[1])
            new_SS = 0

            new_yy = int(newDate[0])
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
                    startPump()
                    lastEvent = "daily schedule"
                    lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                    updateLog()
                elif pump_on is True: # Outside new schedule time + pump is on
                    stopPump()
                    lastEvent = "daily schedule"
                    lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                    updateLog()
            elif sched_off > sched_on:
                if (currtime >= sched_on) and (currtime < sched_off):
                    startPump()
                    lastEvent = "daily schedule"
                    lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                    updateLog()
                elif pump_on is True: # Outside new schedule time + pump is on
                    stopPump()
                    lastEvent = "daily schedule"
                    lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                    updateLog()
            else: # sched_off is the same as sched_on
                lastEvent = "daily schedule"
                lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
                stopPump()
                updateLog()

    templateData = {
        'curr_time' : ("%s:%s %s/%s/20%s" %  (sensors[0][2], sensors[0][1], sensors[0][3], sensors[0][4], sensors[0][5]))
    }

    return render_template('setTime.html', **templateData)

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

    with open(log_recovery, "r") as file:
        current_day = int(file.readline())
        log_path = "%s" % file.readline()

    print("Current day:\t%d\nLog_path:\t%s" % (current_day, log_path))

    # Start the non-interface threads 1.5s apart so they never coincide
    #   Clock timer interval = 60s; pressure timer interval = 3s
    timer_clock = Timer(0, checkTime, ())
    #timer_pt = Timer(1.6, readPressure, ())
    timer_clock.start()
    #timer_pt.start()

    # Wait for checkTime
    while currtime is -1:
        pass

    with open(log_path, 'a') as log:
        log.write("Powering back on at %s\n" % currtime)

    with open(sched_path, "r") as file:
        sched_on = int(file.readline())
        sched_off = int(file.readline())

    if sched_off < sched_on: # Wrap through midnight
        if (currtime >= sched_on) or (currtime < sched_off):
            startPump()
            print("Currtime >= sch on OR < sched_off -> pump on")
            lastEvent = "daily schedule"
            lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
            updateLog()
    elif sched_off > sched_on:
        if (currtime >= sched_on) and (currtime < sched_off):
            startPump()
            print("Currtime >= sch on AND < sched_off -> pump on")
            lastEvent = "daily schedule"
            lastEventTime = "%s:%s" % (sensors[0][2], sensors[0][1])
            updateLog()

    # Start the interface
    app.run(host=ip, port=server_port, debug=False, use_reloader=False)
