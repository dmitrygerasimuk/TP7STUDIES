{*
*
*   Copyright (c) 1992,93 by Richard W. Hansen
*
*
*}
UNIT TvViews;
{$B+}
{$X+}
{$V-}

{$I TVDEFS.INC}

INTERFACE


USES
  TvType, TvConst, TvMenus,
  App, Drivers, Menus, Objects, Views, TextView, Dos;


CONST
  { Position Indicator palette }
  { 1 = Indicator normal }
  { 2 = Indicator passive }
  { 3 = Indicator dragging }
  CPosIndicator   = #2#3;

  { Max/Min button palette }
  { 1 = Button normal }
  { 2 = Button frame normal }
  { 3 = Button dragging }
  CMinMax         = #3#2#3;


TYPE
  PbxFrame = ^TbxFrame;
  TbxFrame = Object(TFrame)
    Procedure   HandleEvent(var Event: TEvent);           Virtual;
  end;


  PbxMinMaxButton = ^TbxMinMaxButton;
  TbxMinMaxButton = Object(TView)
    Constructor Init(var Bounds : TRect);
    Procedure   Draw;                                     Virtual;
    Function    GetPalette: PPalette;                     Virtual;
    Procedure   HandleEvent(var Event : TEvent);          Virtual;
    Procedure   SetState(AState : Word;
                         Enable : Boolean);               Virtual;
  end;


  PbxIcon = ^TbxIcon;
  TbxIcon = Object(TView)
    Title : PString;

    Constructor Init(ATitle : TTitleStr);
    Constructor Load(var S: TStream);
    Destructor  Done;                                     Virtual;
    Procedure   Draw;                                     Virtual;
    Function    GetPalette: PPalette;                     Virtual;
    Procedure   HandleEvent(var Event : TEvent);          Virtual;
    Procedure   SetState(AState : Word;
                         Enable : Boolean);               Virtual;
    Procedure   SizeLimits(var Min, Max : TPoint);        Virtual;
    Procedure   Store(var S: TStream);
  end;


  PbxWindowIcon = ^TbxWindowIcon;
  TbxWindowIcon = Object(TbxIcon)
    View  : PView;

    Constructor Init(ATitle : TTitleStr;
                     AView  : PView);
    Constructor Load(var S: TStream);
    Procedure   ControlMenu(Mouse : Boolean);
    Procedure   HandleEvent(var Event : TEvent);          Virtual;
    Procedure   SetState(AState : Word;
                         Enable : Boolean);               Virtual;
    Procedure   Store(var S: TStream);
  end;


  PbxWindow = ^TbxWindow;
  TbxWindow = Object(TWindow)
    MinMax  : PbxMinMaxButton;
    Icon    : PbxWindowIcon;

    Constructor Init(var Bounds : TRect;
                         ATitle : TTitleStr;
                         ANumber: Integer);
    Constructor Load(var S: TStream);
    Procedure   ControlMenu(Mouse : Boolean);
    Procedure   HandleEvent(var Event : TEvent);          Virtual;
    Procedure   InitFrame;                                Virtual;
    Procedure   InitIcon;                                 Virtual;
    Procedure   SetState(AState : Word;
                         Enable : Boolean);               Virtual;
    Procedure   Store(var S: TStream);
  end;


  PbxTextWindow = ^TbxTextWindow;
  TbxTextWindow = Object(TbxWindow)
    Interior    : PTerminal;
    HScrollBar  : PScrollBar;
    VScrollBar  : PScrollBar;
    Width       : Byte;
    Height      : Byte;

    Constructor Init(Bounds     : TRect;
                     WinTitle   : String;
                     WinNumber  : Word;
                     AOptions   : Word;
                     AMaxLines  : Word
                    );
    Constructor Load(var S: TStream);
    Procedure   Clear;
    Procedure   HandleEvent(var Event : TEvent);          Virtual;
    Procedure   Store(var S: TStream);
    Procedure   Write(St : String);
  end;


  PbxFormattedTextScroller = ^TbxFormattedTextScroller;
  TbxFormattedTextScroller = Object(TScroller)
    Buf     : PbxCharArray;
    BufSize : Word;

    Constructor Init(var Bounds      : TRect;
                         AVScrollBar : PScrollBar;
                         Buff        : PbxCharArray;
                         BuffSize    : Word);
    Constructor Load(var S: TStream);
    Procedure   ChangeBounds(var Bounds: TRect);          Virtual;
    Function    DataSize: Word;                           Virtual;
    Procedure   Draw;                                     Virtual;
    Procedure   GetData(var Rec);                         Virtual;
    Procedure   SetData(var Rec);                         Virtual;
    private
    Procedure   CountLines;
    Procedure   GetNextLine(    First : Word;
                            var Count : Word;
                            var NextCh: Word);
  end;


  PbxPosIndicator = ^TbxPosIndicator;
  TbxPosIndicator = Object(TView)
    Pos : LongInt;

    Constructor Init(var Bounds: TRect);
    Constructor Load(var S: TStream);
    Function    DataSize: Word;                           Virtual;
    Procedure   Draw;                                     Virtual;
    Procedure   GetData(var Rec);                         Virtual;
    Function    GetPalette: PPalette;                     Virtual;
    Procedure   SetState(AState : Word;
                         Enable : Boolean);               Virtual;
    Procedure   SetData(var Rec);                         Virtual;
    Procedure   Store(var S: TStream);
  end;


  PbxMultiScrollBar = ^TbxMultiScrollBar;
  TbxMultiScrollBar = Object(TScrollBar)
    Destructor  Done;                                     Virtual;
    Procedure   SetState(AState : Word;
                         Enable : Boolean);               Virtual;
  end;


  PbxEditBuff = ^TbxEditBuff;
  TbxEditBuff = Object(TScroller)
    Buf       : PbxByteArray;   { pointer to raw data       }
    BufSize   : Word;           { actual buffer size        }
    ItemSize  : Byte;           { display size of each char }

    Constructor Init(Bounds       : TRect;
                     Buff         : Pointer;
                     BuffSize     : Word;
                     ItemWidth    : Byte;
                     AVScrollBar  : PScrollBar);
    Constructor Load(var S: TStream);
    Function    DataSize: Word;                           Virtual;
    Procedure   GetData(var Rec);                         Virtual;
    Function    GetOffset: Word;
    Procedure   GetXY(var Pos : TPoint);
    Procedure   HandleEvent(var Event : TEvent);          Virtual;
    Procedure   SetData(var Rec);                         Virtual;
    Procedure   SetXY(Pos : TPoint);
    Procedure   Store(var S: TStream);
  end;


  PbxAsciiBuff = ^TbxAsciiBuff;
  TbxAsciiBuff = Object(TbxEditBuff)
    Constructor Init(Bounds       : TRect;
                     Buff         : Pointer;
                     BuffSize     : Word;
                     AVScrollBar  : PScrollBar);
    Procedure   Draw;                                     Virtual;
    Procedure   HandleEvent(var Event : TEvent);          Virtual;
  end;


  PbxHexBuff = ^TbxHexBuff;
  TbxHexBuff = Object(TbxEditBuff)
    Constructor Init(Bounds       : TRect;
                     Buff         : Pointer;
                     BuffSize     : Word;
                     AVScrollBar  : PScrollBar);
    Procedure   Draw;                                     Virtual;
    Procedure   HandleEvent(var Event : TEvent);          Virtual;
  end;


  PbxAsciiHexEditor = ^TbxAsciiHexEditor;
  TbxAsciiHexEditor = Object(TbxWindow)
    MaxPos      : Word;                   { highest position edited }
    LView       : PbxEditBuff;            { left side HEX buffer    }
    RView       : PbxEditBuff;            { right side ASCII buffer }
    VScrollBar  : PbxMultiScrollBar;      { vertical scroll bar     }
    Indicator   : PbxPosIndicator;        { byte position indicator }
    Modified    : Boolean;

    Constructor Init(Bounds   : TRect;
                     ATitle   : TTitleStr;
                     ANumber  : Integer;
                     AOptions : Word;
                     Buff     : Pointer;
                     BuffSize : Word);
    Constructor Load(var S: TStream);
    Function    DataSize: Word;                           Virtual;
    Procedure   GetData(var Rec);                         Virtual;
    Procedure   HandleEvent(var Event : TEvent);          Virtual;
    Procedure   SetData(var Rec);                         Virtual;
    Procedure   SetState(AState: Word; Enable: Boolean);  Virtual;
    Procedure   SizeLimits(var Min, Max : TPoint);        Virtual;
    Procedure   Store(var S: TStream);
  end;


  WinData = record
    Device : PTextDevice;
    Filler : Array [1..12] of Char;
  end;


  { Record used by the TbxFormattedTextScroller, TbxEditBuff,
    and TbxASCIIHexEditor SetData methods.
  }
  TbxBufData = record
    Data    : Pointer;
    DataSize: Word;
  end;


