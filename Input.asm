get_order:
        call clear_textarea

        ld a,56+128
        ld (ATT),a

        call SETTROOPDRAWPOS

        ld d,0
        ld e,c
        ld hl,troop_chars
        add hl,de
        ld a,(hl)
        call PRINTUDG

        ld a,56
        ld (ATT),a

        ld d,text_row1
        ld e,0
        call SETDRAWPOS
        ld hl,text_unit_number
        call PRINTSTR
        call output_troop_number
        ld a,32
        call PRINTCHAR

        call output_troop_text

        call output_order_information


        ld d,text_row3
        ld e,0
        call SETDRAWPOS
        ld hl,text_change_orders
        call PRINTSTR

        call get_y_or_n

        dec a
        jr nz,get_order_continue

        jr select_action

get_order_continue:
        call clear_textarea
        call press_any_key

get_order_continue_no_pak:
        ld a,58
        ld (ATT),a

        call SETTROOPDRAWPOS

        ld d,0
        ld e,c
        ld hl,troop_chars
        add hl,de
        ld a,(hl)
        call PRINTUDG

        ret


select_action:
        call clear_textarea

        ld d,text_row1
        ld e,0
        call SETDRAWPOS
        ld hl,text_options_are
        call PRINTSTR



        push bc

        ld b,4
        ld c,0

        ld a,(ix+troopdata_type)
        cp troop_type_archers
        jr z,select_action_output
        inc c
        dec b

select_action_output:

        ld a,text_row1
        add a,c
        ld d,a
        ld e,14
        call SETDRAWPOS

        ld a,c
        call output_order_key
        ld a,32
        call PRINTCHAR
        ld a,45
        call PRINTCHAR
        ld a,32
        call PRINTCHAR
        ld a,c
        call output_order_text

        inc c
        djnz select_action_output

        pop bc

        call get_order_key

        cp key_status
        jp z,show_status

        ld (ix+troopdata_order), a

        cp key_move
        jr z,move_troop

        jr get_order_continue


move_troop:
        push de

        call clear_textarea

        ld d,text_row1
        ld e,0
        call SETDRAWPOS
        ld hl,text_which_way
        call PRINTSTR

        call get_direction_key

        ld (ix+troopdata_dir),a

        pop de

        jp get_order_continue


get_direction_key:
        push bc

gdk_loop:
        ld bc,32766
        in c,(c)

        ld a,c
        and 8
        jr z,gdk_n

        ld bc,65022
        in c,(c)

        ld a,c
        and 2
        jr z,gdk_s

        ld bc,64510
        in c,(c)

        ld a,c
        and 4
        jr z,gdk_e
        ld a,c
        and 2
        jr z,gdk_w


        jr gdk_loop

gdk_n:
        ld a,direction_north
        jr gdk_fin
gdk_s:
        ld a,direction_south
        jr gdk_fin
gdk_e:
        ld a,direction_east
        jr gdk_fin
gdk_w:
        ld a,direction_west
gdk_fin:

        pop bc
        ret

        ; Gets the order key f,s,h,m
        ; Ignores f if not archer (4/5)
        ; Returns in a
        ; 1 - f
        ; 2 - s
        ; 3 - h
        ; 4 - m
get_order_key:
        push bc
gok_loop:
        ld bc,65022
        in c,(c)

        ld a,(ix+troopdata_type)
        cp troop_type_archers
        jr z,gok_check_f
        jr gok_ignore_f

gok_check_f:
        ld a,c
        and 8
        jr z,gok_press_f
gok_ignore_f:
        ld a,c
        and 2
        jr z,gok_press_s

        ld bc,49150
        in a,(c)
        and 16
        jr z,gok_press_h

        ld bc,32766
        in a,(c)
        and 4
        jr z,gok_press_m

        jr gok_loop
gok_press_f:
        ld a,key_fire
        jr gok_fin
gok_press_h:
        ld a,key_halt
        jr gok_fin
gok_press_m:
        ld a,key_move
        jr gok_fin
gok_press_s:
        ld a,key_status

gok_fin:
        pop bc

        ret
