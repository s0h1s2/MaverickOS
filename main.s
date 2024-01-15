[ORG 0x7c00]
start:
    cld
    mov si,msg
    call print_str
    mov dx,print_str
    call print_hex
    jmp $
    
msg db 'Hello,Bootsector',0xa,0xd,0
%include "print.s"
times 510-($-$$) db 0 ; 2 bytes less now
db 0x55
db 0xAA
