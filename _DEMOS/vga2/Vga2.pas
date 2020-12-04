unit VGA2;
interface
const
  STStandard = 1;
  STRLE      = 2;
  VGA = 1;
  Virt = 2;
type
 RectType = RECORD
  X1, Y1, X2, Y2 : INTEGER;
 END;

 BytePtr = array[0..64000] of byte;
 ScreenPtr = ^BytePtr;

 screentype = record
  buffer: ScreenPtr;
  DBuffer: boolean;
  YTable  : ARRAY[0..199] OF WORD;
  Width:word;
  Clip    : RectType;
 end;

 SpriteType = RECORD
  SType         : BYTE;
  Height, Width : INTEGER;
  Data          : ScreenPtr;
  DataLen       : WORD;
 END;

 rgb = record
  r,
  g,
  b : byte
 end;
 paltype  = array[0..255] of rgb;

 letter = record
  x,y:byte;
  data:array[0..100] of byte;
 end;
 fonttype = record
  letter:array[1..122] of letter;
 end;

 procedure initvga;
 procedure closevga;
 PROCEDURE SetClip(X1, Y1, X2, Y2 : INTEGER);
 procedure PutPixel(x,y:word;color:byte);
 procedure PutPixel_C(x,y:word;color:byte);
 function GetPixel(x,y:integer):byte;
 procedure Cls(col:byte);
 procedure Print(x,y,col:word;txt:string;clip:boolean);
 procedure Vsinc;
 Procedure Circle(X, Y, Radius:Word; Color:Byte);
 PROCEDURE HLine(X1, Y, X2 : INTEGER; Color : BYTE);
 PROCEDURE VLine(X, Y1, Y2 : INTEGER; Color : BYTE);
 procedure line(x, y, x2, y2 : integer;col:byte;clip:boolean);
 procedure box(x,y,x1,y1:word;col:byte);
 procedure Square(x,y,x1,y1:word;col:byte);
 procedure Disk(xc,yc,a,b: integer; col:byte);
 PROCEDURE KillSprite(VAR Sprite : SpriteType);
 PROCEDURE CreateSprite(VAR Sprite : SpriteType; Width, Height : INTEGER);
 PROCEDURE Get(VAR Sprite : SpriteType; X1, Y1, X2, Y2 : INTEGER);
 PROCEDURE Put(VAR Sprite : SpriteType; X, Y : INTEGER);
 PROCEDURE Put_c(VAR Sprite : SpriteType; X, Y : INTEGER);
 PROCEDURE MakeRLE(VAR Sprite : SpriteType);
 PROCEDURE PutRLE(VAR Sprite : SpriteType; X, Y : INTEGER);
 PROCEDURE PutRLE_C(VAR Sprite : SpriteType; X, Y : INTEGER);
 PROCEDURE SaveSprite(Sprite : SpriteType; Filename : STRING);
 PROCEDURE LoadSprite(VAR Sprite : SpriteType; Filename : STRING);
 PROCEDURE CopySprite(Source : SpriteType; VAR Dest : SpriteType);
 procedure Use(what:byte);
 PROCEDURE Flip;
 PROCEDURE LoadPCX(dx, dy : WORD; name : STRING);
 procedure setpal(VAR colors:paltype);
 PROCEDURE SetColor(Index, R, G, B : BYTE);
 PROCEDURE ReadColor(Index : BYTE; VAR R, G, B : BYTE);
 Procedure SetBlack;
 Procedure GetPal(var pal:paltype);
 procedure savepal(var colors:paltype;filename:string);
 procedure loadpal(var colors:paltype;filename:string);
 procedure intensity(intensity : byte;var pal:paltype);
 procedure fadeout(t : integer;pal:paltype);
 procedure fadein(t : integer;pal:paltype);
 procedure LoadFont(FileName:string);
 procedure ShowChar(q,b:integer;num:byte;clip:boolean);
 procedure Print_F(x,y:integer;text:string;clip:boolean);
 procedure Print_FC(x,y,col:integer;text:string;clip:boolean);
 var
  screen:screentype;
  rgb256:paltype;
  Font:fonttype;
implementation
 uses dos;

PROCEDURE CalcScreenY(Width : WORD);  { Allow for future expansion }
VAR I : INTEGER;
BEGIN
  FOR I := 0 TO 199 DO
    Screen.YTable[I] := I*Width;
END;

Procedure Delay(ms : Word); Assembler;
Asm
  mov ax, 1000;
  mul ms;
  mov cx, dx;
  mov dx, ax;
  mov ah, $86;
  int $15;
end;

Procedure FillCharFast(Var X; Count: Word; Value:Byte); Assembler;
Asm
  les di,x
  mov cx,Count
  shr cx,1
  mov al,value
  mov ah,al
  rep StoSW
  test count,1
  jz @end
  StoSB
@end:
end;

PROCEDURE SetClip(X1, Y1, X2, Y2 : INTEGER);
BEGIN
  Screen.Clip.X1 := X1; Screen.Clip.Y1 := Y1;
  Screen.Clip.X2 := X2; Screen.Clip.Y2 := Y2;
END;

