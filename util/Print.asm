        ; Sets the next draw position for the
        ; PRINTCHAR and PRINTUDG routines
        ; d is the row (y)
        ; e is the column (x)
        ; Destroys: a
SETDRAWPOS:
        push hl
        ld a,d
        and $18
        ld h,a
        set 6,h
        rrca
        rrca
        rrca
        or $58
        ld a,d
        and 7
        rrca
        rrca
        rrca
        add a,e
        ld l,a
        ld (DFCC),hl
        pop hl
        ret


SETTROOPDRAWPOS:
        ld e,(ix+troopdata_xpos)
        inc e
        ld d,(ix+troopdata_ypos)
        inc d
        call SETDRAWPOS
        ret

PRINTSTR:
        ld a,(hl)
PRINTSTR_LOOP:
        call PRINTCHAR
        inc hl
        ld a,(hl)
        or a
        jr nz,PRINTSTR_LOOP
        ret


PRINTBCHARS:
        ld a,(hl)
        call PRINTCHAR
        inc hl
        djnz PRINTBCHARS
        ret

PRINTUDG:
        push hl
        ld l,a
        ld h,0
        add hl,hl
        add hl,hl
        add hl,hl
        ld de,gfx
        add hl,de
        jr PRINT1

        ; Prints the specified character from the BASE font set
        ; a is the character
        ; Destroys: de, a
PRINTCHAR:
        push hl
        ld l,a
        ld h,0
        add hl,hl
        add hl,hl
        add hl,hl
        ld de,(BASE)
        add hl,de

PRINT1:
        ld de,(DFCC)

        ld a,(hl)
        ld (de),a
        inc hl
        inc d
        ld a,(hl)
        ld (de),a
        inc hl
        inc d
        ld a,(hl)
        ld (de),a
        inc hl
        inc d
        ld a,(hl)
        ld (de),a
        inc hl
        inc d
        ld a,(hl)
        ld (de),a
        inc hl
        inc d
        ld a,(hl)
        ld (de),a
        inc hl
        inc d
        ld a,(hl)
        ld (de),a
        inc hl
        inc d
        ld a,(hl)
        ld (de),a
        inc hl
        inc d

        ld a,d
        rrca
        rrca
        rrca
        dec a
        and 3
        or $58
        ld d,a
        ld hl,(ATT)

        ld a,(de)
        xor l
        and h
        xor l
        ld (de),a

        ld hl,DFCC
        inc (hl)
        pop hl
        ret nz
        push hl
        inc hl
        ld a,(hl)
        add a,8
        ld (hl),a
        pop hl
        ret

; Show number passed in hl, right-justified.
; Destroys: a, de
SHWNUM:
        ld a,48
        ld de,1000
        call SHWDG
        ld de,100
        call SHWDG
        ld de,10
        call SHWDG
        or 16
        ld de,1
SHWDG:
        and 48
SHWDG1:
        sbc hl,de
        jr c,SHWDG0
        or 16
        inc a
        jr SHWDG1
SHWDG0:
        add hl,de
        push af
        push hl
        call PRINTCHAR
        pop hl
        pop af
        ret

BASE:
        defw $3c00
DFCC:
        defw $4000
ATT:
        defb $38
MASK:
        defb 0
