#pragma aux default ""
extern void __cdecl putc(char c);
void puts(char *s);
void bootloader_main(void){
                       putc('h');
                       puts("Hello");
                       loop:
                                              goto loop;
}
void puts(char *s){
                       while (*s!='\0') {
                       putc(*s);
                          s++;
                       }
}


