/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 1/6/2020
Author  : BeSHeRXs
Company : 
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/
  
             
bit C1=0;
bit C2=0 ; 
bit C3=0;                     
bit C4=0 ;   
bit C5=0;

             
             
 
#include <mega16.h>

#include <lcd.h>
#include <delay.h>
#include <stdlib.h>
unsigned char *str;         
#asm
.equ __lcd_port=0x15 ;PORTC
#endasm

float Position_ref=0;
float Position=0;
 
bit sampling=0;


interrupt [TIM2_COMP] void timer2_comp_isr(void) 
{
//sampling=1;
PORTA.7=1;
ADCSRA.6=1;

}



interrupt [EXT_INT0] void direction (void)
{
                        
if(C1==1) Position_ref=30;
else if(C2==1) Position_ref=60;
else if(C3==1) Position_ref=90;
else if(C4==1) Position_ref=120;
else if(C5==1) Position_ref=150;
else Position_ref=0;



}


void main(void)  
{


      
// PI:
const float kp=1,ki=0,Ts=0.001;
float e_k=0,e_k_1=0;
float u_k=0,u_k_1=0;
const float a=(kp+ki*Ts),b=-kp;
//PI



bit M=0;
char moving[8]={0b00001001,0b00001000,0b00001100,0b00000100,0b000000110,0b00000010,0b00000011,0b000010001};

int counter=0;

lcd_init(16);

DDRD=0x00;
DDRA.7=1;
PORTD=0xFF;
DDRB=0XFF;
GICR=0b01000000;
MCUCR=0B00000010;
ADMUX=0b00000000;
ADCSRA=0B10000110;

TCCR2=0b00001011;
OCR2=0xF9;
TIMSK=0b10000000;









    


#asm ("sei")

while (1)
      { 
      
      if (PIND.7==0&&M==0) 
      {
      M=1   ;
      C1=~C1  ;
      } 
      
      
    if (PIND.6==0&&M==0) 
      {
      M=1   ;
      C2=~C2;   }  
      
      
    if (PIND.5==0&&M==0) 
      {
      M=1   ;
      C3=~C3  ;
      }  
      
      
    if (PIND.4==0&&M==0) 
      {
      M=1   ;
      C4=~C4  ;
      }  
      
      
    if (PIND.3==0&&M==0) 
      {
      M=1   ;
      C5=~C5   ;
      }  
      
      
    if (PIND.7==1 && PIND.6==1 && PIND.5==1 && PIND.4==1 && PIND.3==1 && M==1)
                 M=0;  
                 
                 


      
      
      
      //start lcd
      lcd_clear();  
     lcd_puts("Position="); 
itoa(Position,str);
  lcd_puts(str) ; 
  
  
    
     lcd_gotoxy(0,1);
              
     if (C1==1)
     {
     //Position_ref=10;
     lcd_puts("C1");
     }
     else
     lcd_puts("  ");  
     
     
     if (C2==1)
     {//Position_ref=15 ;
     lcd_puts("C2");
     }
     else
     lcd_puts("  "); 
     
     
     if (C3==1)
     { //Position_ref=20 ;
     
     
     lcd_puts("C3");
     }
     else
     lcd_puts("  "); 
     
     
     
     if (C4==1)
     {  
     //Position_ref=25; 
     lcd_puts("C4");
     }
     else
     lcd_puts("  ");  
     
     
     if (C5==1)
     {  //Position_ref=30;
     
     
     lcd_puts("C5");
     }
     else
     lcd_puts("  "); 
     delay_ms(50);
     //end lcd
     
     
     
     
//if(sampling==1)
//{      

      //adc start                
Position=0.175953*ADCW;   //0.175953 = 180/1023
//adc end

e_k=Position_ref-Position;
u_k=a*e_k+b*e_k_1+u_k_1;
u_k_1=u_k;
e_k_1=e_k;

if(u_k>1.5) {
PORTB=moving[counter] ;
counter++;
if(counter==8) counter=0;
}

if(u_k<-1.5) {
counter=8;
 PORTB=moving[counter];
counter--;
if(counter==-1) counter=8;
 }



sampling=0;
}    

}
