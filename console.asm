;	console.asm	atom powers	3.2.98/3.20.98
;	fun video routines and misc stuff

;	3.3.98	add happy rain
;	3.4.98	add arrow key controll
;	3.5.98	finish basic routines and start draw
;	3.5.98	add menus
;	3.6.98	change draw for better chr controll
;	3.6.98	add randamization to rain
;	3.6.98	begin space invaders
;	3.9.98	debuging, build blocks of smile invaders
;	3.10.98	build, debug create, almove for smile invaders
;	3.11.98 continue work on almove, game over menu
;	3.20.98 change raondom to use date/time
;	3.20.98 move graphics down a line in smile invaders
;	3.30.98 change constatus for bios calls

PMTDLY	EQU	03FFH		;prompt delay
RANDLY	EQU	03FFH		;rain delay
BLKDLY	EQU	03FH		;*shtdly = block delay
SHTDLY	EQU	02FH		;shot delay
ESTAR	EQU	0C2AH		;bright red asterix
ESTAR1	EQU	8C2AH
ESHOT	EQU	0B0FH		;enemy's shot
GSHOT	EQU	0A01H		;gun's shot
BS	EQU	08H		;backspace
CR	EQU	0DH		;carrage return
LF	EQU	0AH		;line feed
CHAR	EQU	02		;rain chr, smiley face
VIDSEG	EQU	0B800H		;video segment address
CTANK	EQU	1000H		;character tank in video segment
BLANK	EQU	0720H		;white space
SPACE	EQU	20H
FORE	EQU	03		;black back, cyan chr
LSTCHR	EQU	0F9FH		;offset for last screen address
FREQ	EQU	19		;frequency of rain chr
STAGR	EQU	9		;stagger of rain chr
STOP	EQU	'$'		;stop chr for conout
UP	EQU	48H		;key characters
DOWN	EQU	50H
LEFT	EQU	4BH
RIGHT	EQU	4DH
PGUP	EQU	49H
PGDOWN	EQU	51H
ESC	EQU	1BH
KEND	EQU	4FH
DELT	EQU	53H
F1	EQU	3BH		;function characters
F8	EQU	42H
F9	EQU	43H
F10	EQU	44H
F11	EQU	85H
F12	EQU	86H
SF1	EQU	54H
SF8	EQU	5BH
L	EQU	0C9H		;border characters
TT	EQU	0CDH
BD	EQU	0D1H
R	EQU	0BBH
S	EQU	0BAH
M	EQU	0B3H
U	EQU	0CFH
QQ	EQU	0BCH
K	EQU	0C8H
Y	EQU	0C7H
BB	EQU	0C4H
Z	EQU	0B6H
C	EQU	0C1H

	ORG	0100H

	JMP	MAIN

	DW	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	DW	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
STAK:	DW	0
TANK:	DW	0		;holding tanks
TANK2:	DW	0
TANK3:	DW	0
SEED:	DW	9248H
SCORE:	DW	0
GPOSIT:	DW	050H
BPOSIT:	DW	020H
BDIR:	DB	02
ENEMY:	DW	04D4H,0402H,04BEH
BOMB:	DW	0BAEH,0B02H,0BAFH
GUN:	DW	0720H,02D2H,0720H
	DW	0720H,02C9H,02CEH,02BBH,0720H
BLOCK:	DW	0720H,05B2H,05B2H,05B2H,0720H
	DW	0720H,05B2H,05B2H,05B2H,05B2H,05B2H,0720H
GKILL:	DW	0720H,0720H,0A2AH,0A2AH,0A2AH,0720H,0720H
	DW	0720H,0A2AH,0A2AH,0AB0H,0A2AH,0A2AH,0720H
	DW	0A2AH,0A2AH,0AB0H,0AB0H,0AB0H,0A2AH,0A2AH
OVRMSG:	DW	0720H,84C9H,84CDH,84CDH,0720H,84C9H,84BBH,8720H
	DW	84C9H,84BBH,84C9H,84BBH,0720H,84C9H,84CDH,0720H
	DW	0720H,84C9H,84BBH,0720H,84BAH,84BAH,0720H
	DW	84C9H,84CDH,0720H,84C9H,84BBH,0720H,0720H
