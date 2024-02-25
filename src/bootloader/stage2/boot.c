#include "include/bprint.h"
#pragma clang diagnostic ignored "-Wincompatible-library-redeclaration"
typedef unsigned long u64;
typedef unsigned int u32;
typedef unsigned short u16;
typedef unsigned char u8;
typedef u32 size_t;


void *memset(void *s, int c, size_t n) {
    u8 *p = (u8 *)s;

    for (size_t i = 0; i < n; i++) {
        p[i] = (u8)c;
    }

    return s;
}

void bmain(){
    bputc('a',1);
loop:
  goto loop;
}
