extern printf

section .data
        array dd 1.00,2.00,3.00,4.00,5.00
        cnt db 4
        num dq 5
        mean dq 0
        variance dq 0
        sd dq 0
        hundred: dq 100
        sum dd 0
        newline db 10
        format : db "%lf",10,0
        
dot : db "."
lendot: equ $-dot
        
section .bss
        ans: resb 2
        var1: resb 1
        buffer: resb 10
        cnt1: resb 1
        temp resd 1
 
%macro print 2				
	mov rax, 1
	mov rdi, 1
	mov rsi, %1
	mov rdx, %2
        syscall
%endmacro

section .text
global main

        
main:
        mov r15,array
        finit
        fld dword[r15]
        mov cl,4
        
        loop:
                add r15,4
                fadd dword[r15]
                dec cl
                jnz loop 
        
        fidiv word[num]
        fst qword[mean]
     
        xor rax,rax
        xor rsi,rsi
        xor rcx,rcx
    
        mov rdi,format
        mov rax,2
        sub rsp,8
        movsd xmm0,[mean]
        call printf
        add rsp,8


        ;call display
        
        print newline,1
        
variance_calculation:
          MOV r15,array
          mov cl,5
          
          loop5:
                fld dword[r15]
                fsub qword[mean]
                fst dword[temp]
                fmul dword[temp]
                fadd dword[sum]
                fstp dword[sum]
                add r15,4
                dec cl
                jnz loop5
                
                
        fld dword[sum]        
        fidiv word[num]
        fst qword[variance]
        
        xor rax,rax
        xor rsi,rsi
        xor rcx,rcx
     
        mov rdi,format
        mov rax,2
        sub rsp,8
        movsd xmm0,[variance]
        call printf
        add rsp,8

        ;call display
        print newline,1
         
standard_deviation:
        fld qword[variance]
        fsqrt
        fst qword[sd]

        mov rdi,format
        mov rax,2
        sub rsp,8
        movsd xmm0,[sd]
        call printf
        add rsp,8
        ;call display
               
       

exit:
mov rax,60
mov rdi,0
syscall
        

	     
