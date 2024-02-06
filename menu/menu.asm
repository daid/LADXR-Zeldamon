; Do a selection menu
; HL = pointer do menu data structure.
; Returns selected entry in A and hTMP4, sets zero flag is canceled.
runMenu:
    xor  a
    ldh  [hTMP4], a

.returnToLoop:
    call .updateCursor

.menuLoop:
    call waitVBlank
    ldh  a, [hJoypadPressed]
    and  J_A | J_START ; select
    jr   nz, .select
    ldh  a, [hJoypadPressed]
    and  J_B | J_SELECT ; cancel
    jr   nz, .cancel
    ldh  a, [hJoypadPressed]
    and  J_UP
    jr   nz, .cursorUp
    ldh  a, [hJoypadPressed]
    and  J_DOWN
    jr   nz, .cursorDown
    jr   .menuLoop

.cursorUp:
    ld   a, $0A
    ldh  [hJingleSFX], a
    ldh  a, [hTMP4]
    dec  a
    cp   $FF
    jr   z, .menuLoop
    jr   .returnToLoop

.cursorDown:
    ld   a, $0A
    ldh  [hJingleSFX], a
    ldh  a, [hTMP4]
    inc  a
    cp   [hl]
    jr   z, .menuLoop
    jr   .returnToLoop

.select:
    ld   a, $13
    ldh  [hJingleSFX], a
    ldh  a, [hTMP4]
    ret

.cancel:
    xor  a
    ld   a, $FF
    ret

.updateCursor:
    push hl
    push af

    inc  hl
    ld   c, [hl]
    inc  hl
    ld   b, [hl]

    ldh  a, [hTMP4]
    add  a, a
    add  a, 3
    add  a, l
    ld   l, a
    adc  h
    sub  l
    ld   h, a

    ld   a, [hl+]
    ld   h, [hl]
    ld   l, a

    call writeToTilemap
    pop  af
    pop  hl
    ldh  [hTMP4], a

    push hl

    inc  hl
    inc  hl
    inc  hl
    ld   c, [hl]
    inc  hl
    ld   b, [hl]
    inc  hl

    ldh  a, [hTMP4]
    add  a, a
    add  a, l
    ld   l, a
    adc  h
    sub  l
    ld   h, a

    ld   a, [hl+]
    ld   h, [hl]
    ld   l, a

    call writeToTilemap
    pop  hl
    ret


Menu2x2Info:
    db 4
    dw $7E00, $DC08 ; blank cursor tile, filled cursor tile
    dw $99E1, $9A01, $99E9, $9A09

; Do a selection menu on a 2x2 grid
; Returns selected entry in A and hTMP4, sets zero flag is canceled.
runMenu2x2:
    ld   hl, Menu2x2Info
    xor  a
    ldh  [hTMP4], a

.returnToLoop:
    call runMenu.updateCursor

.menuLoop:
    call waitVBlank
    ldh  a, [hJoypadPressed]
    and  J_A | J_START ; select
    jr   nz, runMenu.select
    ldh  a, [hJoypadPressed]
    and  J_B | J_SELECT ; cancel
    jr   nz, runMenu.cancel
    ldh  a, [hJoypadPressed]
    and  J_UP + J_DOWN
    jr   nz, .cursorUpDown
    ldh  a, [hJoypadPressed]
    and  J_LEFT + J_RIGHT
    jr   nz, .cursorLeftRight
    jr   .menuLoop

.cursorUpDown:
    ld   a, $0A
    ldh  [hJingleSFX], a
    ldh  a, [hTMP4]
    xor  1
    jr   .returnToLoop

.cursorLeftRight:
    ld   a, $0A
    ldh  [hJingleSFX], a
    ldh  a, [hTMP4]
    xor  2
    jr   .returnToLoop

Menu2x1Info:
    db 2
    dw $7E00, $DC08 ; blank cursor tile, filled cursor tile
    dw $9A01, $9A09

; Do a selection menu on a 2x1 grid
; Returns selected entry in A and hTMP4, sets zero flag is canceled.
runMenu2x1:
    ld   hl, Menu2x1Info
    xor  a
    ldh  [hTMP4], a

.returnToLoop:
    call runMenu.updateCursor

.menuLoop:
    call waitVBlank
    ldh  a, [hJoypadPressed]
    and  J_A | J_START ; select
    jp   nz, runMenu.select
    ldh  a, [hJoypadPressed]
    and  J_B | J_SELECT ; cancel
    jp   nz, runMenu.cancel
    ldh  a, [hJoypadPressed]
    and  J_LEFT + J_RIGHT
    jr   nz, .cursorLeftRight
    jr   .menuLoop

.cursorLeftRight:
    ld   a, $0A
    ldh  [hJingleSFX], a
    ldh  a, [hTMP4]
    xor  1
    jr   .returnToLoop


; -- Menu info structs need to be in the right bank
menuInfoZeldaCenterMain:
    db 3 ; amount of entries
    dw $7E00, $DC08 ; blank cursor tile, filled cursor tile
    dw $9902, $9942, $9982, $99C2
menuInfoZeldaCenterBuy:
    db 3 ; amount of entries
    dw $7E00, $DC08 ; blank cursor tile, filled cursor tile
    dw $9942, $9982, $99C2
