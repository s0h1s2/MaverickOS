.DEFAULT_GOAL := os
run: os
	virtualboxvm --startvm Mavrick
	
os: main.s stage2
	nasm  main.s -f bin -o bootloader.bin
	cat bootloader.bin stage2.bin > os.bin
	rm bootloader.bin stage2.bin
	dd if=os.bin of=disk.img bs=1024 count=1440

stage2: stage2.s
	#nasm -f bin stage2.s -o stage2.bin
	smlrcc -flat16 -c -S -verbose -origin 0x7e00 test.c -o stage.asm 
	(echo "[ORG 0x7e00]";cat stage.asm)>stage2.asm
	echo 'times 1024-($$-$$$$) db 0' >> stage2.asm
	nasm -f bin stage2.asm -o stage2.bin
