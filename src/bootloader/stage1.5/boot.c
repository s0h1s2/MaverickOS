#include "include/framebuffer.h"
#include "include/print.h"
void boot_main() {
  clear_screen();
  write_char('A', BLACK, WHITE);
// bprintf("Hello,%c,%x", 'A', 0x1234);
loop:
  goto loop;
}
