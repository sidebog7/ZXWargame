
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
        ld hl,(seed)
        ld a,h
        and 31
        ld h,a
        ld a,(hl)
        inc hl
        ld (seed),hl
        ret
seed:
        DEFW 0

        ; Returns random number in a
        ; Number will be between 1 and d
random_num_btwn_1_d:
        ld e,1
        call random_num
        ret

        ; Returns random number in a
        ; Number will be between e and d
random_num:
        push bc
        push hl
        ld b,0
        ld a,d
        sub e
        ld c,d
        call random
        ld l,a
        ld h,0
mod_loop:
        or a
        sbc hl,bc
        jp p,mod_loop
        add hl,bc
        ld b,0
        ld c,e
        add hl,bc
        ld a,l
        pop hl
        pop bc
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
