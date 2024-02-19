#include "include/print.h"
void boot_main() {
  puts("Hello,world!");
  putc('O');
loop:
  goto loop;
}
