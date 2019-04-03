#include <mega16.h>
#include <stdlib.h>
#include <delay.h>
#include <lcd.h>
#asm
.equ __lcd_port=0x15 ;PORTC
#endasm
int v;
char *s;
void main(void)
{
// Select ADC1 channel  
//ADC Voltage Reference: AVcc pin
ADMUX=0B01000001;
// ADC Clock frequency: 125 kHz
// Single Conversion mode
ADCSRA=0B10000011;
lcd_init(16);
lcd_clear(); 
while (1)
  { 
ADCSRA.6=1;   // Start the AD conversion             
while (ADCSRA.4==0){}  // Wait for the AD conversion to complete
    v=ADCW; 
    itoa(v,s);
    lcd_gotoxy(0,0);         
    lcd_puts("ADC=    ");
    lcd_gotoxy(4,0); 
    lcd_puts(s);   
    delay_ms(250);
  };
}