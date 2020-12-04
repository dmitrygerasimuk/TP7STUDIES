{*
*
*   Copyright (c) 1992,93 by Richard W. Hansen
*
*
*}
UNIT Tv3D;
{$B+}
{$X+}
{$V-}

{$I TVDEFS.INC}

INTERFACE


USES
  TvType,
  App, Dialogs, Drivers, Objects, Views;


CONST
  {** 3D Dialog Palette **}
  { 1  = Frame normal }
  { 2  = Frame passive }
  { 3  = Frame icon }
  { 4  = ScrollBar page area }
  { 5  = ScrollBar controls }
  { 6  = StaticText }
  { 7  = Label normal }
  { 8  = Label selected }
  { 9  = Label shortcut }
  { 10 = Button normal }
  { 11 = Button text }
  { 12 = Button disabled text }
  { 13 = Button shortcut text }
  { 14 = Button shaded }
  { 15 = Button default text }
  { 16 = Cluster normal text }
  { 17 = Cluster selected text }
  { 18 = Cluster shortcut }
  { 19 = Inputline normal }
  { 20 = Inputline selected text }
  { 21 = Inputline arrow }
  { 22 = History arrow }
  { 23 = History normal }
  { 24 = HistoryWindow scrollbar page area }
  { 25 = HistoryWindow scrollbar controls }
  { 26 = ListViewer normal }
  { 27 = ListViewer focused }
  { 28 = ListViewer selected }
  { 29 = ListViewer divider }
  { 30 = InfoPane }
  { 31 = Cluster disabled }
  { 32 = Reserved }
  { 33 = Outline normal }
  { 34 = Outline shaded }
  { 35 = History shaded }
  C3DDialog     = #137#139#140#165#166#167#168#169#170#141 +
                  #142#143#144#145#146#152#153#154#149#150 +
                  #151#160#161#163#164#156#157#158#159#171 +
                  #155#000#147#148#162;


  {** 3D Button Palette **}
  { 1 = Button normal }
  { 2 = Button shaded }
  { 3 = Button text }
  { 4 = Button disabled text}
  { 5 = Button shortcut text}
  { 6 = Button default text }
  C3DButton     = #10#14#11#12#13#15;


  {** 3D History Palette **}
  { 1 = History arrow }
  { 2 = History normal }
  { 3 = History shaded }
  C3DHistory    = #22#23#35;


  {** 3D Outline Palette **}
  { 1 = Outline normal }
  { 2 = Outline shaded }
  C3DOutline    = #33#34;

  {** 3D Tool Button Palette **}
  { 1 = Button normal }
  { 2 = Button shaded }
  { 3 = Button text }
  { 4 = Button disabled text}
  { 5 = Button shortcut text}
  { 6 = Button default text }
  C3DToolButton = #10#14#11#12#11#11;


CONST
  ButtonSelect  : TbxFrameArray = 'É»È¼ººÍÍ';
  ButtonNormal  : TbxFrameArray = 'Ú¿ÀÙ³³ÄÄ';
  ButtonPress   : TbxFrameArray = 'Ú¿ÀÙ³³ÄÄ';
  OutlineNormal : TbxFrameArray = 'Ú¿ÀÙ³³ÄÄ';


