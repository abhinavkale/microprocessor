;Write X86 menus driven Assembly Language Program (ALP) to implement OS (DOS) commands TYPE, COPY and DELETE
;using file operations. User is supposed to provide command line arguments in all cases.

%macro print 2
mov rax,01
mov rdi,01
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro read 2
mov rax,00
mov rdi,00
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .data
title : db "Copy",10
	db "Type",10
	db "Delete",10
	db "Exit",10
title_len : equ $-title

openmsg : db "File opened successfully",10
openmsg_len : equ $-openmsg
errormsg : db "File not opened",10
errormsg_len : equ $-errormsg
closemsg : db "File closed",10
closemsg_len : equ $-closemsg
typemsg : db "Contents : ",10
typemsg_len : equ $-typemsg
delmsg : db "File deleted",10
delmsg_len : equ $-delmsg

section .bss
	buffer : resb 200
	bufferlen : resb 8
	cnt1 : resb 8
	fd_in : resb 8
	input : resb 2
	f1name : resb 20
	f2name : resb 20


section .text
global _start

	_start:
		pop rbx
		pop rbx
		pop rbx

		mov [f1name],rbx
		;print title,title_len
		;read input,2

		cmp byte[rbx],'C'
		je copy

		cmp byte[rbx],'T'
		je type

		cmp byte[rbx],'D'
		je delete

		cmp byte[rbx],'E'
		je exit

	type:
		mov rax,2
		mov rdi,rbx
		mov rsi,2
		mov rdx,0777
		syscall
		
		mov qword[fd_in],rax

		bt rax,63
		jc next
		print openmsg,openmsg_len
		jmp next1

		next:
		print errormsg,errormsg_len
		jmp exit

		next1:
			mov rax,0
			mov rdi,[fd_in]
			mov rsi,buffer
			mov rdx,200
			syscall

			mov qword[bufferlen],rax
			mov qword[cnt1],rax
			print typemsg,typemsg_len
			print buffer,qword[bufferlen]
		
			mov rax,3
			mov rdi,rbx
			syscall
			print closemsg,closemsg_len
			jmp exit

	copy:
		mov rax,2
		mov rdi,rbx
		mov rsi,2
		mov rdx,0777
		syscall
		
		mov qword[fd_in],rax

		bt rax,63
		jc cnext
		print openmsg,openmsg_len
		jmp cnext1

		cnext:
		print errormsg,errormsg_len
		jmp exit

		cnext1:
			mov rax,0
			mov rdi,[fd_in]
			mov rsi,buffer
			mov rdx,200
			syscall

			mov qword[bufferlen],rax
			mov qword[cnt1],rax

			mov rax,3 ;close first file
			mov rdi,rbx
			syscall
			print closemsg,closemsg_len

			;Second File	
			pop rbx
			mov [f2name],rbx

			mov rax,2
			mov rdi,rbx
			mov rsi,2
			mov rdx,0777
			syscall
			
			bt rax,63
			jc next3
			mov qword[fd_in],rax

		


	delete:
		mov rax,87
		mov rdi,[fd_in]
		syscall
		print closemsg,closemsg_len
		jmp exit
		
exit:
	mov rax,60
	mov rdi,0
	syscall
