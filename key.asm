;	key.asm  atom powers	 5.20.98
;	a tsr that replaces the key in the keybuffer before int 09

	ORG	0100H

	JMP	INSTALL

JMPFAR: DW	0,0

MAIN:	MOV	AH,05
	MOV	DL,02
	INT	21h

	jmp   0

INSTALL:
	MOV	AL,23h
	MOV	AH,35H
	INT	21H	  ;return int 9 handler in es:bx
	MOV	[JMPFAR+1],BX
	MOV	[JMPFAR+3],ES

	MOV	DX,MAIN
	MOV	AL,23h
        MOV     AH,25H
	INT	21H

	MOV	DX,06H
	MOV	AH,31H
	INT	21H

	JMP	0
