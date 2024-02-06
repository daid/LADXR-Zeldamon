
; Draw the text at DE to VRAM at HL, using dark background
SRAM_drawTextDark:
    ld   a, [de]
    inc  de
    and  a
    ret  z

    push de
    ; Get tile ID
    ld   de, zm_font_codepoint_to_tile - $20
    add  a, e
    ld   e, a
    ld   a, $00
    adc  d
    ld   d, a

    WAIT_STAT
    ld   a, [de]
    ld   [hl], a
    ld   a, $01
    ldh  [rVBK], a
    WAIT_STAT
    ld   a, $8C
    ld   [hl+], a
    xor  a
    ldh  [rVBK], a

    inc  b
    pop  de
    jr   SRAM_drawTextDark

; Draw the text at DE to VRAM at HL, using light background
SRAM_drawTextLight:
    ld   a, [de]
    inc  de
    and  a
    ret  z

    push de
    ; Get tile ID
    ld   de, zm_font_codepoint_to_tile - $20
    add  a, e
    ld   e, a
    ld   a, $00
    adc  d
    ld   d, a

    WAIT_STAT
    ld   a, [de]
    ld   [hl], a
    ld   a, $01
    ldh  [rVBK], a
    WAIT_STAT
    ld   a, $0D
    ld   [hl+], a
    xor  a
    ldh  [rVBK], a

    inc  b
    pop  de
    jr   SRAM_drawTextLight


SRAM_zm_font_codepoint_to_tile:
;             !    "    #    $    %    &    '    (    )    *    +    ,    -    .    /
    db  $CF, $BB, $BF, 0  , 0  , 0  , $C2, $BE, $C3, $C4, 0  , 0  , $B8, $BD, $B7, 0
;        0    1    2    3    4    5    6    7    8    9    :    ;    <    =    >    ?
    db  $C5, $C6, $C7, $C8, $C9, $CA, $CB, $CC, $CD, $CE, $C0, $C1, 0  , 0  , 0  , $BA
;        @    A    B    C    D    E    F    G    H    I    J    K    L    M    N    O
    db  0  , $80, $81, $82, $83, $84, $85, $86, $87, $88, $89, $8a, $8b, $8c, $8d, $8e
;        P    Q    R    S    T    U    V    W    X    Y    Z    [    \    ]    ^    _
    db  $8f, $90, $91, $92, $93, $94, $95, $96, $97, $98, $99, 0  , 0  , 0  , 0  , 0
;        `    a    b    c    d    e    f    g    h    i    j    k    l    m    n    o
    db  0  , $9a, $9b, $9c, $9d, $9e, $9f, $A0, $A1, $A2, $A3, $A4, $A5, $A6, $A7, $A8
;        p    q    r    s    t    u    v    w    x    y    z    {    |    }    ~
    db  $A9, $Aa, $Ab, $Ac, $Ad, $Ae, $Af, $B0, $B1, $B2, $BC, 0  , 0  , 0  , 0  , 0
