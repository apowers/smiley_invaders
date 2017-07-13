;       sminv.asm     atom powers     4.28.98 5.21.98
;       smiley invaders arcade game

BLKDLY  EQU     0AFH            ;*shtdly = block delay
SHTDLY  EQU     0FH            ;shot delay
ESTAR   EQU     0C2AH           ;bright red asterix
ESTAR1  EQU     8C2AH
ESHOT   EQU     0B0FH           ;enemy's shot
GSHOT   EQU     0A01H           ;gun's shot
BS      EQU     08H             ;backspace
CR      EQU     0DH             ;carrage return
LF      EQU     0AH             ;line feed
VIDSEG  EQU     0B800H          ;video segment address
BLANK   EQU     0720H           ;white space
SPACE   EQU     20H
LSTCHR  EQU     0F9FH           ;offset for last screen address
STOP    EQU     '$'             ;stop chr for conout
UP      EQU     48H             ;key characters
DOWN    EQU     50H
LEFT    EQU     4BH
RIGHT   EQU     4DH
ESC     EQU     1BH

	ORG	1200H		;tanks are in video segment

TANK:   DW      0               ;holding tanks
SEED:   DW      9248H
TONE:   DW      0100H           ;tone,time,change,length for beep
TIME:   DW      01
CHANGE: DW      0
LENGTH: DW      0FFFFH
SCORE:  DW      0
GPOSIT: DW      050H
BPOSIT: DW      020H
BDIR:   DB      02

	ORG     0100H

	JMP     MAIN

	DW      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
STAK:   DW      0
ENEMY:  DW      04D4H,0402H,04BEH
BOMB:   DW      0BAEH,0B02H,0BAFH
GUN:    DW      0720H,02D2H,0720H
	DW      0720H,02C9H,02CEH,02BBH,0720H
BLOCK:  DW      0720H,05B2H,05B2H,05B2H,0720H
	DW      0720H,05B2H,05B2H,05B2H,05B2H,05B2H,0720H
GKILL:  DW      0720H,0720H,0A2AH,0A2AH,0A2AH,0720H,0720H
	DW      0720H,0A2AH,0A2AH,0AB0H,0A2AH,0A2AH,0720H
	DW      0A2AH,0A2AH,0AB0H,0AB0H,0AB0H,0A2AH,0A2AH
OVRMSG: DW      0720H,84C9H,84CDH,84CDH,0720H,84C9H,84BBH,8720H
	DW      84C9H,84BBH,84C9H,84BBH,0720H,84C9H,84CDH,0720H
	DW      0720H,84C9H,84BBH,0720H,84BAH,84BAH,0720H
	DW      84C9H,84CDH,0720H,84C9H,84BBH,0720H,0720H
;SECOND ROW
	DW      0720H,84BAH,0720H,84BBH,0720H,84CCH,84B9H,0720H
	DW      84BAH,84C8H,84BCH,84BAH,0720H,84CCH,84CDH,0720H
	DW      0720H,84BAH,84BAH,0720H,84BAH,84BAH,0720H
	DW      84CCH,84CDH,0720H,84CCH,84CAH,84BBH,0720H
;THIRD ROW
	DW      0720H,84C8H,84CDH,84BCH,0720H,84BAH,84BAH,0720H
	DW      84BAH,0720H,0720H,84BAH,0720H,84C8H,84CDH,0720H
	DW      0720H,84C8H,84BCH,0720H,84C8H,84BCH,0720H
	DW      84C8H,84CDH,0720H,84BAH,0720H,84BAH,0720H

MENUTX: DB      CR,LF
	DB      0C9H,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH
	DB      0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH
	DB      0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH
	DB      0CDH,0CDH,0BBH,CR,LF
	DB      0BAH,'AN ATOMIC RED PRODUCTION    V 5.98   ',0BAH,CR,LF
	DB      0C7H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H
	DB      0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H
	DB      0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H,0C4H
	DB      0C4H,0C4H,0B6H,CR,LF
	DB      0BAH,'[ESC]:        QUIT                   ',0BAH,CR,LF
	DB      0BAH,'[ARROW KEYS]: MOVE LEFT / RIGHT      ',0BAH,CR,LF
	DB      0BAH,'[SPACE]:      FIRE                   ',0BAH,CR,LF
	DB      0C8H,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH
	DB      0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH
	DB      0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH,0CDH
	DB      0CDH,0CDH,0BCH,CR,LF
	DB      'PRESS ANY KEY TO PLAY:',STOP

