stage2:
	wcc -2 -d0 -wx -ms -s -zl main.c
	nasm  -f obj x86.asm -o x86.o 
	wlink FORMAT RAW BIN NAME stage2.bin FILE {main.o x86.o} OPTION OFFSET=0x7E00



