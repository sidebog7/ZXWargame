
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
        jr clrrow
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
        rra
        ld a,l
        rra
        xor h
        ld h,a
        ld a,l
        rra
        ld a,h
        rra
        xor l
        ld l,a
        xor h
        ld h,a
        ld (seed),hl
        ret
seed:
        DEFW 15

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

        djnz divide_loop
        pop bc
        ret

press_any_key:
        ld a,56
        ld (23695),a
        push de
        ld d,21
        ld e,9
        ld hl,text_press_enter
        call setxy
        call text_output
        pop de

        push bc
        ld bc,49150
pak_loop:
        in a,(c)
        rra
        jr c,pak_loop
        pop bc
        ret

text_output:
        ld a,(hl)
text_output_loop:
        rst 16
        inc hl
        ld a,(hl)
        or a

        jr z,text_fin_output
        jr text_output_loop
text_fin_output:
        ret

text_output_b_chars:
        ld a,(hl)
        rst 16
        inc hl
        djnz text_output_b_chars
        ret


get_y_or_n:
        push bc
gyon_loop:
        ld bc,57342
        in a,(c)
        and 16
        jr z,press_y

        ld bc,32766
        in a,(c)
        and 8
        jr z,press_n

        jr gyon_loop
press_y:
        ld a,1
        jr gyon_fin
press_n:
        ld a,2

gyon_fin:
        pop bc
        ret

        ; Returns in hl the map cell
        ; b = xpos
        ; c = ypos
get_map_cell_in_hl_from_bc:
        push de
        ld d,c
        ld e,30
        call Multiply
        ld d,0
        ld e,b
        add hl,de
        ld d,h
        ld e,l
        ld hl,map
        add hl,de
        pop de
        ret


get_map_cell_in_hl:
        push bc
        ld c,(ix+troopdata_ypos)
        ld b,(ix+troop_max_xpos)
        call get_map_cell_in_hl_from_bc
        pop bc
        ret

setxy_troop:
        ld e,(ix+troopdata_xpos)
        inc e
        ld d,(ix+troopdata_ypos)
        inc d
        call setxy
        ret

; Show number passed in hl, right-justified.
; Destroys: a, de
shwnum:
        ld a,48
        ld de,1000
        call shwdg
        ld de,100
        call shwdg
        ld de,10
        call shwdg
        or 16
        ld de,1
shwdg:
        and 48
shwdg1:
        sbc hl,de
        jr c,shwdg0
        or 16
        inc a
        jr shwdg1
shwdg0:
        add hl,de
        push af
        rst 16
        pop af
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
