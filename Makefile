all: build run

build: ./bin/boot.bin

./bin/boot.bin: ./src/boot/boot.asm
	nasm -f bin ./src/boot/boot.asm -o ./bin/boot.bin

run:
	qemu-system-x86_64 -hda ./bin/boot.bin

hello_world: ./bin/hello_world.bin
	qemu-system-x86_64 -hda ./bin/hello_world.bin

./bin/hello_world.bin: ./src/boot/helloworld_boot.asm
	nasm -f bin ./src/boot/helloworld_boot.asm -o ./bin/hello_world.bin

clean:
	rm -f ./bin/boot.bin
