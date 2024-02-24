#include "include/framebuffer.h"
#include "include/types.h"
#define FRAME_BUFFER 0xb8000
const u16 MAX_ROW = 25;
const u16 MAX_COL = 80;
int x = 0;
int y = 0;

void set_cursor(int x, int y) {
  x = x;
  y = y;
}
void write_char(i8 ch, Color fore, Color back) {
  u16 attr = (u16)((back << 4) | (fore & 0x0F));
  volatile u16 *frame = (volatile u16 *)FRAME_BUFFER + (y * MAX_COL + x);
  *frame = (u8)ch | (attr << 8);
}

void write_str(char *s, Color fore, Color back) {
  while (*s != '\0') {
    write_char(*s, fore, back);
    x++;
    if (x >= MAX_COL) {
      set_cursor(0, y++);
    }
  }
}
// void clear_screen() {
//   for (i32 r = 0; r < MAX_ROW; r++) {
//     for (i32 c = 0; c < MAX_COL; c++) {
//       write_char(0, BLACK, BLACK);
//       set_cursor(c, r);
//     }
//   }
// }
