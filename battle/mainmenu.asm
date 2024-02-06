
;Switch the player monster index.
; New index should be loaded in sPlayerActiveMon already. This just does the visual bits.
switchInPlayerMon:
    ld   a, [sPlayerActiveMon]
    call getBaseStatsTable
    ld   de, STAT_BACK_GFX_OFFSET
    add  hl, de
    ld   de, $98C0
    ld   c, $94
    call loadMonsterGFX

    call battleShiftInPlayer

    ld   hl, $9DA1
    ld   a, [sPlayerActiveMon]
    call getMonName
    ld   c, 8
    call drawTextLengthLight

    call battleUpdateHPBarSizes
    call battleDrawHPBars
    call battleDrawPlayerHPValue

    ld   a, [sPlayerActiveMon]
    call getMonLevel
    ld   b, 0
    ld   hl, $9D47
    call drawNumberLight
    ld   bc, $DB08
    call writeToTilemap

    ret

switchInEnemyMon:
    ld   a, [sEnemyActiveMon]
    call getBaseStatsTable
    ld   de, STAT_FRONT_GFX_OFFSET
    add  hl, de
    ld   de, $9C00
    ld   c, $90
    call loadMonsterGFX

    call battleShiftInEnemy

    ld   hl, $9804
    ld   a, [sEnemyActiveMon]
    call getMonName
    ld   c, 8
    call drawTextLengthLight

    call battleUpdateHPBarSizes
    call battleDrawHPBars
    call battleDrawPlayerHPValue

    ld   a, [sEnemyActiveMon]
    call getMonLevel
    ld   b, 0
    ld   hl, $984A
    call drawNumberLight
    ld   bc, $DB08
    call writeToTilemap

    ret

allPlayersDead:
    call drawBlackBottomBar
    DRAW_TEXT_DARK 2, 15, i"You faint..."
    call waitForKeypressOrTimeout

    call healAllMon

    xor  a
    ld   [$DB5A], a ; set link HP to zero
    ld   hl, $DB5F ; set spawn location data
    ld   a, 1 ; indoor
    ld   [hl+], a
    ld   a, $10 ; house map
    ld   [hl+], a
    ld   a, [sLastZeldaCenterRoom]
    ld   [hl+], a
    ld   a, $38
    ld   [hl+], a
    ld   a, $3A
    ld   [hl+], a

    ; Set the result in TMP1
    ld   a, $00
    ldh  [hTMP1], a
    ret

allEnemiesDead:
    call drawBlackBottomBar
    DRAW_TEXT_DARK 2, 15, i"You win!"

    call calculateTotalExpGain
    ld   hl, $9800 + $20 * 16 + 5
    push bc
    call drawNumberDark
    DRAW_TEXT_DARK 7, 16, i"Exp gained"
    call waitForKeypressOrTimeout

    pop  de
    call giveExpToParticipants
    call giveEVToParticipants

    ; Set the result in TMP1
    ld   a, $02
    ldh  [hTMP1], a
    ret

; Run a battle, this function returns as soon as the battle is done:
; -By running away: hTMP1 = 1
; -By player death: hTMP1 = 0
; -By enemy death:  hTMP1 = 2
; -By enemy capture:hTMP1 = 3
battleMainMenu:
    ; Check if the current player mon is dead and needs replacement.
    ld   a, [sPlayerActiveMon]
    add  a, a
    ldhl_add_a sMonHP
    ld   a, [hl+]
    or   [hl]
    jr   nz, .playerAlive

    call drawBlackBottomBar
    ld   a, [sPlayerActiveMon]
    call getMonName
    ld   hl, $99E1
    ld   c, 8
    call drawTextLengthDark

    DRAW_TEXT_DARK 1, 16, i"Fell..."

    call battleShiftOutPlayer
    call waitForKeypressOrTimeoutShort

    call findAlivePlayerMon
    jp   z, allPlayersDead
    ld   a, b
    ld   [sPlayerActiveMon], a

    call switchInPlayerMon
.playerAlive:
    ; Check if the enemy is alive
    ld   a, [sEnemyActiveMon]
    add  a, a
    ldhl_add_a sMonHP
    ld   a, [hl+]
    or   [hl]
    jr   nz, .enemyAlive

    call drawBlackBottomBar
    ld   a, [sEnemyActiveMon]
    call getMonName
    ld   hl, $99E1
    ld   c, 8
    call drawTextLengthDark

    DRAW_TEXT_DARK 1, 16, i"Fell..."

    call battleShiftOutEnemy
    call waitForKeypressOrTimeoutShort

    call findAliveEnemyMon
    jp   z, allEnemiesDead
    ld   a, b
    ld   [sEnemyActiveMon], a

    call switchInEnemyMon
