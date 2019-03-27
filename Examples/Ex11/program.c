#include <mega16.h>
#include <stdlib.h>
#include <lcd.h>
#asm
.equ __lcd_port=0x15 ;PORTC
#endasm
float  t,r=40;
char s[3];
interrupt [2] void incr_button(void)
{if (r<100)r=r+1;}
interrupt [3] void decr_button(void)
{if(r>35)r=r-1 ;}
void main(void)
{DDRD.0=1;
//configure int0 && int1
PORTD=0B00001100;
MCUCR=0B00001111; 
GICR=0B11000000; 
//configure adc
ADMUX=0B00000000;
ADCSRA=0B10000011;
lcd_init(20);
lcd_clear(); 
#asm("sei")
while (1)
  {ADCSRA.6=1;           
while (ADCSRA.4==0){}   
    t=ADCW*0.09775;
    if (t<=r)
    PORTD.0=1;
    else
    PORTD.0=0;
    ftoa(t,0,s);
    lcd_gotoxy(0,0);         
    lcd_puts("Current T=    %");
    lcd_gotoxy(10,0); 
    lcd_puts(s);   
    ftoa(r,0,s);
    lcd_gotoxy(0,1);         
    lcd_puts("requisite T=    %");
    lcd_gotoxy(13,1); 
    lcd_puts(s);  }}
