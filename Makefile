.DEFAULT_GOAL := mavrick

TARGET_EXEC=os.bin
SRC_DIR=./src/
OUTPUT_NAME:= mavrick.img
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
BUILD_DIR:=$(ROOT_DIR)/build/

run: mavrick
	qemu-system-i386 -kernel $(OUTPUT_NAME)
prebuild:
	mkdir -p $(BUILD_DIR)
mavrick: prebuild bootload kernel

bootload:
	nasm -f elf32 $(SRC_DIR)/boot.s -o $(BUILD_DIR)/boot.o
kernel:
		i686-elf-gcc -Wall -Wextra -ffreestanding -c $(SRC_DIR)/kernel/main.c -o $(BUILD_DIR)/main.o
		i686-elf-gcc -ffreestanding -nostdlib -T $(SRC_DIR)/kernel/linker.ld $(BUILD_DIR)/main.o $(BUILD_DIR)/boot.o -o $(ROOT_DIR)/$(OUTPUT_NAME)

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
