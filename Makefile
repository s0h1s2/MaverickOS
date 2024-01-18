os: main.s stage2
	nasm main.s -f bin -o bootloader.bin
	cat bootloader.bin stage2.bin > os.bin
	rm bootloader.bin stage2.bin
	dd if=os.bin of=disk.img bs=1024 count=1440
	virtualboxvm --startvm Mavrick

stage2: stage2.s
	nasm stage2.s -f bin -o stage2.bin

