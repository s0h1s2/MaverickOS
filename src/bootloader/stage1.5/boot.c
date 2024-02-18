#include "include/print.h"
void boot_main() {
  putc('H');
  putc('e');
  putc('l');
  putc('l');
  putc('o');
// puts(hello);
loop:
  goto loop;
}
