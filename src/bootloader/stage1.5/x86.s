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
%macro enter_protected_mode 0
	cli
	mov    eax, cr0
	or     eax, 1
	mov    cr0, eax

	jmp    0x8:.pmode ; 32-bit code segment in GDT table.

.pmode:
  [bits 32]
	mov  eax, 0x10; Data segment
	mov  ds, eax
	mov  es, eax
	mov  ss, eax
	mov  fs, eax
	mov  gs, eax
	
%endmacro

clear_screen:
	push ebp
	mov ebp,esp

	enter_real_mode
	mov ah,0xE
	mov al,'A'
	int 0x10
	enter_protected_mode

	mov esp,ebp
	pop ebp
	ret

section .data
idt_real:
	dw 0x3ff
	dd 0
