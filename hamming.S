		;		ARM Programming Assignment #4: Encode in Hamming(15, 11)
		;
		;		Write a subroutine that encodes 11 bits of data into a 15-bit
		;       block, using 4 parity bits. Assume even parity, that is,
		;       the parity of the bits covered by a parity bit, including
		;       the parity bit, has to be an even number. Assume the bits are
		;       written in the following sequence: p1, p2, d1, p4, d2, d3, d4,
		;       p8, d5, d6, d7, d8, d9, d10, d11, p16, d12, d13, d14, d15.
		;       Call the subroutine `hencode`.
		;
		;       Write a subroutine that decodes a H(15, 11) block to extract
		;       the 11 data bits. Call it `hdecode`. It should:
		;       - calculate the correcting code
		;       - dentify the case: no error (noer), one-bit error (onee)
		;       - write the result in `case` using the encoding provided
		;       - if there is a one-bit error, write the number of the
		;         erroneous bit in `berr`
		;       - if there is a one-bit error, correct the data
		;       - write the result in `corr`
		;
		;       Now, write a main function which uses `hencode` and `decode`
		;       to encode `data` and then, after a simulated transmission,
		;       decode `recv`. Assume that `recv` contains what is received
		;       at the other end.

data		dcd		0b10100100101
recv		dcd		0b101111010100101
		
noer		dcd		0x006a
onee		dcd		0x01
		
case		fill		4
berr		fill		4
corr		fill		4
		
main		adr		r0, data
		ldr		r0, [r0]
		adr		r10, link
		b		hencode
		adr		r1, data
		str		r0, [r1]
		
		adr		r0, recv
		ldr		r0, [r0]
link
		adr		r10, link2
		b		hdecode
link2
		end
		
hdecode
		mov		r1, #0b1010101
		mov		r2, #0b1010101
		bl		pcheck
		mov		r4, r3
		mov		r1, #0b00110011
		mov		r2, #0b110011
		bl		pcheck
		mov		r5, r3
		mov		r1, #0b00001111
		mov		r2, #0b1111
		bl		pcheck
		mov		r6, r3
		mov		r1, #0b11111111
		mov		r2, #0
		bl		pcheck
		mov		r7, r3
		mov		r1, #0
		tst		r4, #1
		beq		lookA
		add		r1, r1, #1
lookA
		tst		r5, #1
		beq		lookB
		add		r1, r1, #2
lookB
		tst		r6, #1
		beq		lookC
		add		r1, r1, #4
lookC
		tst		r7, #1
		beq		lookD
		add		r1, r1, #8
lookD
		adr		r3, case
		mov		r2, #1
		cmp		r1, #0
		beq		noerror
		lsl		r2, r2, #15
		lsr		r2, r2, r1
		eor		r0, r0, r2
		adr		r4, onee
		ldr		r4, [r4]
		str		r4, [r3]
		adr		r3, berr
		str		r1, [r3]
		adr		r5, corr
		str		r0, [r5]
		mov		pc, r10
		
noerror
		adr		r4, noer
		ldr		r4, [r4]
		str		r4, [r3]
		
pcheck
		add		r1, r1, r2, lsl #8
		and		r2, r0, r1
		mov		r3, #0
loop
		sub		r1, r0, #1
		ands		r0, r0, r1
		add		r2, r2, #1
		bne		loop
		moveq	pc, lr
		mov		r1, #1
		mov		pc, lr
		
hencode
		mov		r1, r0
		and		r2, r1, #0b1111111
		add		r8, r8, r2
		lsr		r1, r1, #7
		and		r2, r1, #0b111
		lsl		r2, r2, #8
		add		r8, r8, r2
		lsr		r1, r1, #3
		lsl		r1, r1, #12
		add		r8, r8, r1
		mov		r1, #0b11010101
		mov		r2, #0b110
		add		r1, r1, r2, lsl #8
		and		r2, r0, r1
		mov		r3, #0
		mov		r4, r1
		mov		r1, #0b10110011
		mov		r2, #0b101
		add		r1, r1, r2, lsl #8
		and		r2, r0, r1
		mov		r3, #0
		mov		r5, r1
		mov		r1, #0b10001111
		mov		r2, #0b011
		add		r1, r1, r2, lsl #8
		and		r2, r0, r1
		mov		r3, #0
		mov		r6, r1
		mov		r1, #0b01111111
		add		r1, r1, r2, lsl #8
		and		r2, r0, r1
		mov		r3, #0
		mov		r7, r1
		lsl		r4, r4, #14
		add		r4, r4, r5, lsl #13
		add		r4, r4, r6, lsl #11
		add		r4, r4, r7, lsl #7
		add		r8, r8, r4
		mov		r0, r8
		mov		pc, r10
