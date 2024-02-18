ASM:=nasm
ASM_FLAGS:=-f elf32
LINKER:=ld 
LINKER_FLAGS:=-m elf_i386 -nostdlib -T linker.ld 
CC:=ldc2
CCFLAGS:=-mtriple=i386-pc-none-elf -c --betterC --O1
SRCS := $(shell find . -name '*.d' -or -name '*.s')
OBJS:=$(SRCS:%=$(BUILD_DIR)/%.o)


$(BUILD_DIR)/stage2.bin: $(OBJS)
	ld -m elf_i386 -T linker.ld -o $@ $(OBJS)

$(BUILD_DIR)/%.s.o: %.s
	$(ASM) $(ASM_FLAGS) $< -o $@

$(BUILD_DIR)/%.d.o: %.d
	$(CC) $(CCFLAGS) $< -of=$@
