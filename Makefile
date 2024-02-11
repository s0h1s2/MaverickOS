.DEFAULT_GOAL := mavrick

TARGET_EXEC=os.bin
SRC_DIR=./src/
OUTPUT_NAME:= mavrick.img
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
BUILD_DIR:=$(ROOT_DIR)/build/

run: mavrick
	virtualboxvm --startvm Mavrick

prebuild:
	mkdir -p $(BUILD_DIR)
mavrick: prebuild stage1 stage2
	dd if=/dev/zero of=$(OUTPUT_NAME) bs=512 count=2879
	mkfs.vfat -F12 $(OUTPUT_NAME)
	dd if=$(BUILD_DIR)/bootloader.bin of=$(OUTPUT_NAME) conv=notrunc
	mcopy -n -i $(OUTPUT_NAME) $(BUILD_DIR)/stage2.bin "::Stage2.bin" 
	
stage1:
	$(MAKE) -C $(SRC_DIR)/bootloader/stage1 BUILD_DIR="$(BUILD_DIR)"
stage2:
	$(MAKE) -C $(SRC_DIR)/bootloader/stage2 BUILD_DIR="$(BUILD_DIR)"


.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
