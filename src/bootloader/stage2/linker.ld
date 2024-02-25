OUTPUT_FORMAT("binary");
SECTIONS {
    . = 0x00007e00;
    .text : {
      *(.boot);
      *(.text*);
    }

    .data : ALIGN(4096) {
      *(.data*);
    }

    .bss : ALIGN(4096){
        *(.bss*);
    }

    .rodata : ALIGN(4096) {
        *(.rodata*);
    }
}
