

gfx
gfxblnk DEFB 0,0,0,0,0,0,0,0
gfxhse  DEFB 16,16,60,126,255,189,231,231
gfxtree DEFB 16,56,84,16,56,84,146,16
gfxhil1 DEFB 8,20,34,65,6,8,16,224
gfxhil2 DEFB 0,48,72,132,2,0,0,0
gfxflag DEFB 128,240,255,252,143,128,128,128
gfxmace DEFB 64,240,72,68,68,68,78,68
gfxshld DEFB 255,231,231,129,129,231,102,60
gfxbow  DEFB 249,70,38,25,9,5,3,1
gfxswd  DEFB 1,2,4,8,16,160,64,160

char_blank:     EQU 0
char_hse:       EQU 1
char_tree:      EQU 2
char_hill1:     EQU 3
char_hill2:     EQU 4
char_flag:      EQU 5
char_mace:      EQU 6
char_shld:      EQU 7
char_bow:       EQU 8
char_swd:       EQU 9

terrain_blank   EQU 0
terrain_house   EQU 1
terrain_tree    EQU 2
terrain_hill1   EQU 3
terrain_hill2   EQU 4

terrain_colours:
;                              FBPPPIII
terrain_colour_blank    DEFB  %00111000
terrain_colour_house    DEFB  %00111011
terrain_colour_tree     DEFB  %00111100
terrain_colour_hill1    DEFB  %00111101
terrain_colour_hill2    DEFB  %00111101


colscr  EQU 56
colbdr  EQU 0

map:
        DEFS 30*16,0

trooplen EQU 12
troopdata_order     EQU 0
troopdata_dir       EQU 1
troopdata_weapon    EQU 2
troopdata_armour    EQU 3
troopdata_morale    EQU 4
troopdata_str_orig  EQU 5
troopdata_str       EQU 7
troopdata_ypos      EQU 9
troopdata_xpos      EQU 10
troopdata_type      EQU 11

troops:
user_troops:
        DEFS trooplen*8,0
comp_troops:
        DEFS trooplen*8,0

troop_type_knight     EQU 0
troop_type_sergeant   EQU 1
troop_type_menatarms  EQU 2
troop_type_archers    EQU 3
troop_type_peasants   EQU 4

troop_min_xpos        EQU 0
troop_max_xpos        EQU 29
troop_min_ypos        EQU 0
troop_max_ypos        EQU 15

troop_types:
        DEFB troop_type_knight
        DEFB troop_type_sergeant
        DEFB troop_type_menatarms
        DEFB troop_type_menatarms
        DEFB troop_type_archers
        DEFB troop_type_archers
        DEFB troop_type_peasants
        DEFB troop_type_peasants

; troops 0-7  Blue
; troops 8-15 Red
; troops structure
; 0   - current order         - byte    -       1
; 1   - current direction     - byte    -       2
; 2   - weaponry              - byte    -       3
; 3   - armour                - byte    -       4
; 4   - morale                - byte    -       5
; 5   - initial strength      - word    -       6
; 7   - current strength      - word    -       7
; 9   - Y Position            - byte    -       8
; 10  - X Position            - byte    -       9
; 11  - Type                  - byte

troop_data:
        DEFB 4,3,2
        DEFB 4,2,2
        DEFB 3,2,1
        DEFB 2,2,0
        DEFB 1,1,0
        DEFB 1,2,1
        DEFB 2,1,-1
        DEFB 2,0,-1

direction_north   EQU 1
direction_west    EQU 2
direction_south   EQU 3
direction_east    EQU 4

troop_chars:
        DEFB char_flag,char_mace,char_shld,char_shld
        DEFB char_bow,char_bow,char_swd,char_swd

troop_old:
        DEFS trooplen,0
troop_old_terrain:
        DEFB 0

text_row1   EQU 18
text_row2   EQU 19
text_row3   EQU 20
text_row4   EQU 21

text_unit_number:
        DEFB "Unit number ",0
text_current_orders:
        DEFB "Current orders are to ",0
text_change_orders:
        DEFB "Do you want to change (Y/N)?",0

text_options_are:
        DEFB "Options are:",0

text_which_way:
        DEFB "Which way (NSEW)?",0

text_decides_to_act:
        DEFB " decides to act",0

text_nothing_in_range:
        DEFB "Nothing in range",0

text_fires:
        DEFB " fires",0

text_that_causes:
        DEFB "That causes ",0
text_casualties:
        DEFB " casualties on unit ",0

text_unit_word:
        DEFB "Unit ",0
text_unit_weapon:
        DEFB "Weapon: ",0
text_unit_armour:
        DEFB "Armour: ",0
text_unit_strength:
        DEFB "Strngth: ",0
text_unit_attitude:
        DEFB "Attitude:",0
text_unit_location:
        DEFB "Location: ",0

text_order:
text_order_fire:
        DEFB "fire",0
text_order_halt:
        DEFB "halt",0
text_order_move:
        DEFB "move",0
text_order_status:
        DEFB "status",0
text_order_rout:
        DEFB "rout",0

text_weapon:
text_weapon_length  EQU 5
text_weapon_none:
        DEFB "none "
text_weapon_bow:
        DEFB "bow  "
text_weapon_sword:
        DEFB "sword"
text_weapon_axe:
        DEFB "axe  "
text_weapon_lance:
        DEFB "lance"

text_morale:
text_morale_length  EQU 9
text_morale_cowardly:
        DEFB "cowardly "
text_morale_unwilling:
        DEFB "unwilling"
text_morale_willing:
        DEFB "willing  "
text_morale_brave:
        DEFB "brave    "
text_morale_valiant:
        DEFB "valiant  "

text_unit:
text_unit_knights:
        DEFB "knights",0
text_unit_sergeants:
        DEFB "sergeants",0
text_unit_menatarms:
        DEFB "men-at-arms",0
text_unit_archers:
        DEFB "archers",0
text_unit_peasants:
        DEFB "peasants",0

text_armour:
text_armour_length  EQU 9
text_armour_none:
        DEFB "none     "
text_armour_jerkin:
        DEFB "jerkin   "
text_armour_chainmail:
        DEFB "chainmail"
text_armour_plate:
        DEFB "plate    "

text_terrain:
text_terrain_length EQU 7
text_terrain_plains:
        DEFB "plains "
text_terrain_village:
        DEFB "village"
text_terrain_woods:
        DEFB "woods  "
text_terrain_hills:
        DEFB "hills  "

text_direction:
text_direction_north:
        DEFB "north"
text_direction_west:
        DEFB "west "
text_direction_south:
        DEFB "south"
text_direction_east:
        DEFB "east "

text_press_enter:
        DEFB "(PRESS ENTER)",0
text_press_enter_length EQU $-text_press_enter-1

troop_type_offsets:
troop_type_0:
        DEFW text_unit_knights-text_unit
troop_type_1:
        DEFW text_unit_sergeants-text_unit
troop_type_2:
        DEFW text_unit_menatarms-text_unit
troop_type_3:
        DEFW text_unit_archers-text_unit
troop_type_4:
        DEFW text_unit_peasants-text_unit

troop_order_offsets:
troop_order_0:
        DEFW text_order_fire-text_order
troop_order_1:
        DEFW text_order_halt-text_order
troop_order_2:
        DEFW text_order_move-text_order
troop_order_3:
        DEFW text_order_status-text_order
troop_order_4:
        DEFW text_order_rout-text_order

key_fire        EQU 0
key_halt        EQU 1
key_move        EQU 2
key_status      EQU 3
key_rout        EQU 4

debug:
        DEFW 0
debugseed:
        DEFW 0
