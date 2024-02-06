
healAllMon:
    ld   d, 6
.healLoop:
    ld   a, 6
    sub  d
    ldhl_add_a sMonType
    ld   a, [hl]
    cp   $FF
    jr   z, .skipHeal
    ld   a, 6
    sub  d

    ; Set HP=MaxHP
    push de
    call getMaxHP
    pop  de
    ld   a, 6
    sub  d
    add  a, a
    ldhl_add_a sMonHP
    ld   [hl], c
    inc  hl
    ld   [hl], b

    ; For each move set the PP values
    ld   a, 6
    sub  d
    add  a, a
    add  a, a
    ldhl_add_a sMonMoves
    ld   c, 4
    push de
.setPPloop:
    ld   a, [hl]
    push bc
    push hl
    ld   de, MOVE_ENTRY_SIZE
    call umul8_16
    ld   de, movesTable + MOVE_PP_OFFSET
    add  hl, de
    ld   a, [hl]
    pop  hl
    push hl
    ld   de, sMonMovePP - sMonMoves
    add  hl, de
    ld   [hl], a
    pop  hl
    inc  hl
    pop  bc
    dec  c
    jr   nz, .setPPloop
    pop  de

.skipHeal:
    dec  d
    jr   nz, .healLoop

    ret
