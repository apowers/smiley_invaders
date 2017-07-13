;       int.asm      atom powers     5.5.98 5.6.98
;       executes any interrupt from the command line

	ORG     0100H

	JMP     MAIN

	DW      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
STAK:   DW      0

TKINT:  DW      03
TKAX:   DW      0
TKBX:   DW      0
TKCX:   DW      0
TKDX:   DW      0
TKBP:   DW      0
TKSI:   DW      0
TKDI:   DW      0
TKES:   DW      0
TKDS:   DW      0
;TKFLG:  DW      0

DSPREG: DB      0AH,0DH,'Using INT '
RGINT:  DW      0,0
	DB      0AH,0DH
	DB      'The registers returned were',0AH,0DH
	DB      ' AX='
REGAX:  DW      0,0
	DB      ' BX='
REGBX:  DW      0,0
	DB      ' CX='
REGCX:  DW      0,0
	DB      ' DX='
REGDX:  DW      0,0
	DB      ' BP='
REGBP:  DW      0,0
	DB      ' SI='
REGSI:  DW      0,0
	DB      ' DI='
REGDI:  DW      0,0
	DB      ' ES='
REGES:  DW      0,0
	DB      ' DS='
REGDS:  DW      0,0
	DB      0AH,0DH,'Have a Happy Day ',01,'$'               

HLPTX:  DB      0AH,0DH,'Executes system interrupts from the command line',0AH,0DH
	DB      'INT [/i:interrupt] [/0] [/a:AX] [/b:BX] [/c:CX] [/d:DX]',0AH,0DH
	DB      '    [/b:BP] [/s:SI] [/x:DI] [/e:ES] [/t:DS]',0AH,0DH      
	DB      '    use INT without parameters to view registers',0AH,0DH 
	DB      '    use the /0 swith to clear the registers, must be first switch',0AH,0DH
	;DB      '    flags are overflow, 
	DB      '    all values are in hex, you must enter all four didgets',0AH,0DH
	DB      '    there is no checking for non-hex values, use at your own risk',0AH,0DH
	DB      0AH,0DH,'$'

MAIN:   MOV     [TKAX],AX
	MOV     [TKBX],BX
	MOV     [TKCX],CX
	MOV     [TKDX],DX
	MOV     [TKBP],BP
	MOV     [TKSI],SI
	MOV     [TKDI],DI
	MOV     [TKES],ES
	MOV     [TKDS],DS
	MOV     SI,80H
	MOV     SP,STAK
	
MAIN1:  INC     SI
	MOV     DL,[SI]           ;get command tail character
	CMP     DL,2FH
	JE      PARAM
	CMP     DL,0DH
	JNE     MAIN1
	JMP     EXEC

PARAM:  MOV     DI,TKAX
	INC     SI
	MOV     DL,[SI]
	CMP     DL,'?'
	JNE     PARM0
	JMP     HELP
PARM0:  CMP     DL,'0'
	JNE     PARAM0
	JMP     CLREG
PARAM0: CMP     DL,60H
	JG      PARAMA
	ADD     DL,32
PARAMA: ADD     SI,2
PAR0:   CMP     DL,'i'
	JNE     PAR1
	JMP     GETINT
PAR1:   CMP     DL,'a'
	JNE     PAR2
	MOV     DI,TKAX
	JMP     GETREG
PAR2:   CMP     DL,'b'
	JNE     PAR3
	MOV     DI,TKBX
	JMP     GETREG
PAR3:   CMP     DL,'c'
	JNE     PAR4
	MOV     DI,TKCX
	JMP     GETREG
PAR4:   CMP     DL,'d'
	JNE     PAR5
	MOV     DI,TKDX
	JMP     GETREG
PAR5:   CMP     DL,'b'
	JNE     PAR6
	MOV     DI,TKBP
	JMP     GETREG
PAR6:   CMP     DL,'s'
	JNE     PAR7
	MOV     DI,TKSI
	JMP     GETREG
PAR7:   CMP     DL,'x'
	JNE     PAR8
	MOV     DI,TKDI
	JMP     GETREG
PAR8:   CMP     DL,'e'
	JNE     PAR8
	MOV     DI,TKES
	JMP     GETREG
PAR9:   CMP     DL,'t'
	JNE     PAR10
	MOV     DI,TKDS
	JMP     GETREG
PAR10:  JMP     MAIN1
	
CLREG:        
	MOV     W[TKAX],0
	MOV     W[TKBX],0
	MOV     W[TKCX],0
	MOV     W[TKDX],0
	MOV     W[TKBP],0
	MOV     W[TKSI],0
	MOV     W[TKDI],0
	MOV     W[TKES],0
	MOV     W[TKDS],0
	JMP     MAIN1

GETINT: MOV     DX,[SI]
	CALL    ASCHEX          ;with asc in dx returns with hex in dl
	MOV     [TKINT],DL       
	INC     SI
	JMP     MAIN1

GETREG: MOV     DX,[SI]
	CALL    ASCHEX          ;with asc in dx returns with hex in dl
	MOV     [DI+1],DL       
	MOV     DX,[SI+2]
	CALL    ASCHEX
	MOV     [DI],DL
	ADD     SI,3
	JMP     MAIN1

EXEC:   MOV     AL,[TKINT]
	MOV     DI,DOINT
	MOV     [DI],AL         ;Set location of interrupt 
	MOV     AX,[TKAX]
	MOV     BX,[TKBX]
	MOV     CX,[TKCX]
	MOV     DX,[TKDX]
	MOV     BP,[TKBP]
	MOV     SI,[TKSI]
	MOV     DI,[TKDI]
	MOV     ES,[TKES]
	MOV     DS,[TKDS]
	DB      0CDH            ;int
DOINT:  DB      0               ;interrupt number

XREG:   PUSH    DS
	PUSH    DI
	PUSH    AX              
	MOV     DS,CS           ;restore data segment for me
	MOV     DI,REGDX        ;do the dx register
	CALL    DOREG
	POP     DX              ;pop ax into dx
	MOV     DI,REGAX       
	CALL    DOREG
	POP     DX              ;pop di into dx
	MOV     DI,REGDI
	CALL    DOREG
	POP     DX              ;pop di into dx
	MOV     DI,REGDS
	CALL    DOREG
	MOV     DX,BX
	MOV     DI,REGBX       
	CALL    DOREG
	MOV     DX,CX
	MOV     DI,REGCX       
	CALL    DOREG
	MOV     DX,BP
	MOV     DI,REGBP
	CALL    DOREG
	MOV     DX,SI
	MOV     DI,REGSI
	CALL    DOREG
	MOV     DX,ES
	MOV     DI,REGES
	CALL    DOREG
	MOV     DX,[TKINT]
	MOV     DI,RGINT
	CALL    DOREG

	MOV     AH,09
	MOV     DX,DSPREG
	INT     21h
	JMP     0

HELP:   MOV     DX,HLPTX        ;display help text
	MOV     AH,9
	INT     21H
	JMP     0               ;quit

DOREG:  PUSH    DX
	CALL    HEXASC
	MOV     [DI+2],DX
	POP     DX
	MOV     DL,DH
	CALL    HEXASC
	MOV     [DI],DX
	RET

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

HEXASC: MOV     AL,DL
	AND     AL,0F0H
	ROR     AL,4
	CALL    LETCON
	MOV     DH,AL
	MOV     AL,DL
	AND     AL,0FH
	CALL    LETCON
	MOV     DL,AL
	XCHG    DH,DL
	RET
LETCON: CMP     AL,0AH
	JL      LETCN1
	ADD     AL,7
LETCN1: ADD     AL,30H
	RET

