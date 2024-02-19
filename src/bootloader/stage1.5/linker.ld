OUTPUT_FORMAT("binary");

SECTIONS {
    . = 0x00007e00;
    .text : {
      *(.boot);
      *(.text);
    }

    .data : {
      *(.data);
    }

    .bss : {
        *(.bss);
    }
}
