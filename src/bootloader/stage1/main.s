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
    xor ax,ax 
    mov es,ax
    mov ds,ax
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
    mul [bpb_sectors_per_fat]
    add ax,[bpb_reserved_sectors]
    ; AX contain 19 sectors.
    mov word [sectors_to_read],ax
    add word [sectors_to_read],cx
    ; 15+19=34 sectors.
    ; Load sectors into 7C00:0x0200
    mov bx,0x0200
    call read_sectors
    jmp $
read_sectors:
    push ax
    push dx
    mov dl,[bs_drive_number] ; Drive number in this case is floppy
    mov ah,0x2               ; AH contain 0x2 to read sector functionality.
    mov al,
    pop dx
    pop ax
    ret

msg db 'Stage 1',0xa,0xd,0
data_sector dw 0x0000
disk_error_msg db 'Unable to read disk',0xa,0xd,0
%include "print.s"
times 510-($-$$) db 0 ; 2 bytes less now
db 0x55
db 0xAA
