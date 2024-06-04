;
; Example X-Makina program
; Assembling two string functions (CalculateStringLength and CopyAndConvertString)
; Called by mainline
;
; L. Hughes
; Code edited and repurposed by
; Iftekhar Rafi
; B00871031
;
;
STKTOP  equ     #FFC0   ; Stack top - PUSH (decr then write); PULL (read then incr)
NUL     equ     #00     ; End-of-string indicator (NUL)
DIFF    equ     #20     ; Difference between lower-case and upper-case

; 
r2      equ     R2      ; r2 is alias of R2
LR      equ     R5      ; LR is alias of R5
SP      equ     R6      ; SP is alias of R6 
PC      equ     R7      ; PC is alias of R7
;
; Code space
;
        org     #1000
Main
;
; Initialize stack point
;
        movls   STKTOP,SP       ; STKTOP.LSB to SP.LSB; $FF to SP.MSB
;
; R1 points to string
;
        movl    MyStr,R1
        movh    MyStr,R1
;
; Call CalculateStringLength
; R1 points to string
; R0 returned with length
;
        bl      CalculateStringLength  
;
; Two examples of storing (R0, length, in MSLen):
;
; 1. Indexed using R1 (address of MyStr)
;
        sub     #2,R1   ; Word before MyStr is MSLen
        st.w    R0,R1+  ; Save R0 in MSLen
                        ; Bit of a cheat - increment R1 by 2 to point 
                        ; back to string MyStr
;
; 2. Relative using offset "back" from R1 to MSLen's location
;
        str.w   R0,R1,$-2       ; mem[R1-2] = R0
                                ; Note that R1 is unchanged
;
; Call CopyAndConvertString
; MyStr (R1) to Str2 (r2)
; Setup destination str in R2
;
        movl    Str2,r2
        movh    Str2,r2
;
        bl      CopyAndConvertString  ; LR holds return address
;
; No halt, loop until ^C
;
Done    
        bra     Done
;
; String length function
; Input: R1 - Address of NUL-terminated string
; Returns: Length of string in R0
;
CalculateStringLength
; 
        st      R1,-SP  ; Push R1 (to restore on exit)
        st      R2,-SP  ; Push R2 (holds character read)
        movlz   #0,R0   ; Return length in R0 (initially zero)
;
CalculateStringLengthLoop 
        ld.b    R1+,R2  ; Copy byte [R1] to R2 and R1 incremented by 1
        cmp.b   NUL,R2  ; Compare byte (in R2) with NUL
        beq     CalculateStringLengthEnd ; If equal, go to end
        add     #1,R0   ; R0 (length) incremented by 1
        bra     CalculateStringLengthLoop ; Check next byte
;
; Finished
;
CalculateStringLengthEnd 
        ld      SP+,R2  ; Pull R2
        ld      SP+,R1  ; Pull R1
        mov     LR,PC   ; Return to caller.  R0 has length
;
        org     #2000
;
; String copy and convert function
; Input: R1 - src string; R2 - dst string
; R0 holds char - stop when NUL
; No check on length of dst string
; Returns: nothing
;
CopyAndConvertString
        st      R0,-SP  ; Push R0
        st      R1,-SP  ; Push R1
        st      R2,-SP  ; Push R2

CopyAndConvertStringLoop
        ld.b    R1+,R0  ; Load byte from src to R0 and increment R1
        cmp.b   NUL,R0  ; Compare with NUL
        beq     CopyAndConvertStringEnd ; If NUL, end loop

        movlz   #61,R3  ; Load 'a' ASCII value into R3
        cmp.b   R3,R0   ; Compare byte with 'a'
        blt     NoConversionNeeded ; If less than 'a', no conversion needed

        movlz   #7A,R3  ; Load 'z' ASCII value into R3
        cmp.b   R3,R0   ; Compare byte with 'z'
        bge     NoConversionNeeded ; If greater than or equal to 'z', no conversion needed

        sub.b   DIFF,R0 ; Convert to upper-case by subtracting 32

NoConversionNeeded
        st.b    R0,R2+  ; Store the byte to destination and increment R2
        bra     CopyAndConvertStringLoop ; Repeat loop

CopyAndConvertStringEnd
        ld      SP+,R2  ; Pull R2
        ld      SP+,R1  ; Pull R1
        ld      SP+,R0  ; Pull R0
        mov     LR,PC   ; Return to caller
;
; Data space 
; Setting the origin could be unsafe - if code addresses extend past $1000, they
; could be overwritten by the data.  This is one argument for a linker.
;
        org     #3000
;
MSLen   bss     #2      ; Reserve 2 bytes (word) for length of MyStr
;
MyStr   ascii   "hello, world\n\0"
;
Str2    bss     $100    ; 100 bytes for destination string
;
        end     Main
