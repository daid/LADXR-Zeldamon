
loadFontGraphics:
    call waitVBlank
    ld   a, $01
    ldh  [rVBK], a
    ld   a, BANK(zm_font)
    ld   b, ((zm_font.end - zm_font) / $10) - 1
    ld   de, zm_font
    ld   hl, $8800
    call executeHDMA
    xor  a
    ldh  [rVBK], a
    ret

; Draw the number in BC to location HL, where the final digit is on HL
drawNumberDark:
    push hl
    ld   de, 10
    call udiv16
    pop  hl
    push bc
    ld   a, e
    add  a, $C5
    ld   b, a
    ld   c, $0C
    call writeToTilemap
    pop  bc
    dec  hl
    ld   a, b
    or   c
    jr   nz, drawNumberDark
    ret

drawNumberLight:
    push hl
    ld   de, 10
    call udiv16
    pop  hl
    push bc
    ld   a, e
    add  a, $C5
    ld   b, a
    ld   c, $0D
    call writeToTilemap
    pop  bc
    dec  hl
    ld   a, b
    or   c
    jr   nz, drawNumberLight
    ret

drawTextLengthLight:
    ld   a, [de]
    inc  de

    push bc
    ; Get tile ID
    ld   bc, zm_font_codepoint_to_tile - $20
    add  a, c
    ld   c, a
    ld   a, $00
    adc  b
    ld   b, a
    ld   a, [bc]

    ld   b, a
    ld   c, $0D
    call writeToTilemap
    inc  hl

    pop  bc
    dec  c
    jr   nz, drawTextLengthLight
    ret

drawTextLengthDark:
    ld   a, [de]
    inc  de

    push bc
    ; Get tile ID
    ld   bc, zm_font_codepoint_to_tile - $20
    add  a, c
    ld   c, a
    ld   a, $00
    adc  b
    ld   b, a
    ld   a, [bc]

    ld   b, a
    ld   c, $0C
    call writeToTilemap
    inc  hl

    pop  bc
    dec  c
    jr   nz, drawTextLengthDark
    ret
