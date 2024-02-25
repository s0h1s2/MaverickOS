ASM:=nasm
ASM_FLAGS:=-f elf32
LINKER:=ld 
LINKER_FLAGS:=-m elf_i386 -nostdlib -T script.ld 
CC:=clang
CCFLAGS:= -c -Wall -Wextra --target=i386-pc-none-elf -inline-asm=intel -ffreestanding -nostdlib -c -I include/ -mno-red-zone -fno-builtin 
SRCS := $(shell find . -name '*.c' -or -name '*.s')
OBJS:=$(SRCS:%=$(BUILD_DIR)/%.o)

$(BUILD_DIR)/stage2.bin:$(OBJS)
	$(LINKER) $(LINKER_FLAGS) $(OBJS) -o $(BUILD_DIR)/stage2.elf

$(BUILD_DIR)/%.s.o: %.s
	$(ASM) $(ASM_FLAGS) $< -o $@

$(BUILD_DIR)/%.c.o: %.c
	$(CC) $(CCFLAGS) $< -o $@

