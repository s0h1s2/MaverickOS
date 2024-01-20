bits 16

; glb _start : () void
section .text
	global	__start
__start:
	push	bp
	mov	bp, sp
	;sub	sp,          0
mov ax,0
mov es,ax
mov ds,ax
mov ah,0x0e
mov al,97
int 0x10
; for
L3:
; {
hlt
; }
	jmp	L3
L6:
L1:
	leave
	ret



; Syntax/declaration table/stack:
; Bytes used: 75/15360


; Macro table:
; Macro __SMALLER_C__ = `0x0100`
; Macro __SMALLER_C_16__ = ``
; Macro __SMALLER_C_SCHAR__ = ``
; Macro __SMALLER_C_UWCHAR__ = ``
; Macro __SMALLER_C_WCHAR16__ = ``
; Bytes used: 110/5120


; Identifier table:
; Ident 
; Ident __floatsisf
; Ident __floatunsisf
; Ident __fixsfsi
; Ident __fixunssfsi
; Ident __addsf3
; Ident __subsf3
; Ident __negsf2
; Ident __mulsf3
; Ident __divsf3
; Ident __lesf2
; Ident __gesf2
; Ident _start
; Bytes used: 131/5632

; Next label number: 7
; Compilation succeeded.
