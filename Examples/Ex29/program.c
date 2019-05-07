#include <mega16.h>
#include <delay.h>
#define FOSC 1000000// Clock Speed
#define BAUD 2400
#define MYUBRR FOSC/16/BAUD-1
#define TX_BUFFER_SIZE 20
char press_f=0;
char tx_wr_index,tx_rd_index,tx_counter;
char tx_buffer[TX_BUFFER_SIZE];
void USART_Init( unsigned int ubrr)
{UBRRH = (unsigned char)(ubrr>>8);
UBRRL = (unsigned char)ubrr;
UCSRB = (1<<RXEN)|(1<<TXEN)|(1<<UDRIE);
UCSRC = (1<<URSEL)|(3<<UCSZ0);}
interrupt [13] void usart_tx_isr(void)
{if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index++];
   if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
   }}
void putchar(char c)
{#asm("cli")
if (tx_counter || UCSRA.UDRE==0)
  { tx_buffer[tx_wr_index++]=c;
  if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
    ++tx_counter;}
else
   UDR=c;
#asm("sei")}
void send_txtl(char *txt)
{char l=0;
while (txt[l]!=0)
{putchar(txt[l]);
l++;}
putchar(13);}
void main(void){
PORTA=0B000000111;
USART_Init(MYUBRR);
#asm("sei");
while (1){
if (PINA.0==0 && press_f==0)   
   {send_txtl("Microcotroller"); 
   press_f=1;}  
   if (PINA.1==0 && press_f==0)   
   {send_txtl("Atmle"); 
   press_f=1;}
   if (PINA.2==0 && press_f==0)   
   {send_txtl("Atmega16");
   press_f=1;}           
   if (PINA.0==1 && PINA.1==1 && PINA.2==1  && press_f==1)   
   press_f=0;
}}