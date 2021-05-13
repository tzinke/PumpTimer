#Does the RTC really store time bytes as 40x, 20x, 10x, 8x, 4x, 2x, 1x? Need to test
#If so, how does it store values that have two possible representations (15 = x000 1111 or x001 0101)?

def rtc_set():
    print("Closely watch an adequate time source")
    print("Using the format \"yyyy mm dd HH MM SS\" (24-hour time), enter a time a few seconds into the future. When the entered time is reached, press enter immediately.")
    entry = input("Time to set: ")
    #Why did I do it like this?
    currtime = datetime.datetime.strptime(entry, "%Y %m %d %H %M %S")

    second= (int(currtime.second /10) * 16) + (currtime.second % 10)
    minute = (int(currtime.minute /10) * 16) + (currtime.minute % 10)
    hour = (int(currtime.hour /10) * 16) + (currtime.hour % 10)
    day = (int(currtime.day /10) * 16) + (currtime.day % 10)
    month = (int(currtime.month /10) * 16) + (currtime.month % 10)
    y = currtime.year - 2000
    year = (int(y /10) * 16) + (y % 10)

    bus.write_i2c_block_data(address, 0, [second, minute, hour, 1, day, month, year])
    
def rtc_get():
    sec = bus.read_i2c_data(address)

    '''
    regs = bus.read_i2c_block_data(address, 0, 7)

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
    '''
