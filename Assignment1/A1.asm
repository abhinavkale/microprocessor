;Write X86/64 ALP to count number of positive and negative
;numbers from the array.
section .data
	array db 12H,0xA2,93H,10H,11H
	cnt db 05
	cntp db 0
	cntn db 0
section .text
	global _start
_start:
	mov rsi,array
	;mov byte[cntp],00
	;mov byte[cntn],00
	n3:
	mov al,byte[rsi]
	add al,00h
	js n1
	inc byte[cntp]
	jmp n2
	n1: 
	inc byte[cntn]
	n2: 
	inc rsi
	dec byte[cnt]
	jnz n3
	
	
	add byte[cntp],30h
	add byte[cntn],30h
	
	
	mov rax,01
	mov rdi,01
	mov rsi,cntp
	mov rdx,1
	syscall
	
	mov rax,01
	mov rdi,01
	mov rsi,cntn
	mov rdx,1
	syscall
	
	mov rax,60
	mov rdi,00
	syscall
