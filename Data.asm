

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
; 0   - 2                     - byte
; 1   - 2                     - byte
; 2   - troop_data 1          - byte
; 3   - troop_data 2          - byte
; 4   - troop_data 3 + rnd*2  - byte
; 5   - (Rnd*100)*10+10       - word
; 7   - As 5                  - word
; 9   - X Position            - byte
; 10  - Y Position            - byte

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

debug:
        DEFW 0
