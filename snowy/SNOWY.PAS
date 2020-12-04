{$A+,B-,D-,E-,F-,G+,I-,L-,N-,O-,P-,Q-,R-,S-,T-,V-,X+,Y-}
{$M 4096,0,655360}

{ tapstep = 4 }

PROGRAM Snowy;

CONST
	FlakeCount = 1024;

TYPE
	TFlake = RECORD
		x,y: INTEGER;
		Depth: BYTE;
		Falling: BOOLEAN;
		InAir: BOOLEAN;
	END;

VAR
	Screen: ARRAY[0..63999] OF BYTE ABSOLUTE $A000:0;
	Flake: ARRAY[1..FlakeCount] OF TFlake;

FUNCTION Keypressed: BOOLEAN;
ASSEMBLER;
ASM
	XOR BX,BX
	MOV AH,01H
	INT 16H
	JZ @Done

	MOV BX,-1

@Done:
	MOV AX,BX
END;

FUNCTION Readkey: WORD;
ASSEMBLER;
ASM
	XOR AH,AH
	INT 16H
END;

PROCEDURE VideoModeSet(Mode: BYTE);
ASSEMBLER;
ASM
	XOR AH,AH
	MOV AL,[Mode]
	INT 10H
END;

PROCEDURE PaletteSet(VAR PaletteBuffer; StartColour, EndColour: BYTE);
ASSEMBLER;
ASM
	PUSH DS

	LDS SI,[PaletteBuffer]
	XOR CX,CX
	MOV CL,[EndColour]
	MOV AH,[StartColour]
	MOV BH,AH

	CLD

	MOV BL,1

	CMP CL,AH
	JA @@Incrementing

	STD
	NEG BL
	XCHG CL,AH

@@Incrementing:
	SUB CL,AH
	INC CX

	CLI

@@FillLoop:
	MOV DX,3C8H
	MOV AL,BH
	OUT DX,AL

	MOV DX,3C9H
	LODSB
	OUT DX,AL
	LODSB
	OUT DX,AL
	LODSB
	OUT DX,AL

	ADD BH,BL
	LOOP @@FillLoop

	STI

@@Done:
	POP DS
END;

PROCEDURE TimerWait;
VAR
	i: WORD;
BEGIN
	i:=MEM[$40:$6C];

	WHILE i=MEM[$40:$6C] DO
		;
END;

PROCEDURE PixelPut(x,y: INTEGER; c: BYTE);
BEGIN
	IF (x>-1) AND (x<320) AND (y>-1) AND (y<200) THEN
		Screen[y*320+x]:=c;
END;

PROCEDURE GeneratePalette;
TYPE
	TComponent = RECORD
		r,g,b: BYTE;
	END;

VAR
	NewPalette: ARRAY[0..255] OF TComponent;
	i: INTEGER;
BEGIN
	FOR i:=0 TO 255 DO
		BEGIN
			NewPalette[i].r:=i DIV 4;
			NewPalette[i].g:=i DIV 4;
			NewPalette[i].b:=i DIV 4;
		END;

	PaletteSet(NewPalette,1,255);
END;

PROCEDURE InitializeSnow;
VAR
	i: INTEGER;
BEGIN
	FOR i:=1 TO FlakeCount DO
		BEGIN
			Flake[i].Falling:=FALSE;
			Flake[i].InAir:=FALSE;
		END;
END;

PROCEDURE ShowSnow;
VAR
	i: INTEGER;
BEGIN
	FOR i:=1 TO FlakeCount DO
		IF Flake[i].InAir THEN
			PixelPut(Flake[i].x,Flake[i].y,Flake[i].Depth*8);
END;

PROCEDURE MoveSnow;
VAR
	i: INTEGER;
	NewSnow: BYTE;
	Spd,Loc: INTEGER;
BEGIN
	NewSnow:=RANDOM(255);

	FOR i:=1 TO FlakeCount DO
		BEGIN
			IF (NOT Flake[i].Falling) AND (NewSnow>0) THEN
				BEGIN
					Flake[i].y:=RANDOM(60)-70;
					Flake[i].x:=RANDOM(320);
					Flake[i].Falling:=TRUE;
					Flake[i].InAir:=TRUE;
					Flake[i].Depth:=RANDOM(32);
				END
			ELSE
				BEGIN
					Spd:=Flake[i].Depth DIV 12+1+RANDOM(2);
					Flake[i].y:=Flake[i].y+Spd;
					Flake[i].x:=Flake[i].x-2+RANDOM(5);

					IF Flake[i].y>199 THEN
						BEGIN
							Flake[i].InAir:=FALSE;
							Flake[i].Falling:=FALSE;
						END;
				END;

			IF NewSnow>0 THEN
				NewSnow:=NewSnow-1;
		END;
END;

PROCEDURE KillSnow;
VAR
	i: INTEGER;
BEGIN
	FOR i:=1 TO FlakeCount DO
		IF (Flake[i].Falling) AND (Flake[i].InAir) THEN
			PixelPut(Flake[i].x,Flake[i].y,244);
END;

BEGIN
	VideoModeSet($13); { set 320x200x256 videomode }
	InitializeSnow; { initialize snowflakes }
	GeneratePalette; { set suitable palette }

	REPEAT
		MoveSnow; { change positions of snowflakes }
		ShowSnow; { show snowflakes }
		TimerWait; { pause for about 1/18th seconds }
		KillSnow; { remove snowflakes }
	UNTIL Keypressed; { repeat, until the key was pressed }

	Readkey; { flush keyboard buffer }
	VideoModeSet($3); { set 80x25 textmode }
END.