TYPE
  Pbx3DButton = ^Tbx3DButton;
  Tbx3DButton = Object(TButton)
    Down : Boolean;

    Constructor Init(var Bounds   : TRect;
                         ATitle   : TTitleStr;
                         ACommand : Word;
                         AFlags   : Word);
    Constructor Load(var S: TStream);
    Procedure   Draw;                                     Virtual;
    Procedure   DrawTitle(ATitle: TTitleStr;
                          Color : Word;
                          Row   : Word);                  Virtual;
    Procedure   GetFrame(var F : TbxFrameArray);          Virtual;
    Function    GetPalette: PPalette;                     Virtual;
    Procedure   HandleEvent(var Event : TEvent);          Virtual;
  end;


  Pbx3DOutline  = ^Tbx3DOutline;
  Tbx3DOutline  = Object(TView)
    Constructor Init(var Bounds : TRect);
    Procedure   Draw;                                     Virtual;
    Procedure   GetFrame(var F : TbxFrameArray);          Virtual;
    Function    GetPalette: PPalette;                     Virtual;
  end;


  Pbx3DHistory  = ^Tbx3DHistory;
  Tbx3DHistory  = Object(THistory)
    Constructor Init(var Bounds     : TRect;
                         ALink      : PInputLine;
                         AHistoryId : Word);
    Procedure   Draw;                                     Virtual;
    Function    GetPalette: PPalette;                     Virtual;
  end;


  Pbx3DDialog = ^Tbx3DDialog;
  Tbx3DDialog = Object(TDialog)
    Function    GetPalette: PPalette;                     Virtual;
    Procedure   Insert(P : PView);                        Virtual;
  end;


  Pbx3DToolButton = ^Tbx3DToolButton;
  Tbx3DToolButton = Object(Tbx3DButton)
    Procedure   GetFrame(var F : TbxFrameArray);          Virtual;
    Function    GetPalette: PPalette;                     Virtual;
  end;


  Pbx3DToolBar  = ^Tbx3DToolBar;
  Tbx3DToolBar  = Object(Tbx3DDialog)
    IsVertical  : Boolean;
    LastX       : Word;
    LastY       : Word;

    Constructor Init(var Bounds  : TRect;
                         Vertical: Boolean);
    Constructor Load(var S: TStream);
    Procedure   AddTool(ATitle   : TTitleStr;
                        ACommand : Word);
    Procedure   InitFrame;                                Virtual;
    Procedure   SizeLimits(var Min, Max : TPoint);        Virtual;
    Procedure   Store(var S: TStream);
  end;


{ Tv3D registration procedure }

Procedure RegisterTV3D;

{ Stream Registration Records }

CONST
  Rbx3DButton: TStreamRec = (
    ObjType : 5000;
    VmtLink : Ofs(TypeOf(Tbx3DButton)^);
    Load    : @Tbx3DButton.Load;
    Store   : @Tbx3DButton.Store
  );

CONST
  Rbx3DOutline: TStreamRec = (
    ObjType : 5001;
    VmtLink : Ofs(TypeOf(Tbx3DOutline)^);
    Load    : @Tbx3DOutline.Load;
    Store   : @Tbx3DOutline.Store
  );

CONST
  Rbx3DHistory: TStreamRec = (
    ObjType : 5002;
    VmtLink : Ofs(TypeOf(Tbx3DHistory)^);
    Load    : @Tbx3DHistory.Load;
    Store   : @Tbx3DHistory.Store
  );

CONST
  Rbx3DDialog: TStreamRec = (
    ObjType : 5003;
    VmtLink : Ofs(TypeOf(Tbx3DDialog)^);
    Load    : @Tbx3DDialog.Load;
    Store   : @Tbx3DDialog.Store
  );

CONST
  Rbx3DToolButton: TStreamRec = (
    ObjType : 5004;
    VmtLink : Ofs(TypeOf(Tbx3DToolButton)^);
    Load    : @Tbx3DToolButton.Load;
    Store   : @Tbx3DToolButton.Store
  );

CONST
  Rbx3DToolBar: TStreamRec = (
    ObjType : 5005;
    VmtLink : Ofs(TypeOf(Tbx3DToolBar)^);
    Load    : @Tbx3DToolBar.Load;
    Store   : @Tbx3DToolBar.Store
  );

implementation

constructor Tbx3DButton.Init(var Bounds: TRect; ATitle: TTitleStr;
  ACommand: Word; AFlags: Word);
begin
  inherited Init(Bounds, ATitle, ACommand, AFlags);
  Down := False;
end;

constructor Tbx3DButton.Load(var S: TStream);
begin
  inherited Load(S);
  Down := False;
end;

procedure Tbx3DButton.Draw;
var
  FrameArray: TbxFrameArray;
  Y: Word;
  X: Word;
  Color: Word;
  Color2: Word;
  B: TDrawBuffer;
