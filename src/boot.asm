ORG 0
BITS 16

_start:
    jmp short start
    nop

start:
    ; sets code segment to 0x7c0 and jumps to step2 with absolute address
    ; 0x7c0 * 16 + step2
    jmp 0x7c0:step2
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
    mov si, message
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

message: db 'Hello World!', 0


times 510-($ - $$) db 0
dw 0xAA55