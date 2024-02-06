; Select a party member in the player party.
; Expects the screen to be clear before entering.
; Return selected index in A, or with the zero flag set if canceled.
selectPartyMember:
    ld   c, 6
.drawLoop:
    ld   a, 6
    sub  c
    push bc
    ldh  [hTMP4], a
    ldhl_add_a sMonType
    ld   a, [hl]
    cp   $FF
    jr   z, .skip

    ldh  a, [hTMP4]
    ld   de, $40
    call umul8_16
    ld   de, $9823
    add  hl, de

    ldh  a, [hTMP4]
    call getMonName
    ld   c, 8
    call drawTextLengthLight

    push hl
    ldh  a, [hTMP4]
    call getMonLevel
    pop  hl
    ld   de, 4
    add  hl, de
    call drawNumberLight
    ld   bc, $DB08
    call writeToTilemap

    ldh  a, [hTMP4]
    ld   de, $40
    call umul8_16
    ld   de, $984A
    add  hl, de

    ldh  a, [hTMP4]
    push hl
    call getMaxHP
    pop  hl
    call drawNumberLight
    ld   bc, $DA08
    call writeToTilemap
    dec  hl

    push hl
    ldh  a, [hTMP4]
    add  a, a
    ldhl_add_a sMonHP
    ld   a, [hl+]
    ld   b, [hl]
    ld   c, a
    pop  hl
    call drawNumberLight

.skip:
    pop  bc
    dec  c
    jr   nz, .drawLoop

    ld   hl, .menuInfo
    call runMenu
    jr   z, .cancel

    ldh  a, [hTMP4]
    ldhl_add_a sMonType
    ld   a, [hl]
    cp   $FF
    jr   z, .cancel
    ldh  a, [hTMP4]
    ret

.cancel: ; entered with zero flag set
    ld   a, $FF
    ret

.menuInfo:
    db   6
    dw   $7F00, $DC0D
    dw   $9822, $9862, $98A2, $98E2, $9922, $9962
