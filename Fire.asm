perform_fire_order:

        ld e,0
        ld d,20
        call setxy
        ld hl,text_unit_word
        call text_output

        call output_troop_number

        ld hl,text_fires
        call text_output

        push iy
        ld iy,user_troops
        ld a,c
        cp 8
        jp p,pfo_setup_fire
        ld iy,comp_troops

pfo_setup_fire:
        xor a
        ld (data_closest_troop),a
        ld (data_closest_troop+1),a

        ld a,5
        ld (data_closest_troop_xdiff),a
        ld (data_closest_troop_ydiff),a

        push bc

        ld b,8
pfo_start_fire:

        ld a,(ix+troopdata_ypos)
        ld c,(iy+troopdata_ypos)
        sub c
        jp p,pfo_posydiff
        neg
pfo_posydiff:
        ld d,a

        ld a,(ix+troopdata_xpos)
        ld c,(iy+troopdata_xpos)
        sub c
        jp p,pfo_posxdiff
        neg
pfo_posxdiff:
        ld e,a

        ld a,(iy+troopdata_order)
        cp key_rout
        jp p,pmo_next_troop

        ld a,(data_closest_troop_xdiff)
        cp e
        jr c,pmo_next_troop

        ld a,(data_closest_troop_ydiff)
        cp d
        jr c,pmo_next_troop

        push iy
        pop hl
        ld (data_closest_troop),hl
        ld h,d
        ld l,e
        ld (data_closest_troop_xdiff),hl


pmo_next_troop:

        push de
        ld de,trooplen
        add iy,de
        pop de
        djnz pfo_start_fire

        ld hl,(data_closest_troop)
        ld a,h
        add a,l
        cp 0

        jr z,pmo_nothing_in_range

pmo_finished_firing:
        pop bc
        pop iy
        jp po_continue_loop

pmo_nothing_in_range:
        ld d,21
        ld e,0
        call setxy
        ld hl,text_nothing_in_range
        call text_output


        jr pmo_finished_firing

data_closest_troop:
        defw 0
data_closest_troop_xdiff:
        defb 0
data_closest_troop_ydiff:
        defb 0
