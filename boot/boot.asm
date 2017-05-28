[org 0x7c00]

kernelOffset equ 0x1000 ; Offset to Kernel Location

; Main Boot
[bits 16]
boot:
  mov [bootDrive], dl ; Setup Boot Drive Location

  ; Setup stack
  mov bp, 0x9000
  mov sp, bp

  mov bx, intro ; Store Message in "Base Index" Register
  call print16 ; Print Intro

  call load ; Load Kernel

  call switch ; Switch to Protected Mode

  jmp $ ; Loop

; Load 16 bit printing utility
%include "boot/print16.asm"

; Load 16 bit disk loading utility
%include "boot/loadDisk.asm"

; Load Switcher to Protected Mode
%include "boot/switch.asm"

; Load GDT
%include "boot/gdt.asm"

; Load 32 bit printing utility
%include "boot/print.asm"

; Load Kernel
[bits 16]
load:
  mov bx, kernelOffset
  mov dh, 1
  mov dl, [bootDrive]
  call loadDisk

  ret

; After Switching to Protected Mode
[bits 32]
afterSwitch:
  mov ebx, intro ; Store Message
  call print ; Print Message

  call kernelOffset

  jmp $ ; Loop

; Intro Message
intro db "Ample OS", 0

; Boot Drive Location
bootDrive db 0

times 510-($-$$) db 0 ; Skip over 510 Bytes
dw 0xaa55 ; Let BIOS know disk is Bootable
