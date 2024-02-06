; Simple farcall, call function HL in bank A
SRAM_do_farcall:
    ldh  [hTMP0], a
    ld   a, [wCurrentBank]
    push af
    ldh  a, [hTMP0]
    ld   [wCurrentBank], a
    ld   [SET_ROM_BANK], a ; Change bank
    call $0BEF ; call hl
    ldh  [hTMP0], a
    pop  af
    ld   [wCurrentBank], a
    ld   [SET_ROM_BANK], a ; Change bank back
    ldh  a, [hTMP0]
    ret

; More complex farcall, by modifying-code in sram, call a function in a different bank, this preserves
; all registers, but requires more instructions to call compared to the basic farcall
SRAM_do_farcallX:
    ldh  [hTMP0], a
    ld   a, [wCurrentBank]
    push af
.bankLoadInstr:
    ld   a, $FF
    ld   [wCurrentBank], a
    ld   [SET_ROM_BANK], a ; Change bank
    ldh  a, [hTMP0]
.callInstr:
    call $FFFF
    ldh  [hTMP0], a
    pop  af
    ld   [wCurrentBank], a
    ld   [SET_ROM_BANK], a ; Change bank back
    ldh  a, [hTMP0]
    ret

SRAM_bankedRead:
    ld   [SET_ROM_BANK], a
    ld   a, [hl]
    push af
    ld   a, [wCurrentBank]
    ld   [SET_ROM_BANK], a
    pop  af
    ret

SRAM_bankedReadInc:
    ld   [SET_ROM_BANK], a
    ld   a, [hl+]
    push af
    ld   a, [wCurrentBank]
    ld   [SET_ROM_BANK], a
    pop  af
    ret

SRAM_bankedReadDEInc:
    ld   [SET_ROM_BANK], a
    ld   a, [hl+]
    ld   e, a
    ld   a, [hl+]
    ld   d, a
    ld   a, [wCurrentBank]
    ld   [SET_ROM_BANK], a
    ret

SRAM_bankedReadHL:
    ld   [SET_ROM_BANK], a
    ld   a, [hl+]
    ld   h, [hl]
    ld   l, a
    ld   a, [wCurrentBank]
    ld   [SET_ROM_BANK], a
    ret
