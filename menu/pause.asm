
; Menu that opens with select
pauseMenu:
    farcall storeTilemapVRAMtoSRAM
    farcall loadFontGraphics
    farcall clearOAM
    farcall blankAllTiles
    ld   de, battlePalette
    farcall loadBGPalDE
    ld   de, battlePalette + 64
    farcall loadObjPalDE

.loop:
    farcall blankAllTiles
    farcall drawBlackBottomBar

    farcall selectPartyMember
    cp   $FF
    jp   z, .exit
    ldh  [hTMP5], a

    ; mon selected, show options for:
    DRAW_TEXT_DARK 2, 15, i"Stats"
    DRAW_TEXT_DARK 2, 16, i"Switch"
    DRAW_TEXT_DARK 10, 15, i"Dismiss"
    DRAW_TEXT_DARK 10, 16, i"Exit"
    farcall runMenu2x2
    cp   $FF
    jp   z, .exit
    rst  0
    dw   .stats
    dw   .switch
    dw   .dismiss
    dw   .exit

.stats:
    farcall blankAllTiles

    ldh  a, [hTMP5]
    ld   b, a
    farcall getBaseStatsTableB
    push hl
    ld   de, STAT_FRONT_GFX_OFFSET
    add  hl, de
    ld   de, $9800
    ld   c, $90
    farcallX loadMonsterGFX

    pop  hl
    ld   de, STAT_TYPE_OFFSET
    add  hl, de
    ld   a, BANK(monsterBaseStats)
    call bankedReadInc
    push hl
    ld   c, a
    push bc
    add  a, a
    add  a, LOW(typeLabels)
    ld   l, a
    adc  HIGH(typeLabels)
    sub  l
    ld   h, a
    ld   a, [hl+]
    ld   d, [hl]
    ld   e, a
    ld   hl, $988A
    call drawTextLight
    pop  bc
    pop  hl

    ld   a, BANK(monsterBaseStats)
    call bankedReadInc
    cp   c
    jr   z, .skip2ndType
    add  a, a
    add  a, LOW(typeLabels)
    ld   l, a
    adc  HIGH(typeLabels)
    sub  l
    ld   h, a
    ld   a, [hl+]
    ld   d, [hl]
    ld   e, a
    ld   hl, $98AA
    call drawTextLight
