{*
*
*   Copyright (c) 1992,93 by Richard W. Hansen
*
*
*}
{$F+,O+}
UNIT TVApp;
{$B+}
{$X+}
{$V-}

{$I TVDEFS.INC}

INTERFACE


USES
  App, Dialogs, Drivers, Objects, Views{, N_WndApp};


CONST
  { Palette Layout }
  { 1-63 are normal palette entries }
  { 64-127 are reserved by Borland }
  { 128-135 are the help colors defined in HELPFILE.PAS }
  {         they need to go in ahead of new colors. }
  { 136-185 are TV Tool Box colors }
  { 136 is the busy window color }
  { 137-171 are 3D palette entries }
  { 172-190 are reserved by TV Tool Box for future use }

  { 136 = Busy indicator }
  { 137 = Frame normal }
  { 138 = Frame shaded }
  { 139 = Frame passive }
  { 140 = Frame icon }
  { 141 = Button normal }
  { 142 = Button text }
  { 143 = Button disabled text }
  { 144 = Button shortcut text }
  { 145 = Button shaded }
  { 146 = Button default text }
  { 147 = Outline normal }
  { 148 = Outline shaded }
  { 149 = Inputline active }
  { 150 = Inputline selected text }
  { 151 = Inputline arrow }
  { 152 = Cluster normal }
  { 153 = Cluster selected }
  { 154 = Cluster shortcut }
  { 155 = Cluster disabled }
  { 156 = ListViewer normal }
  { 157 = ListViewer focused }
  { 158 = ListViewer selected }
  { 159 = ListViewer divider }
  { 160 = History arrow }
  { 161 = History normal }
  { 162 = History shaded }
  { 163 = HistoryWindow scrollbar page area }
  { 164 = HistoryWindow scrollbar controls }
  { 165 = Scroll bar page areas }
  { 166 = Scroll bar arrows/indicator }
  { 167 = Static text }
  { 168 = Label normal }
  { 169 = Label selected }
  { 170 = Label shortcut }
  { 171 = InfoPane }

  CHelpColor      = #$37#$3F#$3A#$13#$13#$30#$3E#$1E;
  CHelpBlackWhite = #$07#$0F#$07#$70#$70#$07#$0F#$70;
  CHelpMonochrome = #$07#$0F#$07#$70#$70#$07#$0F#$70;

  CColor      =
   {Busy|     Frame     |        Button         |}
    #$CF#$7F#$70#$70#$70#$7F#$70#$78#$7E#$70#$7F +
   {|Outline|Input Line |  Cluster      |  List Viewer  |}
    #$7F#$70#$70#$07#$70#$70#$7F#$7F#$78#$70#$07#$7F#$70 +
   {|  History  |Hist Wn|Sc. Bar|S T|   Label   |I P}
    #$70#$7F#$70#$78#$0F#$07#$0F#$78#$70#$7F#$7E#$70;

  CBlackWhite =
    #$8F#$7F#$70#$78#$70#$7F#$70#$78#$0F#$70#$7F +
    #$7F#$70#$70#$07#$0F#$70#$07#$0F#$78#$70#$07#$7F#$70 +
    #$70#$7F#$70#$78#$0F#$07#$0F#$78#$70#$7F#$0F#$7F;

  CMonochrome =
    #$8F#$7F#$70#$78#$70#$7F#$70#$78#$0F#$70#$7F +
    #$7F#$70#$70#$07#$0F#$70#$07#$0F#$78#$70#$07#$7F#$70 +
    #$70#$7F#$70#$78#$0F#$07#$0F#$78#$70#$7F#$0F#$7F;

  CBusyWindow = #136#136#136#136#136#136#136#136;


TYPE
  PbxBusyWindow = ^TbxBusyWindow;
  TbxBusyWindow = Object(TWindow)
    Constructor Init(const AMessage : String);
    Function    GetPalette: PPalette;                     Virtual;
    Procedure   Show;                                     Virtual;
  end;


  PbxApplication = ^TbxApplication;
  TbxApplication = Object(TApplication)
    MouseVisible : Boolean;
    ToggleMouse  : Boolean;

    Constructor Init;
    Constructor Load(var S: TStream);
    Procedure   CloseAllWindows;
    Procedure   GetEvent(var Event: TEvent);              Virtual;
    Function    GetPalette: PPalette;                     Virtual;
    Procedure   HandleEvent(var Event: TEvent);           Virtual;
    Procedure   HideBusy;
    Procedure   SetMouseToggle(const Enable : Boolean);
    Procedure   ShowBusy;
    Procedure   Store(var S: TStream);
  end;


