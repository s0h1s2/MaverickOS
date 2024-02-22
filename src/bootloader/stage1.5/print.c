#include "include/print.h"
#include "include/types.h"
#include <stdarg.h>

volatile char *vid_buffer = (volatile char *)0xb8000;

void bputc(char c) {
  *vid_buffer++ = c;
  *vid_buffer++ = 0x05;
}
void bputs(char *src) {
  while (*src != '\0') {
    bputc(*src);
    src++;
  }
}

void __attribute__((cdecl)) bprintf(const char *fmt, ...) {
  va_list ap;
  va_start(ap, fmt);
  va_arg(ap, int);
  char c = (char)va_arg(ap, int);
  bputc(c);
  va_end(ap);
}
