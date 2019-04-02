#include <mega16.h>
#include <delay.h>
unsigned char sevenseg_code[10]={0x3f,6,0x5B,0x4f,0x66,0x6d,0x7c,0x07,0x7f,0x6f}; 
unsigned char a,b,i; 
void main(void)
{
DDRC=0B11111111;
DDRD=0B00000011;
//count External clock source on T0 pin. Clock on rising edge.
// enable CTC 
TCCR0=0B00001111;
OCR0=99;
// Global enable interrupts
#asm("sei")
while (1)
      {
      i=TCNT0;
       a=i%10;
       PORTD=0B00000001;
       PORTC=sevenseg_code[a];
       delay_ms(4);
       b=i/10;
       PORTD=0B00000010;
       PORTC=sevenseg_code[b]; 
       delay_ms(4);
      }
}