#include <mega16.h>
#include <delay.h>
#include <lcd.h>
#include <stdlib.h>

#asm                      // ⁄—Ì›… «· lcd
   .equ __lcd_PORT=0x15; PORTC
#endasm
int i;
float speed_ref=0;   //«·”—⁄… «·„—Ã⁄Ì… Ì·Ì «‰« »œÌ «⁄ÿÌ Ì«Â«
bit f=0; //⁄—›‰« «·„ ÕÊ· f „‘«‰ Êﬁ  “Ì«œ… «·ﬂ»«” „«Ì«Œœ «ﬂ — „‰ „—…  ⁄·Ì„…
unsigned char *b;

interrupt [EXT_INT0] void int0(void)
{                   

}
void main(void)
{
PORTD.2=1;
GICR=0b01000000;  // ›⁄·Ì ﬁÿ» «·„ﬁ«ÿ⁄… ’›—
MCUCR=0b00000010;
 //Ã»Â… Â«»ÿ… «‰ ﬁ«· „‰ 1 «·Ï 0
 #asm("sei")
   lcd_init(16);
  while (1)
        {  if(PIND.0==0  && f==0)     
  
      { 
       if(speed_ref<600)     //·«‰Ê «·„Õ—ﬂ »œÊ— 600 —«œÌ«‰ ⁄«·À«‰Ì…
        speed_ref+=5;   
        f=1;
       }
          { if(PIND.1==0  && f==0)
                   { 
                    if (speed_ref>0)
                     speed_ref-=5;
                      f=1;
                     }
                    
                     if(PIND.0==1 && PIND.1==1 && f==1)
                     f=0;
                          }
        
        
        
        
        lcd_clear();
        lcd_puts("fast=");
        lcd_gotoxy(7,0);
        //
        //
          lcd_puts("voltage=");
          lcd_gotoxy(10,1);
            //
        //
          delay_ms(1000);


        } 
}