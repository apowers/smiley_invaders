;       subs.asm        atom powers     
;       common subroutines

BS      EQU     08H             ;backspace
CR      EQU     0DH             ;carrage return
LF      EQU     0AH             ;line feed
VIDSEG  EQU     0B800H          ;video segment address
BLANK   EQU     0720H           ;white space
SPACE   EQU     20H
STOP    EQU     '$'             ;stop chr for conout
UP      EQU     48H             ;key characters
DOWN    EQU     50H
LEFT    EQU     4BH
RIGHT   EQU     4DH
ESC     EQU     1BH

	ORG     0100H

	JMP     MAIN

	DW      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
STAK:   DW      0               ;stack
TANK:   DW      0               ;holding tanks
SEED:   DW      9248H           ;seed for randomization
TONE:   DW      0               ;tone, time, change, length, used with beep
TIME:   DW      01              ;       
CHANGE: DW      0               ;
LENGTH: DW      0FFFFH          ;

;---------------------------------

MAIN:   
	JMP     0

GETAIL: MOV     SI,80H          ;location of tail characters in psp
GETAIL1: 
	INC     SI              ;first character, next character
	MOV     DL,[SI]         ;get command tail character
	CMP     DL,'/'          ;first char of switch
	JE      PARAM           ;process switch
	CMP     DL,0DH          ;end of tail
	JNE     GETAL1
	RET                     ;return to main

PARAM:  INC     SI              ;character after '/'
	MOV     DL,[SI]         ;get character
	CMP     DL,'?'          ;character for help
	JNE     PARA            
	MOV     AH,09           ;print help text
	MOV     DX,HELPTX       ;
	INT     21H             ;
	JMP     0               ;end after help text
PARA:   CMP     DL,60H          ;look for uppercase
	JG      PAR0
	ADD     DL,32           ;convert to lowercase
PAR0:   CMP     DL,'s'          ;begin processing characters
	JNE     PAR1
	MOV     DI,TONE         ;place to store value
	JMP     GETVAL          ;get and store value
PAR1:   CMP     DL,'t'
	JNE     PARX
	MOV     DI,TIME
	JMP     GETVAL
PARX:   JMP     GETAIL1         ;return and continue processing tail
	
GETVAL: INC     SI              ;set for characters after switch
	MOV     DL,[SI]
	CMP     SI,':'          ;if ':' skip character
	JNE     GETVAL0
	INC     SI
GETVAL0: 
	MOV     DX,[SI]         ;get first characters
	CALL    ASCHEX          ;convert to hex
	MOV     [DI+1],DL       ;store as second byte
	MOV     DX,[SI+2]       ;get second characters
	CALL    ASCHEX          
	MOV     [DI],DL         ;store as first byte
	ADD     SI,3
	JMP     GETAIL1

;---------------------------------

CLEAR:  PUSH    DS
	MOV     AX,VIDSEG       ;setup video segment
	MOV     DS,AX
	MOV     DX,BLANK        ;character to displey
	MOV     DI,0            ;star at first screen character
CLR1:   MOV     [DI],DX         ;display character
	ADD     DI,2            ;next character location
	CMP     DI,0F9FH        ;chk for last chr location
	JLE     CLR1
	POP     DS              ;restore data segment
	RET

DSPCHR: PUSH    DS              ;displays character/color in dx into 
	MOV     AX,VIDSEG       ;       vidseg:di
	MOV     DS,AX
	MOV     [DI],DX
	POP     DS
	RET

CONOUT: MOV     AH,09           ;output a string begining in ds:dx
	INT     21H
	RET
	
CHROUT: PUSH    DX              ;output a character in al into prompt loc.
	MOV     DL,AL           ;setup for int
	MOV     AH,02
	INT     21H
	POP     DX
	RET

CHRIN:  MOV     AH,07           ;wait for keyboard character 
	INT     21H
	RET                     ;return w/ character in al

CONSTA: MOV     AH,6            ;get key in buffer
	MOV     DL,0FFH         ;set for input
	INT     21H
	RET                     ;return with character in al
	
RANDOM: PUSH    DX              ;put unpredictable number in ax
	PUSH    CX              ;retain registers used
	MOV     AH,2CH
	INT     21H             ;get time
	MOV     AX,DX           ;dh=seconds dl=hundreth seconds
	CS:
	ADD     AX,[SEED]       ;combine with seed
	CS:
	MOV     [SEED],AX       ;store new seed
	POP     CX              ;restore registers
	POP     DX
	RET

ASCHEX: MOV     AL,DL           ;with ascii in dx, return with hex in dl
	CALL    ASCHX1          ;do first letter
	ROL     AL,4          
	MOV     DL,AL
	MOV     AL,DH         
	CALL    ASCHX1          ;do second letter
	MOV     DH,AL
	ADD     DL,DH           ;combine into hex
	RET
ASCHX1: CMP     AL,60H          ;convert to lowercase
	JL      ASCHX0
	SUB     AL,20H
ASCHX0: CMP     AL,3AH          ;convert to hex
	JL      ASCHX1
	SUB     AL,7          
ASCHX1: SUB     AL,30H        
	RET

HEXASC: MOV     AL,DL           ;takes hex in dl and turns it into 
	ROR     AL,4            ;  ascii in dx
	CALL    HEXAS1          ;do first number
	MOV     DH,AL
	MOV     AL,DL           
	CALL    HEXAS1          ;do second letter
	MOV     DL,AL
	RET
HEXAS1: AND     AL,0FH
	CMP     AL,0AH          ;look for letter
	JL      HEXAS2
	ADD     AL,07           ;if letter add extra for letter
HEXAS2: ADD     AL,30H
	RET

BEEP:   PUSH    CX
	PUSH    DX
	MOV     CX,[LENGTH]
	MOV     DX,[TONE]
	IN      AL,61H          ;turn tone on 
	OR      AL,3
	OUT     61H,AL
BEEP1:  MOV     AL,DL           ;set up tone
	OUT     42H,AL
	MOV     AL,DH
	OUT     42H,AL
	DEC     CX              ;bump timer
	JNE     BEEP1
	ADD     DX,[CHANGE]     ;change tone
	MOV     CX,[TIME]       ;get time
	DEC     CX              ;bump time
	MOV     [TIME],CX       ;store time
	JE      BEEP2           ;if time is over, toneoff
	MOV     CX,[LENGTH]     ;reset length
	JMP     BEEP1           ;next tone
BEEP2:  IN      AL,61H          ;turn tone off
	AND     AL,0FCH
	OUT     61H,AL
	POP     DX              ;restore data registers
	POP     CX
	RET

	END
