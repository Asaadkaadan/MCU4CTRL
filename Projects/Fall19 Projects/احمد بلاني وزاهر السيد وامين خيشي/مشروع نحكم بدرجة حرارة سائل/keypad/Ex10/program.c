#include <mega16.h>
#include <stdlib.h>
#include <delay.h>
#include <lcd.h>
#asm
.equ __lcd_port=0x15 ;PORTC
#endasm
float  i;
char s[3];
void main(void)
{
// Select ADC0 channel  
//ADC Voltage Reference: AREF pin
ADMUX=0B00000000;
// ADC Clock frequency: 125 kHz
// Single Conversion mode
ADCSRA=0B10000110;
lcd_init(16);
lcd_clear(); 
while (1)
  { 
ADCSRA.6=1;   // Start the AD conversion             
while (ADCSRA.4==0){}  // Wait for the AD conversion to complete 
    i=ADCW*0.09775;
    ftoa(i,0,s);
    lcd_gotoxy(0,0);         
    lcd_puts("Temp=    degree");
    lcd_gotoxy(6,0); 
    lcd_puts(s);   
    delay_ms(250);
  };
}