begin
  GetFrame(FrameArray);
  if (State and sfDisabled <> 0) then Color2 := GetColor($0404)
  else if (State and sfSelected = 0) and AmDefault then
    Color2 := GetColor($0506)
  else if (State and sfSelected <> 0) then Color2 := GetColor($0606) else
    Color2 := GetColor($0503);
  if Down then Color := GetColor($0201) else Color := GetColor($0102);
  X := Size.X - 1;
  MoveChar(B, FrameArray[7], WordRec(Color).Hi, Size.X);
  WordRec(B[X]).Hi := WordRec(Color).Lo;
  WordRec(B[0]).Lo := Byte(FrameArray[1]);
  WordRec(B[X]).Lo := Byte(FrameArray[2]);
  WriteLine(0, 0, Size.X, 1, B);
  MoveChar(B, FrameArray[8], WordRec(Color).Lo, Size.X);
  WordRec(B[0]).Hi := WordRec(Color).Hi;
  WordRec(B[0]).Lo := Byte(FrameArray[3]);
  WordRec(B[X]).Lo := Byte(FrameArray[4]);
  WriteLine(0, Size.Y - 1, Size.X, 1, B);
  MoveChar(B, ' ', WordRec(Color).Hi, Size.X);
  WordRec(B[0]).Lo := Byte(FrameArray[5]);
  WordRec(B[X]).Lo := Byte(FrameArray[6]);
  WordRec(B[X]).Hi := WordRec(Color).Lo;
  for Y := 1 to Size.Y - 2 do WriteLine(0, Y, Size.X, 1, B);
  X := Pos(^M, Title^);
  if (X = 0) then Y := Size.Y div 2 else Y := (Size.Y - 1) div 2;
  if (X = 0) then DrawTitle(Title^, Color2, Y) else
  begin
    DrawTitle(Copy(Title^, 1, X - 1), Color2, Y);
    DrawTitle(Copy(Title^, X + 1, Length(Title^)), Color2, Y + 1);
  end;
end;

procedure Tbx3DButton.DrawTitle(ATitle: TTitleStr; Color: Word; Row: Word);
var
  X: Word;
  L: Word;
  B: TDrawBuffer;
begin
  L := Size.X - 2;
  if (Flags and bfLeftJust <> 0) then X := 0 else
    X := (L - CStrLen(ATitle)) div 2;
  MoveChar(B, ' ', WordRec(Color).Lo, L);
  MoveCStr(B[X], ATitle, Color);
  WriteLine(1, Row, L, 1, B);
end;

procedure Tbx3DButton.GetFrame(var F: TbxFrameArray);
begin
  if Down then F := ButtonPress else
    if (State and sfSelected <> 0) then
      F := ButtonSelect else
      F := ButtonNormal;
end;

function Tbx3DButton.GetPalette: PPalette;
const
  P: string[Length(C3DButton)] = C3DButton;
begin
  GetPalette := @P;
end;

procedure Tbx3DButton.HandleEvent(var Event: TEvent);
var
  R: TRect;
  P: TPoint;
begin
  GetExtent(R);
  if (Event.What = evMouseDown) then
  begin
    MakeLocal(Event.Where, P);
    if not R.Contains(P) then ClearEvent(Event);
    if (Flags and bfGrabFocus <> 0) then TView.HandleEvent(Event);
    if (Event.What = evMouseDown) then
    begin
      Down := False;
      repeat
        MakeLocal(Event.Where, P);
        if (Down <> R.Contains(P)) then
        begin
          Down := not Down;
          Draw;
        end;
      until not MouseEvent(Event, evMouseMove);
      if Down then
      begin
        Down := False;
        Press;
        Draw;
      end;
      ClearEvent(Event);
    end;
  end;
  inherited HandleEvent(Event);
end;

constructor Tbx3DOutline.Init(var Bounds: TRect);
var
  R: TRect;
begin
  R := Bounds;
  R.Grow(1, 1);
  inherited Init(R);
end;

function Tbx3DOutline.GetPalette: PPalette;
const
  P: string[Length(C3DOutline)] = C3DOutline;
