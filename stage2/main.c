void init_asm(void);
#pragma aux init_asm = "xor ax,ax"\
                       "mov ds,ax"\
                       "mov es,ax"\
                       "mov ss,ax"\
                       modify[AX];
void init(){init_asm(); }
