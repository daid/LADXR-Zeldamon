battleUpdateHPBarSizes:
    ; Calculate new HPBar value
    ld   a, [sPlayerActiveMon]
    add  a, a
    ldhl_add_a sMonHP
    ld   a, [hl+]
    ld   d, [hl]
    ld   e, a
    ld   a, 56
    call umul8_16
    push hl ; hp*56
    ld   a, [sPlayerActiveMon]
    call getMaxHP
    ld16_de_bc
    pop  bc
    call udiv16 ; hp*56/maxhp
    ld   a, c
    ld   [sPlayerHPBarSize], a

    ; Calculate new HPBar value
    ld   a, [sEnemyActiveMon]
    add  a, a
    ldhl_add_a sMonHP
    ld   a, [hl+]
    ld   d, [hl]
    ld   e, a
    ld   a, 56
    call umul8_16
    push hl ; hp*56
    ld   a, [sEnemyActiveMon]
    call getMaxHP
    ld16_de_bc
    pop  bc
    call udiv16 ; hp*56/maxhp
    ld   a, c
    ld   [sEnemyHPBarSize], a
    ret

battleDrawHPBars:
    ; Player HP Bar
    ld   hl, $9D60

    ld   a, [sPlayerHPBarSize]
    ld   d, a
    ld   bc, $D928
    call .drawHPBar

    ; Enemy HP Bar
    ld   bc, $D928
    ld   hl, $9823
    ld   a, [sEnemyHPBarSize]
    ld   d, a
    ld   bc, $D928
    call .drawHPBar
    ret

.drawHPBar:
    call writeToTilemap
    inc  hl
    ld   c, $08
    ld   e, 7
.loop:
    ld   a, d
    cp   $80
    jr   nc, .empty
    cp   8
    jr   nc, .full
    add  a, $D0
    ld   b, a
    jr   .draw
.empty:
    ld   b, $D0
    jr   .draw
.full:
    ld   b, $D8
.draw:
    call writeToTilemap
    inc  hl
    ld   a, d
    sub  8
    ld   d, a
    dec  e
    jr   nz, .loop

    ld   bc, $D908
    call writeToTilemap
    ret

battleDrawPlayerHPValue:
    ld   a, [sPlayerActiveMon]
    call getMaxHP
    ld   hl, $9D87
    call drawNumberLight
    ;ld   hl, $9D84
    ld   bc, $DA08
    call writeToTilemap
    dec  hl

    push hl
    ld   a, [sPlayerActiveMon]
    add  a, a
    ldhl_add_a sMonHP
    ld   a, [hl+]
    ld   b, [hl]
    ld   c, a
    pop  hl
    call drawNumberLight
    ld   bc, $7F00
    call writeToTilemap
    dec  hl
    call writeToTilemap
    dec  hl
    ret