{ Redirect output to a PbxTextWindow. Set F to "Output" to redirect all
  Writeln statements to the window.
}
Procedure AssignOutput(var F : Text; AWindow : PbxTextWindow);


{ TvViews registration procedure }

Procedure RegisterTVViews;


{ Stream Registration Records }

CONST
  RbxFrame: TStreamRec = (
    ObjType : 5100;
    VmtLink : Ofs(TypeOf(TbxFrame)^);
    Load    : @TbxFrame.Load;
    Store   : @TbxFrame.Store
  );


CONST
  RbxMinMaxButton: TStreamRec = (
    ObjType : 5101;
    VmtLink : Ofs(TypeOf(TbxMinMaxButton)^);
    Load    : @TbxMinMaxButton.Load;
    Store   : @TbxMinMaxButton.Store
  );

CONST
  RbxIcon: TStreamRec = (
    ObjType : 5102;
    VmtLink : Ofs(TypeOf(TbxIcon)^);
    Load    : @TbxIcon.Load;
    Store   : @TbxIcon.Store
  );

CONST
  RbxWindowIcon: TStreamRec = (
    ObjType : 5103;
    VmtLink : Ofs(TypeOf(TbxWindowIcon)^);
    Load    : @TbxWindowIcon.Load;
    Store   : @TbxWindowIcon.Store
  );

CONST
  RbxWindow: TStreamRec = (
    ObjType : 5104;
    VmtLink : Ofs(TypeOf(TbxWindow)^);
    Load    : @TbxWindow.Load;
    Store   : @TbxWindow.Store
  );

CONST
  RbxTextWindow: TStreamRec = (
    ObjType : 5105;
    VmtLink : Ofs(TypeOf(TbxTextWindow)^);
    Load    : @TbxTextWindow.Load;
    Store   : @TbxTextWindow.Store
  );

CONST
  RbxFormattedTextScroller: TStreamRec = (
    ObjType : 5106;
    VmtLink : Ofs(TypeOf(TbxFormattedTextScroller)^);
    Load    : @TbxFormattedTextScroller.Load;
    Store   : @TbxFormattedTextScroller.Store
  );

CONST
  RbxPosIndicator: TStreamRec = (
    ObjType : 5107;
    VmtLink : Ofs(TypeOf(TbxPosIndicator)^);
    Load    : @TbxPosIndicator.Load;
    Store   : @TbxPosIndicator.Store
  );

CONST
  RbxMultiScrollBar: TStreamRec = (
    ObjType : 5108;
    VmtLink : Ofs(TypeOf(TbxMultiScrollBar)^);
    Load    : @TbxMultiScrollBar.Load;
    Store   : @TbxMultiScrollBar.Store
  );

CONST
  RbxEditBuff: TStreamRec = (
    ObjType : 5109;
    VmtLink : Ofs(TypeOf(TbxEditBuff)^);
    Load    : @TbxEditBuff.Load;
    Store   : @TbxEditBuff.Store
  );

CONST
  RbxAsciiBuff: TStreamRec = (
    ObjType : 5110;
    VmtLink : Ofs(TypeOf(TbxAsciiBuff)^);
    Load    : @TbxAsciiBuff.Load;
    Store   : @TbxAsciiBuff.Store
  );

CONST
  RbxHexBuff: TStreamRec = (
    ObjType : 5111;
    VmtLink : Ofs(TypeOf(TbxHexBuff)^);
    Load    : @TbxHexBuff.Load;
    Store   : @TbxHexBuff.Store
  );

CONST
  RbxAsciiHexEditor: TStreamRec = (
    ObjType : 5112;
    VmtLink : Ofs(TypeOf(TbxAsciiHexEditor)^);
    Load    : @TbxAsciiHexEditor.Load;
    Store   : @TbxAsciiHexEditor.Store
  );

implementation

procedure TbxFrame.HandleEvent(var Event: TEvent);
var
  Mouse: TPoint;