procedure initVGA;
 begin
  asm
   mov ax,0013h
   int 10h
  end;
 screen.buffer := ptr($A000,0);
 CalcScreenY(320);
 screen.Width := 320;
 SetClip(0, 0, 319, 199);
 getpal(rgb256);
end;

procedure CloseVGA;
 begin
  asm
   push VGA
   call use
   mov ax,0003h
   int 10h
  end;
end;

PROCEDURE PutPixel(X, Y : Word; Color : BYTE);ASSEMBLER;
ASM
  les DI, Screen.buffer
  add DI, X
  mov BX, Y
  add BX, BX
  add DI, DS:[BX+OFFSET screen.Ytable]
  mov AL, Color
  mov ES:[DI], AL
END;

PROCEDURE PutPixel_C(X, Y : Word; Color : BYTE);
begin
if ((x >= screen.clip.x1) and (x <= screen.clip.x2)
 and (y >= screen.clip.y1) and (y <= screen.clip.y2)) then begin
ASM
  les DI, Screen.buffer
  add DI, X
  mov BX, Y
  add BX, BX
  add DI, DS:[BX+OFFSET screen.Ytable]
  mov AL, Color
  mov ES:[DI], AL
END;
end;
end;

function getpixel(x,y:integer):byte;assembler;
asm
  les bx,screen.buffer
  add bx,x
  mov ax,y
  shl ax,6
  add bx,ax
  shl ax,2
  add bx,ax
  mov al,es:[bx]
end;

procedure Cls(col:byte);
begin
 FillCharFast(screen.buffer^,64000,col);
end;

procedure Print(x,y,col:word;txt:string;clip:boolean);
type
  pchar=array[char] of array[0..15] of byte;
var
  p:^pchar;
  c:char;
  i,j,z,b:integer;
  ad,bk:word;
  l,v:longint;
  reg:registers;
begin
  reg.bh:=6;
  reg.ax:=$1130;
  intr($10,reg);
  p:=ptr(reg.es,reg.bp);
  for z:=1 to length(txt) do
  begin
    c:=txt[z];
    for j:=0 to 15 do
    begin
      b:=p^[c][j];
      for i:=0 to 7 do
      begin
        if (b and 128)<>0 then v:=col else v:=0;
        if v > 0 then
         if clip = true then PutPixel_C(x+i,y+j,v);
         if clip = false then PutPixel(x+i,y+j,v);
        b:=b shl 1;
      end;
    end;
    inc(x,8);
  end;
end;

procedure Vsinc;assembler;
asm
        mov dx,$3da
@1:     in al,dx
        test al,8
        jz @1
@2:     in al,dx
        test al,8
        jnz @2
end;

PROCEDURE HLine(X1, Y, X2 : INTEGER; Color : BYTE); ASSEMBLER;
ASM
  les DI, Screen.Buffer
  add DI, X1
  mov BX, Y
  add BX, BX
  add DI, DS:[BX+OFFSET Screen.YTable]
  mov CX, X2
  mov AL, Color
  mov AH, AL
  sub CX, X1
  inc CX
  test DI, 1
  jz @Even
  stosb
  dec CX
@Even:
  shr CX, 1
  rep stosw
  adc CX, 0
  rep stosb
END;

PROCEDURE VLine(X, Y1, Y2 : INTEGER; Color : BYTE); ASSEMBLER;
ASM
  les DI, Screen.Buffer
  add DI, X
  mov BX, Y1
  add BX, BX
  add DI, DS:[BX+OFFSET Screen.YTable]
  mov CX, Y2
  sub CX, Y1
  inc CX
  mov DX, Screen.Width
  mov AL, Color
  mov BX, CX
  and BX, 3
  shr CX, 2
  add BX, BX
  add BX, OFFSET @JumpTable
  jmp WORD PTR CS:[BX]
@JumpTable:
  dw OFFSET @Iteration5
  dw OFFSET @Iteration4
  dw OFFSET @Iteration3
  dw OFFSET @Iteration2
@Iteration1:
  mov ES:[DI], AL
  add DI, DX
@Iteration2:
  mov ES:[DI], AL
  add DI, DX
@Iteration3:
  mov ES:[DI], AL
  add DI, DX
@Iteration4:
  mov ES:[DI], AL
  add DI, DX
@Iteration5:
  dec CX
  jns @Iteration1
END;

procedure Disk(xc,yc,a,b: integer; col:byte);
var
  x, y      : integer;
  aa, aa2,
  bb, bb2,
  d, dx, dy : longint;
begin
  x   := 0;
  y   := b;
  aa  := longint(a) * a;
  aa2 := 2 * aa;
  bb  := longint(b) * b;
  bb2 := 2 * bb;
  d   := bb - aa * b + aa div 4;
  dx  := 0;
  dy  := aa2 * b;
  vLine(xc, yc - y, yc + y,col);

  while (dx < dy) do
  begin
    if (d > 0) then
    begin
      dec(y);
      dec(dy, aa2);
      dec(d, dy);
    end;
    inc(x);
    inc(dx, bb2);
    inc(d, bb + dx);
    vLine(xc - x, yc - y, yc + y,col);
    vLine(xc + x, yc - y, yc + y,col);
  end;

  inc(d, (3 * (aa - bb) div 2 - (dx + dy)) div 2);
  while (y >= 0) do
  begin
    if (d < 0) then
    begin
      inc(x);
      inc(dx, bb2);
      inc(d, bb + dx);
      vLine(xc - x, yc - y, yc + y,col);
      vLine(xc + x, yc - y, yc + y,col);
    end;
    dec(y);
    dec(dy, aa2);
    inc(d, aa - dy);
  end;
