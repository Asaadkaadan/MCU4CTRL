
#include <mega16.h>
#include <alcd.h>
#include <stdlib.h>
  #include <delay.h>
  float t;
   char s[5];
void main(void)
{
PORTA=0x00;
DDRA=0x00;

PORTB=0x00;
DDRB=0x00;

PORTC=0x00;
DDRC=0x00;

PORTD=0x00;
DDRD=0xFF;
ADMUX=0b00000000;
ADCSRA=0b10000011; 
lcd_init(16);
lcd_clear();
while (1)
      {
       ADCSRA.6=1;
       
   

       while ( ADCSRA.4==0){}
        t=ADCW*0.09775;
        ftoa(t,0,s);
       
       
       if(t<15)
      { PORTD.7=0;
       PORTD.5=1; 
       PORTD.2=0;
                         PORTD.1=0;
       lcd_gotoxy(0,0);
        lcd_puts("temp=  degree");
       lcd_gotoxy(6,0);
       lcd_puts(s);
       delay_ms(500);
              lcd_gotoxy(0,1);
               lcd_puts("the heater is on");
                         delay_ms(500);}
                         else if(t>20 && t<39)
                        { PORTD.7=1;
                         PORTD.5=0;
                         PORTD.2=0;
                         PORTD.1=0;    
                         lcd_gotoxy(0,0);
                          lcd_puts("temp=  degree");
                          lcd_gotoxy(6,0);
                          lcd_puts(s);
                          delay_ms(500);
                          lcd_gotoxy(0,1);
                          lcd_puts("the Fan is on...");
                           delay_ms(500);}
                           else if (t>15 && t<20)
                          { PORTD.7=0;
                           PORTD.5=0;
                           PORTD.2=0;
                         PORTD.1=0; 
                           lcd_gotoxy(0,0);
                            lcd_puts("temp=  degree");
                             lcd_gotoxy(6,0);
                              lcd_puts(s);
                             delay_ms(500);
                            lcd_gotoxy(0,1);
               lcd_puts("the temp is good");
                                             }
                                             else if (t>40)
                                             {PORTD.1=1;
                                             PORTD.7=1;
                                             PORTD.2=1;
                                             PORTD.5=0;
                                              lcd_gotoxy(0,0);
                            lcd_puts("temp=  degree");
                             lcd_gotoxy(6,0);
                              lcd_puts(s);
                             delay_ms(500);
                            lcd_gotoxy(0,1);
               lcd_puts("the temp is danger");
                                             }
      }
}
