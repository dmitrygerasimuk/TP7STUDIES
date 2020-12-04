unit DemoHelp;
interface
uses Ext_Hlp, Views, Ext_Edit, Objects, AddCntrl, WHelp;
const
    cmFindHelpWindow     = 600;
    CHelpWindow     = #128#129#130#131#132#133#134#135#120;
type
  PNHelpViewer = ^TNHelpViewer;
  TNHelpViewer = object(TExtEditor)
    HelpTopic: PHelpTopic;
    CurLink: integer;
    constructor Init(var Bounds: TRect; AHScrollBar, AVScrollBar: PLargeScrollBar);
    procedure SwitchToTopic(SourceFileID: word; Context: THelpCtx); virtual;
  end;

type
  PHelpWindow = ^THelpWindow;
  THelpWindow = object(TWindow)
    HSB,VSB : PLargeScrollBar;
    HelpView: PNHelpViewer;
    constructor Init;
{      constructor Init(var Bounds: TRect; ATitle: TTitleStr; ASourceFileID: word; AContext: THelpCtx; ANumber: Integer);
    procedure   InitHelpView;
    procedure   HandleEvent(var Event: TEvent); virtual;
    procedure   InitScrollBars; virtual;
    procedure   ShowIndex; virtual;
    procedure   ShowTopic(SourceFileID: word; Context: THelpCtx); virtual;}
    function    GetPalette: PPalette; virtual;
  end;

procedure ShowHelpWindow11;
implementation
uses App, Dialogs;

procedure ShowHelpWindow11;
begin
  if HelpFacility=nil then
  begin
    HelpFacility:=New(PHelpFacility, Init);
    HelpFacility^.AddOAHelpFile('C:\BP\BIN\TURBO.TPH');
  end;
  Application^.InsertWindow(New(PHelpWindow, Init));
end;

  {THelpWindow}
constructor THelpWindow.Init;
var R:TRect;
begin
  Desktop^.GetExtent(R);
  inherited Init(R,'Help',0);
  GetExtent(R);
  R.Grow(-1,-1);
{  HSB:=StandardScrollBar(sbHorizontal);
  VSB:=StandardScrollBar(sbVertical);}
  HelpView:=Insert(New(PNHelpViewer, Init(R, HSB, VSB)));
  HelpView^.SwitchToTopic(0, 0);
end;

function THelpWindow.GetPalette:PPalette;
const
  P: String[Length(CHelpWindow)] = CHelpWindow;
begin
  GetPalette := @P;
end;

  {TNHelpViewer}
constructor TNHelpViewer.Init(var Bounds: TRect; AHScrollBar, AVScrollBar: PLargeScrollBar);
begin
  inherited Init(Bounds, AHScrollBar, AVScrollBar, nil, '');
  ReadOnly:=true;
end;

procedure TNHelpViewer.SwitchToTopic(SourceFileID: word; Context: THelpCtx);
var P: PTopic;
begin
{  if HelpFacility=nil then P:=nil
  else
    if (SourceFileID=0) and (Context=0) and (HelpTopic<>nil) then
       P:=IndexTopic
    else P:=HelpFacility^.LoadTopic(SourceFileID, Context);
  ISwitchToTopicPtr(P,RecordInHistory);}
end;

end.