
        ; Choose the computer's next move
        ; Troop is stored at ix
        ; index number is at c
decide_comp_move:
        ld (ix+troopdata_dir),direction_south
        push de

dcm_choose_random_move:

        ld d,3
        call random_num_btwn_1_d

        ld (ix+troopdata_order),a

        cp key_fire
        jr nz,dcm_after_choose_move

        ld a,(ix+troopdata_type)
        cp troop_type_knight
        jr nz,dcm_choose_random_move

dcm_after_choose_move:

        ld a,(ix+troopdata_order)
        cp key_move
        jr nz,dcm_not_chosen_move

        ld d,2
        call random_num_btwn_1_d
        cp 1
        jr nz,dcm_not_chosen_move

        ld d,4
        call random_num_btwn_1_d

        ld (ix+troopdata_dir), a

dcm_not_chosen_move:

        pop de
        ret
