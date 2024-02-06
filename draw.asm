; Draw a black box on the background tilemap
; d = height, e = width
; hl = top left corner vram address
drawBlackBottomBar:
    ld  de, $0414
    ld  hl, $9800 + $20 * 14

drawBlackBox:

.vloop:
    push de
    push hl
.hloop:
    ; Write the tile
    WAIT_STAT
    ld   [hl], $7E
    ld   a, $01
    ldh  [rVBK], a
    ld   [hl], $80
    xor  a
    ldh  [rVBK], a

    inc  hl
    dec  e
    jr   nz, .hloop
    pop  hl
    ld   de, $20
    add  hl, de
    pop  de
    dec  d
    jr   nz, .vloop

    ret
