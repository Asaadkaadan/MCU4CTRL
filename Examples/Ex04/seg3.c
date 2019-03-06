#include <mega16.h>
#include <delay.h>

unsigned char i=0;

interrupt [EXT_INT0] void ext_int0_isr(void)
{
 i++;
 if(i==10)
 i=9;
}

interrupt [EXT_INT1] void ext_int1_isr(void)
{
if(i>0)
  i--;
}

void main(void)
{
unsigned char decode[10]={0x3f,0x06,0x5B,0x4f,0x66,0x6d, 0x7c,0x07,0x7f,0x6f}; 
PORTC=0x00;
DDRC=0xFF;
PORTD=0x0C;
DDRD=0x00;
// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: On
// INT1 Mode: Falling Edge
// INT2: Off
GICR|=0xC0;
MCUCR=0x0A;
MCUCSR=0x00;
GIFR=0xC0;
// Global enable interrupts
#asm("sei")
while (1)
      {
       PORTC=decode[i]; 
       delay_ms(100);
      }
}
