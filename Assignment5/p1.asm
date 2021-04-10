section .data
	msg0 : db "1. No. of Spaces",10
		   db "2. No. of lines",10
		   db "3. No. of occurences of a particular character",10
		   db "4. Exit",10
	len0 : equ $-msg0
	msg1 : db "Enter character : ",10
	len1 : equ $-msg1
	msg2 : db "File opened successfully",10
	len2 : equ $-msg2
	msg3 : db "Unable to open file",10
	len3 : equ $-msg4
	msg4 : db "Character to be checked : ",10
	len4 : equ $-msg4
	fname : db 'abc.txt'


section .bss
	global buffer
	buffer : resb 200
	opt : resb 2
	fd_in : resb 9
	choice : resb 2
	global char
	char : resb 1

%macro print 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

%macro read 2
	mov rax,0
	mov rdi,0
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro


section .text
global _start
	
	_start:
		mov rax,2
		mov rdi,fname
		mov rsi,0
		mov rdx,0777
		syscall

		mov qword[fd_in],rax
		bt qword[fd_in],63
		jc next
		print msg2,len2
		jmp next1
		next : print msg3,len3

		next1:
			mov rax,0
			mov rdi,[fd_in]
			mov rsi,buffer
			mov rdx,200
			syscall

		extern count

		menu:
			print msg0,len0
			read choice,2

			cmp byte[choice],31H
			je case_1

			cmp byte[choice],32H
			je case_2

			cmp byte[choice],33H
			je case_3

			cmp byte[choice],34H
			je case_4


			case_1:
				extern no_space
				call no_space
				print count,1
				jmp menu

			case_2:
				extern no_line
				call no_line
				print count,1
				jmp menu

			case_3:
				print msg4,len4
				read char,2
				extern no_char
				call no_char
				print count,1
				jmp menu

			case_4:
				mov rax,60
				mov rdi,0
				syscall

