;       disable.asm      atom powers     5.1.98 5.5.98
;       diables any sppecific interrupt on command line

	ORG     100H

MAIN:   MOV     SI,80H
MAIN1:  ADD     SI,2
	MOV     DX,[SI]         ;get command tail
	XCHG    DH,DL
	CALL    ASCHEX

	MOV     AH,35H          ;get interrupt handler
	MOV     AL,03           ;disabbling interupt
	INT     21H             ;return handler in ES:BX
 
	MOV     AL,DL
	MOV     DS,ES           ;set for rerouting
	MOV     DX,BX
	MOV     AH,25H          ;rerout interrupt handler
	INT     21H
 
	MOV     DL,01H          ;print smilely face
	MOV     AH,02
	INT     21H

	JMP     0

ASCHEX: MOV     AL,DH           ;CONVERT DH
	CALL    NUMCON
	ROL     AL,4            ;SHIFT TO HIGH BIT
	MOV     DH,AL
	MOV     AL,DL           ;CONVERT DL
	CALL    NUMCON
	MOV     DL,AL
	ADD     DL,DH           ;COMBINE
	RET
NUMCON: CMP     AL,3AH          ;CHECK FOR LETTER
	JL      NUMCN1
	SUB     AL,7            ;LETTER + NUMBER CONVERSION
NUMCN1: SUB     AL,30H          ;NUMBER CONVERSION
	RET


