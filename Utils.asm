

include 'util/Print.asm'
include 'util/Random.asm'

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
        push bc
        push de
        call rnd
        pop de
        pop bc
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



Multiply:
        push bc
        ld a,e              ; make accumulator first multiplier.
        ld e,d              ; HL = D * E
        ld hl,0             ; zeroise total.
        ld d,h              ; zeroise high byte so de=multiplier.
        ld b,8              ; repeat 8 times.
imul1:
        rra                 ; rotate rightmost bit into carry.
        jr nc,imul2         ; wasn't set.
        add hl,de           ; bit was set, so add de.
        and a               ; reset carry.
imul2:
        rl e                ; shift de 1 bit left.
        rl d
        djnz imul1          ; repeat 8 times.
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

divide_de_bc: ; this routine performs the operation BC=DE/A rem A


        ret

press_any_key:

        ld a,56
        ld (ATT),a

        push bc
        push de

        ld de,$1609
        call SETDRAWPOS

        ld hl,text_press_enter
        call PRINTSTR

        ld bc,49150
pak_loop:
        in a,(c)
        rra
        jr c,pak_loop

        ld de,$1609
        call SETDRAWPOS

        ld b,text_press_enter_length

pak_clear_loop:
        push bc
        ld a,32
        call PRINTCHAR
        pop bc
        djnz pak_clear_loop

        pop de
        pop bc
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
        ld b,(ix+troopdata_xpos)
        call get_map_cell_in_hl_from_bc
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
