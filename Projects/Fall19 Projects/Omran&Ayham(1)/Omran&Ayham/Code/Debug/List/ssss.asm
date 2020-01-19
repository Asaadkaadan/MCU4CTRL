
;CodeVisionAVR C Compiler V3.38 Evaluation
;(C) Copyright 1998-2019 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
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

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
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
	.DEF _st=R4
	.DEF _st_msb=R5
	.DEF _t=R6
	.DEF _t_msb=R7
	.DEF _se=R8
	.DEF _se_msb=R9
	.DEF _mi=R10
	.DEF _mi_msb=R11
	.DEF _o=R12
	.DEF _o_msb=R13

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
	JMP  _timer1_capt_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _ext_int2_isr
	JMP  0x00
	JMP  0x00

_tbl10_G105:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G105:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x64,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0xF,0x0

_0x3:
	.DB  0x61,0x2
_0x4:
	.DB  0x1
_0x5:
	.DB  0x1
_0x6:
	.DB  0x1
_0x7:
	.DB  0x1
_0x0:
	.DB  0x41,0x6E,0x67,0x65,0x6C,0x3D,0x0,0x20
	.DB  0x20,0x53,0x63,0x61,0x6E,0x6E,0x69,0x6E
	.DB  0x67,0x2E,0x2E,0x2E,0x2E,0x0,0x56,0x6D
	.DB  0x61,0x78,0x3D,0x0,0x6D,0x76,0x0,0x56
	.DB  0x3D,0x0,0x54,0x3D,0x0,0x30,0x0,0x20
	.DB  0x20,0x20,0x20,0x0,0x4F,0x46,0x46,0x0
	.DB  0x4F,0x4E,0x0,0x2D,0x54,0x6F,0x2B,0x0
	.DB  0x30,0x54,0x6F,0x2B,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x02
	.DW  _d
	.DW  _0x3*2

	.DW  0x01
	.DW  _z
	.DW  _0x4*2

	.DW  0x01
	.DW  _x
	.DW  _0x5*2

	.DW  0x01
	.DW  _w
	.DW  _0x6*2

	.DW  0x01
	.DW  _j
	.DW  _0x7*2

	.DW  0x07
	.DW  _0xA
	.DW  _0x0*2

	.DW  0x0F
	.DW  _0xB
	.DW  _0x0*2+7

	.DW  0x06
	.DW  _0xB+15
	.DW  _0x0*2+22

	.DW  0x03
	.DW  _0xB+21
	.DW  _0x0*2+28

	.DW  0x03
	.DW  _0x1F
	.DW  _0x0*2+31

	.DW  0x03
	.DW  _0x1F+3
	.DW  _0x0*2+28

	.DW  0x03
	.DW  _0x27
	.DW  _0x0*2+31

	.DW  0x03
	.DW  _0x27+3
	.DW  _0x0*2+28

	.DW  0x03
	.DW  _0x36
	.DW  _0x0*2+34

	.DW  0x02
	.DW  _0x36+3
	.DW  _0x0*2+37

	.DW  0x05
	.DW  _0x36+5
	.DW  _0x0*2+39

	.DW  0x03
	.DW  _0x36+10
	.DW  _0x0*2+34

	.DW  0x02
	.DW  _0x36+13
	.DW  _0x0*2+37

	.DW  0x05
	.DW  _0x36+15
	.DW  _0x0*2+39

	.DW  0x04
	.DW  _0x36+20
	.DW  _0x0*2+44

	.DW  0x05
	.DW  _0x36+24
	.DW  _0x0*2+39

	.DW  0x03
	.DW  _0x36+29
	.DW  _0x0*2+48

	.DW  0x05
	.DW  _0x36+32
	.DW  _0x0*2+39

	.DW  0x05
	.DW  _0x36+37
	.DW  _0x0*2+51

	.DW  0x05
	.DW  _0x36+42
	.DW  _0x0*2+39

	.DW  0x05
	.DW  _0x36+47
	.DW  _0x0*2+56

	.DW  0x05
	.DW  _0x36+52
	.DW  _0x0*2+39

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
	.ORG 0x00

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega16.h>
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
;
;float a=0,v=0,an=0;
;long int i=0,d=609,b=0,ol=0,oh=0;

	.DSEG
