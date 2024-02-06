#INCLUDE "menu/pause.asm"
#INCLUDE "npc/center.asm"
#INCLUDE "npc/kid.asm"
#INCLUDE "menu/nameentry.asm"

onEntityTouch:
    ; Skip collision if we have no health, else we keep triggering battles.
    ld   a, [$DB5A]
    and  a, a
    ret  z

    call clearEnemyParty

    ; Check if we have an encounter for this entity type.
    ld   hl, entityMonMapping
    ldh  a, [$FFEB] ; hActiveEntityType
    ld   d, a
.searchEntityLoop:
    ld   a, [hl+]
    cp   d
    jr   z, .entityFound
    inc  hl
    cp   $FF
    jr   nz, .searchEntityLoop
    ld   a, $01 ; collision not handled
    ret

.entityFound:
    push bc
    ld   b, [hl] ; Mon type

    ; Special cases for specific mons
    ld   a, MON_MOBLIN
    cp   b
    call z, .moblinException
    ld   a, MON_MOBLIN_SWORD
    cp   b
    call z, .moblinException

    call getMonLevelFromRoom

    ld   a, 6    ; mon index
    farcallX createMon

    farcall wildBattle
    ld   a, [hTMP1]
    rst  0
    dw   .playerDeath
    dw   .ranAway
    dw   .enemyDeath
    dw   .enemyCapture

.playerDeath:
    pop  bc
    ld   a, 0 ; we handled collision
    ret

.ranAway:
.enemyCapture:
.enemyDeath:
    ; Destroy the entity.
    pop  bc
    ld   hl, $C280 ; wEntitiesStatusTable
    add  hl, bc
    ld   [hl], $01

    ld   a, $00 ; Return zero if we handled the collision
    ret

.moblinException:
    ld   a, [$C193 + 2] ; Which graphics are loaded in npc slot 2
    cp   $7C ; moblin
    ret  z
    inc  b
    cp   $83 ; pigwarrior
    ret  z
    inc  b
    cp   $92 ; darknut
    ret  z
    inc  b
    ; else hooded stalfos
    ret

runBossBattle:
    ; Skip if we have no health, else we keep triggering battles.
    ld   a, [$DB5A]
    and  a, a
    ret  z
    push bc

    call clearEnemyParty

    ld   hl, bossMonMapping
    ldh  a, [$FFEB] ; hActiveEntityType
    ld   d, a
.searchEntityLoop:
    ld   a, [hl+]
    cp   d
    jr   z, .entityFound
    ld   bc, 6
    add  hl, bc
    cp   $FF
    jr   nz, .searchEntityLoop
    ; Boss not found...
    pop  bc
    ret

.entityFound:
    ld   c, 6
.createLoop:
    ld   b, [hl]
    ld   a, b
    cp   $FF
    jr   z, .skipCreate
    inc  hl
    push hl
    push bc
    call getMonLevelFromRoom
    ld   h, c
    pop  bc
    ld   a, c ; mon index
    push bc
    ld   c, h
    farcallX createMon
    pop  bc
    pop  hl
    inc  c
    ld   a, c
    cp   12
    jr   nz, .createLoop
.skipCreate:

    farcall bossBattle
    ld   a, [hTMP1]
    rst  0
    dw   .playerDeath
    dw   .ranAway
    dw   .enemyDeath
    dw   .enemyCapture

.playerDeath:
.ranAway:
.enemyCapture:
.enemyDeath:
    pop  bc
    ret

bossMonMapping:
    db   $59, MON_MINI_MOLDORM, MON_MINI_MOLDORM, MON_MOLDORM, $FF, $FF, $FF
    db   $5C, MON_GHINI, MON_GHINI, MON_GENIE, $FF, $FF, $FF
    db   $5B, MON_GREEN_ZOL, MON_GREEN_ZOL, MON_SLIME_EYE, $FF, $FF, $FF
    db   $65, MON_FISH, MON_FISH, MON_ANGLER_FISH, $FF, $FF, $FF
    db   $5D, MON_CUKEMAN, MON_SLIME_EEL, $FF, $FF, $FF, $FF
    db   $5A, MON_FLYING_TILE, MON_FLYING_TILE, MON_FACADE, $FF, $FF, $FF
    db   $63, MON_KEESE, MON_KEESE, MON_EVIL_EAGLE, $FF, $FF, $FF
    db   $62, MON_PODOBOO, MON_PODOBOO, MON_HOT_HEAD, $FF, $FF, $FF
    db   $F9, MON_HARDHIT_BEETLE, $FF, $FF, $FF, $FF, $FF
    db   $FF

