#include <xc.h>
#include <stdint.h>
 
#pragma config FOSC=INTRCIO,WDTE=OFF,MCLRE=OFF,BOREN=OFF

// Define inputs
#define btn_addhour 0x02 // GP1
#define btn_rst 0x08 // GP3

//Define outputs
#define relays_on 0x01 // GP0
#define relays_off 0x04 // GP2
#define led_hours 0x10 // GP4
#define led_rst 0x20 //  GP5

volatile uint8_t t_8ms = 0;
volatile uint8_t t_1s = 0;
volatile uint8_t t_1m = 0;
volatile uint8_t t_1h = 0;
volatile uint8_t time_match = 0;

static uint8_t runtime_hours = 0;
static uint8_t half_runtime_hours = 0;
static uint8_t pump_on = 0;
static uint8_t runtime_even = 0;
static uint8_t timer_override = 0;

void __interrupt () isr()
{
    if(T0IF)
    {
        T0IF = 0; // Clear the overflow bit
        TMR0 = 0x77;
        t_8ms++;
        if(125 == t_8ms)
        {
            t_1s++;
            t_8ms = 0;
        }
        if(60 == t_1s)
        {
            t_1s = 0;
            t_1m++;
        }
        if(60 == t_1m)
        {
            t_1m = 0;
            t_1h++;
            
            // Toggle pump at 0 (on), runtime / 2 (off), 12 - (runtime/2) (on), 12 (off)
            // Ex: runtime is 8 hours, started at 9am; 9am -> on, 1pm -> off, 5pm -> on, 9pm -> off
            // This pattern aims to disperse run time evenly throughout the day and only during the day (running at night isn't super useful)
            if(1 == runtime_even)
            {
                time_match = ((0 == t_1h) || (half_runtime_hours == t_1h) ||  ((12 - half_runtime_hours) == t_1h) || (12 == t_1h));
            }
            else // If runtime_hours is odd, add the truncated hour to the first run. Ex: 9am -> 1pm, 9pm -> 12am = 7 hours
            {
                time_match = ((0 == t_1h) || ((half_runtime_hours + 1) == t_1h) ||  ((12 - half_runtime_hours) == t_1h) || (12 + half_runtime_hours) == t_1h);
            }
        }
        if(24 == t_1h)
        {
            t_1h = 0;
        }
    }
}

void configGPIO()
{
    GPIO &= 0xC0;   // Set all pins low for good measure
    CMCON |= 0x07;   // Disconnect the comparator (datasheet pg 30)
    TRISIO &= 0xC8;     // Set all pins to output
    TRISIO |= (btn_rst | btn_addhour);     // Set buttons to input
    ANSEL=0x00;     // All Analog selections pins are assigned as digital I/O
}

void enableInterrupts()
{
    INTCON |= 0x80; // Enable global interrupt
    INTCON |= 0x20; // Enable Timer 0 interrupt
}

void disableInterrupts()
{
    INTCON &= ~0x80; // Disable global interrupt
    INTCON &= ~0x20; // Disable Timer 0 interrupt
}

void configOptions()
{
    OPTION_REG &= 0xD0; // Set TMR0 clock source to internal instruction clock and apply prescaler to TMR0
    OPTION_REG |= 0x05; // Set prescaler bits to 101 (1:64, AKA 15,625Hz)
}

void startPump()
{
    // Turn pump on
    GPIO |= relays_on;
    _delay(15000);
    GPIO &= ~relays_on;
    pump_on = 1;
}
void stopPump()
{
    // Turn pump off
    GPIO |= relays_off;
    _delay(15000);
    GPIO &= ~relays_off;
    pump_on = 0;
}

void checkButtons()
{
    if(0 == (GPIO & btn_rst)) // Reset button pressed
    {
        _delay(50000); // 50ms debounce
        
        if(0 == (GPIO & btn_rst))
        {
            _delay(450000); // Check long press
            if(0 == (GPIO & btn_rst))
            {
                // Toggle timer override
                if(0 != timer_override)
                {
                    timer_override = 0;
                    stopPump();
                }
                else
                {
                    timer_override = 1;
                    startPump();
                }
            }
            else // Short press
            {
                stopPump();
                disableInterrupts();
                runtime_hours = 0;
                timer_override = 0;
                t_8ms = 0;
                t_1s = 0;
                t_1m = 0;
                t_1h = 0;
            }
        }
    }
    
    else if(0 == (GPIO & btn_addhour)) // Add/Check-hour button pressed
    {
        _delay(50000); // 50ms debounce
        
        if(0 == (GPIO & btn_addhour)) // True press
        {
            GPIO |= led_hours;
            _delay(100000);
            GPIO &= ~led_hours;
            _delay(350000); // To make it ~0.5 second since initial press
            
            if(0 == (GPIO & btn_addhour)) // Long press
            {
                // User held button for ~0.5 second. Undo the runtime increment and flash led_hours x runtime_hours
                // Also, flash the reset led to visually distinguish the btn_addhour short- and long-press flashes
                GPIO |= led_rst;
                _delay(100000);
                GPIO &= ~led_rst;
                
                for(int i = 0; i < runtime_hours; i++)
                {
                    GPIO |= led_hours;
                    _delay(100000);
                    GPIO &= ~led_hours;
                    _delay(400000);
                }
                
                if(0 == runtime_hours) // Delay, otherwise the button will be read too quickly and probably add an hour
                {
                    _delay(200000);
                }
            }
            
            else if(20 > runtime_hours) // Not long press (short press) and user hasn't set run time to 20 hours
            {
                runtime_hours++;
                if(1 == runtime_hours)
                {
                    t_8ms = 0;
                    t_1s = 0;
                    t_1m = 0;
                    t_1h = 0;
                }
                
                half_runtime_hours = runtime_hours / 2;
                if(0 == (runtime_hours % 2))
                {
                    runtime_even = 1;
                }

                else
                {
                    runtime_even = 0;
                }
            }
        }
    }
}

void checkTime()
{
    if((time_match) && (0 == timer_override))
    {
        if(1 == pump_on)
        {
            // Turn pump off
            stopPump();
            stopPump(); // Redundant check
        }
        else if(0 == pump_on)
        {
            // Turn pump on
            startPump();
            startPump(); // Redundant check
        }
        else
        {
            // Error state. Turn pump off!
            stopPump();
            stopPump(); // Redundant check
        }
    }
}

void main(void)
{
    configGPIO();
    configOptions();
    enableInterrupts();
    
    while(1) 
    {
        _delay(1000);
        checkButtons();
        checkTime();
        
        if((0 == (t_1s % 5)) && (0 == runtime_hours))
        {
            GPIO |= led_rst;
        }
        else
        {
            GPIO &= ~led_rst;
        }
    }
}