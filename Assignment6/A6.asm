;Write X86/64 ALP to switch from real mode to protected mode and display the values of GDTR, LDTR, IDTR, TR and MSW
;Registers.

section .data
 
 msg1:db 'GDTR :',0xa
 len1:equ $-msg1

 msg2:db 'LDTR :',0xa
 len2:equ $-msg2

 msg3:db 'IDTR  :',0xa
 len3:equ $-msg3

 msg4:db 'TR :',0xa
 len4:equ $-msg4

 msg5:db 'MSW :',0xa
 len5:equ $-msg5

 msg6:db 'protected mode',0xa
 len6:equ $-msg6

 msg7:db ' ',0xa
 len7:equ $-msg7

 msg8:db ' real  mode.!!',0xa
 len8:equ $-msg8

 msg9:db ' : ',0xa
 len9:equ $-msg9

section .bss

 gdt:resd 01
     resw 01
 ldt:resw 01
 idt: resd 01
      resw 01
 tr:resw 01
 msw:resd 01

 result: resw 01
 
  %macro display 2
       mov rax,01
       mov rdi,01
       mov rsi,%1
       mov rdx,%2
       syscall
    %endmacro	
section .text

 global _start
 _start:

 smsw [msw]
 sgdt [gdt]
 sldt [ldt]
 sidt [idt]
 str [tr]

 
mov ax,[msw]
bt ax,0
jc next
 display msg8,len8
jmp exit

next:
 display msg6,len6

;GDTR

 display msg1,len1
 
mov bx,word[gdt+4]
call HtoA
mov bx,word[gdt+2]
call HtoA

 display msg9,len9

mov bx,word[gdt]
call HtoA



;LDTR

 display msg7,len7
 display msg2,len2
 mov bx,word[ldt]
call HtoA


;IDTR

 display msg7,len7

 display msg3,len3
 
mov bx,word[idt+4]
call HtoA
mov bx,word[idt+2]
call HtoA

 display msg9,len9
mov bx,word[idt]
call HtoA

;TR

 display msg7,len7
 display msg4,len4
mov bx,word[tr]
call HtoA

;MSW

 display msg7,len7
 syscall

 display msg5,len5

mov bx,word[msw]
call HtoA

;EXIT
	exit:
 		mov rax,60
 		mov rdi,0 
 		syscall

HtoA:

 mov rcx,4
 mov rdi,result
 dup1:
 rol bx,4
 mov al,bl
 and al,0fh
 cmp al,09h
 jg p3
 add al,30h
 jmp p4
 p3: add al,37h
 p4:mov [rdi],al
 inc rdi
 loop dup1
       
        mov rax,1
 	mov rdi,1
 	mov rsi,result
 	mov rdx,4
 	syscall

 
ret