entityMonMapping:
    db   $09, MON_OCTOROCK
    db   $0B, MON_MOBLIN
    db   $0D, MON_TEKTITE
    db   $0E, MON_LEEVER
    db   $0F, MON_ARMOS_STATUE
    db   $10, MON_GHINI
    db   $11, MON_GIANT_GHINI
    db   $12, MON_GHINI
    db   $19, MON_KEESE
    db   $15, MON_ANTI_FAIRY
    db   $16, MON_SPARK
    db   $17, MON_SPARK
    db   $18, MON_POLS_VOICE
    db   $19, MON_KEESE
    db   $1A, MON_STALFOS
    db   $1E, MON_STALFOS
    db   $1B, MON_GREEN_ZOL ; TODO: Red zols?
    db   $1C, MON_GEL
    db   $1F, MON_GIBDO
    db   $20, MON_HARDHAT_BEETLE
    db   $21, MON_WIZROBE
    db   $23, MON_LIKE_LIKE
    db   $24, MON_IRON_MASK
    db   $28, MON_MIMIC
    db   $29, MON_MINI_MOLDORM
    db   $2C, MON_SPIKED_BEETLE
    db   $50, MON_BOO_BUDDY
    db   $51, MON_BALL_AND_CHAIN
    db   $55, MON_BOMBITE
    db   $56, MON_BOMBITE
    db   $8F, MON_MASKED_MIMIC
    db   $7A, MON_CROW
    db   $7C, MON_GIANT_GOPONGA_FLOWER
    db   $7E, MON_GOPONGA_FLOWER
    db   $90, MON_THREE_OF_A_KIND
    db   $91, MON_ANTI_KIRBY
    db   $93, MON_MAD_BOMBER
    db   $98, MON_HORSE_PIECE ; TODO
    db   $99, MON_WATER_TEKTITE
    ; TODO: MON_FLYING_TILE
    db   $9B, MON_GREEN_ZOL
    db   $9C, MON_STAR
    db   $9F, MON_GOOMBA
    db   $A0, MON_PEAHAT
    db   $A1, MON_SNAKE
    db   $A2, MON_PIRANHA_PLANT
    db   $A9, MON_BLOOPER
    db   $AA, MON_CHEEP_CHEEP
    db   $AB, MON_CHEEP_CHEEP
    db   $AC, MON_CHEEP_CHEEP
    db   $AE, MON_WINGED_OCTOROK
    db   $B0, MON_PINCER
    db   $B2, MON_BEETLE
    db   $B9, MON_BUZZ_BLOB
    ; TODO db   $??, MON_CUKEMAN
    db   $BA, MON_BOMBER
    db   $BB, MON_BUSH_CRAWLER
    db   $BD, MON_VIRE
    db   $BF, MON_ZOMBIE
    db   $C5, MON_URCHIN
    db   $C6, MON_SAND_CRAB
    db   $CB, MON_ZORA
    db   $CC, MON_FISH
    db   $D7, MON_THWIMP
    db   $D8, MON_THWOMP
    db   $D9, MON_GIANT_THWOMP
    db   $DA, MON_PODOBOO
    ;db   $E0, MON_MONKEY
    db   $E3, MON_POKEY
    db   $E9, MON_RED_ORB
    db   $EA, MON_GREEN_ORB
    db   $EB, MON_BLUE_ORB
    db   $EC, MON_RED_CAMO
    db   $ED, MON_GREEN_CAMO
    db   $EE, MON_BLUE_CAMO
    db   $F2, MON_HOPPER
    db   $F3, MON_HOPPER
    db   $FF, $FF ; end of list

clearEnemyParty:
    ld   hl, sMonType + 6
    ld   a, $FF
    ld   [hl+], a
    ld   [hl+], a
    ld   [hl+], a
    ld   [hl+], a
    ld   [hl+], a
    ld   [hl+], a
    ret

getMonLevelFromRoom:
    ; Find the base level number to use.
    ldh  a, [$FFF6] ; map room
    ld   e, a
    ld   a, [$DBA5] ; is indoor
    ld   d, a
    ldh  a, [$FFF7]   ; mapId
    cp   $FF
    jr   nz, .notColorDungeon

    ld   d, $03
    jr   .notCavesA

.notColorDungeon:
    cp   $1A
    jr   nc, .notCavesA
    cp   $06
    jr   c, .notCavesA
    inc  d
.notCavesA:
    ld   hl, monLevelPerRoom
    add  hl, de

    ld   c, [hl] ; level
    call getRandomByte
    and  a, 3
    add  a, c
    ld   c, a
    ret

