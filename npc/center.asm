zeldacenter:
    ldh  a, [$FFF6] ;hMapRoom
    ld   [sLastZeldaCenterRoom], a

    ld   a, $01
    ld   [$C50A], a ;wBlockItemUsage

    ldh  a, [hFrameCounter]
    swap a
    and  1
    ldh  [$FFF1], a

    ld   de, .spriteData
    call $3BC0 ; RenderActiveEntitySpritesPair

    ldh  a, [$FFF0] ; active entity state
    rst  0
    dw   .waitForTalk
    dw   .talking
    dw   .healTalking

.waitForTalk:
    ldh  a, [hJoypadPressed]
    and  J_A
    ret  z
    ldh  a, [hLinkDirection]
    cp   2
    ret  nz
    ldh  a, [hLinkPositionX]
    sub  $32
    ret  c
    cp   $10
    ret  nc
    ldh  a, [hLinkPositionY]
    cp   $40
    ret  nc

    ld   hl, M"Welcome to the zelda center."
    ld   de, $C0A0
.copyLoop:
    ld   a, [hl+]
    ld   [de], a
    inc  de
    inc  a
    jr   nz, .copyLoop

    ld   a, $C9
    call $2385  ; OpenDialogInTable0
    call $3B12 ; Increment entity state
    ret

.healTalking:
    ld   a, [$C19F] ; Dialog state
    and  a
    ret  nz

    call $3B12 ; Increment entity state
    xor  a
    ld   [hl], a
    ret

.talking:
    ld   a, [$C19F] ; Dialog state
    and  a
    ret  nz

    call $3B12 ; Increment entity state
    xor  a
    ld   [hl], a

    push bc
    farcall storeTilemapVRAMtoSRAM
    farcall loadFontGraphics

.mainMenuEntry:
    ;ld   de, $0908
    ld   de, $0708
    ld   hl, $9800 + $20 * 7 + 1
    farcallX drawBlackBox
    DRAW_TEXT_DARK 3, 8, i"Heal"
    DRAW_TEXT_DARK 3, 10, i"Buy"
    ; DRAW_TEXT_DARK 3, 12, i"Sell"
    DRAW_TEXT_DARK 3, 12, i"Bye"

    ld   hl, menuInfoZeldaCenterMain
    farcallX runMenu
    cp   $FF
    jr   z, .exitMenu
    rst  0
    dw   .selectedHeal
    dw   .selectedBuy
    dw   .exitMenu
    ; dw   .exitMenu

.exitMenu:
    farcall restoreTilemapVRAMfromSRAM
    farcall restoreVRAM2
    pop  bc
    ret

.selectedHeal:
    ld   hl, M"Healed all your monsters."
    ld   de, $C0A0
.copyLoop2:
    ld   a, [hl+]
    ld   [de], a
    inc  de
    inc  a
    jr   nz, .copyLoop2

    farcall healAllMon

    ld   a, $C9
    call $2385  ; OpenDialogInTable0
    pop  bc
    call $3B12 ; Increment entity state
    ld   [hl], 2
    push bc
    jr   .exitMenu

.spriteData:
    db $60, $02
    db $62, $02

    db $62, $22
    db $60, $22

.selectedBuy:
    farcall restoreTilemapVRAMfromSRAM
    ld   de, $0712
    ld   hl, $9800 + $20 * 9 + 1
    farcallX drawBlackBox
    DRAW_TEXT_DARK 3, 10, i"Bait   20rupees"
    ld   e, ITEM_BAIT
    call .getItemCount
    ld   b, 0
    ld   c, a
    ld   hl, $9800 + $20 * 11 + 17
    farcallX drawNumberDark
    DRAW_TEXT_DARK 3, 12, i"Potion 30rupees"
    ld   e, ITEM_POTION
    call .getItemCount
    ld   b, 0
    ld   c, a
    ld   hl, $9800 + $20 * 13 + 17
    farcallX drawNumberDark
    DRAW_TEXT_DARK 3, 14, i"Cancel"

    ld   hl, menuInfoZeldaCenterBuy
    farcallX runMenu
    cp   $FF
    jr   z, .returnToMainMenu
    rst  0
    dw   .buyFood
    dw   .buyPotion
    dw   .returnToMainMenu

.buyFood:
    ld   b, $20
    call .takeRupees
    jp   z, .selectedBuy
    ld   e, ITEM_BAIT
    call .giveItem
    jp   .selectedBuy

.buyPotion:
    ld   b, $30
    call .takeRupees
    jp   z, .selectedBuy
    ld   e, ITEM_POTION
    call .giveItem
    jp   .selectedBuy

.returnToMainMenu:
    farcall restoreTilemapVRAMfromSRAM
    jp .mainMenuEntry


.takeRupees:
    ld   a, [wRupeeCountHigh]
    and  a
    jr   nz, .takeRupeesContinue
    ld   a, [wRupeeCountLow]
    sub  b
    daa
    jr   c, .takeRupeesNotEnoughRupees
.takeRupeesContinue:
    ld   a, [wRupeeCountLow]
    sub  b
    daa
    ld   [wRupeeCountLow], a
    jr   nc, .takeRupeesDone
    ld   a, [wRupeeCountHigh]
    sub  1
    daa
    ld   [wRupeeCountHigh], a
.takeRupeesDone:

    ; Update the rupee count visuals in the 2nd sram bank.
    ld   a, $01
    ld   [SET_RAM_BANK], a
    ld   hl, $A000 + $9C2A - $9800
    ld   a, [wRupeeCountHigh]
    add  $B0
    ld   [hl+], a
    ld   a, [wRupeeCountLow]
    swap a
    and  $0F
    add  $B0
    ld   [hl+], a
    ld   a, [wRupeeCountLow]
    and  $0F
    add  $B0
    ld   [hl+], a
    xor  a
    ld   [SET_RAM_BANK], a

    ld   a, $FF
    and  a, a
    ret

.takeRupeesNotEnoughRupees:
    ld   a, $1D
    ldh  [hJingle], a
    xor  a
    ret

.giveItem:
    ld   hl, sInvItems
.giveItemLoop:
    ld   a, [hl+]
    cp   0
    jr   z, .giveItemNotFound
    cp   e
    jr   z, .giveItemFound
    inc  hl
    jr   .giveItemLoop
.giveItemFound:
    ld   a, [hl]
    cp   99
    ret  z
    inc  [hl]
    ret
.giveItemNotFound:
    dec  hl
    ld   [hl], e
    inc  hl
    ld   [hl], 1
    ret

.getItemCount:
    ld   hl, sInvItems
.getItemCountLoop:
    ld   a, [hl+]
    cp   0
    jr   z, .getItemCountNotFound
    cp   e
    jr   z, .getItemCountFound
    inc  hl
    jr   .getItemCountLoop
.getItemCountFound:
    ld   a, [hl]
    ret
.getItemCountNotFound:
    ld   a, 0
    ret
