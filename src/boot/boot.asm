; adds this offset to every address/label
; gets used when absolute addresses are used (for example in jumps, memory access)
; in the most cases relative addresses are used so there this setting is not used
ORG 0x7c00

; Generate 16 Bit Assembly
BITS 16

CODE_SEG equ gdt_code - gdt_start ; calcs offset of code segment within the GDT
DATA_SEG equ gdt_data - gdt_start ; calcs offset of data segment within the GDT

; jumps over the bios parameter block (this code gets assembled to exactly 3 bytes)
_start:
    jmp short start
    nop ; has opcode 0x90

; sets bios parameter block up where the bios can write into
; without corrupting the boot file
times 33 db 0 

start:
    ; sets code segment to 0
    jmp 0:step2

step2:
    cli ; Clear Interrupts

    ; setup segment registers
    mov ax, 0x00
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti ; Enable Interrupts

; GDT
gdt_start:
; Null descriptor: never referenced by processor and should always contain no data
; is 8 bytes wide
gdt_null:
    dd 0x0
    dd 0x0
; Kernel mode code segment, offset in GDT should be 0x8 (it is after the null descriptor)
gdt_code:       ; CS should point to this
    dw 0xffff   ; segment limit first 0-15 bits
    dw 0        ; base first 0-15 bits
    db 0        ; base 16-23 bits
    db 0x9a     ; Access byte
    db 11001111b; High 4 bit flags and low 4 bit flags
    db 0        ; Base 24-31 bits
; Kernel mode data segment, offset in GDT should be 0x10 (it is after the code segment which is 8 bytes wide)
gdt_data:       ; DS, SS, ES, FS and GS should point to this
    dw 0xffff   ; segment limit first 0-15 bits
    dw 0        ; base first 0-15 bits
    db 0        ; base 16-23 bits
    db 0x92     ; Access byte
    db 11001111b; High 4 bit flags and low 4 bit flags
    db 0        ; Base 24-31 bits
gdt_end:
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; gives the size of the gdt descriptor
    dd gdt_start

times 510-($ - $$) db 0
dw 0xAA55
