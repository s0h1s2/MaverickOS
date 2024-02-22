#include "include/print.h"
void boot_main() {
  // bputs("Hello,world!");
  // bputc('O');
  // detect_memory();
  bprintf("Hello,%c,%x", 'A', 0x1234);
loop:
  goto loop;
}