SCRTX:  DB      'SCORE: 0000$'

;---------------------------------

MAIN:   MOV	AX,VIDSEG
	MOV	DS,AX
	MOV	W[TANK],0               ;holding tanks
	MOV	W[SEED],9248H
	MOV	W[TONE],0100H           ;tone,time,change,length for beep
	MOV	W[TIME],01
	MOV	W[CHANGE],0
	MOV	W[LENGTH],0FFFFH
	MOV	W[SCORE],0
	MOV	W[GPOSIT],050H
	MOV	W[BPOSIT],020H
	MOV	B[BDIR],02
	MOV     W[SCORE],0
	CALL    CLEAR        		;clear screen
	PUSH	DS
	MOV	DS,CS
	MOV     DX,MENUTX       	;display menu
	CALL    CONOUT          
	POP	DS
	CALL    CHRIN
	CMP     AL,1BH
	JNE     SMINV
	JMP     0

SMINV:  CALL    CLEAR
	MOV     BX,1            ;screen page
	MOV     DX,0            ;cursor position
	MOV     AH,2            ;int function
	INT     10H
	PUSH	DS
	MOV	DS,CS
	MOV     DX,SCRTX
	CALL    CONOUT
	POP	DS
	MOV     W[TONE],500H
	MOV     W[TIME],4H
	MOV     W[CHANGE],0FEFFH
	MOV     W[LENGTH],0FFFFH
	CALL    BEEP
	CALL    GMOVE           ;create gun
SMILE0: MOV     CH,BLKDLY
SMILE1: MOV     CL,SHTDLY
SMILE2: CALL    CONSTA          ;look for key
	CALL    DOKEY           ;process key stroke
	DEC     CL
	JNE     SMILE2
	CALL    SHTMOV
	DEC     CH
	JNE     SMILE1
	CALL    BMOVE
	CALL    ALMOVE
	CALL    CREATE
	CALL    SCORIT
	JMP     SMILE0

DOKEY:  CMP     AL,0
	JNE     DOKY0
	CALL    CONSTA
DOKY0:  CMP     AL,ESC
	JNE     DOKY1
	JMP     MAIN
DOKY1:  CMP     AL,SPACE
	JNE     DOKY2
	JMP     GSHOOT
DOKY2:  CMP     AL,LEFT
	JNE     DOKY3
DOKY2A: SUB     W[GPOSIT],2
	JLE     DOKY3A
	JMP     GMOVE
DOKY3:  CMP     AL,RIGHT
	JNE     DOKY4
DOKY3A: ADD     W[GPOSIT],2
	CMP     W[GPOSIT],9AH
	JGE     DOKY2A
	JMP     GMOVE
DOKY4:  RET

GMOVE:  PUSH    CX
	MOV     DI,0E60H        ;first row for gun
	MOV     SI,GUN
	MOV     CX,203H         ;row, column counter
	ADD     DI,[GPOSIT]
GMOVE1: CALL    DRAWIT
	ADD     DI,098H         ;next line of gun
	MOV     CL,5            ;reset column counter for second row
	DEC     CH
	JNE     GMOVE1
	POP     CX
	RET

GSHOOT: MOV     W[TONE],100H
	MOV     W[TIME],10H
	MOV     W[CHANGE],0A0H
	MOV     W[LENGTH],01FFFH
	CALL    BEEP
	MOV     DI,0DC0H
	ADD     DI,[GPOSIT]
	ADD     DI,2
	MOV     DX,GSHOT        ;character for shot
	MOV     [DI],DX
	RET

SHTMOV: MOV     SI,0A0H
	MOV     DI,SI
	SUB     DI,0A0H
SHMOVA: MOV     DX,[SI]
	CMP     DX,GSHOT
	JNE     SHMOVX
	MOV     [SI],BLANK
	MOV     DX,[DI]
	CMP     DH,05           ;check for block
	JE      SHMOVX
	CMP     DH,04           ;look for enemy by color
	JNE     SHMOV1
	CALL    EXPLOD
	MOV	AX,4		;setup for tens diget
	CALL	SCORIT
	JMP     SHMOVX
SHMOV1: CMP     DX,ESHOT        ;look for enemy's shot
	JNE     SHMOV2
	MOV     [DI],ESTAR
	JMP     SHMOVX