CONST
  BusyWindow  : PbxBusyWindow = nil;



{ TvApp registration procedure }

Procedure RegisterTVApp;


{ Stream Registration Records }

CONST
  RbxBusyWindow: TStreamRec = (
    ObjType : 5200;
    VmtLink : Ofs(TypeOf(TbxBusyWindow)^);
    Load    : @TbxBusyWindow.Load;
    Store   : @TbxBusyWindow.Store
  );

CONST
  RbxApplication: TStreamRec = (
    ObjType : 5201;
    VmtLink : Ofs(TypeOf(TbxApplication)^);
    Load    : @TbxApplication.Load;
    Store   : @TbxApplication.Store
  );

implementation

CONSTRUCTOR TbxBusyWindow.Init(CONST AMessage: STRING);
var
  R: TRect;
begin
  R.Assign(0, 0, Length(AMessage) + 2, 3);
  INHERITED Init(R, '', wnNoNumber);
  Flags := wfMove;
  DragMode := dmDragMove;
  State := State and not sfVisible;
  GetExtent(R);
  R.Grow(-1, -1);
  Insert(New(PStaticText, Init(R, AMessage)));
end;

function TbxBusyWindow.GetPalette: PPalette;
const
  P: string[Length(CBusyWindow)] = CBusyWindow;
begin
  GetPalette := @P;
end;

procedure TbxBusyWindow.Show;
begin
  inherited Show;
  MakeFirst
end;

CONSTRUCTOR TbxApplication.Init;
BEGIN
  INHERITED Init;
  MouseVisible := TRUE;
  ToggleMouse := TRUE;
  BusyWindow := New(PbxBusyWindow, Init('Подождите...'));
  IF (BusyWindow <> NIL) THEN Insert(BusyWindow)
END;

constructor TbxApplication.Load(var S:TStream);
begin
  inherited Load(S);
  S.Read(MouseVisible, SizeOf(Boolean));
  S.Read(ToggleMouse, SizeOf(Boolean));
end;

procedure TbxApplication.CloseAllWindows;

procedure CloseWindow(P: PView); far;
begin
  Message(P, evCommand, cmClose, nil);
end;

begin
  Desktop^.ForEach(@CloseWindow);
end;

procedure TbxApplication.GetEvent(var Event: TEvent);
begin
  inherited GetEvent(Event);
  if ToggleMouse then
    case Event.What of
      evMouseDown, evMouseUp:
        begin
          if not MouseVisible then
          begin
            MouseVisible := True;
            ShowMouse;
          end;
        end;
      evMouseMove:
        if not MouseVisible then
        begin
          MouseVisible := True;
          ShowMouse;
        end;
      evKeyDown:
        if MouseVisible then
        begin
          MouseVisible := False;
          HideMouse;
        end;
    end;
end;

function TbxApplication.GetPalette: PPalette;
const
  P: array[apColor..apMonochrome] of
    string[Length(CAppColor+CHelpColor+CColor)] =
    (CAppColor + CHelpColor + CColor,
    CAppBlackWhite + CHelpBlackWhite + CBlackWhite,
    CAppMonochrome + CHelpMonochrome + CMonochrome);
begin
  GetPalette := @P[AppPalette];
end;

procedure TbxApplication.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);
  case Event.What of
    evCommand:
      case Event.Command of
        cmCLoseAll:
          begin
            CloseAllWindows;
            ClearEvent(Event);
          end;
      end;
  end;
end;

procedure TbxApplication.HideBusy;
begin
  if (BusyWindow <> nil) then BusyWindow^.Hide;
end;

procedure TbxApplication.SetMouseToggle(const Enable: Boolean);
begin
  if (not Enable and ToggleMouse) and not MouseVisible then
  begin
    MouseVisible := True;
    ShowMouse;
  end;
  ToggleMouse := Enable;
end;

procedure TbxApplication.ShowBusy;
begin
  if (BusyWindow <> nil) then BusyWindow^.Show;
end;

procedure TbxApplication.Store(var S: TStream);
begin
  inherited Store(S);
  S.Write(MouseVisible, SizeOf(Boolean));
  S.Write(ToggleMouse, SizeOf(Boolean));
end;

procedure RegisterTvApp;
begin
  RegisterType(RbxBusyWindow);
  RegisterType(RbxApplication);
end;

end.
