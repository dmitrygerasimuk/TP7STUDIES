uses crt, dos;

 var
  Shift,colorChange,colorNum,i,j:byte;
  scrbuf : array[1..4000] of byte absolute $B800:$0000;

Procedure SetColor(Color, R, G, B : Byte); Assembler;
    Asm
     Mov AX, $1007              {Get register for color}
     Mov BL, Color
     Int $10
     Xor BL, BL
     XChg BH, BL                {Put register in BL}
     Mov AX, $1010              {Set RGB for individual color}
     Mov DH, R
     Mov CH, G
     Mov CL, B
     Int $10
End;


procedure turn_off_cursor;
  var num : word;
  begin
    port[$03D4]:=$0A; num:=port[$03D5];
    port[$03D4]:=$0A; port[$03D5]:=num or 32;
  end;
  {}
  procedure turn_on_cursor;
  var num : word;
  begin
    port[$03D4]:=$0A; num:=port[$03D5];
    port[$03D4]:=$0A; port[$03D5]:=num xor 32;
  end;

 procedure writechar(x,y : byte; c :byte; b:byte);
begin
   
  mem[$b800: (y-1)*80*2 + (x-1)*2] := c;
  mem[$b800: (y-1)*80*2 + (x-1)*2 + 1] := b;
end;
begin
clrscr;
turn_off_cursor;
ColorNUm:=4;
repeat

for i:=0 to 15 do begin
    colorChange:=i+Shift;
    if colorChange>14 then colorChange:=0+colorChange-15;
    SetColor(colorChange,0,0,i*7)
end;

SetColor(0,0,0,0);


for i:=1 to 80 do begin
    for j:=1 to 25 do begin

        writechar(i,j,177, colorNum);
        colorNum:=colorNum+1;
        if colorNum>15 then colorNum:=0;
    end
  end;

  delay (100);
  Shift:=Shift+1;
  if Shift>16 then Shift:=0;
until keypressed;
turn_on_cursor;

clrscr;
end.
