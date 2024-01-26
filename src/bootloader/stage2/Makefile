ASM:=nasm
ASM_FLAGS:=-f elf32
LINKER:=ld 
LINKER_FLAGS:=-m elf_i386 -nostdlib -T script.ld 

SRCS := $(shell find . -name '*.c' -or -name '*.s')
OBJS:=$(SRCS:%=$(BUILD_DIR)/%.o)

$(BUILD_DIR)/stage2.bin:$(OBJS)
	$(LINKER) $(LINKER_FLAGS) $(OBJS) -o stage2.elf
	objcopy -O binary stage2.elf $@

$(BUILD_DIR)/%.s.o: %.s
	$(ASM) $(ASM_FLAGS) $< -o $@

# # stage2: $(OBJ_FILES)
# 	$(LINKER) -m elf_i386 -nostdlib -T script.ld $(OBJ_FILES) -o stage2.elf
# 	objcopy -O binary stage2.elf stage2.bin
# %.o: %.s
# 	$(ASM) $(ASM_FLAGS) $? -o $@

