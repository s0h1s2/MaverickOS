%define CLRF 0xA,0xD
%define DEBUG 1
; Future idea:
; I think i can assign values to macros then use them in BPB below.
; %define x 512
; bytes_per_sector x ; Now it's 512 :)
; We may be able calculate root dir offsets and data sector offsets as well without using proccessor :).
%macro calculate_fat 0
    xor ax,ax
    mov al,[FAT_count] 
    mul word [sectors_per_FAT]
    add ax,[reserve_count]
%endmacro

; just for sake of reading.
%define ROOT_SEGMENT        0x0500
%define ROOT_OFFSET         0x0000

%define FAT_SEGMENT         0x0500
%define FAT_OFFSET          0x0000

%define STAGE2_LOAD_SEGMENT 0x7e00
%define STAGE2_LOAD_OFFSET  0x0000


[BITS 16]
[ORG 0]

jmp short start
nop
;==================================
; Bootcode | Reserved Sectors | Fat 1 | Fat etc.. | Root dir | Data
;   ^
;   |
;   | 
;   ------------> This file.
;==================================
bpb_OEM               db "MSWIN4.1"       ; OEM id. 8 bytes in size, basically a version string
bpb_bytes_per_sector  dw 512              ; bytes making up each sector, 2 bytes
bpb_secs_per_cluster  db 1                ; sectors per cluster, 1 byte
bpb_reserve_sector    dw 1                ; reserved sectors before first FAT, 2 bytes
bpb_fat_count         db 2                ; number of FATs appearing on media
bpb_dir_entries       dw 224              ; directory entries max (root dir), 2 bytes
bpb_total_sectors     dw 2880             ; Total sectors in file system (1.44MB Floppy)
bpb_media_descriptor  db 0xF8             ; Media descriptor, 1 byte. F0 for 1.44M
bpb_sectors_per_fat   dw 9                ; Sectors per FAT, 2 bytes
bpb_sectors_per_track dw 18               ; Sectors per track, 2 bytes.
bpb_head_count        dw 2                ; Number of drive heads (On a double sided diskette, there are 2 :))
bpb_hidden_sectors    dd 0                ; Hidden sectors before FAT. should be zero on an unpartitioned media
; In larger file systems, there would be a double word field here defining the 
; total number of sectors. since we don't need this, we'll just pad it out
; so that we can write an Extended BPB below
                      dd 0
drive_number          db 0x80                ; Physical drive number, 0 is removable. 80h for hdd
dirty_bit             db 1                ; WinNT uses this field to check if the fs is clean
extboot_sig           db 0x29             ; This lets us know the EBPB exists
volume_id             dd 77               ; Serial number for the volume
volume_label          db "durOS     ",0    ; Volume label. pad out to 11 bytes with spaces
fs_type               db "FAT12   "       ; File system type, pad with blanks to 8 bytes

    

start:
    cli
    mov ax,0x7c0
    mov ds,ax
    mov es,ax
    mov ax, 0x7000
    mov ss, ax
    mov sp, 0xFFFF
    sti
    ; Check extension present
    xor ax,ax
    mov ah,0x41
    mov dl,[drive_number]
    mov bx,0x55AA
    int 0x13
    jc fl_not_support
    ; Calculate sectors to get fat12 root dir.
    mov ax,word [bpb_sectors_per_fat]
    mul byte [bpb_fat_count]
    add ax,[bpb_reserve_sector] ; AX contain the start of root dir.
    mov cx,ax
    ; Calculate total sectors to read for root dir.
    mov ax,32
    mul word [bpb_dir_entries]
    div word [bpb_bytes_per_sector]
    ; Store data region start offset.
    mov word [data_region_start],cx
    add word [data_region_start],ax

.load_root:
    mov word [disk_packet.sector_to_read],ax
    mov word [disk_packet.lower_lba],cx
    mov word [disk_packet.offset],ROOT_OFFSET
    mov word [disk_packet.segment],ROOT_SEGMENT
    call read_disk 
.search_for_stage2:
    mov ax,ROOT_SEGMENT
    mov es,ax
    mov di,ROOT_OFFSET
    mov cx,word [bpb_dir_entries]
    .search_loop:
        push cx
        push di
        mov cx,11           ; 11 Bytes for file name and extension(extension is 3 bytes). 
        mov si,stage2_name
        rep cmpsb
        pop di
        je .load_fat       ; We found it yay :).
        pop cx
        add di,32
        loop .search_loop
    jmp stage2_not_found
.load_fat:
   xor dx,dx
   mov dx,[es:di+26]
   call print_hex
.load_cluster:
.jump_stage2:
    ;jmp STAGE2_LOAD_SEGMENT:STAGE2_LOAD_OFFSET
    jmp end

read_disk:
   push ax
   push dx
   mov ah,0x42
   mov si,disk_packet
   mov dl,[drive_number]
   int 0x13
   jc cant_read_disk
   pop dx
   pop ax
   ret

stage2_not_found:
    mov si,floppy_not_supported_msg
    call print_str
    jmp end
fl_not_support:
    mov si,floppy_not_supported_msg
    call print_str
    jmp end
cant_read_disk:
    mov si,unable_to_read_disk_msg
    call print_str
    jmp end
end:
    jmp $



data_region_start: dw 0x0000
stage2_name: db "STAGE2  BIN" ; Spaces are important; 11 bytes name:|8 bytes|,extension:|3 bytes|

disk_packet:
    .size db 0x10
    .unused db 0
    .sector_to_read dw 0x0000
    .offset dw 0x0000
    .segment dw 0x0000
    .lower_lba dd 0x0
    .higher_lba dd 0x0

cluster: dw 0x0000
floppy_not_supported_msg: db "fail",CLRF,0
unable_to_read_disk_msg: db "fail",CLRF,0
%include "print.s"
times 510-($-$$) db 0
db 0x55
db 0xAA

