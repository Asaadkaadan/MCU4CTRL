/*******************************************************
Chip type               : ATmega16A
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega16a.h>
#include <stdlib.h>
#include <delay.h>
#include <alcd.h>
#include <stdio.h>
#include <string.h>

#define filling_valve (OCR1A)
#define discharge_valve (OCR1B)


// Declare your global variables here
 //bit s,d,p;

 int Mode = 0;
 int adc_data[6];
 int i;
 int _kp=0;
 int fill_display, dis_display;

 char buffer1[20];
 char buffer2[20];
 //char buffer3[20];

 volatile char message;
 volatile char data[20];

 float _ki= 0.00; float _kd= 0.00;
 float setpoint, sensor, error, integral, derivative, old_integral, pre_error;

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
    Mode = 1; //Manual
}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
    Mode = 2; //Auto_Mode_Full_PI
}

// External Interrupt 2 service routine
interrupt [EXT_INT2] void ext_int2_isr(void)
{
   Mode = 3; //Auto_Mode_Half_PI
}

// Declare your global variables here

#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)

// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index=0,rx_rd_index=0;
#else
unsigned int rx_wr_index=0,rx_rd_index=0;
#endif

#if RX_BUFFER_SIZE < 256
unsigned char rx_counter=0;
#else
unsigned int rx_counter=0;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
   int indx = 0;
   message = UDR;
    if(message == '\r') {
        indx =0;
        data[0] = 0;
    }else{
        data[indx] = message;
        indx++;
    }
    message = 0;

}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#endif
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE 8
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE <= 256
unsigned char tx_wr_index=0,tx_rd_index=0;
#else
unsigned int tx_wr_index=0,tx_rd_index=0;
#endif

#if TX_BUFFER_SIZE < 256
unsigned char tx_counter=0;
#else
unsigned int tx_counter=0;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index++];
#if TX_BUFFER_SIZE != 256
   if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
#asm("cli")
if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer[tx_wr_index++]=c;
#if TX_BUFFER_SIZE != 256
   if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
#endif
   ++tx_counter;
   }
else
   UDR=c;
#asm("sei")
}
#pragma used-
#endif

void send_txtl(char *txt)
{char l=0;
    while (txt[l]!=0)
    {
        putchar(txt[l]);
        l++;
    }
    putchar(0xD);
}

//char recieve_txt1()
//{
//   char line[20];
//   int  j = 0;
//while(1) {
//  line[i] = getchar();
//  if (line[i] == "\r\n") break;
//  i++;
//}
//line[i] = 0;
//
//}

// Voltage Reference: AREF pin
#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))

// ADC interrupt service routine
// with auto input scanning
interrupt [ADC_INT] void adc_isr(void)
{
// Read the AD conversion result
adc_data[i]=ADCW;
// Select next ADC input
i++;
if (i==6)  i=0;
ADMUX=i;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA.6=1;
}

float PI_calculation(float err, float kp, float ki, float kd)
{
    float Pout,Iout,Dout,output;

   // Proportional term
    Pout = kp * err;

   // Integral term
    integral = (old_integral + err) * 0.13;
    Iout = ki * integral;

   // Derivative term
    derivative = (err - pre_error) / 0.13;
    Dout = kd * derivative;

   // Calculate total output
    output = Pout + Iout + Dout;

   // Save previous data(Integral value)
    old_integral = integral;

   // Save error to previous error
    pre_error = err;

return output;
};


void main(void)
{
// Declare your local variables here


// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=P Bit3=T Bit2=P Bit1=T Bit0=P
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (1<<PORTB4) | (0<<PORTB3) | (1<<PORTB2) | (0<<PORTB1) | (1<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In
DDRD=(0<<DDD7) | (0<<DDD6) | (1<<DDD5) | (1<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=0 Bit4=0 Bit3=P Bit2=P Bit1=T Bit0=T
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 1000.000 kHz
// Mode: Fast PWM top=ICR1
// OC1A output: Non-Inverted PWM
// OC1B output: Non-Inverted PWM
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 20 ms
// Output Pulse(s):
// OC1A Period: 20 ms Width: 0 us
// OC1B Period: 20 ms Width: 0 us
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (1<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (1<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x4E;
ICR1L=0x1F;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: On
// INT1 Mode: Falling Edge
// INT2: On
// INT2 Mode: Falling Edge
GICR|=(1<<INT1) | (1<<INT0) | (1<<INT2);
MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);
GIFR=(1<<INTF1) | (1<<INTF0) | (1<<INTF2);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(1<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x33;

// ADC initialization
// ADC Clock frequency: 125.000 kHz
// ADC Voltage Reference: AREF pin
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (1<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (0<<ADPS0);
SFIOR=(0<<ACME);

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTC Bit 1
// RD - PORTC Bit 0
// EN - PORTD Bit 7
// D4 - PORTC Bit 4
// D5 - PORTC Bit 5
// D6 - PORTC Bit 6
// D7 - PORTC Bit 7
// Characters/line: 16
lcd_init(16);

// Global enable interrupts
#asm("sei")

ADCSRA.6=1;

putchar(0xD);
delay_ms(500);
send_txtl("stream 500 inf -v");

       lcd_puts("Welcome");
       delay_ms(500);
       lcd_clear();

    while (1)
    {

        switch (Mode)
        {

        case 0:
            _kp = adc_data[1]/10.23;
            _ki = adc_data[2]/102.3;
            _kd = adc_data[3]/102.3;

            sprintf(buffer1,"P=%d I=%f D=%f",_kp,_ki,_kd);
            lcd_puts(buffer1);
            delay_ms(500);
            lcd_gotoxy(0,1);

            lcd_clear();
        break;

        case 1:  //Manual_Mode

            filling_valve = (65 + adc_data[5]/4.35)*10;

            discharge_valve = (65 + adc_data[4]/4.35)*10;

            fill_display = ((65 + adc_data[5]/4.35)*10)*0.06;
            dis_display = ((65 + adc_data[4]/4.35)*10)*0.06;

            sprintf(buffer1,"SRC= %d deg",fill_display);
            lcd_puts(buffer1);
            lcd_gotoxy(0,1);
            sprintf(buffer2,"DIS= %d deg",dis_display);
            lcd_puts(buffer2);
            delay_ms(500);
            lcd_clear();

        break;

        case 2:  //Auto_Mode_Full_PI

            setpoint = (adc_data[0]/10.23)*10;
            _kp = adc_data[1]/10.23;
            _ki = adc_data[2]/1023;
            _kd = adc_data[3]/1023;


            //sensor = atof(data);
            sensor = 500;
            error = setpoint - sensor;

            sprintf(buffer1,"setpoint=%f",setpoint);
            lcd_puts(buffer1);
            lcd_gotoxy(0,1);
            sprintf(buffer2,"Error=%f",error);
            lcd_puts(buffer2);
            delay_ms(1500);
            lcd_clear();

//            sprintf(buffer3,"Sensor=%f",sensor);
//            lcd_puts(buffer3);
//            delay_ms(1500);
//            lcd_clear();

            if(error>0)
            {
                discharge_valve = PI_calculation(error, _kp, _ki, _kd);
                filling_valve = 60;
            }
            else if(error<0)
            {
                error = abs(error);
                filling_valve = PI_calculation(error, _kp, _ki, _kd);
                discharge_valve = 60;
            }


        break;

        case 3:  //Auto_Mode_Half_PI

            setpoint = (adc_data[0]/10.23)*10;
            _kp = adc_data[1]/10.23;
            _ki = adc_data[2]/1023;
            _kd = adc_data[3]/1023;

            sensor = 500;
            error = setpoint - sensor;

            send_txtl("stream 500 inf p4");

            sprintf(buffer1,"setpoint=%f",setpoint);
            lcd_puts(buffer1);
            lcd_gotoxy(0,1);
            sprintf(buffer2,"Error=%f",error);
            lcd_puts(buffer2);
            delay_ms(500);
            lcd_clear();

            if(error>0)
            {
                discharge_valve = 65 + adc_data[4]/4.35;
                filling_valve = 60;
            }
            else if(error<0)
            {
                error = abs(error);
                filling_valve = PI_calculation(error, _kp, _ki, _kd);
                discharge_valve = 60;
            }


        break;
        };

    }



}
