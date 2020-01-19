#include <mega16.h>

#include <delay.h>

#include <alcd.h>

#include <stdlib.h>

double PI ( double , double ) ;

double adc_data[6];

double t1,t2,m;

 double y,z,a,b ;
 
int s1=1,s2=0,s3=0,s4=0;

unsigned int x,c,l;

unsigned char *j;

char t;

interrupt[USART_RXC]void rxc(void)
{
t=UDR;
if (t=='C')
{  s2=0;
   s1=0;
   s3=0;
   s4=1;
   }
   else if (t=='c')
   {PORTB.3=1;
   s1=1;
   s4=0;
   PORTB.3=0;
   }
}

interrupt [TIM0_COMP] void timer0(void)
{
   x++;
   if(x==1000)
   {
   t1=t1+adc_data[0];
   t2=t2+adc_data[1];
   x=0;
   c++;
        if(c==5)
        {
        c=0;
        m=(t1+t2)/10;
        t1=0;
        t2=0;
            if(m<=0.25)
            {
            
              s1=0;
              s3=1;
              OCR1A=290;
              OCR1B=290;
            }  
             else 
              {  
              s1=1;
              s3=0;
              } 
              m=0;
        }
   }
}


interrupt [ADC_INT] void adc_isr(void)
{
static unsigned char i=0;

adc_data[i]=ADCH;

if (++i > (5))
   i=0;
ADMUX=(0x60)+i;

delay_us(10);

ADCSRA|=0x40;
}


void main(void)
{

PORTA=0x00;
DDRA=0x00;


PORTB=0B00010100;
DDRB=0x28;


PORTC=0x00;
DDRC=0x00;


PORTD=0x00;
DDRD=0x30;


TCCR1A=0xA2;
TCCR1B=0x1B;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x09;
ICR1L=0xC4;
OCR1A=0;
OCR1B=0;


TIMSK=0x00;


ADMUX=0x60;
ADCSRA=0xCE;


lcd_init(16);

UCSRA=0x00;
UCSRB=0x90;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x33;


#asm("sei")

GICR= 0x20;
MCUCSR= 0x40;
PORTB.5=1;
  while(1)
  {

while (s1)
{    
      l=((adc_data[0]+adc_data[1])/10)+1;
      itoa(l,j); 
      lcd_clear();
      lcd_puts("Normal Mood on"); 
      lcd_gotoxy(0,1); 
      lcd_puts("Lightning = ");
      lcd_puts(j);
      y=PI(180,adc_data[4]);
      if(y<1&&y>-1)
        y=0;  
      b=b+y;
      if(b>290)
        b=290;
      if(b<0)
        b=0;
      OCR1A=b;
      z=PI(140,adc_data[5]);
      if(z<1&&z>-1)
        z=0; 
      a=a+z;
      if(a>290)
        a=290;
      if(a<0)
        a=0;
      OCR1B=a;
      delay_ms(20)  ;
}


while (s3)
{
    lcd_clear;
    lcd_puts("Night Mood on");
    lcd_puts("Wait For sun");
    lcd_gotoxy(0,1); 
    delay_ms(20);
}
    
while (s4)
{   PORTB.3=1;
    lcd_clear();
    lcd_puts("Manual Mood on");
    l=((adc_data[0]+adc_data[1])/10)+1;
    itoa(l,j); 
    lcd_gotoxy(0,1);  
    lcd_puts("Lightning = ");
    lcd_puts(j);
    switch (t) 
    {case 'L': OCR1A=OCR1A+5; break;
    case 'R': OCR1A=OCR1A-5; break;
    case 'D': OCR1B=OCR1B-5; break;
    case 'U': OCR1B=OCR1B+5; break; 
    default: break;
    }
    delay_ms(20);
}
   }

}
double PI ( double setpoint, double pv )         
{
  
    double error = setpoint - pv;
     
    double Pout = 0.05*error;

    double _integral = _integral+ (error * 0.02);
    double Iout = 0.0001 * _integral;

    double output = Pout  + Iout;
                       
    return output;
}
