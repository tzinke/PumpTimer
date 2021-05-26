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

set_single:

set_time:

toggle_pump:

fetch_log:

Change Log
----------

'''

##################################################################################################
# # Imports
##################################################################################################

import os
import time
import smbus
import datetime
import subprocess
from flask import Flask, render_template, request, send_file
import RTC
from threading import Timer

##################################################################################################
# # Global Variables
##################################################################################################

#Define the address and port this server will run on
ip = "192.168.15.1"
server_port = 5000

#Schedule and log file paths
#Schedules are written to files so the timer can resume
#   the schedule in case of temporary power outage
sched_path = "./static/schedule"
single_path = "./static/single"
log_dir = "./static/logs/"
log_path = null #Will get set to current date

#State variables
pressureFailure = False
pump_on = False
pump_scheduled = False
pump_single_run = False
lastEvent = "None" #Possible values: "button", "daily schedule", "single-run schedule", "pressure failure"
cooldown = 0 #This is to prevent overly-frequent pump-state changes. Each change will incur a 3s cooldown
mutex = 0 #This is to prevent unwanted interactions between timer and button events
pt_task_running = 0

#Schedule variables
sched_on = 0
sched_off = 0
single_on = 0
single_off = 0

#I2C variables
bus = smbus.SMBus(1)
pt_addr = 0x28

sensors = {
    1 : {'name' : 'Time', 'data' : 'None'},
    2 : {'name' : 'Pressure', 'data' : 'None'}
}

#Should refine these. What might the user want to know?
states = {
    1 : {'name' : 'Last event', 'data' : 'None'},
    1 : {'name' : 'Single set', 'data' : 'None'},
    1 : {'name' : 'Pressure', 'data' : 'None'},
    2 : {'name' : 'Schedule set', 'data' : 'None'}
}

app = Flask(__name__)

##################################################################################################
# # Function Definitions/Client Routing
##################################################################################################

def startPump():
    global pump_on, cooldown
    if cooldown is 0:
        #GPIO18 high for 15ms
        gpio.output(18, 1)
        time.sleep(0.015)
        gpio.output(18, 0)
        pump_on = True
        
        gpio.output(15,1)
        cooldown = 1
        Timer(3, cooldown_counter, ()).start()

def stopPump():
    global pump_on, cooldown
    if cooldown is 0:
        #GPIO14 high for 15ms
        gpio.output(14, 1)
        time.sleep(0.015)
        gpio.output(14, 0)
        pump_on = False
        
        gpio.output(15,1)
        cooldown = 1
        Timer(3, cooldown_counter, ()).start()

def toggle_pump():
    global lastEvent, mutex
    if mutex is 0:
        mutex = 1
        if pump_on is False:
            startPump()
        else:
            stopPump()

        mutex = 0
        lastEvent = "button"

def cooldown_counter():
    global cooldown
    cooldown = 0
    gpio.output(15,0)

def readPressure():
    #Not sure how to poll the device... no manual provided
    curr_p = int(smbus.read_block_data(pt_addr, 0))
    #sensors[1] = ?
    #Do I want to do some kind of sliding average or anything?
    
    #if pressure is below some threshold for some amount of time,
    #   turn pump off and set error flag
    timer_pt = Timer(3, readPressure, ())
    timer_pt.start()

def checkTime():
    global mutex, sensors, pt_task_running, lastEvent
    if mutex is 0:
        mutex = 1
        #Check if the current time matches sched_on, sched_off, single_on, or single_off
        #   and change pump state if necessary
        sensors[0] = rtc_get()
        currtime = sensors[0][2]*100 + sensors[0][1]

        drift = sensors[0][0] #Subtract out the seconds from timer delay so this happens on the minute
        #Correcting for drift means timer_clock and timer_pt can coincide.
        #   If drift-correction is needed, I need to adjust the timer_pt offset
        #TODO what function will delay timer_pt the least but guarantees that it fires 1.5s after 
        #   (60 - drift) without being too complex?
        if drift is not 0:
            timer_pt.cancel()
            timer_pt = Timer( , readPressure, ())
            timer_pt.start()
        
        desired_pump_state = 0
        #Using only if statements (no else or else-if) so default pump state is OFF
        #   in case user enters the same time for on/off events
        if currtime == sched_on:
            desired_pump_state = 1
            lastEvent = "daily schedule"
        if currtime == sched_off:
            desired_pump_state = 0
            lastEvent = "daily schedule"
            
        #Separate logic statements (not or'd with the statements above)
        #   to give preference to single-run schedules
        if currtime == single_on:
            desired_pump_state = 1
            lastEvent = "single-run schedule"
        if currtime == single_off:
            desired_pump_state = 0
            lastEvent = "single-run schedule"
        
        if (desired_pump_state is 1) and (pump_on is False):
            startPump()
        else if (desired_pump_state is 0) and (pump_on is True):
            stopPump()
            
        mutex = 0
        timer_clock = Timer(60 - drift, checkTime, ())
        timer_clock.start()

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
        'sensors' : sensors,
        'states' : states
        }
    # Pass the template data into the template main.html and return it to the user
    return render_template('main.html', **templateData)

@app.route("/setSchedule", methods=['GET', 'POST'])
def setSchedule():
    #Should I store this in a file on the SD card or in the RTC RAM?
    if request.method == 'POST':
        try:
            sched_on = int(request.form['scheduleon'])
            with open(sched_path, "r") as file:
                file.readline() #Do I care about the old on-time?
                old_off = int(file.readline())

            with open(sched_path, "w") as file:
                file.write(sched_on)
                file.write(old_off)

            if curr_time >= sched_on:
                startPump()
        except:
            pass

        try:
            sched_off = int(request.form['scheduleoff'])
            with open(sched_path, "r") as file:
                old_on = int(file.readline())

            with open(sched_path, "w") as file:
                file.write(old_on)
                file.write(sched_off)
            if curr_time >= sched_off:
                stopPump()
        except:
            pass

    templateData = {
        'curr_on' : sched_on,
        'curr_off' : sched_off,
        'curr_time' : sensors[0]
    }

    return render_template('setSchedule.html', **templateData)

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
    path = "PathToLog" % datetime.datetime.now() #TODO

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

    #TODO how can I send a log's contents for viewing on the webpage?
    #Put it in a multi-line string or just redirect the client to the log file on SD card?
    loginfo = {
    }

    if request.method == 'POST':
        requested = request.form['req_log']

        if not requested == 'none':
            #TODO

    return render_template('logs.html', **(logs), **loginfo)

@app.route("/setTime", methods=['GET', 'POST'])
def set_time():
    current_time = rtc_get()

    templateData = {
        'curr_SS' : current_time[0],
        'curr_MM' : current_time[1],
        'curr_HH' : current_time[2],
        'curr_dd' : current_time[3],
        'curr_mm' : current_time[4],
        'curr_yy' : current_time[5]
    }

    if request.method == 'POST':
        new_SS = request.form['new_SS'] #Do I need to cast to int?
        new_MM = request.form['new_MM']
        new_HH = request.form['new_HH']
        new_dd = request.form['new_dd']
        new_mm = request.form['new_mm']
        new_yy = request.form['new_yy']

        #TODO how do I want to check formatting and stuff?
        if new_SS == 'none':
            

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
    #Configure GPIO
    GPIO.setmode(GPIO.BCM)
    GPIO.setwarnings(False)
    GPIO.setup(18, GPIO.OUT) #set
    GPIO.setup(14, GPIO.OUT) #reset
    GPIO.setup(4, GPIO.IN) #pump-toggle button
    GPIO.setup(15, GPIO.OUT) #~btn_rdy LED
    GPIO.add_event_detect(4, GPIO.FALLING, callback=toggle_pump)

    #Start the non-interface threads 1.5s apart so they never coincide
    #   Clock timer interval = 60s; pressure timer interval = 3s
    timer_clock = Timer(0.1, readPressure, ())
    timer_pt = Timer(1.6, checkTime, ())
    timer_clock.start()
    timer_pt.start()

    #Start the interface
    app.run(host=ip, port=server_port, debug=True, use_reloader=True)
