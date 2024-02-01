[ORG 0x7c00]
jmp start
nop
;-----------------------
; Bios Parameter Block(BPB)
;-----------------------
;==================================
; Layout of Disk/floppy of fat 12 file system
;==================================
;==================================
; Boot | Reserved Sectors | FAT Table 1 |FAT Table etc... | Root Entries | Data sectors.
; ^
; |
; |---> This file in the disk.
;==================================

bpb_bytes_per_sector:  	    dw 512
bpb_sectors_per_cluster: 	db 1
bpb_reserved_sectors: 	    dw 1
bpb_number_of_fats: 	    db 2
bpb_root_entries: 	        dw 224
bpb_total_sectors: 	        dw 2880
bpb_media: 	                db 0xf0
bpb_sectors_per_fat: 	    dw 9
bpb_sectors_per_track: 	    dw 18
bpb_heads_per_cylinder:     dw 2
bpb_hidden_sectors: 	    dd 0
bpb_total_sectors_big:      dd 0
bs_drive_number: 	        db 0
bs_unused: 	                db 0
bs_ext_boot_signature: 	    db 0x29
bs_serial_number:	        dd 0xa0a1a2a3
bs_volume_label: 	        db "Mavrick    "
bs_file_system: 	        db "fat12   "

start:
    cli 
    xor ax,ax 
    mov es,ax
    mov ds,ax
    sti
    mov si,msg
    call print_str
    xor dx,dx
    xor cx,cx
    ; Each entry for root directory entry is 32 bytes=0x20
    mov ax,0x20
    ; Calculate sectors to read, 32 bytes * 224 entries / 512=15 sectors.
    mul word [bpb_root_entries]
    div word [bpb_bytes_per_sector]
        
    xchg ax,cx ; Swap the values of ax with cx. We need ax for more calculation.

    ; Calculate the offset to reach the start of root entries sector.
    ; 9 sectors * 2 fats + 1 reserved=19 sectors.
    mov al,[bpb_number_of_fats]
    mul WORD [bpb_sectors_per_fat]
    add ax,[bpb_reserved_sectors]
    ; AX contain 19 sectors.
    mov word [data_sector],ax
    add word [data_sector],cx
    ; 15+19=34 sectors.
    ; Load sectors into 7C00:0x0200
    mov bx,0x0200
    call read_sectors
    jmp $

; TODO: handling errors might be a good idea.
;=====================
; CX contain number of sectors to read.
; AX is offset sector.
; ES:BX are Buffer to write into memory.
;=====================
read_sectors:
.main:
    push ax
    push bx
    push cx
    call lbachs
    mov ah,0x02 ; BIOS function to read sector into memory
    mov al,0x1  ; Read one sector at a time.
    mov ch,[absolute_track]
    mov cl,[absolute_sector]
    mov dh,[absolute_head]
    mov dl,[bs_drive_number] ; Drive number in this case it is a floppy.
    int 0x13
.success:
    pop cx
    pop bx
    pop ax
    add bx,WORD [bpb_bytes_per_sector]
    inc ax
    loop .main ; Dec cx by 1
    ret
;==============
; AX is argument for lba value
;==============
lbachs:
    push dx
    xor dx,dx
    div WORD [bpb_sectors_per_track]
    inc dl
    mov BYTE [absolute_sector],dl
    xor dx,dx
    div WORD [bpb_heads_per_cylinder]
    mov BYTE [absolute_head],dl
    mov BYTE [absolute_track],dl
    pop dx
    ret


; Variables And Messages.
msg db 'Stage 1',0xa,0xd,0
data_sector         dw 0x0000
absolute_sector     db 0x00
absolute_head       db 0x00
absolute_track      db 0x00

disk_error_msg db 'Unable to read disk',0xa,0xd,0
%include "print.s"
times 510-($-$$) db 0 ; 2 bytes less now
db 0x55
db 0xAA