end;

PROCEDURE KillSprite(VAR Sprite : SpriteType);
BEGIN
  WITH Sprite DO
  BEGIN
    FREEMEM(Data, DataLen);
    Width := 0; Height := 0; Data := NIL;
  END;
END;

PROCEDURE CreateSprite(VAR Sprite : SpriteType; Width, Height : INTEGER);
BEGIN
  IF Sprite.Data <> NIL THEN KillSprite(Sprite);
  Sprite.Width := Width;
  Sprite.Height := Height;
  Sprite.DataLen := Width*Height;
  Sprite.SType   := STStandard;
  GETMEM(Sprite.Data, Sprite.DataLen);
END;

PROCEDURE Get(VAR Sprite : SpriteType; X1, Y1, X2, Y2 : INTEGER); ASSEMBLER;
VAR ScrIndex : INTEGER;
ASM
  mov DX, X2
  sub DX, X1
  inc DX
  mov BX, Y2
  sub BX, Y1
  inc BX
  push BX
  push DX
  db $66; mov AX, WORD [Sprite]
  db $66; push AX
  push DX
  push BX
  call CreateSprite
  mov AX, X1
  mov BX, Y1
  add BX, BX
  add AX, DS:[BX+OFFSET Screen.YTable]
  mov ScrIndex, AX
  pop DX
  pop BX
  mov AX, Screen.Width
  push DS
  les DI, Sprite
  les DI, ES:[DI+SpriteType.Data]
  lds SI, Screen.Buffer
  add SI, ScrIndex
  sub AX, DX
@YLoop:
  mov CX, DX
  rep movsb
  add SI, AX
  dec BX
  jnz @YLoop
  pop DS
END;

PROCEDURE Put(VAR Sprite : SpriteType; X, Y : INTEGER); ASSEMBLER;
ASM
  les DI, Sprite
  mov AX, X
  mov BX, Y
  add BX, BX
  add AX, DS:[BX+OFFSET Screen.YTable]
  mov BX, AX
  mov AX, Screen.Width
  push DS
  les DI, Screen.Buffer
  add DI, BX
  lds SI, Sprite
  mov DX, DS:[SI+SpriteType.Width]
  mov BX, DS:[SI+SpriteType.Height]
  sub AX, DX
  lds SI, DS:[SI+SpriteType.Data]
@YLoop:
  mov CX, DX
  rep movsb
  add DI, AX
  dec BX
  jnz @YLoop
  pop DS
END;

PROCEDURE put_c(VAR Sprite : SpriteType; X, Y : INTEGER); ASSEMBLER;
VAR
  Height, Width,
  SkippedPixels,
  Index, YI : INTEGER;
ASM
  xor AX, AX
  mov Index, AX
  mov SkippedPixels, AX
  mov CX, X
  mov DX, Y
  cmp CX, Screen.Clip.X2
  jg @TrivialReject
  cmp DX, Screen.Clip.Y2
  jg @TrivialReject
  les DI, Sprite
  mov AX, ES:[DI+SpriteType.Height]
  mov BX, ES:[DI+SpriteType.Width]
  mov Height, AX
  mov Width, BX
  add CX, BX
  add DX, AX
  cmp CX, Screen.Clip.X1
  jl @TrivialReject
  cmp DX, Screen.Clip.Y1
  jl @TrivialReject
  mov AX, Screen.Clip.Y1
  cmp AX, Y
  jle @NoTopClip
  sub AX, Y
  sub Height, AX
  add Y, AX
  mul Width
  add Index, AX
@NoTopClip:
  mov AX, X
  add AX, Width
  dec AX
  cmp Screen.Clip.X2, AX
  jge @NoRightClip
  sub AX, Screen.Clip.X2
  sub Width, AX
  add SkippedPixels, AX
@NoRightClip:
  mov AX, Screen.Clip.X1
  cmp AX, X
  jle @NoLeftClip
  sub AX, X
  add Index, AX
  add SkippedPixels, AX
  sub Width, AX
  add X, AX
@NoLeftClip:
  mov AX, Y
  add AX, Height
  dec AX
  cmp Screen.Clip.Y2, AX
  jge @NoBottomClip
  sub AX, Screen.Clip.Y2
  sub Height, AX
@NoBottomClip:
  les DI, Screen.Buffer
  add DI, X
  mov BX, Y
  add BX, BX
  add DI, DS:[BX+OFFSET Screen.YTable]
  push DS
  mov DX, Screen.Width
  lds SI, Sprite
  mov AX, Height
  lds SI, DS:[SI+SpriteType.Data]
  mov YI, AX
  mov AX, Width
  mov BX, SkippedPixels
  add SI, Index
  sub DX, AX
