
blackShutter:
    ldh  a, [rSCY]
    and  $F8
    ld   b, $00
    sla  a
    rl   b
    sla  a
    rl   b

    call waitVBlank
    ld   de, $0220
    ld   hl, $9800 + $20 * 0
    add  hl, bc
    call drawBlackBox
    ld   de, $0220
    ld   hl, $9800 + $20 * 16
    add  hl, bc
    res  2, h
    call drawBlackBox
    ld   a, $FF
    ldh  [rWY], a
    call waitVBlank
    ld   de, $0220
    ld   hl, $9800 + $20 * 2
    add  hl, bc
    res  2, h
    call drawBlackBox
    ld   de, $0220
    ld   hl, $9800 + $20 * 14
    add  hl, bc
    res  2, h
    call drawBlackBox
    call waitVBlank
    ld   de, $0220
    ld   hl, $9800 + $20 * 4
    add  hl, bc
    res  2, h
    call drawBlackBox
    ld   de, $0220
    ld   hl, $9800 + $20 * 12
    add  hl, bc
    res  2, h
    call drawBlackBox
    call waitVBlank
    ld   de, $0220
    ld   hl, $9800 + $20 * 6
    add  hl, bc
    res  2, h
    call drawBlackBox
    ld   de, $0220
    ld   hl, $9800 + $20 * 10
    add  hl, bc
    res  2, h
    call drawBlackBox
    call waitVBlank
    ld   de, $0220
    ld   hl, $9800 + $20 * 8
    add  hl, bc
    res  2, h
    call drawBlackBox
    call waitVBlank
    ; Fall into clearOAM

clearOAM:
    xor  a
    ld   hl, wOAMBuffer
    ld   c, 40 * 4
.oamClearLoop:
    ld   [hl+], a
    dec  c
    jr   nz, .oamClearLoop
    call waitVBlank
    call $FFC0 ; DMA Routine
    ret

blankAllTiles:
    ld   a, BANK(blankTiles)
    ld   de, blankTiles
    ld   hl, $9800
    ld   b, $3F
    call waitVBlank
    call executeHDMA
    ld   a, 1
    ldh  [rVBK], a
    ld   a, BANK(blankTileAttr)
    ld   de, blankTileAttr
    call executeHDMA

    xor  a
    ldh  [rVBK], a
    ld   a, BANK(blankTiles)
    ld   de, blankTiles
    ld   hl, $9C00
    ld   b, $3F
    call waitVBlank
    call executeHDMA
    ld   a, 1
    ldh  [rVBK], a
    ld   a, BANK(blankTileAttr)
    ld   de, blankTileAttr
    call executeHDMA

    xor  a
    ldh  [rVBK], a
    ldh  [rSCX], a
    ldh  [rSCY], a

    ret
