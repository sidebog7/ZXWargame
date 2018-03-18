

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
        DEFS 176,0
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

text_order_fire:
        DEFB "fire"
text_order_halt:
        DEFB "halt"
text_order_move:
        DEFB "move"
text_order_status:
        DEFB "status"
text_order_rout:
        DEFB "rout"

text_weapon_none:
        DEFB "none"
text_weapon_bow:
        DEFB "bow"
text_weapon_sword:
        DEFB "sword"
text_weapon_axe:
        DEFB "axe"
text_weapon_lance:
        DEFB "lance"

text_morale_cowardly:
        DEFB "cowardly"
text_morale_unwilling:
        DEFB "unwilling"
text_morale_willing:
        DEFB "willing"
text_morale_brave:
        DEFB "brave"
text_morale_valiant:
        DEFB "valiant"

text_unit_knights:
        DEFB "knights"
text_unit_sergeants:
        DEFB "sergeants"
text_unit_menatarms:
        DEFB "men-at-arms"
text_unit_archers:
        DEFB "archers"
text_unit_peasants:
        DEFB "peasants"

text_armour_none:
        DEFB "none"
text_armour_jerkin:
        DEFB "jerkin"
text_armour_chainmail:
        DEFB "chainmail"
text_armour_plate:
        DEFB "plate"

text_terrain_plains:
        DEFB "plains"
text_terrain_village:
        DEFB "village"
text_terrain_woods:
        DEFB "woods"
text_terrain_hills:
        DEFB "hills"

text_press_any_key:
        DEFB "(PRESS ANY KEY)"
        DEFB 0

debug:
        DEFW 0
