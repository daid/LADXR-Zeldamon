loadBGPalDE:
    ld16_hl_de
loadBGPal:
    ld  a, $80
    ldh [rBCPS], a
    ld  c, 8 * 4 * 2
.loop:
    WAIT_STAT
    ld  a, [hl+]
    ldh [rBGPD], a
    dec c
    jr  nz, .loop
    ret

loadObjPalDE:
    ld16_hl_de
loadObjPal:
    ld  a, $80
    ldh [rOCPS], a
    ld  c, 8 * 4 * 2
.loop:
    WAIT_STAT
    ld  a, [hl+]
    ldh [rOBPD], a
    dec c
    jr  nz, .loop
    ret

battlePalette:
    dw $47FF, $46FF, $22A2, $0000 ; Green things (cursor, HP)
    dw $47FF, $46FF, $05FF, $0000 ; Yellow things
    dw $47FF, $46FF, $143F, $0000 ; Red things (HP)
    dw $47FF, $46FF, $7E03, $0000 ; Blue things
    dw $47FF, $47FF, $46FF, $0000 ; Used for dark text
    dw $47FF, $0000, $22A2, $47FF ; Used for light text
    dw $47FF, $7FFF, $7FFF, $0000
    dw $47FF, $7FFF, $7FFF, $0000

    dw $47FF, $0000, $22A2, $46FF ; Green things
    dw $47FF, $0000, $05FF, $46FF ; Yellow things
    dw $47FF, $0000, $143F, $46FF ; Red things
    dw $47FF, $0000, $7E03, $46FF ; Blue things
    dw $47FF, $1ADF, $001B, $0000
    dw $47FF, $7EAE, $7C00, $0000
    dw $47FF, $26C4, $1521, $0000
    dw $47FF, $51F3, $2867, $0000