;SECOND ROW
	DW	0720H,84BAH,0720H,84BBH,0720H,84CCH,84B9H,0720H
	DW	84BAH,84C8H,84BCH,84BAH,0720H,84CCH,84CDH,0720H
	DW	0720H,84BAH,84BAH,0720H,84BAH,84BAH,0720H
	DW	84CCH,84CDH,0720H,84CCH,84CAH,84BBH,0720H
;THIRD ROW
	DW	0720H,84C8H,84CDH,84BCH,0720H,84BAH,84BAH,0720H
	DW	84BAH,0720H,0720H,84BAH,0720H,84C8H,84CDH,0720H
	DW	0720H,84C8H,84BCH,0720H,84C8H,84BCH,0720H
	DW	84C8H,84CDH,0720H,84BAH,0720H,84BAH,0720H

MENUTX:	DB	CR,LF
	DB	L,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT
	DB	TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,R
	DB	CR,LF
	DB	S,'AN ATOMIC RED PRODUCTION    V 3.98      ',S,CR,LF
	DB	Y,BB,BB,BB,BB,BB,BB,BB,0C2H,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB
	DB	BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,Z
	DB	CR,LF
	DB	S,'[1]    ',M,'HAPPY RAIN                      ',S,CR,LF
	DB	S,'[2]    ',M,'DRAW                            ',S,CR,LF
	DB	S,'[3]    ',M,'SMILE INVADERS                  ',S,CR,LF
;	DB	S,'[4]    ',M,'BLACK JACK                      ',S,CR,LF
;	DB	S,'[5]    ',M,'                                ',S,CR,LF	
;	DB	S,'[6]    ',M,'                                ',S,CR,LF
;	DB	S,'[7]    ',M,'                                ',S,CR,LF
	DB	S,'[ESC]  ',M,'QUIT                            ',S,CR,LF
	DB	S,'[SPACE]',M,'MENU                            ',S,CR,LF
	DB	K,TT,TT,TT,TT,TT,TT,TT,U,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT
	DB	TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,QQ
	DB	CR,LF,STOP

RAINMN:	DB	CR,LF
	DB	L,TT,TT,TT,TT,TT,TT,TT,BD,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT
	DB	TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,R,CR,LF
	DB	S,'UP:    ',M,'CHANGE CHARACTER COLOR  ',S,CR,LF
	DB	S,'DOWN:  ',M,'CHANGE BACKGROUND COLOR ',S,CR,LF
	DB	S,'LEFT:  ',M,'DECREMENT CHARACTER     ',S,CR,LF
	DB	S,'RIGHT: ',M,'INCREMENT CHARACTER     ',S,CR,LF
	DB	S,'END:   ',M,'RESET                   ',S,CR,LF
	DB	S,'ESC:   ',M,'QUIT TO MENU            ',S,CR,LF
	DB	K,TT,TT,TT,TT,TT,TT,TT,U,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT
	DB	TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,QQ,CR,LF
	DB	'PRESS ANY KEY TO CONTINUE:',CR,LF,STOP

DRAWMN:	DB	CR,LF
	DB	L,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,BD,TT,TT,TT
	DB	TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,R,CR,LF
	DB	S,'F1:  BLACK      ',M,'F5:  RED          ',S,CR,LF
	DB	S,'F2:  BLUE       ',M,'F6:  MAGENTA      ',S,CR,LF
	DB	S,'F3:  GREEN      ',M,'F7:  BROWN        ',S,CR,LF
	DB	S,'F4:  CYAN       ',M,'F8:  WHITE        ',S,CR,LF
	DB	S,'F9:  PREV CHAR  ',M,'F12: (FLASH)      ',S,CR,LF
	DB	S,'F10: NEXT CHAR  ',M,'F11: (BRIGHT)     ',S,CR,LF
	DB	Y,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,C,BB,BB,BB
	DB	BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,Z,CR,LF
	DB	S,'SHIFT+FUNCTION: BACKGROUND         ',S,CR,LF
	DB	S,'ARROW KEYS:     MOVE CURSOR        ',S,CR,LF
	DB	S,'ESC:            QUITS BACK TO MENU ',S,CR,LF
	DB	S,'DELETE:         DRAW EMPTY SPACES  ',S,CR,LF
	DB	S,'SPACE:          TOGGLE DRAW / MOVE ',S,CR,LF
	DB	S,'ANY OTHER KEY:  ASCII CHARACTER    ',S,CR,LF
	DB	S,'                (CHR + 7Fh)        ',S,CR,LF
	DB	K,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT
	DB	TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,QQ,CR,LF
	DB	'PRESS ANY KEY TO CONTINUE:',CR,LF,STOP

