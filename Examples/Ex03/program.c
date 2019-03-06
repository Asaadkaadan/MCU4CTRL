#include <mega16.h>
interrupt [EXT_INT0] void extrenal_int0 (void)
{
PORTB.0=~PORTB.0;
}
void main(void)
{DDRB.0=1;
MCUCR=0B00000011; //RISING EDGE FOR INT0
GICR=0B01000000;  //ENABLE INT0
#asm("sei")  //ENABLE GENERAL INT
while (1)
{}}

