#include "include/print.h"

volatile char *vid_buffer = (volatile char *)0xb8000;

void putc(char c) {
  *vid_buffer = c;
  vid_buffer += 2;
}
void puts(char *src) {
  while (*src != '\0') {
    putc(*src);
    src++;
  }
}
void printf(char *fmt, ...) {

  while (*fmt != '\0') {
  }
}