SPACMN:	DB	L,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT
	DB	TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,R,CR,LF
	DB	S,'ARROW KEYS: MOVE LEFT / RIGHT ',S,CR,LF
	DB	S,'SPACE:      FIRE              ',S,CR,LF
	DB	K,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT
	DB	TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,QQ,CR,LF
	DB	'PRESS ANY KEY TO CONTINUE:',CR,LF,STOP

SCRMN:	DB	'S',07,'C',07,'O',07,'R',07,'E',07,':',07,' ',07
	DB	'0',07,'0',07,'0',07,'0',07,'0',07

;---------------------------------

MAIN:	MOV	DS,CS		;set data segment
	MOV	SP,STAK		;set stack
	MOV	W[TANK],0	;clear tanks
	MOV	W[TANK2],0
	MOV	W[TANK3],0
	CALL	CLEAR		;clear screen
	MOV	DX,MENUTX	;display menu
	CALL	CONOUT		
	CALL	PROMPT		;menu prompt and routing routines
	JMP	MAIN

CLEAR:	PUSH	DS
	MOV	AX,VIDSEG	;setup video segment
	MOV	DS,AX
	MOV	DX,BLANK	;character to displey
	MOV	DI,0		;star at first screen character
CLR1:	MOV	[DI],DX		;display character
	ADD	DI,2		;next character location
	CMP	DI,0F9FH	;chk for last chr location
	JLE	CLR1
	POP	DS		;restore data segment to current seg.
	RET

PROMPT:	MOV	AL,'\'		
	CALL	CHROUT		;show prompt character
	CALL	DELAY		;wait
	CALL	KILCHR		;prepare for next character
	MOV	AL,'-'
	CALL	CHROUT
	CALL	DELAY
	CALL	KILCHR
	MOV	AL,'/'
	CALL	CHROUT
	CALL	DELAY
	CALL	KILCHR
	MOV	AL,'|'
	CALL	CHROUT
	CALL	DELAY
	CALL	KILCHR
	JMP	PROMPT

KILCHR:	MOV	AL,BS		;print a backspace
	CALL	CHROUT
	RET

DELAY:	MOV	CX,PMTDLY
DELAY1:	NOP			;place holder
	CALL	CONSTA		;look for input
	CALL	ROUT		;rout input
	CALL	KILCHR		;kill char displayed
	DEC	CX
	JNE	DELAY1		;loop
	RET

ROUT:	CMP	AL,1BH		;esc chr quits
	JNE	ROUTAA
QUIT:	CALL	CLEAR
	JMP	0
ROUTAA:	CMP	AL,SPACE	;space chr displays menu
	JNE	ROUTA
	CALL	CLEAR
	JMP	MAIN
ROUTA:	CMP	AL,31H		;'1'
	JNE	ROUTB
	CALL	CLEAR
	JMP	RAINST
ROUTB:	CMP	AL,32H		;'2'
	JNE	ROUTC
	CALL	CLEAR
	JMP	DRAW
ROUTC:	CMP	AL,33H		;'3'
	JNE	ROUTx
	CALL	CLEAR
	JMP	SMILEINV
ROUTD:	CMP	AL,34H		;'4'
	JNE	ROUTE
	CALL	CLEAR
	JMP	MAIN
ROUTE:	CMP	AL,35H		;'5'
	JNE	ROUTF
	CALL	CLEAR
	JMP	MAIN
ROUTF:	CMP	AL,36H		;'6'
	JNE	ROUTG
	CALL	CLEAR
	JMP	MAIN
ROUTG:	CMP	AL,37H		;'7'
	JNE	ROUTX
	JMP	MAIN
ROUTX:	RET

;--------------------------

RAINST:	MOV	DX,RAINMN
	CALL	CONOUT
	CALL	CHRIN
HRAIN:	MOV	B[TANK],CHAR	;set first character
	MOV	B[TANK+1],FORE	;set first color
RAIN0:	CALL	RANDOM		;get random stagger and frequency
	MOV	[TANK2],AX
RAIN0A:	SUB	B[TANK2],5
	CMP	B[TANK2],3	;min stag
	JL	RAIN0
	CMP	B[TANK2],13	;max stag
	JG	RAIN0A
