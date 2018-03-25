perform_move_order:

        ld a,(ix+troopdata_xpos)
        ld (troop_old_xpos), a

        ld a,(ix+troopdata_ypos)
        ld (troop_old_ypos), a

        call get_map_cell_in_hl

        ld a,(hl)
        cp 0
        jr z,pmo_no_terrain
        add a,143-32
pmo_no_terrain:
        add a,32
        ld (troop_old_terrain),a


        ld a,c
        cp 8
        ld a,58
        jr c,po_user_colour
        dec a
        po_user_colour:
        ld (23695),a


        ld e,(ix+troopdata_xpos)
        ld d,(ix+troopdata_ypos)
        call setxy
        ld a,(troop_old_terrain)
        rst 16




        jr po_continue_loop