@MainLoop:
  mov CX, AX
  shr CX, 1
  rep movsw
  adc CX, CX
  rep movsb
  add SI, BX
  add DI, DX
  dec YI
  jnz @MainLoop
  pop DS
@TrivialReject:
END;

PROCEDURE PutRLE(VAR Sprite : SpriteType; X, Y : INTEGER); ASSEMBLER;
VAR I : INTEGER;
ASM
  push DS
  les DI, Sprite
  mov AX, [ES:DI+SpriteType.Height]
  mov I, AX
  mov BX, Y
  add BX, BX
  mov AX, [BX+OFFSET Screen.YTable]
  add AX, X
  mov DX, [ES:DI+SpriteType.Width]
  add DX, AX
  mov BX, Screen.Width
  les SI, ES:[DI+SpriteType.Data]
  add SI, I
  add SI, I
  lds DI, Screen.Buffer
  add DX, DI
  add DI, AX
  mov AX, DS
  mov CX, ES
  mov DS, CX
  mov ES, AX
  mov AX, DI
  mov CH, 0
@YLoop:
@XLoop:
  cmp DI, DX
  jae @OuttaXLoop
  mov CL, DS:[SI]
  inc SI
  shr CL, 1
  jnc @TransparentRun
@DataRun:
  rep movsb
  jmp @XLoop
@TransparentRun:
  add DI, CX
  jmp @XLoop
@OuttaXLoop:
  add AX, BX
  mov DI, AX
  add DX, BX
  dec I
  jnz @YLoop
  pop DS
END;

PROCEDURE PutRLE_C(VAR Sprite : SpriteType; X, Y : INTEGER); ASSEMBLER;
VAR
  I              : INTEGER;
  LeftClip, RightClip,
  Height,
  ScreenOffs,
  StartLine,
  SavedSI,
  ScreenWidth    : WORD;
ASM
  mov AX, Screen.Width     { Copy this into a local variable so that }
  mov ScreenWidth, AX      {  it will be available after we trash DS }
  les SI, Sprite
  mov CX, ES:[SI+SpriteType.Width]   { RightClip := Sprite.Width }
  mov RightClip, CX
  mov DX, ES:[SI+SpriteType.Height]  { Height := Sprite.Height   }
  mov Height, DX
  mov AX, X
  mov BX, Y
  cmp AX, Screen.Clip.X2
  jg @TriviallyReject
  cmp BX, Screen.Clip.Y2
  jg @TriviallyReject
  add CX, AX
  add DX, BX
  cmp CX, Screen.Clip.X1
  jl @TriviallyReject
  cmp DX, Screen.Clip.Y1
  jge @DontTriviallyReject
@TriviallyReject:
  jmp @GetOutOfHere                                    { Trivially Reject }
@DontTriviallyReject:
  mov DI, FALSE                  { Code := FALSE                          }
  cmp DX, Screen.Clip.Y2         { IF (Y+Height > Screen.Clip.Y2) THEN    }
  jle @DontClipBottom                 { Clip the bottom          }
  mov DX, Screen.Clip.Y2
  sub DX, Y
  inc DX
  mov Height, DX                 {   Height := Screen.Clip.Y2-Y+1         }
  mov DI, TRUE                   {   Code := TRUE                         }
@DontClipBottom:                 { END                                    }
  cmp CX, Screen.Clip.X2         { IF (X+RightClip > Screen.Clip.X2) THEN }
  jle @DontClipRight                  { Clip the right           }
  mov CX, Screen.Clip.X2
  sub CX, X
  inc CX
  mov RightClip, CX              {   RightClip := Screen.Clip.X2-X+2      }
  mov DI, TRUE                   {   Code := TRUE                         }
@DontClipRight:                  { END                                    }
  mov CX, 0                      { StartLine := 0                         }
  cmp BX, Screen.Clip.Y1         { IF (Y < Screen.Clip.Y1) THEN           }
  jge @DontClipTop                    { Clip the top             }
  mov AX, Screen.Clip.Y1
  sub AX, BX                     {   StartLine := Screen.Clip.Y1-Y        }
  mov CX, AX                          { Update the starting line }
  mov AX, CX                     {   Height    := Height-StartLine        }
  sub Height, AX                      { Reduce the height        }
  mov AX, Screen.Clip.Y1         {   Y := Screen.Clip.Y1                  }
  mov Y, AX                           { Set the new Y value      }
  mov DI, TRUE                   {   Code := TRUE                         }
@DontClipTop:                    { END                                    }
  mov StartLine, CX
  mov CX, 0                      { LeftClip := 0                          }
  mov AX, X
  cmp AX, Screen.Clip.X1         { IF (X < Screen.Clip.X1) THEN           }
  jge @DontClipLeft                   { Clip the left            }
  mov CX, Screen.Clip.X1
  sub CX, AX                     {   LeftClip := Screen.Clip.X1-X         }
  mov DI, TRUE                   {   Code := TRUE                         }
