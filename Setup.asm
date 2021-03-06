terrain_init:
        ld hl,map
        ld b,16
terrain_next_left_col:
        call get_terrain_tile
        ld (hl),a
        ld de,30
        add hl,de
        djnz terrain_next_left_col

        ld hl,map
        ld b,16
        ld d,1
terrain_next_row:
        inc hl
        call terrain_fill_row
        inc d
        djnz terrain_next_row
        ret

terrain_fill_row: ; Process row d - row, e - column
        push bc
        ld e,2
        ld b,29
terrain_fill_cell:
        push de
        ld d,10
        call random_num_btwn_1_d
        pop de

        cp 8
        jr nc,terrain_get_previous
        call get_terrain_tile
        push de
        ld d,a
        ld a,(hl)

        cp terrain_hill2
        jr nz,terrain_use_tile
        ld a,d
        pop de
        cp terrain_hill1
        jr z, terrain_set_map

        jr terrain_output

terrain_use_tile:
        ld a,d
        pop de
        jr terrain_set_map
terrain_get_previous:
        dec hl
        ld a,(hl)
        cp terrain_hill2
        jr nz,terrain_mountain_check
        ld a,terrain_hill1
terrain_mountain_check:
        inc hl
terrain_set_map:
        ld (hl),a

        cp terrain_hill1
        jr nz,terrain_output  ; a <> 3
        ld a,b
        dec a
        jr z,terrain_output   ; col < 30
        inc hl
        ld (hl),terrain_hill2
        dec hl

terrain_output:

        ld a,(hl)
        or a
        jr z,terrain_row_fin  ; a = 0

        push hl

        ld hl,terrain_colours
        ADD_A_TO_HL
        ld a,(hl)
        ld (ATT),a

        pop hl

        call SETDRAWPOS
        ld a,(hl)

        push de
        call PRINTUDG
        pop de


terrain_row_fin:

        inc hl
        inc e
        djnz terrain_fill_cell
        pop bc
        ret



troops_init:
        ld ix,troops
        ld c,15
        push iy
troop_start_loop:
        ld iy,troop_types
        ld hl,troop_data
        ld b,8
troop_loop:
        ld (ix+troopdata_order),key_halt
        ld (ix+troopdata_dir),direction_north
        ld a,(hl)
        ld (ix+troopdata_weapon),a
        inc hl
        ld a,(hl)
        inc hl
        ld (ix+troopdata_armour),a
        ld e,(hl)
        inc hl
        push de
        ld d,2
        call random_num_btwn_1_d
        pop de
        add a,e
        ld (ix+troopdata_morale),a
        ld d,100
        call random_num_btwn_1_d
        push hl
        ld h,0
        ld l,a
        add hl,hl
        add hl,hl
        add hl,hl
        ADD_A_TO_HL
        ADD_A_TO_HL
        ld a,10
        ADD_A_TO_HL
        ld (ix+troopdata_str),l
        ld (ix+troopdata_str+1),h
        ld (ix+troopdata_str_orig),l
        ld (ix+troopdata_str_orig+1),h
        ld (ix+troopdata_ypos),c
        ld a,(iy)
        ld (ix+troopdata_type), a
        pop hl
        ld de,trooplen
        add ix,de
        inc iy
        djnz troop_loop

        ld a,c
        sub 15
        ld c,a
        jr z,troop_start_loop

        pop iy
        ret


troops_deploy:

        ld c,0
        ld b,2
troops_deploy_loop:
        ld a,56
        add a,b
        ld (ATT),a                ; Set ink 1 or 2
        call troops_output
        inc c
        djnz troops_deploy_loop
        ret

troops_output:
        ld a,c
        rlca
        rlca
        rlca                        ; a = 0 or 8
        push bc
        ld b,8                      ; Count from 8 to 1
        ld c,a
        ld d,1
        ld e,30

troop_choice:

        call get_unplaced_troop

        push de
        ld d,4
        call random_num_btwn_1_d
        pop de

        add a,d
        ld d,a
        push bc
        ld b,d
        call divide_d_e
        ld a,b
        pop bc
        sub d
        ld d,a

        ld (ix+troopdata_xpos),d

        push de
        call SETTROOPDRAWPOS

        ld d,h
        ld e,l
        ld hl,troop_chars
        add hl,de
        ld a,(hl)
        call PRINTUDG
        pop de

        djnz troop_choice

        pop bc
        ret

get_unplaced_troop:
        push de
        ld d,7
        ld e,0
        call random_num                   ; a = between 0 and 7
        pop de

        ld h,0
        ld l,a

        push hl

        ld ix,troops

        push de
        add a,c
        ld e,a
        ld d,trooplen
        call Multiply

        ld d,h
        ld e,l

        add ix,de                         ; IX is the troop location

        pop de

        ld a,(ix+troopdata_xpos)
        or a

        pop hl

        jr nz,get_unplaced_troop          ; Repeat if the troop already has an xpos

        ret
