
        ; Draws a border around the play area
        ; Destroys: a,bc,de
border:
        ld a,56
        ld (23695),a
        ld b,16
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
        ld d,16
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
        push de
        push bc
        ld a,56
        ld (23695),a
        ld b,5
        ld d,17
        ld e,0
        call setxy
clear_loop1:
        push bc
        ld b,32
clear_loop2:
        ld a,32
        rst 16
        djnz clear_loop2
        pop bc
        djnz clear_loop1
        pop bc
        pop de
        ret


        ; Shows the status display in the lower pane
        ; Destroys: a, de, hl
show_status:
        call clear_textarea

        ld e,0
        ld d,17
        call setxy
        ld hl,text_unit_word
        call text_output

        ld a,49
        add a,c
        rst 16



        ld e,0
        ld d,18
        call setxy
        ld hl,text_unit_weapon
        call text_output

        call output_weapon_text

        ld e,15
        ld d,18
        call setxy
        ld hl,text_unit_armour
        call text_output

        call output_armour_text

        ld e,0
        ld d,19
        call setxy
        ld hl,text_unit_strength
        call text_output

        ld h, (ix+troopdata_str)
        ld l, (ix+troopdata_str+1)
        call shwnum

        ld e,14
        ld d,19
        call setxy
        ld hl,text_unit_attitude
        call text_output


        call output_morale_text


        ld e,0
        ld d,20
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
        cp 0
        jr z,gwi_noloop
        xor a
gwi_loop:
        add a,text_weapon_length
        djnz gwi_loop
gwi_noloop:
        ld b,0
        ld c,a
        ld hl,text_weapon
        add hl,bc
        ret

        ; Sets hl to the address of the armour text
        ; for the armour in b
        ; Destroys: a, ix
get_armour_hl:

        ld a,b
        cp 0
        jr z,gai_noloop
        xor a
gai_loop:
        add a,text_armour_length
        djnz gai_loop
gai_noloop:
        ld b,0
        ld c,a
        ld hl,text_armour
        add hl,bc
        ret

        ; Sets hl to the address of the morale text
        ; for the weapon in b
        ; Destroys: a, ix
get_morale_hl:

        ld a,b
        cp 0
        jr z,gmi_noloop
        xor a
gmi_loop:
        add a,text_morale_length
        djnz gmi_loop
gmi_noloop:
        ld b,0
        ld c,a
        ld hl,text_morale
        add hl,bc
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
        ld b,a
        sla a
        sla a
        add a,b
        ld hl,text_direction
        ld b,0
        ld c,a
        add hl,bc
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
        sla a
        ld d,0
        ld e,a
        add hl,de
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
        sla a
        ld d,0
        ld e,a
        add hl,de
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
        ld a,c
        sla a
        ld d,0
        ld e,a
        add hl,de
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

        ; Retrieves the address for text for terrain
        ; number b into ix
        ; Destroys: a, bc, ix
get_description_hl:
        ld a,b
        cp 0
        jr z,gdi_noloop
        xor a
gdi_loop:
        add a,text_terrain_length
        djnz gdi_loop
gdi_noloop:
        ld b,0
        ld c,a
        ld hl,text_terrain
        add hl,bc
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