SHMOV2: CMP     DH,0BH          ;look for bomb
	JNE     SHMOVW
	CALL    EXPLOD
	MOV	AX,6		;setup for ones diget
	CALL	SCORIT
	JMP     SHMOVX
SHMOVW: CMP     DI,0A0H
	JL      SHMOVX
	MOV     [DI],GSHOT      ;move shot up a place
SHMOVX: ADD     SI,2
	ADD     DI,2
	CMP     SI,0FA0H
	JL      SHMOVA
SHMOVY: RET

EXPLOD: MOV     W[LENGTH],5FFFH
	MOV     W[TONE],500H
	MOV     W[TIME],4H
	MOV     W[CHANGE],0100H
	CALL    BEEP
	SUB     DI,2
	MOV     DX,[DI]
	CMP     DL,02
	JE      EXPLD1
	ADD     DI,4
	MOV     DX,[DI]
	CMP     DL,02
	JE      EXPLD1
	SUB     DI,2
EXPLD1: MOV     [DI],ESHOT
	MOV     [DI-2],ESTAR
	MOV     [DI+2],ESTAR
	MOV     [SI],BLANK
	RET

BMOVE:  MOV     AX,[BPOSIT]     ;adjust position and directions
BMOVEA: ADD     AL,[BDIR]
	CMP     AX,02           ;far left position
	JG      BMOVEB
	MOV     B[BDIR],02      ;move right
	JMP     BMOVEA
BMOVEB: CMP     AX,064H         ;far right for left block
	JL      BMOVEC
	MOV     B[BDIR],0FEH    ;move left
	JMP     BMOVEA
BMOVEC: MOV     [BPOSIT],AX
	CALL    BLMOVE
	MOV     AX,[BPOSIT]
	ADD     AX,30H  
	CALL    BLMOVE
	RET

BLMOVE: MOV     DI,0C80H        ;first row for block
	MOV     SI,BLOCK
	MOV     CX,205H         ;row, column counter
	ADD     DI,AX
BMOVE1: CALL    DRAWIT
	ADD     DI,094H         ;next line of gun
	MOV     CL,7            ;reset column counter
	DEC     CH
	JNE     BMOVE1
	RET

ALMOVE: MOV     SI,0F9EH
	MOV     DI,SI
	ADD     DI,0A0H
ALMOV:  MOV     CL,2
	MOV     DX,[SI]
	CMP     DX,ESTAR
	JNE     AMOVE0
	MOV     [SI],ESTAR1
	JMP     AMOVEX
AMOVE0: CMP     DX,ESTAR1
	JNE     AMOVE1
	MOV     [SI],BLANK
	JMP     AMOVEX
AMOVE1: CMP     DX,ESHOT        ;look for enemy shot
	JNE     AMOVE2
	CALL    ESHT
	JMP     AMOVEX
AMOVE2: CMP     DX,0B02H        ;look for bomb by middle character
	JNE     AMOVE3
	CALL    BOMOV
	JMP     AMOVEX
AMOVE3: CMP     DX,0402H        ;look for enemy by middle character
	JNE     AMOVEX
	CALL    EMOVE
AMOVEX: SUB     DI,2
	SUB     SI,2
	JLE     AMOVEZ
	JMP     ALMOV
AMOVEZ: RET

ESHT:   MOV     DX,[DI]
	CMP     DH,04           ;check for enemy
	JNE     ESHT1
	CALL    EXPLOD
	RET
ESHT1:  CMP     DH,05           ;check for block
	JNE     ESHT2
	MOV     [SI],BLANK
	JMP     AMOVEX
ESHT2:  CMP     DH,02H          ;check for gun
	JNE     ESHT3
	JMP     GOVER
ESHT3:  MOV     [DI],ESHOT      ;move shot down
	MOV     [SI],BLANK
	RET

BOMOV:  ADD     DI,2
BOMVA:  MOV     DX,[DI]
	CMP     DH,04           ;look for enemy
	JNE     BOMOV1
	CALL    EXPLOD
BOMOV0: MOV     DI,SI
	CALL    EXPLOD
	ADD     DI,0A0H
	JMP     AMOVEX
BOMOV1: CMP     DH,05           ;look for block
	JE      BOMOV0
BOMOV2: CMP     DH,02           ;look for gun
	JNE     BOMOV3
	JMP     GOVER
