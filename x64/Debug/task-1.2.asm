;
; Sum an array of 16-bit numbers
;
; ECED 3403
; Name: Iftekhar Rafi
; ID: B00871031
;
; Date: 20 May 24
;
	org	#1000
;
; Initialize registers
;
Main
	movlz	#800,R0		; Load lower byte of base address of the array into R0
	movh	#800,R0		; Load upper byte of base address of the array into R0
	ld	R0,R1		; Load the limit value from the first word of the array into R1
	movlz	#0,R2		; Initialize sum to 0 in R2
	movlz	#2,R4		; Initialize index to 2 in R4 (points to the first number after the limit)
;
; Sum the array elements
;
SumLoop
	ld		R0,R3		; Load the current number from the array into R3
	add		R3,R2		; Add the current number to the sum in R2
	add		#2,R0		; Increment address in R0 to point to the next number
	cmp		R4,R1		; Compare the index in R4 with the limit in R1
	beq		Done		; If index >= limit, go to Done
	add		#2,R4		; Increment index by 2
	bra		SumLoop		; Repeat the loop
;
; Store the result
;
Done
	movlz	#900,R5		; Load lower byte of result address into R5
	movh	#900,R5		; Load upper byte of result address into R5
	st		R2,R5		; Store the sum from R2 into the result address
;
; All done - busy wait for ^C
;
Wait
	bra		Wait
;
; Data
;
	org	#0800
;
Array
	word	#0005		; Limit value
	word	#000A		; Array element 1 (10)
	word	#0014		; Array element 2 (20)
	word	#001E		; Array element 3 (30)
	word	#0028		; Array element 4 (40)
	word	#0032		; Array element 5 (50)
;
Sum
	word	#0000		; Memory location to store the sum
;
	end	Main		; Start of program (S9 record)
