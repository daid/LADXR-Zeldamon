calculateTotalExpGain:
    ld   c, 6  ; start index
    ld   b, 6  ; loop amount
    ld   hl, 0 ; final result
    push hl

.loop:
    ld   a, c
    ldhl_add_a sMonType
    ld   a, [hl]
    cp   $FF
    jr   z, .skip

    ld   a, c
    push bc
    call getBaseStatsTable
    ld   bc, STAT_EXP_OFFSET
    add  hl, bc
    ld   d, 0
    ld   a, BANK(monsterBaseStats)
    call bankedReadInc
    ld   e, a
    pop  bc

    push bc
    ld   a, c
    call getMonLevel
    call umul8_16 ; level * exp_rate
    ld16_bc_hl
    ld   de, 7    ; / 7
    call udiv16
    ld16_hl_bc
    pop  bc

    pop  de
    add  hl, de ; add to total
    push hl
.skip:
    inc c
    dec b
    jr  nz, .loop

    ; Total exp is on the stack, now we need to find out how many party members are alive and participated.
    ld  c, 6
    ld  b, $01
    ld  de, 0
.participationLoop:
    ld  a, [sPlayerMonParticipated]
    and b
    jr  z, .skipParticipation
    ld  a, 6
    sub c
    add a, a
    ldhl_add_a sMonHP
    ld  a, [hl+]
    or  [hl]
    jr  z, .skipParticipation
    inc e
.skipParticipation:
    rlc b
    dec c
    jr  nz, .participationLoop

    pop bc ; final result
    call udiv16 ; / [amount of participants]
    ret


; Give DE exp to participants
giveExpToParticipants:
    ld  c, 6
    ld  b, $01
.participationLoop:
    ld  a, [sPlayerMonParticipated]
    and b
    jr  z, .skipParticipation
    ld  a, 6
    sub c
    add a, a
    ldhl_add_a sMonHP
    ld  a, [hl+]
    or  [hl]
    jr  z, .skipParticipation

    ; Get current level
    push de
    push bc
    ld  a, 6
    sub c
    call getMonLevel
    ldh  [hTMP3], a
    pop  bc
    pop  de

    ; Add exp
    ld  a, 6
    sub c
    ld  h, a
    add a, a
    add a, h
    ldhl_add_a sMonExp + 2
    ld  a, [hl]
    add a, e
    ld  [hl-], a
    ld  a, [hl]
    adc a, d
    ld  [hl-], a
    ld  a, [hl]
    adc a, 0
    ld  [hl-], a

    ; Get new level
    push de
    push bc
    ld  a, 6
    sub c
    call getMonLevel
    pop  bc
    ld   h, a
    ldh  [hTMP9], a
    ldh  a, [hTMP3]
    cp   h
    call nz, handleLevelUp
    pop  de

.skipParticipation:
    rlc b
    dec c
    jr  nz, .participationLoop
    ret


handleLevelUp:
    ; Show level up of mon[6-c]
    push bc
    call drawBlackBottomBar

    pop  bc
    push bc
    ld   a, 6
    sub  c
    call getMonName
    ld   hl, $9800 + $20 * 15 + 2
    ld   c, 8
    call drawTextLengthDark

    DRAW_TEXT_DARK 2, 16, i"Level up!"
    call waitForKeypressOrTimeout
    pop  bc
    push bc

    ; Check if we need to learn a new move
    ld   a, 6
    sub  c
    call getBaseStatsTable
    ld   bc, STAT_MOVE_LEARN_OFFSET
    add  hl, bc
    ld   a, BANK(monsterBaseStats)
    call bankedReadHL
    ldh  a, [hTMP9]
    ld   c, a
