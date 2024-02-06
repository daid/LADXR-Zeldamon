

useItemPotion:
    call drawBlackBottomBar
    ld   a, [sPlayerActiveMon]
    call getMonName
    ld   hl, $9800 + $20 * 15 + 2
    ld   c, 8
    call drawTextLengthDark
    DRAW_TEXT_DARK 2, 16, i"Used a potion"
    call waitForKeypressOrTimeout

    ld   a, [sPlayerActiveMon]
    call getMaxHP ; in bc

    ld   a, [sPlayerActiveMon]
    add  a, a
    ldhl_add_a sMonHP
    ld   a, [hl]
    add  a, 100
    ld   e, a
    ld   [hl+], a
    ld   a, [hl]
    adc  a, 0
    ld   [hl], a

    cp   b
    jr   c, .noOverflow
    jr   nz, .overflow
    ld   a, e
    cp   c
    jr   c, .noOverflow
.overflow:
    ld   a, b
    ld   [hl-], a
    ld   [hl], c
.noOverflow:
    jp   battleMainMenu.startEnemyAttack

useItemBait:
    call drawBlackBottomBar
    DRAW_TEXT_DARK 2, 16, i"Throwing bait"
    call waitForKeypressOrTimeout

    ld   a, [sBattleType]
    and  a, a
    jp   nz, .noCapture

    ; Check if the enemy has more then 50% HP
    ld   a, [sEnemyActiveMon]
    call getMaxHP ; in bc
    srl  b
    rr   c

    ld   a, [sEnemyActiveMon]
    add  a, a
    ldhl_add_a sMonHP + 1
    ld   a, [hl-]
    cp   b
    jr   c, .noOverflow
    jr   nz, .overflow
    ld   a, [hl]
    cp   c
    jr   c, .noOverflow
.overflow:
    jp   .noCapture
.noOverflow:
    ; Add some random factor
    call GetRandomByte
    cp   100
    jp   nc, .noCapture

    ; Show that we captured
    call drawBlackBottomBar
    ld   a, [sEnemyActiveMon]
    call getMonName
    ld   hl, $9800 + $20 * 15 + 2
    ld   c, 8
    call drawTextLengthDark
    DRAW_TEXT_DARK 2, 16, i"Got caught!"
    call waitForKeypressOrTimeout

    ; Disable the LCDC interrupt
    call waitVBlank
    ld   a, 1
    ldh  [rIE], a

    call blankAllTiles
    FARCALL nameMonMenu

    ld   b, 6
    ld   c, 0
.searchEmptySlotLoop:
    ld   a, c
    ldhl_add_a sMonType
    ld   a, [hl]
    cp   $FF
    jr   z, .emptyFound
    inc  c
    ld   a, c
    cp   6
    jr   z, .noEmptySlot
    jr   .searchEmptySlotLoop

.emptyFound:
    call copyMon

    ; Set the result in TMP1
    ld   a, $03
    ldh  [hTMP1], a
    ret


.noEmptySlot:
    ; Show that we captured
    call drawBlackBottomBar
    DRAW_TEXT_DARK 2, 15, i"But no space"
    DRAW_TEXT_DARK 2, 16, i"in party"
    call waitForKeypressOrTimeout

    ;TODO Move mon to storage
    ld   a, $03
    ldh  [hTMP1], a
    ret

.noCapture:
    call drawBlackBottomBar
    ld   a, [sEnemyActiveMon]
    call getMonName
    ld   hl, $9800 + $20 * 15 + 2
    ld   c, 8
    call drawTextLengthDark
    DRAW_TEXT_DARK 2, 16, i"Ignored it"
    call waitForKeypressOrTimeout

    jp   battleMainMenu.startEnemyAttack
