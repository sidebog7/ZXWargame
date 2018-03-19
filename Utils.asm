
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
        push ix
        ld a,56
        ld (23695),a
        push de
        ld d,21
        ld e,9
        ld ix,text_press_enter
        call setxy
        call text_output
        pop de

        push bc
        ld bc,49150
pak_loop:
        in a,(c)
        and 1
        cp 1
        jr z,pak_loop
        pop bc
        pop ix
        ret

text_output:
        ld a,(ix+0)
        rst 16
        ld a,(ix+1)
        or a
        jp z,text_fin_output
        inc ix

        jp text_output
text_fin_output:
        ret

text_output_b_chars:
        ld a,(ix+0)
        rst 16
        inc ix
        djnz text_output_b_chars
        ret


get_y_or_n:
        push bc
gyon_loop:
        ld bc,57342
        in a,(c)
        and 16
        cp 16
        jr nz,press_y

        ld bc,32766
        in a,(c)
        and 8
        cp 8
        jr nz,press_n

        jp gyon_loop
press_y:
        ld a,1
        jp gyon_fin
press_n:
        ld a,2

gyon_fin:
        pop bc
        ret


fade:
        ld b,7		;maximum of seven colors
fade0:
        ld hl,$5800	;beginning of attr area

        halt		;wait for beginning of frame
        ld de,$262	;0x262 is minimum for a custom IM2 routine
fade_wait:
        dec de		;until we reach active screen area,
        ld a,d		;plus generous overlap to account for
        or e		;different timings of different machines
        jr nz,fade_wait	;before we start drawing behind the beam

fade1:
        ld a,(hl)	;read attr into A
        and 7		;isolate INK
        ld c,a		;copy into C
        jr z,fade_1		;leave it alone, if 0
        dec c		;else, decrement INK
fade_1:
        ld a,(hl)	;reload A with attr
        and $38		;isolate PAPER
        jr z,fade_2		;leave it alone, if 0
        sub 8		;else, decrement PAPER
fade_2:
        or c		;merge with INK
        ld (hl),a	;write attr
        inc hl		;next cell
        ld a,h
        cp $5b		;past the end of attr area?
        jr nz,fade1	;repeat if not
        djnz fade0	;next color down

        ret
