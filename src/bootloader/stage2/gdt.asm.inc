section .data
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
	dw 0x0
	db 10010010b
	db 11001111b
	db 0
gdt_end:
toc: ;; Table of content
	dw gdt_end-gdt_start-1 ; GDT table size in this case is 3*8=24-1 bytes.
	dd gdt_start 					 ; 4 byte pointer.