RAIN0B:	SUB	B[TANK2+1],14	;reduce frequency
	CMP	B[TANK2+1],5	;min freq
	JL	RAIN0
	CMP	B[TANK2+1],35	;max freq
	JG	RAIN0B
	MOV	AX,[TANK3]	;get parameters
	ADD	AL,[TANK2]	;stagger
	AND	AL,9FH		;prevent line wrap
	MOV	AH,[TANK2+1]	;restore frequency
	MOV	[TANK3],AX	;save parameters
	CALL	NEWLN		;draw new line
	CALL	DROP		;shift down
	MOV	CX,RANDLY	;wait count
RAIN1:	CALL	CONSTA		;look for keypress
	CMP	AL,00
	JNE	RAIN1A
	CALL	CONSTA
RAIN1A:	CMP	AL,ESC		;quit
	JNE	RAIN1B
	JMP	MAIN
RAIN1B:	CMP	AL,SPACE	;quit
	JNE	RAIN2
	JMP	MAIN
RAIN2:	CMP	AL,UP
	JNE	RAIN3
	INC	B[TANK+1]	;change character color
	TEST	B[TANK+1],0FH
	JNE	RAIN0
	SUB	B[TANK+1],10H
	JMP	RAIN0
RAIN3:	CMP	AL,DOWN
	JNE	RAIN4
	ADD	B[TANK+1],10H	;change background color
	TEST	B[TANK+1],80H
	JNE	RAIN3A
	JMP	RAIN0
RAIN3A:	AND	B[TANK+1],7FH
	JMP	RAIN0
RAIN4:	CMP	AL,RIGHT
	JNE	RAIN5
	INC	B[TANK]		;inc character
	JMP	RAIN0
RAIN5:	CMP	AL,LEFT
	JNE	RAIN6
	DEC	B[TANK]		;dec character
	JMP	RAIN0
RAIN6:	CMP	AL,KEND		
	JNE	RAIN7
	JMP	HRAIN		;reset parameters
RAIN7:	DEC	CX
	JNE	RAIN1
	JMP	RAIN0

NEWLN:	PUSH	DS
	MOV	DX,VIDSEG
	MOV	DS,DX
	MOV	CL,AL
	MOV	BX,0		;first character location
NEWLN1:	MOV	DX,BLANK	;set blank character
NEWLN2:	MOV	[BX],DX		;display character
	ADD	BX,2		;next location
	CMP	BX,0A0H		;end of line?
	JGE	NEWLN3
	DEC	CL		
	JNE	NEWLN1
	MOV	CL,AH
	CS:
	MOV	DX,[TANK]	;get data
	JMP	NEWLN2
NEWLN3:	POP	DS
	RET

DROP:	PUSH	DS
	MOV	AX,VIDSEG	;setup for display
	MOV	DS,AX
	MOV	CX,0EFFH	;initial source
	MOV	DX,0F9FH	;initail destination
DROP1:	MOV	BX,CX		;copy
	MOV	AX,[BX]
	MOV	BX,DX
	MOV	[BX],AX
	DEC	DX		;bump locations
	DEC	CX
	JNE	DROP1
	POP	DS		;restore data segment
	RET

;-----------------------------

DRAW:	CALL	CLEAR		;clear screen
	MOV	DX,DRAWMN	;display instructions
	CALL	CONOUT		
	CALL	CHRIN		;continue?
	CALL	CLEAR		
	MOV	DX,8401H	;initial chr, blinking smiley face
	MOV	CX,0		;set move mode
	MOV	BX,0730H	;initial position
	MOV	AX,VIDSEG	;setup for video display
	MOV	DS,AX	
	MOV	[BX],DX
DRAW1:	CALL	CHRIN		;look input
	CALL	KEYCHK		;evaluate
	JMP	DRAW1


KEYCHK:	CMP	AL,ESC		;look for quit character
	JNE	KYCHK1
	JMP	MAIN
KYCHK1:	CMP	AL,00		;look for two byte code
	JE	KYCH10
	JMP	KYCHKX
KYCH10:	CALL	CONSTA		;get second byte
	CMP	AL,UP
	JNE	KYCHK2
	TEST	CL,0FFH
	JNE	KYCH1A
	MOV	[BX],[CTANK]	;display old chr
KYCH1A:	SUB	BX,0A0H		;move up
	CMP	BX,0F9FH
	JG	KYCH2A
	MOV	[CTANK],[BX]
	MOV	[BX],DX
	RET
