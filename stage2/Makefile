stage2:
	wcc -2 -d0 -wx -ms -s -zl main.c
	wlink file main.o format raw bin name stage2.bin option NODEFAULTLIBS,verbose,start=init_,OFFSET=0x7E00