.enemyAlive:

    ; Always update which player mons have participated
    ld   a, [sPlayerActiveMon]
    inc  a
    ld   c, $80
.activeMonBitShiftLoop:
    rlc  c
    dec  a
    jr   nz, .activeMonBitShiftLoop
    ld   a, [sPlayerMonParticipated]
    or   c
    ld   [sPlayerMonParticipated], a

    call drawBlackBottomBar
    DRAW_TEXT_DARK 2, 15, i"Fight"
    DRAW_TEXT_DARK 2, 16, i"Item"
    DRAW_TEXT_DARK 10, 15, i"Switch"
    DRAW_TEXT_DARK 10, 16, i"Run"

.menuLoop:
    call runMenu2x2
    jr   z, .menuLoop
    rst  0
    dw .battleFight   ; fight
    dw .selectItemToUse ; item
    dw .changeMon ; change
    dw .runFromBattle ; run

.updateCursor:
    add  hl, de
    add  hl, de
    ld   a, [hl+]
    ld   h, [hl]
    ld   l, a
    call writeToTilemap
    ret

.changeMon:
    ; Disable the LCDC interrupt
    call waitVBlank
    ld   a, 1
    ldh  [rIE], a

    call blankAllTiles
    call drawBlackBottomBar
    DRAW_TEXT_DARK 1, 15, i"Who to bring out?"

    call selectPartyMember
    push af
    call blankAllTiles

    call drawBlackBottomBar

    ; Enable the LCDC interrupt
    call waitVBlank
    ld   a, 3
    ldh  [rIE], a

    call switchInEnemyMon
    call switchInPlayerMon

    pop  af
    jp   z, battleMainMenu ; canceled
    ld   hl, sPlayerActiveMon
    cp   [hl]
    jp   z, battleMainMenu ; same selected
    ld   [hl], a
    call battleShiftOutPlayer
    call switchInPlayerMon

    jp   .startEnemyAttack

.selectItemToUse:
    ; Disable the LCDC interrupt
    call waitVBlank
    ld   a, 1
    ldh  [rIE], a

    call blankAllTiles
    call drawBlackBottomBar
    DRAW_TEXT_DARK 1, 15, i"Which item to use?"

    ld   bc, sInvItems
    ld   hl, $9822
.selectItemToUseDrawLoop:
    ld   a, [bc]
    add  a, a
    jr   z, .selectItemToUseDrawDone
    push hl
    push bc
    ld   bc, itemNames
    add  a, c
    ld   c, a
    ld   a, b
    adc  a, 0
    ld   b, a
    ld   a, [bc]
    ld   e, a
    inc  bc
    ld   a, [bc]
    ld   d, a
    call drawTextLight
    ld   a, l
    or   $0F
    ld   l, a
    pop  bc
    inc  bc
    ld   a, [bc]
    inc  bc
    push bc
    ld   b, $00
    ld   c, a
    call drawNumberLight
    pop  bc
    pop  hl
    ld   de, $0020
    add  hl, de
    jr   .selectItemToUseDrawLoop

.selectItemToUseDrawDone:
    ld   hl, .selectItemToUseMenuInfo
    call runMenu
    push af

    call blankAllTiles
    call drawBlackBottomBar

    ; Enable the LCDC interrupt
    call waitVBlank
    ld   a, 3
    ldh  [rIE], a

    call switchInEnemyMon
    call switchInPlayerMon

    pop  af
    jp   z, battleMainMenu ; canceled
    add  a, a
    ldhl_add_a sInvItems
    xor  a
    ld   b, [hl]
    cp   [hl]
    jp   z, battleMainMenu ; no item selected
    inc  hl
    ld   a, [hl]
    cp   0
    jp   z, battleMainMenu ; count is zero
    dec  [hl]

    ld   a, b
    dec  a
    rst  0
    dw   useItemPotion
    dw   useItemBait

.selectItemToUseMenuInfo:
    db 8
    dw $7F00, $DC0D ; blank cursor tile, filled cursor tile
    dw $9821, $9841, $9861, $9881, $98A1, $98C1, $98E1, $9901, $9921


