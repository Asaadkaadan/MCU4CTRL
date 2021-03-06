#include <mega16.h>
#include <stdlib.h>
#include <delay.h>
#include <lcd.h>
#asm
.equ __lcd_port=0x15 ;PORTC
#endasm
float  v;
char s[4];
void main(void)
{
// Select ADC0 channel  
//ADC Voltage Reference: AVcc pin
ADMUX=0B01000000;
// ADC Clock frequency: 125 kHz
// Single Conversion mode
ADCSRA=0B10000011;
lcd_init(16);
lcd_clear(); 
while (1)
  { 
ADCSRA.6=1;   // Start the AD conversion             
while (ADCSRA.4==0){}  // Wait for the AD conversion to complete 
    v=ADCW*0.009775;
    ftoa(v,3,s);
    lcd_gotoxy(0,0);         
    lcd_puts("Volt=          V");
    lcd_gotoxy(5,0); 
    lcd_puts(s);   
    delay_ms(250);
  };
}
