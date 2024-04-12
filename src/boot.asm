ORG 0
BITS 16

; jumps over the bios parameter block (this code gets assembled to exactly 3 bytes)
_start:
    jmp short start
    nop ; has opcode 0x90

; sets bios parameter block up where the bios can write into
; without corrupting the boot file
times 33 db 0 

start:
    ; sets code segment to 0x7c0 and instruction pointer to the address of step2
    ; results in an jump to absolute address 0x7c0 * 16 + step2
    jmp 0x7c0:step2

handle_zero:
    mov ah, 0eh
    mov al, 'A'
    mov bx, 0x00
    int 0x10
    iret

step2:
    cli ; Clear Interrupts

    ; setup segment registers
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax

    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7c00
    sti ; Enable Interrupts

    ; setup interrupt vector table
    mov word[ss:0x00], handle_zero
    mov word[ss:0x02], 0x7c0

    int 0

    ; print welcome msg
    mov si, welcome
    call print

    jmp $

print:
    mov bx, 0
.loop:
    lodsb ; loads value from absolute address: ds * 16 + si and increments si by 1
    cmp al, 0
    je .done
    call print_char
    jmp .loop
.done:
    ret


print_char: 
    mov ah, 0x0e
    int 0x10
    ret

welcome: db 'Hello World!', 0


times 510-($ - $$) db 0
dw 0xAA55