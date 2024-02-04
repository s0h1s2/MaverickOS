[BITS 16]
[ORG 0]

jmp short start
nop
OEMid           db "MSWIN4.1"       ; OEM id. 8 bytes in size, basically a version string
BytesPerSector  dw 512              ; bytes making up each sector, 2 bytes
SecsPerCluster  db 1                ; sectors per cluster, 1 byte
ReserveCount    dw 1                ; reserved sectors before first FAT, 2 bytes
FATcount        db 2                ; number of FATs appearing on media
DirEntries      dw 224              ; directory entries max (root dir), 2 bytes
TotalSectors    dw 2880             ; Total sectors in file system (1.44MB Floppy)
MediaDescriptor db 0xF0             ; Media descriptor, 1 byte. F0 for 1.44M
SectorsPerFAT   dw 9                ; Sectors per FAT, 2 bytes
SectorsPerTrack dw 18               ; Sectors per track, 2 bytes.
HeadCount       dw 2                ; Number of drive heads (On a double sided diskette, there are 2 :))
HiddenSectors   dd 0                ; Hidden sectors before FAT. should be zero on an unpartitioned media
; In larger file systems, there would be a double word field here defining the 
; total number of sectors. since we don't need this, we'll just pad it out
; so that we can write an Extended BPB below
                dd 0
DriveNumber     db 0x80                ; Physical drive number, 0 is removable. 80h for hdd
DirtyBit        db 1                ; WinNT uses this field to check if the fs is clean
extBootSig      db 0x29             ; This lets us know the EBPB exists
VolumeID        dd 77               ; Serial number for the volume
VolumeLabel     db "durOS     ",0    ; Volume label. pad out to 11 bytes with spaces
FSType          db "FAT12   "       ; File system type, pad with blanks to 8 bytes

start:
    cli
    mov ax,0x7c0
    mov ds,ax
    mov es,ax
    mov ax, 0x7000
    mov ss, ax
    mov sp, 0xFFFF
    sti
    call read_fat_table
    mov bx,0x400

    jmp $

read_fat_table:
    mov si,disk_packet
    mov ah,0x42
    mov dl,[DriveNumber]
    int 0x13
    ret 

disk_packet:
    .size db 0x10
    .unused db 0x0
    .sectors_to_read dw 14
    .offset dw 0x0200
    .segment dw 0x7c00
    .lower_lba dw 18
    .lower_high dw 0x0

%include "print.s"
times 510-($-$$) db 0
db 0x55
db 0xAA

