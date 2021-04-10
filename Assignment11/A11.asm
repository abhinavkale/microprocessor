;Write 80387 ALP to obtain: i) Mean ii) Variance iii) Standard Deviation Also plot the histogram for the data set. The data
;elements are available in a text file.

%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

Section .data
	arr1 dd 1.00,2.00,4.00,2.00,3.00
	n: db 05h
	hdec: dw 0100
	cnt db 00
	counter db 5h
	counter1 db 9h
	dot db "."
	len: equ $-dot
	
	newline: db 0x0A
	newmsg: equ $-newline

Section .bss
	mean resd 4
	var resd 4
	sd resd 4
	buffer rest 10
	sum resb 2

Section .text

global _start:

_start:
	FINIT

;MEAN:
	
	FLDZ
	mov rsi,arr1
	loop1:
		fadd dword[rsi]
		add rsi,4
		dec byte[counter]
		jnz loop1

	FIDIV dword[n]
	FST dword[mean]
	call display
	print newline, newmsg


;VARIANCE:
	mov rsi,arr1
	mov byte[counter],5
	FLDZ
up1:
	FLDZ
	FLD dword[rsi]
	FSUB dword[mean]
	FMUL ST0
	FADD
		add rsi,4
		dec byte[counter]
		jnz up1
	
	FIDIV dword[n]
	FST dword[var]
	call display
	print newline, newmsg


;SD
	FLDZ
	FLD dword[var]
	FSQRT
	FST dword[sd]
	call display
	print newline, newmsg
		
		
exit:
	mov rax,60
	mov rdi,0
	syscall

display:
	FIMUL word[hdec]
	FBSTP tword[buffer]

	mov byte[counter],9
	mov rsi,buffer+9
	
	loop2:
		mov bl,byte[rsi]
		push rsi

		call htoa
		pop rsi
		dec rsi
		dec byte[counter]
		jnz loop2
	
	print dot,len
	mov rsi,buffer
	mov bl,byte[rsi]
	call htoa	
	ret



htoa:	mov rsi,sum
	mov byte[cnt],2

upp:	rol bl,04
	mov cl,bl
	and cl,0FH
	cmp cl,09H
	jbe next2
	add cl,07H
next2:	add cl,30H
	mov byte[rsi],cl
	inc rsi
	dec byte[cnt]
	jnz upp
	

	print sum,2
	
	ret

	
	