begin
  if (Event.What = evMouseDown) and (State and sfActive <> 0) then
  begin
    MakeLocal(Event.Where, Mouse);
    if (Mouse.Y = 0) then
    begin
      if (PWindow(Owner)^.Flags and wfClose <> 0) and (Mouse.X >= 2)
        and (Mouse.X <= 4) then
      begin
        if (Event.Buttons = mbRightButton) then
        begin
          Event.What := evCommand;
          Event.Command := cmPopMenu;
          Event.InfoPtr := Owner;
          PutEvent(Event);
          ClearEvent(Event);
        end;
      end;
    end;
  end;
  inherited HandleEvent(Event);
end;

constructor TbxMinMaxButton.Init(var Bounds: TRect);
begin
  inherited Init(Bounds);
  GrowMode := GrowMode or gfGrowLoX or gfGrowHiX;
end;

procedure TbxMinMaxButton.Draw;
var
  R: TRect;
begin
  Owner^.GetExtent(R);
  if (PbxWindow(Owner)^.Flags and wfZoom <> 0) then
  begin
    R.B.Y := R.A.Y + 1;
    R.A.X := R.B.X - 8;
    R.B.X := R.A.X + 3;
  end else
  begin
    R.B.Y := R.A.Y + 1;
    R.A.X := R.B.X - 5;
    R.B.X := R.A.X + 3;
  end;
  SetBounds(R);
  if (State and sfDragging <> 0) then WriteStr(0, 0, '[]', 3) else
  begin
    WriteChar(0, 0, '[', 2, 1);
    WriteChar(1, 0, '', 3, 1);
    WriteChar(2, 0, ']', 2, 1);
  end;
end;

function TbxMinMaxButton.GetPalette: PPalette;
const
  P:string[Length(CMinMax)] = CMinMax;
begin
  GetPalette := @P;
end;

procedure TbxMinMaxButton.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);
  if (Event.What = evMouseDown) and GetState(sfActive) then
  begin
    Event.Command := cmMinimize;
    Event.What := evCommand;
    Event.InfoPtr := Owner;
    PutEvent(Event);
    ClearEvent(Event);
  end;
end;

procedure TbxMinMaxButton.SetState(AState: Word; Enable: Boolean);
begin
  inherited SetState(AState, Enable);
  if (AState and (sfActive or sfDragging) <> 0) then DrawView;
end;

constructor TbxIcon.Init(ATitle: TTitleStr);
var
  R: TRect;
  X: Word;
  Y: Word;
  P: Word;
  T: string;
begin
  if (ATitle[1] = ^C) then T := Copy(ATitle, 2, Length(ATitle)) else T := ATitle;
  P := Pos(^M, T);
  X := 0;
  Y := 0;
  while (P <> 0) do
  begin
    Inc(Y);
    if (P - 1 > X) then X := P - 1;
    T := Copy(T, P + 1, Length(T));
    P := Pos(^M, T);
  end;
  if (T <> '') then
  begin
    Inc(Y);
    if (Length(T) > X) then X := Length(T);
  end;
  Desktop^.GetExtent(R);
  Inc(R.A.X, 2);
  Dec(R.B.Y, 1);
  R.A.Y := R.B.Y - Y;
  R.B.X := R.A.X + X;
  inherited Init(R);
  Title := NewStr(ATitle);
  Options := Options or ofSelectable or ofTopSelect;
end;

constructor TbxIcon.Load(var S: TStream);
begin
  inherited Load(S);
  Title := S.ReadStr;
end;

destructor TbxIcon.Done ;
begin
  DisposeStr(Title);
  inherited Done;
end;

procedure TbxIcon.Draw;
var
  B: TDrawBuffer;
  Color: Word;
  P: Word;
  Y: Word;
  X: Word;
  Centered: Boolean;
  T: string;
  S: string;
begin
  if State and sfDragging <> 0 then Color := 3
  else if State and sfSelected =0 then Color := 1
  else Color := 2;
  Color := GetColor(Color);
  Centered := (Title^[1] = ^C);
  if Centered then T := Copy(Title^, 2, Length(Title^)) else T := Title^;
  P := Pos(^M, T);
  Y := 0;
  while (P <> 0) do
  begin
    MoveChar(B, ' ', Color, Size.X);
    S := Copy(T, 1, P - 1);
    if Centered then X := ((Size.X - Length(S)) shr 1) else X := 0;
    MoveStr(B[X], S, Color);
    WriteLine(0, Y, Size.X, 1, B);
    Inc(Y);
    T := Copy(T, P + 1, Length(T));
    P := Pos(^M, T);
  end;
  if (T <> '') then
  begin
    MoveChar(B, ' ', Color, Size.X);
    if Centered then X := ((Size.X - Length(T)) shr 1) else X := 0;
    MoveStr(B[X], T, Color);
    WriteLine(0, Y, Size.X, 1, B);
  end;
end;

function TbxIcon.GetPalette: PPalette;
const
  Palette: string[Length(CGrayWindow)] = CGrayWindow;
begin
  GetPalette := @Palette;
end;

procedure TbxIcon.HandleEvent(var Event: TEvent);
var
  Limits: TRect;
begin
  inherited HandleEvent(Event);
  case Event.What of
    evCommand:
      case Event.Command of
        cmResize:
          begin
            Owner^.GetExtent(Limits);
            DragView(Event, dmDragMove, Limits, Size, Size);
            ClearEvent(Event);
          end;
      end;
    evMouseDown:
      begin
        Owner^.GetExtent(Limits);
        DragView(Event, dmDragMove, Limits, Size, Size);
        ClearEvent(Event);
      end;
  end;
end;

procedure TbxIcon.SetState(AState: Word; Enable: Boolean);
begin
  inherited SetState(AState, Enable);
  if (AState and (sfSelected or sfFocused) <> 0)
    or (AState and (sfActive or sfDragging) <> 0) then DrawView;
end;

procedure TbxIcon.SizeLimits(var Min, Max: TPoint);
begin
  Min.X := Size.X;
  Min.Y := Size.Y;
  Max.X := Size.X;
  Max.Y := Size.Y;
end;

procedure TbxIcon.Store(var S: TStream);
begin
  inherited Store(S);
  S.WriteStr(Title);
end;

constructor TbxWindowIcon.Init(ATitle: TTitleStr; AView: PView);
begin
  inherited Init(ATitle);
  View := AView;
end;

