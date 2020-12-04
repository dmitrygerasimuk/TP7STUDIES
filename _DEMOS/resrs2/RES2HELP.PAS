{$O+}
{$I Define.inc}
unit Res2Help;
interface

uses Clases, WHelp, Editors, Ext_Hlp, Objects, Views, Drivers, Menus,
     Register;

const
    cmFindHelpWindow     = 600;
    CHelpWindow     = #128#129#130#131#132#133#134#135#120;
type
    PHelpWindow = ^THelpWindow;
    THelpWindow = object(TWindow)
      HSB,VSB : PScrollBar;
      HelpView: PHelpViewer;
      constructor Init(var Bounds: TRect; ATitle: TTitleStr; ASourceFileID: word; AContext: THelpCtx; ANumber: Integer);
      procedure   InitHelpView;
      procedure   HandleEvent(var Event: TEvent); virtual;
      procedure   InitScrollBars; virtual;
      procedure   ShowIndex; virtual;
      procedure   ShowTopic(SourceFileID: word; Context: THelpCtx); virtual;
      function    GetPalette: PPalette; virtual;
    end;

procedure Help(FileID, Context: THelpCtx; Modal: boolean);
procedure HelpIndex(Keyword: string);
procedure HelpTopicSearch(Editor: PEditor);
procedure HelpTopic(const S: string);

procedure InitHelpSystem;
procedure DoneHelpSystem;

procedure InitHelpFiles;
procedure DoneHelpFiles;

const
    HelpInited     : boolean = false;
    HelpFiles : PStrings = nil;

implementation
uses App, ResTools, Ext_Str, Ext_Dos, MsgBox;

constructor THelpWindow.Init(var Bounds: TRect; ATitle: TTitleStr; ASourceFileID: word; AContext: THelpCtx; ANumber: Integer);
begin
  inherited Init(Bounds, ATitle, ANumber);
  InitScrollBars;
  if Assigned(HSB) then Insert(HSB);
  if Assigned(VSB) then Insert(VSB);
  InitHelpView;
  if Assigned(HelpView) then
  begin
    if (ASourceFileID<>0) or (AContext<>0) then
       ShowTopic(ASourceFileID, AContext);
    Insert(HelpView);
  end;
end;

procedure THelpWindow.InitScrollBars;
var R: TRect;
begin
  GetExtent(R); R.Grow(0,-1); R.A.X:=R.B.X-1;
  New(VSB, Init(R)); VSB^.GrowMode:=gfGrowLoX+gfGrowHiX+gfGrowHiY;
  GetExtent(R); R.Grow(-1,0); R.A.Y:=R.B.Y-1;
  New(HSB, Init(R)); HSB^.GrowMode:=gfGrowLoY+gfGrowHiX+gfGrowHiY;
end;

procedure THelpWindow.InitHelpView;
var R: TRect;
begin
  GetExtent(R); R.Grow(-1,-1);
  New(HelpView, Init(R, HSB, VSB));
  HelpView^.GrowMode:=gfGrowHiX+gfGrowHiY;
end;

procedure THelpWindow.ShowIndex;
begin
  HelpView^.SwitchToIndex;
end;

procedure THelpWindow.ShowTopic(SourceFileID: word; Context: THelpCtx);
begin
  HelpView^.SwitchToTopic(SourceFileID, Context);
end;

procedure THelpWindow.HandleEvent(var Event: TEvent);
begin
  case Event.What of
    evKeyDown :
      case Event.KeyCode of
        kbEsc :
          begin
            Event.What:=evCommand; Event.Command:=cmClose;
          end;
      end;
    evCommand:
      if Event.Command=cmFindHelpWindow then ClearEvent(Event);
  end;
  inherited HandleEvent(Event);
end;

function THelpWindow.GetPalette: PPalette;
const
  P: String[Length(CHelpWindow)] = CHelpWindow;
begin
  GetPalette := @P;
end;




procedure InitHelpSystem;

  procedure AddOAFile(HelpFile: string);
  begin
//    {$IFDEF DEBUG}SetStatus(strLoadingHelp+' ('+SmartPath(HelpFile)+')');{$ENDIF}
    HelpFacility^.AddOAHelpFile(HelpFile);
