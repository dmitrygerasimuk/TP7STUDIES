{*
*
*   Copyright (c) 1992,93 by Richard W. Hansen
*
*
*}
Unit TvScroll;
{$B+}
{$X+}
{$V-}

{$I TVDEFS.INC}

INTERFACE


USES
  TvConst, TvViews,
  Objects, Dialogs, Drivers, Views;


CONST
  gfScrollXY  = $80;
  scVScroll   = ofVScrollBar;
  scHScroll   = ofHScrollBar;

  CScrollInputLine  = #1#6#7#1; { Passive, Active, Selected, Arrow }


TYPE
  PbxScrollGroup = ^TbxScrollGroup;
  TbxScrollGroup = Object(TGroup)
    VScrollBar  : PScrollBar;
    HScrollBar  : PScrollBar;
    OldPos      : TPoint;
    AutoPos     : Boolean;

    Constructor Init(var Bounds      : TRect;
                         AHScrollBar : PScrollBar;
                         AVScrollBar : PScrollBar);
    Constructor Load(var S: TStream);
    Procedure   HandleEvent(var Event : TEvent);          Virtual;
    Procedure   Store(var S: TStream);
  end;


  PbxScrollDialog = ^TbxScrollDialog;
  TbxScrollDialog = Object(TDialog)
    Limit     : TPoint;
    VScrollBar: PScrollBar;
    HScrollBar: PScrollBar;
    Interior  : PbxScrollGroup;

    Constructor Init(var Bounds : TRect;
                         ATitle : String;
                         ofFlag : Word);
    Constructor Load(var S: TStream);
    Procedure   AutoPosition(Enable : Boolean);
    Function    InitBackground: PView;                    Virtual;
    Procedure   InsertToScroll(P : PView);
    Procedure   SetLimit(X, Y : Integer);
    Procedure   Store(var S: TStream);
  end;


  PbxScrollView = ^TbxScrollView;
  TbxScrollView = Object(TView)
    Constructor Init(var Bounds : TRect);
    Procedure   HandleEvent(var Event : TEvent);          Virtual;
    Procedure   SetState(AState: Word;
                         Enable: Boolean);                Virtual;
  end;


  PbxScrollInputLine  = ^TbxScrollInputLine;
  TbxScrollInputLine  = Object(TInputLine)
    Function    GetPalette: PPalette;                     Virtual;
  end;


  PbxScrollWindow = ^TbxScrollWindow;
  TbxScrollWindow = Object(TbxWindow)
    Limit      : TPoint;
    VScrollBar : PScrollBar;
    HScrollBar : PScrollBar;
    Interior   : PbxScrollGroup;

    Constructor Init(var Bounds : TRect;
                         ATitle : String;
                         ANumber: Word;
                         ofFlag : Word);
    Constructor Load(var S: TStream);
    Procedure   AutoPosition(Enable : Boolean);
    Procedure   ChangeBounds(var Bounds : TRect);         Virtual;
    Function    InitBackground: PView;                    Virtual;
    Procedure   InsertToScroll(P : PView);
    Procedure   SetLimit(X, Y : Integer);
    Procedure   Store(var S: TStream);
  end;


{ TVScroll registration procedure }

Procedure RegisterTVScroll;


{ Stream Registration Records }

CONST
  RbxScrollGroup: TStreamRec = (
    ObjType : 5350;
    VmtLink : Ofs(TypeOf(TbxScrollGroup)^);
    Load    : @TbxScrollGroup.Load;
    Store   : @TbxScrollGroup.Store
  );

CONST
  RbxScrollDialog: TStreamRec = (
    ObjType : 5351;
    VmtLink : Ofs(TypeOf(TbxScrollDialog)^);
    Load    : @TbxScrollDialog.Load;
    Store   : @TbxScrollDialog.Store
  );

CONST
  RbxScrollInputLine: TStreamRec = (
    ObjType : 5352;
    VmtLink : Ofs(TypeOf(TbxScrollInputLine)^);
    Load    : @TbxScrollInputLine.Load;
    Store   : @TbxScrollInputLine.Store
  );

CONST
  RbxScrollWindow: TStreamRec = (
    ObjType : 5353;
    VmtLink : Ofs(TypeOf(TbxScrollWindow)^);
    Load    : @TbxScrollWindow.Load;
    Store   : @TbxScrollWindow.Store
  );

