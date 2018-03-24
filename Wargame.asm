        org 40000

begin:
        di

        ld bc,(23672)
        ld (seed),bc

        ld a,colscr
        ld (23693),a
        call 3503
        ld a,colbdr
        call 8859

        ; Set up graphics
        ld hl,gfx
        ld (23675),hl

        call 3503

        call terrain_init

        call border

        call troops_init

        call troops_deploy

        call clear_textarea

        call press_any_key

        call game_loop_start

        ei
        ret



game_loop_start:
        ld b,8
        ld c,0
        ld ix,troops
game_user_loop:

        ld a,(ix+0)
        cp 3
        jr nc,after_order

        call get_order
after_order:



        ld de,trooplen
        add ix,de
        inc c
        djnz game_user_loop

        ld b,8
        ld c,8
game_comp_loop:



        ld de,trooplen
        add ix,de
        inc c
        djnz game_comp_loop

        call perform_orders

        ret


perform_orders:

        ld b,16
        ld c,0
        ld ix,troops
po_order_loop:

        ld a,(ix+troopdata_order)
        cp key_status
        jp p,po_order_loop_fin

        ld a,56
        ld (23695),a
        call clear_textarea

        ld e,0
        ld d,17
        call setxy
        push ix
        ld ix,text_unit_word
        call text_output
        pop ix

        ld a,49
        add a,c
        rst 16

        push ix
        ld ix,text_decides_to_act
        call text_output
        pop ix

        ld d,57
        ld a,c
        cp 8
        jr c,po_user_colour
        inc d
po_user_colour:
        ld a,d
        ld (23695),a

        ld a,(ix+troopdata_order)
        cp key_move
        jr z,perform_move_order

        cp key_halt
        jr z,po_order_loop_fin

        jr perform_fight_order

po_continue_loop:


po_order_loop_fin:
        ld de,trooplen
        add ix,de
        inc c
        djnz po_order_loop

        ret


perform_fight_order:

        jr po_continue_loop

perform_move_order:

        jr po_continue_loop

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
        jr terrain_set_map
terrain_get_previous:
        dec hl
        ld a,(hl)
        inc hl
terrain_set_map:
        ld (hl),a

        cp 3
        jr nz,terrain_output  ; a <> 3
        ld a,b
        dec a
        jr z,terrain_output   ; col < 30
        inc hl
        ld (hl),4
        dec hl

terrain_output:

        ld a,(hl)
        or a
        jr z,terrain_row_fin  ; a = 0
        cp 3
        jr z,terrain_output_2 ; a = 3
        call setxy
        ld a,143
        add a,(hl)
        rst 16
        jr terrain_row_fin

terrain_output_2:

        ld a,(hl)
        cp 3
        jr nz,terrain_row_fin
        ld a,e
        cp 30
        jr z,terrain_row_fin
        call setxy
        ld a,146
        rst 16
        ld a,147
        rst 16


terrain_row_fin:

        inc hl
        inc e
        djnz terrain_fill_cell
        pop bc
        ret


troops_init:
        ld iy,debug
        ld ix,troops
        ld c,15
troop_start_loop:
        ld hl,troop_data
        ld b,8
troop_loop:
        ld (ix+troopdata_order),1
        ld (ix+troopdata_dir),1
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
        ld (iy),a
        inc iy
        push hl
        ld h,0
        ld l,a
        ld d,0
        ld e,a
        add hl,hl
        add hl,hl
        add hl,hl
        add hl,de
        add hl,de
        ld e,10
        add hl,de
        ld (ix+troopdata_str),h
        ld (ix+troopdata_str+1),l
        ld (ix+troopdata_str_orig),h
        ld (ix+troopdata_str_orig+1),l
        ld (ix+troopdata_ypos),c
        pop hl
        ld d,0
        ld e,trooplen
        add ix,de
        djnz troop_loop

        ld a,c
        sub 14
        ld c,a
        dec a
        jr z,troop_start_loop

        ret


troops_deploy:

        ld c,0
        ld b,2
troops_deploy_loop:
        ld a,56
        add a,b
        ld (23695),a                ; Set ink 1 or 2
        call troops_output
        inc c
        djnz troops_deploy_loop
        ret

troops_output:
        ld a,c
        sla a
        sla a
        sla a
        push bc
        push de
        ld b,8
        ld c,a
        ld d,1
        ld e,30

troop_choice:
        push de
        ld d,7
        ld e,0
        call random_num

        ld d,0
        ld e,a
        add a,c

        ld ix,troop_chars
        add ix,de

        ld d,trooplen
        ld e,a

        call Multiply

        ld de,troops
        add hl,de

        ld d,0
        ld e,troopdata_xpos
        add hl,de

        pop de

        ld a,(hl)
        or a

        jr nz,troop_choice

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
        sub d
        pop bc
        ld d,a

        ld (hl),d

        push de
        ld e,(hl)
        dec hl
        ld d,(hl)
        call setxy
        ld a,(ix+0)
        rst 16
        pop de

        djnz troop_choice

        pop de
        pop bc
        ret

        include 'Input.asm'
        include 'GameAI.asm'
        include 'Display.asm'
        include 'Utils.asm'

        include 'Data.asm'


end begin