@DontClipLeft:                   { END                                    }
  mov LeftClip, CX
  or DI, DI                      { IF Code = FALSE THEN                   }
  jnz @DontTriviallyAccept            { Trivially Accept         }
  push WORD [Sprite+2]
  push WORD [Sprite]
  push X
  push Y
  call PutRLE                  {   DrawRLESprite(Sprite, X, Y)          }
  jmp @GetOutOfHere
@DontTriviallyAccept:            { END                                    }
  les DI, Screen.Buffer
  lds SI, Sprite                  { DS:SI now points to Sprite }
  mov BX, Y
  add BX, BX
  mov AX, DS:[BX+OFFSET Screen.YTable]
  add AX, X
  add AX, LeftClip
  add AX, DI
  mov ScreenOffs, AX
  lds SI, DS:[SI+SpriteType.Data] { DS:SI now points to Sprite.Data }
  shl StartLine, 1
  mov SavedSI, SI
  add StartLine, SI
  mov I, 0
@ILoop:                        { FOR I := 0 TO Height-1 DO                 }
  mov BX, StartLine
  add StartLine, 2
  mov SI, DS:[BX]              {   SpritePtr := Sprite.Data^[(StartLine+I)*2]+        }
  add SI, SavedSI              {                Sprite.Data^[(StartLine+I)*2+1] SHL 8 }
  mov AX, ScreenWidth          {   ScreenPtr := (Y+I)*ScreenWidth+X+LeftClip }
  xor BX, BX                   {   J := 0                                  }
  mov DI, ScreenOffs
  add ScreenOffs, AX
  mov CH, 0
  mov CL, DS:[SI]              {   Count := Sprite.Data^[SpritePtr]        }
  inc SI                       {   INC(SpritePtr)                          }
  xor DX, DX
  shr CL, 1
  rcl DX, 1
  mov AX, BX
@ThisWhileLoop:
  add AX, CX
  cmp AX, LeftClip             {   WHILE J+(Count SHR 1) <= LeftClip DO    }
  ja @SkipThisWhileLoop        {   BEGIN                                   }
  or DX, DX                    {     IF (Count AND 1) = 1 THEN             }
  jz @DontUpdateSpritePtr            { Block of pixels }
  add SI, CX                   {        SpritePtr := SpritePtr + Count     }
@DontUpdateSpritePtr:
  mov BX, AX                   {     J := J + Count                        }
  mov CL, DS:[SI]              {     Count := Sprite.Data^[SpritePtr]      }
  inc SI                       {     INC(SpritePtr)                        }
  xor DL, DL
  shr CL, 1
  rcl DX, 1
  jmp @ThisWhileLoop           {    END                                    }
