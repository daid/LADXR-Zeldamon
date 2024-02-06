; Find the index of an alive player mon, return the index in B
; returns with zero flag set of there is no mon available.
findAlivePlayerMon:
    ld   c, 6
    ld   b, 0
    ld   hl, sMonType
    jr   findAliveMonImpl

; Find the index of an alive enemy mon, return the index in B
; returns with zero flag set of there is no mon available.
findAliveEnemyMon:
    ld   c, 6
    ld   b, 6
    ld   hl, sMonType + 6

findAliveMonImpl:
.loop:
    ld   a, [hl+]
    cp   $FF
    jr   z, .skip
    push hl
    ld   a, b
    add  a, a
    ldhl_add_a sMonHP
    ld   a, [hl+]
    or   [hl]
    pop  hl
    ret  nz
.skip:
    inc  b
    dec  c
    jr   nz, .loop
    xor  a
    ret
