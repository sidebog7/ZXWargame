

gfx
gfxhse  DEFB 16,16,60,126,255,189,231,231
gfxtree DEFB 16,56,84,16,56,84,146,16
gfxhil1 DEFB 8,20,34,65,6,8,16,224
gfxhil2 DEFB 0,48,72,132,2,0,0,0
gfxflag DEFB 128,240,255,252,143,128,128,128
gfxmace DEFB 64,240,72,68,68,68,78,68
gfxshld DEFB 255,231,231,129,129,231,102,60
gfxbow  DEFB 249,70,38,25,9,5,3,1
gfxswd  DEFB 1,2,4,8,16,160,64,160

colscr  EQU 56
colbdr  EQU 0

map:
        DEFS 480,0
troops:
user_troops:
        DEFS 88,0
comp_troops:
        DEFS 88,0
trooplen EQU 11

troopdata1 EQU 0
troopdata2 EQU 1
troopdata3 EQU 2
troopdata4 EQU 3
troopdata5 EQU 4
troopdata6 EQU 5
troopdata7 EQU 7
troopdata_ypos EQU 9
troopdata_xpos EQU 10

; troops 0-7  Blue
; troops 8-15 Red
; troops structure
; 0   - current order         - byte
; 1   - current direction     - byte
; 2   - weaponry              - byte
; 3   - armour                - byte
; 4   - morale                - byte
; 5   - initial strength      - word
; 7   - current strength      - word
; 9   - Y Position            - byte
; 10  - X Position            - byte

troop_data:
        DEFB 5,4,3
        DEFB 5,3,3
        DEFB 4,3,2
        DEFB 3,3,1
        DEFB 2,2,1
        DEFB 2,3,2
        DEFB 3,2,0
        DEFB 3,1,0

troop_chars:
        DEFB 148,149,150,150,151,151,152,152

text_unit_number:
        DEFB "Unit number ",0
text_current_orders:
        DEFB "Current orders are to ",0
text_change_orders:
        DEFB "Do you want to change (Y/N)?",0

text_options_are:
        DEFB "Options are:",0

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


text_weapon_none:
        DEFB "none",0
text_weapon_bow:
        DEFB "bow",0
text_weapon_sword:
        DEFB "sword",0
text_weapon_axe:
        DEFB "axe",0
text_weapon_lance:
        DEFB "lance",0

text_morale_cowardly:
        DEFB "cowardly",0
text_morale_unwilling:
        DEFB "unwilling",0
text_morale_willing:
        DEFB "willing",0
text_morale_brave:
        DEFB "brave",0
text_morale_valiant:
        DEFB "valiant",0

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

text_armour_none:
        DEFB "none",0
text_armour_jerkin:
        DEFB "jerkin",0
text_armour_chainmail:
        DEFB "chainmail",0
text_armour_plate:
        DEFB "plate",0

text_terrain_plains:
        DEFB "plains",0
text_terrain_village:
        DEFB "village",0
text_terrain_woods:
        DEFB "woods",0
text_terrain_hills:
        DEFB "hills",0

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

troop_type_offsets:
troop_type_1:
        DEFW text_unit_knights-text_unit
troop_type_2:
        DEFW text_unit_sergeants-text_unit
troop_type_3:
        DEFW text_unit_menatarms-text_unit
troop_type_4:
        DEFW text_unit_menatarms-text_unit
troop_type_5:
        DEFW text_unit_archers-text_unit
troop_type_6:
        DEFW text_unit_archers-text_unit
troop_type_7:
        DEFW text_unit_peasants-text_unit
troop_type_8:
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

debug:
        DEFW 0
