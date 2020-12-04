
{---------------------------------------------------------------}
{								}
{	Pascal Mouse						}
{	Mouse Interface for Turbo/Borland Pascal 6.0/7.0	}
{	Version 1.5						}
{       June 17 1997						}
{								}
{	Copyright (c) 1996-1997 Horatiu A. Tanescu		}
{								}
{---------------------------------------------------------------}
{	Testing the mouse in different video modes		}
{---------------------------------------------------------------}

program VideoTest;

uses Mouse, Crt;

{ Selects a specific video mode }
procedure SetVideoMode(const Mode : Byte); assembler;
asm
	XOR	AH, AH
	MOV	AL, Mode
	INT	10H
end;

{ Displays TextString at (X, Y) using the specified color }
procedure WriteStr(const X, Y : Byte; const TextString : string; const Color : Byte); assembler;
asm
	PUSH	BP
	MOV	AH, 13H
	XOR	AL, AL
	XOR	BH, BH
	MOV	BL, Color
	MOV	DH, Y
	MOV	DL, X
	LES	BP, TextString
	XOR	CH, CH
	MOV	CL, ES:[BP]
	INC	BP
	INT	10H
	POP	BP
end;

procedure TestVideoMode(const Mode : Byte);
var
  S : string;
begin
  SetVideoMode(Mode);		{ init video mode }

  Str(Mode, S); S := 'This is video mode ' + S + '. Press any key...';
  WriteStr(0, 0, S, 7);		{ display mode number on screen }

  ShowMouse;			{ show mouse cursor }
  ReadKey;                      { wait for a keystroke }
  HideMouse;			{ hide mouse cursor }
end;

var
  I : Byte;

(* Main program *)

begin
  if not MouseInstalled then  { if a mouse driver is not installed }
  begin                       { then halt program }
    WriteLn('Sorry, mouse is not available');
    Halt(1)
  end;

  for I := 0 to $7 do TestVideoMode(I);     { testing modes 0 to $7   }
  for I := $D to $13 do TestVideoMode(I);   { testing modes $D to $13 }

  SetVideoMode(3)                           { set 80x25 color text mode }
end.