;int st=100,t=0,se=0,mi=0,o=15;
;int z=1,x=1,y=0,p=0,w=1,j=1;
;char *e,m[10],r[10];
;
;void Angel()  //  «»⁄ ≈ŸÂ«— «·“«ÊÌ…
; 0000 000D {

	.CSEG
_Angel:
; .FSTART _Angel
; 0000 000E  if(z==0)
	RCALL SUBOPT_0x0
	BRNE _0x8
; 0000 000F    an=((b-619)/10)*0.9;
	RCALL SUBOPT_0x1
	RJMP _0x55
; 0000 0010  else
_0x8:
; 0000 0011    an=(((b-619)/10)*0.9)-90;
	RCALL SUBOPT_0x1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x42B40000
	RCALL __SWAPD12
	RCALL __SUBF12
_0x55:
	STS  _an,R30
	STS  _an+1,R31
	STS  _an+2,R22
	STS  _an+3,R23
; 0000 0012  ftoa(an,1,r);
	RCALL __PUTPARD1
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(_r)
	LDI  R27,HIGH(_r)
	RCALL _ftoa
; 0000 0013  lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0014  lcd_puts("Angel=");
	__POINTW2MN _0xA,0
	RCALL _lcd_puts
; 0000 0015  lcd_puts(r);
	LDI  R26,LOW(_r)
	LDI  R27,HIGH(_r)
	RCALL _lcd_puts
; 0000 0016 }
	RET
; .FEND

	.DSEG
_0xA:
	.BYTE 0x7
;
;void Scan()   //  «»⁄ «·„”Õ
; 0000 0019 {

	.CSEG
_Scan:
; .FSTART _Scan
; 0000 001A  lcd_clear();
	RCALL _lcd_clear
; 0000 001B  lcd_puts("  Scanning....");
	__POINTW2MN _0xB,0
	RCALL _lcd_puts
; 0000 001C  d=609;
	__GETD1N 0x261
	RCALL SUBOPT_0x2
; 0000 001D  j=0;
	LDI  R30,LOW(0)
	STS  _j,R30
	STS  _j+1,R30
; 0000 001E  a=0;
	STS  _a,R30
	STS  _a+1,R30
	STS  _a+2,R30
	STS  _a+3,R30
; 0000 001F  for(i=0;i<=200;i++)
	STS  _i,R30
	STS  _i+1,R30
	STS  _i+2,R30
	STS  _i+3,R30
_0xD:
	LDS  R26,_i
	LDS  R27,_i+1
	LDS  R24,_i+2
	LDS  R25,_i+3
	__CPD2N 0xC9
	BRGE _0xE
; 0000 0020   {
; 0000 0021    if(x==1)
	RCALL SUBOPT_0x3
	BRNE _0xF
; 0000 0022      {
; 0000 0023       d+=10;
	RCALL SUBOPT_0x4
	__ADDD1N 10
	RCALL SUBOPT_0x2
; 0000 0024       OCR1AH=d/256;OCR1AL=d%256;
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
	LDS  R30,_d
	OUT  0x2A,R30
; 0000 0025       if(d==619)
	RCALL SUBOPT_0x5
	__CPD2N 0x26B
	BRNE _0x10
; 0000 0026         delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 0027       delay_ms(50);
_0x10:
	LDI  R26,LOW(50)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0028       ADCSRA.6=1;
	SBI  0x6,6
; 0000 0029       while(ADCSRA.4==0){}
_0x13:
	SBIS 0x6,4
	RJMP _0x13
; 0000 002A       if(ADCW>a)
	IN   R30,0x4
	IN   R31,0x4+1
	MOVW R26,R30
	LDS  R30,_a
	LDS  R31,_a+1
	LDS  R22,_a+2
	LDS  R23,_a+3
	CLR  R24
	CLR  R25
	RCALL __CDF2
	RCALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x16
; 0000 002B        {
; 0000 002C         a=ADCW;
	RCALL SUBOPT_0x7
; 0000 002D         b=d;
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x8
; 0000 002E        }
; 0000 002F      }
_0x16:
; 0000 0030   }
_0xF:
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	RCALL __GETD1P_INC
	__SUBD1N -1
	RCALL __PUTDP1_DEC
	RJMP _0xD
_0xE:
; 0000 0031   if(x==1)
	RCALL SUBOPT_0x3
	BRNE _0x17
; 0000 0032    {
; 0000 0033     OCR1AH=b/256;OCR1AL=b%256;
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x6
	LDS  R30,_b
	OUT  0x2A,R30
; 0000 0034     delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RCALL _delay_ms
; 0000 0035     v=(a*5000)/1024;
	RCALL SUBOPT_0xA
; 0000 0036     lcd_clear();
; 0000 0037     lcd_puts("Vmax=");
	__POINTW2MN _0xB,15
	RCALL SUBOPT_0xB
; 0000 0038     ftoa(v,3,m);
; 0000 0039     lcd_puts(m);
; 0000 003A     lcd_puts("mv");
	__POINTW2MN _0xB,21
	RCALL _lcd_puts
; 0000 003B     Angel();
	RCALL _Angel
; 0000 003C     j=1;
	RCALL SUBOPT_0xC
; 0000 003D     x=0;
	RCALL SUBOPT_0xD
; 0000 003E    }
; 0000 003F }
_0x17:
	RET
; .FEND

	.DSEG
_0xB:
	.BYTE 0x18
