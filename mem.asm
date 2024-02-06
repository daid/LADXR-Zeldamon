; Additional memory we use
; Located as SRAM:AD00 up to B000

; Total memory locations reserved for monsters.
; 6 player, 6 enemies
MON_COUNT := 12

; We start with these tables, so they do not cross a byte
; boundary and are easier to index. (HL=... L+=index), we have room for 21 of these tables.
#MACRO sMonMem
\1: ds MON_COUNT * \2
#ASSERT (\1 / $100) == ((\1 + MON_COUNT * \2) / $100)
#END

sMonMem sMonHP, 2
sMonMem sMonExp, 3
sMonMem sMonType, 1
sMonMem sMonHPEV, 1
sMonMem sMonHPIV, 1
sMonMem sMonAtkEV, 1
sMonMem sMonAtkIV, 1
sMonMem sMonDefEV, 1
sMonMem sMonDefIV, 1
sMonMem sMonSpdEV, 1
sMonMem sMonSpdIV, 1
sMonMem sMonSpcEV, 1
sMonMem sMonSpcIV, 1
sMonMem sMonUNUSED, 1
sMonMem sMonMoves, 4
ds 4 ; Padding to align back on a $100 page
sMonMem sMonMovePP, 4

sMonName:           ds MON_COUNT * 8

sPlayerActiveMon:   ds 1 ; active player mon in range 0-5
sEnemyActiveMon:    ds 1 ; active enemy mon in range 6-11

sPlayerHPBarSize:   ds 1 ; Amount of pixels to display on the player HP bar, 0-56
sEnemyHPBarSize:   ds 1 ; Amount of pixels to display on the player HP bar, 0-56

sPlayerMonParticipated: ds 1 ; bit set to 1 for each player mon that participated in battle.
sLastZeldaCenterRoom: ds 1 ; Set to the last zelda center room you visited, so you respawn there if you are killed in battle.

sBattleType: ds 1 ; 0 = wild, 1 = non-wild

; Inventory, 2 bytes per item: [ID], [COUNT]
sInvItems: ds 32
#ASSERT (sInvItems / $100) == ((sInvItems + 32) / $100)

__memEnd:
#ASSERT __memEnd < $B000
