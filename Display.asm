
        ; Draws a border around the play area
        ; Destroys: a,bc,de
border:
        ld a,56
        ld (23695),a
        ld b,17
border_edge:
        ld d,b
        ld e,31
        call setxy
        ld a,150
        rst 16
        ld e,0
        call setxy
        ld a,150
        rst 16
        djnz border_edge
        ld d,17
border_horizontal:
        ld e,0
        call setxy
        ld b,32
border_row:
        ld a,150
        rst 16
        djnz border_row
border_row_fin:
        ld a,d
        or a
        jr z,border_fin   ; a = 0
        ld d,0
        jr border_horizontal
border_fin:
        ret


        ; Clears the lower pane
        ; Destroys: a
clear_textarea:

        push hl
        push bc
        push de

        ld hl,$5040
        ld d,h
        ld e,l
        ld c,6*8
cta_loop:
        ld b,4
cta_row_loop:

        ld (hl),0
        inc l
        ld (hl),0
        inc l
        ld (hl),0
        inc l
        ld (hl),0
        inc l
        ld (hl),0
        inc l
        ld (hl),0
        inc l
        ld (hl),0
        inc l
        ld (hl),0
        inc hl

        djnz cta_row_loop

        inc d
        ld a,d
        and 7
        jr nz,cta_next_line
        ld a,e
        add a,32
        ld e,a
        jr c,cta_next_line
        ld a,d
        sub 8
        ld d,a


cta_next_line:
        ld h,d
        ld l,e
        dec c
        jr nz,cta_loop
        pop de
        pop bc
        pop hl
        ret

        ; Shows the status display in the lower pane
        ; Destroys: a, de, hl
show_status:
        call clear_textarea

        ld e,0
        ld d,text_row1
        call setxy
        ld hl,text_unit_word
        call text_output

        ld a,49
        add a,c
        rst 16



        ld e,0
        ld d,text_row2
        call setxy
        ld hl,text_unit_weapon
        call text_output

        call output_weapon_text

        ld e,15
        ld d,text_row2
        call setxy
        ld hl,text_unit_armour
        call text_output

        call output_armour_text

        ld e,0
        ld d,text_row3
        call setxy
        ld hl,text_unit_strength
        call text_output

        ld l, (ix+troopdata_str)
        ld h, (ix+troopdata_str+1)
        call shwnum

        ld e,14
        ld d,text_row3
        call setxy
        ld hl,text_unit_attitude
        call text_output


        call output_morale_text


        ld e,0
        ld d,text_row4
        call setxy
        ld hl,text_unit_location
        call text_output

        call output_map_cell_description

        call press_any_key

        jp get_order_continue_no_pak

        ; Sets hl to the address of the weapon text
        ; for the weapon in b
        ; Destroys: a, ix
get_weapon_hl:

        ld a,b
        or a
        jr z,gwi_noloop
        xor a
gwi_loop:
        add a,text_weapon_length
        djnz gwi_loop
gwi_noloop:
        ld hl,text_weapon
        ADD_A_TO_HL
        ret

        ; Sets hl to the address of the armour text
        ; for the armour in b
        ; Destroys: a, ix
get_armour_hl:

        ld a,b
        or a
        jr z,gai_noloop
        xor a
gai_loop:
        add a,text_armour_length
        djnz gai_loop
gai_noloop:
        ld hl,text_armour
        ADD_A_TO_HL
        ret

        ; Sets hl to the address of the morale text
        ; for the weapon in b
        ; Destroys: a, ix
get_morale_hl:

        ld a,b
        or a
        jr z,gmi_noloop
        xor a
gmi_loop:
        add a,text_morale_length
        djnz gmi_loop
gmi_noloop:
        ld hl,text_morale
        ADD_A_TO_HL
        ret



        ; Outputs the morale text pointed to by the
        ; troop at ix
output_morale_text:
        push bc
        ld b,(ix+troopdata_morale)
        call get_morale_hl

        ld b,text_morale_length
        call text_output_b_chars
        pop bc
        ret

        ; Outputs the armour text pointed to by the
        ; troop at ix