;
;interrupt [EXT_INT0] void ext_int0_isr(void)   // · Õ—Ìﬂ «·„Õ—ﬂ ≈·Ï «·Ì„Ì‰ »„ﬁœ«— ŒÿÊ…
; 0000 0042 {

	.CSEG
_ext_int0_isr:
; .FSTART _ext_int0_isr
	RCALL SUBOPT_0xE
; 0000 0043  x=0;
; 0000 0044  j=1;
	RCALL SUBOPT_0xC
; 0000 0045  oh=OCR1AH;
	RCALL SUBOPT_0xF
; 0000 0046  ol=OCR1AL;
; 0000 0047  b=(oh<<8)+ol;
; 0000 0048  if(b<=(2619-st))
	LDI  R30,LOW(2619)
	LDI  R31,HIGH(2619)
	SUB  R30,R4
	SBC  R31,R5
	RCALL SUBOPT_0x9
	RCALL __CWD1
	RCALL __CPD12
	BRLT _0x18
; 0000 0049    b+=st;
	RCALL SUBOPT_0x10
	RCALL __ADDD12
	RJMP _0x56
; 0000 004A  else
_0x18:
; 0000 004B    b=2619;
	__GETD1N 0xA3B
_0x56:
	STS  _b,R30
	STS  _b+1,R31
	STS  _b+2,R22
	STS  _b+3,R23
; 0000 004C  OCR1AH=b/256;OCR1AL=b%256;
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x11
; 0000 004D  delay_ms(100);
; 0000 004E  ADCSRA.6=1;
; 0000 004F  while(ADCSRA.4==0){}
_0x1C:
	SBIS 0x6,4
	RJMP _0x1C
; 0000 0050  a=ADCW;
	RCALL SUBOPT_0x7
; 0000 0051  v=(a*5000)/1024;
	RCALL SUBOPT_0xA
; 0000 0052  lcd_clear();
; 0000 0053  lcd_puts("V=");
	__POINTW2MN _0x1F,0
	RCALL SUBOPT_0xB
; 0000 0054  ftoa(v,3,m);
; 0000 0055  lcd_puts(m);
; 0000 0056  lcd_puts("mv");
	__POINTW2MN _0x1F,3
	RCALL _lcd_puts
; 0000 0057  Angel();
	RCALL _Angel
; 0000 0058  delay_ms(1);
	RJMP _0x5A
; 0000 0059 }
; .FEND

	.DSEG
_0x1F:
	.BYTE 0x6
;
;interrupt [EXT_INT1] void ext_int1_isr(void)   // · Õ—Ìﬂ «·„Õ—ﬂ ≈·Ï «·Ì”«— »„ﬁœ«— ŒÿÊ…
; 0000 005C {

	.CSEG
_ext_int1_isr:
; .FSTART _ext_int1_isr
	RCALL SUBOPT_0xE
; 0000 005D  x=0;
; 0000 005E  j=1;
	RCALL SUBOPT_0xC
; 0000 005F  oh=OCR1AH;
	RCALL SUBOPT_0xF
; 0000 0060  ol=OCR1AL;
; 0000 0061  b=(oh<<8)+ol;
; 0000 0062  if(b>=(619+st))
	MOVW R30,R4
	SUBI R30,LOW(-619)
	SBCI R31,HIGH(-619)
	RCALL SUBOPT_0x9
	RCALL __CWD1
	RCALL __CPD21
	BRLT _0x20
; 0000 0063    b-=st;
	RCALL SUBOPT_0x10
	RCALL __SUBD21
	STS  _b,R26
	STS  _b+1,R27
	STS  _b+2,R24
	STS  _b+3,R25
; 0000 0064   else
	RJMP _0x21
_0x20:
; 0000 0065    b=619;
	__GETD1N 0x26B
	RCALL SUBOPT_0x8
; 0000 0066  OCR1AH=b/256;OCR1AL=b%256;
_0x21:
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x11
; 0000 0067  delay_ms(100);
; 0000 0068  ADCSRA.6=1;
; 0000 0069  while(ADCSRA.4==0){}
_0x24:
	SBIS 0x6,4
	RJMP _0x24
; 0000 006A  a=ADCW;
	RCALL SUBOPT_0x7
; 0000 006B  v=(a*5000)/1024;
	RCALL SUBOPT_0xA
; 0000 006C  lcd_clear();
; 0000 006D  lcd_puts("V=");
	__POINTW2MN _0x27,0
	RCALL SUBOPT_0xB
; 0000 006E  ftoa(v,3,m);
; 0000 006F  lcd_puts(m);
; 0000 0070  lcd_puts("mv");
	__POINTW2MN _0x27,3
	RCALL _lcd_puts
; 0000 0071  Angel();
	RCALL _Angel
; 0000 0072  delay_ms(1);
	RJMP _0x5A
; 0000 0073 }
; .FEND

	.DSEG
_0x27:
	.BYTE 0x6
