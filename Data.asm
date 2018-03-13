

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

map     DEFS 480,0
troops  DEFS 176,0

; troops 0-7  Blue
; troops 8-15 Red
; troops structure
; 0 - 2                     - byte
; 1 - 2                     - byte
; 2 - troop_data 1          - byte
; 3 - troop_data 2          - byte
; 4 - troop_data 3 + rnd*2  - byte
; 5 - (Rnd*100)*10+10       - word
; 6 - As 5                  - word
; 7 - X Position            - byte
; 8 - Y Position            - byte

troop_data:
        ; DEFB

trpinit DEFB 148,149,150,150,151,151,152,152
        DEFB 148,149,150,150,151,151,152,152
