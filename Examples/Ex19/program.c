#include <mega16.h> 
char press_f;  
int speed;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       #include <mega16.h>
void main(void){
// Timer/Counter 1 initialization
// Prescaler: 1
// Mode: Fast PWM R=10Bit
// OC1A output: Non-Inv.
// OC1B output: Discon.
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0B10000011;
TCCR1B=0B00001001;
//configure PD5(OC1A)-->OUTPUT
DDRD.5=1;
PORTA=0B00000011;
speed=500;
OCR1A=speed;
while(1){
if (PINA.0==0 && press_f==0)   
   { if (speed<1000)  
   speed=speed+100;
   OCR1A=speed;
   press_f=1; } 
    if (PINA.1==0 && press_f==0)   
   {if (speed >0)  
   speed=speed-100;
   OCR1A=speed;
    press_f=1;}
  if (PINA.0==1 && PINA.1==1  && press_f==1) {  
   press_f=0;}
}}