implementation

constructor TbxScrollGroup.Init(var Bounds: TRect; AHScrollBar: PScrollBar;
  AVScrollBar: PScrollBar);
begin
  inherited Init(Bounds);
  HScrollBar := AHScrollBar;
  VScrollBar := AVScrollBar;
  GrowMode := GrowMode or gfGrowHiX or gfGrowHiY;
  AutoPos := True;
end;

constructor TbxScrollGroup.Load(var S: TStream);
begin
  inherited Load(S);
  GetPeerViewPtr(S, HScrollBar);
  GetPeerViewPtr(S, VScrollBar);
  S.Read(OldPos, SizeOf(TPoint));
  S.Read(AutoPos, SizeOf(Boolean));
end;

procedure TbxScrollGroup.HandleEvent(var Event: TEvent);
var
  SaveEvent: TEvent;
  DeltaX: Integer;
  DeltaY: Integer;
  Mouse: TPoint;

procedure ScrollView(P: PView); far;
begin
  if (P^.GrowMode and gfScrollXY <> 0) then
  begin
    P^.Origin.X := P^.Origin.X + DeltaX;
    P^.Origin.Y := P^.Origin.Y + DeltaY;
  end;
end;

procedure CalcDelta;
begin
  if (Current <> nil) then
  begin
    DeltaX := 0;
    DeltaY := 0;
    if (HScrollBar <> nil) then
    begin
      if (Current^.Origin.X < 0) then
        HScrollBar^.Value := HScrollBar^.Value + Current^.Origin.X
      else if (Current^.Origin.X + Current^.Size.X > Size.X) then
        HScrollBar^.Value := HScrollBar^.Value +
          (Current^.Origin.X + Current^.Size.X - Size.X);
      DeltaX := OldPos.X - HScrollBar^.Value;
      if (DeltaX <> 0) then
      begin
        OldPos.X := HScrollBar^.Value;
        HScrollBar^.DrawView;
      end;
    end;
    if (VScrollBar <> nil) then
    begin
      if (Current^.Origin.Y < 0) then
        VScrollBar^.Value := VScrollBar^.Value + Current^.Origin.Y
      else if (Current^.Origin.Y + Current^.Size.Y > Size.Y) then
        VScrollBar^.Value := VScrollBar^.Value +
          (Current^.Origin.Y + Current^.Size.Y - Size.Y);
      DeltaY := OldPos.Y - VScrollBar^.Value ;
      if (DeltaY <> 0) then
      begin
        OldPos.Y := VScrollBar^.Value;
        VScrollBar^.DrawView;
      end;
    end;
  end;
end;

begin
  if (Event.What = evBroadcast) then case Event.Command of
    cmScrollBarChanged:
      if (Event.InfoPtr <> nil) then
        if (HScrollBar <> nil) or (VScrollBar <> nil) then
        begin
          DeltaX := 0;
          DeltaY := 0;
          if (HScrollBar = Event.InfoPtr) then
          begin
            DeltaX := OldPos.X - HScrollBar^.Value;
            OldPos.X := HScrollBar^.Value;
          end else if (VScrollBar = Event.InfoPtr) then
          begin
            DeltaY := OldPos.Y - VScrollBar^.Value;
            OldPos.Y := VScrollBar^.Value;
          end;
          if (DeltaX <> 0) or (DeltaY <> 0) then
          begin
            ForEach(@ScrollView);
            Redraw;
            if (Current <> nil) then
              if (Current^.State and sfCursorVis <> 0) then
                Current^.SetCursor(Current^.Cursor.X, Current^.Cursor.Y);
          end;
          Exit;
        end;
  end else if (Event.What = evKeyDown) then case Event.KeyCode of
    kbTab:
      begin
        FocusNext(False);
        if AutoPos then
        begin
          CalcDelta;
          if (DeltaX <> 0) or (DeltaY <> 0) then
          begin
            ForEach(@ScrollView);
            Redraw;
          end;
        end;
        ClearEvent(Event);
        Exit;
      end;
    kbShiftTab:
      begin
        FocusNext(True);
        if AutoPos then
        begin
          CalcDelta;
          if (DeltaX <> 0) or (DeltaY <> 0) then
          begin
            ForEach(@ScrollView);
            Redraw;
          end;
        end;
        ClearEvent(Event);
        Exit;
      end;
  end;
  SaveEvent := Event;
  inherited HandleEvent(Event);
  if (SaveEvent.What and evMouseDown <> 0) and AutoPos then
  begin
    if (Current <> nil) and Current^.MouseInView(SaveEvent.Where) then
    begin
      CalcDelta;
      if (DeltaX <> 0) or (DeltaY <> 0) then
      begin
        ForEach(@ScrollView);
        Redraw;
      end;
    end;
  end;
