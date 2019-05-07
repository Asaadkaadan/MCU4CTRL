#include <mega16.h>
#include <delay.h>
#define FOSC 1000000// Clock Speed
#define BAUD 2400
#define MYUBRR FOSC/16/BAUD-1
char ch;
void USART_Init( unsigned int ubrr)
{
/* Set baud rate */
UBRRH = (unsigned char)(ubrr>>8);
UBRRL = (unsigned char)ubrr;
/* Enable receiver and transmitter */
UCSRB = (1<<RXEN)|(1<<TXEN)|(1<<RXCIE);
/* Set frame format: 8data, 1 stop bit */
UCSRC = (1<<URSEL)|(3<<UCSZ0);
}
interrupt [12] void usart_tx_isr(void)
{
ch=UDR;
switch (ch)
{
case 'a':
PORTA.0=~PORTA.0;break;
case 'b':
PORTA.1=~PORTA.1;break;
case 'c':
PORTA.2=~PORTA.2;break;
}
}

void main( void )
{DDRA=0B00000111;
USART_Init ( MYUBRR );
#asm("sei");
while(1){}
}














