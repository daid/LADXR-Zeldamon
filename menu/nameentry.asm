nameMonLetters:
    db   "ABCDEFG  abcdefg"
    db   "HIJKLMN  hijklmn"
    db   "OPQRSTU  opqrstu"
    db   "VWXYZ'-  vwxyz,."
    db   "0123456  7890?! "

; Name the mon in slot 6, this always happens in slot 6,
;   because that's where wild mons are captured. Rest of the code can easy deal with hardcoded slot 6.
nameMonMenu:
    ld   de, nameMonLetters
    ld   hl, $9800 + $20 * 4 + 2
    ld   b, 5
.drawLetterColLoop:
    ld   c, 16
.drawLetterRowLoop:
    ld   a, [de]
    inc  de
    push bc
    add  a, LOW(zm_font_codepoint_to_tile - $20)
    ld   c, a
    adc  HIGH(zm_font_codepoint_to_tile - $20)
    sub  c
    ld   b, a
    ld   a, [bc]

    ld   b, a
    ld   c, $08 + 5
    call writeToTilemap
    pop  bc

    inc  hl
    dec  c
    jr   nz, .drawLetterRowLoop
    push de
    ld   de, $40 - 16
    add  hl, de
    pop  de
    dec  b
    jr   nz, .drawLetterColLoop

    xor  a
    ldh  [hTMP4], a ; cursor X
    ldh  [hTMP5], a ; cursor Y
    ldh  [hTMP6], a ; text pointer
    call .drawMonName
    ld   a, $FF
    ldh  [hTMP6], a ; text pointer (default=FF, still need to clear)

.menuLoopEntry:
    ld   bc, $B30D
    call .drawCursor

.menuLoop:
    call waitVBlank
    ldh  a, [hJoypadPressed]
    and  J_A ; select
    jr   nz, .select
    ldh  a, [hJoypadPressed]
    and  J_B ; cancel
    jp   nz, .backspace
    ldh  a, [hJoypadPressed]
    and  J_UP
    jr   nz, .cursorUp
    ldh  a, [hJoypadPressed]
    and  J_DOWN
    jr   nz, .cursorDown
    ldh  a, [hJoypadPressed]
    and  J_LEFT
    jr   nz, .cursorLeft
    ldh  a, [hJoypadPressed]
    and  J_RIGHT
    jr   nz, .cursorRight
    ldh  a, [hJoypadPressed]
    and  J_START
    jp   nz, .finish
    jr   .menuLoop

.cursorUp:
    ld   a, $0A
    ldh  [hJingleSFX], a
    ld   bc, $7F00
    call .drawCursor
    ldh  a, [hTMP5]
    dec  a
    cp   $FF
    jr   nz, .noWrapUp
    ld   a, 4
.noWrapUp:
    ldh  [hTMP5], a
    jr   .menuLoopEntry

.cursorDown:
    ld   a, $0A
    ldh  [hJingleSFX], a
    ld   bc, $7F00
    call .drawCursor
    ldh  a, [hTMP5]
    inc  a
    cp   5
    jr   nz, .noWrapDown
    xor  a
.noWrapDown:
    ldh  [hTMP5], a
    jr   .menuLoopEntry

.cursorLeft:
    ld   a, $0A
    ldh  [hJingleSFX], a
    ld   bc, $7F00
    call .drawCursor
    ldh  a, [hTMP4]
    dec  a
    and  $0F
    ldh  [hTMP4], a
    jr   .menuLoopEntry

.cursorRight:
    ld   a, $0A
    ldh  [hJingleSFX], a
    ld   bc, $7F00
    call .drawCursor
    ldh  a, [hTMP4]
    inc  a
    and  $0F
    ldh  [hTMP4], a
    jp   .menuLoopEntry

.select:
    ld   a, $13
    ldh  [hJingleSFX], a

    ; If nothing was entered yet, clear the name.
    ldh  a, [hTMP6]
    cp   $FF
    jr   nz, .noClear

    ld   hl, sMonName + 6 * 8
    ld   a, 32
    ld   c, 8
.clearNameLoop:
    ld   [hl+], a
    dec  c
    jr   nz, .clearNameLoop

    xor  a
    ldh  [hTMP6], a
.noClear:
    ; Add the character to the mon name
    ld   a, [hTMP5]
    swap a
    ld   b, a
    ld   a, [hTMP4]
    or   b
    add  LOW(nameMonLetters)
    ld   l, a
    adc  HIGH(nameMonLetters)
    sub  l
    ld   h, a
    ld   c, [hl]
    ldh  a, [hTMP6]
    add  LOW(sMonName + 6 * 8)
    ld   l, a
    adc  HIGH(sMonName + 6 * 8)
    sub  l
    ld   h, a
    ld   [hl], c

    ; If it's not at the last position, increase the entry cursor position
    ldh  a, [hTMP6]
    cp   7
    jr   z, .skipCursorIncrease
    inc  a
    ldh  [hTMP6], a
.skipCursorIncrease:
    call .drawMonName
    jp   .menuLoop

.backspace:
    ld   a, $13
    ldh  [hJingleSFX], a

    ldh  a, [hTMP6]
    and  a
    jp   z, .menuLoop
    dec  a
    ldh  [hTMP6], a
    call .drawMonName
    jp   .menuLoop

.drawMonName:
    ld   c, 8
    ld   de, sMonName + 6 * 8
    ld   hl, $9800 + $20 * 1 + 6
    farcallX drawTextLengthLight
    ld   de, i"        "
    ld   hl, $9800 + $20 * 2 + 6
    call drawTextLight
    ldh  a, [hTMP6]
    ld   e, a
    ld   d, 0
    ld   hl, $9800 + $20 * 2 + 6
    add  hl, de
    ld   bc, $B30D
    call writeToTilemap
    ret

.drawCursor:
    ldh  a, [hTMP5]
    ld   de, $40
    push bc
    call umul8_16
    pop  bc
    ldh  a, [hTMP4]
    ld   e, a
    ld   d, 0
    add  hl, de
    ld   de, $9800 + $20 * 5 + 2
    add  hl, de
    call writeToTilemap
    ret

.finish:
    ld   a, $13
    ldh  [hJingleSFX], a
    ret
