section .data

section .bss
	global count
	count : resb 1

section .text
	
	extern buffer

	global no_space
	no_space:
		mov rsi,buffer
		mov byte[count],00H

		loop_space:	
			cmp byte[rsi],20H
			jne down
			inc byte[count]
			down : inc rsi
			cmp byte[rsi],00H
			jne loop_space

		cmp byte[count],09H
		jbe down1
		add byte[count],07H
		down1 : add byte[count],30H

	ret


	global no_line
	no_line:
		mov rsi,buffer
		mov byte[count],00H

		loop_line:
			cmp byte[rsi],0AH
			jne down2
			inc byte[count]
			down2 : inc rsi
			cmp byte[rsi],00H
			jne loop_line

		cmp	byte[count],09H
		jbe down3
		add byte[count],07H
		down3 : add byte[count],30H

	ret

	global no_char
	no_char:
		extern char
		mov r8b,byte[char]
		mov rsi,buffer
		mov byte[count],00H

		loop_char:
			cmp byte[rsi],r8b
			jne down4
			inc byte[count]
			down4 : inc rsi
			cmp byte[rsi],00H
			jne loop_char

		cmp byte[count],09H
		jbe down5
		add byte[count],07H
		down5 : add byte[count],30H

	ret