KYCHK2:	CMP	AL,DOWN
	JNE	KYCHK3
	TEST	CL,0FFH
	JNE	KYCH2A
	MOV	[BX],[CTANK]	;display old chr
KYCH2A:	ADD	BX,0A0H		;move down
	CMP	BX,0F9FH
	JG	KYCH1A
	MOV	[CTANK],[BX]
	MOV	[BX],DX		;display character
	RET
KYCHK3:	CMP	AL,LEFT
	JNE	KYCHK4
	TEST	CL,0FFH
	JNE	KYCH3A
	MOV	[BX],[CTANK]	;display old chr
KYCH3A:	SUB	BX,2		;move left
	MOV	[CTANK],[BX]
	MOV	[BX],DX		;display character
	RET
KYCHK4:	CMP	AL,RIGHT
	JNE	KYCHK5
	TEST	CL,0FFH
	JNE	KYCH4A
	MOV	[BX],[CTANK]	;display blank
KYCH4A:	ADD	BX,2		;move right
	MOV	[CTANK],[BX]
	MOV	[BX],DX		;display character
	RET
KYCHK5:	CMP	AL,F1		;if a function key, color change
	JL	KYCHK6
	CMP	AL,F8
	JG	KYCHK6
	JMP	FCOLOR 
KYCHK6:	CMP	AL,SF1		;if shift+func, change back color
	JL	KYCHK7
	CMP	AL,SF8
	JG	KYCHK7
	JMP	BCOLOR
KYCHK7:	CMP	AL,F9
	JNE	KYCH7A
	DEC	DL		;decrement chr
	MOV	[BX],DX
	RET
KYCH7A:	CMP	AL,F10
	JNE	KYCHK8
	INC	DL		;inc chr
	MOV	[BX],DX
	RET
KYCHK8:	CMP	AL,F11
	JNE	KYCHK9
	XOR	DH,08		;toggle 'bright'
	MOV	[BX],DX		;display character
	RET
KYCHK9:	CMP	AL,F12
	JNE	KYCHKA
	XOR	DH,80H		;toggle flashing
	MOV	[BX],DX		;display character
	RET
KYCHKA:	CMP	AL,DELT		
	JNE	KYCHKW
	MOV	[CTANK],DX
	CALL	DELETE		;delete mode
KYCHKW:	RET
KYCHKX:	CMP	AL,20H		;retain space for display
	JNE	KYCHKY
	XOR	CL,01		;toggle draw/move mode
	RET
KYCHKY:	ADD	AL,7FH		;alter to interesting ascii chars
	MOV	DL,AL
	MOV	[BX],DX		;display character
	RET

FCOLOR:	AND	DH,0F8H		;clear fore color
	SUB	AL,F1		;change al to color number
	OR	DH,AL		;put color in character data
	MOV	[BX],DX		;display character
	RET

BCOLOR:	AND	DH,8FH		;clear back color
	SUB	AL,SF1		;change al to color 
	ROR	AL,4		;shift to back color place
	OR	DH,AL		;put color into cahracter
	MOV	[BX],DX		;display character
	RET

DELETE:	MOV	[BX],8401H	;cursor
	MOV	CL,0		;move mode
	CALL	CHRIN
	JMP	DELKEY

DELKEY:	CMP	AL,ESC
	JNE	DKY1
	MOV	[BX],[CTANK]
	RET	
DKY1:	CMP	AL,SPACE
	JNE	DKY2
	MOV	[BX],[CTANK]
	RET
DKY2:	CMP	AL,UP
	JNE	DKY3
	MOV	[BX],BLANK
	SUB	BX,0A0H
	JMP	DELETE
DKY3:	CMP	AL,DOWN
	JNE	DKY4
	MOV	[BX],BLANK
	ADD	BX,0A0H
	JMP	DELETE
DKY4:	CMP	AL,LEFT
	JNE	DKY5
	MOV	[BX],BLANK
	SUB	BX,02
	JMP	DELETE
DKY5:	CMP	AL,RIGHT
	JNE	DKY6
	MOV	[BX],BLANK
	ADD	BX,02
DKY6:	JMP	DELETE

;----------------------------

SMILEINV:
	CALL	CLEAR
	MOV	DX,SPACMN
	CALL	CONOUT
	CALL	CHRIN
	CALL	CLEAR
	CALL	SETKEY
	CALL	SHSCMN
	CALL	GMOVE
