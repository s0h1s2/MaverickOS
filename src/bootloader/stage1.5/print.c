#include "include/print.h"

char *vid_buffer = (char *)0xb8000;
void putc(char c) {
  *vid_buffer = c;
  vid_buffer += 2;
}
