all:
	nasm -f bin ./src/boot.asm -o ./bin/boot.bin
	dd if=./temp/message.txt >> ./bin/boot.bin
	dd if=/dev/zero bs=512 count=1 >> ./bin/boot.bin
