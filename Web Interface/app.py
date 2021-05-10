'''
app.py

Description
-----------
These functions are executed when requested by a client connected in a web browser to the address/port defined in this script.

Functions Defined
------------------
get_incline: Gets a single reading from the inclinometer 
    Parameters: None
    Returns: String containing the pitch, roll, and temperature of inclinometer
    
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
import json
import subprocess
from flask import Flask, render_template, request, jsonify, send_file

##################################################################################################
# # Global Variables 
##################################################################################################

#Define the address and port this server will run on
ip = "192.168.69.1"
server_port = 5000


#State variables
noflowantonio = False
pump_timed_on = False
pump_timed_off = True
pump_scheduled = False
pump_single_run = False
pump_button_on = False
pump_button_off = False

#Schedule variables
sched_on = 0
sched_off = 0
single_on = 0
single_off = 0

sensors = {
    1 : {'name' : 'Time', 'data' : 'None'},
    2 : {'name' : 'Flow', 'data' : 'None'}
}

mode = {
    1 : {'name' : 'Button', 'data' : 'None'},
    1 : {'name' : 'Single', 'data' : 'None'},
    1 : {'name' : 'Flow', 'data' : 'None'},
    2 : {'name' : 'Schedule', 'data' : 'None'}
}

app = Flask(__name__)

##################################################################################################
# # Function Definitions/Client Routing
##################################################################################################

def startPump():
    #GPIO 18 high for 15ms
    pass

def stopPump():
    #GPIO14 high for 15ms
    pass

def synctime():
    pass

def setRTC():
    pass

def readFlowMeter():
    # Place holder to remind me
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
        'sensors' : sensors,
        #'mode' : ,
        }
    # Pass the template data into the template main.html and return it to the user
    return render_template('main.html', **templateData)

@app.route("/setSchedule", methods=['GET', 'POST'])
def setSchedule(): 
    if request.method == 'POST':
        try:
            sched_on = int(request.form['scheduleon'])
            if curr_time >= sched_on:
                startPump()
        except:
            pass
      
        try:
            sched_off = int(request.form['scheduleoff'])
            if curr_time >= sched_off:
                stopPump()
        except:
            pass
        
    templateData = {
        'curr_on' : sched_on,
        'curr_off' : sched_off
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
    loginfo = {
    }

    if request.method == 'POST':
        requested = request.form['req_log']

        if not requested == 'none':
            #TODO

    return render_template('.html', **(logs), **loginfo)
   
@app.after_request
def add_header(r):
    """
    Description
    -----------
    This function prevents sensor data from being stored by the browser. This is in place because some sensor data was being loaded from local caches rather than taking data in real-time from the sensor. 
    
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
    Taylor Zinke: Taylor.Zinke@lynntech.com
    
    Notes
    -----
    """ 


    r.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    r.headers["Pragma"] = "no-cache"
    r.headers["Expires"] = "0"
    r.headers['Cache-Control'] = 'public, max-age=0'
    return r

if __name__ == "__main__":
    app.run(host=ip, port=server_port, debug=True, use_reloader=True)