SMILE0:	MOV	CH,BLKDLY
SMILE1:	MOV	CL,SHTDLY
SMILE2:	PUSH	CX
	CALL	CONSTA
	CALL	DOKEY
	POP	CX
	DEC	CL
	JNE	SMILE2
	CALL	SHTMOV
	DEC	CH
	JNE	SMILE1
	CALL	BMOVE
	CALL	ALMOVE
	CALL	CREATE
	CALL	SCORIT
	JMP	SMILE0

SETKEY:
	MOV	AX,0305H
	MOV	BX,01FFH
	INT	16H
	RET

SHSCMN:	MOV	W[SCORE],0
	MOV	SI,SCRMN
	MOV	DI,0
	MOV	CL,12
	PUSH	DS
	MOV	AX,VIDSEG
	MOV	DS,AX
SHSCM1:	CS:
	MOV	DX,[SI]
	MOV	[DI],DX
	ADD	SI,2
	ADD	DI,2
	DEC	CL
	JNE	SHSCM1
	POP	DS
	RET

DOKEY:	CMP	AL,0
	JNE	DOKY0
	CALL	CONSTA
DOKY0:	CMP	AL,ESC
	JNE	DOKY1
	JMP	MAIN
DOKY1:	CMP	AL,SPACE
	JNE	DOKY2
	JMP	GSHOOT
DOKY2:	CMP	AL,LEFT
	JNE	DOKY3
DOKY2A:	SUB	W[GPOSIT],2
	JLE	DOKY3A
	JMP	GMOVE
DOKY3:	CMP	AL,RIGHT
	JNE	DOKY4
DOKY3A:	ADD	W[GPOSIT],2
	CMP	W[GPOSIT],9AH
	JGE	DOKY2A
	JMP	GMOVE
DOKY4:	RET

GSHOOT:	MOV	DI,0DC0H
	ADD	DI,[GPOSIT]
	ADD	DI,2
	MOV	DX,GSHOT	;character for shot
	CALL	DSPCHR
	RET

GMOVE:	MOV	DI,0E60H	;first row for gun
	MOV	SI,GUN
	MOV	CX,203H		;row, column counter
	ADD	DI,[GPOSIT]
GMOVE1:	CALL	DRAWIT
	ADD	DI,098H		;next line of gun
	MOV	CL,5		;reset column counter for second row
	DEC	CH
	JNE	GMOVE1
	RET

SHTMOV:	PUSH	DS
	MOV	AX,VIDSEG
	MOV	DS,AX
	MOV	SI,0A0H
SHMOVA:	MOV	DI,SI
	SUB	DI,0A0H
	MOV	DX,[SI]
	CMP	DX,GSHOT
	JE	SHMOV1
SHMOVX:	ADD	SI,2
	CMP	SI,0FA0H
	JL	SHMOVA
SHMOVY:	POP	DS
	RET

SHMOV1:	MOV	DX,[DI]
	CMP	DH,05		;check for block
	JNE	SHMV1A
	MOV	[SI],BLANK	;blank character
	JMP	SHMOVX
SHMV1A:	CMP	DH,04		;look for enemy by color
	JNE	SHMV1C
	MOV	[SI],BLANK
	CALL	EXPLOD
	CS:
	ADD	W[SCORE],10
	JMP	SHMOVX
SHMV1C:	CMP	DX,ESHOT	;look for enemy's shot
	JNE	SHMV1D
	MOV	[DI],ESTAR
	MOV	[SI],BLANK
	JMP	SHMOVX
SHMV1D:	CMP	DH,0BH		;look for bomb
	JNE	SHMOVW
	CALL	EXPLOD
	CS:
	ADD	W[SCORE],1
	JMP	SHMOVX
SHMOVW:	CMP	DI,0A0H
	JGE	SHMOW1
	MOV	[SI],BLANK	;don't move up to top line
	JMP	SHMOVX
SHMOW1:	MOV	[DI],GSHOT	;move shot up a place
	MOV	[SI],BLANK
	JMP	SHMOVX

SCORIT:	MOV	AX,[SCORE]
	CALL	HEXASC
	MOV	DI,18
	CALL	SCORT1
	MOV	AL,[SCORE+1]
	CALL	HEXASC
	MOV	DI,14
	CALL	SCORT1
	RET
SCORT1:	PUSH	DS
	MOV	AX,VIDSEG
	MOV	DS,AX
	MOV	[DI],DH
	MOV	B[DI+1],07
	MOV	[DI+2],DL
	MOV	B[DI+3],07
	POP	DS
	RET

