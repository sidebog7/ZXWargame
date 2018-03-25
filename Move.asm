perform_move_order:

        push de
        push hl
        push bc
        push ix
        pop hl
        ld de,troop_old
        ld bc,trooplen
        ldir
        pop bc
        pop hl
        pop de

        call get_map_cell_in_hl

        ld a,(hl)
        ld (troop_old_terrain),a


        ld a,c
        cp 8
        ld a,58
        jr c,po_user_colour
        dec a
        po_user_colour:
        ld (23695),a



        push ix
        ld ix,troop_old

        call setxy_troop
        ld a,(troop_old_terrain)
        call get_terrain_data
        rst 16

        pop ix


        jr po_continue_loop

        ; Returns in a the tile to draw
        ; Sets the temporary colour to the relevant colour
get_terrain_data:

        cp 0
        jr z,gtd_blank
        add a,143
        jr gtd_continue
gtd_blank:
        ld a,32
gtd_continue:

        push af
        ld hl,terrain_colours
        add a,l
        ld l,a
        ld a,(hl)
        ld a,56
        ld (23695),a
        pop af

        ret