BOMOV3: SUB     DI,2            ;check all three characters    
	DEC     CL
	JNE     BOMVA
	MOV     BX,BOMB         ;move bomb down
	SUB     SI,2            ;set position for redraw
	CALL    MOVEIT
	RET

EMOVE:  ADD     DI,2
EMOVE0: MOV     DX,[DI]
	CMP     DH,05H          ;check for block
	JNE     EMOVEA
	CALL    EXPLOD
	RET
EMOVEA: CMP     DH,02           ;check for gun
	JNE     EMOVEB
	JMP     GOVER
EMOVEB: SUB     DI,2
	DEC     CL
	JNE     EMOVE0
	CMP     SI,140H         ;check for top line
	JL      EMOVEC
	CALL    RANDIR
	ADD     DI,BX
EMOVEC: MOV     BX,ENEMY
	SUB     SI,2
	CALL    MOVEIT
	MOV     DI,SI
	ADD     DI,0A0H
	RET

RANDIR: CALL    RANDOM
	CMP     AL,30H
	JG      RNDIR1
	MOV     BX,-6
	RET
RNDIR1: CMP     AL,60H
	JG      RNDIR2
	MOV     BX,6
	RET
RNDIR2: MOV     BX,0
	RET

MOVEIT: MOV     CL,3
MOVIT0: CS:
	MOV     DX,[BX]
	MOV     [DI],DX
	MOV     [SI],BLANK
	ADD     BX,2
	ADD     DI,2
	ADD     SI,2
	DEC     CL
	JNE     MOVIT0
	RET

CREATE: PUSH    CX
	MOV     DI,0A0H
CREAT0: CALL    RANDOM
	CMP     AL,2
	JLE     CREAT0
CREAT1: MOV     [DI],BLANK
	ADD     DI,2
	SUB     AL,1
	JGE     CREAT1  
CREAT2: CMP     AH,0H
	JG      CREAT4
	MOV     SI,BOMB
	MOV     CL,3
	CALL    DRAWIT
	JMP     CREATX
CREAT4: MOV     SI,ENEMY
	MOV     CL,3
	CALL    DRAWIT
CREATX: MOV     [DI],BLANK
	ADD     DI,2
	CMP     DI,0A0H
	JL      CREATX
CREATZ: POP     CX
	RET

SCORIT: MOV	DI,0DH			;first character of score
	ADD	DI,AX	
SCORT0:	MOV	DX,[DI]			;get last charcater
	INC	DH
	CMP	DH,3AH
	JGE	SCORT1			;if not ascii number adjust
	MOV	[DI],DX
	RET
SCORT1:	MOV	DH,30H			;replace with a '0'
	MOV	[DI],DX
	SUB	DI,2
	JMP	SCORT0			;do next higher place diget

GOVER:	MOV     W[LENGTH],5FFFH
	MOV     W[TONE],1100H
	MOV     W[TIME],10H
	MOV     W[CHANGE],0100H
	CALL    BEEP
	MOV     DI,[GPOSIT]
	ADD     DI,0DBCH
	MOV     SI,GKILL
	MOV     CX,0307H
GOVERA: CALL    DRAWIT
	MOV     CL,07
	ADD     DI,0A0H-14
	DEC     CH
	JNE     GOVERA
GOVER1: MOV     DI,5A0H+32
	MOV     SI,OVRMSG
	MOV     CX,031EH
GOVERB: CALL    DRAWIT
	MOV     CL,1EH
	ADD     DI,0A0H-60
	DEC     CH
	JNE     GOVERB
GOVERC: CALL    CHRIN
	JMP     MAIN

;----------------------

CLEAR:	MOV     DX,BLANK        ;character to displey
	MOV     DI,0            ;star at first screen character
CLR1:   MOV     [DI],DX         ;display character
	ADD     DI,2            ;next character location
	CMP     DI,0F9FH        ;chk for last chr location
	JLE     CLR1
	RET

DRAWIT: CS:
	MOV     DX,[SI]         ;get character to display
	MOV     [DI],DX
	ADD     SI,2            ;bump locations
	ADD     DI,2
	DEC     CL              ;done?
	JNE     DRAWIT
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
	ADD     AX,[SEED]       ;combine with seed
	MOV     [SEED],AX       ;store new seed
	POP     CX              ;restore registers
	POP     DX
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
