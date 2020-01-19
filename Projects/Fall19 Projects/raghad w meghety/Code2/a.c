
#include <mega16.h>
 unsigned char z;
// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
z=UDR;
}



// Declare your global variables here

void main(void)
{

DDRB=0xFF;
DDRD=0x20;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 125.000 kHz
// Mode: Fast PWM top=0x00FF
// OC1A output: Non-Inv.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x81;
TCCR1B=0x0B;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: Off
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=0x00;
UCSRB=0x90;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x33;

// Global enable interrupts
#asm("sei")

OCR1AH=0x00;
OCR1AL=127;
while (1)
      { 
         if (z>170) {PORTB=0;}
else  {  PORTB=~z;};
         
     OCR1AH=0x00;
     if (z>170) {OCR1A=0 ;}
else  {   OCR1AL=170-z;};

     

      
}
}