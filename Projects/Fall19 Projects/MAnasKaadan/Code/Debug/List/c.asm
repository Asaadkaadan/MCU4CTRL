
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16A
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16A
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _Mode=R4
	.DEF _Mode_msb=R5
	.DEF _i=R6
	.DEF _i_msb=R7
	.DEF __kp=R8
	.DEF __kp_msb=R9
	.DEF _fill_display=R10
	.DEF _fill_display_msb=R11
	.DEF _dis_display=R12
	.DEF _dis_display_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  _adc_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _ext_int2_isr
	JMP  0x00
	JMP  0x00

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x0:
	.DB  0x73,0x74,0x72,0x65,0x61,0x6D,0x20,0x35
	.DB  0x30,0x30,0x20,0x69,0x6E,0x66,0x20,0x2D
	.DB  0x76,0x0,0x57,0x65,0x6C,0x63,0x6F,0x6D
	.DB  0x65,0x0,0x50,0x3D,0x25,0x64,0x20,0x49
	.DB  0x3D,0x25,0x66,0x20,0x44,0x3D,0x25,0x66
	.DB  0x0,0x53,0x52,0x43,0x3D,0x20,0x25,0x64
	.DB  0x20,0x64,0x65,0x67,0x0,0x44,0x49,0x53
	.DB  0x3D,0x20,0x25,0x64,0x20,0x64,0x65,0x67
	.DB  0x0,0x73,0x65,0x74,0x70,0x6F,0x69,0x6E
	.DB  0x74,0x3D,0x25,0x66,0x0,0x45,0x72,0x72
	.DB  0x6F,0x72,0x3D,0x25,0x66,0x0,0x73,0x74
	.DB  0x72,0x65,0x61,0x6D,0x20,0x35,0x30,0x30
	.DB  0x20,0x69,0x6E,0x66,0x20,0x70,0x34,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2020003:
	.DB  0x80,0xC0
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x06
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x12
	.DW  _0x1B
	.DW  _0x0*2

	.DW  0x08
	.DW  _0x1B+18
	.DW  _0x0*2+18

	.DW  0x12
	.DW  _0x1B+26
	.DW  _0x0*2+86

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;Chip type               : ATmega16A
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega16a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdlib.h>
;#include <delay.h>
;#include <alcd.h>
;#include <stdio.h>
;#include <string.h>
;
;#define filling_valve (OCR1A)
;#define discharge_valve (OCR1B)
;
;
;// Declare your global variables here
; //bit s,d,p;
;
; int Mode = 0;
; int adc_data[6];
; int i;
; int _kp=0;
; int fill_display, dis_display;
;
; char buffer1[20];
; char buffer2[20];
; //char buffer3[20];
;
; volatile char message;
; volatile char data[20];
;
; float _ki= 0.00; float _kd= 0.00;
; float setpoint, sensor, error, integral, derivative, old_integral, pre_error;
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 002A {

	.CSEG
_ext_int0_isr:
; .FSTART _ext_int0_isr
	ST   -Y,R30
	ST   -Y,R31
; 0000 002B     Mode = 1; //Manual
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x2E
; 0000 002C }
; .FEND
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0030 {
_ext_int1_isr:
; .FSTART _ext_int1_isr
	ST   -Y,R30
	ST   -Y,R31
; 0000 0031     Mode = 2; //Auto_Mode_Full_PI
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x2E
; 0000 0032 }
; .FEND
;
;// External Interrupt 2 service routine
;interrupt [EXT_INT2] void ext_int2_isr(void)
; 0000 0036 {
_ext_int2_isr:
; .FSTART _ext_int2_isr
	ST   -Y,R30
	ST   -Y,R31
; 0000 0037    Mode = 3; //Auto_Mode_Half_PI
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
_0x2E:
	MOVW R4,R30
; 0000 0038 }
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;// Declare your global variables here
;
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index=0,rx_rd_index=0;
;#else
;unsigned int rx_wr_index=0,rx_rd_index=0;
;#endif
;
;#if RX_BUFFER_SIZE < 256
;unsigned char rx_counter=0;
;#else
;unsigned int rx_counter=0;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0057 {
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0058    int indx = 0;
; 0000 0059    message = UDR;
	ST   -Y,R17
	ST   -Y,R16
;	indx -> R16,R17
	__GETWRN 16,17,0
	IN   R30,0xC
	STS  _message,R30
; 0000 005A     if(message == '\r') {
	LDS  R26,_message
	CPI  R26,LOW(0xD)
	BRNE _0x3
; 0000 005B         indx =0;
	__GETWRN 16,17,0
; 0000 005C         data[0] = 0;
	LDI  R30,LOW(0)
	STS  _data,R30
; 0000 005D     }else{
	RJMP _0x4
_0x3:
; 0000 005E         data[indx] = message;
	MOVW R30,R16
	SUBI R30,LOW(-_data)
	SBCI R31,HIGH(-_data)
	LDS  R26,_message
	STD  Z+0,R26
; 0000 005F         indx++;
	__ADDWRN 16,17,1
; 0000 0060     }
_0x4:
; 0000 0061     message = 0;
	LDI  R30,LOW(0)
	STS  _message,R30
; 0000 0062 
; 0000 0063 }
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x2D
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 006A {
; 0000 006B char data;
; 0000 006C while (rx_counter==0);
;	data -> R17
; 0000 006D data=rx_buffer[rx_rd_index++];
; 0000 006E #if RX_BUFFER_SIZE != 256
; 0000 006F if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
; 0000 0070 #endif
; 0000 0071 #asm("cli")
; 0000 0072 --rx_counter;
; 0000 0073 #asm("sei")
; 0000 0074 return data;
; 0000 0075 }
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 8
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE <= 256
;unsigned char tx_wr_index=0,tx_rd_index=0;
;#else
;unsigned int tx_wr_index=0,tx_rd_index=0;
;#endif
;
;#if TX_BUFFER_SIZE < 256
;unsigned char tx_counter=0;
;#else
;unsigned int tx_counter=0;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 008B {
_usart_tx_isr:
; .FSTART _usart_tx_isr
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 008C if (tx_counter)
	LDS  R30,_tx_counter
	CPI  R30,0
	BREQ _0x9
; 0000 008D    {
; 0000 008E    --tx_counter;
	SUBI R30,LOW(1)
	STS  _tx_counter,R30
; 0000 008F    UDR=tx_buffer[tx_rd_index++];
	LDS  R30,_tx_rd_index
	SUBI R30,-LOW(1)
	STS  _tx_rd_index,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 0090 #if TX_BUFFER_SIZE != 256
; 0000 0091    if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDS  R26,_tx_rd_index
	CPI  R26,LOW(0x8)
	BRNE _0xA
	LDI  R30,LOW(0)
	STS  _tx_rd_index,R30
; 0000 0092 #endif
; 0000 0093    }
_0xA:
; 0000 0094 }
_0x9:
_0x2D:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 009B {
_putchar:
; .FSTART _putchar
; 0000 009C while (tx_counter == TX_BUFFER_SIZE);
	ST   -Y,R26
;	c -> Y+0
_0xB:
	LDS  R26,_tx_counter
	CPI  R26,LOW(0x8)
	BREQ _0xB
; 0000 009D #asm("cli")
	cli
; 0000 009E if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	LDS  R30,_tx_counter
	CPI  R30,0
	BRNE _0xF
	SBIC 0xB,5
	RJMP _0xE
_0xF:
; 0000 009F    {
; 0000 00A0    tx_buffer[tx_wr_index++]=c;
	LDS  R30,_tx_wr_index
	SUBI R30,-LOW(1)
	STS  _tx_wr_index,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
; 0000 00A1 #if TX_BUFFER_SIZE != 256
; 0000 00A2    if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDS  R26,_tx_wr_index
	CPI  R26,LOW(0x8)
	BRNE _0x11
	LDI  R30,LOW(0)
	STS  _tx_wr_index,R30
; 0000 00A3 #endif
; 0000 00A4    ++tx_counter;
_0x11:
	LDS  R30,_tx_counter
	SUBI R30,-LOW(1)
	STS  _tx_counter,R30
; 0000 00A5    }
; 0000 00A6 else
	RJMP _0x12
_0xE:
; 0000 00A7    UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00A8 #asm("sei")
_0x12:
	sei
; 0000 00A9 }
	JMP  _0x20C0004
