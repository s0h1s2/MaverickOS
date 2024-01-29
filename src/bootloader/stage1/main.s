[ORG 0x7c00]
jmp start
; TODO:This procedure load 2 sectors only
; TODO:I might need a file system or load more sectors for the second stage.

read_stage2_into_memory:
    ;pusha 
    ; Buffer to read.
    mov dx,0 ; Number of retries.
    mov ax,0
    mov es,ax
    mov bx,0x7e00
    ;
    mov ah,0x2
    mov al,0x2
    mov ch,0x0
    mov cl,0x2
    mov dh,0x0
    .retry:
    int 0x13
    jc .error
    jmp .end
.error:
    mov si,disk_error_msg
    call print_str
    cmp dx,0x3
    jle .retry
.end:
    ;popa
    ret
start:
    xor ax,ax 
    mov es,ax
    mov ds,ax
    mov si,msg
    call print_str
    call read_stage2_into_memory
    jmp 0x0000:0x7e00
    jmp $
    
msg db 'Stage 1 loaded',0xa,0xd,0
disk_error_msg db 'Unable to read disk',0xa,0xd,0
%include "print.s"
times 510-($-$$) db 0 ; 2 bytes less now
db 0x55
db 0xAA
