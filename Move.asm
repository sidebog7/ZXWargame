perform_move_order:

        push hl
        push bc
        push ix
        pop hl
        ld de,troop_old
        ld bc,trooplen
        ldir
        pop bc
        pop hl

        call get_map_cell_in_hl

        ld a,(hl)
        ld (troop_old_terrain),a





        call output_troop_after_move


        jr po_continue_loop


output_troop_after_move:
        ld a,c
        cp 8
        ld a,58
        jr c,po_user_colour
        dec a
        po_user_colour:
        ld (23695),a

        call setxy_troop
        ld a,c
        cp 8
        jr c,pmo_c_user_player
        sub 8
        pmo_c_user_player
        ld d,0
        ld e,c
        ld hl,troop_chars
        add hl,de
        ld a,(hl)
        rst 16

        push ix
        ld ix,troop_old

        call setxy_troop
        ld a,(troop_old_terrain)
        call get_terrain_data
        rst 16

        pop ix

        ret

        ; Returns in a the tile to draw
        ; Sets the temporary colour to the relevant colour
get_terrain_data:

        push af
        ld hl,terrain_colours
        add a,l
        ld l,a
        ld a,(hl)
        ld (23695),a
        pop af

        cp 0
        jr z,gtd_blank
        add a,143
        jr gtd_continue
gtd_blank:
        ld a,32
gtd_continue:

        ret