constructor TbxWindowIcon.Load(var S: TStream);
begin
  inherited Load(S);
  GetPeerViewPtr(S, View);
end;

procedure TbxWindowIcon.ControlMenu(Mouse: Boolean);
var
  R: TRect;
  P: PMenuBox;
  Event: TEvent;
begin
  if Mouse then R.Assign(0, 0, 14, 12) else
    R.Assign(Origin.X, Origin.Y, Origin.X + 14, Origin.Y + 11);
  P := New(PMenuBox, Init(R, NewMenu(
    NewItem('~C~lose', '', kbNoKey, cmClose, hcNoContext,
    NewItem('~M~aximize', '', kbNoKey, cmMaximize, hcNoContext,
    NewItem('~P~revious', '', kbNoKey, cmPrev, hcNoContext,
    NewItem('~N~ext', '', kbNoKey, cmNext ,hcNoContext,
    NewItem('Mo~v~e', '', kbNoKey, cmResize, hcNoContext, nil)))))), nil));
  if Mouse then Event.Command := MousePopupMenu(P) else
    Event.Command := PopupMenu(P);
  DisposeMenu(P^.Menu);
  Dispose(P);
  if (Event.Command <> 0) then
  begin
    Event.What := evCommand;
    Event.InfoPtr := @Self;
    PutEvent(Event);
  end;
end;

procedure TbxWindowIcon.HandleEvent(var Event: TEvent);
var
  R: TRect;
begin
  case Event.What of
    evKeyDown:
      case Event.KeyCode of
        kbAltMinus:
          begin
            ControlMenu(False);
            ClearEvent(Event);
          end;
      end;
    evCommand:
      case Event.Command of
        cmMaximize:
          begin
            View^.Show;
            View^.Select;
            Hide;
            ClearEvent(Event);
          end;
        cmClose:
          begin
            if (Event.InfoPtr = nil) or (Event.InfoPtr = @Self) then
              Message(View, evCommand, cmClose, @Self);
              if (Event.InfoPtr = nil) or (Event.InfoPtr = @Self)
                or (Event.InfoPtr = View) then
              begin
                Free;
                ClearEvent(Event);
              end;
          end;
      end;
    evMouseDown:
      begin
        if Event.Double then
        begin
          View^.Show;
          View^.Select;
          Hide;
          ClearEvent(Event);
        end else if (Event.Buttons = mbRightButton) then
        begin
          ControlMenu(True);
          ClearEvent(Event);
        end
      end;
  end;
  inherited HandleEvent(Event);
end;

procedure TbxWindowIcon.SetState(AState: Word; Enable: Boolean);
var
  C: TCommandSet;
begin
  inherited SetState(AState, Enable);
  if (AState and sfSelected <> 0) then
    EnableCommands([cmClose, cmMinimize, cmResize, cmNext, cmPrev]);
end;

procedure TbxWindowIcon.Store(var S: TStream);
begin
  inherited Store(S);
  PutPeerViewPtr(S, View);
end;

constructor TbxWindow.Init(var Bounds: TRect; ATitle: TTitleStr;
  ANumber: Integer);
var
  R: TRect;
  Dummy: TPoint;
begin
  inherited Init(Bounds, ATitle, wnNoNumber);
  GetExtent(R);
  R.B.Y := R.A.Y + 1;
  R.A.X := R.B.X - 8;
  R.B.X := R.A.X + 3;
  MinMax := New(PbxMinMaxButton, Init(R));
  Insert(MinMax);
  InitIcon;
  if (Icon <> nil) then
  begin
    Icon^.SetState(sfVisible, False);
    Desktop^.Insert(Icon);
  end;
end;

constructor TbxWindow.Load(var S: TStream);
begin
  inherited Load(S);
  GetSubViewPtr(S, MinMax);
  GetPeerViewPtr(S, Icon);
end;

procedure TbxWindow.ControlMenu(Mouse: Boolean);
var
  R: TRect;
  P: PMenuBox;
  Event: TEvent;
begin
  if Mouse then R.Assign(0, 0, 14, 12) else
    R.Assign(Origin.X, Origin.Y, Origin.X + 14, Origin.Y + 11);
  P := New(PMenuBox, Init(R, NewMenu(
    NewItem('~C~lose', '', kbNoKey, cmClose, hcNoContext,
    NewItem('~Z~oom', '', kbNoKey, cmZoom, hcNoContext,
    NewItem('~M~inimize', '', kbNoKey, cmMinimize, hcNoContext,
    NewItem('~P~revious', '', kbNoKey, cmPrev, hcNoContext,
    NewItem('~N~ext', '', kbNoKey, cmNext, hcNoContext,
    NewItem('~R~esize/move', '', kbNoKey, cmResize, hcNoContext,
    NewItem('~T~ile', '', kbNoKey, cmTile, hcNoContext,
    NewItem('C~a~scade', '', kbNoKey, cmCascade, hcNoContext, nil))))))))), nil));
  if Mouse then Event.Command := MousePopupMenu(P) else
    Event.Command := PopupMenu(P);
  DisposeMenu(P^.Menu);
  Dispose(P);
  if (Event.Command <> 0) then
  begin
    Event.What := evCommand;
    Event.InfoPtr := @Self;
    PutEvent(Event);
  end;
end;

procedure TbxWindow.HandleEvent(var Event: TEvent);
var
  R: TRect;
begin
  case Event.What of
    evKeyDown:
      case Event.KeyCode of
        kbAltMinus:
          begin
            ControlMenu(False);
            ClearEvent(Event);
          end;
      end;
    evCommand:
      case Event.Command of
        cmMinimize:
          begin
            if (Icon <> nil) then
            begin
              Icon^.Show;
              Icon^.Select;
              Hide;
            end;
            ClearEvent(Event);
          end;
        cmClose:
          begin
            if (Icon <> nil) then
            begin
              if (Event.InfoPtr = nil) or (Event.InfoPtr = @Self) then
                Message(Icon, evCommand, cmClose, @Self)
              else if (Event.InfoPtr = Icon) then Event.InfoPtr := @Self;
            end;
          end;
        cmPopMenu:
          begin
            ControlMenu(True);
            ClearEvent(Event);
          end;
      end;
  end;
  inherited HandleEvent(Event);
end;

procedure TbxWindow.InitFrame;
var
  R: TRect;
begin
  GetExtent(R);
  Frame := New(PbxFrame, Init(R));
end;

