#INCLUDE "sram.asm"
#INCLUDE "draw.asm"
#INCLUDE "text.asm"
#INCLUDE "palette.asm"
#INCLUDE "vrambackup.asm"
#INCLUDE "transition.asm"
#INCLUDE "mon/exp.asm"
#INCLUDE "mon/moves.asm"
#INCLUDE "mon/create.asm"
#INCLUDE "mon/copy.asm"
#INCLUDE "mon/healall.asm"
#INCLUDE "battle/hpbar.asm"
#INCLUDE "battle/gfx.asm"
#INCLUDE "battle/stat.asm"
#INCLUDE "battle/move.asm"
#INCLUDE "battle/mainmenu.asm"
#INCLUDE "battle/party.asm"
#INCLUDE "battle/expgain.asm"
#INCLUDE "battle/items.asm"
#INCLUDE "menu/party.asm"
#INCLUDE "menu/menu.asm"

checkSaveData:
    ; Check if the last 16 bytes are zero, if not we need to setup SRAM
    ld   hl, $B000 - $10
    ld   c, $10
.checkloop:
    ld   a, [hl+]
    and  a, a
    jr   nz, .clearSaveData
    dec  c
    jr   nz, .checkloop
    ret

.clearSaveData:
    ld   hl, $AD00
    ld   de, $B000 - $AD00
.clearSRAMloop:
    xor  a
    ld   [hl+], a
    dec  de
    ld   a, d
    or   e
    jr   nz, .clearSRAMloop

    ld   hl, sMonType
    ld   c, 12
.clearTypesLoop:
    ld   a, $FF
    ld   [hl+], a
    dec  c
    jr   nz, .clearTypesLoop

    ld   a, $CB
    ld   [sLastZeldaCenterRoom], a

    ret

wildBattle:
    call storeTilemapVRAMtoSRAM
    call loadFontGraphics

    call blackShutter

    call blankAllTiles
    ld   hl, battlePalette
    call loadBGPal
    call loadObjPal

    call drawBlackBottomBar

    DRAW_TEXT_DARK 1, 15, i"Wild monster"
    DRAW_TEXT_DARK 1, 16, i"appeared!"

    xor  a
    ld   [sBattleType], a

    call setupLCDCInterruptForBattle

    ; Music
    ld   a, $19
    ld   [$D368], a
    ; Set music speed
    ld   a, 2
    ld   [$C10B], a

    xor  a
    ld   [sPlayerMonParticipated], a
    call findAlivePlayerMon
    ld   a, b
    ld   [sPlayerActiveMon], a
    call findAliveEnemyMon
    ld   a, b
    ld   [sEnemyActiveMon], a

    call switchInPlayerMon
    call switchInEnemyMon
    call waitForKeypressOrTimeout

    call battleMainMenu

    ; Return back to the game
    call blankAllTiles
    call restoreVRAM2
    call setDefaultLCDCInterrupt
    ld   a, $E7
    ldh  [rLCDC], a
    call restoreTilemapVRAMfromSRAM
    ; reset music
    ldh  a, [$FFBF]
    ld   [$D368], a
    xor  a
    ld   [$C10B], a
    ret

bossBattle:
    call storeTilemapVRAMtoSRAM
    call loadFontGraphics

    call blackShutter

    call blankAllTiles
    ld   hl, battlePalette
    call loadBGPal
    call loadObjPal

    call drawBlackBottomBar

    DRAW_TEXT_DARK 1, 15, i"Now fight!"

    ld   a, 1
    ld   [sBattleType], a

    call setupLCDCInterruptForBattle

    ; Music
    ld   a, $19
    ld   [$D368], a
    ; Set music speed
    ld   a, 2
    ld   [$C10B], a

    xor  a
    ld   [sPlayerMonParticipated], a
    call findAlivePlayerMon
    ld   a, b
    ld   [sPlayerActiveMon], a
    call findAliveEnemyMon
    ld   a, b
    ld   [sEnemyActiveMon], a

    call switchInPlayerMon
    call switchInEnemyMon
    call waitForKeypressOrTimeout

    call battleMainMenu

    ; Return back to the game
    call blankAllTiles
    call restoreVRAM2
    call setDefaultLCDCInterrupt
    ld   a, $E7
    ldh  [rLCDC], a
    call restoreTilemapVRAMfromSRAM
    ; reset music
    ldh  a, [$FFBF]
    ld   [$D368], a
    xor  a
    ld   [$C10B], a
    ret

waitForKeypressOrTimeout:
    ld   c, 0
    jr   waitForKeypressOrTimeoutShort.loop
waitForKeypressOrTimeoutVeryShort:
    ld   c, 16
    jr   waitForKeypressOrTimeoutShort.loop
waitForKeypressOrTimeoutShort:
    ld   c, 32
.loop:
    call waitVBlank
    ldh  a, [hJoypadPressed]
    and  J_A | J_B | J_START | J_SELECT
    ret  nz
    dec  c
    jr   nz, .loop
    ret

waitForKeypress:
    call waitVBlank
    ldh  a, [hJoypadPressed]
    and  J_A | J_B | J_START | J_SELECT
    ret  nz
    jr   waitForKeypress
