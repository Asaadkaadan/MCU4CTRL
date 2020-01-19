#include <mega16.h>
#include <delay.h>
#include <alcd.h>
#include <stdlib.h>

int f1,counter;

int f2,state=0,dir=0,mod=0,x=0,cnt=0,sec=0;

int f3,step[8]={1,5,4,12,8,10,2,3};



float f4,Kp=50,Ki=100,dt=0.001,integral=0,Io=0,out=0,Po=0,error=0,vr=0,z=0,va=0;

char *c;



interrupt [EXT_INT0] void ext_int0_isr(void)
{
      if(state ==1)
        state=0;
      else
        state=1;
}

interrupt [EXT_INT1] void ext_int1_isr(void)
{
      if(dir ==1)
        dir=0;
      else
        dir=1;
}

interrupt [EXT_INT2] void ext_int2_isr(void)
{
      cnt++;
}

interrupt [TIM1_COMPA] void timer1_compa_isr(void) 
{
     sec++;
     if(sec>4)
     {
       sec=0;
       z=cnt;
       cnt=0;
     }
}

float PI( float vreq, float vreal )  
{
// Calculate error
error = vreq - vreal;
// Proportional term
Po = Kp * error;
// Integral term
integral += error * dt;

Io = Ki * integral;
// Calculate total output
out = Po + Io;

return out;
}

void main(void)
{
DDRA=0x0f;

PORTD=0x1c;

TCCR1A=(0<<COM1A1)|(0<<COM1A0)|(0<<COM1B1)|(0<<COM1B0)|(0<<WGM11)|(0<<WGM10);
TCCR1B=(0<<ICNC1)|(0<<ICES1)|(0<<WGM13)|(1<<WGM12)|(1<<CS12)|(0<<CS11)|(0<<CS10);
OCR1AH=0x7a;
OCR1AL=0x11;
TIMSK=0x10;

GICR=0xe0;
MCUCR=0x0A;
MCUCSR=0x00;

ADMUX=0x05;
ADCSRA=0x86;



lcd_init(16);

#asm("sei")   

while (1)
      {
            ADCSRA.6=1;
            while(ADCSRA.4==0){}
            va=ADCW/40;
            if(PIND.4==0 && x==0)
            {
                    if(mod ==1)
                        mod=0;
                    else
                        mod=1;
                    x=1;
            }
            if(PIND.4==1)
                x=0;
            if(state==1)
            {
                PORTA = step[counter];
                counter = counter + ((1-2*dir)*(1+mod));
                if(counter == 8 )  counter = 0; 
                if(counter == 9 )  counter = 1;
                if(counter == -1)  counter = 7;
                if(counter == -2)  counter = 6;
            } 
            vr=z*12/20;
            lcd_puts("Va=");  
            itoa(va,c); 
            lcd_puts(c);
            lcd_puts("rpm"); 
            lcd_puts(" Vr=");   
            itoa(vr,c);
            lcd_puts(c);
            lcd_puts("rpm");
            lcd_gotoxy(0,1); 
            if(mod==1)
                lcd_puts("FULL");
            else
                lcd_puts("HALF"); 
            if(dir==0)
                lcd_puts("   -->");
            else
                lcd_puts("   <--"); 
            if(state==1)
                lcd_puts("   ON");
            else
                lcd_puts("   OFF");
            if(state==1)
              delay_ms(PI(va,vr));
            else
              delay_ms(10);
            lcd_clear();
      }
}

















































//          if(state==1 && mod==0)
//              v=60000/(2*64*del);
//          else if(state==1 && mod==1)
//              v=60000/(64*del);
//          else