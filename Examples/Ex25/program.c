#include <mega16.h>
#include <delay.h>
#define FOSC 1000000// Clock Speed
#define BAUD 2400
#define MYUBRR FOSC/16/BAUD-1

void USART_Init( unsigned int ubrr)
{
/* Set baud rate */
UBRRH = (unsigned char)(ubrr>>8);
UBRRL = (unsigned char)ubrr;
/* Enable receiver and transmitter */
UCSRB = (1<<RXEN)|(1<<TXEN);
/* Set frame format: 8data, 1 stop bit */
UCSRC = (1<<URSEL)|(3<<UCSZ0);
}
void USART_Transmit( unsigned char data )
{
/* Wait for empty transmit buffer */
while (!UCSRA.UDRE);
/* Put data into buffer, sends the data */
UDR = data;
}
unsigned char USART_Receive( void )
{
/* Wait for data to be received */
while ( !UCSRA.RXC ) ;

/* Get and return received data from buffer */
return UDR;
}

void main( void )
{

USART_Init ( MYUBRR );
while(1){
USART_Transmit('a');
USART_Transmit('b');
delay_ms(1000);
}
}
