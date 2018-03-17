
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

        ; Sets the x position to e
        ; Sets the y position to d
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
        dec d
        call random_num
        ret

        ; Returns random number in a
        ; Number will be between e and d
random_num:
        inc d
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
        push bc
        ld hl,0                        ; HL is used to accumulate the result
        ld a,d                         ; checking one of the factors; returning if it is zero
        or a
        ret z
        ld b,d                         ; one factor is in B
        ld d,h                         ; clearing D (H is zero), so DE holds the other factor
MulLoop:                         ; adding DE to HL exactly B times
        add hl,de
        djnz MulLoop
        pop bc
        ret

divide_d_e:   ; this routine performs the operation D=D/E rem A
        push bc
        xor	a
        ld	b, 8

divide_loop:
        sla	d
        rla
        cp	e
        jr	c, $+4
        sub	e
        inc	d

        djnz	divide_loop
        pop bc
        ret

press_any_key:
        ld a,56
        ld (23695),a
        push de
        ld d,21
        ld e,7
        ld ix,text_press_any_key
pak_textloop:
        call setxy
        ld a,(ix+0)
        rst 16
        ld a,(ix+1)
        or a
        jp z,pak_fin_textloop
        inc e
        inc ix

        jp pak_textloop
pak_fin_textloop:
        pop de

        push hl
        ld hl,23560
        ld (hl),0
pak_loop:
        ld a,(hl)
        or a
        jr z,pak_loop
        pop hl
        ret
