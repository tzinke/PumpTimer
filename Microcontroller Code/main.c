#include <xc.h>
#include <stdint.h>
 
#pragma config FOSC=INTRCIO,WDTE=OFF,MCLRE=OFF,BOREN=OFF

// Define inputs
#define btn_addhour 0x02 // GP1
#define btn_subtracthour 0x08 // GP3

//Define outputs
#define relays_on 0x01 // GP0
#define relays_off 0x04 // GP2
#define led_green 0x10 // GP4
#define led_red 0x20 //  GP5

volatile uint8_t t_8ms = 0;
volatile int8_t t_1s = 0; // This is signed for correction factor
volatile uint8_t t_1m = 0;
volatile uint8_t t_1h = 0;
volatile uint8_t on_time_match = 0; // 0 == no action, 1 == Time to turn pump on
volatile uint8_t off_time_match = 0; // 0 == no action, 1 == Time to turn pump off

static uint8_t runtime_hours = 0; // # hours for pump to run each day
static uint8_t pump_state = 0; // 0 == off, 1 == on
static uint8_t timed_pump_state = 0; // Store the pump state according to the timer for proper de-overrides. 0 off, 1 on
static uint8_t timer_override_ON = 0; // Bool storing if the timer is overridden to pump on
static uint8_t timer_override_OFF = 0; // Bool storing if the timer is overridden to pump off

void __interrupt () isr()
{
    if(T0IF)
    {
        T0IF = 0; // Clear the overflow bit
        TMR0 = 0x79;
        t_8ms++;
        if(122 == t_8ms) // This is as close as I can get to a perfect 1 second increment
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
            t_1s = 1; // Correction for ~1s drift per hour
            t_1h++;
            
            if(24 == t_1h)
            {
                t_1h = 0;
            }

            if((0 == t_1h) && (0 < runtime_hours))
            {
                on_time_match = 1;
            }
            else if(t_1h == runtime_hours)
            {
                off_time_match = 1;
            }
        }
    }
}

void configGPIO()
{
    GPIO &= 0xC0;   // Set all pins low for good measure
    CMCON |= 0x07;   // Disconnect the comparator (datasheet pg 30)
    TRISIO &= 0xC8;     // Set all pins to output
    TRISIO |= (btn_subtracthour | btn_addhour);     // Set buttons to input
    ANSEL=0x00;     // All Analog selections pins are assigned as digital I/O
}

void enableInterrupts()
{
    INTCON |= 0x80; // Enable global interrupt
    INTCON |= 0x20; // Enable Timer 0 interrupt
}

void disableInterrupts() // Currently unused
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
    _delay(16000);
    GPIO &= ~relays_on;
    pump_state = 1;
}

void stopPump()
{
    // Turn pump off
    GPIO |= relays_off;
    _delay(16000);
    GPIO &= ~relays_off;
    pump_state = 0;
}

// Resets the timer variables (excluding override)
void reset()
{
    // Don't want to energize relay coils if timer is overridden
    if((0 == timer_override_ON) && (0 == timer_override_OFF))
    {
        stopPump();    
    }
     
    runtime_hours = 0;
    timed_pump_state = 0;
    t_8ms = 0;
    t_1s = 1;
    t_1m = 0;
    t_1h = 0;
}

void overrideToOff()
{
    // Not already overridden. Put in override_off state
    if(0 == timer_override_OFF)
    {
        timer_override_OFF = 1;
        timer_override_ON = 0;
        if(1 == pump_state)
        {
            stopPump();
        }
    }
    else // Already overridden. Return to timed state
    {
        timer_override_OFF = 0;
        
        if(1 == timed_pump_state)
        {
            startPump();
        }
    }
    
    // Let user know that override input was received
    GPIO |= led_red | led_green;
    _delay(1000000);
    GPIO &= ~(led_red | led_green);
}

void overrideToOn()
{
    // Not already overridden. Put in override_on state
    if(0 == timer_override_ON)
    {
        timer_override_ON = 1;
        timer_override_OFF = 0;
        if(0 == pump_state)
        {
            startPump();
        }
    }
    else // Already overridden. Return to timed state
    {
        timer_override_ON = 0;
        
        if(0 == timed_pump_state)
        {
            stopPump();
        }
    }
    
    // Let user know that override input was received
    GPIO |= led_red | led_green;
    _delay(1000000);
    GPIO &= ~(led_red | led_green);
}

