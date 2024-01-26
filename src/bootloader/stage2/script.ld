ENTRY(init_sys)
OUTPUT_FORMAT("elf32-i386");

SECTIONS {
        . = 0x7e00;
        .text : { 
                *(.text);
        }
        .data : SUBALIGN(2) {
                *(.data);
                *(.rodata*);
        }
}
