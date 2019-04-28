			;		ARM Programming Assignment #4: Count the ones in a binary number
			;
			;		Write a program that counts the number of ones in a binary number,
			;		stored in a word (4 bytes). Its loop should run no more times than there
			;		are ones in the number. Write the count in `numones`. For the example
			;		number given below, the loop should only run 8 times, counting 8 ones.
			;
			;		Hint:
			;		The first significant instruction in the loop is SUB r1, r1, 1, which
			;		decrements the number, assuming it's stored in register r1. Now,
			;		remember your logical operations.
			;
			;		Bonus:
			;		1. (20 extra points) For the shortest program (by instruction count),
			;		because this operation has to be FAST.
			;		2. (30 extra points) For extending the program to counting the ones
			;		in any word-aligned continuous region of memory.
			
			;		Your code here
			
example		DCD		0x0010070f
numones		FILL		4
			;working code with help from Devin.
		adr		r0, example
		ldr		r0, [r0]
		bl		loop
		adr		r1, numones
		str		r2, [r1]
		end
		
loop		sub		r1, r0, #1
		ands		r0, r0, r1
		add		r2, r2, #1
		bne		loop
		mov		pc, lr	
			
			;non-working attempt (Stops loop to early because of Z flag. Also, if working, the loop would run as many times as there are zeros and ones in the number)
			adr		r0, example
			ldr		r2, [r0]
			bl		count_loop
			adr		r4, numones
			str		r1, [r4]
			end
			
count_loop
			LSR		r6, r2, r3
			TST		r6, #1    ;is R6 odd?
			ADDNE	r1, r1, #1
			add		r3, r3, #1
			bne		count_loop
			mov		pc, lr
