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
        jp p,po_continue_loop

        ld a,56
        ld (23695),a
        call clear_textarea

        ld e,0
        ld d,text_row1
        call setxy
        ld hl,text_unit_word
        call text_output

        ld a,c
        cp 9
        ld a,49
        jr c,po_troop_less_than_ten
        ld a,49
        rst 16
        ld a,39
po_troop_less_than_ten:
        add a,c
        rst 16

        ld hl,text_decides_to_act
        call text_output

        ld a,(ix+troopdata_order)

        cp key_move
        jr z,perform_move_order

        cp key_halt
        jr z,po_continue_loop

        jr perform_fight_order

po_continue_loop:

        call press_any_key
        ld de,trooplen
        add ix,de
        inc c
        djnz po_order_loop

        ret


perform_fight_order:

        jr po_continue_loop




        include 'Move.asm'
        include 'Setup.asm'
        include 'Input.asm'
        include 'GameAI.asm'
        include 'Display.asm'
        include 'Utils.asm'

        include 'Data.asm'


end begin
