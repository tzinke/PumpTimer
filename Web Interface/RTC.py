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

    second= (int(currtime.second /10) * 16) + (currtime.second % 10)
    minute = (int(currtime.minute /10) * 16) + (currtime.minute % 10)
    hour = (int(currtime.hour /10) * 16) + (currtime.hour % 10)
    day = (int(currtime.day /10) * 16) + (currtime.day % 10)
    month = (int(currtime.month /10) * 16) + (currtime.month % 10)
    year = (int(currtime.year /10) * 16) + (currtime.year % 10)

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

    os.system("date -s \"20%s%s%s %s:%s:%s\"" % (year, month, day, hours, minutes, seconds))
    print("20%s%s%s %s:%s:%s" % (year, month, day, hours, minutes, seconds))

    return [seconds, minutes, hours, day, month, year]
