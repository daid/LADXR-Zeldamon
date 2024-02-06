
storeTilemapVRAMtoSRAM:
    call waitVBlank
    ld   a, $01
    ld   [SET_RAM_BANK], a
    ld   de, $A000
    ld   hl, $9800
    ld   bc, $0800
    call vramCopyLoop
    ld   a, $01
    ldh  [rVBK], a
    ld   hl, $9800
    ld   bc, $0800
    call vramCopyLoop
    xor  a
    ldh  [rVBK], a
    ld   [SET_RAM_BANK], a
    ret

vramCopyLoop:
    WAIT_STAT
    ld   a, [hl+]
    ld   [de], a
    inc  de
    dec  c
    jr   nz, vramCopyLoop
    dec  b
    jr   nz, vramCopyLoop
    ret

restoreTilemapVRAMfromSRAM:
    ; Restore background/window positions
    ldh  a, [$FF96]
    ldh  [rSCX], a
    ldh  a, [$FF97]
    ldh  [rSCY], a
    ld   a, 7
    ldh  [rWX], a
    ld   a, $80
    ldh  [rWY], a

    ; Restore tilemaps from SRAM by means if DMA
    call waitVBlank
    ld   a, $01
    ld   [SET_RAM_BANK], a
    ld   a, $A0
    ldh  [$FF51], a
    xor  a
    ldh  [$FF52], a
    ld   a, $98
    ldh  [$FF53], a
    xor  a
    ldh  [$FF54], a
    ld   a, $7F
    ldh  [$FF55], a

    ld   a, $01
    ldh  [rVBK], a

    ld   a, $A8
    ldh  [$FF51], a
    xor  a
    ldh  [$FF52], a
    ld   a, $98
    ldh  [$FF53], a
    xor  a
    ldh  [$FF54], a
    ld   a, $7F
    ldh  [$FF55], a
    xor  a
    ldh  [rVBK], a

    ld   [SET_RAM_BANK], a

    ld   hl, $DC10
    call loadBGPal
    call loadObjPal
    ret

; Load back the tiles the other patches expect in 2nd graphics bank.
restoreVRAM2:
    call waitVBlank
    ld   a, $01
    ldh  [rVBK], a
    ld   a, $3F
    ld   b, $7F
    ld   de, $6800
    ld   hl, $8000
    call executeHDMA
    xor  a
    ldh  [rVBK], a

    call waitVBlank
    ld   a, $01
    ldh  [rVBK], a
    ld   a, $3F
    ld   b, $7F
    ld   de, $7000
    ld   hl, $8800
    call executeHDMA
    xor  a
    ldh  [rVBK], a

    call waitVBlank
    ld   a, $01
    ldh  [rVBK], a
    ld   a, $3F
    ld   b, $7F
    ld   de, $6800
    ld   hl, $9000
    call executeHDMA
    xor  a
    ldh  [rVBK], a
    ret
