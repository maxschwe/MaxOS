ORG 0x7c00
BITS 16

start:
    mov ah, 0x
    mov al, 'A'
    mov bx, 0
    int 0x10

    jmp $


times 510-($ - $$) db 0
dw 0xAA55