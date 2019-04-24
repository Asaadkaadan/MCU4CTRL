#include <mega16.h> 
#include <delay.h>
#include <stdlib.h> 
#include <lcd.h>
#asm
.equ __lcd_port=0x1B ; PORTA
#endasm
char keypad16(void);
char press_f;
long number;
eeprom long e_number;
char s[8];
char kp;
void main(void) {
DDRD=0b00001111;
lcd_init(16);
lcd_gotoxy(0,0); 
lcd_puts("Number="); 
Loop:
kp=keypad16();
if (kp!=20)
{  
if (kp<10)
{if(number<9999999)
number=number*10+kp;
else
number=0;}
if (kp==10)e_number=number;
if (kp==11)number=e_number;
lcd_gotoxy(0,0); 
lcd_puts("Number="); 
ltoa(number,s);
lcd_gotoxy(7,0); 
lcd_puts("        ");
lcd_gotoxy(7,0); 
lcd_puts(s);}
goto Loop;}
char keypad16(void)
{char key=20;
PORTD=0B00000001;delay_ms(1);
if (PIND.4==1 && press_f==0)
{key=1;press_f=1;}
if (PIND.5==1 && press_f==0)
{key=2;press_f=1;}
if (PIND.6==1 && press_f==0)
{key=3;press_f=1;}
PORTD=0B00000010;delay_ms(1);
if (PIND.4==1 && press_f==0)
{key=4;press_f=1;}
if (PIND.5==1 && press_f==0)
{key=5;press_f=1;}
if (PIND.6==1 && press_f==0)
{key=6;press_f=1;}
PORTD=0B00000100;delay_ms(1);
if (PIND.4==1 && press_f==0)
{key=7;press_f=1;}
if (PIND.5==1 && press_f==0)
{key=8;press_f=1;}
if (PIND.6==1 && press_f==0)
{key=9;press_f=1;}
PORTD=0B00001000;delay_ms(1);
if (PIND.4==1 && press_f==0)
{key=10;press_f=1;}
if (PIND.5==1 && press_f==0)
{key=0;press_f=1;}
if (PIND.6==1 && press_f==0)
{key=11;press_f=1;}
PORTD=0B00001111;delay_ms(1);
if (PIND==0B00001111 && press_f==1)
{press_f=0;}
return key;}
