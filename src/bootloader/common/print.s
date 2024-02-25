section .text
print_str:
  pusha
  
  mov ah,0x0e
.char_loop:
   lodsb ; mov al,[si]
   cmp al,0
   je .end
   int 0x10
   jmp .char_loop
.end:
   popa
   ret
;; 'DX' Register is the argument for this procedure.
;;  HEX_OUT: 0x0000
;;  Want to print:0x1234
;;  
print_hex:
  pusha       ;; Push all register content into stack.
  mov cx,4    ;; Start from right to left in output and use cx as index
  mov bx,HEX_OUT+6 ;; 'BX' is array of chars. 'HEX_OUT' address start+6 more bytes(skip '0x').
.hex_loop:
  dec cx      ;; Decremnt index
  mov ax,dx   ;; Create a copy of dx content
  shr dx,4    ;; Shift right dx by 4 bits(nibble)
  and ax,0xf  ;; 
  dec bx      ;; Decrement bx pointer by 1
  cmp ax,0xa  ;; If ax<'9'
  jl .set_letter 
  add al,0x27 ;; other wise add 0x27 to reach alphabet letters in ascii.Then set_letters
.set_letter:
  add al,0x30
  mov byte [bx],al ;; Derefernce 'BX' and put al content into 'BH(BX,BH)' --> char c='';char *d=&c;*d='1'
  cmp cx,0
  jne .hex_loop
.end:
  mov si,HEX_OUT
  call print_str
  popa
  ret

HEX_OUT db '0x0000',0

