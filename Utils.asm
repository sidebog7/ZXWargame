
clrtxt  push de
        ld a,56
        ld (23695),a
        ld b,5
clrrep  ld a,16
        add a,b
        ld d,a
        ld e,31
clrrow  call setxy
        ld a,' '
        rst 16
        dec e
        jp m,clrnr
        jp clrrow
clrnr   djnz clrrep
        pop de
        ret

setxy   ld a,22
        rst 16
        ld a,d
        rst 16
        ld a,e
        rst 16
        ret

random:
        push bc
        ld a, (seed)
        ld b, a

        rrca ; multiply by 32
        rrca
        rrca
        xor 0x1f

        add a, b
        sbc a, 255 ; carry

        ld (seed), a
        pop bc
        ret
seed    defw 192

rfn:
        call random
        dec d
        and d
        inc a
        ret

Multiply:   ; this routine performs the operation HL=D*E
        ld hl,0                        ; HL is used to accumulate the result
        ld a,d                         ; checking one of the factors; returning if it is zero
        or a
        ret z
        ld b,d                         ; one factor is in B
        ld d,h                         ; clearing D (H is zero), so DE holds the other factor
MulLoop:                         ; adding DE to HL exactly B times
        add hl,de
        djnz MulLoop
        ret
