setupSRAMCode:
    call $27D0 ; Enable SRAM on bank 0
    ld   hl, $B100
    ld   de, SRAMCODE_START
    ld   bc, SRAMCODE_END - SRAMCODE_START
copyLoop:
    ld   a, [de]
    ld   [hl+], a
    inc  de
    dec  bc
    ld   a, b
    or   c
    jr   nz, copyLoop

setDefaultLCDCInterrupt:
    ld  a, 1
    ldh [rIE], a
    ld  a, $C3
    ldh [$FF80], a
    ld  a, $88
    ldh [$FF81], a
    ld  a, $03
    ldh [$FF82], a
    ret


SRAMCODE_START:

#INCLUDE "sram/banking.asm"
#INCLUDE "sram/interrupt.asm"
#INCLUDE "sram/vram.asm"
#INCLUDE "sram/vblank.asm"
#INCLUDE "sram/math.asm"
#INCLUDE "sram/text.asm"

SRAMCODE_END:
#ASSERT SRAMCODE_END - SRAMCODE_START < $900
