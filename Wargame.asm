        org 40000

begin:

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

        ret

control


        ret

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
        ld e,31
border_row:
        call setxy
        ld a,150
        rst 16
        dec e
        jp m,border_row_fin
        jp border_row
border_row_fin:
        ld a,d
        cp 0
        jp z,border_fin
        ld d,0
        jp border_horizontal
border_fin:
        ret


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
        jp nc,terrain_get_previous
        call get_terrain_tile
        jp terrain_set_map
terrain_get_previous:
        dec hl
        ld a,(hl)
        inc hl
terrain_set_map:
        ld (hl),a

        cp 3
        jp nz,terrain_output  ; a <> 3
        ld a,b
        cp 1
        jp z,terrain_output   ; col < 30
        inc hl
        ld (hl),4
        dec hl

terrain_output:

        ld a,(hl)
        cp 0
        jp z,terrain_row_fin
        cp 3
        jp z,terrain_output_2
        call setxy
        ld a,143
        add a,(hl)
        rst 16
        jp terrain_row_fin

terrain_output_2:

        ld a,(hl)
        cp 3
        jp nz,terrain_row_fin
        ld a,e
        cp 30
        jp z,terrain_row_fin
        call setxy
        ld a,146
        rst 16
        inc e
        call setxy
        dec e
        ld a,147
        rst 16


terrain_row_fin:

        inc hl
        inc e
        djnz terrain_fill_cell
        pop bc
        ret


troops_init:
        ld ix,troops
        ld c,15
troop_start_loop:
        ld hl,troop_data
        ld b,8
troop_loop:
        ld (ix+0),2
        ld (ix+1),2
        ld a,(hl)
        ld (ix+2),a
        inc hl
        ld a,(hl)
        inc hl
        ld (ix+3),a
        ld e,(hl)
        inc hl
        push de
        ld d,2
        call random_num_btwn_1_d
        pop de
        add a,e
        ld (ix+4),a
        ld d,100
        call random_num_btwn_1_d
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
        ld (ix+5),h
        ld (ix+6),l
        ld (ix+7),h
        ld (ix+8),l
        ld (ix+troopdata_ypos),c
        pop hl
        ld d,0
        ld e,trooplen
        add ix,de
        djnz troop_loop

        ld a,c
        sub 14
        ld c,a
        cp 1
        jp z,troop_start_loop

        ret


troops_deploy:

        ld c,0
        ld b,2
troops_deploy_loop:
        ld a,56
        add a,b
        ld (23695),a                ; Set ink 1 or 2
        call troops_output
        ld a,c
        add a,8
        ld c,a
        djnz troops_deploy_loop
        ret

troops_output:
        ld a,c
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
        pop de
        add a,c

        push de

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
        cp 0


        jp nz,troop_choice


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
        ld a,65
        rst 16
        pop de

        djnz troop_choice

        pop de
        pop bc
        ret

get_terrain_tile:
        push de
        ld d,50
        call random_num_btwn_1_d
        pop de

        cp 6        ; 1-6
        jp m,trn1
        ld a,0
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

        include 'Utils.asm'
        include 'Data.asm'


end begin
