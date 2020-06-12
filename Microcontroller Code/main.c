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
volatile uint8_t time_match = 0;

static uint8_t runtime_hours = 0;
static uint8_t half_runtime_hours = 0;
static uint8_t pump_on = 0;
static uint8_t timed_pump_state = 0; // Store the pump state according to the timer for proper de-overrides
static uint8_t timer_override_ON = 0; // Bool storing if the timer is overridden to pump on
static uint8_t timer_override_OFF = 0; // Bool storing if the timer is overridden to pump off

void __interrupt () isr()
{
    if(T0IF)
    {
        T0IF = 0; // Clear the overflow bit
        TMR0 = 0x79;
        t_8ms++;
        if(122 == t_8ms) // This and line 35 is as close as I can get to a perfect 1 second increment
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

            time_match = ((0 == t_1h) || (t_1h == runtime_hours));            
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

// Resets the timer variables (excluding override)
void reset()
{
    stopPump();    
    runtime_hours = 0;
    timed_pump_state = 0;
    t_8ms = 0;
    t_1s = 1;
    t_1m = 0;
    t_1h = 0;
}

void overrideToOff()
{
    if(0 == timer_override_OFF)
    {
        timer_override_OFF = 1;
        timer_override_ON = 0;
        stopPump();
    }
    else
    {
        timer_override_OFF = 0;
        
        if(1 == timed_pump_state)
        {
            startPump();
        }
    }
    
    // Let user know that override was performed
    GPIO |= led_red | led_green;
    _delay(1000000);
    GPIO &= ~(led_red | led_green);
}

void overrideToOn()
{
    if(0 == timer_override_ON)
    {
        timer_override_ON = 1;
        timer_override_OFF = 0;
        startPump();
    }
    else
    {
        timer_override_ON = 0;
        
        if(0 == timed_pump_state)
        {
            stopPump();
        }
    }
    
    // Let user know that override was performed
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
        if(0 == timer_override_OFF)
        {
            startPump();
            timed_pump_state = 1;
        }
    }

    half_runtime_hours = runtime_hours / 2;
}

void decrementRunTime()
{
    runtime_hours--;
    if(0 == runtime_hours)
    {
        if(0 == timer_override_ON)
        {
            stopPump();
            timed_pump_state = 0;
        }
    }

    half_runtime_hours = runtime_hours / 2;
}

void checkButtons()
{
    if(0 == (GPIO & btn_subtracthour)) // Reset button pressed
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
                decrementRunTime();
                displayHours();
            }
        }
    }
   
    else if(0 == (GPIO & btn_addhour)) // Reset button pressed
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
    if((time_match) && (0 < runtime_hours))
    {
        if(0 == (timer_override_ON | timer_override_OFF)) // Timer not overridden. Execute normal instructions.
        {
            if(1 == pump_on)
            {
                // Turn pump off
                stopPump();
            }
            else if(0 == pump_on)
            {
                // Turn pump on
                startPump();
            }
            else
            {
                // Error state. Turn the pump off
                stopPump();
            }

            time_match = 0;
        }
        else // Timer is overridden. Store the correct pump state, but don't change the actual pump state.
        {
            // When the timer is de-overridden, this will put the pump in the correct state
            timed_pump_state ^= 1;
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
            if(0 != (timer_override_ON | timer_override_OFF)) // Flash both lights to indicate timer is overridden
            {
                GPIO ^= (led_red | led_green);
            }
            else if(0 == runtime_hours) // Flash red LED to indicate timer is not running
            {
                GPIO ^= led_red;
            }
        }
        else
        {
            GPIO &= ~led_red;
            GPIO &= ~led_green;
        }
    }
}