monLevelPerRoom:
    ;   x0  x1  x2  x3  x4  x5  x6  x7  x8  x9  xA  xB  xC  xD  xE  xF
    db  45, 45, 45, 42, 42, 42, 41, 30, 30, 30, 30, 30, 30, 30, 39, 35 ; 0x
    db  44, 44, 43, 42, 42, 42, 41, 20, 20, 21, 22, 22, 22, 30, 35, 35 ; 1x
    db  12, 12, 13, 13, 14, 12, 15, 16, 20, 21, 22, 24, 22, 22, 22, 22 ; 2x
    db  12, 12, 13, 13, 13, 12, 15, 16, 19, 19, 19, 19, 22, 22, 22, 22 ; 3x
    db   8,  8,  8,  9,  9, 10, 14, 15, 17, 17, 17, 17,  1,  1,  1,  1 ; 4x
    db   8,  8,  8,  8, 10, 10, 14, 15, 17, 17, 17, 17,  1,  1,  1,  1 ; 5x
    db   7,  7,  8,  8, 10, 10, 14, 15, 17, 17, 17, 17,  1,  1,  1,  1 ; 6x
    db   5,  7,  8,  8, 15, 15, 14, 15, 17, 17, 17, 17,  1,  1,  1,  1 ; 7x
    db   3,  3,  3,  3, 15, 15, 15, 15, 16, 16, 16, 16, 34, 30, 30, 30 ; 8x
    db   3,  3,  3,  3, 15, 15, 15, 15, 16, 16, 16, 16, 30, 30, 30, 30 ; 9x
    db   3,  3,  3,  3, 15, 15, 15, 15, 16, 16, 16, 16, 33, 32, 31, 30 ; Ax
    db   3,  3,  3,  3, 16, 19, 15, 15, 16, 16, 16, 16, 33, 32, 31, 30 ; Bx
    db   4,  4,  8,  9, 30, 30, 25, 25, 27, 27, 27, 27,  1,  1, 20, 20 ; Cx
    db   4,  4,  9, 10, 30, 30, 25, 26, 27, 29, 27, 27,  1,  1, 20, 20 ; Dx
    db   4,  4,  5,  5,  6,  6, 25, 26, 27, 27, 27, 27,  1,  1, 20, 20 ; Ex
    db   4,  4,  5,  5,  6, 25, 25, 26, 27, 27, 27, 27,  1,  1, 20, 20 ; Fx

    ;   x0  x1  x2  x3  x4  x5  x6  x7  x8  x9  xA  xB  xC  xD  xE  xF
    db  10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10 ; 0x
    db  10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 15, 15 ; 1x
    db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15 ; 2x
    db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15 ; 3x
    db  20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20 ; 4x
    db  20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 25, 25 ; 5x
    db  25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25 ; 6x
    db  25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25 ; 7x
    db  30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30 ; 8x
    db  30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30 ; 9x
    db  30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30,  0,  0,  0,  0 ; Ax
    db  35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35 ; Bx
    db  35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35 ; Cx
    db  35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35 ; Dx
    db   1,  1,  1,  1, 35, 35, 35,  1, 20,  1,  1, 17, 17,  1,  1, 25 ; Ex
    db   1, 32,  1,  1, 35,  1, 35,  1, 20, 20,  1,  1,  1,  1,  1, 25 ; Fx

    ;   x0  x1  x2  x3  x4  x5  x6  x7  x8  x9  xA  xB  xC  xD  xE  xF
    db  40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40 ; 0x
    db  40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40 ; 1x
    db  40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40 ; 2x
    db  45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45 ; 3x
    db  45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45 ; 4x
    db  45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45 ; 5x
    db  45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 33, 33, 33, 33 ; 6x
    db  50, 50, 50, 50, 50, 50, 50, 25, 25, 25, 25, 25, 25, 25, 25, 33 ; 7x
    db  30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 33 ; 8x
    db  16, 16, 16, 16, 16, 16, 16, 28, 28,  1, 30,  1,  1,  1,  1,  1 ; 9x
    db   1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  8,  8,  1, 12, 12 ; Ax
    db   1,  1,  1,  8,  1,  1, 21, 22, 22, 22, 22, 22, 22,  8, 16, 16 ; Bx
    db   1,  1, 17, 17,  1, 17, 18,  1, 18, 15, 15,  1,  1, 15, 16, 16 ; Cx
    db  20, 20, 17, 17,  1, 17, 17,  1, 18,  1,  1,  1,  1,  1, 14, 14 ; Dx
    db  13, 13, 13,  1, 15, 15, 20, 20, 40,  1, 30, 30, 30, 30, 30, 30 ; Ex
    db  13, 35, 35, 35, 15,  1, 20, 20, 40, 30, 30, 30, 31, 25,  1,  1 ; Fx

    db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15 ; Ex
    db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15 ; Fx
