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

.load_protected:
    cli
    lgdt[gdt_descriptor]
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp CODE_SEG:load32

; GDT
gdt_start:
; Null descriptor (first entry): never referenced by processor and should always contain no data
; width: 8 bytes
gdt_null:
    dd 0x0
    dd 0x0
; Kernel mode code segment descriptor (second entry), offset in GDT should be 0x8 (it is after the null descriptor)
gdt_code:       ; CS should point to this; width: 8 bytes
    dw 0xffff   ; limit: 0-15 bits                                      (location 00-15 bit)
    dw 0        ; base: 0-15 bits                                       (location 16-31 bit)
    db 0        ; base: 16-23 bits                                      (location 32-39 bit)
    db 10011010b; Access byte                                           (location 40-47 bit)
    db 11001111b; High 4 bits: flags, low 4 bits: limit 16-19 bits      (location 48-55 bit)
    db 0        ; base: 24-31 bits                                      (location 56-63 bit)
; Kernel mode data segment descriptor (third entry), offset in GDT should be 0x10 (it is after the code segment which is 8 bytes wide)
gdt_data:       ; DS, SS, ES, FS and GS should point to this; width: 8 bytes
    dw 0xffff   ; limit: 0-15 bits                                      (location 00-15 bit)
    dw 0        ; base: 0-15 bits                                       (location 16-31 bit)
    db 0        ; base: 16-23 bits                                      (location 32-39 bit)
    db 10010010b; Access byte                                           (location 40-47 bit)
    db 11001111b; High 4 bits: flags, low 4 bits: limit 16-19 bits      (location 48-55 bit)
    db 0        ; base: 24-31 bits                                      (location 56-63 bit)
gdt_end:
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; gives the size of the gdt descriptor (it is always -1 because so the size can be up to 65536 (instead of 65535) and a size of 0 would eh be invalid)
    dd gdt_start               ; gives the offset of the gdt descriptor table

[BITS 32]
load32:
    jmp $

times 510-($ - $$) db 0
dw 0xAA55
