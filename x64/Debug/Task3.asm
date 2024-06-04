;
; Count the number of bits set in a register
;
; Input: R0 - Register to count bits in
; Output: R1 - Number of bits set
;
; Assuming a 32-bit register
;

STKTOP  equ     #FFC0   ; Stack top - PUSH (decr then write); PULL (read then incr)

LR	equ	R5	; LR is alias of R5
SP      equ     R6      ; SP is alias of R6 
PC      equ     R7      ; PC is alias of R7

        org     #1000

Main
        movls   STKTOP,SP       ; Initialize stack pointer

        movls   #0F,R0  ; Example value for testing
        bl      CountBits        ; Call the function

Done    
        bra     Done             ; Infinite loop to end the program

; Function to count bits set in a register
; Input: R0 - Register to count bits in
; Output: R1 - Number of bits set

CountBits
        st      R1,-SP          ; Push R1 (to restore on exit)
        movlz   #0,R1           ; Initialize R1 to 0 (count of set bits)

CountLoop
        mov     R0,R2           ; Copy R0 to R2
        and     #1,R2           ; Isolate the least significant bit
        add     R2,R1           ; Add the isolated bit to the count
        sra     R0,#1           ; Shift R0 right by 1 bit arithmetic
        cmp     #0,R0           ; Compare R0 with 0
        bne     CountLoop        ; If R0 is not 0, repeat the loop
        ld      SP+,R1          ; Restore R1
        mov     LR,PC           ; Return to caller

        end     Main