end;

procedure TbxScrollGroup.Store(var S: TStream);
begin
  inherited Store(S);
  PutPeerViewPtr(S, HScrollBar);
  PutPeerViewPtr(S, VScrollBar);
  S.Write(OldPos, SizeOf(TPoint));
  S.Write(AutoPos, SizeOf(Boolean));
end;

constructor TbxScrollDialog.Init(var Bounds: TRect; ATitle: string;
  ofFlag: Word);
var
  R: TRect;
  P: PView;
begin
  inherited Init(Bounds, ATitle);
  if (ofFlag and ofHScrollBar <> 0) then
  begin
    HScrollBar := StandardScrollBar(sbHorizontal or sbHandleKeyboard);
    Insert(HScrollBar);
  end;
  if (ofFlag and ofVScrollBar <> 0) then
  begin
    VScrollBar := StandardScrollBar(sbVertical or sbHandleKeyboard);
    Insert(VScrollBar);
  end;
  GetExtent(R);
  R.Grow(-1, -1);
  Interior := New(PbxScrollGroup, Init(R, HScrollBar, VScrollBar));
  Insert(Interior);
  Interior^.Insert(InitBackground);
end;

constructor TbxScrollDialog.Load(var S: TStream);
begin
  inherited Load(S);
  S.Read(Limit, SizeOf(TPoint));
  GetSubViewPtr(S, VScrollBar);
  GetSubViewPtr(S, HScrollBar);
  GetSubViewPtr(S, Interior);
end;

procedure TbxScrollDialog.AutoPosition(Enable: Boolean);
begin
  Interior^.AutoPos := Enable;
end;

function TbxScrollDialog.InitBackground: PView;
var
  R: TRect;
  P: PView;
begin
  Interior^.GetExtent(R);
  P := New(PView, Init(R));
  P^.SetState(sfDisabled, True);
  P^.Options := P^.Options and not ofSelectable;
  InitBackground := P;
end;

procedure TbxScrollDialog.InsertToScroll(P: PView);
begin
  Interior^.Insert(P);
  P^.GrowMode := P^.GrowMode or gfScrollXY;
end;

procedure TbxScrollDialog.SetLimit(X, Y: Integer);
begin
  Limit.X := X;
  Limit.Y := Y;
  if (HScrollBar <> nil) then
    HScrollBar^.SetParams(HScrollBar^.Value, 0, X - Size.X, Size.X - 1, 1);
  if (VScrollBar <> nil) then
    VScrollBar^.SetParams(VScrollBar^.Value, 0, Y - Size.Y, Size.Y - 1, 1);
end;

procedure TbxScrollDialog.Store(var S: TStream);
begin
  inherited Store(S);
  S.Write(Limit, SizeOf(TPoint));
  PutSubViewPtr(S, VScrollBar);
  PutSubViewPtr(S, HScrollBar);
  PutSubViewPtr(S, Interior);
end;

constructor TbxScrollView.Init(var Bounds: TRect);
begin
  inherited Init(Bounds);
  Options := Options or ofSelectable;
  DragMode := dmDragMove or dmDragGrow;
  EventMask := EventMask or evBroadcast;
end;

procedure TbxScrollView.HandleEvent(var Event: TEvent);

procedure DragScroll(Mode: Byte);
var
  Limits: TRect;
  Min, Max: TPoint;
begin
  if (DragMode and Mode <> 0) then
  begin
    Owner^.GetExtent(Limits);
    SizeLimits(Min, Max);
    Mode := Mode or DragMode and not dmDragMove and not dmDragGrow;
    DragView(Event, Mode, Limits, Min, Max);
    ClearEvent(Event);
  end;