output_armour_text:
        push bc
        ld b,(ix+troopdata_armour)
        call get_armour_hl

        ld b,text_armour_length
        call text_output_b_chars
        pop bc
        ret

        ; Outputs the weapon text pointed to by the
        ; troop at ix
output_weapon_text:
        push bc
        ld b,(ix+troopdata_weapon)
        call get_weapon_hl

        ld b,text_weapon_length
        call text_output_b_chars
        pop bc
        ret

        ; Outputs the order direction text for
        ; troop at ix
        ; Destroys a
output_order_direction:
        ld a,32
        rst 16
        push bc
        ld a,(ix+troopdata_dir)
        dec a
        ld b,a
        rlca
        rlca
        add a,b
        ld hl,text_direction
        ADD_A_TO_HL
        ld b,5
        call text_output_b_chars
        pop bc
        ret

        ; Outputs the relevant Order text for
        ; troop at ix
        ; Destroys: a, de, hl
output_troop_order_text:
        ld a,(ix+troopdata_order)
        call output_order_text
        ret

        ; Outputs the relevant Order text for
        ; order a (0-3)
        ; Destroys: a, de, hl
output_order_text:
        ld hl,troop_order_offsets
        rlca
        ADD_A_TO_HL
        ld e,(hl)
        inc hl
        ld d,(hl)
        ld hl,text_order
        add hl,de
        call text_output
        ret

        ; Outputs the relevant Order text for
        ; order a (0-3)
        ; Destroys: a, de, hl
output_order_key:
        ld hl,troop_order_offsets
        rlca
        ADD_A_TO_HL
        ld e,(hl)
        inc hl
        ld d,(hl)
        ld hl,text_order
        add hl,de
        ld a,(hl)
        rst 16
        ret

        ; Outputs the relevant Troop name for
        ; troop number stored in c
        ; Destroys: a, de, hl
output_troop_text:

        ld hl,troop_type_offsets
        ld a,(ix+troopdata_type)
        sla a
        ADD_A_TO_HL
        ld e,(hl)
        inc hl
        ld d,(hl)
        ld hl,text_unit
        add hl,de
        call text_output
        ret

        ; Outputs the terrain referenced at the
        ; x and y pos of the troop at ix
output_map_cell_description:

        call get_map_cell_in_hl

        push bc

        ld b,(hl)
        call output_description_text

        pop bc

        ret

        ; Outputs the terrain text referenced by
        ; register b
        ; Destroys: bc
output_description_text:

        call get_description_hl

        ld b,text_terrain_length
        call text_output_b_chars
        ret

        ; Outputs the number 1 through 16
        ; Number to print out is passed in c
output_troop_number:

        ld a,c
        cp 9
        ld a,49
        jr c,po_troop_less_than_ten
        rst 16
        ld a,39
po_troop_less_than_ten:
        add a,c
        rst 16
        ret

output_order_information:
        ld d,text_row2
        ld e,0
        call setxy
        ld hl,text_current_orders
        call text_output

        call output_troop_order_text

        ld a,(ix+troopdata_order)
        cp key_move
        jr nz,ooi_no_move

        call output_order_direction
ooi_no_move:
        ret


output_troop_after_move:

        push ix
        ld ix,troop_old

        call setxy_troop
        ld a,(troop_old_terrain)
        call get_terrain_data
        rst 16
        pop ix

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
pmo_c_user_player:

        ld hl,troop_chars
        ADD_A_TO_HL
        ld a,(hl)
        rst 16



        ret

        ; Retrieves the address for text for terrain
        ; number b into ix
        ; Destroys: a, bc, ix
get_description_hl:
        ld a,b
        or a
        jr z,gdi_noloop
        xor a
gdi_loop:
        add a,text_terrain_length
        djnz gdi_loop
gdi_noloop:
        ld hl,text_terrain
        ADD_A_TO_HL
        ret




        ; Sets a to random terrain tile (0-3)
        ; Destroys: a
get_terrain_tile:
        push de
        ld d,50
        call random_num_btwn_1_d
        pop de

        cp 6        ; 1-6
        jp m,trn1
        xor a
        ret
trn1:
        cp 5        ; 1-5
        jp m,trn2
        ld a,3
        ret
trn2:
        cp 2       ; 1-1
        jp m,trn3
        ld a,2
trn3:
        ret