.skip2ndType:

    ldh  a, [hTMP5]
    ldhl_add_a sMonType
    ld   b, 0
    ld   c, [hl]
    ld   hl, $9905
    farcallX drawNumberLight
    ld   de, $10000 - 2
    add  hl, de
    ld   de, i"No."
    call drawTextLight

    ; Level
    ldh  a, [hTMP5]
    farcallX getMonLevel
    ld   b, 0
    ld   hl, $9832
    farcallX drawNumberLight
    ld   bc, $DB08
    call writeToTilemap

    ; HP
    ldh  a, [hTMP5]
    farcallX getMaxHP
    ld   hl, $9852
    farcallX drawNumberLight
    ld   bc, $DA08
    call writeToTilemap
    dec  hl

    push hl
    ld   a, [hTMP5]
    add  a, a
    ldhl_add_a sMonHP
    ld   a, [hl+]
    ld   b, [hl]
    ld   c, a
    pop  hl
    farcallX drawNumberLight
    ld   de, $10000 - 2
    add  hl, de
    ld   de, i"HP:"
    call drawTextLight

    ; TODO: Display Exp

    ; Base stats
    DRAW_TEXT_LIGHT 1, 10, i"Attack:"
    ld   a, [hTMP5]
    farcallX getMonAttack
    ld   b, 0
    ld   c, a
    ld   hl, $9967
    farcallX drawNumberLight

    DRAW_TEXT_LIGHT 1, 12, i"Defense:"
    ld   a, [hTMP5]
    farcallX getMonDefense
    ld   b, 0
    ld   c, a
    ld   hl, $99A7
    farcallX drawNumberLight

    DRAW_TEXT_LIGHT 1, 14, i"Speed:"
    ld   a, [hTMP5]
    farcallX getMonSpeed
    ld   b, 0
    ld   c, a
    ld   hl, $99E7
    farcallX drawNumberLight

    DRAW_TEXT_LIGHT 1, 16, i"Special:"
    ld   a, [hTMP5]
    farcallX getMonSpecial
    ld   b, 0
    ld   c, a
    ld   hl, $9A27
    farcallX drawNumberLight

    ; Moves
    ld   a, [hTMP5]
    add  a, a
    add  a, a
    ldhl_add_a sMonMoves

    ld   a, [hl+]
    push hl
    ld   de, MOVE_ENTRY_SIZE
    call umul8_16
    ld   de, movesTable
    add  hl, de
    ld   a, BANK(movesTable)
    call bankedReadDEInc
    push hl
    ld   hl, $994A
    farcallXY drawTextLight, BANK(movesTable)
    pop  hl
    ld   de, MOVE_PP_OFFSET - 2
    add  hl, de
    ld   a, BANK(movesTable)
    call bankedReadInc
    ld   c, a
    ld   b, 0
    ld   hl, $9973
    farcallX drawNumberLight
    ld   bc, $DA08
    call writeToTilemap
    dec  hl
    ldh  a, [hTMP5]
    add  a, a
    add  a, a
    ldde_add_a sMonMovePP
    ld   a, [de]
    ld   c, a
    ld   b, 0
    farcallX drawNumberLight
    pop  hl

    ld   a, [hl+]
    push hl
    ld   de, MOVE_ENTRY_SIZE
    call umul8_16
    ld   de, movesTable
    add  hl, de
    ld   a, BANK(movesTable)
    call bankedReadDEInc
    push hl
    ld   hl, $998A
    farcallXY drawTextLight, BANK(movesTable)
    pop  hl
    ld   de, MOVE_PP_OFFSET - 2
    add  hl, de
    ld   a, BANK(movesTable)
    call bankedReadInc
    ld   c, a
    ld   b, 0
    ld   hl, $99B3
    farcallX drawNumberLight
    ld   bc, $DA08
    call writeToTilemap
    dec  hl
    ldh  a, [hTMP5]
    add  a, a
    add  a, a
    ldde_add_a sMonMovePP + 1
    ld   a, [de]
    ld   c, a
    ld   b, 0
    farcallX drawNumberLight
    pop  hl

    ld   a, [hl+]
    push hl
    ld   de, MOVE_ENTRY_SIZE
    call umul8_16
    ld   de, movesTable
    add  hl, de
    ld   a, BANK(movesTable)
    call bankedReadDEInc
    push hl
    ld   hl, $99CA
    farcallXY drawTextLight, BANK(movesTable)
    pop  hl
    ld   de, MOVE_PP_OFFSET - 2
    add  hl, de
    ld   a, BANK(movesTable)
    call bankedReadInc
    ld   c, a
    ld   b, 0
    ld   hl, $99F3
    farcallX drawNumberLight
    ld   bc, $DA08
    call writeToTilemap
    dec  hl
    ldh  a, [hTMP5]
    add  a, a
    add  a, a
    ldde_add_a sMonMovePP + 2
    ld   a, [de]
    ld   c, a
    ld   b, 0
    farcallX drawNumberLight
    pop  hl

    ld   a, [hl+]
    push hl
    ld   de, MOVE_ENTRY_SIZE
    call umul8_16
    ld   de, movesTable
    add  hl, de
    ld   a, BANK(movesTable)
    call bankedReadDEInc
    push hl
    ld   hl, $9A0A
    farcallXY drawTextLight, BANK(movesTable)
    pop  hl
    ld   de, MOVE_PP_OFFSET - 2
    add  hl, de
    ld   a, BANK(movesTable)
    call bankedReadInc
    ld   c, a
    ld   b, 0
    ld   hl, $9A33
    farcallX drawNumberLight
    ld   bc, $DA08
    call writeToTilemap
    dec  hl
    ldh  a, [hTMP5]
    add  a, a
    add  a, a
    ldde_add_a sMonMovePP + 3
    ld   a, [de]
    ld   c, a
    ld   b, 0
    farcallX drawNumberLight
    pop  hl

    farcall waitForKeypress
    jp .exit

.switch:
    farcall blankAllTiles
    farcall drawBlackBottomBar
    DRAW_TEXT_DARK 2, 15, i"Switch with?"

    farcall selectPartyMember
    cp   $FF
    jp   z, .loop
    ; Swap the mons by using first enemy party slot as temporary storage
    ldh  [hTMP6], a
    ldh  a, [hTMP5]
    ld   b, a
    ld   c, 6
    farcall copyMon
    ldh  a, [hTMP4]
    ld   b, a
    ldh  a, [hTMP5]
    ld   c, a
    farcall copyMon
    ld   b, 6
    ldh  a, [hTMP4]
    ld   c, a
    farcall copyMon

    jp   .loop

.dismiss:
    ld   c, 6
    ld   b, 0
    ld   hl, sMonType
.dismissMonCountLoop:
    ld   a, [hl+]
    cp   $FF
    jr   z,  .dismissMonCountNoMon
    inc  b
.dismissMonCountNoMon:
    dec  c
    jr   nz, .dismissMonCountLoop
    ld   a, b
    cp   2
    jp   c, .loop

    farcall drawBlackBottomBar
    DRAW_TEXT_DARK 2, 15, i"Are you sure?"
    DRAW_TEXT_DARK 2, 16, i"Cancel"
    DRAW_TEXT_DARK 10, 16, i"Yes"

    farcall runMenu2x1
    ldh  a, [hTMP4]
    cp   1 ; yes
    jp   nz, .loop
    ldh  a, [hTMP5]
    ldhl_add_a sMonType
    ld   [hl], $FF
    jp   .loop

.exit:
    farcall blankAllTiles
    farcall restoreVRAM2
    farcall restoreTilemapVRAMfromSRAM
    ret

typeLabels:
    dw i"Normal"
    dw i"Fighting"
    dw i"Flying"
    dw i"Poison"
    dw i"Ground"
    dw i"Rock"
    dw i"Bird"
    dw i"Bug"
    dw i"Ghost"
    dw i"Special"
    dw i"Fire"
    dw i"Water"
    dw i"Grass"
    dw i"Electric"
    dw i"Psychic"
    dw i"Ice"
    dw i"Dragon"