; .FEND
;#pragma used-
;#endif
;
;void send_txtl(char *txt)
; 0000 00AE {char l=0;
_send_txtl:
; .FSTART _send_txtl
; 0000 00AF     while (txt[l]!=0)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*txt -> Y+1
;	l -> R17
	LDI  R17,0
_0x13:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	CPI  R30,0
	BREQ _0x15
; 0000 00B0     {
; 0000 00B1         putchar(txt[l]);
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	RCALL _putchar
; 0000 00B2         l++;
	SUBI R17,-1
; 0000 00B3     }
	RJMP _0x13
_0x15:
; 0000 00B4     putchar(0xD);
	LDI  R26,LOW(13)
	RCALL _putchar
; 0000 00B5 }
	JMP  _0x20C0005
; .FEND
;
;//char recieve_txt1()
;//{
;//   char line[20];
;//   int  j = 0;
;//while(1) {
;//  line[i] = getchar();
;//  if (line[i] == "\r\n") break;
;//  i++;
;//}
;//line[i] = 0;
;//
;//}
;
;// Voltage Reference: AREF pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
;
;// ADC interrupt service routine
;// with auto input scanning
;interrupt [ADC_INT] void adc_isr(void)
; 0000 00CA {
_adc_isr:
; .FSTART _adc_isr
	ST   -Y,R24
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00CB // Read the AD conversion result
; 0000 00CC adc_data[i]=ADCW;
	MOVW R30,R6
	LDI  R26,LOW(_adc_data)
	LDI  R27,HIGH(_adc_data)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	IN   R30,0x4
	IN   R31,0x4+1
	ST   X+,R30
	ST   X,R31
; 0000 00CD // Select next ADC input
; 0000 00CE i++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 00CF if (i==6)  i=0;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x16
	CLR  R6
	CLR  R7
; 0000 00D0 ADMUX=i;
_0x16:
	OUT  0x7,R6
; 0000 00D1 // Delay needed for the stabilization of the ADC input voltage
; 0000 00D2 delay_us(10);
	__DELAY_USB 27
; 0000 00D3 // Start the AD conversion
; 0000 00D4 ADCSRA.6=1;
	SBI  0x6,6
; 0000 00D5 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R24,Y+
	RETI
; .FEND
;
;float PI_calculation(float err, float kp, float ki, float kd)
; 0000 00D8 {
_PI_calculation:
; .FSTART _PI_calculation
; 0000 00D9     float Pout,Iout,Dout,output;
; 0000 00DA 
; 0000 00DB    // Proportional term
; 0000 00DC     Pout = kp * err;
	CALL __PUTPARD2
	SBIW R28,16
;	err -> Y+28
;	kp -> Y+24
;	ki -> Y+20
;	kd -> Y+16
;	Pout -> Y+12
;	Iout -> Y+8
;	Dout -> Y+4
;	output -> Y+0
	CALL SUBOPT_0x0
	__GETD2S 24
	CALL SUBOPT_0x1
; 0000 00DD 
; 0000 00DE    // Integral term
; 0000 00DF     integral = (old_integral + err) * 0.13;
	CALL SUBOPT_0x0
	LDS  R26,_old_integral
	LDS  R27,_old_integral+1
	LDS  R24,_old_integral+2
	LDS  R25,_old_integral+3
	CALL __ADDF12
	__GETD2N 0x3E051EB8
	CALL __MULF12
	STS  _integral,R30
	STS  _integral+1,R31
	STS  _integral+2,R22
	STS  _integral+3,R23
; 0000 00E0     Iout = ki * integral;
	CALL SUBOPT_0x2
	__GETD2S 20
	CALL __MULF12
	__PUTD1S 8
; 0000 00E1 
; 0000 00E2    // Derivative term
; 0000 00E3     derivative = (err - pre_error) / 0.13;
	LDS  R26,_pre_error
	LDS  R27,_pre_error+1
	LDS  R24,_pre_error+2
	LDS  R25,_pre_error+3
	CALL SUBOPT_0x0
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3E051EB8
	CALL __DIVF21
	STS  _derivative,R30
	STS  _derivative+1,R31
	STS  _derivative+2,R22
	STS  _derivative+3,R23
; 0000 00E4     Dout = kd * derivative;
	CALL SUBOPT_0x3
	CALL SUBOPT_0x4
; 0000 00E5 
; 0000 00E6    // Calculate total output
; 0000 00E7     output = Pout + Iout + Dout;
	__GETD1S 8
	CALL SUBOPT_0x5
	CALL __ADDF12
	CALL SUBOPT_0x6
	CALL __ADDF12
	CALL __PUTD1S0
; 0000 00E8 
; 0000 00E9    // Save previous data(Integral value)
; 0000 00EA     old_integral = integral;
	CALL SUBOPT_0x2
	STS  _old_integral,R30
	STS  _old_integral+1,R31
	STS  _old_integral+2,R22
	STS  _old_integral+3,R23
; 0000 00EB 
; 0000 00EC    // Save error to previous error
; 0000 00ED     pre_error = err;
	CALL SUBOPT_0x0
	STS  _pre_error,R30
	STS  _pre_error+1,R31
	STS  _pre_error+2,R22
	STS  _pre_error+3,R23
; 0000 00EE 
; 0000 00EF return output;
	CALL SUBOPT_0x7
	ADIW R28,32
	RET
; 0000 00F0 };
; .FEND
;
;
;void main(void)
; 0000 00F4 {
_main:
; .FSTART _main
; 0000 00F5 // Declare your local variables here
; 0000 00F6 
; 0000 00F7 
; 0000 00F8 // Input/Output Ports initialization
; 0000 00F9 // Port A initialization
; 0000 00FA // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00FB DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 00FC // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00FD PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 00FE 
; 0000 00FF // Port B initialization
; 0000 0100 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0101 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 0102 // State: Bit7=T Bit6=T Bit5=T Bit4=P Bit3=T Bit2=P Bit1=T Bit0=P
; 0000 0103 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (1<<PORTB4) | (0<<PORTB3) | (1<<PORTB2) | (0<<PORTB1) | (1<<PORTB0);
	LDI  R30,LOW(21)
	OUT  0x18,R30
; 0000 0104 
; 0000 0105 // Port C initialization
; 0000 0106 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0107 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 0108 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0109 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 010A 
; 0000 010B // Port D initialization
; 0000 010C // Function: Bit7=In Bit6=In Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 010D DDRD=(0<<DDD7) | (0<<DDD6) | (1<<DDD5) | (1<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(48)
	OUT  0x11,R30
; 0000 010E // State: Bit7=T Bit6=T Bit5=0 Bit4=0 Bit3=P Bit2=P Bit1=T Bit0=T
; 0000 010F PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(12)
	OUT  0x12,R30
; 0000 0110 
; 0000 0111 // Timer/Counter 1 initialization
; 0000 0112 // Clock source: System Clock
; 0000 0113 // Clock value: 1000.000 kHz
; 0000 0114 // Mode: Fast PWM top=ICR1
; 0000 0115 // OC1A output: Non-Inverted PWM
; 0000 0116 // OC1B output: Non-Inverted PWM
; 0000 0117 // Noise Canceler: Off
; 0000 0118 // Input Capture on Falling Edge
; 0000 0119 // Timer Period: 20 ms
; 0000 011A // Output Pulse(s):
; 0000 011B // OC1A Period: 20 ms Width: 0 us
; 0000 011C // OC1B Period: 20 ms Width: 0 us
; 0000 011D // Timer1 Overflow Interrupt: Off
; 0000 011E // Input Capture Interrupt: Off
; 0000 011F // Compare A Match Interrupt: Off
; 0000 0120 // Compare B Match Interrupt: Off
; 0000 0121 TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (1<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(162)
	OUT  0x2F,R30
; 0000 0122 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (1<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
	LDI  R30,LOW(26)
	OUT  0x2E,R30
; 0000 0123 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0124 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0125 ICR1H=0x4E;
	LDI  R30,LOW(78)
	OUT  0x27,R30
; 0000 0126 ICR1L=0x1F;
	LDI  R30,LOW(31)
	OUT  0x26,R30
; 0000 0127 OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
; 0000 0128 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0129 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 012A OCR1BL=0x00;
	OUT  0x28,R30
; 0000 012B 
; 0000 012C // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 012D TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 012E 
; 0000 012F // External Interrupt(s) initialization
; 0000 0130 // INT0: On
; 0000 0131 // INT0 Mode: Falling Edge
; 0000 0132 // INT1: On
; 0000 0133 // INT1 Mode: Falling Edge
; 0000 0134 // INT2: On
; 0000 0135 // INT2 Mode: Falling Edge
; 0000 0136 GICR|=(1<<INT1) | (1<<INT0) | (1<<INT2);
	IN   R30,0x3B
	ORI  R30,LOW(0xE0)
	OUT  0x3B,R30
; 0000 0137 MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(10)
	OUT  0x35,R30
; 0000 0138 MCUCSR=(0<<ISC2);
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 0139 GIFR=(1<<INTF1) | (1<<INTF0) | (1<<INTF2);
	LDI  R30,LOW(224)
	OUT  0x3A,R30
; 0000 013A 
; 0000 013B // USART initialization
; 0000 013C // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 013D // USART Receiver: On
; 0000 013E // USART Transmitter: On
; 0000 013F // USART Mode: Asynchronous
; 0000 0140 // USART Baud Rate: 9600
; 0000 0141 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0142 UCSRB=(1<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 0143 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0144 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0145 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0146 
; 0000 0147 // ADC initialization
; 0000 0148 // ADC Clock frequency: 125.000 kHz
; 0000 0149 // ADC Voltage Reference: AREF pin
; 0000 014A ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 014B ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (1<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (0<<ADPS0);
	LDI  R30,LOW(142)
	OUT  0x6,R30
; 0000 014C SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 014D 
; 0000 014E // Alphanumeric LCD initialization
; 0000 014F // Connections are specified in the
; 0000 0150 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0151 // RS - PORTC Bit 1
; 0000 0152 // RD - PORTC Bit 0
; 0000 0153 // EN - PORTD Bit 7
; 0000 0154 // D4 - PORTC Bit 4
; 0000 0155 // D5 - PORTC Bit 5
; 0000 0156 // D6 - PORTC Bit 6
; 0000 0157 // D7 - PORTC Bit 7
; 0000 0158 // Characters/line: 16
; 0000 0159 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 015A 
; 0000 015B // Global enable interrupts
; 0000 015C #asm("sei")
	sei
; 0000 015D 
; 0000 015E ADCSRA.6=1;
	SBI  0x6,6
; 0000 015F 
; 0000 0160 putchar(0xD);
	LDI  R26,LOW(13)
	RCALL _putchar
; 0000 0161 delay_ms(500);
	CALL SUBOPT_0x8
; 0000 0162 send_txtl("stream 500 inf -v");
	__POINTW2MN _0x1B,0
	RCALL _send_txtl
; 0000 0163 
; 0000 0164        lcd_puts("Welcome");
	__POINTW2MN _0x1B,18
	CALL SUBOPT_0x9
; 0000 0165        delay_ms(500);
; 0000 0166        lcd_clear();
	CALL _lcd_clear
; 0000 0167 
; 0000 0168     while (1)
_0x1C:
; 0000 0169     {
; 0000 016A 
; 0000 016B         switch (Mode)
	MOVW R30,R4
; 0000 016C         {
; 0000 016D 
; 0000 016E         case 0:
	SBIW R30,0
	BREQ PC+2
	RJMP _0x22
; 0000 016F             _kp = adc_data[1]/10.23;
	CALL SUBOPT_0xA
; 0000 0170             _ki = adc_data[2]/102.3;
	__GETW1MN _adc_data,4
	CALL SUBOPT_0xB
	STS  __ki,R30
	STS  __ki+1,R31
	STS  __ki+2,R22
	STS  __ki+3,R23
; 0000 0171             _kd = adc_data[3]/102.3;
	__GETW1MN _adc_data,6
	CALL SUBOPT_0xB
	STS  __kd,R30
	STS  __kd+1,R31
	STS  __kd+2,R22
	STS  __kd+3,R23
; 0000 0172 
; 0000 0173             sprintf(buffer1,"P=%d I=%f D=%f",_kp,_ki,_kd);
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,26
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R8
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
	LDS  R30,__kd
	LDS  R31,__kd+1
	LDS  R22,__kd+2
	LDS  R23,__kd+3
	CALL __PUTPARD1
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 0174             lcd_puts(buffer1);
	LDI  R26,LOW(_buffer1)
	LDI  R27,HIGH(_buffer1)
	CALL SUBOPT_0x9
; 0000 0175             delay_ms(500);
; 0000 0176             lcd_gotoxy(0,1);
	CALL SUBOPT_0xF
; 0000 0177 
; 0000 0178             lcd_clear();
	CALL _lcd_clear
; 0000 0179         break;
	RJMP _0x21
; 0000 017A 
; 0000 017B         case 1:  //Manual_Mode
_0x22:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x23
; 0000 017C 
; 0000 017D             filling_valve = (65 + adc_data[5]/4.35)*10;
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
; 0000 017E 
; 0000 017F             discharge_valve = (65 + adc_data[4]/4.35)*10;
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
; 0000 0180 
; 0000 0181             fill_display = ((65 + adc_data[5]/4.35)*10)*0.06;
	CALL SUBOPT_0x10
	CALL SUBOPT_0x14
	MOVW R10,R30
; 0000 0182             dis_display = ((65 + adc_data[4]/4.35)*10)*0.06;
	CALL SUBOPT_0x12
	CALL SUBOPT_0x14
	MOVW R12,R30
; 0000 0183 
; 0000 0184             sprintf(buffer1,"SRC= %d deg",fill_display);
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,41
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R10
	CALL SUBOPT_0xD
	CALL SUBOPT_0x15
; 0000 0185             lcd_puts(buffer1);
	CALL SUBOPT_0x16
; 0000 0186             lcd_gotoxy(0,1);
; 0000 0187             sprintf(buffer2,"DIS= %d deg",dis_display);
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,53
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R12
	CALL SUBOPT_0xD
	CALL SUBOPT_0x15
; 0000 0188             lcd_puts(buffer2);
	LDI  R26,LOW(_buffer2)
	LDI  R27,HIGH(_buffer2)
	CALL SUBOPT_0x9
; 0000 0189             delay_ms(500);
; 0000 018A             lcd_clear();
	CALL _lcd_clear
; 0000 018B 
; 0000 018C         break;
	RJMP _0x21
; 0000 018D 
; 0000 018E         case 2:  //Auto_Mode_Full_PI
_0x23:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x24
; 0000 018F 
; 0000 0190             setpoint = (adc_data[0]/10.23)*10;
	CALL SUBOPT_0x18
; 0000 0191             _kp = adc_data[1]/10.23;
; 0000 0192             _ki = adc_data[2]/1023;
	CALL SUBOPT_0x19
; 0000 0193             _kd = adc_data[3]/1023;
; 0000 0194 
; 0000 0195 
; 0000 0196             //sensor = atof(data);
; 0000 0197             sensor = 500;
; 0000 0198             error = setpoint - sensor;
; 0000 0199 
; 0000 019A             sprintf(buffer1,"setpoint=%f",setpoint);
	CALL SUBOPT_0xC
	CALL SUBOPT_0x1A
; 0000 019B             lcd_puts(buffer1);
	CALL SUBOPT_0x16
; 0000 019C             lcd_gotoxy(0,1);
; 0000 019D             sprintf(buffer2,"Error=%f",error);
	CALL SUBOPT_0x17
	CALL SUBOPT_0x1B
; 0000 019E             lcd_puts(buffer2);
	LDI  R26,LOW(_buffer2)
	LDI  R27,HIGH(_buffer2)
	CALL _lcd_puts
; 0000 019F             delay_ms(1500);
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	CALL _delay_ms
; 0000 01A0             lcd_clear();
	CALL SUBOPT_0x1C
; 0000 01A1 
; 0000 01A2 //            sprintf(buffer3,"Sensor=%f",sensor);
; 0000 01A3 //            lcd_puts(buffer3);
; 0000 01A4 //            delay_ms(1500);
; 0000 01A5 //            lcd_clear();
; 0000 01A6 
; 0000 01A7             if(error>0)
	BRGE _0x25
; 0000 01A8             {
; 0000 01A9                 discharge_valve = PI_calculation(error, _kp, _ki, _kd);
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x13
; 0000 01AA                 filling_valve = 60;
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 01AB             }
; 0000 01AC             else if(error<0)
	RJMP _0x26
_0x25:
	LDS  R26,_error+3
	TST  R26
	BRPL _0x27
; 0000 01AD             {
; 0000 01AE                 error = abs(error);
	CALL SUBOPT_0x20
; 0000 01AF                 filling_valve = PI_calculation(error, _kp, _ki, _kd);
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x11
; 0000 01B0                 discharge_valve = 60;
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 01B1             }
; 0000 01B2 
; 0000 01B3 
; 0000 01B4         break;
_0x27:
_0x26:
	RJMP _0x21
; 0000 01B5 
; 0000 01B6         case 3:  //Auto_Mode_Half_PI
_0x24:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x21
; 0000 01B7 
; 0000 01B8             setpoint = (adc_data[0]/10.23)*10;
	CALL SUBOPT_0x18
; 0000 01B9             _kp = adc_data[1]/10.23;
; 0000 01BA             _ki = adc_data[2]/1023;
	CALL SUBOPT_0x19
; 0000 01BB             _kd = adc_data[3]/1023;
; 0000 01BC 
; 0000 01BD             sensor = 500;
; 0000 01BE             error = setpoint - sensor;
; 0000 01BF 
; 0000 01C0             send_txtl("stream 500 inf p4");
	__POINTW2MN _0x1B,26
	RCALL _send_txtl
; 0000 01C1 
; 0000 01C2             sprintf(buffer1,"setpoint=%f",setpoint);
	CALL SUBOPT_0xC
	CALL SUBOPT_0x1A
; 0000 01C3             lcd_puts(buffer1);
	CALL SUBOPT_0x16
; 0000 01C4             lcd_gotoxy(0,1);
; 0000 01C5             sprintf(buffer2,"Error=%f",error);
	CALL SUBOPT_0x17
	CALL SUBOPT_0x1B
; 0000 01C6             lcd_puts(buffer2);
	LDI  R26,LOW(_buffer2)
	LDI  R27,HIGH(_buffer2)
	CALL SUBOPT_0x9
; 0000 01C7             delay_ms(500);
; 0000 01C8             lcd_clear();
	CALL SUBOPT_0x1C
; 0000 01C9 
; 0000 01CA             if(error>0)
	BRGE _0x29
; 0000 01CB             {
; 0000 01CC                 discharge_valve = 65 + adc_data[4]/4.35;
	__GETW1MN _adc_data,8
	CALL SUBOPT_0x21
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x408B3333
	CALL __DIVF21
	__GETD2N 0x42820000
	CALL __ADDF12
	CALL SUBOPT_0x13
; 0000 01CD                 filling_valve = 60;
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 01CE             }
; 0000 01CF             else if(error<0)
	RJMP _0x2A
_0x29:
	LDS  R26,_error+3
	TST  R26
	BRPL _0x2B
; 0000 01D0             {
; 0000 01D1                 error = abs(error);
	CALL SUBOPT_0x20
; 0000 01D2                 filling_valve = PI_calculation(error, _kp, _ki, _kd);
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x11
; 0000 01D3                 discharge_valve = 60;
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 01D4             }
; 0000 01D5 
; 0000 01D6 
; 0000 01D7         break;
_0x2B:
_0x2A:
; 0000 01D8         };
_0x21:
; 0000 01D9 
; 0000 01DA     }
	RJMP _0x1C
; 0000 01DB 
; 0000 01DC 
; 0000 01DD 
; 0000 01DE }
_0x2C:
	RJMP _0x2C
; .FEND

	.DSEG
_0x1B:
	.BYTE 0x2C

	.CSEG
_abs:
; .FSTART _abs
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    sbiw r30,0
    brpl __abs0
    com  r30
    com  r31
    adiw r30,1
__abs0:
    ret
; .FEND
_ftoa:
; .FSTART _ftoa
	CALL SUBOPT_0x22
	LDI  R30,LOW(0)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x200000D
	CALL SUBOPT_0x23
	__POINTW2FN _0x2000000,0
	CALL _strcpyf
	RJMP _0x20C0007
_0x200000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x200000C
	CALL SUBOPT_0x23
	__POINTW2FN _0x2000000,1
	CALL _strcpyf
	RJMP _0x20C0007
_0x200000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x200000F
	__GETD1S 9
	CALL __ANEGF1
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
	LDI  R30,LOW(45)
	ST   X,R30
_0x200000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2000010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2000010:
	LDD  R17,Y+8
_0x2000011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2000013
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
	CALL SUBOPT_0x28
	RJMP _0x2000011
_0x2000013:
	CALL SUBOPT_0x29
	CALL __ADDF12
	CALL SUBOPT_0x24
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	CALL SUBOPT_0x28
_0x2000014:
	CALL SUBOPT_0x29
	CALL __CMPF12
	BRLO _0x2000016
	CALL SUBOPT_0x26
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x28
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2000017
	CALL SUBOPT_0x23
	__POINTW2FN _0x2000000,5
	CALL _strcpyf
	RJMP _0x20C0007
_0x2000017:
	RJMP _0x2000014
_0x2000016:
	CPI  R17,0
	BRNE _0x2000018
	CALL SUBOPT_0x25
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2000019
_0x2000018:
_0x200001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x200001C
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
	CALL SUBOPT_0x2B
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0x28
	CALL SUBOPT_0x29
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x25
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	LDI  R31,0
	CALL SUBOPT_0x26
	CALL SUBOPT_0x21
	CALL __MULF12
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2D
	RJMP _0x200001A
_0x200001C:
_0x2000019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20C0006
	CALL SUBOPT_0x25
	LDI  R30,LOW(46)
	ST   X,R30
_0x200001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2000020
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x24
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x25
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	LDI  R31,0
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x21
	CALL SUBOPT_0x2D
	RJMP _0x200001E
_0x2000020:
_0x20C0006:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0007:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
; .FEND

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
; .FSTART __lcd_write_nibble_G101
	ST   -Y,R26
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x15,R30
	__DELAY_USB 13
	SBI  0x12,7
	__DELAY_USB 13
	CBI  0x12,7
	__DELAY_USB 13
	RJMP _0x20C0004
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 133
	RJMP _0x20C0004
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x2E
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x2E
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2020004
_0x2020005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020007
	RJMP _0x20C0004
_0x2020007:
_0x2020004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x15,1
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,1
	RJMP _0x20C0004
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020008
_0x202000A:
_0x20C0005:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x14
	ORI  R30,LOW(0xF0)
	OUT  0x14,R30
	SBI  0x11,7
	SBI  0x14,1
	SBI  0x14,0
	CBI  0x12,7
	CBI  0x15,1
	CBI  0x15,0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x2F
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0004:
	ADIW R28,1
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G102:
; .FSTART _put_buff_G102
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2040010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2040012
	__CPWRN 16,17,2
	BRLO _0x2040013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2040012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2040013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2040014
	CALL SUBOPT_0x30
_0x2040014:
	RJMP _0x2040015
_0x2040010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2040015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__ftoe_G102:
; .FSTART __ftoe_G102
	CALL SUBOPT_0x22
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2040019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2040000,0
	CALL _strcpyf
	RJMP _0x20C0003
_0x2040019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2040018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2040000,1
	CALL _strcpyf
	RJMP _0x20C0003
_0x2040018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x204001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x204001B:
	LDD  R17,Y+11
_0x204001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x204001E
	CALL SUBOPT_0x31
	RJMP _0x204001C
_0x204001E:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x204001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0x31
	RJMP _0x2040020
_0x204001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x32
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2040021
	CALL SUBOPT_0x31
_0x2040022:
	CALL SUBOPT_0x32
	BRLO _0x2040024
	CALL SUBOPT_0x33
	SUBI R19,-LOW(1)
	RJMP _0x2040022
_0x2040024:
	RJMP _0x2040025
_0x2040021:
_0x2040026:
	CALL SUBOPT_0x32
	BRSH _0x2040028
	CALL SUBOPT_0x5
	__GETD1N 0x41200000
	CALL SUBOPT_0x1
	SUBI R19,LOW(1)
	RJMP _0x2040026
_0x2040028:
	CALL SUBOPT_0x31
_0x2040025:
	__GETD1S 12
	CALL SUBOPT_0x2B
	__PUTD1S 12
	CALL SUBOPT_0x32
	BRLO _0x2040029
	CALL SUBOPT_0x33
	SUBI R19,-LOW(1)
_0x2040029:
_0x2040020:
	LDI  R17,LOW(0)
_0x204002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x204002C
	CALL SUBOPT_0x6
	CALL SUBOPT_0x27
	CALL SUBOPT_0x2B
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	__PUTD1S 4
	CALL SUBOPT_0x5
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x34
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL SUBOPT_0x6
	CALL __MULF12
	CALL SUBOPT_0x5
	CALL __SWAPD12
	CALL __SUBF12
	__PUTD1S 12
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x204002A
	CALL SUBOPT_0x34
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x204002A
_0x204002C:
	CALL SUBOPT_0x35
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x204002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x2040113
_0x204002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x2040113:
	ST   X,R30
	CALL SUBOPT_0x35
	CALL SUBOPT_0x35
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x35
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0003:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
; .FEND
__print_G102:
; .FSTART __print_G102
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x30
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2040032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2040036
	CPI  R18,37
	BRNE _0x2040037
	LDI  R17,LOW(1)
	RJMP _0x2040038
_0x2040037:
	CALL SUBOPT_0x36
_0x2040038:
	RJMP _0x2040035
_0x2040036:
	CPI  R30,LOW(0x1)
	BRNE _0x2040039
	CPI  R18,37
	BRNE _0x204003A
	CALL SUBOPT_0x36
	RJMP _0x2040114
_0x204003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x204003B
	LDI  R16,LOW(1)
	RJMP _0x2040035
_0x204003B:
	CPI  R18,43
	BRNE _0x204003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2040035
_0x204003C:
	CPI  R18,32
	BRNE _0x204003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2040035
_0x204003D:
	RJMP _0x204003E
_0x2040039:
	CPI  R30,LOW(0x2)
	BRNE _0x204003F
_0x204003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040040
	ORI  R16,LOW(128)
	RJMP _0x2040035
_0x2040040:
	RJMP _0x2040041
_0x204003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2040042
_0x2040041:
	CPI  R18,48
	BRLO _0x2040044
	CPI  R18,58
	BRLO _0x2040045
_0x2040044:
	RJMP _0x2040043
_0x2040045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2040035
_0x2040043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2040046
	LDI  R17,LOW(4)
	RJMP _0x2040035
_0x2040046:
	RJMP _0x2040047
_0x2040042:
	CPI  R30,LOW(0x4)
	BRNE _0x2040049
	CPI  R18,48
	BRLO _0x204004B
	CPI  R18,58
	BRLO _0x204004C
_0x204004B:
	RJMP _0x204004A
_0x204004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2040035
_0x204004A:
_0x2040047:
	CPI  R18,108
	BRNE _0x204004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2040035
_0x204004D:
	RJMP _0x204004E
_0x2040049:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x2040035
_0x204004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2040053
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
	CALL SUBOPT_0x37
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x39
	RJMP _0x2040054
_0x2040053:
	CPI  R30,LOW(0x45)
	BREQ _0x2040057
	CPI  R30,LOW(0x65)
	BRNE _0x2040058
_0x2040057:
	RJMP _0x2040059
_0x2040058:
	CPI  R30,LOW(0x66)
	BREQ PC+2
	RJMP _0x204005A
_0x2040059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x3A
	CALL __GETD1P
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3C
	LDD  R26,Y+13
	TST  R26
	BRMI _0x204005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x204005D
	CPI  R26,LOW(0x20)
	BREQ _0x204005F
	RJMP _0x2040060
_0x204005B:
	CALL SUBOPT_0x3D
	CALL __ANEGF1
	CALL SUBOPT_0x3B
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x204005D:
	SBRS R16,7
	RJMP _0x2040061
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x39
	RJMP _0x2040062
_0x2040061:
_0x204005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2040062:
_0x2040060:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2040064
	CALL SUBOPT_0x3D
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _ftoa
	RJMP _0x2040065
_0x2040064:
	CALL SUBOPT_0x3D
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G102
_0x2040065:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x3E
	RJMP _0x2040066
_0x204005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2040068
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x3E
	RJMP _0x2040069
_0x2040068:
	CPI  R30,LOW(0x70)
	BRNE _0x204006B
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3F
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040069:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x204006D
	CP   R20,R17
	BRLO _0x204006E
_0x204006D:
	RJMP _0x204006C
_0x204006E:
	MOV  R17,R20
_0x204006C:
_0x2040066:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x204006F
_0x204006B:
	CPI  R30,LOW(0x64)
	BREQ _0x2040072
	CPI  R30,LOW(0x69)
	BRNE _0x2040073
_0x2040072:
	ORI  R16,LOW(4)
	RJMP _0x2040074
_0x2040073:
	CPI  R30,LOW(0x75)
	BRNE _0x2040075
_0x2040074:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2040076
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x40
	LDI  R17,LOW(10)
	RJMP _0x2040077
_0x2040076:
	__GETD1N 0x2710
	CALL SUBOPT_0x40
	LDI  R17,LOW(5)
	RJMP _0x2040077
_0x2040075:
	CPI  R30,LOW(0x58)
	BRNE _0x2040079
	ORI  R16,LOW(8)
	RJMP _0x204007A
_0x2040079:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x20400B8
_0x204007A:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x204007C
	__GETD1N 0x10000000
	CALL SUBOPT_0x40
	LDI  R17,LOW(8)
	RJMP _0x2040077
_0x204007C:
	__GETD1N 0x1000
	CALL SUBOPT_0x40
	LDI  R17,LOW(4)
_0x2040077:
	CPI  R20,0
	BREQ _0x204007D
	ANDI R16,LOW(127)
	RJMP _0x204007E
_0x204007D:
	LDI  R20,LOW(1)
_0x204007E:
	SBRS R16,1
	RJMP _0x204007F
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3A
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2040115
_0x204007F:
	SBRS R16,2
	RJMP _0x2040081
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3F
	CALL __CWD1
	RJMP _0x2040115
_0x2040081:
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3F
	CLR  R22
	CLR  R23
_0x2040115:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2040083
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2040084
	CALL SUBOPT_0x3D
	CALL __ANEGD1
	CALL SUBOPT_0x3B
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2040084:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2040085
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2040086
_0x2040085:
	ANDI R16,LOW(251)
_0x2040086:
_0x2040083:
	MOV  R19,R20
_0x204006F:
	SBRC R16,0
	RJMP _0x2040087
_0x2040088:
	CP   R17,R21
	BRSH _0x204008B
	CP   R19,R21
	BRLO _0x204008C
_0x204008B:
	RJMP _0x204008A
_0x204008C:
	SBRS R16,7
	RJMP _0x204008D
	SBRS R16,2
	RJMP _0x204008E
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x204008F
_0x204008E:
	LDI  R18,LOW(48)
_0x204008F:
	RJMP _0x2040090
_0x204008D:
	LDI  R18,LOW(32)
_0x2040090:
	CALL SUBOPT_0x36
	SUBI R21,LOW(1)
	RJMP _0x2040088
_0x204008A:
_0x2040087:
_0x2040091:
	CP   R17,R20
	BRSH _0x2040093
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2040094
	CALL SUBOPT_0x41
	BREQ _0x2040095
	SUBI R21,LOW(1)
_0x2040095:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2040094:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x39
	CPI  R21,0
	BREQ _0x2040096
	SUBI R21,LOW(1)
_0x2040096:
	SUBI R20,LOW(1)
	RJMP _0x2040091
_0x2040093:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2040097
_0x2040098:
	CPI  R19,0
	BREQ _0x204009A
	SBRS R16,3
	RJMP _0x204009B
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x204009C
_0x204009B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x204009C:
	CALL SUBOPT_0x36
	CPI  R21,0
	BREQ _0x204009D
	SUBI R21,LOW(1)
_0x204009D:
	SUBI R19,LOW(1)
	RJMP _0x2040098
_0x204009A:
	RJMP _0x204009E
_0x2040097:
_0x20400A0:
	CALL SUBOPT_0x42
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20400A2
	SBRS R16,3
	RJMP _0x20400A3
	SUBI R18,-LOW(55)
	RJMP _0x20400A4
_0x20400A3:
	SUBI R18,-LOW(87)
_0x20400A4:
	RJMP _0x20400A5
_0x20400A2:
	SUBI R18,-LOW(48)
_0x20400A5:
	SBRC R16,4
	RJMP _0x20400A7
	CPI  R18,49
	BRSH _0x20400A9
	CALL SUBOPT_0x3
	__CPD2N 0x1
	BRNE _0x20400A8
_0x20400A9:
	RJMP _0x20400AB
_0x20400A8:
	CP   R20,R19
	BRSH _0x2040116
	CP   R21,R19
	BRLO _0x20400AE
	SBRS R16,0
	RJMP _0x20400AF
_0x20400AE:
	RJMP _0x20400AD
_0x20400AF:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20400B0
_0x2040116:
	LDI  R18,LOW(48)
_0x20400AB:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20400B1
	CALL SUBOPT_0x41
	BREQ _0x20400B2
	SUBI R21,LOW(1)
_0x20400B2:
_0x20400B1:
_0x20400B0:
_0x20400A7:
	CALL SUBOPT_0x36
	CPI  R21,0
	BREQ _0x20400B3
	SUBI R21,LOW(1)
_0x20400B3:
_0x20400AD:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x42
	CALL __MODD21U
	CALL SUBOPT_0x3B
	LDD  R30,Y+20
	CALL SUBOPT_0x3
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x40
	__GETD1S 16
	CALL __CPD10
	BREQ _0x20400A1
	RJMP _0x20400A0
_0x20400A1:
_0x204009E:
	SBRS R16,0
	RJMP _0x20400B4
_0x20400B5:
	CPI  R21,0
	BREQ _0x20400B7
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x39
	RJMP _0x20400B5
_0x20400B7:
_0x20400B4:
_0x20400B8:
_0x2040054:
_0x2040114:
	LDI  R17,LOW(0)
_0x2040035:
	RJMP _0x2040030
_0x2040032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x43
	SBIW R30,0
	BRNE _0x20400B9
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0002
_0x20400B9:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x43
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G102)
	LDI  R31,HIGH(_put_buff_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G102
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0002:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_strcpyf:
; .FSTART _strcpyf
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL __PUTPARD2
	CALL __GETD2S0
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	RCALL SUBOPT_0x7
	RJMP _0x20C0001
__floor1:
    brtc __floor0
	RCALL SUBOPT_0x7
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x20C0001:
	ADIW R28,4
	RET
; .FEND

	.DSEG
_adc_data:
	.BYTE 0xC
_buffer1:
	.BYTE 0x14
_buffer2:
	.BYTE 0x14
_message:
	.BYTE 0x1
_data:
	.BYTE 0x14
__ki:
	.BYTE 0x4
__kd:
	.BYTE 0x4
_setpoint:
	.BYTE 0x4
_sensor:
	.BYTE 0x4
_error:
	.BYTE 0x4
_integral:
	.BYTE 0x4
_derivative:
	.BYTE 0x4
_old_integral:
	.BYTE 0x4
_pre_error:
	.BYTE 0x4
_rx_buffer:
	.BYTE 0x8
_rx_rd_index:
	.BYTE 0x1
_rx_counter:
	.BYTE 0x1
_tx_buffer:
	.BYTE 0x8
_tx_wr_index:
	.BYTE 0x1
_tx_rd_index:
	.BYTE 0x1
_tx_counter:
	.BYTE 0x1
__seed_G100:
	.BYTE 0x4
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	__GETD1S 28
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	CALL __MULF12
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDS  R30,_integral
	LDS  R31,_integral+1
	LDS  R22,_integral+2
	LDS  R23,_integral+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	__GETD2S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4:
	CALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x5:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	CALL _lcd_puts
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0xA:
	__GETW1MN _adc_data,2
	CALL __CWD1
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x4123AE14
	CALL __DIVF21
	CALL __CFD1
	MOVW R8,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB:
	CALL __CWD1
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x42CC999A
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(_buffer1)
	LDI  R31,HIGH(_buffer1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xE:
	LDS  R30,__ki
	LDS  R31,__ki+1
	LDS  R22,__ki+2
	LDS  R23,__ki+3
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x10:
	__GETW1MN _adc_data,10
	CALL __CWD1
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x408B3333
	CALL __DIVF21
	__GETD2N 0x42820000
	CALL __ADDF12
	__GETD2N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	CALL __CFD1U
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x12:
	__GETW1MN _adc_data,8
	CALL __CWD1
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x408B3333
	CALL __DIVF21
	__GETD2N 0x42820000
	CALL __ADDF12
	__GETD2N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	CALL __CFD1U
	OUT  0x28+1,R31
	OUT  0x28,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	__GETD2N 0x3D75C28F
	CALL __MULF12
	CALL __CFD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x15:
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	LDI  R26,LOW(_buffer1)
	LDI  R27,HIGH(_buffer1)
	CALL _lcd_puts
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(_buffer2)
	LDI  R31,HIGH(_buffer2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x18:
	LDS  R30,_adc_data
	LDS  R31,_adc_data+1
	CALL __CWD1
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x4123AE14
	CALL __DIVF21
	__GETD2N 0x41200000
	CALL __MULF12
	STS  _setpoint,R30
	STS  _setpoint+1,R31
	STS  _setpoint+2,R22
	STS  _setpoint+3,R23
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x19:
	__GETW2MN _adc_data,4
	LDI  R30,LOW(1023)
	LDI  R31,HIGH(1023)
	CALL __DIVW21
	LDI  R26,LOW(__ki)
	LDI  R27,HIGH(__ki)
	CALL __CWD1
	CALL __CDF1
	CALL __PUTDP1
	__GETW2MN _adc_data,6
	LDI  R30,LOW(1023)
	LDI  R31,HIGH(1023)
	CALL __DIVW21
	LDI  R26,LOW(__kd)
	LDI  R27,HIGH(__kd)
	CALL __CWD1
	CALL __CDF1
	CALL __PUTDP1
	__GETD1N 0x43FA0000
	STS  _sensor,R30
	STS  _sensor+1,R31
	STS  _sensor+2,R22
	STS  _sensor+3,R23
	LDS  R26,_sensor
	LDS  R27,_sensor+1
	LDS  R24,_sensor+2
	LDS  R25,_sensor+3
	LDS  R30,_setpoint
	LDS  R31,_setpoint+1
	LDS  R22,_setpoint+2
	LDS  R23,_setpoint+3
	CALL __SUBF12
	STS  _error,R30
	STS  _error+1,R31
	STS  _error+2,R22
	STS  _error+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1A:
	__POINTW1FN _0x0,65
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_setpoint
	LDS  R31,_setpoint+1
	LDS  R22,_setpoint+2
	LDS  R23,_setpoint+3
	CALL __PUTPARD1
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1B:
	__POINTW1FN _0x0,77
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_error
	LDS  R31,_error+1
	LDS  R22,_error+2
	LDS  R23,_error+3
	CALL __PUTPARD1
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1C:
	CALL _lcd_clear
	LDS  R26,_error
	LDS  R27,_error+1
	LDS  R24,_error+2
	LDS  R25,_error+3
	CALL __CPD02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1D:
	LDS  R30,_error
	LDS  R31,_error+1
	LDS  R22,_error+2
	LDS  R23,_error+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1E:
	CALL __PUTPARD1
	MOVW R30,R8
	CALL __CWD1
	CALL __CDF1
	CALL __PUTPARD1
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1F:
	LDS  R26,__kd
	LDS  R27,__kd+1
	LDS  R24,__kd+2
	LDS  R25,__kd+3
	JMP  _PI_calculation

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x20:
	RCALL SUBOPT_0x1D
	CALL __CFD1
	MOVW R26,R30
	CALL _abs
	LDI  R26,LOW(_error)
	LDI  R27,HIGH(_error)
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __PUTDP1
	RCALL SUBOPT_0x1D
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x22:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x24:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x25:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x27:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x29:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2B:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	CALL __SWAPD12
	CALL __SUBF12
	RJMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2F:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G101
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x30:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x31:
	RCALL SUBOPT_0x6
	__GETD1N 0x41200000
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x32:
	__GETD1S 4
	RCALL SUBOPT_0x5
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x33:
	RCALL SUBOPT_0x5
	__GETD1N 0x3DCCCCCD
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x35:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x36:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x37:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x38:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x39:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x3A:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3B:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3C:
	RCALL SUBOPT_0x37
	RJMP SUBOPT_0x38

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3E:
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3F:
	RCALL SUBOPT_0x3A
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x40:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x41:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x42:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
