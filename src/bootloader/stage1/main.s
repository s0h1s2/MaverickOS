; Future idea:
; I think i can assign values to macros then use them in BPB below.
; %define x 512
; bytes_per_sector x ; Now it's 512 :)
; We may be able calculate root dir offsets and data sector offsets as well without using proccessor :).

[BITS 16]
[ORG 0]

jmp short start
nop

OEM_id           db "MSWIN4.1"       ; OEM id. 8 bytes in size, basically a version string
bytes_per_sector  dw 512              ; bytes making up each sector, 2 bytes
secs_per_cluster  db 1                ; sectors per cluster, 1 byte
reserve_count    dw 1                ; reserved sectors before first FAT, 2 bytes
FAT_count        db 2                ; number of FATs appearing on media
dir_entries      dw 224              ; directory entries max (root dir), 2 bytes
total_sectors    dw 2880             ; Total sectors in file system (1.44MB Floppy)
media_descriptor db 0xF0             ; Media descriptor, 1 byte. F0 for 1.44M
sectors_per_FAT   dw 9                ; Sectors per FAT, 2 bytes
sectors_per_track dw 18               ; Sectors per track, 2 bytes.
head_count       dw 2                ; Number of drive heads (On a double sided diskette, there are 2 :))
hidden_sectors   dd 0                ; Hidden sectors before FAT. should be zero on an unpartitioned media
; In larger file systems, there would be a double word field here defining the 
; total number of sectors. since we don't need this, we'll just pad it out
; so that we can write an Extended BPB below
                dd 0
drive_number     db 0x80                ; Physical drive number, 0 is removable. 80h for hdd
dirty_bit        db 1                ; WinNT uses this field to check if the fs is clean
extboot_sig      db 0x29             ; This lets us know the EBPB exists
volume_id        dd 77               ; Serial number for the volume
volume_label     db "durOS     ",0    ; Volume label. pad out to 11 bytes with spaces
fs_type          db "FAT12   "       ; File system type, pad with blanks to 8 bytes

start:
    cli
    mov ax,0x7c0
    mov ds,ax
    mov es,ax
    mov ax, 0x7000
    mov ss, ax
    mov sp, 0xFFFF
    sti
    ; Check bios extension for LBA reading.I hate CHS and my conversions would not work :(.
    ; https://wiki.osdev.org/Disk_access_using_the_BIOS_(INT_13h)
    mov ah,0x41
    mov bx,0x55AA
    mov dl,[drive_number]
    int 0x13
    jc .fl_not_support
    ; Calculate offset between bootloader and ROOT dir in sectors.
    xor ax,ax
    mov al,[FAT_count] 
    mul word [sectors_per_FAT]
    add ax,[reserve_count]
    mov [disk_packet.lba1],ax
    ; Calculate how many sectors to read.
    mov ax,32 ; Each root entry is 32 byte.
    xor dx,dx
    mul word [dir_entries] ; 32 * dir_entries
    div word [bytes_per_sector]; 32 * dir_entries/bytes_per_sector=?
    mov [disk_packet.sectors_to_read],ax
    mov si,disk_packet
    call read_disk_lba
    jc .cant_read_disk
    mov ax,root_segment
    mov es,ax
    mov di,root_offset
    
    mov cx,2
    .my_loop:
        mov si,stage2_name
        push di
        push cx
        mov cx,11
        .name_lookup:
            repe cmpsb
            jz .load_root
        pop cx
        pop di
        add di,32
        loop .my_loop
        jmp .stage2_not_found
        jmp end
    ; call read_fat_table
    ; ;mov si,0x200
    ; mov si,disk_size_msg
    ; call print_str
    ; mov dx,disk_packet_size
    ; call print_hex
    ; mov ax,0x0500
    ; mov es,ax
    ; mov di,0x0000
    ; add di,32
    ;
    ; mov dx,[es:di]
    ; call print_hex
    ; 
.load_root:
    mov si,stage2_found_msg
    call print_str
    jmp end
.stage2_not_found:
    mov si,stage2_not_found_msg
    call print_str
    jmp end
.fl_not_support:
    mov si,floppy_not_supported_msg
    call print_str
    jmp end
.cant_read_disk:
    mov si,unable_to_read_disk_msg
    call print_str
    jmp end


end:
    jmp $

;============================
; ARGS:
;  SI points to 16 byte memory address/variable
;============================
;
read_disk_lba:
    push si
    push ax
    push dx
    mov ah,0x42
    mov dl,[drive_number]
    int 0x13
    pop dx
    pop ax
    pop si
    ret 


root_segment: equ 0x0500
root_offset: equ 0x0000

disk_packet:
    .size db 0x10 ; Size of the struct.
    .unused db 0x0
    .sectors_to_read dw 0
    .offset dw root_offset
    .segment dw root_segment
    .lba1 dw 0        ; I don't know whether this is a correct approach but it works for now.
    .lba2 dw 0
    .lba3 dw 0
    .lba4 dw 0
stage2_name: db "STAGE2  BIN", ; Spaces are important.
stage2_found_msg: db "Found stage2",0
stage2_not_found_msg: db "unable to find stage2",0
floppy_not_supported_msg: db "Floppies not supported",0
unable_to_read_disk_msg: db "Can't read disk",0
%include "print.s"
times 510-($-$$) db 0
db 0x55
db 0xAA

