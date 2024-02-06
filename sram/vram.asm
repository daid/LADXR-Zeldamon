; Execute a HDMA
; A = bank to copy from
; DE = source address
; HL = target VRAM address
; B = (size - $10) / $10
SRAM_executeHDMA:
    ld   [SET_ROM_BANK], a
    ld   a, d
    ldh  [$FF51], a
    ld   a, e
    ldh  [$FF52], a
    ld   a, h
    ldh  [$FF53], a
    ld   a, l
    ldh  [$FF54], a
    ld   a, b
    ldh  [$FF55], a
    ld   a, [wCurrentBank]
    ld   [SET_ROM_BANK], a
    ret

; Write b to VRAM:0 at HL, and c to VRAM:1 at HL
SRAM_writeToTilemap:
    WAIT_STAT
    ld   [hl], b
    ld   a, 1
    ldh  [rVBK], a
    WAIT_STAT
    ld   [hl], c
    xor  a
    ldh  [rVBK], a
    ret
