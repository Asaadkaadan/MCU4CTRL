#include <mega16.h>
#include <stdlib.h>
#include <delay.h>
#include <alcd.h>

float a=0,v=0,an=0;         
long int i=0,d=609,b=0,ol=0,oh=0;
int st=100,t=0,se=0,mi=0,o=15;
int z=1,x=1,y=0,p=0,w=1,j=1;
char *e,m[10],r[10];

void Angel()  //  «»⁄ ≈ŸÂ«— «·“«ÊÌ…
{
 if(z==0)
   an=((b-619)/10)*0.9;
 else
   an=(((b-619)/10)*0.9)-90;
 ftoa(an,1,r);
 lcd_gotoxy(0,1);
 lcd_puts("Angel=");
 lcd_puts(r);
}

void Scan()   //  «»⁄ «·„”Õ
{
 lcd_clear();
 lcd_puts("  Scanning....");
 d=609;
 j=0;
 a=0;
 for(i=0;i<=200;i++)
  {
   if(x==1)
     {
      d+=10;       
      OCR1AH=d/256;OCR1AL=d%256;
      if(d==619)
        delay_ms(1000);
      delay_ms(50);
      ADCSRA.6=1;
      while(ADCSRA.4==0){}
      if(ADCW>a)
       {
        a=ADCW;
        b=d;
       }
     } 
  }
  if(x==1)
   {
    OCR1AH=b/256;OCR1AL=b%256;
    delay_ms(300);
    v=(a*5000)/1024;
    lcd_clear();
    lcd_puts("Vmax=");
    ftoa(v,3,m);
    lcd_puts(m);
    lcd_puts("mv");
    Angel();
    j=1;
    x=0;
   }   
}  

interrupt [EXT_INT0] void ext_int0_isr(void)   // · Õ—Ìﬂ «·„Õ—ﬂ ≈·Ï «·Ì„Ì‰ »„ﬁœ«— ŒÿÊ…
{
 x=0;
 j=1;
 oh=OCR1AH;
 ol=OCR1AL;
 b=(oh<<8)+ol;
 if(b<=(2619-st))   
   b+=st;
 else
   b=2619;
 OCR1AH=b/256;OCR1AL=b%256;
 delay_ms(100);
 ADCSRA.6=1;
 while(ADCSRA.4==0){}
 a=ADCW;
 v=(a*5000)/1024;
 lcd_clear();
 lcd_puts("V=");
 ftoa(v,3,m);
 lcd_puts(m);
 lcd_puts("mv");
 Angel();
 delay_ms(1);
}

interrupt [EXT_INT1] void ext_int1_isr(void)   // · Õ—Ìﬂ «·„Õ—ﬂ ≈·Ï «·Ì”«— »„ﬁœ«— ŒÿÊ…
{
 x=0;
 j=1;
 oh=OCR1AH;
 ol=OCR1AL;
 b=(oh<<8)+ol;
 if(b>=(619+st))   
   b-=st;
  else
   b=619;
 OCR1AH=b/256;OCR1AL=b%256;
 delay_ms(100);
 ADCSRA.6=1;
 while(ADCSRA.4==0){}
 a=ADCW;
 v=(a*5000)/1024;
 lcd_clear();
 lcd_puts("V=");
 ftoa(v,3,m);
 lcd_puts(m);
 lcd_puts("mv");
 Angel();  
 delay_ms(1);
}
                                                  
interrupt [EXT_INT2] void ext_int2_isr(void)   // · €ÌÌ— ŒÿÊ… «·„Õ—ﬂ
{
 if(st==10)
   st=100;
 else
   st=10; 
 delay_ms(1);
}

interrupt [TIM1_CAPT] void timer1_capt_isr(void)   // ·Õ”«» “„‰ «·„”Õ «· ·ﬁ«∆Ì
{
 if(j==1)
  {
   t++;
   if(t>=50)
    {
     se++;
     t=0;
    }
   if(se>=60)
    {
     mi++;
     se=0;
    }
   if(mi==o)
    {
     y=1;
     mi=0;
    }
   }
}