begin
  GetPalette := @P;
end;

procedure Tbx3DOutline.GetFrame(var F: TbxFrameArray);
begin
  F := OutlineNormal;
end;

procedure Tbx3DOutline.Draw;
var
  FrameArray: TbxFrameArray;
  Color: Word;
  X: Word;
  Y: Word;
  B: TDrawBuffer;
begin
  GetFrame(FrameArray);
  Color := GetColor($0102);
  X := Size.X - 1;
  MoveChar(B, FrameArray[7], WordRec(Color).Lo, Size.X);
  WordRec(B[X]).Hi := WordRec(Color).Hi;
  WordRec(B[0]).Lo := Byte(FrameArray[1]);
  WordRec(B[X]).Lo := Byte(FrameArray[2]);
  WriteLine(0, 0, Size.X, 1, B);
  MoveChar(B, FrameArray[8], WordRec(Color).Hi, Size.X);
  WordRec(B[0]).Hi := WordRec(Color).Lo;
  WordRec(B[0]).Lo := Byte(FrameArray[3]);
  WordRec(B[X]).Lo := Byte(FrameArray[4]);
  WriteLine(0, Size.Y - 1, Size.X, 1, B);
  for Y := 1 to Size.Y - 2 do
  begin
    WriteChar(0, Y, FrameArray[5], 2, 1);
    WriteChar(X, Y, FrameArray[6], 1, 1);
  end;
end;

constructor Tbx3DHistory.Init(var Bounds: TRect; ALink: PInputLine;
  AHistoryId: Word);
begin
  Bounds.Grow(0, 1);
  inherited Init(Bounds, ALink, AHistoryId);
end;

procedure Tbx3DHistory.Draw;
var
  Color: Word;
  X: Word;
  B: TDrawBuffer;
begin
  X := Size.X - 1;
  Color := GetColor($0203);
  MoveChar(B, ButtonNormal[7], WordRec(Color).Hi, Size.X);
  WordRec(B[X]).Hi := WordRec(Color).Lo;
  WordRec(B[0]).Lo := Byte(ButtonNormal[1]);
  WordRec(B[X]).Lo := Byte(ButtonNormal[2]);
  WriteLine(0, 0, Size.X, 1, B);
  MoveChar(B, ButtonNormal[8], WordRec(Color).Lo, Size.X);
  WordRec(B[0]).Hi := WordRec(Color).Hi;
  WordRec(B[0]).Lo := Byte(ButtonNormal[3]);
  WordRec(B[X]).Lo := Byte(ButtonNormal[4]);
  WriteLine(0, Size.Y - 1, Size.X, 1, B);
  MoveChar(B, ' ', WordRec(Color).Hi, Size.X);
  WordRec(B[0]).Lo := Byte(ButtonNormal[5]);
  WordRec(B[X]).Lo := Byte(ButtonNormal[6]);
  WordRec(B[X]).Hi := WordRec(Color).Lo;
  WordRec(B[1]).Lo := 25;
  Color := GetColor($01);
  WordRec(B[1]).Hi := WordRec(Color).Lo;
  WriteLine(0, 1, Size.X, 1, B);
end;

function Tbx3DHistory.GetPalette: PPalette;
const
  P: string[Length(C3DHistory)] = C3DHistory;
begin
  GetPalette := @P;
end;

function Tbx3DDialog.GetPalette: PPalette;
const
  P: string[Length(C3DDialog)] = C3DDialog;
begin
  GetPalette := @P;
end;

procedure Tbx3DDialog.Insert(P: PView);
var
  R: TRect;
  I: PView;
begin
  if (P^.Options and ofFramed <> 0) then
  begin
    P^.GetBounds(R);
    I := New(Pbx3DOutline, Init(R));
    inherited Insert(I);
  end;
  inherited Insert(P);
end;

procedure Tbx3DToolButton.GetFrame(var F: TbxFrameArray);
begin
  if Down then F := ButtonPress else F := ButtonNormal;
end;

function Tbx3DToolButton.GetPalette: PPalette;
const
  P: string[Length(C3DToolButton)] = C3DToolButton;
