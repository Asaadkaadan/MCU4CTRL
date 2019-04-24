#include <mega16.h>
#include <stdlib.h>
#include <delay.h>
#include <lcd.h>

#asm
.equ __lcd_port =0x15;
#endasm

unsigned int adc_data[4];
char i;
char *s;
// ADC interrupt service routine
interrupt [ADC_INT] void adc_isr(void)
{
// Read the AD conversion result
adc_data[i]=ADCW; 
// Select next ADC input
i++;
if (i==4)  i=0;
ADMUX=i; 
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA.6=1;
}
void main(void)
{
// Select ADC1 channel  
//ADC Voltage Reference: AVcc pin
ADMUX=0B00000000;
// ADC Clock frequency: 125 kHz
// Single Conversion mode
ADCSRA=0B10001011;
lcd_init(16);
lcd_clear(); 
// Global enable interrupts
#asm("sei") 
// Start the AD conversion
ADCSRA.6=1;          
while (1)
  {  
    itoa(adc_data[0],s);
    lcd_gotoxy(0,0);         
    lcd_puts("A0=    ");
    lcd_gotoxy(3,0); 
    lcd_puts(s);   
    delay_ms(5);
    itoa(adc_data[1],s);
    lcd_gotoxy(8,0);         
    lcd_puts("A1=    ");
    lcd_gotoxy(11,0); 
    lcd_puts(s);   
    delay_ms(5);  
    itoa(adc_data[2],s);
    lcd_gotoxy(0,1);         
    lcd_puts("A2=    ");
    lcd_gotoxy(3,1); 
    lcd_puts(s);   
    delay_ms(5);
    itoa(adc_data[3],s);
    lcd_gotoxy(8,1);         
    lcd_puts("A3=    ");
    lcd_gotoxy(11,1); 
    lcd_puts(s);   
    delay_ms(5);  
  }
}
