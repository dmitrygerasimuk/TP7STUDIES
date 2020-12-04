PROGRAM NewScroll;
Uses Crt;

TYPE
  TCell = RECORD C: Char; A: Byte; END;
  TScreen = array[1..25, 1..80] of TCell;

CONST
  Row: byte = 15;
  Col1: byte = 10;
  Col2: byte = 70;
  Attr: byte = $4F; { bwhite / red }
  Txt: string = 'Hello world....         ';

VAR
  Scr: TScreen ABSOLUTE $B800:0;
  I, J: Byte;
BEGIN
  I := 1;
  REPEAT
    while (port[$3da] and 8) <> 0 do;  { wait retrace }
    
    while (port[$3da] and 8) = 0 do;
while (port[$3da] and 8) <> 0 do;  { wait retrace }
    
    while (port[$3da] and 8) = 0 do;

    FOR J := Col1 TO (Col2-1) DO
      Scr[Row, J] := Scr[Row, J+1];  { shift cell left }
    Scr[Row, Col2].C := Txt[I];      { add new cell }
    Scr[Row, Col2].A := Attr;
    I := 1 + (I MOD Length(Txt));
  UNTIL Keypressed;

END.
