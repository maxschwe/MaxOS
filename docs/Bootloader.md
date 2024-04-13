## 1 - How does the Bios load the bootloader
- Any machine with legacy BIOS will load the boot sector to physical address 0x07c00 and then transfer control to it (usually a FAR JMP or equivalent). It is that simple. The memory address 0x07c0:0x0000 and 0000:0x7c00 are actually the physical location in memory. To compute physical address from real mode segment:offset pair you shift the segment left 4 bits (or multiply by 16 decimal) and then add the offset. So (0x07c0<<4)+0x0000=0x07c00 and (0x0000<<4)+0x7c00=0x07c00 too.  
  
The difference is what address the BIOS uses to FAR JMP to your code. A FAR JMP to 0x0000:0x7c00 will set CS to 0x0000 and IP to 0x7c00 and a FAR JMP to 0x07c0:0x0000 will set CS to 0x07c0 and IP to 0x0000. What is important is that your bootloader loads the segment registers accordingly when it starts running.

## 2 - Addresses
- each absolute address addresses one byte 

## 3 - Interrupts
- the first 32 interrupts 0x00 - 0x1F are exceptions (for example 0x00 is division by 0) which can be handled by specifying entries in the interrupt vector table saved in the first bytes of RAM 
- [Ralf Browns Interrupt List](https://www.ctyme.com/intr/int.htm)
## 4 - Hello World
- in das A und B Register werden bestimmte Werte gelegt und mit `int 0x10` wird eine Funktion des Bios aufgerufen (in $AH$ wird ein bestimmter Bios Befehl ausgewählt und $AL$ und $B$ fungieren als Parameter)