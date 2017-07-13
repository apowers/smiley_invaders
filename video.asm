;	bars.asm	atom powers	3.2.98/3.5.98
;	paint a variety of verticle bars on the screen to order

;	3.3.98	add happy rain
;	3.4.98	add arrow key controll
;	3.5.98	finish basic routines and start draw

BS	EQU	08H		;backspace
CR	EQU	0DH		;carrage return
LF	EQU	0AH		;line feed
CHAR	EQU	02		;rain chr, smiley face
SPACE	EQU	20H		;blank character
VIDSEG	EQU	0B800H		;video segment address
WHITE	EQU	07		;black back, white chr
FORE	EQU	03		;black back, cyan chr
LSTCHR	EQU	0F9FH		;offset for last screen address
FREQ	EQU	19		;frequency of rain chr
STAGR	EQU	9		;stagger of rain chr
STOP	EQU	'$'		;stop chr for conout
UP	EQU	48H
DOWN	EQU	50H
LEFT	EQU	4BH
RIGHT	EQU	4DH
PGUP	EQU	49H
PGDOWN	EQU	51H
ESC	EQU	1BH
F1	EQU	3BH		;function characters
F8	EQU	42H
F11	EQU	85H
F12	EQU	86H
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
DELY:	DW	0		;for delay routine
DELYS:	DW	0

MENUTX:	DB	CR,LF
	DB	L,TT,TT,TT,TT,TT,TT,TT,BD,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT
	DB	TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,R
	DB	CR,LF
	DB	S,'[1]    ',M,'HORIZONTAL BAR                  ',S,CR,LF
	DB	S,'[2]    ',M,'VERTICLE BAR                    ',S,CR,LF
	DB	S,'[3]    ',M,'BARS W/ HORIZONTAL COLOR CHANGE ',S,CR,LF
	DB	S,'[4]    ',M,'BARS W/ VERTICLE COLOR CHANGE   ',S,CR,LF
	DB	S,'[5]    ',M,'BARBAR POLE                     ',S,CR,LF	
	DB	S,'[6]    ',M,'HAPPY RAIN                      ',S,CR,LF
	DB	S,'[7]    ',M,'DRAW                            ',S,CR,LF
	DB	S,'[ESC]  ',M,'QUIT                            ',S,CR,LF
	DB	S,'[SPACE]',M,'MENU                            ',S,CR,LF
	DB	K,TT,TT,TT,TT,TT,TT,TT,U,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT
	DB	TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,QQ
	DB	CR,LF,STOP

DRAWMN:	DB	CR,LF
	DB	L,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,BD,TT,TT,TT
	DB	TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,R,CR,LF
	DB	S,'F1:  BLACK      ',M,'F5:  RED          ',S,CR,LF
	DB	S,'F2:  BLUE       ',M,'F6:  MAGENTA      ',S,CR,LF
	DB	S,'F3:  GREEN      ',M,'F7:  BROWN        ',S,CR,LF
	DB	S,'F4:  CYAN       ',M,'F8:  WHITE        ',S,CR,LF
	DB	S,'F11: (BRIGHT)   ',M,'F12: (FLASH)      ',S,CR,LF
	DB	Y,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,C,BB,BB,BB
	DB	BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,BB,Z,CR,LF
	DB	S,'SHIFT+FUNCTION: BACKGROUND         ',S,CR,LF
	DB	S,'ARROW KEYS:     MOVE CURSOR        ',S,CR,LF
	DB	S,'ESC:            QUITS BACK TO MENU ',S,CR,LF
	DB	S,'ANY OTHER KEY:  ASCII CHARACTER    ',S,CR,LF
	DB	S,'                (CHR + 6Eh)        ',S,CR,LF
	DB	K,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT
	DB	TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,TT,QQ,CR,LF
	DB	'PRESS ANY KEY TO CONTINUE:',STOP

MAIN:	MOV	SP,STAK		;set stack
	MOV	W[TANK],0	;clear tanks
	MOV	W[TANK2],0
	MOV	W[TANK3],0
	CALL	CLEAR		;clear screen
	MOV	DX,MENUTX	;display menu
	CALL	CONOUT		
	CALL	PROMPT		;menu prompt and routing routines
	JMP	MAIN

CLEAR:	MOV	AX,VIDSEG	;setup video segment
	MOV	DS,AX
	MOV	DH,WHITE	;character to displey
	MOV	DL,SPACE
	MOV	BX,0		;star at first screen character
CLR1:	MOV	[BX],DX		;display character
	ADD	BX,2		;next character location
	CMP	BX,0F9FH	;chk for last chr location
	JLE	CLR1
	MOV	DS,CS		;restore data segment to current seg.
	RET

