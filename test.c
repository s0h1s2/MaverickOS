void _start() {
  asm("mov ax,0");
  asm("mov es,ax");
  asm("mov ds,ax");
  asm("mov ah,0x0e");
  asm("mov al,97");
  asm("int 0x10");

  // asm("mov dx,0x1234");
  //  asm("call print_hex");
  for (;;) {
    asm("hlt");
  }
}