.runFromBattle:
    call drawBlackBottomBar
    ld   a, [sBattleType]
    and  a
    jr   nz, .runFromBattleFailed
    DRAW_TEXT_DARK 2, 15, i"You bravely"
    DRAW_TEXT_DARK 2, 16, i"run away"
    call waitForKeypressOrTimeout
    ; Set the result in TMP1
    ld   a, $01
    ldh  [hTMP1], a
    ret
.runFromBattleFailed:
    DRAW_TEXT_DARK 2, 15, i"You failed"
    DRAW_TEXT_DARK 2, 16, i"to run away"
    call waitForKeypressOrTimeout
    jp   .startEnemyAttack

.battleFight:
    call drawBlackBottomBar

    xor  a
    ldh  [hTMP4], a

.drawMovesLoop:
    ld   a, [sPlayerActiveMon]
    add  a, a
    add  a, a
    ldhl_add_a sMonMoves
    ldh  a, [hTMP4]
    add  a, l
    ld   l, a

    ld   a, [hl]
    ldh  [hTMP5], a
    ld   de, MOVE_ENTRY_SIZE
    call umul8_16
    ld   de, movesTable
    add  hl, de
    ld   e, [hl]
    inc  hl
    ld   d, [hl]
    ld   bc, MOVE_PP_OFFSET - 1
    add  hl, bc
    push hl ; push the pointer in the move table at the PP value

    push de
    ld   de, $20
    ldh  a, [hTMP4]
    call umul8_16
    ld   de, $9800 + $20 * 14 + 2
    add  hl, de
    pop  de
    call drawTextDark
    ; move hl to end of line
    ld   a, l
    and  $E0
    add  a, 17
    ld   l, a
    pop  de ; get the move max PP value pointer

    ldh  a, [hTMP5]
    and  a
    jr   z, .skipMoveDraw

    ld   a, [de]
    ld   c, a
    ld   b, 0
    call drawNumberDark
    ld   bc, $DD08
    call writeToTilemap
    dec  hl

    push hl
    ld   a, [sPlayerActiveMon]
    add  a, a
    add  a, a
    ldhl_add_a sMonMovePP
    ldh  a, [hTMP4]
    add  a, l
    ld   l, a
    ld   c, [hl]
    ld   b, 0
    pop  hl
    call drawNumberDark

.skipMoveDraw:
    ldh  a, [hTMP4]
    inc  a
    ldh  [hTMP4], a
    cp   4
    jr   nz, .drawMovesLoop

    ld   hl, movesMenuInfo
    call runMenu
    jp   z, battleMainMenu
    ldh  [hTMPC], a ; Store move index in TMPC

    ; Store attacker in TMPA and defender in TMPB
    ld   a, [sPlayerActiveMon]
    ldh  [hTMPA], a
    ld   a, [sEnemyActiveMon]
    ldh  [hTMPB], a
    call executeMove

    ; Temporary shake until we have battle animations
    ld   c, 16
.shakeloop:
    call $280D
    and  $07
    add  a, ENEMY_GFX_X_END - 3
    ldh  [hEnemyGfxX], a
    call waitVBlank
    dec  c
    jr   nz, .shakeloop
    ld   a, ENEMY_GFX_X_END
    ldh  [hEnemyGfxX], a
    call waitForKeypressOrTimeoutVeryShort

.startEnemyAttack:
    ; Enemy attack.
    ld   a, [sEnemyActiveMon]
    ldh  [hTMPA], a
    ld   a, [sPlayerActiveMon]
    ldh  [hTMPB], a
    ld   a, 0 ; execute the first move for now TODO: proper "AI"
    ldh  [hTMPC], a
    call executeMove

    ; Temporary shake until we have battle animations
    ld   c, 16
.shakeloop2:
    call $280D
    and  $07
    add  a, $100 - 3
    ldh  [hPlayerGfxX], a
    call waitVBlank
    dec  c
    jr   nz, .shakeloop2
    xor  a
    ldh  [hPlayerGfxX], a
    call waitForKeypressOrTimeoutVeryShort

    call battleDrawPlayerHPValue
    call battleUpdateHPBarSizes
    call battleDrawHPBars
    ld   de, 0
    jp   battleMainMenu

movesMenuInfo:
    db 4 ; amount of entries
    dw $7E00, $DC08 ; blank cursor tile, filled cursor tile
    dw $99C1, $99E1, $9A01, $9A21


itemNames:
    dw i"None"
    dw i"Potion"
    dw i"Bait"