#include "include/print.h"
#include "include/framebuffer.h"
#include "include/types.h"
#include <stdarg.h>

void __attribute__((cdecl)) bprintf(const char *fmt, ...) {
  va_list ap;
  va_start(ap, fmt);
  while (*fmt != '\0') {
  }
  va_end(ap);
}