PROMPT:	MOV	W[DELY],03FFH	;wait times
	MOV	W[DELYS],07
	MOV	AL,'\'		
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

DELAY:	PUSH	AX		;retain registers
	PUSH	CX
	PUSH	DX
DELAY1:	MOV	CX,[DELYS]
DELAY2:	MOV	DX,[DELY]
DELAY3:	NOP			;place holder
	CALL	CONSTA		;look for input
	CALL	ROUT		;rout input
	CALL	KILCHR		;kill char displayed
	DEC	DX
	JNE	DELAY3		;loop first
	DEC	CX
	JNE	DELAY2		;loop second
	POP	DX		;restore registers
	POP	CX
	POP	AX
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
	JMP	HOBAR
ROUTB:	CMP	AL,32H		;'2'
	JNE	ROUTC
	CALL	CLEAR
	JMP	VERBAR
ROUTC:	CMP	AL,33H		;'3'
	JNE	ROUTD
	CALL	CLEAR
	JMP	HBARS
ROUTD:	CMP	AL,34H		;'4'
	JNE	ROUTE
	CALL	CLEAR
	JMP	VBARS
ROUTE:	CMP	AL,35H		;'5'
	JNE	ROUTF
	CALL	CLEAR
	JMP	BBAR
ROUTF:	CMP	AL,36H		;'6'
	JNE	ROUTG
	CALL	CLEAR
	JMP	HRAIN
ROUTG:	CMP	AL,37H		;'7'
	JNE	ROUTX
	JMP	DRAW
ROUTX:	RET

HOBAR:	MOV	B[TANK],21H	;character
	MOV	B[TANK+1],10H	;color
HOBAR1:	MOV	BX,0780H	;middle of screen
	MOV	DX,[TANK]	;get chr data
	MOV	CL,0A0H		;column count
	MOV	AL,1		;character increment
	MOV	AH,1		;color increment
	CALL	HBAR		;display row
	MOV	DL,21H		;character
	MOV	DH,10H		;color
	CALL	CHRIN		;wait for keypress
	CALL	CONSTA		;get second chr of function code
	CMP	AL,UP		
	JNE	HOBAR2
	INC	B[TANK+1]	;change forground color
	JMP	HOBAR1
HOBAR2:	CMP	AL,DOWN
	JNE	HOBAR3
	ADD	B[TANK+1],10H	;change background color
	JMP	HOBAR1
HOBAR3:	CMP	AL,LEFT
	JNE	HOBAR4
	INC	B[TANK]		;change first character left
	JMP	HOBAR1
HOBAR4:	CMP	AL,RIGHT
	JNE	HOBAR5
	DEC	B[TANK]		;change first chr right
	JMP	HOBAR1
HOBAR5:	
HOBARX:	JMP	MAIN

VERBAR:	MOV	B[TANK],30H	;set first chr
	MOV	B[TANK+1],40H	;set first color
VRBAR0:	MOV	BX,50H		;set screen position
	MOV	DX,[TANK]	;load data
	MOV	AL,1		;color inc
	MOV	AH,1		;letter inc
	MOV	CH,25		;row count
VRBAR1:	MOV	CL,2
	CALL	HBAR		;display chr
	ADD	BX,09EH		;next line
	DEC	CH		;bump count
	JNE	VRBAR1
	CALL	CHRIN		;check for input
	CALL	CONSTA
	CMP	AL,UP
	JNE	VRBAR2
	INC	B[TANK+1]	;change fore color
	JMP	VRBAR0
VRBAR2:	CMP	AL,DOWN
	JNE	VRBAR3
	ADD	B[TANK+1],10H	;change back color
	JMP	VRBAR0
VRBAR3:	CMP	AL,LEFT
	JNE	VRBAR4
	INC	B[TANK]		;change start character left
	JMP	VRBAR0
VRBAR4:	CMP	AL,RIGHT
	JNE	VRBAR5
	DEC	B[TANK]		;change start chr right
	JMP	VRBAR0
VRBAR5:	
VRBARX:	JMP	MAIN
	
HBARS:	MOV	B[TANK],21H	;first character
	MOV	B[TANK+1],01H	;first color
HBARS0:	MOV	BX,0		;first chr location
	MOV	AL,1		;chr increment
	MOV	AH,0		;color increment
	MOV	CH,25		;row count
	MOV	W[TANK2],W[TANK];save into worknig
