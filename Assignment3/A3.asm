section .data
msg: db "1.HEX TO BCD",0x0A
     db "2.BCD TO HEX",0x0A
     db "3.EXIT",0x0A
len: equ $-msg

section .bss

%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

num: resb 20
number:resb 90
sum: resb 80
result:resb 80
cnt: resb 10

section .text
global main
main:

	scall 1,1,msg,len
	scall 0,1,num,2

	mov byte[cnt],0

	cmp byte[num],31H
	je first

	cmp byte[num],32H
	je second

	cmp byte[num],33H
	je exit
	
first:	scall 0,1,number,9
	call atoh	
	call HEXTOBCD
	call main

second: scall 0,1,number,9
	mov dword[result],00
	mov rax,00
	mov rbx,00
	mov rcx,00
	mov rdx,00	
	call atoh
	call BCDTOHEX
	mov edx,dword[sum]             ; IMPORTANT
	call htoa		
	call main
	
exit:	mov rax,60
	mov rdi,0
	syscall


	
HEXTOBCD:	mov rax,0       ; NOW EAX WILL HAVE ONLY 0
		add eax,ebx       ; NOW FIRST 16 bit of EAX i.e. ax are replaced by bx so now we got dividend
		mov ebx,0x0A     ; TO DIVIDE BY 10

up2:		mov edx,0        ; EACH TIME initiallly REMAINDER WILL be ASSIGNED TO ZERO
		div ebx
		push dx         ; REMAIN DER IS PUSHED
		inc byte[cnt] 
		cmp rax,0       ; COMPARING QUOTIENT TO 0 AS IT IS STOORED IN EAX
		jne up2

up3:		pop dx
		add edx,30H
		mov word[result],dx
		scall 1,1,result,2
		dec byte[cnt]
		jnz up3

		ret

atoh: 	mov rsi,number
	mov byte[cnt],8
	mov ebx,000

up:	rol ebx,4
	mov dl,byte[rsi]
	cmp dl,39H
	jbe next
	sub dl,07H
next:	sub dl,30H
	add bl,dl
	inc rsi
	dec byte[cnt]
	jnz up
	
	ret


BCDTOHEX:	mov ecx,ebx
		mov eax,0
		mov ebx,00H
		mov bl,cl
		and bl,0FH
		
		mov eax,01H       ; 1
		mul bx
		add dword[sum],eax
		
		ror ecx,04
		mov ebx,0
		mov eax,0
		mov bl,cl
		and bl,0FH
		mov eax,0x0A     ; 10
		mul bx
		add dword[sum],eax

		ror ecx,04
		mov ebx,0
		mov eax,0
		mov bl,cl
		and bl,0FH
		mov eax,0x64     ; 100
		mul bx
		add dword[sum],eax

		ror ecx,04
		mov ebx,0
		mov eax,0
		mov bl,cl
		and bl,0FH
		mov eax,0x3E8     ; 1000
		mul bx
		add dword[sum],eax

		ror ecx,04
		mov ebx,0
		mov eax,0
		mov bl,cl
		and bl,0FH
		mov eax,0x2710    ; 10000
		mul bx
		
		add dword[sum],eax


		ret

htoa:	mov rsi,sum
	mov byte[cnt],8

upp:	rol edx,04
	mov cl,dl
	and cl,0FH
	cmp cl,09H
	jbe next2
	add cl,07H
next2:	add cl,30H
	mov byte[rsi],cl
	inc rsi
	dec byte[cnt]
	jnz upp
	
	scall 1,1,sum,8
	
	ret
	
	
