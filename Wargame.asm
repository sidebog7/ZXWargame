include 'util/Macro.asm'

        org 0x8000

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

        ld a,(ix+0)
        cp 3
        jr nc,after_comp_order

        call decide_comp_move

after_comp_order:
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
        jp p,po_continue_loop

        ld a,56
        ld (23695),a
        call clear_textarea

        ld e,0
        ld d,text_row1
        call setxy
        ld hl,text_unit_word
        call text_output

        call output_troop_number

        ld hl,text_decides_to_act
        call text_output

        call output_order_information

        ld a,(ix+troopdata_order)

        cp key_move
        jp z,perform_move_order

        cp key_halt
        jr z,po_continue_loop

        cp key_fire
        jr z,perform_fire_order

po_continue_loop:

        call press_any_key
        ld de,trooplen
        add ix,de
        inc c
        djnz po_order_loop

        ret






        include 'Fire.asm'
        include 'Move.asm'
        include 'Setup.asm'
        include 'Input.asm'
        include 'GameAI.asm'
        include 'Display.asm'
        include 'Utils.asm'

        include 'Data.asm'


end begin
