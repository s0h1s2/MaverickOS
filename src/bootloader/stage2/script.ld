OUTPUT("elf-i386");
SECTIONS {
        .data : ALIGN(4) {
                *(.data);
                *(.rodata*);
        }

}
