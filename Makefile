.DEFAULT_GOAL := os
run: os
	virtualboxvm --startvm Mavrick
	
os: main.s stage2_boot
	nasm main.s -f bin -o bootloader.bin
	dd if=/dev/zero of=disk.img bs=1024 count=1440
	dd if=bootloader.bin of=disk.img conv=notrunc
	dd if=stage2.bin of=disk.img conv=notrunc bs=512 seek=1 conv=notrunc


stage2_boot: 
	$(MAKE) -C stage2/
	cp stage2/stage2.bin .


