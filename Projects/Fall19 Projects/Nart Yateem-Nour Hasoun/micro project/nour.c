#include <mega16.h>
#include <stdlib.h>
#include <delay.h>
#include <lcd.h>
#asm
.equ __lcd_port=0x15 ;
#endasm
unsigned int adc_data[2];
char i;
char *s;
char *x;
char *y;
float a;
float temp;
float m1;
float m2;
float m3;
float volt;
float lux;
float z;
interrupt [ADC_INT] void adc_isr(void)
{
// Read the AD conversion result
adc_data[i]=ADCW;
// Select next ADC input
i++;
if (i==2) i=0;
ADMUX=i;
delay_us(1);   

ADCSRA.6=1;
}
void main(void)
{ 
TCCR0=0b01101010;
TCNT0=0x00;
OCR0=0x00;
m1=-0.8;
m2=-0.25;
m3=-0.125;

DDRB.3=1;
// Select ADC1 channel
// ADC initialization
// ADC Clock frequency: 125.000 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: ADC Stopped
ADMUX=0;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (1<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (0<<ADPS0);
SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);

lcd_init(16);
lcd_clear();
// Global enable interrupts
#asm("sei")
// Start the AD conversion
ADCSRA.6=1;
while (1)
{
a=adc_data[0];
volt=adc_data[1]*4.88281;
if (volt<800)
{
lux=1000; }
else if(volt>=800&&volt<1300)
  {lux=m1*volt+1640;
  }
  else if(volt>=1400&&volt<2200)
  {lux=m2*volt+750;
  }
  else if (volt>=2500&&volt<3500)
  {lux=m3*volt+487.5; 
  }
  else if(volt>4300)
{
lux=0;}

z=lux;
OCR0=a/4;
temp=a*0.488281;
itoa(temp,s);
lcd_gotoxy(0,0);
lcd_puts("temp=");
lcd_puts(s);
lcd_gotoxy(0,1);
lcd_puts("LUX=");
itoa(z,x);
lcd_gotoxy(4,1);
lcd_puts(x);
lcd_gotoxy(9,1);
lcd_puts("vo=");
itoa(volt,y);
lcd_puts(y);
delay_ms(50);
lcd_clear();
}
}