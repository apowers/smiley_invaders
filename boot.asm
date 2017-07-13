;       red.asm         a trick on forrest.


	JMP     MAIN

MESSAG: DB      0DH,0DH,0AH,'REMEMBER WHO YOUR FRIENDS ARE. ',02,0A,0D,'$'

MAIN:   MOV     AH,09   ;display message
	MOV     DX,MESSAG
	INT     21H

	MOV     AH,07   ;wait for keypress
	INT     21H

	CMP	AL,15H	;look for quit character
	JNE	REBOOT
	JMP	0

REBOOT:	INT     19H     ;reboot machine

	JMP     0	;will never happen

