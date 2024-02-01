.DEFAULT_GOAL := mavrick

TARGET_EXEC=os.bin
SRC_DIR=./src/

ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
BUILD_DIR:=$(ROOT_DIR)/build/

run: mavrick
	virtualboxvm --startvm Mavrick

prebuild:
	mkdir -p $(BUILD_DIR)
mavrick: prebuild stage1 stage2
	dd if=/dev/zero of=disk.img bs=1024 count=1440
	mkfs.vfat -F12 disk.img

stage1:
	$(MAKE) -C $(SRC_DIR)/bootloader/stage1 BUILD_DIR="$(BUILD_DIR)"
stage2:
	$(MAKE) -C $(SRC_DIR)/bootloader/stage2 BUILD_DIR="$(BUILD_DIR)"


.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
