;       beep.asm      atom powers     5.5.98 5.6.98
;       displays custom sounds from the pc speaker

	ORG     0100H

	JMP     MAIN

TONE:   DW      0100h
TIME:   DW      01
CHANGE: DW      0
LENGTH: DW      0FFFFH
DELTA:  DW      0

HELPTX: DB      'BEEP [/t:initial tone] [/c:tone change] [/l:tone length] ',0AH,0DH
	DB      '     [/d:change in length] [/n:number of tones]',0AH,0DH,'$'

MAIN:   MOV     SI,80H
MAIN1:  INC     SI
	MOV     DL,[SI]    ;get command tail character
	CMP     DL,2FH
	JE      PARAM
	CMP     DL,0DH
	JNE     MAIN1
	JMP     EXEC

PARAM:  INC     SI
	MOV     DL,[SI]
	CMP     DL,'?'
	JNE     PARAMA
	MOV     AH,09
	MOV     DX,HELPTX
	INT     21H
	JMP     0
PARAMA: CMP     DL,60H
	JG      PAR0
	ADD     DL,32
PAR0:   ADD     SI,2
	CMP     DL,'t'
	JNE     PAR1
	MOV     DI,TONE
	JMP     GETVAL
PAR1:   CMP     DL,'n'
	JNE     PAR2
	MOV     DI,TIME
	JMP     GETVAL
PAR2:   CMP     DL,'c'
	JNE     PAR3
	MOV     DI,CHANGE
	JMP     GETVAL
PAR3:   CMP     DL,'l'
	JNE     PAR4
	MOV     DI,LENGTH
	JMP     GETVAL
PAR4:   CMP     DL,'d'
	JNE     PAR5
	MOV     DI,DELTA
	JMP     GETVAL
PAR5:   JMP     MAIN1
	
GETVAL: MOV     DX,[SI]
	CALL    ASCHEX    ;with asc in dx returns with hex in dl
	MOV     [DI+1],DL
	MOV     DX,[SI+2]
	CALL    ASCHEX
	MOV     [DI],DL
	ADD     SI,3
	JMP     MAIN1

ASCHEX: MOV     AL,DL
	CALL    NUMCON
	ROL     AL,4
	MOV     DL,AL
	MOV     AL,DH
	CALL    NUMCON
	MOV     DH,AL
	ADD     DL,DH
	RET
NUMCON: CMP     AL,60H
	JL      NUMCN0
	SUB     AL,20H
NUMCN0: CMP     AL,3AH
	JL      NUMCN1
	SUB     AL,7
NUMCN1: SUB     AL,30H
	RET		

EXEC:   MOV     BX,[CHANGE]
	MOV     CX,[TIME]
	MOV     DX,[TONE]
	IN      AL,61H	    ;turn on speaker
	OR      AL,3
	OUT     61H,AL
EXEC1:  MOV     AL,DL	      ;set tone for speaker
	OUT     42H,AL
	MOV     AL,DH
	OUT     42H,AL
	DEC     CX
	JNE     EXEC1
	ADD     DX,BX
	MOV     CX,[TIME]
	DEC     CX
	MOV     [TIME],CX
	JE      EXEC2
	MOV     CX,[LENGTH]
	SUB     CX,[DELTA]
	MOV     [LENGTH],CX
	JMP     EXEC1
EXEC2:  IN      AL,61H	    ;turn speaker off
	AND     AL,0FCH
	OUT     61H,AL
	JMP     0