void displayHours()
{ 
    // Also, flash the reset led to visually distinguish the btn_addhour short- and long-press flashes
    GPIO |= led_red;
    _delay(100000);
    GPIO &= ~led_red;

    for(int i = 0; i < runtime_hours; i++)
    {
        GPIO |= led_green;
        _delay(100000);
        GPIO &= ~led_green;
        _delay(400000);
    }

    if((0 == runtime_hours) || (1 == runtime_hours)) // Delay, otherwise the button will be read too quickly and probably add an hour
    {
        _delay(200000);
    }
}

void incrementRunTime()
{
    runtime_hours++;

    if(1 == runtime_hours)
    {
        t_8ms = 0;
        t_1s = 1;
        t_1m = 0;
        t_1h = 0;
        timed_pump_state = 1;

        if(0 == timer_override_OFF)
        {
            startPump();
        }
    }
    else if((runtime_hours > t_1h) && (0 == pump_state))
    {
        // Incremented beyond the current time after runtime. Turn pump on.
        // This time-match event won't be caught by the ISR
        on_time_match = 1;
    }
}

void decrementRunTime()
{
    runtime_hours--;

    if(0 == runtime_hours)
    {
        reset();
    }
    else if((runtime_hours == t_1h) && (1 == pump_state))
    {
        // Decremented beyond the current time during runtime. Turn pump off.
        // This time-match event won't be caught by the ISR
        off_time_match = 1;
    }
}

void checkButtons()
{
    if(0 == (GPIO & btn_subtracthour)) // Subtract-hour button pressed
    {
        _delay(50000); // 50ms debounce
        
        if(0 == (GPIO & btn_subtracthour)) // True press
        {
            _delay(250000); // Check long press
            if(0 == (GPIO & btn_subtracthour))
            {
                overrideToOff();
                _delay(500000); // Give time for user to stop pressing button before re-entering this loop
            }
            else // Short press
            {
                if(0 < runtime_hours)
                {
                    decrementRunTime();
                }
                
                displayHours();
            }
        }
    }
   
    else if(0 == (GPIO & btn_addhour)) // Add-hour button pressed
    {
        _delay(50000); // 50ms debounce
        
        if(0 == (GPIO & btn_addhour)) // True press
        {
            _delay(250000); // Check long press
            if(0 == (GPIO & btn_addhour))
            {
                overrideToOn();
                _delay(500000); // Give time for user to stop pressing button before re-entering this loop
            }
            else // Short press
            {
                if(24 > runtime_hours)
                {
                    incrementRunTime();
                }
                
                displayHours();
            }
        }
    } 
}

void checkTime()
{
    if(1 == on_time_match)
    {
        on_time_match = 0;
        timed_pump_state = 1;
        
        // If timer is not overridden, turn pump on
        if((0 == timer_override_OFF) && (0 == timer_override_ON))
        {
            startPump();
        }
    }
    else if(1 == off_time_match)
    {
        off_time_match = 0;
        timed_pump_state = 0;
        
        // If timer is not overridden, turn pump off
        if((0 == timer_override_OFF) && (0 == timer_override_ON))
        {
            stopPump();
        }
    }
}

void main(void)
{
    configGPIO();
    configOptions();
    enableInterrupts();
    
    reset();
    
    while(1) 
    {
        _delay(1000);
        checkButtons();
        checkTime();
        
        if(0 == (t_1s % 5))
        {
            if((1 == timer_override_ON) || (1 == timer_override_OFF)) // Flash both lights to indicate timer is overridden
            {
                GPIO ^= (led_red | led_green);
            }
            else if(0 == runtime_hours) // Flash red LED to indicate timer is not running
            {
                GPIO ^= led_red;
            }
            else
            {
                GPIO ^= led_green; // Flash greed LED to indicate normal operation
            }
        }
        else
        {
            GPIO &= ~led_red;
            GPIO &= ~led_green;
        }
    }
}