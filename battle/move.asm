executeMove:
    ldh  a, [hTMPC]
    ld   c, a
    ld   a, MOVE_STRUGGLE ; If we have no PP, we use struggle.
    ldh  [hTMPC], a
    ldh  a, [hTMPA]
    add  a, a
    add  a, a
    add  a, c
    ldhl_add_a sMonMovePP
    xor  a
    cp   [hl]
    jr   z, .noPP
    dec  [hl]
    ld   de, sMonMoves - sMonMovePP + $10000
    add  hl, de
    ld   a, [hl]
    ldh  [hTMPC], a
.noPP:
    ; Movetable index is now in hTMPC
    call drawBlackBottomBar
    ldh  a, [hTMPA]
    call getMonName
    ld   hl, $9800 + $20 * 15 + 2
    ld   c, 8
    call drawTextLengthDark
    DRAW_TEXT_DARK 2, 16, i"Used"

    ldh  a, [hTMPC]
    ld   de, MOVE_ENTRY_SIZE
    call umul8_16
    ld   de, movesTable
    add  hl, de
    ld   e, [hl]
    inc  hl
    ld   d, [hl]
    ld   hl, $9800 + $20 * 16 + 7
    call drawTextDark

    ldh  a, [hTMPA]
    call getMonLevel
    add  a, a ; level * 2
    ld   c, a
    ld   b, 0
    ld   de, 5
    call udiv16 ; / 5
    inc  bc
    inc  bc
    push bc

    ldh  a, [hTMPC]
    ld   de, MOVE_ENTRY_SIZE
    call umul8_16
    ld   de, movesTable + MOVE_POWER_OFFSET
    add  hl, de
    ld   a, [hl]

    pop  de
    call umul8_16 ; * power
    push hl
    ldh  a, [hTMPA]
    call getMonAttack
    pop  de
    call umul8_16 ; * attack (TODO: This can overflow on high levels)
    push hl
    ldh  a, [hTMPB]
    call getMonDefense
    ld   e, a
    ld   d, 0
    pop  bc
    call udiv16 ; / defense
    ld   de, 50
    call udiv16 ; / 50
    inc  bc
    inc  bc ; +2

    ;TODO: STAB
    ; Type effectiveness (only first type right now)
    push bc
    ldh  a, [hTMPC]
    ld   de, MOVE_ENTRY_SIZE
    call umul8_16
    ld   de, movesTable + MOVE_TYPE_OFFSET
    add  hl, de
    ld   a, [hl]
    swap a
    ld   hl, moveTypeEffectiveness
    ld   c, a
    ld   b, 0
    add  hl, bc
    push hl
    ldh  a, [hTMPA]
    call getBaseStatsTable
    ld   de, STAT_TYPE_OFFSET
    add  hl, de
    ld   a, BANK(monsterBaseStats)
    call bankedReadInc
    ld   e, a
    ld   d, 0
    pop  hl
    add  hl, de
    ld   a, [hl]
    ldh  [hTMPD], a
    ; Type effectiveness is now in A
    pop  de ; pop current damage
    call umul8_16 ; multiply by effectiveness and then divide by 2
    srl  h
    rr   l

    ;Add some randomness (+0%-15%)
    push hl
    call GetRandomByte
    and  $0F
    ld16_de_bc
    call umul8_16
    ld16_bc_hl
    ld   de, 100
    call udiv16
    pop  hl
    add  hl, bc
    ld16_bc_hl

    ; Subtract the damage from HP.
    ldh  a, [hTMPB]
    add  a, a
    ldhl_add_a sMonHP
    ld   a, [hl+]
    sub  c
    ld   e, a
    ld   a, [hl]
    sbc  b
    ld   [hl-], a
    ld   [hl], e
    jr   nc, .notNeg ; if HP is now negative, set it to zero
    xor  a
    ld   [hl+], a
    ld   [hl+], a
.notNeg:

    ldh  a, [hTMPD]
    cp   4
    jr   z, .superEffective
    cp   1
    jr   z, .notEffective
    cp   0
    jr   z, .noEffect
    ret

.notEffective:
    call drawBlackBottomBar
    DRAW_TEXT_DARK 2, 15, i"It is not very"
    DRAW_TEXT_DARK 2, 16, i"effective"
    call waitForKeypressOrTimeoutVeryShort
    ret

.superEffective:
    call drawBlackBottomBar
    DRAW_TEXT_DARK 2, 15, i"It is super"
    DRAW_TEXT_DARK 2, 16, i"effective"
    call waitForKeypressOrTimeoutVeryShort
    ret

.noEffect:
    call drawBlackBottomBar
    DRAW_TEXT_DARK 2, 15, i"It has no"
    DRAW_TEXT_DARK 2, 16, i"effect"
    call waitForKeypressOrTimeoutVeryShort
    ret

moveTypeEffectiveness:
;    NORMAL FIGHTING FLYING POISON GROUND ROCK BUG GHOST FIRE WATER GRASS ELECTRIC PSYCHIC ICE DRAGON
    db 2, 2, 2, 2, 2, 1, 2, 0, 2, 2, 2, 2, 2, 2, 2, 0 ; Normal
    db 4, 2, 1, 1, 2, 4, 1, 0, 2, 2, 2, 2, 1, 4, 2, 0 ; Fighting
    db 2, 4, 2, 2, 2, 1, 4, 2, 2, 2, 4, 1, 2, 2, 2, 0 ; Flying
    db 2, 2, 2, 1, 1, 1, 4, 1, 2, 2, 4, 2, 2, 2, 2, 0 ; Poison
    db 2, 2, 0, 4, 2, 4, 1, 2, 4, 2, 1, 4, 2, 2, 2, 0 ; Ground
    db 2, 1, 4, 2, 1, 2, 4, 2, 4, 2, 2, 2, 2, 4, 2, 0 ; Rock
    db 2, 1, 1, 4, 2, 2, 2, 1, 1, 2, 4, 2, 4, 2, 2, 0 ; Bug
    db 0, 2, 2, 2, 2, 2, 2, 4, 2, 2, 2, 2, 0, 2, 2, 0 ; Ghost
    db 2, 2, 2, 2, 2, 1, 4, 2, 1, 1, 4, 2, 2, 4, 1, 0 ; Fire
    db 2, 2, 2, 2, 4, 4, 2, 2, 4, 1, 1, 2, 2, 2, 1, 0 ; Water
    db 2, 2, 1, 1, 4, 4, 1, 2, 1, 4, 1, 2, 2, 2, 1, 0 ; Grass
    db 2, 2, 4, 2, 0, 2, 2, 2, 2, 4, 1, 1, 2, 2, 1, 0 ; Electric
    db 2, 4, 2, 4, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 0 ; Psychic
    db 2, 2, 4, 2, 4, 2, 2, 2, 2, 1, 4, 2, 2, 1, 4, 0 ; Ice
    db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4, 0 ; Dragon
