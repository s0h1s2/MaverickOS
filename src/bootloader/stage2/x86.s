bits 16

extern bmain

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
    call enable_a20
check_a20_gate:
    call check_a20
    cmp ax,1
    jne end
    call install_gdt
    mov eax,cr0
    or eax,1
    mov cr0,eax
    jmp 0x8:protected_mode

end:
    jmp $
;===========================================================
; Check if A20 gate enabled by checking memory wrap around.
; By testing whether they refer to same position.
; When ax=1 A20 gate is enabled
; When ax=0 A20 gate is disabled
;===========================================================
check_a20:
    pushf 
    push ds
    push es
    push di
    push si

    cli

    xor ax,ax ; ax=0x0000
    mov es,ax

    not ax ; ax=0xFFFF
    mov ds,ax

    mov di,0x0500 ; [ES:DI]
    mov si,0x0510 ; [DS:SI]

    mov al,byte [es:di]
    push ax
    mov al,byte [ds:si]
    push ax
    
    mov byte [es:di],0x00
    mov byte [ds:si],0xFF

    cmp byte [es:di],0xFF

    pop ax
    mov [ds:si],al

    pop ax
    mov [es:di],al
    
    mov ax,0
    je .exit
    mov ax,1

.exit:
    pop si
    pop di
    pop es
    pop ds
    popf 
    ret

;Fast a20 gate method.
enable_a20:
   push ax
   in al,0x92
   or al,2
   out 0x92,al
   pop ax
   ret

install_gdt:
    pusha
    cli
    lgdt [toc]
    popa
    ret

[bits 32]
protected_mode:
    mov ax,0x10 ; 0x10 becuase of data semgment in GDT is second entry
    mov ds,ax
    mov es,ax
    mov ss,ax
    mov esp,0x9000
    call bmain
    jmp $

section .data
msg db "Stage 2 Loaded",0xA,0xD,0
a20_enabled_msg db "A20 enabled",0xA,0xD,0
gdt_start:
;; null descriptor
	dd 0
	dd 0
;; code descriptor
	dw 0xFFFF ;Base limit 
	dw 0
	db 0
	db 10011010b 			; access
	db 11001111b 			; granularity
	db 0

;; data descriptor
	dw 0xFFFF
	dw 0x0
	db 0
	db 10010010b
	db 11001111b
	db 0
gdt_end:
toc: ;; Table of content
	dw gdt_end-gdt_start-1 ; GDT table size in this case is 3*8=24-1 bytes.
	dd gdt_start 					 ; 4 byte pointer.

%include "../common/print.s"
;%include "gdt.asm.inc"
