#include "include/print.h"
#include "include/types.h"
#include <stdarg.h>

volatile char *vid_buffer = (volatile char *)0xb8000;

void bputc(char c) {
  *vid_buffer++ = c;
  *vid_buffer++ = 0xF6;
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
  while (*fmt != '\0') {
    if (*fmt == '%') {
      fmt++;
      if (*fmt == 'c') {
        char ch = (char)va_arg(ap, int);
        bputc(ch);
      } else if (*fmt == 'x') {
        char digits[16] = {'0', '1', '2', '3', '4', '5', '6', '7',
                           '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
        // NOTE: i don't implement format length so for now we print
        // 32bit(4bytes) hex at least for now.
        i32 dword = va_arg(ap, i32);
        char buffer[7] = {'0', 'x', '0', '0', '0', '0', '\0'};
        u8 current_index = 5;
        while (dword > 0) {
          char digit = dword % 16;
          buffer[current_index--] = *(digits + digit);
          dword /= 16;
        }
        bputs(buffer);
      } else {
        bputc('%');
      }
    } else {
      bputc(*fmt);
    }
    fmt++;
  }
  va_end(ap);
}
