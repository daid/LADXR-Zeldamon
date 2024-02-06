getMaxHP_b:
    ld   a, b
; Get the maximum HP for the monster at index A
; Return BC=MaxHP
getMaxHP:
    push af
    ; HP = (Base * 2 + IV + (EV / 4)) * Level / 100) + Level + 10
    call getBaseStatsTable
    ld   b, 0
    ld   a, BANK(monsterBaseStats)
    call bankedReadInc ; get base HP
    add  a, a ; * 2
    ld   c, a
    pop  af
    push af
    ldhl_add_a sMonHPIV
    ld   l, [hl]
    ld   h, $00
    add  hl, bc ; + IV
    ld16_bc_hl
    pop  af
    push af
    ldhl_add_a sMonHPEV ; get EV
    ld   l, [hl]
    srl  l  ; /2
    srl  l  ; /4
    ld   h, $00
    add  hl, bc ; + EV/4

    pop  af
    push hl
    call getMonLevel
    pop  de
    push af

    call umul8_16 ; * level

    ld16_bc_hl
    ld   de, 100
    call udiv16 ; /100

    pop  af
    add  a, 10
    add  a, c
    ld   c, a
    ld   a, b
    adc  $00
    ld   b, a

    ret

; Return monster[a] effective attack
getMonAttack:
    push af
    ; Attack = (2 * Base + IV + (EV / 4)) * Level / 100) + 5
    call getBaseStatsTable
    inc  hl
    ld   a, BANK(monsterBaseStats)
    call bankedReadInc ; get base Atk
    add  a, a ; * 2
    ld   b, 0
    ld   c, a
    pop  af

    push af
    ldhl_add_a sMonAtkIV
    ld   l, [hl]
    ld   h, $00
    add  hl, bc ; + IV
    ld16_bc_hl
    pop  af

    push af
    ldhl_add_a sMonAtkEV
    ld   l, [hl]
    srl  l  ; /2
    srl  l  ; /4
    ld   h, $00
    add  hl, bc ; + EV/4
    pop  af

    push hl
    call getMonLevel
    pop  de
    call umul8_16 ; * level

    ld16_bc_hl
    ld   de, 100
    call udiv16 ; /100
    ld   hl, 5
    add  hl, bc
    ld   a, l
    ret

; Return monster[a] effective defense
getMonDefense:
    push af
    ; Defense = (2 * Base + IV + (EV / 4)) * Level / 100) + 5
    call getBaseStatsTable
    inc  hl
    inc  hl
    ld   a, BANK(monsterBaseStats)
    call bankedReadInc ; get base Def
    add  a, a ; * 2
    ld   b, 0
    ld   c, a
    pop  af

    push af
    ldhl_add_a sMonDefIV
    ld   l, [hl]
    ld   h, $00
    add  hl, bc ; + IV
    ld16_bc_hl
    pop  af

    push af
    ldhl_add_a sMonDefEV
    ld   l, [hl]
    srl  l  ; /2
    srl  l  ; /4
    ld   h, $00
    add  hl, bc ; + EV/4
    pop  af

    push hl
    call getMonLevel
    pop  de
    call umul8_16 ; * level

    ld16_bc_hl
    ld   de, 100
    call udiv16 ; /100
    ld   hl, 5
    add  hl, bc
    ld   a, l
    ret

; Return monster[a] effective speed
getMonSpeed:
    push af
    ; Speed = (2 * Base + IV + (EV / 4)) * Level / 100) + 5
    call getBaseStatsTable
    inc  hl
    inc  hl
    inc  hl
    ld   a, BANK(monsterBaseStats)
    call bankedReadInc ; get base Spd
    add  a, a ; * 2
    ld   b, 0
    ld   c, a
    pop  af

    push af
    ldhl_add_a sMonSpdIV
    ld   l, [hl]
    ld   h, $00
    add  hl, bc ; + IV
    ld16_bc_hl
    pop  af

    push af
    ldhl_add_a sMonSpdEV
    ld   l, [hl]
    srl  l  ; /2
    srl  l  ; /4
    ld   h, $00
    add  hl, bc ; + EV/4
    pop  af

    push hl
    call getMonLevel
    pop  de
    call umul8_16 ; * level

    ld16_bc_hl
    ld   de, 100
    call udiv16 ; /100
    ld   hl, 5
    add  hl, bc
    ld   a, l
    ret

; Return monster[a] effective speed
getMonSpecial:
    push af
    ; Spacial = (2 * Base + IV + (EV / 4)) * Level / 100) + 5
    call getBaseStatsTable
    inc  hl
    inc  hl
    inc  hl
    inc  hl
    ld   a, BANK(monsterBaseStats)
    call bankedReadInc ; get base Special
    add  a, a ; * 2
    ld   b, 0
    ld   c, a
    pop  af

    push af
    ldhl_add_a sMonSpcIV
    ld   l, [hl]
    ld   h, $00
    add  hl, bc ; + IV
    ld16_bc_hl
    pop  af

    push af
    ldhl_add_a sMonSpcEV
    ld   l, [hl]
    srl  l  ; /2
    srl  l  ; /4
    ld   h, $00
    add  hl, bc ; + EV/4
    pop  af

    push hl
    call getMonLevel
    pop  de
    call umul8_16 ; * level

    ld16_bc_hl
    ld   de, 100
    call udiv16 ; /100
    ld   hl, 5
    add  hl, bc
    ld   a, l
    ret

; Return monster[a] level in A and C
getMonLevel:
    ld   c, a
    add  a, a
    add  a, c
    ldhl_add_a sMonExp
    ; Load current exp into hTMP
    ld   a, [hl+]
    ldh  [hTMP2], a
    ld   a, [hl+]
    ldh  [hTMP1], a
    ld   a, [hl+]
    ldh  [hTMP0], a

    ld   hl, expTable
    ; Start at level 1
    ld   c, 1

.loop:
    ; Compare hTMP with exp in table.
    ldh  a, [hTMP2]
    cp   [hl]
    jr   c, .done
    jr   nz, .next3
    inc  hl

    ldh  a, [hTMP1]
    cp   [hl]
    jr   c, .done
    jr   nz, .next2
    inc  hl

    ldh  a, [hTMP0]
    cp   [hl]
    jr   c, .done
    jr   .next1

.next3:
    inc  hl
.next2:
    inc  hl
.next1:
    inc  hl
    ; increase our level counter
    inc  c
    jr   .loop

.done:
    ld   a, c
    ret

; Get a pointer to the monsterBaseStats of monster[b] in hl
getBaseStatsTableB:
    ld   a, b
; Get a pointer to the monsterBaseStats of monster[a] in hl
getBaseStatsTable:
    ldhl_add_a sMonType
    ld   a, [hl]
    ld   de, STAT_ENTRY_SIZE
    call umul8_16
    ld   de, monsterBaseStats
    add  hl, de
    ret

; Get pointer to the name of monster[a] in de
getMonName:
    add a, a ;*2
    add a, a ;*4
    add a, a ;*8
    add a, LOW(sMonName)
    ld  e, a
    adc HIGH(sMonName)
    sub e
    ld  d, a
    ret