.checkNextMove:
    ld   a, BANK(monsterBaseStats)
    call bankedReadInc
    inc  hl
    and  a
    jp   z, .newMovesDone
    cp   c
    jr   nz, .checkNextMove

    ; Give a new move
    dec  hl
    ld   a, BANK(monsterBaseStats)
    call bankedReadInc
    ldh  [hTMP9], a ; Store the new move.
    call drawBlackBottomBar
    DRAW_TEXT_DARK 2, 15, i"Learned move"
    ldh  a, [hTMP9]
    ld   de, MOVE_ENTRY_SIZE
    call umul8_16
    ld   de, movesTable
    add  hl, de
    ld   a, BANK(movesTable)
    call bankedReadDEInc
    ld   hl, $9800 + $20 * 16 + 2
    call drawTextDark
    call waitForKeypressOrTimeout

    ; Find a free move slot to put the move in.
    pop  bc
    push bc
    ld   a, 6
    sub  c
    add  a, a
    add  a, a
    ldhl_add_a sMonMoves
    ld   c, 4
.findEmptySlotLoop:
    ld   a, [hl+]
    and  a
    jr   z, .giveMove
    dec  c
    jr   nz, .findEmptySlotLoop
    ; No empty slot found, ask the player to remove a move
    call drawBlackBottomBar
    DRAW_TEXT_DARK 1, 15, i"Already has 4 moves"
    DRAW_TEXT_DARK 2, 16, i"Forget a move?"
    call waitForKeypressOrTimeout

    .battleFight:
    call drawBlackBottomBar

    xor  a
    ldh  [hTMP4], a

.drawMovesLoop:
    pop  bc
    push bc
    ld   a, 6
    sub  a, c
    add  a, a
    add  a, a
    ldhl_add_a sMonMoves
    ldh  a, [hTMP4]
    add  a, l
    ld   l, a

    ld   a, [hl]
    ld   de, MOVE_ENTRY_SIZE
    call umul8_16
    ld   de, movesTable
    add  hl, de
    ld   e, [hl]
    inc  hl
    ld   d, [hl]

    push de
    ld   de, $20
    ldh  a, [hTMP4]
    call umul8_16
    ld   de, $9800 + $20 * 14 + 2
    add  hl, de
    pop  de
    call drawTextDark

    ldh  a, [hTMP4]
    inc  a
    ldh  [hTMP4], a
    cp   4
    jr   nz, .drawMovesLoop

    ld   hl, movesMenuInfo
    call runMenu
    jp   z, .newMovesDone
    ldhl_add_a sMonMoves + 1 ; The +1 is because .giveMove does hl-
    pop  bc
    push bc
    ld   a, 6
    sub  a, c
    add  a, a
    add  a, a
    add  a, l
    ld   l, a

.giveMove:
    dec  hl
    ldh  a, [hTMP9]
    ld   [hl], a
    ld   bc, sMonMovePP - sMonMoves
    add  hl, bc
    push hl
    ldh  a, [hTMP9]
    ld   de, MOVE_ENTRY_SIZE
    call umul8_16
    ld   de, movesTable + MOVE_PP_OFFSET
    add  hl, de
    ld   a, BANK(movesTable)
    call bankedRead
    pop  hl
    ld   [hl], a ; Store the new PP value

.newMovesDone:
    pop  bc
    ret

giveEVToParticipants:
    ld  a, 0
    ldh [hTMP0], a ; HPEV+
    ldh [hTMP1], a ; AtkEV+
    ldh [hTMP2], a ; DefEV+
    ldh [hTMP3], a ; SpdEV+
    ldh [hTMP4], a ; SpcEV+

    ; For each enemy mon, add one EV
    ld  hl, sMonType + 6
    ld  c, 6
.enemyLoop:
    ld  a, [hl]
    cp  $FF
    jr  z, .skipEnemy
    push hl
    push bc
    ld   hl, hTMP0
    inc  [hl]
    inc  hl
    inc  [hl]
    inc  hl
    inc  [hl]
    inc  hl
    inc  [hl]
    inc  hl
    inc  [hl]

    ld   de, STAT_ENTRY_SIZE
    call umul8_16
    ld   de, monsterBaseStats
    add  hl, de
    push hl

    ; Find the highest base stats for this mon.
    xor  a
    ld   d, a
    ld   e, a

    ld   c, 5
