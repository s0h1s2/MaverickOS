#include "include/bprint.h"
volatile char *buffer=(volatile char *)0xB8000;
void bputc(char c,Color color){
  *buffer++=c;
  *buffer++=color;
}

void bprints(char *str){
  while (*str!='\0') {
    bputc(*str,GRAY);
    str++;
  }
}

