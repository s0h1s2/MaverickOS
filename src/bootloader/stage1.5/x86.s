GLOBAL clear_screen

section .text
%macro enter_real_mode 0
	cli
	mov eax,0x20

	mov ds,eax
	mov es,eax
	mov ss,eax
	mov fs,eax
	mov gs,eax

	jmp 0x18:.prmode
.prmode:
	[bits 32]
	mov eax, cr0
	mov eax,0
	mov cr0, eax

	jmp 0:.rmode

.rmode:
	[bits 16]
	mov ax,0
	mov ds,ax
	mov es,ax
	mov ss,ax
	mov sp,0x8000
	lidt [idt_real]
	sti
%endmacro
; %macro enter_protected_mode 0
; 	cli
; 	mov    eax, cr0
; 	or     eax, 1
; 	mov    cr0, eax
;
; 	jmp    0x8:.pmode ; 32-bit code segment in GDT table.
;
; .pmode:
; 	[bits 32]
; 	mov   eax, 0x16   ; setup 32-bit data segment in GDT table.
; 	mov   es, eax
; 	mov   ds, eax
; 	mov   ss, eax
; 	mov   fs, eax
; 	mov   gs, eax
;
; %endmacro

clear_screen:
	enter_real_mode
	mov ah,0x0
	mov al,0x0
	int 0x10
	;enter_protected_mode
	jmp $;
	;ret

section .data
idt_real:
	dw 0x3ff
	dd 0
