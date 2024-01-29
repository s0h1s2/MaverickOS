#include "include/bprint.h"

void putc(char c){
  volatile char *buffer=(volatile char *)0xB8000;
  *buffer++=c;
  *buffer++=15;
}

