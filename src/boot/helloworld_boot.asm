ORG 0x7c00
BITS 16

start:
    mov ah, 0x01
    jmp [testing]
    mov bh, 0x02

dd testing

testing:
    mov cx, 0x03

times 510 - ($ - $$) db 0
dw 0xaa55