procedure TbxWindow.InitIcon;
var
  R: TRect;
begin
  Icon := New(PbxWindowIcon, Init(Title^, @Self));
end;

procedure TbxWindow.SetState(AState: Word; Enable: Boolean);
begin
  inherited SetState(AState, Enable);
  if (AState = sfActive) then case Enable of
    True:
      MinMax^.Show;
    False:
      MinMax^.Hide;
  end;
  if (AState and sfSelected <> 0) then EnableCommands([cmMinimize]);
end;

procedure TbxWindow.Store(var S: TStream);
begin
  inherited Store(S);
  PutSubViewPtr(S, MinMax);
  PutPeerViewPtr(S, Icon);
end;

constructor TbxTextWindow.Init(Bounds: TRect; WinTitle: string;
  WinNumber: Word; AOptions: Word; AMaxLines: Word);
var
  R: TRect;
begin
  TbxWindow.Init(Bounds, WinTitle, WinNumber);
  HScrollBar := nil;
  VScrollBar := nil;
  Desktop^.GetExtent(R);
  Width := R.B.X;
  Height := AMaxLines;
  if (Height = 0) then Height := R.B.Y;
  if ((AOptions and ofHScrollBar) <> 0) then
  begin
    HScrollBar := StandardScrollBar(sbHorizontal + sbHandleKeyboard);
    Insert(HScrollBar);
  end;
  if ((AOptions and ofVScrollBar) <> 0) then
  begin
    VScrollBar := StandardScrollBar(sbVertical + sbHandleKeyboard);
    Insert(VScrollBar);
  end;
  GetExtent(Bounds);
  Bounds.Grow(-1, -1);
  Interior := New(PTerminal, Init(Bounds, HScrollBar, VScrollBar, Width * Height));
  Insert(Interior);
end;

constructor TbxTextWindow.Load(var S: TStream);
begin
  inherited Load(S);
  GetSubViewPtr(S, Interior);
  GetSubViewPtr(S, HScrollBar);
  GetSubViewPtr(S, VScrollBar);
  S.Read(Width, SizeOf(Byte));
  S.Read(Height, SizeOf(Byte));
end;

procedure TbxTextWindow.Clear;
begin
  Interior^.QueFront := 0;
  Interior^.QueBack := 0;
  Interior^.SetLimit(0, 1);
  Interior^.SetCursor(0, 0);
  Interior^.ShowCursor;
  Interior^.DrawView;
end;

procedure TbxTextWindow.HandleEvent(var Event: TEvent);
begin
  if (Event.What = evBroadcast) then case Event.Command of
    cmDisplayStr:
      Write(PString(Event.InfoPtr)^);
    cmDisplayClr:
      Clear;
  end;
  inherited HandleEvent(Event);
end;

procedure TbxTextWindow.Store(var S: TStream);
begin
  inherited Store(S);
  PutSubViewPtr(S, Interior);
  PutSubViewPtr(S, HScrollBar);
  PutSubViewPtr(S, VScrollBar);
  S.Write(Width, SizeOf(Byte));
  S.Write(Height, SizeOf(Byte));
end;

procedure TbxTextWindow.Write(St: string);
var
  T: TextBuf;
  X: Byte;
  I: Byte;
begin
  I := 0;
  repeat
    X := 0;
    while (X < SizeOf(TextBuf) - 2) and (X < Width) and (I < Byte(St[0])) do
    begin
      Inc(I);
      T[X] := St[I];
      Inc(X);
    end;
    T[X] := #13;
    Inc(X);
    T[X] := #10;
    Inc(X);
    Interior^.StrWrite(T,X);
  until (I >= Byte(St[0]));
end;

constructor TbxFormattedTextScroller.Init(var Bounds: TRect;
  AVScrollBar: PScrollBar; Buff: PbxCharArray; BuffSize: Word);
begin
  inherited Init(Bounds, nil, AVScrollBar);
  Buf := Buff;
  BufSize := BuffSize;
  GrowMode := gfGrowHiX or gfGrowHiY;
  CountLines;
end;

constructor TbxFormattedTextScroller.Load(var S: TStream);
begin
  inherited Load(S);
  Buf := nil;
  BufSize := 0;
end;

procedure TbxFormattedTextScroller.ChangeBounds(var Bounds: TRect);
begin
  TScroller.ChangeBounds(Bounds);
  CountLines;
end;
procedure TbxFormattedTextScroller.CountLines;
var
  First: Word;
  Count: Word;
  NextCh: Word;
  Y: Word;
begin
  Y := 1;
  First := 0;
  while (First < BufSize) do
  begin
    GetNextLine(First, Count, NextCh);
    First := NextCh;
    Inc(Y);
  end;
  if Y <> Limit.Y then SetLimit(Size.X, Y);
end;

function TbxFormattedTextScroller.DataSize: Word;
begin
  DataSize := SizeOf(TbxBufData);
end;

procedure TbxFormattedTextScroller.Draw;
var
  First: Word;
  Count: Word;
  NextCh: Word;
  Y: Word;
  B: TDrawBuffer;
  Color: Byte;
begin
  Color := GetColor(1);
  First := 0;
  Y := 0;
  while (Y < Delta.Y - 1) do
  begin
    GetNextLine(First, Count, NextCh);
    First := NextCh;
    Inc(Y);
  end;
  Y := 0;
  while (Y < Size.Y) do
  begin
    MoveChar(B, ' ', Color, Size.X);
    GetNextLine(First, Count, NextCh);
    MoveBuf(B, Buf^[First], Color, Count);
    WriteLine(0, Y, Size.X, 1, B);
    First := NextCh;
    Inc(Y);
  end;
end;

procedure TbxFormattedTextScroller.GetData(var Rec);
begin
  with TbxBufData(Rec) do
  begin
    Data := Buf;
    DataSize := BufSize;
  end;
end;

procedure TbxFormattedTextScroller.GetNextLine(First: Word; var Count: Word;
  var NextCh:Word);
var
  I: Word;
