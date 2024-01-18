[ORG 0x7E00]
jmp stage2 
; Fast A20 
enable_a20:
  pusha 
  in al,0x92
  or al,0x2
  out 0x92,al
  popa
  ret
check_a20:
    pushf
    push ds
    push es
    push di
    push si
    cli
    xor ax, ax ; ax = 0
    mov es, ax
 
    not ax ; ax = 0xFFFF
    mov ds, ax
 
    mov di, 0x0500
    mov si, 0x0510
 
    mov al, byte [es:di]
    push ax
 
    mov al, byte [ds:si]
    push ax
 
    mov byte [es:di], 0x00
    mov byte [ds:si], 0xFF
 
    cmp byte [es:di], 0xFF
 
    pop ax
    mov byte [ds:si], al
 
    pop ax
    mov byte [es:di], al
 
    mov ax, 0
    je .exit
 
    mov ax, 1
 
.exit:
    pop si
    pop di
    pop es
    pop ds
    popf
    ret
stage2:
  xor ax,ax
  mov es,ax
  mov ds,ax
  mov si,msg
  call print_str
  call enable_a20
  call check_a20
  cmp ax,0x0
  je .end
  mov si,a20_on_msg 
  call print_str
.end:
  jmp $

%include "print.s"
msg db "Stage2!",0xa,0xd,0
a20_on_msg db "A20 is on",0xa,0xd,0

mem_size dw 0x0000


times 1024-($-$$) db 0 

