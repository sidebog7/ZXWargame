        ; Sets the next draw position for the
        ; PRINTCHAR and PRINTUDG routines
        ; b is the row
        ; c is the column
        ; Destroys: a, hl, de
SETDRAWPOS:
        ld a,b
        and $18
        ld h,a
        set 6,h
        rrca
        rrca
        rrca
        or $58
        ld d,a
        ld a,b
        and 7
        rrca
        rrca
        rrca
        add a,c
        ld l,a
        ld e,a
        ld a,(de)
        ld (DFCC),hl
        ret


PRINTSTR:
        ld a,(hl)
PRINTSTR_LOOP:
        push hl
        call PRINTCHAR
        pop hl
        inc hl
        ld a,(hl)
        or a
        jr nz,PRINTSTR_LOOP
        ret

        ; Prints the specified character from the BASE font set
        ; a is the character
        ; Destroys: hl, de, bc, a
PRINTCHAR:
        ld l,a
        ld h,0
        add hl,hl
        add hl,hl
        add hl,hl
        ld de,(BASE)
        add hl,de
        jr PRINT1

PRINTUDG:
        ld l,a
        ld h,0
        add hl,hl
        add hl,hl
        add hl,hl
        ld de,(gfx)
        add hl,de

PRINT1:
        ld de,(DFCC)
        ld b,8
NXTROW:
        ld a,(hl)
        ld (de),a
        inc hl
        inc d
        djnz NXTROW

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
        ret nz
        inc hl
        ld a,(hl)
        add a,8
        ld (hl),a
        ret

BASE:
        defw $3c00
DFCC:
        defw $4000
ATT:
        defb $38
MASK:
        defb 0