ALMOVE:	PUSH	DS
	MOV	AX,VIDSEG
	MOV	DS,AX
	MOV	SI,0F9EH
ALMOV:	MOV	DI,SI
	ADD	DI,0A0H
	MOV	DX,[SI]
	CMP	DX,ESTAR
	JNE	AMOVE0
	MOV	[SI],ESTAR1
	JMP	AMOVEX
AMOVE0:	CMP	DX,ESTAR1
	JNE	AMOVE1
	MOV	[SI],BLANK
	JMP	AMOVEX
AMOVE1:	CMP	DX,ESHOT	;look for enemy shot
	JNE	AMOVE2
	MOV	DX,[DI]
	CMP	DH,04		;check for enemy
	JNE	ESHT1
	CALL	EXPLOD
	JMP	AMOVEX
ESHT1:	CMP	DH,05		;check for block
	JNE	ESHT2
	MOV	[SI],BLANK
	JMP	AMOVEX
ESHT2:	CMP	DH,02H		;check for gun
	JNE	ESHT3
	JMP	GOVER
ESHT3:	MOV	[DI],ESHOT	;move shot down
	MOV	[SI],BLANK
	JMP	AMOVEX
AMOVE2:	CMP	DX,0B02H	;look for middle of bomb
	JNE	AMOVE3
	MOV	DX,[DI]
	CMP	DH,04		;look for enemy
	JNE	BOMOV1
BOMOV0:	SUB	DI,0A0H
	CALL	EXPLOD
	JMP	AMOVEX
BOMOV1:	CMP	DH,05		;look for block
	JE	BOMOV0
BOMOV2:	CMP	DH,02		;look for gun
	JNE	BOMOV3
	JMP	GOVER
BOMOV3:	MOV	BX,BOMB
	SUB	DI,2
	SUB	SI,2
	CALL 	MOVEIT
	JMP	AMOVEX
AMOVE3:	CMP	DX,0402H	;look for enemy by middle chr
	JNE	AMOVEX
	MOV	DX,[DI]
	CMP	DH,05H		;block
	JNE	EMOVEA
	SUB	DI,0A0H
	CALL	EXPLOD
	JMP	AMOVEX
EMOVEA:	CMP	DH,02		;gun
	JNE	EMOVEB
	JMP	GOVER
EMOVEB:	PUSH	SI
	SUB	SI,2
	MOV	DI,SI
	MOV	BX,0A0H
	CMP	SI,140H		;check for top line
	JL	EMOVEC
	CALL	RANDIR
EMOVEC:	ADD	DI,BX
	MOV	BX,ENEMY
	CALL	MOVEIT
	POP	SI
AMOVEX:	SUB	SI,2
	JLE	AMOVEZ
	JMP	ALMOV
AMOVEZ:	POP	DS
	RET

EXPLOD:	MOV	DX,[DI]
	CMP	DL,02
	JE	EXPLD1
	SUB	DI,2
	MOV	DX,[DI]
	CMP	DL,02
	JE	EXPLD1
	ADD	DI,4
EXPLD1:	MOV	[DI],ESHOT
	MOV	[DI-2],ESTAR
	MOV	[DI+2],ESTAR
	MOV	[SI],ESTAR
	RET

RANDIR:	CALL	RANDOM
	CMP	AL,0A0H
	JG	RNDIR1
	MOV	BX,-6
	JMP	RNDIRX
RNDIR1:	CMP	AL,050H
	JG	RNDIR2
	MOV	BX,6
	JMP	RNDIRX
RNDIR2:	MOV	BX,0A0H
RNDIRX:	RET

MOVEIT:	MOV	CL,3
MOVIT0:	CS:
	MOV	DX,[BX]
	MOV	[DI],DX
	MOV	[SI],BLANK
	ADD	BX,2
	ADD	DI,2
	ADD	SI,2
	DEC	CL
	JNE	MOVIT0
	RET

BMOVE:	MOV	AX,[BPOSIT]	;adjust position and directions
BMOVEA:	ADD	AL,[BDIR]
	CMP	AX,02		;far left position
	JG	BMOVEB
	MOV	B[BDIR],02	;move right
	JMP	BMOVEA
BMOVEB:	CMP	AX,064H		;far right for left block
	JL	BMOVEC
	MOV	B[BDIR],0FEH	;move left
	JMP	BMOVEA
