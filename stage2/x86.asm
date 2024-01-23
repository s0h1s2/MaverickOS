bits 16
extern bootloader_main
%include "../print.s"

section _DATA class=STACK
section _TEXT class=CODE
  global init_sys
  global _putc

init_sys:
    mov ax,0x7E00
    mov es,ax
    mov ds,ax
    mov bx,0x8000
    cli 
    mov ss,bx
    mov sp,ax
    sti
    call bootloader_main
    jmp $

_putc:
  push ax
  mov bp,sp
  mov ah,0x0e
  mov al,[bp+4]
  int 0x10
  pop ax
  ret

