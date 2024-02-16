OUTPUT("elf-i386");
SECTIONS {

        .text :  {
                *(.boot);
                *(.text);
        }
        .data : ALIGN(4) {
                *(.data);
                *(.rodata*);
        }

}
