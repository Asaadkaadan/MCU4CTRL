#include <mega16.h>
#include <delay.h>
void main(void){
 DDRC=0b11111111 ;
 loop:
 switch (PINB)
 {
case 0b00000000:
   PORTC=0B00111111; break;
case 0b00000001:
  PORTC=0B00000110; break;
  case 0b00000011:
  PORTC=0B01011011; break;
case 0b00000111:
  PORTC=0B01001111 ; break;
  case 0b00001111:
  PORTC=0B01100110; break;
  case 0b00011111:
  PORTC=0B01101101 ; break;
 default:
  PORTC=0B01111001;
 }
 goto loop;
}