begin
  GetPalette := @P;
end;

constructor Tbx3DToolBar.Init(var Bounds: TRect; Vertical: Boolean);
var
  R: TRect;
  P: PView;
begin
  inherited Init(Bounds, '');
  IsVertical := Vertical;
  SetState(sfShadow, False);
  Options := Options and not ofTileable and not ofSelectable or ofFirstClick;
  Flags := Flags and not wfClose;
  GetExtent(R);
  if (Frame <> nil) then
  begin
    LastX := 1;
    LASTY := 1;
    R.Grow(-1, -1);
  end else
  begin
    LastX := 0;
    LastY := 0;
  end;
  P := New(PView, Init(R));
  P^.SetState(sfDisabled, True);
  P^.Options := P^.Options and not ofSelectable;
  P^.GrowMode := P^.GrowMode or gfGrowHiX or gfGrowHiY;
  Insert(P);
end;

constructor Tbx3DToolBar.Load(var S: TStream);
begin
  inherited Load(S);
  S.Read(IsVertical, SizeOf(Boolean));
  S.Read(LastX, SizeOf(Word));
  S.Read(LastY, SizeOf(Word));
end;

procedure Tbx3DToolBar.AddTool(ATitle: TTitleStr; ACommand: Word);
var
  R: TRect;
  B: TRect;
  Width2: Word;
  Width: Word;
  Height: Word;
  LineBreak: Word;
  XX: Word;
  YY: Word;
  SizeX: Word;
  SizeY: Word;
begin
  LineBreak := Pos(^M, ATitle);
  if (LineBreak = 0) then
  begin
    Height := 3;
    Width := CStrLen(ATitle);
  end else
  begin
    Height := 4;
    Width := CStrLen(Copy(ATitle, 1, LineBreak - 1));
    Width2 := CStrLen(Copy(ATitle, LineBreak + 1, Length(ATitle)));
    if (Width2 > Width) then Width := Width2;
  end;
  Width := Width + 2;
  R.A.X := LastX;
  R.A.Y := LastY;
  R.B.X := R.A.X + Width;
  R.B.Y := R.A.Y + Height;
  SizeX := Size.X;
  SizeY := Size.Y;
  if (Frame <> nil) then
  begin
    Dec(SizeX);
    Dec(SizeY);
  end;
  if (R.B.Y > SizeY) then YY := R.B.Y - SizeY else YY := 0;
  if (R.B.X > SizeX) then XX := R.B.X - SizeX else XX := 0;
  GetBounds(B);
  if (YY <> 0) then
  begin
    B.B.Y := B.B.Y + YY;
    if (B.B.Y > Desktop^.Size.Y) then Exit;
  end;
  if (XX <> 0) then
  begin
    B.B.X := B.B.X + XX;
    if (B.B.X > Desktop^.Size.X) then Exit;
  end;
  if (XX <> 0) or (YY <> 0) then
    if (State and sfVisible <> 0) then
      ChangeBounds(B) else
      SetBounds(B);
  Insert(New(Pbx3DToolButton, Init(R, ATitle, ACommand, 0)));
  if IsVertical then LastY := R.B.Y else LastX := R.B.X;
end;

procedure Tbx3DToolBar.InitFrame;
begin
  Frame := nil;
end;

procedure Tbx3DToolBar.SizeLimits(var Min, Max: TPoint);
begin
  Min := Size;
  Max := Size;
end;

procedure Tbx3DToolBar.Store(var S: TStream);
begin
  inherited Store(S);
  S.Write(IsVertical, SizeOf(Boolean));
  S.Write(LastX, SizeOf(Word));
  S.Write(LastY, SizeOf(Word));
end;

procedure RegisterTv3D;
begin
  RegisterType(Rbx3DButton);
  RegisterType(Rbx3DOutline);
  RegisterType(Rbx3DHistory);
  RegisterType(Rbx3DDialog);
  RegisterType(Rbx3DToolButton);
  RegisterType(Rbx3DToolBar);
end;

end.
