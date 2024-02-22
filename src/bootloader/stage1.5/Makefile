ASM:=nasm
ASM_FLAGS:=-f elf32
LINKER:=i686-elf-ld 
LINKER_FLAGS:=-m elf_i386 -nostdlib -T linker.ld -Map $(BUILD_DIR)/kernel.map
CC:=i686-elf-gcc
CCFLAGS:=-m32 -g -O0 -std=c99  -fno-stack-protector -c -Wall -Wextra -mgeneral-regs-only  -ffreestanding -nostdlib -c -I include/ 
SRCS := $(shell find . -name '*.c' -or -name '*.s')
OBJS:=$(SRCS:%=$(BUILD_DIR)/%.o)


$(BUILD_DIR)/stage2.bin: $(OBJS)
	$(LINKER) $(LINKER_FLAGS) -o $@ $(OBJS)

$(BUILD_DIR)/%.s.o: %.s
	$(ASM) $(ASM_FLAGS) $< -o $@

$(BUILD_DIR)/%.c.o: %.c
	$(CC) $(CCFLAGS) $< -o $@
