
;CodeVisionAVR C Compiler V3.37 Evaluation
;(C) Copyright 1998-2019 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16A
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
	.DEF _x=R4
	.DEF _x_msb=R5
	.DEF _y=R6
	.DEF _y_msb=R7
	.DEF _Time1=R8
	.DEF _Time1_msb=R9
	.DEF _Time2=R10
	.DEF _Time2_msb=R11
	.DEF _rpm1=R12
	.DEF _rpm1_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _int0
	JMP  _int1
	JMP  0x00
	JMP  _timer2_ovf
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf
	JMP  0x00
	JMP  _uasrt_rx
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G103:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G103:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0x3E,0x52,0x65,0x61,0x64,0x79,0x20,0x74
	.DB  0x6F,0x20,0x52,0x65,0x63,0x69,0x76,0x65
	.DB  0x20
_0x4:
	.DB  0x20,0x2A,0x2A,0x56,0x65,0x72,0x79,0x20
	.DB  0x4C,0x6F,0x6E,0x67,0x2A,0x2A
_0x0:
	.DB  0x53,0x61,0x74,0x61,0x72,0x74,0x2E,0x2E
	.DB  0x2E,0x2E,0x0,0x6D,0x6F,0x31,0x20,0x6F
	.DB  0x6E,0x20,0x32,0x35,0x0,0x6D,0x6F,0x31
	.DB  0x20,0x6F,0x6E,0x20,0x35,0x30,0x0,0x6D
	.DB  0x6F,0x31,0x20,0x6F,0x6E,0x20,0x37,0x35
	.DB  0x0,0x6D,0x6F,0x31,0x20,0x6F,0x6E,0x20
	.DB  0x31,0x30,0x30,0x0,0x6D,0x6F,0x31,0x20
	.DB  0x63,0x77,0x0,0x6D,0x6F,0x31,0x20,0x63
	.DB  0x63,0x77,0x0,0x6D,0x6F,0x31,0x20,0x6F
	.DB  0x66,0x66,0x0,0x6D,0x6F,0x32,0x20,0x6F
	.DB  0x6E,0x20,0x32,0x35,0x0,0x6D,0x6F,0x32
	.DB  0x20,0x6F,0x6E,0x20,0x35,0x30,0x0,0x6D
	.DB  0x6F,0x32,0x20,0x6F,0x6E,0x20,0x37,0x35
	.DB  0x0,0x6D,0x6F,0x32,0x20,0x6F,0x6E,0x20
	.DB  0x31,0x30,0x30,0x0,0x6D,0x6F,0x32,0x20
	.DB  0x6F,0x66,0x66,0x0,0x6D,0x6F,0x32,0x20
	.DB  0x63,0x77,0x0,0x6D,0x6F,0x32,0x20,0x63
	.DB  0x63,0x77,0x0,0x4D,0x6F,0x31,0x20,0x4F
	.DB  0x6E,0x20,0x43,0x57,0x0,0x4D,0x6F,0x31
	.DB  0x20,0x4F,0x6E,0x20,0x43,0x43,0x57,0x0
	.DB  0x4D,0x6F,0x31,0x20,0x4F,0x66,0x66,0x0
	.DB  0x52,0x50,0x4D,0x0,0x4D,0x6F,0x32,0x20
	.DB  0x4F,0x6E,0x20,0x43,0x57,0x0,0x4D,0x6F
	.DB  0x32,0x20,0x4F,0x6E,0x20,0x43,0x43,0x57
	.DB  0x0,0x4D,0x6F,0x32,0x20,0x4F,0x66,0x66
	.DB  0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x11
	.DW  _tx1
	.DW  _0x3*2

	.DW  0x0E
	.DW  _txt2
	.DW  _0x4*2

	.DW  0x0B
	.DW  _0x1E
	.DW  _0x0*2

	.DW  0x0A
	.DW  _0x1E+11
	.DW  _0x0*2+11

	.DW  0x0A
	.DW  _0x1E+21
	.DW  _0x0*2+21

	.DW  0x0A
	.DW  _0x1E+31
	.DW  _0x0*2+31

	.DW  0x0B
	.DW  _0x1E+41
	.DW  _0x0*2+41

	.DW  0x07
	.DW  _0x1E+52
	.DW  _0x0*2+52

	.DW  0x08
	.DW  _0x1E+59
	.DW  _0x0*2+59

	.DW  0x08
	.DW  _0x1E+67
	.DW  _0x0*2+67

	.DW  0x0A
	.DW  _0x1E+75
	.DW  _0x0*2+75

	.DW  0x0A
	.DW  _0x1E+85
	.DW  _0x0*2+85

	.DW  0x0A
	.DW  _0x1E+95
	.DW  _0x0*2+95

	.DW  0x0B
	.DW  _0x1E+105
	.DW  _0x0*2+105

	.DW  0x08
	.DW  _0x1E+116
	.DW  _0x0*2+116

	.DW  0x07
	.DW  _0x1E+124
	.DW  _0x0*2+124

	.DW  0x08
	.DW  _0x1E+131
	.DW  _0x0*2+131

	.DW  0x0A
	.DW  _0x1E+139
	.DW  _0x0*2+139

	.DW  0x0B
	.DW  _0x1E+149
	.DW  _0x0*2+149

	.DW  0x08
	.DW  _0x1E+160
	.DW  _0x0*2+160

	.DW  0x04
	.DW  _0x1E+168
	.DW  _0x0*2+168

	.DW  0x0A
	.DW  _0x1E+172
	.DW  _0x0*2+172

	.DW  0x0B
	.DW  _0x1E+182
	.DW  _0x0*2+182

	.DW  0x08
	.DW  _0x1E+193
	.DW  _0x0*2+193

	.DW  0x04
	.DW  _0x1E+201
	.DW  _0x0*2+168

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

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
;/*******************************************************
;This program was created by the CodeWizardAVR V3.37
;Automatic Program Generator
;© Copyright 1998-2019 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 11/21/2019
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16A
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
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
;#include <lcd.h>
;#include <delay.h>
;#include <stdlib.h>
;#include <string.h>
;
;#asm
.equ __lcd_port=0x1B ;PORTA
; 0000 001E #endasm
;
;unsigned int x,y,Time1,Time2,rpm1,rpm2;
;unsigned char *v;
;char ch,i,j,k;
;unsigned char txt[12];
;unsigned char tx1[]=">Ready to Recive ";

	.DSEG
;unsigned char txt2[]=" **Very Long**";
;
;//________________________________________________________________
;interrupt [USART_RXC] void uasrt_rx(void)
; 0000 0029 {ch=UDR;

	.CSEG
_uasrt_rx:
; .FSTART _uasrt_rx
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	IN   R30,0xC
	STS  _ch,R30
; 0000 002A txt[i]=ch;
	RCALL SUBOPT_0x0
	LDS  R26,_ch
	STD  Z+0,R26
; 0000 002B if(i<11)
	LDS  R26,_i
	CPI  R26,LOW(0xB)
	BRSH _0x5
; 0000 002C i++;
	LDS  R30,_i
	SUBI R30,-LOW(1)
	STS  _i,R30
; 0000 002D     else
	RJMP _0x6
_0x5:
; 0000 002E     {i=0;
	LDI  R30,LOW(0)
	STS  _i,R30
; 0000 002F     while (txt2[k]!=0)
_0x7:
	RCALL SUBOPT_0x1
	CPI  R30,0
	BREQ _0x9
; 0000 0030     {while(UCSRA.5==0);
_0xA:
	SBIS 0xB,5
	RJMP _0xA
; 0000 0031     UDR=txt2[k];
	RCALL SUBOPT_0x1
	OUT  0xC,R30
; 0000 0032     k++;
	LDS  R30,_k
	SUBI R30,-LOW(1)
	STS  _k,R30
; 0000 0033     }
	RJMP _0x7
_0x9:
; 0000 0034     if (txt2[k]==0)
	RCALL SUBOPT_0x1
	CPI  R30,0
	BRNE _0xD
; 0000 0035     {while(UCSRA.5==0);
_0xE:
	SBIS 0xB,5
	RJMP _0xE
; 0000 0036     UDR=13;
	LDI  R30,LOW(13)
	OUT  0xC,R30
; 0000 0037     ch=UDR;
	IN   R30,0xC
	STS  _ch,R30
; 0000 0038     k=0;
	LDI  R30,LOW(0)
	STS  _k,R30
; 0000 0039     }
; 0000 003A     }
_0xD:
_0x6:
; 0000 003B if(ch==13)
	LDS  R26,_ch
	CPI  R26,LOW(0xD)
	BRNE _0x11
; 0000 003C     {i=0;
	LDI  R30,LOW(0)
	STS  _i,R30
; 0000 003D     while (tx1[j]!=0)
_0x12:
	RCALL SUBOPT_0x2
	CPI  R30,0
	BREQ _0x14
; 0000 003E         {while(UCSRA.5==0);
_0x15:
	SBIS 0xB,5
	RJMP _0x15
; 0000 003F         UDR=tx1[j];
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0000 0040         j++;
; 0000 0041         }
	RJMP _0x12
_0x14:
; 0000 0042     j=0;
	LDI  R30,LOW(0)
	STS  _j,R30
; 0000 0043     }
; 0000 0044 }
_0x11:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;interrupt [EXT_INT0] void int0 (void)
; 0000 0047 {if (OCR0!=0)
_int0:
; .FSTART _int0
	RCALL SUBOPT_0x4
	IN   R30,0x3C
	CPI  R30,0
	BREQ _0x18
; 0000 0048 x++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 0049 else x=0;
	RJMP _0x19
_0x18:
	CLR  R4
	CLR  R5
; 0000 004A }
_0x19:
	RJMP _0x71
; .FEND
;
;interrupt [TIM0_OVF] void timer0_ovf (void)
; 0000 004D {Time1++;
_timer0_ovf:
; .FSTART _timer0_ovf
	RCALL SUBOPT_0x5
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 004E if(Time1==500)
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x1A
; 0000 004F     {rpm1=x*60/20;
	MOVW R30,R4
	RCALL SUBOPT_0x6
	MOVW R12,R30
; 0000 0050     x=0;
	CLR  R4
	CLR  R5
; 0000 0051     Time1=0;
	CLR  R8
	CLR  R9
; 0000 0052     }
; 0000 0053 }
_0x1A:
	RJMP _0x72
; .FEND
;
;interrupt [TIM2_OVF] void timer2_ovf (void)
; 0000 0056 {Time2++;
_timer2_ovf:
; .FSTART _timer2_ovf
	RCALL SUBOPT_0x5
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 0057 if(Time2==500)
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x1B
; 0000 0058     {rpm2=y*60/20;
	MOVW R30,R6
	RCALL SUBOPT_0x6
	STS  _rpm2,R30
	STS  _rpm2+1,R31
; 0000 0059     y=0;
	CLR  R6
	CLR  R7
; 0000 005A     Time2=0;
	CLR  R10
	CLR  R11
; 0000 005B     }
; 0000 005C }
_0x1B:
_0x72:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;interrupt [EXT_INT1] void int1 (void)
; 0000 005F {if (OCR2!=0)
_int1:
; .FSTART _int1
	RCALL SUBOPT_0x4
	IN   R30,0x23
	CPI  R30,0
	BREQ _0x1C
; 0000 0060 y++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 0061 else y=0;
	RJMP _0x1D
_0x1C:
	CLR  R6
	CLR  R7
; 0000 0062 }
_0x1D:
_0x71:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;//________________________________________________________________
;void main(void)
; 0000 0066 {
_main:
; .FSTART _main
; 0000 0067 DDRB=0b11001000;
	LDI  R30,LOW(200)
	OUT  0x17,R30
; 0000 0068 DDRC=0b00001111;
	LDI  R30,LOW(15)
	OUT  0x14,R30
; 0000 0069 DDRD=0b10000000;
	LDI  R30,LOW(128)
	OUT  0x11,R30
; 0000 006A PORTD=0b00001100;
	LDI  R30,LOW(12)
	OUT  0x12,R30
; 0000 006B //________________________________________________________________
; 0000 006C // External Interrupt(s) initializtion
; 0000 006D // INT0 = on
; 0000 006E // INT0 Mode: Falling Edge
; 0000 006F // INT1 = on
; 0000 0070 // INT1 Mode: Falling Edge
; 0000 0071 GICR=0b11000000;
	LDI  R30,LOW(192)
	OUT  0x3B,R30
; 0000 0072 MCUCR=0b00001010;
	LDI  R30,LOW(10)
	OUT  0x35,R30
; 0000 0073 //________________________________________________________________
; 0000 0074 
; 0000 0075 //________________________________________________________________
; 0000 0076 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0077 lcd_puts("Satart....");
	__POINTW2MN _0x1E,0
	RCALL _lcd_puts
; 0000 0078 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 0079 lcd_clear();
	RCALL _lcd_clear
; 0000 007A //________________________________________________________________
; 0000 007B // Timer/Counter 0 initialization
; 0000 007C // Timer/Counter 1 initialization
; 0000 007D // Clock source: System Clock
; 0000 007E // Mode: Fast PWM
; 0000 007F // Prescaler = 64
; 0000 0080 // OCR output: Non-Inverted
; 0000 0081 TCCR0=0B01101011;
	LDI  R30,LOW(107)
	OUT  0x33,R30
; 0000 0082 TCCR2=0B01101100;
	LDI  R30,LOW(108)
	OUT  0x25,R30
; 0000 0083 //________________________________________________________________
; 0000 0084 // Timer Interrupt initialization
; 0000 0085 TIMSK=0b01000001;
	LDI  R30,LOW(65)
	OUT  0x39,R30
; 0000 0086 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0087 //________________________________________________________________
; 0000 0088 //USART
; 0000 0089 UBRRH=0x00;
	OUT  0x20,R30
; 0000 008A UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 008B UCSRB=0b10011000;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 008C UCSRC=0b10000110;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 008D 
; 0000 008E while (tx1[j]!=0)
_0x1F:
	RCALL SUBOPT_0x2
	CPI  R30,0
	BREQ _0x21
; 0000 008F     {while(UCSRA.5==0);
_0x22:
	SBIS 0xB,5
	RJMP _0x22
; 0000 0090     UDR=tx1[j];
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0000 0091     j++;
; 0000 0092     }
	RJMP _0x1F
_0x21:
; 0000 0093 j=0;
	LDI  R30,LOW(0)
	STS  _j,R30
; 0000 0094 
; 0000 0095 // Global enable interrupts
; 0000 0096 #asm("sei")
	SEI
; 0000 0097 while (1)
_0x25:
; 0000 0098       {
; 0000 0099       delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0000 009A       lcd_clear();
	RCALL _lcd_clear
; 0000 009B       txt[i]=0;
	RCALL SUBOPT_0x0
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 009C //________________________________________________________________
; 0000 009D       // Motor 1
; 0000 009E       if(strcmp(txt,"mo1 on 25")==0)
	RCALL SUBOPT_0x7
	__POINTW2MN _0x1E,11
	RCALL _strcmp
	CPI  R30,0
	BRNE _0x28
; 0000 009F       OCR0=60;
	LDI  R30,LOW(60)
	OUT  0x3C,R30
; 0000 00A0       if(strcmp(txt,"mo1 on 50")==0)
_0x28:
	RCALL SUBOPT_0x7
	__POINTW2MN _0x1E,21
	RCALL _strcmp
	CPI  R30,0
	BRNE _0x29
; 0000 00A1       OCR0=127;
	LDI  R30,LOW(127)
	OUT  0x3C,R30
; 0000 00A2       if(strcmp(txt,"mo1 on 75")==0)
_0x29:
	RCALL SUBOPT_0x7
	__POINTW2MN _0x1E,31
	RCALL _strcmp
	CPI  R30,0
	BRNE _0x2A
; 0000 00A3       OCR0=190;
	LDI  R30,LOW(190)
	OUT  0x3C,R30
; 0000 00A4       if(strcmp(txt,"mo1 on 100")==0)
_0x2A:
	RCALL SUBOPT_0x7
	__POINTW2MN _0x1E,41
	RCALL _strcmp
	CPI  R30,0
	BRNE _0x2B
; 0000 00A5       OCR0=255;
	LDI  R30,LOW(255)
	OUT  0x3C,R30
; 0000 00A6 
; 0000 00A7       if (strcmp(txt,"mo1 cw")==0)
_0x2B:
	RCALL SUBOPT_0x7
	__POINTW2MN _0x1E,52
	RCALL _strcmp
	CPI  R30,0
	BRNE _0x2C
; 0000 00A8       {PORTC.3=0;   PORTC.2=1;}
	CBI  0x15,3
	SBI  0x15,2
; 0000 00A9 
; 0000 00AA       else if(strcmp(txt,"mo1 ccw")==0)
	RJMP _0x31
_0x2C:
	RCALL SUBOPT_0x7
	__POINTW2MN _0x1E,59
	RCALL _strcmp
	CPI  R30,0
	BRNE _0x32
; 0000 00AB       {PORTC.3=1;   PORTC.2=0;}
	SBI  0x15,3
	CBI  0x15,2
; 0000 00AC 
; 0000 00AD       if (strcmp(txt,"mo1 off")==0)
_0x32:
_0x31:
	RCALL SUBOPT_0x7
	__POINTW2MN _0x1E,67
	RCALL _strcmp
	CPI  R30,0
	BRNE _0x37
; 0000 00AE       {
; 0000 00AF       OCR0=0;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 00B0       PORTC.3=0;
	CBI  0x15,3
; 0000 00B1       PORTC.2=0;
	CBI  0x15,2
; 0000 00B2       PORTB.7=0;
	CBI  0x18,7
; 0000 00B3       }
; 0000 00B4 
; 0000 00B5 //________________________________________________________________
; 0000 00B6       // Motor 2
; 0000 00B7       if(strcmp(txt,"mo2 on 25")==0)
_0x37:
	RCALL SUBOPT_0x7
	__POINTW2MN _0x1E,75
	RCALL _strcmp
	CPI  R30,0
	BRNE _0x3E
; 0000 00B8       OCR2=60;
	LDI  R30,LOW(60)
	OUT  0x23,R30
; 0000 00B9       if(strcmp(txt,"mo2 on 50")==0)
_0x3E:
	RCALL SUBOPT_0x7
	__POINTW2MN _0x1E,85
	RCALL _strcmp
	CPI  R30,0
	BRNE _0x3F
; 0000 00BA       OCR2=127;
	LDI  R30,LOW(127)
	OUT  0x23,R30
; 0000 00BB       if(strcmp(txt,"mo2 on 75")==0)
_0x3F:
	RCALL SUBOPT_0x7
	__POINTW2MN _0x1E,95
	RCALL _strcmp
	CPI  R30,0
	BRNE _0x40
; 0000 00BC       OCR2=190;
	LDI  R30,LOW(190)
	OUT  0x23,R30
; 0000 00BD       if(strcmp(txt,"mo2 on 100")==0)
_0x40:
	RCALL SUBOPT_0x7
	__POINTW2MN _0x1E,105
	RCALL _strcmp
	CPI  R30,0
	BRNE _0x41
; 0000 00BE       OCR2=255;
	LDI  R30,LOW(255)
	OUT  0x23,R30
; 0000 00BF       if (strcmp(txt,"mo2 off")==0)
_0x41:
	RCALL SUBOPT_0x7
	__POINTW2MN _0x1E,116
	RCALL _strcmp
	CPI  R30,0
	BRNE _0x42
; 0000 00C0         {PORTC.0=0;
	CBI  0x15,0
; 0000 00C1         PORTC.1=0;
	CBI  0x15,1
; 0000 00C2         OCR2=0;
	LDI  R30,LOW(0)
	OUT  0x23,R30
; 0000 00C3         PORTB.6=0;
	CBI  0x18,6
; 0000 00C4         }
; 0000 00C5 
; 0000 00C6       if (strcmp(txt,"mo2 cw")==0)
_0x42:
	RCALL SUBOPT_0x7
	__POINTW2MN _0x1E,124
	RCALL _strcmp
	CPI  R30,0
	BRNE _0x49
; 0000 00C7       {PORTC.0=1;   PORTC.1=0;}
	SBI  0x15,0
	CBI  0x15,1
; 0000 00C8 
; 0000 00C9       else if(strcmp(txt,"mo2 ccw")==0)
	RJMP _0x4E
_0x49:
	RCALL SUBOPT_0x7
	__POINTW2MN _0x1E,131
	RCALL _strcmp
	CPI  R30,0
	BRNE _0x4F
; 0000 00CA       {PORTC.0=0;   PORTC.1=1;}
	CBI  0x15,0
	SBI  0x15,1
; 0000 00CB 
; 0000 00CC //________________________________________________________________
; 0000 00CD       //Turn Motor1 Led On
; 0000 00CE       if (OCR0>1&&(PORTC.3==!PORTC.2))
_0x4F:
_0x4E:
	IN   R30,0x3C
	CPI  R30,LOW(0x2)
	BRLO _0x55
	LDI  R26,0
	SBIC 0x15,3
	LDI  R26,1
	LDI  R30,0
	SBIS 0x15,2
	LDI  R30,1
	CP   R30,R26
	BREQ _0x56
_0x55:
	RJMP _0x54
_0x56:
; 0000 00CF       PORTB.7=1;
	SBI  0x18,7
; 0000 00D0       //Turn Motor2 Led On
; 0000 00D1       if (OCR2>1&&(PORTC.0==!PORTC.1))
_0x54:
	IN   R30,0x23
	CPI  R30,LOW(0x2)
	BRLO _0x5A
	LDI  R26,0
	SBIC 0x15,0
	LDI  R26,1
	LDI  R30,0
	SBIS 0x15,1
	LDI  R30,1
	CP   R30,R26
	BREQ _0x5B
_0x5A:
	RJMP _0x59
_0x5B:
; 0000 00D2       PORTB.6=1;
	SBI  0x18,6
; 0000 00D3 
; 0000 00D4 //________________________________________________________________
; 0000 00D5       lcd_gotoxy(0,0);
_0x59:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 00D6       if(OCR0>1&&PORTC.2==1)        //Motor1 On and INT2 (L298) On
	IN   R30,0x3C
	CPI  R30,LOW(0x2)
	BRLO _0x5F
	SBIC 0x15,2
	RJMP _0x60
_0x5F:
	RJMP _0x5E
_0x60:
; 0000 00D7       lcd_puts("Mo1 On CW");
	__POINTW2MN _0x1E,139
	RJMP _0x6F
; 0000 00D8 
; 0000 00D9       else if(OCR0>1&&PORTC.3==1)   //Motor1 On and INT1 (L298) On
_0x5E:
	IN   R30,0x3C
	CPI  R30,LOW(0x2)
	BRLO _0x63
	SBIC 0x15,3
	RJMP _0x64
_0x63:
	RJMP _0x62
_0x64:
; 0000 00DA       lcd_puts("Mo1 On CCW");
	__POINTW2MN _0x1E,149
	RJMP _0x6F
; 0000 00DB 
; 0000 00DC       else lcd_puts("Mo1 Off");     //Motor2 Off and INT1 && INT2 (L298) off
_0x62:
	__POINTW2MN _0x1E,160
_0x6F:
	RCALL _lcd_puts
; 0000 00DD 
; 0000 00DE       lcd_gotoxy(11,0);
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 00DF       itoa(rpm1,v);
	ST   -Y,R13
	ST   -Y,R12
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
; 0000 00E0       lcd_puts(v);
; 0000 00E1 
; 0000 00E2       lcd_gotoxy(13,0);
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 00E3       lcd_puts("RPM");
	__POINTW2MN _0x1E,168
	RCALL _lcd_puts
; 0000 00E4 
; 0000 00E5 //________________________________________________________________
; 0000 00E6       lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 00E7 
; 0000 00E8       if(OCR2>1&&PORTC.0==1)        //Motor2 On and INT4 (L298) On
	IN   R30,0x23
	CPI  R30,LOW(0x2)
	BRLO _0x67
	SBIC 0x15,0
	RJMP _0x68
_0x67:
	RJMP _0x66
_0x68:
; 0000 00E9       lcd_puts("Mo2 On CW");
	__POINTW2MN _0x1E,172
	RJMP _0x70
; 0000 00EA 
; 0000 00EB       else if(OCR2>1&&PORTC.1==1) //Motor2 On and INT3 (L298) On
_0x66:
	IN   R30,0x23
	CPI  R30,LOW(0x2)
	BRLO _0x6B
	SBIC 0x15,1
	RJMP _0x6C
_0x6B:
	RJMP _0x6A
_0x6C:
; 0000 00EC       lcd_puts("Mo2 On CCW");
	__POINTW2MN _0x1E,182
	RJMP _0x70
; 0000 00ED 
; 0000 00EE       else
_0x6A:
; 0000 00EF       lcd_puts("Mo2 Off");          //Motor2 Off and INT3 && INT4 (L298) off
	__POINTW2MN _0x1E,193
_0x70:
	RCALL _lcd_puts
; 0000 00F0 
; 0000 00F1       lcd_gotoxy(11,1);
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 00F2       itoa(rpm2,v);
	LDS  R30,_rpm2
	LDS  R31,_rpm2+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
; 0000 00F3       lcd_puts(v);
; 0000 00F4 
; 0000 00F5       lcd_gotoxy(13,1);
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 00F6       lcd_puts("RPM");
	__POINTW2MN _0x1E,201
	RCALL _lcd_puts
; 0000 00F7 
; 0000 00F8       }
	RJMP _0x25
; 0000 00F9 }
_0x6E:
	RJMP _0x6E
; .FEND

	.DSEG
_0x1E:
	.BYTE 0xCD
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
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G100:
; .FSTART __lcd_delay_G100
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
; .FEND
__lcd_ready:
; .FSTART __lcd_ready
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
; .FEND
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G100
	RET
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G100
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x20C0001
; .FEND
__lcd_read_nibble_G100:
; .FSTART __lcd_read_nibble_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G100
    andi  r30,0xf0
	RET
; .FEND
_lcd_read_byte0_G100:
; .FSTART _lcd_read_byte0_G100
	RCALL __lcd_delay_G100
	RCALL __lcd_read_nibble_G100
    mov   r26,r30
	RCALL __lcd_read_nibble_G100
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	RCALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
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
	RCALL __lcd_ready
	LDI  R26,LOW(2)
	RCALL __lcd_write_data
	RCALL __lcd_ready
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	RCALL __lcd_ready
	LDI  R26,LOW(1)
	RCALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000004
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2000004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
	LD   R26,Y
	RCALL __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x20C0001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000007
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000005
_0x2000007:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
__long_delay_G100:
; .FSTART __long_delay_G100
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
; .FEND
__lcd_init_write_G100:
; .FSTART __lcd_init_write_G100
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x20C0001
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	RCALL __long_delay_G100
	LDI  R26,LOW(48)
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R26,LOW(48)
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R26,LOW(48)
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R26,LOW(32)
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	RCALL __long_delay_G100
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	RCALL __long_delay_G100
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	RCALL __long_delay_G100
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RCALL _lcd_read_byte0_G100
	CPI  R30,LOW(0x5)
	BREQ _0x200000B
	LDI  R30,LOW(0)
	RJMP _0x20C0001
_0x200000B:
	RCALL __lcd_ready
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
	LDI  R30,LOW(1)
_0x20C0001:
	ADIW R28,1
	RET
; .FEND

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

	.DSEG

	.CSEG

	.CSEG
_strcmp:
; .FSTART _strcmp
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strcmp0:
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strcmp1
    tst  r22
    brne strcmp0
strcmp3:
    clr  r30
    ret
strcmp1:
    sub  r22,r23
    breq strcmp3
    ldi  r30,1
    brcc strcmp2
    subi r30,2
strcmp2:
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

	.CSEG

	.CSEG

	.DSEG
_rpm2:
	.BYTE 0x2
_v:
	.BYTE 0x2
_ch:
	.BYTE 0x1
_i:
	.BYTE 0x1
_j:
	.BYTE 0x1
_k:
	.BYTE 0x1
_txt:
	.BYTE 0xC
_tx1:
	.BYTE 0x12
_txt2:
	.BYTE 0xF
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LDS  R30,_i
	LDI  R31,0
	SUBI R30,LOW(-_txt)
	SBCI R31,HIGH(-_txt)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1:
	LDS  R30,_k
	LDI  R31,0
	SUBI R30,LOW(-_txt2)
	SBCI R31,HIGH(-_txt2)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2:
	LDS  R30,_j
	LDI  R31,0
	SUBI R30,LOW(-_tx1)
	SBCI R31,HIGH(-_tx1)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	OUT  0xC,R30
	LDS  R30,_j
	SUBI R30,-LOW(1)
	STS  _j,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(60)
	LDI  R27,HIGH(60)
	RCALL __MULW12U
	MOVW R26,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(_txt)
	LDI  R31,HIGH(_txt)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	LDS  R26,_v
	LDS  R27,_v+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	RCALL _itoa
	RCALL SUBOPT_0x8
	RCALL _lcd_puts
	LDI  R30,LOW(13)
	ST   -Y,R30
	RET

;RUNTIME LIBRARY

	.CSEG
__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
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
