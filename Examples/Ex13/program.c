#include <mega16.h>
int i;
interrupt [20] void extrenal_int0 (void)
{ 
i++;
if (i==1000)
{
i=0;
PORTB.0=~PORTB.0;
}
}
void main(void)
{ 
DDRB.0=1;
TCCR0=0B00001011;
TIMSK=0B00000010;
OCR0=124;
#asm("sei") 
while (1)
{}}