end;

var
  Mouse: TPoint;
begin
  inherited HandleEvent(Event);
  if (Event.What = evCommand) then
  begin
    case Event.Command of
      cmDragView:
        DragScroll(dmDragMove or dmDragGrow);
    end;
  end else if (Event.What = evBroadcast) then
  begin
    case Event.Command of
      cmReceivedFocus, cmReleasedFocus:
        DrawView;
    end;
  end else if (Event.What = evMouseDown) then
  begin
    MakeLocal(Event.Where, Mouse);
    if (Mouse.Y = 0) and (Mouse.X < Size.X - 1) then
      DragScroll(dmDragMove)
    else if (Mouse.X >= Size.X - 1) and (Mouse.Y >= Size.Y - 1) then
      DragScroll(dmDragGrow);
  end;
end;

procedure TbxScrollView.SetState(AState: Word; Enable: Boolean);
begin
  inherited SetState(AState, Enable);
  if (AState = sfSelected) then SetState(sfActive, Enable)
  else if (AState and (sfDragging or sfActive) <> 0) then DrawView;
end;

function TbxScrollInputLine.GetPalette: PPalette;
const
  P: string[Length(CScrollInputLine)] = CScrollInputLine;
begin
  GetPalette := @P;
end;

constructor TbxScrollWindow.Init(var Bounds: TRect; ATitle: string;
  ANumber: Word; ofFlag: Word);
var
  R: TRect;
begin
  inherited Init(Bounds, ATitle, ANumber);
  if (ofFlag and ofHScrollBar <> 0) then
  begin
    HScrollBar := StandardScrollBar(sbHorizontal or sbHandleKeyboard);
    Insert(HScrollBar);
  end;
  if (ofFlag and ofVScrollBar <> 0) then
  begin
    VScrollBar := StandardScrollBar(sbVertical or sbHandleKeyboard);
    Insert(VScrollBar);
  end;
  GetExtent(R);
  R.Grow(-1, -1);
  Interior := New(PbxScrollGroup, Init(R, HScrollBar, VScrollBar));
  Insert(Interior);
  Interior^.Insert(InitBackground);
end;

constructor TbxScrollWindow.Load(var S: TStream);
begin
  inherited Load(S);
  GetSubViewPtr(S, Interior);
end;

procedure TbxScrollWindow.AutoPosition(Enable: Boolean);
begin
  Interior^.AutoPos := Enable;
end;

procedure TbxScrollWindow.ChangeBounds(var Bounds: TRect);
begin
  inherited ChangeBounds(Bounds);
  if (HScrollBar <> nil) then
    HScrollBar^.SetParams(HScrollBar^.Value, 0, Limit.X - Size.X + 2, Size.X - 1, 1);
  if (VScrollBar <> nil) then
    VScrollBar^.SetParams(VScrollBar^.Value, 0, Limit.Y - Size.Y + 2, Size.Y - 1, 1);
end;

function TbxScrollWindow.InitBackground: PView;
var
  R: TRect;
  P: PView;
begin
  Interior^.GetExtent(R);
  P := New(PView, Init(R));
  P^.SetState(sfDisabled, True);
  P^.Options := P^.Options and not ofSelectable;
  InitBackground := P;
end;

procedure TbxScrollWindow.InsertToScroll(P: PView);
begin
  Interior^.Insert(P);
  P^.GrowMode := P^.GrowMode or gfScrollXY;
end;

procedure TbxScrollWindow.SetLimit(X, Y: Integer);
begin
  Limit.X := X;
  Limit.Y := Y;
  if (HScrollBar <> nil) then
    HScrollBar^.SetParams(HScrollBar^.Value, 0, X - Size.X, Size.X - 1, 1);
  if (VScrollBar <> nil) then
    VScrollBar^.SetParams(VScrollBar^.Value, 0, Y - Size.Y, Size.Y - 1, 1);
end;

procedure TbxScrollWindow.Store(var S: TStream);
begin
  inherited Store(S);
  PutSubViewPtr(S, Interior);
end;

procedure RegisterTvScroll;
begin
  RegisterType(RbxScrollGroup);
  RegisterType(RbxScrollDialog);
  RegisterType(RbxScrollInputLine);
  RegisterType(RbxScrollWindow);
end;

end.