begin
  Count := 0;
  if (First >= BufSize) then Exit;
  I := First;
  if (First + Size.X > BufSize) then NextCh := BufSize else
    NextCh := First + Size.X;
  while (I < NextCh) and (Buf^[I] <> #13) do Inc (I);
  if (Buf^[I] = #13) then
  begin
    NextCh := I;
    if (NextCh < BufSize) and (Buf^[NextCh+1] = #10) then Inc(NextCh);
  end else
  begin
    while (I > First) and (Buf^[I] <> ' ') do Dec(I);
    if (I = First) then I := NextCh else NextCh := I;
  end;
  if (NextCh < BufSize) then Inc(NextCh);
  Count := I - First;
end;

procedure TbxFormattedTextScroller.SetData(var Rec);
begin
  with TbxBufData(Rec) do
  begin
    Buf := Data;
    BufSize := DataSize;
  end;
  ScrollTo(0, 0);
  CountLines;
end;

constructor TbxPosIndicator.Init(var Bounds: TRect);
begin
  inherited Init(Bounds);
  GrowMode := gfGrowLoY or gfGrowHiY;
  Pos := 1;
end;

constructor TbxPosIndicator.Load(var S: TStream);
begin
  inherited Load(S);
  S.Read(Pos, SizeOf(Longint));
end;

function TbxPosIndicator.DataSize: Word;
begin
  DataSize := SizeOf(Longint);
end;

procedure TbxPosIndicator.Draw;
var
  Color: Word;
  Frame: Char;
  SPos: string[12];
  B: TDrawBuffer;
begin
  if (State and sfDragging = 0) then
  begin
    Color := GetColor(1);
    Frame := #205;
  end else
  begin
    Color := GetColor(2);
    Frame := #196;
  end;
  Str(Pos, SPos);
  MoveChar(B, Frame, Color, Size.X);
  MoveStr(B, ' Pos : ' + SPos + ' ', Color);
  WriteBuf(0, 0, Size.X, 1, B);
end;

procedure TbxPosIndicator.GetData(var Rec);
begin
  Longint(Rec) := Pos;
end;

function TbxPosIndicator.GetPalette: PPalette;
const
  P: string[Length(CPosIndicator)] = CPosIndicator;
begin
  GetPalette := @P;
end;

procedure TbxPosIndicator.SetData(var Rec);
begin
  if (Pos <> Longint(Rec)) then
  begin
    Pos := Longint(Rec);
    DrawView;
  end;
end;

procedure TbxPosIndicator.SetState(AState: Word; Enable: Boolean);
begin
  inherited SetState(AState, Enable);
  if (AState = sfDragging) then DrawView;
end;

procedure TbxPosIndicator.Store(var S: TStream);
begin
  inherited Store(S);
  S.Write(Pos, SizeOf(Longint));
end;

destructor TbxMultiScrollBar.Done;
begin
  inherited SetState(sfVisible, False);
  inherited Done;
end;

procedure TbxMultiScrollBar.SetState(AState: Word; Enable: Boolean);
begin
  if (AState = sfVisible) and not Enable then Exit;
  inherited SetState(AState, Enable);
end;

constructor TbxEditBuff.Init(Bounds: TRect; Buff: Pointer; BuffSize: Word;
  ItemWidth: Byte; AVScrollBar: PScrollBar);
var
  NumCols: Word;
begin
  inherited Init(Bounds, nil, AVScrollBar);
  Options := Options or ofFramed;
  Buf := Buff;
  BufSize := BuffSize;
  ItemSize := ItemWidth;
  ShowCursor;
  BlockCursor;
  NumCols := (BufSize * ItemSize) div Size.X;
  if ((BufSize * ItemSize) mod Size.X <> 0) then Inc(NumCols);
  SetLimit(Size.X, NumCols);
end;

constructor TbxEditBuff.Load(var S: TStream);
begin
  inherited Load(S);
  S.Read(ItemSize, SizeOf(Byte));
  Buf := nil;
  BufSize := 0;
end;

function TbxEditBuff.DataSize: Word;
begin
  DataSize := SizeOf(TbxBufData);
end;

procedure TbxEditBuff.GetData(var Rec);
begin
  with TbxBufData(Rec) do
  begin
    Data := Buf;
    DataSize := BufSize;
  end;
end;

function TbxEditBuff.GetOffset: Word;
begin
  GetOffset := Word((Longint(Delta.Y * Size.X) + Longint(Cursor.Y * Size.X) +
    Cursor.X) div ItemSize);
end;

procedure TbxEditBuff.GetXY(var Pos: TPoint);
begin
  Pos.X := Cursor.X div ItemSize;
  Pos.Y := Cursor.Y;
end;

procedure TbxEditBuff.HandleEvent(var Event: TEvent);
var
  NewCursor: TPoint;
  Y: Integer;
begin
  case Event.What of
    evBroadcast:
      begin
        case Event.Command of
          cmScrollBarChanged:
            begin
              if (VScrollBar^.Value <> Delta.Y) then
              begin
                NewCursor := Cursor;
                inherited HandleEvent(Event);
                SetCursor(NewCursor.X, NewCursor.Y);
                Message(Owner, evBroadcast, cmCursorMoved, @Self);
              end;
            end;
        end;
      end;
    evKeyDown:
      begin
        case Event.KeyCode of
          kbUp:
            begin
              Y := Cursor.Y - 1;
              if (Y < 0) then ScrollTo(0, Delta.Y - 1) else
                SetCursor(Cursor.X, Y);
              Message(Owner, evBroadcast, cmCursorMoved, @Self);
            end;
          kbPgUp:
            begin
              if (Delta.Y - Size.Y >= 0) then
              begin
                ScrollTo(0, Delta.Y - Size.Y);
              end else
              begin
                ScrollTo(0, 0);
                SetCursor(Cursor.X, 0);
              end;
              Message(Owner, evBroadcast, cmCursorMoved, @Self);
            end;
          kbLeft:
            begin
              if (Cursor.X > 0) then
              begin
                SetCursor(Cursor.X - 1, Cursor.Y);
              end else if (Cursor.Y > 0) then
              begin
                SetCursor(Size.X - 1, Cursor.Y - 1);
              end else if (Delta.Y > 0) then
              begin
                ScrollTo(0, Delta.Y - 1);
                SetCursor(Size.X - 1, 0);
              end;
              Message(Owner, evBroadcast, cmCursorMoved, @Self);
            end;
          kbRight:
            begin
              if (Cursor.X + 1 < Size.X) then
              begin
                SetCursor(Cursor.X + 1, Cursor.Y);
              end else if (Cursor.Y + 1 < Size.Y) then
              begin
                SetCursor(0, Cursor.Y + 1);
              end else if (Delta.Y + Size.Y < Limit.Y) then
              begin
                ScrollTo(0, Delta.Y + 1);
                SetCursor(0, Size.Y - 1);
              end;
              Message(Owner, evBroadcast, cmCursorMoved, @Self);
            end;
          kbDown:
            begin
              Y := Cursor.Y + 1;
              if (Y = Size.Y) then ScrollTo(0, Delta.Y + 1) else
                SetCursor(Cursor.X, Y);
              Message(Owner, evBroadcast, cmCursorMoved, @Self);
            end;
          kbPgDn:
            begin
              if (Delta.Y + Size.Y < Limit.Y) then
              begin
                ScrollTo(0, Delta.Y + Size.Y);
              end else
              begin
                ScrollTo(0, Limit.Y);
                SetCursor(Cursor.X, Size.Y - 1);
              end;
              Message(Owner, evBroadcast, cmCursorMoved, @Self);
            end;
          kbCtrlPgDn:
            begin
              ScrollTo(0, Limit.Y);
              SetCursor(Size.X - 1, Size.Y - 1);
              Message(Owner, evBroadcast, cmCursorMoved, @Self);
            end;
          kbCtrlPgUp:
            begin
              ScrollTo(0, 0);
              SetCursor(0, 0);
              Message(Owner, evBroadcast, cmCursorMoved, @Self);
            end;
        end;
      end;
    evMouseDown:
      begin
        if MouseInView(Event.Where) then
        begin
          MakeLocal(Event.Where, NewCursor);
          SetCursor(NewCursor.X, NewCursor.Y);
          Message(Owner, evBroadcast, cmCursorMoved, @Self);
        end;
      end;
  end;
  inherited HandleEvent(Event);
end;

procedure TbxEditBuff.SetXY(Pos: TPoint);
begin
  SetCursor(Pos.X * ItemSize, Pos.Y);
end;

procedure TbxEditBuff.SetData(var Rec);
var
  NumCols: Word;
begin
  with TbxBufData(Rec) do
  begin
    Buf := Data;
    BufSize := DataSize;
    NumCols := (BufSize * ItemSize) div Size.X;
  end;
  if ((BufSize * ItemSize) mod Size.X <> 0) then Inc(NumCols);
  SetLimit(Size.X, NumCols);
  ScrollTo(0, 0);
end;

procedure TbxEditBuff.Store(var S: TStream);
begin
  inherited Store(S);
  S.Write(ItemSize, SizeOf(Byte));
end;

constructor TbxAsciiBuff.Init(Bounds: TRect; Buff: Pointer; BuffSize: Word;
  AVScrollBar: PScrollBar);
begin
  inherited Init(Bounds, Buff, BuffSize, 1, AVScrollBar);
end;

procedure TbxAsciiBuff.HandleEvent(var Event: TEvent);
var
  X: Word;
begin
  inherited HandleEvent(Event);
  if (Event.What = evKeyDown) then
  begin
    case Event.CharCode of
      #1..#8, #10..#255:
        begin
          X := GetOffset;
          if (X < BufSize) then
          begin
            Buf^[X] := Byte(Event.CharCode);
            Message(Owner, evBroadcast, cmUpdateView, @Self);
            Message(Owner, evBroadcast, cmEditView, @Self);
            Message(Owner, evKeyDown, kbRight, @Self);
            ClearEvent(Event);
          end;
        end;
    end;
  end;
end;

procedure TbxAsciiBuff.Draw;
var
  Color: Byte;
  I: Word;
  J: Word;
  First: Word;
  Last: Word;
  B: array[1..4096] of Byte;
begin
  Color := GetColor(1);
  First := Delta.Y * Size.X;
  Last := First + (Size.Y * Size.X) - 1;
  if (Last >= BufSize) then Last := BufSize - 1;
  MoveChar(B, '.', Color, (Size.Y * Size.X));
  J := 1;
  for I := First to Last do
  begin
    B[J] := Buf^[I];
    Inc(J);
    Inc(J);
  end;
  WriteBuf(0, 0, Size.X, Size.Y, B);
end;

constructor TbxHexBuff.Init(Bounds: TRect; Buff: Pointer; BuffSize: Word;
  AVScrollBar: PScrollBar);
begin
  inherited Init(Bounds, Buff, BuffSize, 2, AVScrollBar);
end;

procedure TbxHexBuff.Draw;
const
  HexDigits: array[0..$F] of Char = '0123456789ABCDEF';
var
  Color: Byte;
  I: Word;
  J: Word;
  First: Word;
  Last: Word;
  B: array[1..4096] of Byte;
  Width: Word;
begin
  Width := Size.X div 2;
  Color := GetColor(1);
  First := Delta.Y * Width;
  Last := First + (Size.Y * Width) - 1;
  if (Last >= BufSize) then Last := BufSize - 1;
  MoveChar(B, '.', Color, (Size.Y * Size.X));
  J := 1;
  for I := First to Last do
  begin
    B[J] := Byte(HexDigits[Buf^[I] shr 4]);
    Inc(J);
    Inc(J);
    B[J] := Byte(HexDigits[Buf^[I] and $F]);
    Inc(J);
    Inc(J);
  end;
  WriteBuf(0, 0, Size.X, Size.Y, B);
end;

procedure TbxHexBuff.HandleEvent(var Event: TEvent);
var
  I: Byte;
  C: Integer;
  X: Word;
begin
  inherited HandleEvent(Event);
  if (Event.What = evKeyDown) then
  begin
    case Event.CharCode of
      '0'..'9', 'a'..'f', 'A'..'F':
        begin
          X := GetOffset;
          if (X < BufSize) then
          begin
            Val('$' + Event.CharCode, I, C);
            if ((Cursor.X mod 2) = 0) then
              Buf^[X] := (Buf^[X] and $0F) or (I shl 4) else
              Buf^[X] := (Buf^[X] and $F0) or I;
            Message(Owner, evBroadcast, cmUpdateView, @Self);
            Message(Owner, evBroadcast, cmEditView, @Self);
            Message(Owner, evKeyDown, kbRight, @Self);
            ClearEvent(Event);
          end;
        end;
    end;
  end;
end;

constructor TbxAsciiHexEditor.Init(Bounds: TRect; ATitle: TTitleStr;
  ANumber: Integer; AOptions: Word; Buff: Pointer; BuffSize: Word);
var
  Width: Word;
  ByteCount: Word;
begin
  Width := Bounds.B.X - Bounds.A.X - 3;
  ByteCount := (Width div 3);
  Width := ByteCount * 3;
  Bounds.B.X := Width + Bounds.A.X + 3;
  inherited Init(Bounds, ATitle, ANumber);
  Modified := False;
  GetExtent(Bounds);
  Bounds.Assign(Bounds.B.X - 1, Bounds.A.Y + 1, Bounds.B.X, Bounds.B.Y - 1);
  VScrollBar := New(PbxMultiScrollBar, Init(Bounds));
  VScrollBar^.GrowMode := gfGrowHiY;
  Insert(VScrollBar);
  GetExtent(Bounds);
  Bounds.Grow(-1, -1);
  Bounds.B.X := Bounds.A.X + (2 * ByteCount);
  LView := New(PbxHexBuff, Init(Bounds, Buff, BuffSize, VScrollBar));
  LView^.GrowMode := gfGrowHiY;
  Insert(LView);
  GetExtent(Bounds);
  Bounds.Grow(-1, -1);
  Bounds.A.X := Bounds.B.X - ByteCount;
  RView := New(PbxAsciiBuff, Init(Bounds, Buff, BuffSize, VScrollBar));
  RView^.GrowMode := gfGrowHiY;
  Insert(RView);
  if ((AOptions and ofPosIndicator) <> 0) then
  begin
    Bounds.Assign(2, Size.Y - 1, 15, Size.Y);
    Indicator := New(PbxPosIndicator, Init(Bounds));
    Insert(Indicator);
    Indicator^.Hide;
  end;
end;

constructor TbxAsciiHexEditor.Load(var S: TStream);
begin
  inherited Load(S);
  GetSubViewPtr(S, LView);
  GetSubViewPtr(S, RView);
  GetSubViewPtr(S, VScrollBar);
  GetSubViewPtr(S, Indicator);
  Modified := False;
  MaxPos := 0;
end;

function TbxAsciiHexEditor.DataSize: Word;
begin
  DataSize := LView^.DataSize;
end;

procedure TbxAsciiHexEditor.GetData(var Rec);
begin
  LView^.GetData(Rec);
end;

procedure TbxAsciiHexEditor.HandleEvent(var Event: TEvent);
var
  NewCursor: TPoint;
  Offset: Word;
begin
  if (Event.What = evBroadcast) then
  begin
    case Event.Command of
      cmUpdateView:
        begin
          Redraw;
          ClearEvent(Event);
          Exit;
        end;
      cmEditView:
        begin
          if (Event.InfoPtr = LView) then Offset := LView^.GetOffset
          else if (Event.InfoPtr = RView) then Offset := RView^.GetOffset;
          Inc(Offset);
          if (Offset > MaxPos) then MaxPos := Offset;
          ClearEvent(Event);
          Modified := True;
          Exit;
        end;
      cmCursorMoved:
        begin
          if (Event.InfoPtr = LView) then
          begin
            if (Indicator <> nil) then
            begin
              Offset := LView^.GetOffset;
              Inc(Offset);
              Indicator^.SetData(Offset);
              Indicator^.DrawView;
            end;
            LView^.GetXY(NewCursor);
            RView^.SetXY(NewCursor);
            ClearEvent(Event);
            Exit;
          end else if (Event.InfoPtr = RView) then
          begin
            if (Indicator <> nil) then
            begin
              Offset := RView^.GetOffset;
              Inc(Offset);
              Indicator^.SetData(Offset);
              Indicator^.DrawView;
            end;
            RView^.GetXY(NewCursor);
            LView^.SetXY(NewCursor);
            ClearEvent(Event);
            Exit;
          end;
        end;
    end;
  end;
  inherited HandleEvent(Event);
end;

procedure TbxAsciiHexEditor.SetData(var Rec);
var
  L: Longint;
begin
  LView^.SetData(Rec);
  RView^.SetData(Rec);
  Modified := False;
  MaxPos := 0;
  if (Indicator <> nil) then
  begin
    L := 0;
    Indicator^.SetData(L);
  end;
end;

procedure TbxAsciiHexEditor.SetState(AState: Word; Enable: Boolean);
begin
  inherited SetState(AState, Enable);
  case AState of
    sfActive:
      begin
        if (Indicator <> nil) then Indicator^.SetState(sfVisible, Enable);
      end;
  end;
end;

procedure TbxAsciiHexEditor.SizeLimits(var Min, Max: TPoint);
begin
  inherited SizeLimits(Min, Max);
  Min.X := Size.X;
  Max.X := Size.X;
end;

procedure TbxAsciiHexEditor.Store(var S: TStream);
begin
  inherited Store(S);
  PutSubViewPtr(S, LView);
  PutSubViewPtr(S, RView);
  PutSubViewPtr(S, VScrollBar);
  PutSubViewPtr(S, Indicator);
end;

function WindowOutput(var T: TextRec): Integer; far;
begin
  with T do
  begin
    WinData(UserData).Device^.StrWrite(BufPtr^, BufPos);
    BufPos := 0;
  end;
  WindowOutput := 0;
end;

function WindowDummy(var T: TextRec): Integer; far;
begin
  WindowDummy := 0;
end;

function WindowOpen(var T: TextRec): Integer; far;
begin
  with T do
  begin
    if (Mode = fmInput) then
    begin
      InOutFunc := @WindowDummy;
      FlushFunc := @WindowDummy;
    end else
    begin
      InOutFunc := @WindowOutput;
      FlushFunc := @WindowOutput;
    end;
    CloseFunc := @WindowDummy;
    WindowOpen := 0;
  end;
end;

procedure AssignOutput(var F: Text; AWindow: PbxTextWindow);
begin
  with TextRec(F) do
  begin
    Handle := $FFFF;
    Mode := fmClosed;
    BufSize := SizeOf(Buffer);
    BufPtr := @Buffer;
    OpenFunc := @WindowOpen;
    WinData(UserData).Device := AWindow^.Interior;
  end;
end;

procedure RegisterTvViews;
begin
  RegisterType(RbxFrame);
  RegisterType(RbxMinMaxButton);
  RegisterType(RbxIcon);
  RegisterType(RbxWindowIcon);
  RegisterType(RbxWindow);
  RegisterType(RbxTextWindow);
  RegisterType(RbxFormattedTextScroller);
  RegisterType(RbxPosIndicator);
  RegisterType(RbxMultiScrollBar);
  RegisterType(RbxEditBuff);
  RegisterType(RbxAsciiBuff);
  RegisterType(RbxHexBuff);
  RegisterType(RbxAsciiHexEditor);
end;

end.
