%macro enter_real_mode 0
	cli
	jmp    word 0x18:.pmode16

.pmode16:
	mov eax, cr0
	and al, ~1
	mov cr0, eax
	jmp word 0x0:.rmode

.rmode:
	[bits 16]
  mov ax,0
  mov ds,ax
  mov es,ax
  sti
%endmacro

%macro enter_protected_mode 0
	cli
	mov    eax, cr0
	or     eax, 1
	mov    cr0, eax
	jmp    0x8:.pmode

.pmode:
	[bits 32]
	mov   eax, 0x16
	mov   es, ax
	mov   ds, ax
	mov   fs, eax
	mov   gs, eax

%endmacro
