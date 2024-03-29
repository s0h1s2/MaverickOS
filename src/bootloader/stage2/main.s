extern  boot_main
[bits   16]
section .boot

init_system:
	cli
	;mov ax, 0x7e00
	xor  ax, ax
	mov  ds, ax
	mov  es, ax
	mov  ax, 0x8000
	mov  ss, ax
	sti
	mov  si, msg
	call print_str
	call enable_a20
	cli
	lgdt [toc]
	mov  eax, cr0
	or   eax, 1
	mov  cr0, eax
	jmp  0x8:protected_mode
	jmp $

print_str:
	pusha
	mov ah, 0x0e

.char_loop:
	lodsb ; mov al, [si]
	cmp   al, 0
	je    .end
	int   0x10
	jmp   .char_loop

.end:
	popa
	ret

enable_a20:
	push ax
	in   al, 0x92
	or   al, 2
	out  0x92, al
	pop  ax
	ret

[bits 32]

protected_mode:
	mov  eax, 0x10; Data segment
	mov  ds, eax
	mov  es, eax
	mov  ss, eax
	mov  fs, eax
	mov  gs, eax
	call boot_main
	jmp  $

section .data:

msg:
	db "Hello,Stage2", 0

%include "gdt.s.inc"