;
;interrupt [EXT_INT2] void ext_int2_isr(void)   // · €ÌÌ— ŒÿÊ… «·„Õ—ﬂ
; 0000 0076 {

	.CSEG
_ext_int2_isr:
; .FSTART _ext_int2_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0077  if(st==10)
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x28
; 0000 0078    st=100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RJMP _0x57
; 0000 0079  else
_0x28:
; 0000 007A    st=10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
_0x57:
	MOVW R4,R30
; 0000 007B  delay_ms(1);
_0x5A:
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _delay_ms
; 0000 007C }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;interrupt [TIM1_CAPT] void timer1_capt_isr(void)   // ·Õ”«» “„‰ «·„”Õ «· ·ﬁ«∆Ì
; 0000 007F {
_timer1_capt_isr:
; .FSTART _timer1_capt_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0080  if(j==1)
	LDS  R26,_j
	LDS  R27,_j+1
	SBIW R26,1
	BRNE _0x2A
; 0000 0081   {
; 0000 0082    t++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 0083    if(t>=50)
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CP   R6,R30
	CPC  R7,R31
	BRLT _0x2B
; 0000 0084     {
; 0000 0085      se++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 0086      t=0;
	CLR  R6
	CLR  R7
; 0000 0087     }
; 0000 0088    if(se>=60)
_0x2B:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R8,R30
	CPC  R9,R31
	BRLT _0x2C
; 0000 0089     {
; 0000 008A      mi++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 008B      se=0;
	CLR  R8
	CLR  R9
; 0000 008C     }
; 0000 008D    if(mi==o)
_0x2C:
	__CPWRR 12,13,10,11
	BRNE _0x2D
; 0000 008E     {
; 0000 008F      y=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _y,R30
	STS  _y+1,R31
; 0000 0090      mi=0;
	CLR  R10
	CLR  R11
; 0000 0091     }
; 0000 0092    }
_0x2D:
; 0000 0093 }
_0x2A:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;void main(void)
; 0000 0096 {
_main:
; .FSTART _main
; 0000 0097 DDRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 0098 PORTB=0xff;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0099 
; 0000 009A DDRD=0x60;
	LDI  R30,LOW(96)
	OUT  0x11,R30
; 0000 009B PORTD=0x4c;
	LDI  R30,LOW(76)
	OUT  0x12,R30
; 0000 009C 
; 0000 009D TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (1<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(130)
	OUT  0x2F,R30
; 0000 009E TCCR1B=(0<<ICNC1) | (0<<ICES1) | (1<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
	LDI  R30,LOW(26)
	OUT  0x2E,R30
; 0000 009F TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 00A0 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00A1 ICR1H=0x4E;
	LDI  R30,LOW(78)
	OUT  0x27,R30
; 0000 00A2 ICR1L=0x1F;
	LDI  R30,LOW(31)
	OUT  0x26,R30
; 0000 00A3 OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
; 0000 00A4 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00A5 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00A6 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00A7 
; 0000 00A8 TIMSK=0x20;
	LDI  R30,LOW(32)
	OUT  0x39,R30
; 0000 00A9 
; 0000 00AA GICR|=(1<<INT1) | (1<<INT0) | (1<<INT2);
	IN   R30,0x3B
	ORI  R30,LOW(0xE0)
	OUT  0x3B,R30
; 0000 00AB MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(10)
	OUT  0x35,R30
; 0000 00AC MCUCSR=(0<<ISC2);
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 00AD 
; 0000 00AE ADMUX=0x00;
	OUT  0x7,R30
; 0000 00AF ADCSRA=0x85;
	LDI  R30,LOW(133)
	OUT  0x6,R30
; 0000 00B0 
; 0000 00B1 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 00B2 
; 0000 00B3 #asm("sei")
	SEI
; 0000 00B4 
; 0000 00B5 Scan();   // ·»œ¡ ⁄„·Ì… „”Õ »œ«∆Ì… ›Ì »œ«Ì… «· ‘€Ì·
	RCALL _Scan
; 0000 00B6 
; 0000 00B7 while (1)
_0x2E:
; 0000 00B8       {
; 0000 00B9        if(y==1)   // ·»œ¡ «·„”Õ «· ·ﬁ«∆Ì »⁄œ “„‰ „⁄Ì‰
	LDS  R26,_y
	LDS  R27,_y+1
	SBIW R26,1
	BRNE _0x31
; 0000 00BA         {
; 0000 00BB          y=0;
	RCALL SUBOPT_0x12
; 0000 00BC          x=1;
	RCALL SUBOPT_0x13
; 0000 00BD          Scan();
; 0000 00BE         }
; 0000 00BF        if(PINB.0==0 && p==0)   // ·“Ì«œ… «·“„‰ ﬁ»· »œ¡ „”Õ  ·ﬁ«∆Ì ÃœÌœ
_0x31:
	SBIC 0x16,0
	RJMP _0x33
	RCALL SUBOPT_0x14
	BREQ _0x34
_0x33:
	RJMP _0x32
_0x34:
; 0000 00C0         {
; 0000 00C1          if(o<99)
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
	CP   R12,R30
	CPC  R13,R31
	BRGE _0x35
; 0000 00C2            o++;
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 00C3          itoa(o,e);
_0x35:
	RCALL SUBOPT_0x15
; 0000 00C4          lcd_gotoxy(12,1);
; 0000 00C5          lcd_puts("T=");
	__POINTW2MN _0x36,0
	RCALL SUBOPT_0x16
; 0000 00C6          if(o<10)
	BRGE _0x37
; 0000 00C7            lcd_puts("0");
	__POINTW2MN _0x36,3
	RCALL _lcd_puts
; 0000 00C8          lcd_puts(e);
_0x37:
	RCALL SUBOPT_0x17
; 0000 00C9          delay_ms(400);
; 0000 00CA          lcd_gotoxy(12,1);
; 0000 00CB          lcd_puts("    ");
	__POINTW2MN _0x36,5
	RCALL _lcd_puts
; 0000 00CC         }
; 0000 00CD        else if(PINB.1==0 && p==0)   // ·≈‰ﬁ«’ «·“„‰ ﬁ»· »œ¡ „”Õ  ·ﬁ«∆Ì ÃœÌœ
	RJMP _0x38
_0x32:
	SBIC 0x16,1
	RJMP _0x3A
	RCALL SUBOPT_0x14
	BREQ _0x3B
_0x3A:
	RJMP _0x39
_0x3B:
; 0000 00CE         {
; 0000 00CF          if(o>1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R12
	CPC  R31,R13
	BRGE _0x3C
; 0000 00D0            o--;
	MOVW R30,R12
	SBIW R30,1
	MOVW R12,R30
; 0000 00D1          itoa(o,e);
_0x3C:
	RCALL SUBOPT_0x15
; 0000 00D2          lcd_gotoxy(12,1);
; 0000 00D3          lcd_puts("T=");
	__POINTW2MN _0x36,10
	RCALL SUBOPT_0x16
; 0000 00D4          if(o<10)
	BRGE _0x3D
; 0000 00D5            lcd_puts("0");
	__POINTW2MN _0x36,13
	RCALL _lcd_puts
; 0000 00D6          lcd_puts(e);
_0x3D:
	RCALL SUBOPT_0x17
; 0000 00D7          delay_ms(400);
; 0000 00D8          lcd_gotoxy(12,1);
; 0000 00D9          lcd_puts("    ");
	__POINTW2MN _0x36,15
	RCALL _lcd_puts
; 0000 00DA         }
; 0000 00DB        else if(PINB.4==0 && p==0)   // · ›⁄Ì· √Ê ≈·€«¡  ›⁄Ì·  «·„”Õ «· ·ﬁ«∆Ì „⁄ ·Ìœ ≈‘«—…
	RJMP _0x3E
_0x39:
	SBIC 0x16,4
	RJMP _0x40
	RCALL SUBOPT_0x14
	BREQ _0x41
_0x40:
	RJMP _0x3F
_0x41:
; 0000 00DC         {
; 0000 00DD          if(w==1)
	LDS  R26,_w
	LDS  R27,_w+1
	SBIW R26,1
	BRNE _0x42
; 0000 00DE           {
; 0000 00DF            PORTD.6=0;
	CBI  0x12,6
; 0000 00E0            TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 00E1            y=0;
	RCALL SUBOPT_0x12
; 0000 00E2            t=0;
	RCALL SUBOPT_0x18
; 0000 00E3            se=0;
; 0000 00E4            mi=0;
; 0000 00E5            w=0;
	LDI  R30,LOW(0)
	STS  _w,R30
	STS  _w+1,R30
; 0000 00E6            lcd_gotoxy(13,1);
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 00E7            lcd_puts("OFF");
	__POINTW2MN _0x36,20
	RCALL SUBOPT_0x19
; 0000 00E8            delay_ms(750);
; 0000 00E9            lcd_gotoxy(12,1);
; 0000 00EA            lcd_puts("    ");
	__POINTW2MN _0x36,24
	RJMP _0x58
; 0000 00EB           }
; 0000 00EC          else
_0x42:
; 0000 00ED           {
; 0000 00EE            PORTD.6=1;
	SBI  0x12,6
; 0000 00EF            TIMSK=0x20;
	LDI  R30,LOW(32)
	OUT  0x39,R30
; 0000 00F0            y=0;
	RCALL SUBOPT_0x12
; 0000 00F1            t=0;
	RCALL SUBOPT_0x18
; 0000 00F2            se=0;
; 0000 00F3            mi=0;
; 0000 00F4            w=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _w,R30
	STS  _w+1,R31
; 0000 00F5            j=1;
	RCALL SUBOPT_0xC
; 0000 00F6            lcd_gotoxy(14,1);
	LDI  R30,LOW(14)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 00F7            lcd_puts("ON");
	__POINTW2MN _0x36,29
	RCALL SUBOPT_0x19
; 0000 00F8            delay_ms(750);
; 0000 00F9            lcd_gotoxy(12,1);
; 0000 00FA            lcd_puts("    ");
	__POINTW2MN _0x36,32
_0x58:
	RCALL _lcd_puts
; 0000 00FB           }
; 0000 00FC          p=1;
	RCALL SUBOPT_0x1A
; 0000 00FD         }
; 0000 00FE        else if(PINB.5==0 && p==0)   // ·»œ¡ ⁄„·Ì… „”Õ ÌœÊÌ…
	RJMP _0x48
_0x3F:
	SBIC 0x16,5
	RJMP _0x4A
	RCALL SUBOPT_0x14
	BREQ _0x4B
_0x4A:
	RJMP _0x49
_0x4B:
; 0000 00FF         {
; 0000 0100          x=1;
	RCALL SUBOPT_0x13
; 0000 0101          Scan();
; 0000 0102          p=1;
	RCALL SUBOPT_0x1A
; 0000 0103         }
; 0000 0104        else if(PINB.6==0 && p==0)   // · ÕœÌœ ÿ—Ìﬁ… ≈ŸÂ«— «·“«ÊÌ… ⁄·Ï «·‘«‘…
	RJMP _0x4C
_0x49:
	SBIC 0x16,6
	RJMP _0x4E
	RCALL SUBOPT_0x14
	BREQ _0x4F
_0x4E:
	RJMP _0x4D
_0x4F:
; 0000 0105         {
; 0000 0106          if(z==0)
	RCALL SUBOPT_0x0
	BRNE _0x50
; 0000 0107           {
; 0000 0108            z=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _z,R30
	STS  _z+1,R31
; 0000 0109            Angel();
	RCALL SUBOPT_0x1B
; 0000 010A            lcd_gotoxy(12,1);
; 0000 010B            lcd_puts("-To+");
	__POINTW2MN _0x36,37
	RCALL SUBOPT_0x19
; 0000 010C            delay_ms(750);
; 0000 010D            lcd_gotoxy(12,1);
; 0000 010E            lcd_puts("    ");
	__POINTW2MN _0x36,42
	RJMP _0x59
; 0000 010F           }
; 0000 0110          else
_0x50:
; 0000 0111           {
; 0000 0112            z=0;
	LDI  R30,LOW(0)
	STS  _z,R30
	STS  _z+1,R30
; 0000 0113            Angel();
	RCALL SUBOPT_0x1B
; 0000 0114            lcd_gotoxy(12,1);
; 0000 0115            lcd_puts("0To+");
	__POINTW2MN _0x36,47
	RCALL SUBOPT_0x19
; 0000 0116            delay_ms(750);
; 0000 0117            lcd_gotoxy(12,1);
; 0000 0118            lcd_puts("    ");
	__POINTW2MN _0x36,52
_0x59:
	RCALL _lcd_puts
; 0000 0119           }
; 0000 011A          p=1;
	RCALL SUBOPT_0x1A
; 0000 011B         }
; 0000 011C        else if(PINB==255)
	RJMP _0x52
_0x4D:
	IN   R30,0x16
	CPI  R30,LOW(0xFF)
	BRNE _0x53
; 0000 011D          p=0;
	LDI  R30,LOW(0)
	STS  _p,R30
	STS  _p+1,R30
; 0000 011E       }
_0x53:
_0x52:
_0x4C:
_0x48:
_0x3E:
_0x38:
	RJMP _0x2E
; 0000 011F }
_0x54:
	RJMP _0x54
; .FEND

	.DSEG
_0x36:
	.BYTE 0x39

	.CSEG
_itoa:
; .FSTART _itoa
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret
; .FEND
_ftoa:
; .FSTART _ftoa
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	RCALL __SAVELOCR6
	MOVW R18,R26
	LDD  R21,Y+10
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x200000D
	ST   -Y,R19
	ST   -Y,R18
	__POINTW2FN _0x2000000,0
	RCALL _strcpyf
	RJMP _0x20C0004
_0x200000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x200000C
	ST   -Y,R19
	ST   -Y,R18
	__POINTW2FN _0x2000000,1
	RCALL _strcpyf
	RJMP _0x20C0004
_0x200000C:
	LDD  R26,Y+14
	TST  R26
	BRPL _0x200000F
	RCALL SUBOPT_0x1C
	RCALL __ANEGF1
	RCALL SUBOPT_0x1D
	MOVW R26,R18
	__ADDWRN 18,19,1
	LDI  R30,LOW(45)
	ST   X,R30
_0x200000F:
	CPI  R21,7
	BRLO _0x2000010
	LDI  R21,LOW(6)
_0x2000010:
	MOV  R17,R21
_0x2000011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2000013
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x20
	RJMP _0x2000011
_0x2000013:
	RCALL SUBOPT_0x21
	RCALL __ADDF12
	RCALL SUBOPT_0x1D
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0x20
_0x2000014:
	RCALL SUBOPT_0x21
	RCALL __CMPF12
	BRLO _0x2000016
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x20
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2000017
	ST   -Y,R19
	ST   -Y,R18
	__POINTW2FN _0x2000000,5
	RCALL _strcpyf
	RJMP _0x20C0004
_0x2000017:
	RJMP _0x2000014
_0x2000016:
	CPI  R17,0
	BRNE _0x2000018
	MOVW R26,R18
	__ADDWRN 18,19,1
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2000019
_0x2000018:
_0x200001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x200001C
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
	__GETD2N 0x3F000000
	RCALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	RCALL _floor
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x21
	RCALL __DIVF21
	RCALL __CFD1U
	MOV  R16,R30
	PUSH R19
	PUSH R18
	RCALL SUBOPT_0x23
	POP  R26
	POP  R27
	ST   X,R30
	MOV  R30,R16
	LDI  R31,0
	RCALL SUBOPT_0x1E
	RCALL __CWD1
	RCALL __CDF1
	RCALL __MULF12
	RCALL SUBOPT_0x24
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x1D
	RJMP _0x200001A
_0x200001C:
_0x2000019:
	CPI  R21,0
	BREQ _0x20C0003
	MOVW R26,R18
	__ADDWRN 18,19,1
	LDI  R30,LOW(46)
	ST   X,R30
_0x200001E:
	MOV  R30,R21
	SUBI R21,1
	CPI  R30,0
	BREQ _0x2000020
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1C
	RCALL __CFD1U
	MOV  R16,R30
	PUSH R19
	PUSH R18
	RCALL SUBOPT_0x23
	POP  R26
	POP  R27
	ST   X,R30
	MOV  R30,R16
	LDI  R31,0
	RCALL SUBOPT_0x24
	RCALL __CWD1
	RCALL __CDF1
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x1D
	RJMP _0x200001E
_0x2000020:
_0x20C0003:
	MOVW R26,R18
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0004:
	RCALL __LOADLOCR6
	ADIW R28,15
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
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	MOV  R30,R17
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x15,R30
	__DELAY_USB 13
	SBI  0x15,2
	__DELAY_USB 13
	CBI  0x15,2
	__DELAY_USB 13
	RJMP _0x20C0002
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
	ADIW R28,1
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R17
	ST   -Y,R16
	MOV  R17,R26
	LDD  R16,Y+2
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	ADD  R30,R16
	MOV  R26,R30
	RCALL __lcd_write_data
	STS  __lcd_x,R16
	STS  __lcd_y,R17
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x25
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x25
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R17
	MOV  R17,R26
	CPI  R17,10
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
	CPI  R17,10
	BRNE _0x2020007
	RJMP _0x20C0002
_0x2020007:
_0x2020004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x15,0
	MOV  R26,R17
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x20C0002
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	RCALL __SAVELOCR4
	MOVW R18,R26
_0x2020008:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020008
_0x202000A:
	RCALL __LOADLOCR4
	JMP  _0x20C0001
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x14
	ORI  R30,LOW(0xF0)
	OUT  0x14,R30
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	STS  __lcd_maxx,R17
	MOV  R30,R17
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	MOV  R30,R17
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x26
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
_0x20C0002:
	LD   R17,Y+
	RET
; .FEND

	.CSEG

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	RCALL __PUTPARD2
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
	RCALL __PUTPARD2
	RCALL __GETD2S0
	RCALL _ftrunc
	RCALL __PUTD1S0
    brne __floor1
__floor0:
	RCALL SUBOPT_0x27
	RJMP _0x20C0001
__floor1:
    brtc __floor0
	RCALL SUBOPT_0x27
	__GETD2N 0x3F800000
	RCALL __SUBF12
_0x20C0001:
	ADIW R28,4
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

	.DSEG
_a:
	.BYTE 0x4
_v:
	.BYTE 0x4
_an:
	.BYTE 0x4
_i:
	.BYTE 0x4
_d:
	.BYTE 0x4
_b:
	.BYTE 0x4
_ol:
	.BYTE 0x4
_oh:
	.BYTE 0x4
_z:
	.BYTE 0x2
_x:
	.BYTE 0x2
_y:
	.BYTE 0x2
_p:
	.BYTE 0x2
_w:
	.BYTE 0x2
_j:
	.BYTE 0x2
_e:
	.BYTE 0x2
_m:
	.BYTE 0xA
_r:
	.BYTE 0xA
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
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LDS  R30,_z
	LDS  R31,_z+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x1:
	LDS  R30,_b
	LDS  R31,_b+1
	LDS  R22,_b+2
	LDS  R23,_b+3
	__SUBD1N 619
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0xA
	RCALL __DIVD21
	RCALL __CDF1
	__GETD2N 0x3F666666
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	STS  _d,R30
	STS  _d+1,R31
	STS  _d+2,R22
	STS  _d+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	LDS  R26,_x
	LDS  R27,_x+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	LDS  R30,_d
	LDS  R31,_d+1
	LDS  R22,_d+2
	LDS  R23,_d+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	LDS  R26,_d
	LDS  R27,_d+1
	LDS  R24,_d+2
	LDS  R25,_d+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6:
	__GETD1N 0x100
	RCALL __DIVD21
	OUT  0x2B,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x7:
	IN   R30,0x4
	IN   R31,0x4+1
	LDI  R26,LOW(_a)
	LDI  R27,HIGH(_a)
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RCALL __PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x8:
	STS  _b,R30
	STS  _b+1,R31
	STS  _b+2,R22
	STS  _b+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:40 WORDS
SUBOPT_0x9:
	LDS  R26,_b
	LDS  R27,_b+1
	LDS  R24,_b+2
	LDS  R25,_b+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:54 WORDS
SUBOPT_0xA:
	LDS  R26,_a
	LDS  R27,_a+1
	LDS  R24,_a+2
	LDS  R25,_a+3
	__GETD1N 0x459C4000
	RCALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x44800000
	RCALL __DIVF21
	STS  _v,R30
	STS  _v+1,R31
	STS  _v+2,R22
	STS  _v+3,R23
	RJMP _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0xB:
	RCALL _lcd_puts
	LDS  R30,_v
	LDS  R31,_v+1
	LDS  R22,_v+2
	LDS  R23,_v+3
	RCALL __PUTPARD1
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(_m)
	LDI  R27,HIGH(_m)
	RCALL _ftoa
	LDI  R26,LOW(_m)
	LDI  R27,HIGH(_m)
	RJMP _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _j,R30
	STS  _j+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(0)
	STS  _x,R30
	STS  _x+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xE:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0xF:
	IN   R30,0x2B
	CLR  R31
	CLR  R22
	CLR  R23
	STS  _oh,R30
	STS  _oh+1,R31
	STS  _oh+2,R22
	STS  _oh+3,R23
	IN   R30,0x2A
	CLR  R31
	CLR  R22
	CLR  R23
	STS  _ol,R30
	STS  _ol+1,R31
	STS  _ol+2,R22
	STS  _ol+3,R23
	LDS  R26,_oh
	LDS  R27,_oh+1
	LDS  R24,_oh+2
	LDS  R25,_oh+3
	LDI  R30,LOW(8)
	RCALL __LSLD12
	LDS  R26,_ol
	LDS  R27,_ol+1
	LDS  R24,_ol+2
	LDS  R25,_ol+3
	RCALL __ADDD12
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	MOVW R30,R4
	RCALL SUBOPT_0x9
	RCALL __CWD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	LDS  R30,_b
	OUT  0x2A,R30
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
	SBI  0x6,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(0)
	STS  _y,R30
	STS  _y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _x,R30
	STS  _x+1,R31
	RJMP _Scan

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x14:
	LDS  R26,_p
	LDS  R27,_p+1
	SBIW R26,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x15:
	ST   -Y,R13
	ST   -Y,R12
	LDS  R26,_e
	LDS  R27,_e+1
	RCALL _itoa
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	RCALL _lcd_puts
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R12,R30
	CPC  R13,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x17:
	LDS  R26,_e
	LDS  R27,_e+1
	RCALL _lcd_puts
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RCALL _delay_ms
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	CLR  R6
	CLR  R7
	CLR  R8
	CLR  R9
	CLR  R10
	CLR  R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x19:
	RCALL _lcd_puts
	LDI  R26,LOW(750)
	LDI  R27,HIGH(750)
	RCALL _delay_ms
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _p,R30
	STS  _p+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1B:
	RCALL _Angel
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	__GETD1S 11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1D:
	__PUTD1S 11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1E:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1F:
	__GETD1N 0x3DCCCCCD
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x20:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x21:
	__GETD1S 6
	__GETD2S 11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x22:
	__GETD1N 0x41200000
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	__ADDWRN 18,19,1
	MOV  R30,R16
	SUBI R30,-LOW(48)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x24:
	__GETD2S 11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x26:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	RCALL __GETD1S0
	RET

;RUNTIME LIBRARY

	.CSEG
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

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__SUBD21:
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
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

__ANEGD2:
	COM  R27
	COM  R24
	COM  R25
	NEG  R26
	SBCI R27,-1
	SBCI R24,-1
	SBCI R25,-1
	RET

__LSLD12:
	TST  R30
	MOV  R0,R30
	LDI  R30,8
	MOV  R1,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSLD12R
__LSLD12S8:
	CP   R0,R1
	BRLO __LSLD12L
	MOV  R23,R22
	MOV  R22,R31
	MOV  R31,R30
	LDI  R30,0
	SUB  R0,R1
	BRNE __LSLD12S8
	RET
__LSLD12L:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R0
	BRNE __LSLD12L
__LSLD12R:
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	MOVW R20,R0
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

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	RCALL __ANEGD2
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
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

__CDF2U:
	SET
	RJMP __CDF2U0
__CDF2:
	CLT
__CDF2U0:
	RCALL __SWAPD12
	RCALL __CDF1U0

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

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

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
	MOVW R22,R30
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
	MOVW R20,R18
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

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
