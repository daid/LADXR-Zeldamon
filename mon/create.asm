
; Create a new mon at index A of level C with type B
createMon:
    ldh  [hTMP4], a
    ld   a, c
    ldh  [hTMP5], a
    ldh  a, [hTMP4]
    ; Set the monster type
    ldhl_add_a sMonType

    ; Find how much exp this monster should have at this level
    ld   [hl], b
    ld   b, 0
    ld   hl, expTableZero
    add  hl, bc
    add  hl, bc
    add  hl, bc
    push hl

    ; Store the exp
    ldh  a, [hTMP4]
    ld   c, a
    add  a, a
    add  a, c
    ldhl_add_a sMonExp
    pop  de
    ld   a, [de]
    inc  de
    ld   [hl+], a
    ld   a, [de]
    inc  de
    ld   [hl+], a
    ld   a, [de]
    inc  de
    ld   [hl+], a

    ; Set the max HP value.
    ld   a, c
    call getMaxHP
    ldh  a, [hTMP4]
    add  a, a
    ldhl_add_a sMonHP
    ld   [hl], c
    inc  hl
    ld   [hl], b

    ; Set EV value to 0
    ldh  a, [hTMP4]
    ldhl_add_a sMonHPEV
    ld   [hl], 0

    ldh  a, [hTMP4]
    ldhl_add_a sMonAtkEV
    ld   [hl], 0

    ldh  a, [hTMP4]
    ldhl_add_a sMonDefEV
    ld   [hl], 0

    ldh  a, [hTMP4]
    ldhl_add_a sMonSpdEV
    ld   [hl], 0

    ldh  a, [hTMP4]
    ldhl_add_a sMonSpcEV
    ld   [hl], 0

    ; Set IV value
    ldh  a, [hTMP4]
    ldhl_add_a sMonHPIV
    call GetRandomByte
    and  $1F
    ld   [hl], a

    ldh  a, [hTMP4]
    ldhl_add_a sMonAtkIV
    call GetRandomByte
    and  $1F
    ld   [hl], a

    ldh  a, [hTMP4]
    ldhl_add_a sMonDefIV
    call GetRandomByte
    and  $1F
    ld   [hl], a

    ldh  a, [hTMP4]
    ldhl_add_a sMonSpdIV
    call GetRandomByte
    and  $1F
    ld   [hl], a

    ldh  a, [hTMP4]
    ldhl_add_a sMonSpcIV
    call GetRandomByte
    and  $1F
    ld   [hl], a

    ldh  a, [hTMP4]
    add  a, a
    add  a, a
    ldhl_add_a sMonMoves
    push hl
    ldh  a, [hTMP4]
    call getBaseStatsTable
    ld   bc, STAT_MOVES_OFFSET
    add  hl, bc
    pop  de
    ld   c, 4
.copyMovesLoop:
    ld   a, BANK(monsterBaseStats)
    call bankedReadInc
    ld   [de], a
    inc  de
    dec  c
    jr   nz, .copyMovesLoop

    ; Give moves of higher levels
    ld   a, BANK(monsterBaseStats)
    call bankedReadHL
.extraMovesLoop:
    ld   a, BANK(monsterBaseStats)
    call bankedReadDEInc ; get level in E and move in D
    ld   a, e
    and  a, a
    jr   z, .extraMovesDone
    ldh  a, [hTMP5]
    cp   e
    jr   c, .extraMovesDone
    push hl
    ; Add the move D to the moves table
    ;  First check if there is a free spot
    ld   a, [hTMP4]
    add  a, a
    add  a, a
    ldhl_add_a sMonMoves
    ld   c, 4
.addExtraMoveSearchFreeSlot:
    ld   a, [hl+]
    and  a, a
    jr   z, .addExtraMoveHLminus
    dec  c
    jr   nz, .addExtraMoveSearchFreeSlot

    ; No free slot found, shift all the moves and add move to the last slot.
    ld   a, [hTMP4]
    add  a, a
    add  a, a
    ldhl_add_a sMonMoves
    ld16_bc_hl
    inc  hl
    ld   a, [hl+]
    ld   [bc], a
    inc  bc
    ld   a, [hl+]
    ld   [bc], a
    inc  bc
    ld   a, [hl+]
    ld   [bc], a
    inc  bc

.addExtraMoveHLminus:
    dec  hl
    ld   [hl], d

    pop  hl
    jr   .extraMovesLoop
.extraMovesDone:

    ; Set PP value of each move
    ldh  a, [hTMP4]
    add  a, a
    add  a, a
    ldhl_add_a sMonMoves
    ld   c, 4
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

    ; Set default name
    ldh  a, [hTMP4]
    call getBaseStatsTable
    ld   bc, STAT_NAME_OFFSET
    add  hl, bc
    ldh  a, [hTMP4]
    call getMonName
    ld   c, 8
.copyNameLoop:
    ld   a, BANK(monsterBaseStats)
    call bankedReadInc
    ld   [de], a
    inc  de
    dec  c
    jr   nz, .copyNameLoop

    ret
