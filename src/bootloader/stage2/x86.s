bits 16
global init_sys
section .text
init_sys:
    xor ax,ax
    mov es,ax
    mov ds,ax
    mov bx,0x8000
    cli 
    mov ss,bx
    mov sp,0
    mov bp,bx
    sti
    mov si,msg
    call print_str
    jmp $



msg db "Hello",0

%include "../common/print.s"