BMOVEC:	MOV	[BPOSIT],AX
	CALL	BLMOVE
	MOV	AX,[BPOSIT]
	ADD	AX,30H	
	CALL	BLMOVE
	RET

BLMOVE:	MOV	DI,0C80H	;first row for block
	MOV	SI,BLOCK
	MOV	CX,205H		;row, column counter
	ADD	DI,AX
BMOVE1:	CALL	DRAWIT
	ADD	DI,094H		;next line of gun
	MOV	CL,7		;reset column counter
	DEC	CH
	JNE	BMOVE1
	RET

CREATE:	PUSH	DS
	PUSH	CX
	MOV	AX,VIDSEG
	MOV	DS,AX
	MOV	DI,0A0H
	CALL	RANDOM
CREAT1:	MOV	[DI],BLANK
	ADD	DI,2
	SUB	AL,1
	JGE	CREAT1	
	MOV	DS,CS
CREAT2:	CMP	AH,0H
	JG	CREAT4
	MOV	SI,BOMB
	MOV	CL,3
	CALL	DRAWIT
	JMP	CREATX
CREAT4:	MOV	SI,ENEMY
	MOV	CL,3
	CALL	DRAWIT
CREATX:	MOV	AX,VIDSEG
	MOV	DS,AX
CREATY:	MOV	[DI],BLANK
	ADD	DI,2
	CMP	DI,0A0H
	JL	CREATY
CREATZ:	POP	CX
	POP	DS
	RET

GOVER:	CS:
	MOV	DI,[GPOSIT]
	ADD	DI,0DBEH
	MOV	SI,GKILL
	MOV	CX,0307H
GOVERA:	CALL	DRAWIT
	MOV	CL,07
	ADD	DI,0A0H-14
	DEC	CH
	JNE	GOVERA
GOVER1:	MOV	DI,5A0H+32
	MOV	SI,OVRMSG
	MOV	CX,031EH
GOVERB:	CALL	DRAWIT
	MOV	CL,1EH
	ADD	DI,0A0H-60
	DEC	CH
	JNE	GOVERB
GOVERC:	CALL	CHRIN
	CMP	AL,1BH
	JNE	GOVERC
	JMP	MAIN

;----------------------

DRAWIT:	CS:
	MOV	DX,[SI]		;get character to display
	CALL	DSPCHR		;display character
	ADD	SI,2		;bump locations
	ADD	DI,2
	DEC	CL		;done?
	JNE	DRAWIT
	RET

DSPCHR:	PUSH	AX
	PUSH	DS
	MOV	AX,VIDSEG
	MOV	DS,AX
	MOV	[DI],DX
	POP	DS
	POP	AX
	RET

CONOUT:	MOV	AH,09		;output a string
	INT	21H
	RET
	
CHROUT:	PUSH	DX		;output a character
	MOV	DL,AL
	MOV	AH,02
	INT	21H
	POP	DX
	RET

CHRIN:	MOV	AH,07		;wait for keyboard character
	INT	21H
	RET

CONSTA:	MOV	AH,1
	INT	16H
	CMP	AL,0
	JE	CONSTA
	RET
	
RANDOM:	PUSH	DS
	PUSH	DX
	PUSH	CX
	PUSH	BX
	MOV	DS,CS
	MOV	AH,2CH
	INT	21H		;get date/time
	MOV	AX,DX
	MOV	AH,AL
	ADD	AX,[SEED]	;alter number
	MOV	[SEED],AX
	POP	BX
	POP	CX
	POP	DX
	POP	DS
	RET

TONEON:	IN	AL,61H		;turn speaker on
	OR	AL,3
	OUT	61H,AL
	RET

TONEST:	MOV	AL,DL		;output to speaker
	OUT	42H,AL
	MOV	AL,DH
	OUT	42H,AL
	RET

TONEOF:	IN	AL,61H		;turn speaker off
	AND	AL,0FH
	OUT	61H,AL
	RET

HEXASC:	MOV	AH,AL		;takes hex in al and turns it into 
	ROR	AL,4		;  ascii in dx
	CALL	HEXAS1
	MOV	DH,AL
	MOV	AL,AH
	CALL	HEXAS1
	MOV	DL,AL
	RET
HEXAS1:	AND	AL,0FH
	CMP	AL,0AH		;look for letter
	JL	HEXAS2
	ADD	AL,07
HEXAS2:	ADD	AL,30H
	RET

	END

