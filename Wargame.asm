        org 40000

begin:

randomize:
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

        ret

control


        ret

border:
        push de
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
        pop de
        ret


terrain_init:
        push de
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
        pop de
        ret

terrain_fill_row: ; Process row d - row, e - column
        push bc
        ld e,1
        ld b,29
terrain_fill_cell:
        push de
        ld d,10
        call random_fn
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


        ret


get_terrain_tile:
        push de
        ld d,50
        call random_fn
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
