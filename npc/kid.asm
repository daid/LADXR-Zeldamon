giveInitialMon:
    farcall storeTilemapVRAMtoSRAM
    farcall loadFontGraphics

    farcall blackShutter

    farcall blankAllTiles
    ld   hl, battlePalette
    farcallX loadBGPal
    farcallX loadObjPal

    farcall setupLCDCInterruptForBattle

    farcall drawBlackBottomBar

    ; First, show the kid.
    ld   hl, kidGfxInfo
    ld   de, $9C00
    ld   c, $90
    farcallX loadMonsterGFX
    farcall battleShiftInEnemy

    DRAW_TEXT_DARK 1, 15, i"Pick your favorite"
    DRAW_TEXT_DARK 1, 16, i"Monster..."

    farcall waitForKeypressOrTimeout

.retryPickMon:
    farcall drawBlackBottomBar
    DRAW_TEXT_DARK 2, 15, i"Moblin"
    DRAW_TEXT_DARK 2, 16, i"Stalfos"
    DRAW_TEXT_DARK 10, 15, i"LikeLike"
    DRAW_TEXT_DARK 10, 16, i"Tektite"

    farcall runMenu2x2
    ldh  a, [hTMP4]
    cp   $FF
    jr   z, .retryPickMon
    rst  0
    dw   .giveMoblin
    dw   .giveStalfos
    dw   .giveLikeLike
    dw   .giveTektite

.giveMoblin:
    ld   b, MON_MOBLIN
    jr   .giveMon
.giveStalfos:
    ld   b, MON_STALFOS
    jr   .giveMon
.giveLikeLike:
    ld   b, MON_LIKE_LIKE
    jr   .giveMon
.giveTektite:
    ld   b, MON_TEKTITE
.giveMon:
    ld   a, 6
    ld   c, 10
    farcallX createMon

    farcall drawBlackBottomBar
    DRAW_TEXT_DARK 2, 15, i"Great choice!"
    farcall waitForKeypressOrTimeout

    farcall drawBlackBottomBar
    DRAW_TEXT_DARK 2, 15, i"Now, name"
    DRAW_TEXT_DARK 2, 16, i"your monster"

    call waitVBlank
    ld  a, 1
    ldh [rIE], a ; Disable the LCDC interrupt during name entry.

    call nameMonMenu
    ld   b, 6
    ld   c, 0
    farcall copyMon

    ; TODO First battle
    farcall blankAllTiles
    farcall drawBlackBottomBar

    ; Return back to the game
    farcall blankAllTiles
    farcall restoreVRAM2
    farcall setDefaultLCDCInterrupt
    ld   a, $E7
    ldh  [rLCDC], a
    farcall restoreTilemapVRAMfromSRAM
    ; reset music
    ldh  a, [$FFBF]
    ld   [$D368], a
    xor  a
    ld   [$C10B], a
    ret
