; Execute a division:
; BC = BC / DE
; DE = BC % DE
SRAM_udiv16:
    ;; Check for division by zero
    ld      a,e
    or      d
    jr      NZ,.divide      ; Branch if divisor is non-zero
    ld      bc, 0           ; Divide by zero error
    ld      d,b
    ld      e,c
    scf                     ; Set carry, invalid result
    ret
.divide:
    ld      l,c             ; L = low byte of dividend/quotient
    ld      h,b             ; H = high byte of dividend/quotient
    ld      bc, 0           ; BC = remainder
    or      a               ; Clear carry to start
    ld      a, 16           ; 16 bits in dividend
.dvloop:
    ;; Shift next bit of quotient into bit 0 of dividend
    ;; Shift next MSB of dividend into LSB of remainder
    ;; BC holds both dividend and quotient. While we shift a bit from
    ;;  MSB of dividend, we shift next bit of quotient in from carry
    ;; HL holds remainder
    ;; Do a 32-bit left shift, shifting carry to L, L to H,
    ;;  H to C, C to B
    push    af              ; save number of bits remaining
    rl      l               ; Carry (next bit of quotient) to bit 0
    rl      h               ; Shift remaining bytes
    rl      c
    rl      b               ; Clears carry since BC was 0
    ;; If remainder is >= divisor, next bit of quotient is 1. This
    ;;  bit goes to carry
    push    bc              ; Save current remainder
    ld      a,c             ; Substract divisor from remainder
    sbc     e
    ld      c,a
    ld      a,b
    sbc     d
    ld      b,a
    ccf                     ; Complement borrow so 1 indicates a
                            ;  successful substraction (this is the
                            ;  next bit of quotient)
    jr      C,.drop         ; Jump if remainder is >= dividend
    pop     bc              ; Otherwise, restore remainder
    pop     af              ; recover # bits remaining, carry flag destroyed
    dec     a
    or      a               ; restore (clear) the carry flag
    jr      NZ,.dvloop
    jr      .nodrop
.drop:
    pop     af              ; faster and smaller than 2x inc sp
    pop     af              ; recover # bits remaining, carry flag destroyed
    dec     a
    scf                     ; restore (set) the carry flag
    jr      NZ,.dvloop
    jr      .nodrop
.nodrop:
    ;; Shift last carry bit into quotient
    ld      d,b             ; DE = remainder
    ld      e,c
    rl      l               ; Carry to L
    ld      c,l             ; C = low byte of quotient
    rl      h
    ld      b,h             ; B = high byte of quotient
    or      a               ; Clear carry, valid result
    ret

; HL = A * E
SRAM_umul8_8:
    ld      c, a
    xor     a
    jr SRAM_umul8_16.enter_8_8

; HL = A * DE
SRAM_umul8_16:
    ld      c, a
    xor     a
.enter_8_8:
    ld      l, a
    ld      b, 8
    ld      a, c
.loop8:
    add     hl ,hl
    rla
    jr      NC, .skip8
    add     hl, de
.skip8:
    dec     b
    jr      NZ, .loop8

    ret
