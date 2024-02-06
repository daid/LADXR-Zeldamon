SRAM_waitVBlank:
    push hl
    push de
    push bc
    push af

    ld   a, [wCurrentBank]
    push af
    call $08A4 ; PlayAudioStep
    ld   a, $1F
    ld   hl, $7F80 ; activate sfx call
    call do_farcall
    call $0091 ; LADXR update ingame time

.VBlankWaitTillVBlankInterrupt:
    halt ; Wait for VBlank interrupt.
    ldh  a, [$FFD1] ; hNeedsRenderingFrame
    and  a
    jr   z, .VBlankWaitTillVBlankInterrupt
    xor  a
    ldh  [$FFD1], a

    ld   hl, $FFE7
    inc  [hl]

    call $2852 ; ReadJoypadState.readState

    pop  af
    ld   [wCurrentBank], a
    ld   [SET_ROM_BANK], a

    pop  af
    pop  bc
    pop  de
    pop  hl
    ret
