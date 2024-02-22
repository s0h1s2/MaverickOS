#include "include/print.h"
void boot_main() {
  // bputs("Hello,world!");
  // bputc('O');
  // detect_memory();
  bprintf("Hello,%c", 'A', 'B', 'A', 'B', 'C');
loop:
  goto loop;
}
