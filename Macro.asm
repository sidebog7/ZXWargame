;-------------------------------------------------------------------
;Usage: ADD_A_TO_HL           Response: HL=HL+A
  MACRO	ADD_A_TO_HL
        add a,l
        ld l,a
        jr nc, $+3
        inc h
	ENDM
