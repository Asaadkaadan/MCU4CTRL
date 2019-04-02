#include <mega16.h>
#include <delay.h>
char sevenseg_code[10]={0x3f,0x06,0x5B,0x4f,0x66,0x6d, 0x7c,0x07,0x7f,0x6f};
char i=0,v=0 ,a,b;
unsigned  int c;
interrupt [2] void extrenal_int0 (void)
{
i++;
}
interrupt [20] void compare_t0_int (void)
{ 
c++;
if (c==125)
{
v=i;
i=0;
c=0;
}
}

void main(void)
{
DDRA=0B11111111;
DDRB=0B00000011;
MCUCR=0B00000011; 
GICR=0B01000000;  
TCCR0=0B00001011;
TIMSK=0B00000010;
OCR0=124;
#asm("sei") 
while (1)
      {
       a=v%10;
       PORTB=0B00000001;
       PORTA=sevenseg_code[a];
       delay_ms(3);
       b=v/10;
       PORTB=0B00000010;
       PORTA=sevenseg_code[b]; 
       delay_ms(3);
      }
}