void main(void)
{
DDRB=0x00;
PORTB=0xff;

DDRD=0x60;
PORTD=0x4c;

TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (1<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (1<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x4E;
ICR1L=0x1F;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

TIMSK=0x20;

GICR|=(1<<INT1) | (1<<INT0) | (1<<INT2);
MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);

ADMUX=0x00;
ADCSRA=0x85;

lcd_init(16);

#asm("sei")

Scan();   // ·»œ¡ ⁄„·Ì… „”Õ »œ«∆Ì… ›Ì »œ«Ì… «· ‘€Ì·

while (1)
      {
       if(y==1)   // ·»œ¡ «·„”Õ «· ·ﬁ«∆Ì »⁄œ “„‰ „⁄Ì‰
        {
         y=0;
         x=1;
         Scan();
        }
       if(PINB.0==0 && p==0)   // ·“Ì«œ… «·“„‰ ﬁ»· »œ¡ „”Õ  ·ﬁ«∆Ì ÃœÌœ
        {
         if(o<99)
           o++;
         itoa(o,e);
         lcd_gotoxy(12,1);
         lcd_puts("T=");
         if(o<10)
           lcd_puts("0");
         lcd_puts(e);
         delay_ms(400);
         lcd_gotoxy(12,1);
         lcd_puts("    ");
        }
       else if(PINB.1==0 && p==0)   // ·≈‰ﬁ«’ «·“„‰ ﬁ»· »œ¡ „”Õ  ·ﬁ«∆Ì ÃœÌœ
        {
         if(o>1)
           o--;
         itoa(o,e);
         lcd_gotoxy(12,1);
         lcd_puts("T=");
         if(o<10)
           lcd_puts("0");  
         lcd_puts(e);
         delay_ms(400);
         lcd_gotoxy(12,1);
         lcd_puts("    ");
        }
       else if(PINB.4==0 && p==0)   // · ›⁄Ì· √Ê ≈·€«¡  ›⁄Ì·  «·„”Õ «· ·ﬁ«∆Ì „⁄ ·Ìœ ≈‘«—…
        {
         if(w==1)
          {
           PORTD.6=0;          
           TIMSK=0x00;
           y=0;
           t=0;
           se=0;
           mi=0; 
           w=0;
           lcd_gotoxy(13,1);
           lcd_puts("OFF");
           delay_ms(750);
           lcd_gotoxy(12,1);
           lcd_puts("    ");
          } 
         else
          {
           PORTD.6=1;
           TIMSK=0x20;
           y=0;
           t=0;
           se=0;
           mi=0; 
           w=1;
           j=1;
           lcd_gotoxy(14,1);
           lcd_puts("ON");
           delay_ms(750);
           lcd_gotoxy(12,1);
           lcd_puts("    ");
          }    
         p=1;
        }
       else if(PINB.5==0 && p==0)   // ·»œ¡ ⁄„·Ì… „”Õ ÌœÊÌ…
        {
         x=1;
         Scan();
         p=1;
        }
       else if(PINB.6==0 && p==0)   // · ÕœÌœ ÿ—Ìﬁ… ≈ŸÂ«— «·“«ÊÌ… ⁄·Ï «·‘«‘…
        {
         if(z==0)
          {
           z=1;
           Angel();
           lcd_gotoxy(12,1);
           lcd_puts("-To+");
           delay_ms(750);
           lcd_gotoxy(12,1);
           lcd_puts("    ");
          }
         else
          {
           z=0;
           Angel();
           lcd_gotoxy(12,1);
           lcd_puts("0To+");
           delay_ms(750);
           lcd_gotoxy(12,1);
           lcd_puts("    ");
          }
         p=1;
        }
       else if(PINB==255)
         p=0;          
      }    
}
