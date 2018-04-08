perform_move_order:

        call copy_troop_to_temp

        call get_map_cell_in_hl

        ld a,(hl)
        ld (troop_old_terrain),a

        push bc

        ; Move calculation

        ; d = D - Max Distance
        call pmo_move_get_max_distance

        ; c = up
        ; b = al
        call pmo_move_get_direction

pmo_move_loop:

        ; pushes bc onto the stack and sets up new position
        ; b = n1 - xpos
        ; c = np - ypos
        push bc
        call pmo_setup_new_position

        call get_map_cell_in_hl_from_bc

        ld a,(hl)
        or a
        jr z,pmo_move_blank_terrain
        dec d

pmo_move_blank_terrain:
        ld a,d
        or a
        jr z,pmo_finished_moving

        call pmo_move_check_collisions

        ld a,d
        or a
        jr z,pmo_finished_moving

        ld (ix+troopdata_xpos),b
        ld (ix+troopdata_ypos),c
        dec d
        jr z,pmo_finished_moving

        pop bc
        jr pmo_move_loop

pmo_finished_moving:
        pop bc
        pop bc

        call output_troop_after_move

        jp po_continue_loop





pmo_setup_new_position:

        push de

        ld a,(ix+troopdata_xpos)
        add a,b

        push bc
        ld b,troop_min_xpos
        ld c,troop_max_xpos
        call pmo_validate_pos
        pop bc

        ; n1 = d
        ld d,a

        ld a,(ix+troopdata_ypos)
        add a,c

        push bc
        ld b,troop_min_ypos
        ld c,troop_max_ypos
        call pmo_validate_pos
        pop bc

        ; np = e
        ld e,a

        ld b,d
        ld c,e

        pop de

        ret


pmo_move_get_max_distance:
        ld a,5
        ld d,(ix+troopdata_armour)
        sub d
        ld d,a
        ld a,(ix+troopdata_type)
        cp troop_type_knight
        jr z,pmo_mgmd_mounted
        cp troop_type_sergeant
        jr z,pmo_mgmd_mounted
        ret
pmo_mgmd_mounted:
        inc d
        inc d
        ret

pmo_move_get_direction:

        ld e,(ix+troopdata_dir)
        dec e
        ld a,e
        sub 2

        ld b,a
        ld c,0

        bit 0,e
        jr nz,pmo_mgd_horizontal_move
        ld c,e
        dec c
        ld b,0
pmo_mgd_horizontal_move:
        ret


pmo_move_check_collisions:

        push de
        push bc
        ld d,b
        ld e,c                ; copy bc into de
        ld hl,user_troops
        ld b,8
pmo_move_check_user_troops:
        push de
        push hl
        push ix
        pop de
        sbc hl,de
        pop hl
        pop de
        jr z,pmo_mcc_next_user_troop

        jr pmo_mcc_check_for_collision

pmo_mcc_next_user_troop:
        push de
        ld de,trooplen
        add hl,de
        pop de

        djnz pmo_move_check_user_troops

        pop bc
        pop de
        ret

pmo_mcc_reset_d:
        pop bc
        pop de
        ld d,0
        ret

pmo_mcc_check_for_collision:
        push ix
        push hl
        pop ix

        ld a,(ix+troopdata_xpos)
        cp d
        jr nz,pmo_mcc_check_comp_troops
        ld a,(ix+troopdata_ypos)
        cp e
        jr nz,pmo_mcc_check_comp_troops
        pop ix
        jr pmo_mcc_reset_d

pmo_mcc_check_comp_troops:
        push de
        ld de,trooplen*8
        add ix,de
        pop de

        ld a,(ix+troopdata_xpos)
        cp d
        jr nz,pmo_mcc_found_no_collision
        ld a,(ix+troopdata_ypos)
        cp e
        jr nz,pmo_mcc_found_no_collision
        pop ix
        jr pmo_mcc_reset_d

pmo_mcc_found_no_collision:
        pop ix
        jr pmo_mcc_next_user_troop



pmo_validate_pos:
        cp b
        jp m,pmo_move_pos_min
        cp c
        jp p,pmo_move_pos_max
        ret
pmo_move_pos_min:
        ld a,b
        jr pmo_accept_pos
pmo_move_pos_max:
        ld a,c
pmo_accept_pos:
        ret


        ; Returns in a the tile to draw
        ; Sets the temporary colour to the relevant colour
get_terrain_data:

        push af
        ld hl,terrain_colours
        add a,l
        ld l,a
        ld a,(hl)
        ld (ATT),a
        pop af

        ret

copy_troop_to_temp:
        push hl
        push bc
        push ix
        pop hl
        ld de,troop_old
        ld bc,trooplen
        ldir
        pop bc
        pop hl
        ret
