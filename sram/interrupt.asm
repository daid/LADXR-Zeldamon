SRAM_LCDCbattleInterrupt:
    push af
    ldh  a, [rLYC]
    cp   14 * 8
    jr   z, .statusBar
    cp   6 * 8
    jr   z, .playerGraphicsStart
    cp   8 * 8
    jr   z, .enemyGraphicsEnd

    ; First row
    ldh  a, [hEnemyGfxX]
    ldh  [rWX], a
    ld   a, $E7
    ldh  [rLCDC], a
    ld   a, 6 * 8
    ldh  [rLYC], a
    jr   .reti

.playerGraphicsStart:
    ldh  a, [hPlayerGfxX]
    ldh  [rSCX], a
    ld   a, 8 * 8
    ldh  [rLYC], a
    jr   .reti

.enemyGraphicsEnd:
    ld   a, 7 + 64
    ldh  [rWX], a
    ld   a, 14 * 8
    ldh  [rLYC], a
    jr   .reti

.statusBar:
    ld   a, $C7
    ldh  [rLCDC], a
    ld   a, 0
    ldh  [rLYC], a
    ldh  [rSCX], a

.reti:
    WAIT_STAT ; We need to exit the interrupt at a point where we can write to VRAM due to interrupting stat checks
    pop  af
    reti
