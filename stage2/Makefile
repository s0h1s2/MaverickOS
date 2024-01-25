ASM:=nasm
ASM_FLAGS:=-f elf32
OBJ_FILES:=$(wildcard *.o)
ASM_FILES:=$(wildcard *.s)
LINKER:=ld 

stage2:
	$(ASM) $(ASM_FLAGS) $(ASM_FILES)
	$(LINKER) -m elf_i386 -nostdlib -T script.ld $(OBJ_FILES) -o stage2.elf
	objcopy -O binary stage2.elf stage2.bin

