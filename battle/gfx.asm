battleShiftOutPlayer:
.loop:
    call waitVBlank
    ldh  a, [hPlayerGfxX]
    add  a, 4
    ldh  [hPlayerGfxX], a
    cp   64
    jr   nz, .loop
    ret

battleShiftInPlayer:
.loop:
    call waitVBlank
    ldh  a, [hPlayerGfxX]
    and  a
    ret  z
    sub  4
    ldh  [hPlayerGfxX], a
    jr   nz, .loop
    ret

battleShiftOutEnemy:
.loop:
    call waitVBlank
    ldh  a, [hEnemyGfxX]
    add  a, 4
    ldh  [hEnemyGfxX], a
    cp   ENEMY_GFX_X_START
    jr   nz, .loop
    ret

battleShiftInEnemy:
.loop:
    call waitVBlank
    ldh  a, [hEnemyGfxX]
    cp   ENEMY_GFX_X_END
    ret  z
    sub  4
    ldh  [hEnemyGfxX], a
    cp   ENEMY_GFX_X_END
    jr   nz, .loop
    ret

; Load info pointed by HL to tilemap at DE with the graphics loaded at cc00
loadMonsterGFX:
    push de
    ld   a, BANK(monsterBaseStats)
    call bankedReadInc
    ld   b, a
    ld   a, BANK(monsterBaseStats)
    call bankedReadDEInc
    push hl

    call waitVBlank
    ld   a, $01
    ldh  [rVBK], a
    ld   a, b
    ld   b, $3F
    ld   h, c
    ld   l, 00
    call executeHDMA
    xor  a
    ldh  [rVBK], a

    pop  hl
    pop  de
    ld   a, BANK(monsterBaseStats)
    call bankedReadInc
    ld   b, a
    ld   a, BANK(monsterBaseStats)
    call bankedReadHL

    ld   c, 8
    push bc

.tilemaploop:
    ld   a, b
    call bankedReadInc
    push af
    WAIT_STAT
    pop  af
    ld   [de], a
    ld   a, $01
    ldh  [rVBK], a
    ld   a, b
    call bankedReadInc
    push af
    WAIT_STAT
    pop  af
    ld   [de], a
    xor  a
    ldh  [rVBK], a
    inc  de
    dec  c
    jr   nz, .tilemaploop

    ld   a, e
    add  a, 32 - 8
    ld   e, a
    ld   a, $00
    adc  d
    ld   d, a

    pop  bc
    dec  c
    push bc
    ld   c, 8
    jr   nz, .tilemaploop
    pop  bc

    ret

setupLCDCInterruptForBattle:
    ld  a, LOW(LCDCbattleInterrupt)
    ldh [$FF81], a
    ld  a, HIGH(LCDCbattleInterrupt)
    ldh [$FF82], a
    ld  a, 64
    ldh [hPlayerGfxX], a
    ld  a, ENEMY_GFX_X_START
    ldh [hEnemyGfxX], a

    ld  a, 0
    ldh [rLYC], a
    xor a
    ldh [rIF], a
    ld  a, 3
    ldh [rIE], a

    ld   a, 0
    ldh  [rWY], a

    ret
