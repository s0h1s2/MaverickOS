bits 16

; glb _start : () void
section .text
	global	__start
__start:
	push	bp
	mov	bp, sp
	 sub	sp,          4
mov ax,0
mov es,ax
mov ds,ax
mov ah,0x0e
; loc     c : (@-2) : * char

section .rodata
L3:
	db	"example"
	times	1 db 0

section .text
; RPN'ized expression: "c L3 = "
; Expanded expression: "(@-2) L3 =(2) "
; Fused expression:    "=(170) *(@-2) L3 "
	mov	ax, L3
	mov	[bp-2], ax
; for
; loc     i : (@-4) : int
; RPN'ized expression: "i 0 = "
; Expanded expression: "(@-4) 0 =(2) "
; Fused expression:    "=(170) *(@-4) 0 "
	mov	ax, 0
	mov	[bp-4], ax
L4:
; RPN'ized expression: "i 7 < "
; Expanded expression: "(@-4) *(2) 7 < "
; Fused expression:    "< *(@-4) 7 IF! "
	mov	ax, [bp-4]
	cmp	ax, 7
	jge	L7
; RPN'ized expression: "i ++p "
; Expanded expression: "(@-4) ++p(2) "
; {
mov al,c[i]
int 0x10
; }
L5:
; Fused expression:    "++p(2) *(@-4) "
	mov	ax, [bp-4]
	inc	word [bp-4]
	jmp	L4
L7:
; for
L8:
; {
hlt
; }
	jmp	L8
L11:
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

; Next label number: 12
; Compilation succeeded.
