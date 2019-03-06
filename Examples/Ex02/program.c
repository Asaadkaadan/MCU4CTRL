#include <mega16.h>
#include <delay.h>
__interrupt void external_int0(void) {
/* Place your code here */


}

void main(){
DDRC=0B01111111;
DDRB.0=1;
while (1)
      {
      if (PINB.0==1)   PORTC=0B00000110;
      if (PINB.0==1)   PORTC=0B01011011;
      }
}
