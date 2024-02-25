gdt_start:
	;; null descriptor
	dd 0
	dd 0

	;; 32-bit code descriptor
	dw 0xFFFFF; Base limit
	dw 0
	db 0
	db 10011010b; access
	db 11001111b; granularity
	db 0

	;; 32-bit data descriptor
	dw 0xFFFFF
	dw 0x0
	db 0
	db 10010010b
	db 11001111b
	db 0

	;; 16-bit code descriptor
	dw 0xFFFF; limit (bits 0-15) = 0xFFFFF
	dw 0; base (bits 0-15) = 0x0
	db 0; base (bits 16-23)
	db 10011010b; access (present, ring 0, code segment, executable, direction 0, readable)
	db 00001111b; granularity (1b pages, 16-bit pmode) + limit (bits 16-19)
	db 0; base high

	;; 16-bit data descriptor
	dw 0xFFFF; limit (bits 0-15) = 0xFFFFF
	dw 0; base (bits 0-15) = 0x0
	db 0; base (bits 16-23)
	db 10010010b; access (present, ring 0, data segment, executable, direction 0, writable)
	db 00001111b; granularity (1b pages, 16-bit pmode) + limit (bits 16-19)
	db 0; base high

gdt_end:
toc:
	;; Table of content
	dw gdt_end-gdt_start-1; GDT table size in this case is 3*8=24-1 bytes.
	dd gdt_start; 4 byte pointer.
