OUTPUT_FORMAT("elf32-i386");
SECTIONS {
        . = 0x7e00;
        .text : ALIGN(4) {
                x86.s.o(.text);
                *(.text);
        }
        .data : ALIGN(4) {
                *(.data);
                *(.rodata*);
        }
}
