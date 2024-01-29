#include "include/bprint.h"
typedef unsigned long u64;
typedef unsigned int u32;
typedef unsigned short u16;
typedef unsigned char u8;

void bmain(){
  putc('C');
loop:
  goto loop;
}
