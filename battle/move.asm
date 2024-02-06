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
    call umul8_16 ; * attack
    push hl
    ldh  a, [hTMPA]
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
    ;TODO: Type effectiveness

    ;Add some randomness (+0%-15%)
    push bc
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

    ret