//    {$IFDEF DEBUG}SetStatus(strLoadingHelp);{$ENDIF}
  end;

(*  procedure AddHTMLFile(TOCEntry,HelpFile: string);
  begin
    {$IFDEF DEBUG}SetStatus(strLoadingHelp+' ('+SmartPath(HelpFile)+')');{$ENDIF}
    HelpFacility^.AddHTMLHelpFile(HelpFile, TOCEntry);
    {$IFDEF DEBUG}SetStatus(strLoadingHelp);{$ENDIF}
  end;*)

var I,P: Integer;
    S: string;
    TopicTitle: string;
begin
  New(HelpFacility, Init);
  for I:=0 to HelpFiles^.Count-1 do
    begin
      S:=HelpFiles^.Str(I); TopicTitle:='';
      P:=Pos('|',S);
      if P>0 then
        begin TopicTitle:=copy(S,P+1,255); S:=copy(S,1,P-1); end;
      if TopicTitle='' then TopicTitle:=S;
(*      if copy(stUpCase(ExtractExt(S)),1,4)='.HTM' then { this recognizes both .htm and .html }
          AddHTMLFile(TopicTitle,S)
      else*)
        AddOAFile(S);
    end;
end;

procedure CheckHelpSystem;
begin
  if HelpInited then Exit;
  InitHelpSystem;
  HelpInited:=true;
end;

procedure DoneHelpSystem;
begin
  if assigned(HelpFacility) then
    begin
      Dispose(HelpFacility, Done);
      HelpFacility:=nil;
    end;
  HelpInited:=false;
end;

function HelpCreateWindow:PHelpWindow;
var R: TRect;
    HelpWindow : PHelpWindow;
begin
  CheckHelpSystem;
  HelpWindow:=Message(Application, evCommand, cmFindHelpWindow, nil);
  if HelpWindow=nil then
  begin
     Desktop^.GetExtent(R); R.Grow(-15,-3); Dec(R.A.Y);
     HelpWindow:=New(PHelpWindow, Init(R, 'Help', 1, 0, GetWindowNumber));
     if HelpWindow<>nil then
     begin
       HelpWindow^.Hide;
       Desktop^.Insert(HelpWindow);
     end;
  end;
  HelpCreateWindow:=HelpWindow;
end;

procedure Help(FileID, Context: THelpCtx; Modal: boolean);
var HelpWindow:PHelpWindow;
begin
  if Modal then
     begin MessageBox('Sorry, modal help not yet implemented.',nil,mfInformation+mfInsertInApp+mfOKButton); Exit; end;
  HelpWindow:=HelpCreateWindow;
  if HelpWindow<>nil then
  with HelpWindow^ do
  begin
    HelpWindow^.ShowTopic(FileID,Context);
    if GetState(sfVisible)=false then Show;
    MakeFirst;
  end;
end;

procedure HelpTopicSearch(Editor: PEditor);
var S: string;
begin
  if Editor=nil then S:='' else
{  S:=GetEditorCurWord(Editor);}
  HelpTopic(S);
end;

procedure HelpTopic(const S: string);
var FileID: word;
    Ctx   : THelpCtx;
var Found: boolean;
begin
  CheckHelpSystem;
  Found:=HelpFacility^.TopicSearch(S,FileID,Ctx);
  if Found then
     Help(FileID,Ctx,false)
  else
     HelpIndex(S);
end;

procedure HelpIndex(Keyword: string);
var HelpWindow:PHelpWindow;
begin
  HelpWindow:=HelpCreateWindow;
  if HelpWindow<>nil then
  with HelpWindow^ do
  begin
    ShowIndex;
    if Keyword<>'' then
       HelpView^.Lookup(Keyword);
    if GetState(sfVisible)=false then Show;
    MakeFirst;
  end;
end;

procedure InitHelpFiles;
begin
  if HelpFiles=nil then HelpFiles:=New(PStrings, Init);
end;

procedure DoneHelpFiles;
begin
  if HelpFiles<>nil then Dispose(HelpFiles, Done);
  HelpFiles:=nil;
end;


end.
