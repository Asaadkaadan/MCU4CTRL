#include <mega16.h>
#include <delay.h>
#define FOSC 1000000// Clock Speed
#define BAUD 2400
#define MYUBRR FOSC/16/BAUD-1
char press_f=0;
void USART_Init( unsigned int ubrr)
{/* Set baud rate */
UBRRH = (unsigned char)(ubrr>>8);
UBRRL = (unsigned char)ubrr;
/* Enable receiver and transmitter */
UCSRB = (1<<RXEN)|(1<<TXEN);
/* Set frame format: 8data, 1 stop bit */
UCSRC = (1<<URSEL)|(3<<UCSZ0);}
void USART_Transmit( unsigned char data )
{/* Wait for empty transmit buffer */
while (!UCSRA.UDRE);
/* Put data into buffer, sends the data */
UDR = data;}
void main( void )
{PORTA=0B00000111;
USART_Init ( MYUBRR );
while (1){
if (PINA.0==0 && press_f==0)   
   { USART_Transmit('a');
   press_f=1;}  
   if (PINA.1==0 && press_f==0)   
   {USART_Transmit('b');
   press_f=1;}
   if (PINA.2==0 && press_f==0)   
   {USART_Transmit('c');
   press_f=1;}           
   if (PINA.0==1 && PINA.1==1 && PINA.2==1  && press_f==1)   
   press_f=0;
}}