.findhighestloop:
    ld   a, BANK(monsterBaseStats)
    call bankedReadInc
    cp   d
    jr   c, .compare2
    jr   z, .done
    ld   e, d
    ld   d, a ; highest value
    jr   .done
.compare2:
    cp   e
    jr   c, .done
    ld   e, a ; 2nd highest value
.done:
    dec  c
    jr   nz, .findhighestloop

    ; Highest two stat numbers are now in d and e
    ; Now find the index of each of these
    pop  hl

    ld   c, 5
.increaseEVincloop:
    ld   a, BANK(monsterBaseStats)
    call bankedReadInc
    cp   d
    jr   nz, .inccompare2
    ; this is the highest value, add 2 to the hTMP related to this.
    push hl
    ld   h, HIGH(hTMP0)
    ld   a, LOW(hTMP0 + 5)
    sub  c
    ld   l, a
    inc  [hl]
    inc  [hl]
    pop  hl
    jr   .incdone
.inccompare2:
    cp   e
    jr   nz, .incdone
    ; this is the 2nd highest value, add 1 to the hTMP releated to this.
    push hl
    ld   h, HIGH(hTMP0)
    ld   a, LOW(hTMP0 + 5)
    sub  c
    ld   l, a
    inc  [hl]
    pop  hl
.incdone:
    dec  c
    jr   nz, .increaseEVincloop

    pop  bc
    pop  hl
.skipEnemy:
    inc hl
    dec c
    jr  nz, .enemyLoop

    ; Now we have all the EV increases we want in hTMP0 to hTMP4, so see if we should add them.
    ld  c, 6
    ld  b, $01
.participationLoop:
    ld  a, [sPlayerMonParticipated]
    and b
    jp  z, .skipParticipation

    ld  a, 6
    sub c
    add a, a
    ldhl_add_a sMonHP
    ld  a, [hl+]
    or  [hl]
    jp  z, .skipParticipation

    ; First check total EV points (hl=total, de=add)
    ld  h, 0
    ld  l, h
    ld  d, h

    ld  a, 6
    sub c
    ldde_add_a sMonHPEV
    ld  a, [de]
    ld  e, a
    ld  d, 0
    add hl, de

    ld  a, 6
    sub c
    ldde_add_a sMonAtkEV
    ld  a, [de]
    ld  e, a
    ld  d, 0
    add hl, de

    ld  a, 6
    sub c
    ldde_add_a sMonDefEV
    ld  a, [de]
    ld  e, a
    ld  d, 0
    add hl, de

    ld  a, 6
    sub c
    ldde_add_a sMonSpdEV
    ld  a, [de]
    ld  e, a
    ld  d, 0
    add hl, de

    ld  a, 6
    sub c
    ldde_add_a sMonSpcEV
    ld  a, [de]
    ld  e, a
    ld  d, 0
    add hl, de

    ld  a, h
    cp  2   ; We have 512 or more EV points, skip adding more.
    jr  nc, .skipParticipation

    ; Add the EV points totals
    ld  a, 6
    sub c
    ldhl_add_a sMonHPEV
    ldh a, [hTMP0]
    add a, [hl]
    ld  [hl], a

    ld  a, 6
    sub c
    ldhl_add_a sMonAtkEV
    ldh a, [hTMP1]
    add a, [hl]
    ld  [hl], a

    ld  a, 6
    sub c
    ldhl_add_a sMonDefEV
    ldh a, [hTMP2]
    add a, [hl]
    ld  [hl], a

    ld  a, 6
    sub c
    ldhl_add_a sMonSpdEV
    ldh a, [hTMP3]
    add a, [hl]
    ld  [hl], a

    ld  a, 6
    sub c
    ldhl_add_a sMonSpcEV
    ldh a, [hTMP4]
    add a, [hl]
    ld  [hl], a

.skipParticipation:
    rlc b
    dec c
    jp  nz, .participationLoop
    ret
