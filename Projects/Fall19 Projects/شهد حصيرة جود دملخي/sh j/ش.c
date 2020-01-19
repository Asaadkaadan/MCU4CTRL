

#include <mega16.h>


#include <alcd.h>
#include <stdlib.h>
#include <delay.h>

unsigned int a,v,x,se,s,error,pout,iout,integral,output;
unsigned char *b;


interrupt [EXT_INT0] void ext_int0_isr(void)
{
x++;
}

interrupt[TIM2_COMP]void timer2_comp(void)
{   
  if(x==50)
  {
se=x*300;
x=0;}
// error=s-se;
 // pout=0.5*error;
  //integral+=error;
  //iout=0.1*integral;
 //output=pout+iout;
  //if(output>255)
  //output=255;
  //if(output<0)
  //output=0;
  //OCR2=output;       
}


void main(void)
{ 
PORTA=0x00;
DDRA=0x00;
 
PORTB=0x00;
DDRB=0x08;

 
PORTC=0x00;
DDRC=0x00;

PORTD=0x00;
DDRD=0x04;

TCCR2=0x0B;
TCNT2=0x00;
OCR0=124;

ASSR=0x00;
TCCR0=0x6D;
TCNT0=0x00;
OCR2=0x00;

GICR|=0x40;
MCUCR=0x02;
MCUCSR=0x00;
GIFR=0x40;

TIMSK=0x80;

ADCSRA=0x86;

lcd_init(16);


#asm("sei")
 
lcd_puts("shahd&joud");
delay_ms(50);
 lcd_clear();
while (1)
      {
      // Place your code here  
      ADCSRA.6=1;
      while(ADCSRA.4==0){}
      a=ADCW;
      s=(255*a)/1023;
      
      lcd_puts("speed=");
      lcd_gotoxy(7,0);
      itoa(s,b);
      lcd_puts(b);
      delay_ms(50);
      v=(a*9)/1023;
      lcd_gotoxy(0,1);
      lcd_puts("volt=");
      lcd_gotoxy(6,1);
      itoa(v,b);
      lcd_puts(b); 
      delay_ms(20);
      lcd_clear();
      }
}
