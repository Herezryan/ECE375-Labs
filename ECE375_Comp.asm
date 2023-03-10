;***********************************************************
;*	 Author: Paul Lipp and Ryan Muriset
;*	   Date: Feb 3, 2023
;*
;***********************************************************

.include "m32U4def.inc"			; Include definition file

;***********************************************************
;*	Internal Register Definitions and Constants
;***********************************************************
.def	mpr = r16				; Multipurpose register is required for LCD Driver
.def	counter = r17				; Counter register used for incrementing Y and Z pointers
.equ	PD_seven = 7				; Button D7
.equ	PD_five = 5				; Button D5
.equ	PD_four = 4				; Button D4
;***********************************************************
;*	Start of Code Segment
;***********************************************************
.cseg							; Beginning of code segment

;***********************************************************
;*	Interrupt Vectors
;***********************************************************
.org	$0000					; Beginning of IVs
		rjmp INIT				; Reset interrupt

.org	$0056					; End of Interrupt Vectors

;***********************************************************
;*	Program Initialization
;***********************************************************
INIT:							; The initialization routine

	ldi	mpr, low(RAMEND)	; Initialize Stack Pointer
	out SPL, mpr
	ldi mpr, high(RAMEND)
	out SPH, mpr

	rcall LCDInit			; Initialize LCD Display

        	; Initialize Port D for input
	ldi		mpr, $00		; Set Port D Data Direction Register
	out		DDRD, mpr		; for input
	ldi		mpr, $FF		; Initialize Port D Data Register
	out		PORTD, mpr		; so all Port D inputs are Tri-State

		


;***********************************************************
;*	Main Program
;***********************************************************
MAIN:								; The Main program
	
        in		mpr, PIND				; Get input from Port D
	andi	mpr, (1<<PD_five|1<<PD_four)
	cpi		mpr, (1<<PD_five)		; Check for button d5
	brne	NEXT					
	ldi counter, 9					; Setting our counter to 9

	;strings from program mem to data mem
        ldi ZL, low(STRING_BEG_L1<<1)
	ldi ZH, high(STRING_BEG_L1<<1)

        ;pointing y to address of LCD line1 ($0100)
        ldi YL, $00
	ldi YH, $01

		
	rcall	PRINT					; Call the subroutine print
	rjmp	MAIN					; Continue through main 

NEXT:
        cpi		mpr, (1<<PD_four)		; Check for PD4 input (Recall Active)
	brne	MAIN					
	rcall	CLEAR					; Call subroutine CLEAR
	rjmp	MAIN					; Continue through main
		
;***********************************************************
;*	Functions and Subroutines
;***********************************************************

;-----------------------------------------------------------
; Func: Template function header
; Desc: Cut and paste this and fill in the info at the
;		beginning of your functions
;-----------------------------------------------------------
PRINT:	
     
        ;load from program memory
        lpm mpr, Z+
	st Y+, mpr					; Store value in mpr in Y, increment Y
	dec counter					; decrement counter
	brne PRINT					; repeat until counter = 0

        rcall LCDWrLn1					; write to line 1 of LCD

	;strings from program mem to data mem
        ldi ZL, low(STRING_BEG_L2<<1)
	ldi ZH, high(STRING_BEG_L2<<1)

        ;pointing y to address of LCD line2 ($0110)
        ldi YL, $10
	ldi YH, $01

	ldi counter, 16					; load k = 16 into counter (r17)

	rcall PRINT2

	ret						; End subroutine

PRINT2:

		 ;load from program memory
        lpm mpr, Z+					; Same as PRINT subroutine
	st Y+, mpr
	dec counter
	brne PRINT2

        rcall LCDWrLn2
	ret
CLEAR:
        rcall LCDClr            ;Clear LCD
        ret                     ;End subroutine
;***********************************************************
;*	Stored Program Data
;***********************************************************

;-----------------------------------------------------------
; An example of storing a string. Note the labels before and
; after the .DB directive; these can help to access the data
;-----------------------------------------------------------
STRING_BEG_L1:
.DB		"Paul Lipp"				; Declaring data in ProgMem
STRING_BEG_L2:
.DB		"and Ryan Muriset"
STRING_END:

;***********************************************************
;*	Additional Program Includes
;***********************************************************
.include "LCDDriver.asm"		; Include the LCD Driver
