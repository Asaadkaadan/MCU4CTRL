#include <mega8.h>
#include <delay.h>
char sevenseg_code[10]={0x3f,0x06,0x5B,0x4f,0x66,0x6d, 0x7c,0x07,0x7f,0x6f};
char i,a,b;
interrupt [2] void extrenal_int0 (void)
{
if (i<99)
i++;
}
interrupt [3] void extrenal_int1 (void)
{
if (i>0)
i--;
}
void main(void)
{DDRB=0B11111111;
DDRC=0B00000011;
PORTD.2=1;
MCUCR=0B00001111; 
GICR=0B11000000;  
#asm("sei") 
while (1)
      {
       a=i%10;
       PORTC=0B00000001;
       PORTB=sevenseg_code[a];
       delay_ms(3);
       b=i/10;
       PORTC=0B00000010;
       PORTB=sevenseg_code[b]; 
       delay_ms(3);
      }
}