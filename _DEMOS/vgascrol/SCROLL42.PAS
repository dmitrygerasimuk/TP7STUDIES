{ Chain-4 mode example - scrolling 640x400 screen    }
{ By Paradise / Fate (paradise@bachus.umcs.lublin.pl }

uses Palette,Pal,Scr1,Scr2,Scr3,Scr4;

procedure InitVga4; assembler;
asm
    mov    ax, 0013h    { Use bios to enter standard Mode 13h }
    int    10h
    mov    dx, 03c4h    { Set up DX to one of the VGA registers }
    mov    al, 04h      { Register = Sequencer : Memory Modes }
    out    dx, al
    inc    dx           { Now get the status of the register }
    in     al, dx       { from the next port }
    and    al, 0c7h     { AND it with 11000111b ie, bits 3,4,5 wiped }
    or     al, 04h      { Turn on bit 2 (00000100b) }
    out    dx, al       { and send it out to the register }
    mov    dx, 03c4h    { Again, get ready to activate a register }
    mov    al, 02h      { Register = Map Mask }
    out    dx, al
    inc    dx
    mov    al, 0fh      { Send 00001111b to Map Mask register }
    out    dx, al       { Setting all planes active }
    mov    ax, 0a000h   { VGA memory segment is 0a000h }
    mov    es, ax       { load it into ES }
    sub    di, di       { clear DI }
    mov    ax, di       { clear AX }
    mov    cx, 8000h    { set entire 64k memory area (all 4 pages) }
    repnz  stosw        { to colour BLACK (ie, Clear screens) }
    mov    dx, 03d4h    { User another VGA register }
    mov    al, 14h      { Register = Underline Location }
    out    dx, al
    inc    dx           { Read status of register }
    in     al, dx       { into AL }
    and    al, 0bFh     { AND AL with 10111111b }
    out    dx, al       { and send it to the register }
                        { to deactivate Double Word mode addressing }
    dec    dx           { Okay, this time we want another register,}
    mov    al, 17h      { Register = CRTC : Mode Control }
    out    dx, al
    inc    dx
    in     al, dx       { Get status of this register }
    or     al, 40h      { and Turn the 6th bit ON }
    out    dx, al       { to turn WORD mode off }
                        { And thats all there is too it!}
    mov    dx, 3d4h
    mov    al, 13h
    out    dx, al
    inc    dx
    mov    al, 80       { 80 * 8 = Pixels across. Only 320 are visible}
    out    dx, al
end;

procedure CloseVga; assembler;
asm
    mov    ax, 13h
    int    10h
end;

procedure PutPixel(X,Y: Integer; Color: Byte); assembler;
asm
    mov    bx, x
    mov    ax, Y
    mov    cx, 160 
    mul    cx
    mov    di, ax
    mov    ax, bx
    shr    ax, 1
    shr    ax, 1
    add    di, ax
    and    bx, 3
    mov    ah, 1
    mov    cl, bl
    shl    ah, cl
    mov    al, 2
    mov    dx, 03C4h
    mov    bx, $A000
    mov    es, bx
    out    dx, ax 
    mov    al, Color
    mov    es:[di], al
end;

procedure SetAddress(Offs: Word); assembler;
asm
    mov    dx, 03d4h
    mov    al, 0ch
    mov    ah, [byte(Offs)+1]
    out    dx, ax
    mov    al, 0dh
    mov    ah, [byte(Offs)]
    out    dx, ax
end;

function KeyPressed: Boolean; assembler;
asm
    in     al, 60h
    cmp    al, 1
    je     @exit
    xor    al, al
@exit:
end;

procedure Retrace; assembler;
asm
    mov    dx, 3dah
@@1:
    in     al, dx
    test   al, 8
    jnz    @@1
@@2:
    in     al, dx
    test   al, 8
    jz     @@2
end;

procedure ShowPic;
var
 scanline : array [0..639] of byte;
 seg_,ofs_: word;
 x,y      : integer;
begin
 fillchar(stdpal,768,0);
 SetPalette(stdpal);
 seg_:=Seg(_Pal); ofs_:=Ofs(_Pal);
 move(mem[seg_:ofs_],stdpal,768);
 seg_:=Seg(_Scr1); ofs_:=Ofs(_Scr1);
 for y:=0 to 99 do
 begin
  move(mem[seg_:ofs_],scanline,640); inc(ofs_,640);
  for x:=0 to 639 do putpixel(x,y,scanline[x]);
 end;
 seg_:=Seg(_Scr2); ofs_:=Ofs(_Scr2);
 for y:=100 to 199 do
 begin
  move(mem[seg_:ofs_],scanline,640); inc(ofs_,640);
  for x:=0 to 639 do putpixel(x,y,scanline[x]);
 end;
 seg_:=Seg(_Scr3); ofs_:=Ofs(_Scr3);
 for y:=200 to 299 do
 begin
  move(mem[seg_:ofs_],scanline,640); inc(ofs_,640);
  for x:=0 to 639 do putpixel(x,y,scanline[x]);
 end;
 seg_:=Seg(_Scr4); ofs_:=Ofs(_Scr4);
 for y:=300 to 399 do
 begin
  move(mem[seg_:ofs_],scanline,640); inc(ofs_,640);
  for x:=0 to 639 do putpixel(x,y,scanline[x]);
 end;
end;

var Offset: Word;
    MasterTab: Array [0..360,1..2] of Integer;
    i,Counter: Integer;
    Ende,FadeIn,FadeOut: Boolean;
    zero,picp: paltype;
    licznik: longint;

procedure InitTab;
begin
 for i:=0 to 360 do
 begin
  MasterTab[i,1]:=-120+ Round(40* -Sin((i+(i))*PI/90));
  MasterTab[i,2]:= 100+ Round(90*  Cos((i+(2*i))*PI/180));
 end;
 Counter:=0;
end;

procedure NewTab;
begin
 Offset:=MasterTab[Counter,2]*160+MasterTab[Counter,1];
 Inc(Counter);
 if Counter>360 then Counter:=0;
end;

procedure InitMisc;
begin
 fillchar(zero,768,0);
 picp:=stdpal;
 stdpal:=zero;
 Ende:=false;
 FadeOut:=False;
 FadeIn:=True;
 licznik:=0;
 SetPalette(stdpal);
end;

procedure PullMisc;
begin
 Retrace;
 inc(licznik);
 if (FadeIn) and (licznik mod 4=0) then
 begin
  if not(StepPalette(stdpal,picp)) then FadeIn:=False;
  SetPalette(stdpal);
 end;
 if keypressed then begin FadeIn:=False; Ende:=True; FadeOut:=True; end;
 if (FadeOut) and (licznik mod 2=0) then
 begin
  if not(StepPalette(stdpal,zero)) then FadeOut:=False;
  SetPalette(stdpal);
 end;
end;

begin
 InitVga4;
 ShowPic;
 InitTab;
 InitMisc;
 Repeat
  NewTab;
  SetAddress(Offset);
  PullMisc;
 Until (Ende and not(FadeOut));
 CloseVga;
end.