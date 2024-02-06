#MACRO copyMonOneMem
    ld   a, b
    ldde_add_a \1
    ld   a, c
    ldhl_add_a \1
    ld   a, [de]
    ld   [hl], a
#END
; Copy mon at index B to index C (used by capture and swapping)
copyMon:
    ld   a, b
    add  a, a
    ldde_add_a sMonHP
    ld   a, c
    add  a, a
    ldhl_add_a sMonHP
    ld   a, [de]
    inc  de
    ld   [hl+], a
    ld   a, [de]
    ld   [hl], a

    ld   a, b
    add  a, a
    add  a, b
    ldde_add_a sMonExp
    ld   a, c
    add  a, a
    add  a, c
    ldhl_add_a sMonExp
    ld   a, [de]
    inc  de
    ld   [hl+], a
    ld   a, [de]
    inc  de
    ld   [hl+], a
    ld   a, [de]
    inc  de
    ld   [hl], a

    copyMonOneMem sMonType
    copyMonOneMem sMonHPEV
    copyMonOneMem sMonHPIV
    copyMonOneMem sMonAtkEV
    copyMonOneMem sMonAtkIV
    copyMonOneMem sMonDefEV
    copyMonOneMem sMonDefIV
    copyMonOneMem sMonSpdEV
    copyMonOneMem sMonSpdIV
    copyMonOneMem sMonSpcEV
    copyMonOneMem sMonSpcIV

    ld   a, b
    add  a, a
    add  a, a
    ldde_add_a sMonMoves
    ld   a, c
    add  a, a
    add  a, a
    ldhl_add_a sMonMoves
    ld   a, [de]
    inc  de
    ld   [hl+], a
    ld   a, [de]
    inc  de
    ld   [hl+], a
    ld   a, [de]
    inc  de
    ld   [hl+], a
    ld   a, [de]
    inc  de
    ld   [hl], a

    ld   a, b
    add  a, a
    add  a, a
    ldde_add_a sMonMovePP
    ld   a, c
    add  a, a
    add  a, a
    ldhl_add_a sMonMovePP
    ld   a, [de]
    inc  de
    ld   [hl+], a
    ld   a, [de]
    inc  de
    ld   [hl+], a
    ld   a, [de]
    inc  de
    ld   [hl+], a
    ld   a, [de]
    inc  de
    ld   [hl], a

    ld   a, c
    call getMonName
    ld16_hl_de
    ld   a, b
    call getMonName
    ld   c, 8
.nameCopyLoop:
    ld   a, [de]
    inc  de
    ld   [hl+], a
    dec  c
    jr   nz, .nameCopyLoop

    ret
