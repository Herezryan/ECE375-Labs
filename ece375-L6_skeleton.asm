;***********************************************************
;*
;*	This is the skeleton file for Lab 6 of ECE 375
;*
;*	 Author: Enter your name
;*	   Date: Enter Date
;*
;***********************************************************

.include "m32U4def.inc"			; Include definition file

;***********************************************************
;*	Internal Register Definitions and Constants
;***********************************************************
.def	mpr = r16				; Multipurpose register

.equ	EngEnR = 5				; right Engine Enable Bit
.equ	EngEnL = 6				; left Engine Enable Bit
.equ	EngDirR = 4				; right Engine Direction Bit
.equ	EngDirL = 7				; left Engine Direction Bit

;***********************************************************
;*	Start of Code Segment
;***********************************************************
.cseg							; beginning of code segment

;***********************************************************
;*	Interrupt Vectors
;***********************************************************
.org	$0000
		rjmp	INIT			; reset interrupt

		; place instructions in interrupt vectors here, if needed

.org	$0056					; end of interrupt vectors

;***********************************************************
;*	Program Initialization
;***********************************************************
INIT:
		; Initialize the Stack Pointer

		ldi	mpr, low(RAMEND)	; Initialize Stack Pointer
		out SPL, mpr
		ldi mpr, high(RAMEND)
		out SPH, mpr

		; Configure I/O ports

		ldi mpr, $00			; Initialize Port D for input
		out DDRD, mpr
		ldi mpr, $FF
		out PORTD, mpr

								; Initialize PORT B for Output 
		ldi		mpr, $FF		; Set Port B Data Direction Register
		out		DDRB, mpr		; for output
		ldi		mpr, $00		; Initialize Port B Data Register
		out		PORTB, mpr		; so all Port B outputs are low

		; Configure External Interrupts, if needed


		; Configure 16-bit Timer/Counter 1A and 1B

		ldi mpr, $00
		sts TCNT1H, mpr
		ldi mpr, $00
		sts TCNT1L, mpr

		ldi mpr, $00
		sts OCR1AH, mpr
		ldi mpr, $00
		sts OCR1AL, mpr

		ldi mpr, $B1			;load mpr with 177
		sts TCCR1A, mpr			;copy value from mpr to TCCR1A 
		ldi mpr, $09			;load mpr with value of address		
		sts TCCR1B, mpr			;copy value from mpr to TCCR1B

		; Fast PWM, 8-bit mode, no prescaling

		; Set TekBot to Move Forward (1<<EngDirR|1<<EngDirL) on Port B

		; Set initial speed, display on Port B pins 3:0

		; Enable global interrupts (if any are used)

;***********************************************************
;*	Main Program
;***********************************************************
MAIN:
		; poll Port D pushbuttons (if needed)

								; if pressed, adjust speed
								; also, adjust speed indication

		rjmp	MAIN			; return to top of MAIN

;***********************************************************
;*	Functions and Subroutines
;***********************************************************

;-----------------------------------------------------------
; Func:	Template function header
; Desc:	Cut and paste this and fill in the info at the
;		beginning of your functions
;-----------------------------------------------------------
FUNC:	; Begin a function with a label

		; If needed, save variables by pushing to the stack

		; Execute the function here

		; Restore any saved variables by popping from stack

		ret						; End a function with RET

;***********************************************************
;*	Stored Program Data
;***********************************************************
		; Enter any stored data you might need here

;***********************************************************
;*	Additional Program Includes
;***********************************************************
		; There are no additional file includes for this program