@SkipThisWhileLoop:
 { cmp AX, LeftClip             {    IF J+(Count SHR 1) > LeftClip THEN     }
  jbe @SkipSplitRun                 { If a run is split...    }
  or DX, DX                    {      IF (Count AND 1) = 1 THEN            }
  jz @SkipUpdateSpritePtr           { Block of pixels }
  mov AX, LeftClip
  sub AX, BX
  add SI, AX                   {        SpritePtr := SpritePtr + LeftClip-J}
@SkipUpdateSpritePtr:
  shr DX, 1
  rcl CX, 1         { Reassemble Count to include carry bit }
  mov AX, BX
  sub AX, LeftClip
  add AX, AX
  add CX, AX                   {       Count := Count+((J-LeftClip) SHL 1) }
@SkipSplitRun:
  mov BX, LeftClip             {    J := LeftClip                          }
  xor DX, DX
  shr CL, 1
  rcl DX, 1
  mov AX, BX
@MainWhileLoop:
  add AX, CX
  cmp AX, RightClip            {   WHILE J+(Count SHR 1) <= RightClip DO   }
  ja @SkipMainWhileLoop        {   BEGIN                                   }
  or DL, DL                    {     IF (Count AND 1) = 0 THEN             }
  jnz @PixelRun                      { Transparant run }
  add DI, CX                   {        ScreenPtr := ScreenPtr + Count     }
  mov CL, 0 { Don't execute the rep movsb }
@PixelRun:                     {     ELSE                { Block of pixels }
  rep movsb                    {       WHILE Count > 0 DO...               }
  mov BX, AX
  mov CL, DS:[SI]              { Count := Sprite.Data^[SpritePtr]          }
  inc SI                       {   INC(SpritePtr)                          }
  xor DX, DX
  shr CL, 1
  rcl DX, 1
  jmp @MainWhileLoop           {    END                                    }
@SkipMainWhileLoop:
{ cmp AX, RightClip            {   IF J+(Count SHR 1) > RightClip THEN     }
  jbe @SkipRightSplitRun              { If a run is split...    }
  or DX, DX                    {     IF (Count AND 1) = 1 THEN             }
  jz @SkipRightSplitRun               { Ignore transparent runs }
  mov CX, RightClip                   { Just move what's left   }
  sub CX, BX                   {       Count := RightClip-J                }
  rep movsb                    {       WHILE Count > 0 DO...               }
@SkipRightSplitRun:
  inc I
  mov AX, Height
  cmp I, AX
  jb @ILoop
  mov AX, SEG @Data
  mov DS, AX
@GetOutOfHere:
END;

PROCEDURE MakeRLE(VAR Sprite : SpriteType);
VAR
  SpriteSrc, SpriteDest : WORD;
  NewSprite : SpriteType;
  X, Y, I   : INTEGER;
  RunCount  : INTEGER;
  RunType   : BOOLEAN;
BEGIN
  IF Sprite.SType <> STStandard THEN EXIT;
  NewSprite.Width   := Sprite.Width;
  NewSprite.Height  := Sprite.Height;
  NewSprite.DataLen := Sprite.Width*Sprite.Height*3 DIV 2 + Sprite.Height*2;
  NewSprite.SType   := STRLE;
  GETMEM(NewSprite.Data, NewSprite.DataLen);
  SpriteSrc := 0; SpriteDest := Sprite.Height*2;  { Skip past the list }
  FOR Y := 1 TO Sprite.Height DO
  BEGIN
    NewSprite.Data^[(Y-1)*2  ] := SpriteDest AND 255; { Update the list      }
    NewSprite.Data^[(Y-1)*2+1] := SpriteDest DIV 256; { They are split bytes }
    RunCount := 0;
    RunType := Sprite.Data^[SpriteSrc] <> 0;    { FALSE = Transparent }
    FOR X := 1 TO Sprite.Width DO
    BEGIN
      IF (RunType <> (Sprite.Data^[SpriteSrc] <> 0)) OR (RunCount > 126) THEN
      BEGIN
        NewSprite.Data^[SpriteDest] :=
          (RunCount SHL 1) + (BYTE(RunType) AND 1);
        INC(SpriteDest);
        IF RunType = TRUE THEN
          FOR I := SpriteSrc-RunCount TO SpriteSrc-1 DO
          BEGIN
            NewSprite.Data^[SpriteDest] := Sprite.Data^[I];
            INC(SpriteDest);
          END;
        RunCount := 0;
        RunType := Sprite.Data^[SpriteSrc] <> 0;
      END;
      INC(RunCount);
      INC(SpriteSrc);
    END;
    IF RunCount > 0 THEN
    BEGIN
      NewSprite.Data^[SpriteDest] := (RunCount SHL 1) + (BYTE(RunType) AND 1);
      INC(SpriteDest);
      IF RunType = TRUE THEN
        FOR I := SpriteSrc-RunCount TO SpriteSrc-1 DO
        BEGIN
          NewSprite.Data^[SpriteDest] := Sprite.Data^[I];
          INC(SpriteDest);
        END;
      RunCount := 0;
      RunType := Sprite.Data^[SpriteSrc] <> 0;
    END;
  END;
  KillSprite(Sprite);
  Sprite := NewSprite;
  Sprite.DataLen := SpriteDest;
  GETMEM(Sprite.Data, Sprite.DataLen);
  Move(NewSprite.Data^, Sprite.Data^, Sprite.DataLen); 
  KillSprite(NewSprite);
END;

PROCEDURE Flip; ASSEMBLER;
ASM
  cmp Screen.DBuffer, 0
  je @Done
  push DS
  mov CX, 64000 / 4
  mov AX, 0A000h
  mov ES, AX
  xor DI, DI
  lds SI, Screen.Buffer
  cld
  db $66; rep movsw
  pop DS
@Done:
END;

procedure Use(what:byte);
begin
 if what = 1 then begin
  if screen.dbuffer = false then exit;
   FREEMEM(Screen.Buffer, 64000);
   Screen.Buffer := PTR($A000, 0);
   Screen.DBuffer := FALSE;
 end;
 if what = 2 then begin
  if screen.Dbuffer then exit;
   GETMEM(Screen.Buffer, 64000);
   Screen.DBuffer := TRUE;
 end;
end;

PROCEDURE loadpcx(dx, dy : WORD; name : STRING);
VAR q                          : FILE;
    b                          : ARRAY[0..2047] OF BYTE;
    anz, pos, c, w, h, e, pack : WORD;
    x, y                       : WORD;
LABEL ende_background;
BEGIN
  x := dx; y := dy;
  ASSIGN(q, name); {$I-} RESET(q, 1);{$I+}
  IF IORESULT <> 0 THEN
    GOTO ende_background;
  BLOCKREAD(q, b, 128, anz);
  IF (b[0] <> 10) OR (b[3] <> 8) THEN
  BEGIN
    CLOSE(q);
    GOTO ende_background;
    END;
  w := SUCC((b[9] - b[5]) SHL 8 + b[8] - b[4]);
  h := SUCC((b[11] - b[7]) SHL 8 + b[10] - b[6]);
  pack := 0; c := 0; e := y + h;
  REPEAT
    BLOCKREAD(q, b, 2048, anz);
    pos := 0;
    WHILE (pos < anz) AND (y < e) DO
    BEGIN
      IF pack <> 0 THEN
      BEGIN
        FOR c := c TO c + pack DO
          Putpixel(x+c,y,b[pos]);
        pack := 0;
      END
      ELSE
        IF (b[pos] AND $C0) = $C0 THEN
          pack := b[pos] AND $3F
        ELSE
        BEGIN
          Putpixel(x+c,y,b[pos]);
          INC(c);
        END;
      INC(pos);
      IF c = w THEN
      BEGIN
        c := 0;
        INC(y);
      END;
    END;
  UNTIL (anz = 0) OR (y = e);
   SEEK(q, FILESIZE(q) - 3 SHL 8 - 1);
  BLOCKREAD(q, b, 3 SHL 8 + 1);
   IF b[0] = 12 THEN
    FOR x := 1 TO 3 SHL 8 + 1 DO
      b[x] := b[x] SHR 2;
   PORT[$3C8] := 0;
   FOR x := 0 TO 255 DO
  BEGIN
    PORT[$3C9] := b[x*3+1];
    PORT[$3C9] := b[x*3+2];
    PORT[$3C9] := b[x*3+3];
  END;
   CLOSE(q);
ende_background:
END;

procedure setpal(VAR colors:paltype);
var
 t:byte;
begin
 for t := 0 to 255 do
  setcolor(t,colors[t].r,colors[t].g,colors[t].b);
end;

PROCEDURE SetColor(Index, R, G, B : BYTE);
BEGIN
  Port[$3C8] := Index;
  Port[$3C9] := R;
  Port[$3C9] := G;
  Port[$3C9] := B;
END;

PROCEDURE ReadColor(Index : BYTE; VAR R, G, B : BYTE);
BEGIN
  Port[$3C7] := Index;
  R := Port[$3C9];
  G := Port[$3C9];
  B := Port[$3C9];
END;

Procedure SetBlack;
begin
 intensity(0,rgb256);
end;

Procedure GetPal(var pal:paltype);
var r,g,b,t:byte;
begin
 for T := 0 to 255 do
  begin
   ReadColor(t,r,g,b);
   pal[t].r := r;
   pal[t].g := g;
   pal[t].b := b;
  end;
end;

procedure intensity(intensity : byte;var pal:paltype);
var
  i : integer;
begin
  port[$3C8] := $00;
  for i := 0 to 255 do begin
    port[$3C9] := pal[i].r*intensity div 63;
    port[$3C9] := pal[i].g*intensity div 63;
    port[$3C9] := pal[i].b*intensity div 63;
  end;
end;

procedure fadeout(t : integer;pal:paltype);
var i:integer;
begin
  for i := 63 downto 0 do
   begin
    vsinc;
    intensity(i,pal);
    delay(t);
   end;
end;

procedure fadein(t : integer;pal:paltype);
var i:integer;
begin
  for i := 0 to 63 do
  begin
   vsinc;
   intensity(i,pal);
   delay(t);
  end;
end;

Procedure Circle(X, Y, Radius:Word; Color:Byte);
Var
   Xs, Ys    : Integer;
   Da, Db, S : Integer;
begin
     if (Radius = 0) then
          Exit;
      if (Radius = 1) then
     begin
          PutPixel(X, Y, Color);
          Exit;
     end;
     Xs := 0;
     Ys := Radius;
     Repeat
           Da := Sqr(Xs+1) + Sqr(Ys) - Sqr(Radius);
           Db := Sqr(Xs+1) + Sqr(Ys - 1) - Sqr(Radius);
           S  := Da + Db;
           Xs := Xs+1;
           if (S > 0) then
                Ys := Ys - 1;
           PutPixel(X+Xs-1, Y-Ys+1, Color);
           PutPixel(X-Xs+1, Y-Ys+1, Color);
           PutPixel(X+Ys-1, Y-Xs+1, Color);
           PutPixel(X-Ys+1, Y-Xs+1, Color);
           PutPixel(X+Xs-1, Y+Ys-1, Color);
           PutPixel(X-Xs+1, Y+Ys-1, Color);
           PutPixel(X+Ys-1, Y+Xs-1, Color);
           PutPixel(X-Ys+1, Y+Xs-1, Color);
     Until (Xs >= Ys);
end;

procedure square(x,y,x1,y1:word;col:byte);
begin
 hline(x,y,x1,col);
 hline(x,y1,x1,col);
 vline(x1,y,y1,col);
 vline(x,y,y1,col);
end;

procedure box(x,y,x1,y1:word;col:byte);
var t:word;
begin
 for t := y to y1 do
  hline(x,t,x1,col);
end;

procedure LoadFont(FileName:string);
var
 f:file of fonttype;
begin
 assign(f,FileName);
 reset(f);
 read(f,font);
 close(f);
end;
procedure ShowChar(q,b:integer;num:byte;clip:boolean);
var
 index:byte;
 t,x,y:byte;
begin
 X:=0;
 Y:=1;
 index := 0;
 repeat
  x:=x+1;
  if font.Letter[num].data[index] <> 0 then
  begin
  if clip = false then putpixel(x+q,y+b,font.letter[num].data[index]);
  if clip = true then putpixel_c(x+q,y+b,font.letter[num].data[index]);
  end;
  index := index +1;
  if x = font.letter[num].x then
  begin
   index := index + 10 - x;
   x:=0;
   y:=y+1;
  end;
 until Y = font.letter[num].y+1;
end;
procedure print_f(x,y:integer;text:string;clip:boolean);
var
 c:byte;
 t:byte;
 l:integer;
begin
 L:=x;
 for t := 1 to length(text) do
  begin
   c := ORD(text[t]);
   ShowChar(l,y,c,clip);
   l:=l+font.letter[c].x +1;
  end;
end;
procedure print_FC(x,y,col:integer;text:string;clip:boolean);
var
 c:byte;
 t:byte;
 l:integer;
procedure CShowChar(q,b,col:integer;num:byte;clip:boolean);
var
 index:byte;
 t,x,y:byte;
begin
 X:=0;
 Y:=1;
 index := 0;
 repeat
  x:=x+1;
  if font.Letter[num].data[index] <> 0 then
  begin
   if clip = false then putpixel(x+q,y+b,col);
   if clip = True then putpixel_c(x+q,y+b,col);
  end;
  index := index +1;
  if x = font.letter[num].x then
  begin
   index := index + 10 - x;
   x:=0;
   y:=y+1;
  end;
 until Y = font.letter[num].y+1;
end;
begin
 L:=x;
 for t := 1 to length(text) do
  begin
   c := ORD(text[t]);
   CShowChar(l,y,col,c,clip);
   l:=l+font.letter[c].x +1;
  end;
end;

PROCEDURE SaveSprite(Sprite : SpriteType; Filename : STRING);
VAR
  F : FILE;
  Header : ARRAY[0..3] OF WORD;
BEGIN
  IF Pos('.', Filename) = 0 THEN
    Filename := Filename + '.SPR';
  ASSIGN(F, Filename);
  REWRITE(F, 1);
  IF IOResult <> 0 THEN EXIT;
  Header[0] := Sprite.SType;
  Header[1] := Sprite.Height;
  Header[2] := Sprite.Width;
  Header[3] := Sprite.DataLen;
  BlockWrite(F, Header[0], 8);
  BlockWrite(F, Sprite.Data^, Sprite.DataLen);
  CLOSE(F);
END;

PROCEDURE LoadSprite(VAR Sprite : SpriteType; Filename : STRING);
VAR
  F : FILE;
  Header : ARRAY[0..3] OF WORD;
BEGIN
  IF Sprite.Data <> NIL THEN
    KillSprite(Sprite);
  IF Pos('.', Filename) = 0 THEN
    Filename := Filename + '.SPR';
  ASSIGN(F, Filename);
  RESET(F, 1);
  IF IOResult <> 0 THEN EXIT;
  BlockRead(F, Header[0], 8);
  Sprite.SType   := Header[0];
  Sprite.Height  := Header[1];
  Sprite.Width   := Header[2];
  Sprite.DataLen := Header[3];
  GetMem(Sprite.Data, Sprite.DataLen);
  BlockRead(F, Sprite.Data^, Sprite.DataLen);
  CLOSE(F);
END;

PROCEDURE CopySprite(Source : SpriteType; VAR Dest : SpriteType);
BEGIN
  IF Dest.Data <> NIL THEN
    KillSprite(Dest);
  Dest := Source;
  GetMem(Dest.Data, Dest.DataLen);
  ASM
    push DS
    les DI, Dest
    lds SI, Source.Data
    mov CX, Source.DataLen
    les DI, ES:[DI+SpriteType.Data]
    shr CX, 1
    sbb BX, BX
    shr CX, 1
    db $66; rep movsw
    adc CX, CX
    add CX, CX
    sub CX, BX
    rep movsb
    pop DS
  END;
END;

procedure savepal(var colors:paltype;filename:string);
var
 f:file of paltype;
begin
 assign(f,filename);
 rewrite(f);
 write(f,colors);
 close(f);
end;

procedure loadpal(var colors:paltype;filename:string);
var
 f:file of paltype;
begin
 assign(f,filename);
 reset(f);
 read(f,colors);
 close(f);
end;

procedure line(x, y, x2, y2 : integer;col:byte;clip:boolean);
var
  d, dx, dy,
  ai, bi,
  xi, yi : integer;
begin
  if (x < x2) then
  begin
    xi := 1;
    dx := x2 - x;
  end
  else
  begin
    xi := - 1;
    dx := x - x2;
  end;

  if (y < y2) then
  begin
    yi := 1;
    dy := y2 - y;
  end
  else
  begin
    yi := - 1;
    dy := y - y2;
  end;

  if clip = false then PutPixel(x, y,col);
  if clip = true then PutPixel_c(x, y,col);

  if dx > dy then
  begin
    ai := (dy - dx) * 2;
    bi := dy * 2;
    d  := bi - dx;
    repeat
      if (d >= 0) then
      begin
        inc(y, yi);
        inc(d, ai);
      end
      else
        inc(d, bi);

      inc(x, xi);
  if clip = false then PutPixel(x, y,col);
  if clip = true then PutPixel_c(x, y,col);
    until (x = x2);
  end
  else
  begin
    ai := (dx - dy) * 2;
    bi := dx * 2;
    d  := bi - dy;
    repeat
      if (d >= 0) then
      begin
        inc(x, xi);
        inc(d, ai);
      end
      else
        inc(d, bi);

      inc(y, yi);
    if clip = false then PutPixel(x, y,col);
   if clip = true then PutPixel_c(x, y,col);
    until (y = y2);
  end;
end;

end.