HBARS1:	MOV	CL,0A0H		;column count
	MOV	DX,[TANK2]	;restore original character
	ADD	DH,10H		;next back color
	AND	DH,7FH		;don't blink
	MOV	[TANK2],DX	;save for next loop
	CALL	HBAR		;display 
	DEC	CH		;bump count
	JNE	HBARS1
	CALL	CHRIN		;look for input
	CALL	CONSTA
	CMP	AL,UP
	JNE	HBARS2
	INC	B[TANK+1]	;change fore color
	JMP	HBARS0
HBARS2:	CMP	AL,DOWN
	JNE	HBARS3
	ADD	B[TANK+1],10H	;change back color
	JMP	HBARS0
HBARS3:	CMP	AL,LEFT
	JNE	HBARS4
	INC	B[TANK]		;change character left
	JMP	HBARS0
HBARS4:	CMP	AL,RIGHT
	JNE	HBARS5
	DEC	B[TANK]		;change character right
	JMP	HBARS0
HBARS5:	
HBARSX:	JMP	MAIN	

VBARS:	MOV	B[TANK],21H	;first character
	MOV	B[TANK+1],01	;first color
VBARS0:	MOV	BX,0		;first chr location
	MOV	AL,1		;character inc
	MOV	AH,11H		;color inc
	MOV	CH,25		;row count
VBARS1:	MOV	CL,0A0H		;column count
	MOV	DX,[TANK]	;character data
	CALL	HBAR		;display
	DEC	CH
	JNE	VBARS1
	CALL	CHRIN		;lookk for input
	CALL	CONSTA
	CMP	AL,UP
	JNE	VBARS2
	INC	B[TANK+1]	;change fore color
	JMP	VBARS0
VBARS2:	CMP	AL,DOWN
	JNE	VBARS3
	ADD	B[TANK+1],10H	;change back color
	JMP	VBARS0
VBARS3:	CMP	AL,LEFT
	JNE	VBARS4
	INC	B[TANK]		;change character lift
	JMP	VBARS0
VBARS4:	CMP	AL,RIGHT
	JNE	VBARS5
	DEC	B[TANK]		;change char right
	JMP	VBARS0
VBARS5:	
VBARSX:	JMP	MAIN

BBAR:	MOV	DL,21H		;first character
	MOV	DH,01H		;first color
	MOV	W[TANK3],101H	;row change
BBAR0:	MOV	BX,0		;first character
	MOV	AL,01		;character inc
	MOV	AH,01		;color inc
	MOV	CH,25		;row count
	MOV	[TANK],DX	;save chr data
	MOV	[TANK2],DX
BBAR1:	MOV	CL,0A0H		;column count
	CALL	HBAR		;display
	MOV	DX,[TANK]	;save char data
	ADD	DX,[TANK3]	;begin for next row
	TEST	DH,0FH		;look for background change
	JNE	BBAR1A	
	SUB	DH,10H		;reset background change
BBAR1A:	MOV	[TANK],DX	;save char data
	DEC	CH
	JNE	BBAR1
	CALL	CHRIN		;look for input
	CALL	CONSTA
	MOV	DX,[TANK2]	;recover orig data
	CMP	AL,UP
	JNE	BBAR2
	INC	DH		;change fore color
	TEST	DH,0FH		;prevent background change
	JNE	BBAR0
	SUB	DH,10H
	JMP	BBAR0
BBAR2:	CMP	AL,DOWN
	JNE	BBAR3
	ADD	DH,10H		;change background
	JMP	BBAR0
BBAR3:	CMP	AL,LEFT
	JNE	BBAR4
	INC	DL		;change character left
	JMP	BBAR0
BBAR4:	CMP	AL,RIGHT
	JNE	BBAR5
	DEC	DL		;change character right
	JMP	BBAR0
BBAR5:	CMP	AL,PGUP
	JNE	BBAR6
	MOV	W[TANK3],101H	;set barb direction forward
	JMP	BBAR0
BBAR6:	CMP	AL,PGDOWN
	JNE	BBARX
	MOV	W[TANK3],0FF00H	;set barb direction backward
	JMP	BBAR0
BBARX:	JMP	MAIN

HBAR:	PUSH	AX		;set data segment for video buffer
	MOV	AX,VIDSEG
	MOV	DS,AX
	POP	AX
HBAR1:	MOV	[BX],DX		;display character
	ADD	DL,AL		;increment character
	ADD	DH,AH		;increment color
	TEST	DH,0FH		;look for background change
	JNE	HBAR2		;prevent background change
	SUB	DH,10H
HBAR2:	ADD	BX,2		;next chr location
	SUB	CL,2		;bump count
	JNE	HBAR1
	MOV	DS,CS		;restore data segment
	RET

