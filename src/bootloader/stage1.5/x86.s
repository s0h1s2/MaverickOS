%macro enter_real_mode 0
  [bits 32]
	cli
	jmp    word 0x18:.pmode16 ; 16-bit code segment in GDT table.
 
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
	jmp    0x8:.pmode ; 32-bit code segment in GDT table.

.pmode:
	[bits 32]
	mov   eax, 0x16   ; setup 32-bit data segment in GDT table.
	mov   es, ax
	mov   ds, ax
	mov   fs, eax
	mov   gs, eax

%endmacro

