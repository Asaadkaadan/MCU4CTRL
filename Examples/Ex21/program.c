#include <mega16.h>
#include <delay.h>
void main(void){
DDRB.0=1;
PORTB.0=1;
delay_ms(1000);
PORTB.0=0;
WDTCR=0B00011111;
while(1)
{if (PIND.0==1)#asm("wdr");
}}