HRAIN:	MOV	B[TANK],CHAR	;set first character
	MOV	B[TANK+1],FORE	;set first color
	MOV	B[TANK2],STAGR	;set rain stagger
	MOV	B[TANK2+1],FREQ	;set rain frequency
	MOV	W[TANK3],0	;clear tank
RAIN0:	MOV	AX,[TANK3]	;get parameters
	ADD	AL,[TANK2]	;stagger
	AND	AL,9FH		;prevent line wrap
	MOV	AH,[TANK2+1]	;restore frequency
	MOV	[TANK3],AX	;save parameters
	CALL	NEWLN		;draw new line
	CALL	DROP		;shift down
	MOV	CX,0FFFH
RAIN1:	CALL	CONSTA		;look for keypress
	CALL	CONSTA
	CMP	AL,ESC		;quit
	JNE	RAIN1A
	JMP	MAIN
RAIN1A:	CMP	AL,SPACE	;quit
	JNE	RAIN2
	JMP	MAIN
RAIN2:	CMP	AL,UP
	JNE	RAIN3
	INC	B[TANK+1]	;change color
	JMP	RAIN0
RAIN3:	CMP	AL,DOWN		;reset parameters
	JNE	RAIN4
	JMP	HRAIN
RAIN4:	CMP	AL,RIGHT
	JNE	RAIN5
	INC	B[TANK2+1]	;decrease frequency
	JMP	RAIN0
RAIN5:	CMP	AL,LEFT
	JNE	RAIN6
	DEC	B[TANK2+1]	;increase frequency
	JMP	RAIN0
RAIN6:	DEC	CX
	JNE	RAIN1
	JMP	RAIN0

NEWLN:	MOV	CX,VIDSEG	;setup video segment
	MOV	DS,CX
	MOV	CL,AL
	MOV	BX,0		;first character location
NEWLN1:	MOV	DH,WHITE	;set blank character
	MOV	DL,SPACE
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
NEWLN3:	MOV	DS,CS		;restore data segment
	RET

DROP:	MOV	AX,VIDSEG	;setup for display
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
	MOV	DS,CS		;restore data segment
	RET

DRAW:	CALL	CLEAR		;clear screen
	MOV	DX,DRAWMN	;display instructions
	CALL	CONOUT		
	CALL	CHRIN		;continue?
	CALL	CLEAR		
	MOV	DX,8401H	;initial chr, blinking smiley face
	MOV	BX,0730H	;initial position
	MOV	AX,VIDSEG	;setup for video display
	MOV	DS,AX	
DRAW1:	MOV	[BX],DX		;display character
	CALL	CHRIN		;look input
	CALL	KEYCHK		;evaluate
	JMP	DRAW1


KEYCHK:	CMP	AL,ESC		;look for quit character
	JNE	KYCHK1
	MOV	DS,CS		;restore data segment
	JMP	MAIN
KYCHK1:	CMP	AL,00		;look for two byte code
	JNE	KYCHKX
	CALL	CONSTA		;get second byte
	CMP	AL,UP
	JNE	KYCHK2
	SUB	BX,0A0H		;move up
	RET
KYCHK2:	CMP	AL,DOWN
	JNE	KYCHK3
	ADD	BX,0A0H		;move down
	RET
KYCHK3:	CMP	AL,LEFT
	JNE	KYCHK4
	SUB	BX,2		;move left
	RET
KYCHK4:	CMP	AL,RIGHT
	JNE	KYCHK5
	ADD	BX,2		;move right
	RET
KYCHK5:	CMP	AL,F1		;if a function key, color change
	JL	KYCHK7
	CMP	AL,F8
	JG	KYCHK7
	JMP	FCOLOR
KYCHK7:	CMP	AL,F11
	JNE	KYCHK8
	XOR	DH,08		;toggle 'bright'
	RET
KYCHK8:	CMP	AL,F12
	JNE	KYCHKA
	XOR	DH,80H		;toggle flaching
	RET
KYCHKA:	RET
KYCHKX:	CMP	AL,20H		;retain space for display
	JNE	KYCHKY
	MOV	DL,AL
	RET
KYCHKY:	ADD	AL,6EH		;alter to interesting ascii chars
	MOV	DL,AL
	RET

FCOLOR:	MOV	DH,77H		;change fore color
	SUB	AL,3BH
	AND	DH,AL
	MOV	CX,1
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

CHRIN:	MOV	AH,8		;wait for keyboard character
	INT	21H
	RET

CONSTA:	PUSH	DX		;check keyboard for character
	MOV	DL,0FFH
	MOV	AH,06
	INT	21H
	POP	DX
	RET
	
	END

