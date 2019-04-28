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
			
example		DCD		0x0010070f
numones		FILL		4
			
			adr		r0, example
			ldr		r0, [r0]
			bl		count_loop
			adr		r1, numones
			str		r0, [r1]
			end
			
			MOV		r1, #0                ;(initialize R1 and R6 to zero)
			MOV		r6, #0
count_loop	AND		r6, r6, r2, LSR #1    ;(Right shift by 1, right most bit is in carry flag)
			ADDCS	r1, r1, #1                ;(Add #1 to R1 if carry  flag is set)
			CMP		r2, #0                  ;(update the status flags if R2 == 0 or not)
			BEQ		count_loop                     ;(branch back to xx until R2==0)
