.include "./m328Pdef.inc" ; directive for pin and register definitions

.EQU    SEG_ZERO = 0x08 ; 0x08 = 0b00001000
.EQU    SEG_ONE = 0x7B ; 0x7B = 0b01111011
.EQU    SEG_TWO = 0x34 ; 0x34 = 0b00110100
.EQU    SEG_THREE = 0x31 ; 0x31 = 0b00110001
.EQU    SEG_FOUR = 0x63 ; 0x63 = 0b01100011
.EQU    SEG_FIVE = 0x81 ; 0x81 = 0b10000001
.EQU    SEG_SEVEN = 0x3B ; 0x3B = 0b00111011
.EQU    SEG_EIGHT = 0x00 ; 0x00 = 0b00000000
.EQU    SEG_NINE = 0x01 ; 0x01 = 0b00000001

.def	tmp	= r16		; define temp register

init:
    ldi     r16, 0xFF ; set PORTD as output where is 7seg display
    out     DDRD, r16
	ldi	    ZL, LOW(2*var)		; load 2*var
	ldi	    ZH, HIGH(2*var)		; into Z pointer
	lpm	    r19, Z
	out     PORTD, r19
	    
    ldi     r16, 0b11111000 ; set PC0, PC1, PC2 as input and rest of pins as
    out     DDRC, r16       ; output
    ldi     r16, 0xFF
    out     PORTC, r16 ; pull all PORTC internally to logical 1
	
main:
    in      r16, PINC ; read the value from PORTC
    andi    r16, 0x07 ; 0x07 = 0b00000111 this will keep only MSB: PC0, PC1, PC2
    cpi     r16, 0x05 ; 0x05 = 0b11111101 compare R16 with 0x05. If PC1 = GND,
                      ; then jump to increaseNumb label
    breq    nextValue
    rjmp    main

nextValue:
    lpm	    r19, Z+
	out     PORTD, r20
	call    delay
ret
; -------- delay function - about 1 sek -------- 
delay:    
    ldi     r16, 50
    ldi     r18, 18
    loop_2:
        ldi     R17, 17
    loop_1:   
        dec     R18
        brne    loop_1
        dec     R17 ; decrement 8bit register. DEC instruction sets Z flag
                    ; in the status register 
        brne    loop_1 ; branch if not equal. Tests if the result of the 
                       ; previous operation was zero. If it was not, brne jump 
                       ; to the label given as an operand. If it was zero 
                       ; brne will continue to the next instruction.
        dec     R16
        brne    loop_2
    ret ; return form subroutine
    
; defining constants in program memory    
var:    
    .db     SEG_ZERO, SEG_ONE, SEG_TWO, SEG_THREE, SEG_FOUR, SEG_FIVE
    .db     SEG_SEVEN, SEG_EIGHT, SEG_NINE, 0
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
