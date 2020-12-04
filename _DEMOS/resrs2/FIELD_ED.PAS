{$O+}
{$I Define.inc}
unit Field_Ed;
interface
uses Views, Dialogs, DataCtrl, DAE, DBFTable, Drivers, Register;
type
  PFieldListBox = ^TFieldListBox;
  TFieldListBox = object(TListBox)
    function GetText(Item: Integer; MaxLen: Integer): String; virtual;
    procedure FocusItem(Item: Integer); virtual;
  end;

type
  PFieldEditor = ^TFieldEditor;
  TFieldEditor = object(TDialog)
    FieldListBox:PFieldListBox;
    DS:PDBSourse;
    constructor Init(ADS:PDBSourse);
    procedure HandleEvent(var Event:TEvent);virtual;
    function GetTitle(MaxSize: Integer): TTitleStr; virtual;
  end;

procedure NewFieldEditor(D:PDBSourse);

{type
  PTabbedEditor = ^TTabbedEditor;
  TTabbedEditor = object(TWindow)
    Controls:PView;
    ListBox:PListBox;
    constructor Init(AControls:PView; OnGetText:TGetTextEvent;
         OnFocusItem:TItemEvent);
    procedure HandleEvent(var Event:TEvent);virtual;
  end;}

implementation
uses Objects, App, CmdConst, GlType, ResTools, ResStrs, Ext_Dos;

  { TFieldListBox }
function TFieldListBox.GetText(Item: Integer; MaxLen: Integer): String;
var F:PField;
begin
  if List<>nil then
  begin
    F:=List^.At(Item);
    GetText:=F^.Name^
  end
  else
  GetText:='';
end;

procedure TFieldListBox.FocusItem(Item: Integer);
var R:TObjectToEditMsgRec;
    F:PField;
begin
  inherited FocusItem(Item);
  if (List<>nil) and (Owner<>nil) then
  begin
    F:=List^.At(Item);
    R.Code:=byte(F^.FieldType);
    R.Obj:=F;
    R.View:=PFieldEditor(Owner)^.DS;
    Message(Application, evBroadcast, cmCurObjSelect, @R);
  end;
end;

  { TFieldEditor }
constructor TFieldEditor.Init(ADS:PDBSourse);
var R:TRect;
    ScrollBar:PScrollBar;
begin
   R.Assign( 24,  3, 51, 18);
   inherited Init(R,'');
   DS:=ADS;
   GrowMode := gfGrowAll + gfGrowRel;
   Flags := wfMove + wfGrow + wfClose + wfZoom;
   Palette:=dpBlueDialog;
   R.Assign( 26,  1, 27, 14);
     ScrollBar:=New(PScrollBar, Init( R));
     Insert(ScrollBar);
   R.Assign(  1,  1, 26, 14);
     FieldListBox:=New(PFieldListBox, Init( R ,1,ScrollBar));
     FieldListBox^.GrowMode:=gfGrowHiX + gfGrowHiY;
     FieldListBox^.NewList(DS^.FieldDefs);
     Insert(FieldListBox);
end;

function TFieldEditor.GetTitle(MaxSize: Integer): TTitleStr;
begin
  if (DS<>nil) and (DS^.TableName<>nil) then
      GetTitle:=FNameReduce(DS^.TableName^, MaxSize-4)
  else GetTitle:=GetString(sFieldEditor);
end;

procedure TFieldEditor.HandleEvent(var Event:TEvent);
begin
  inherited HandleEvent(Event);
  case Event.What of
    evBroadcast:
    begin
      case Event.Command of
        cmDelCurForm:if DS^.Owner=Event.InfoPtr then Close;
        cmFindFieldEditor: if Event.InfoPtr=DS then ClearEvent(Event);
        cmNewTable:if Event.InfoPtr=DS then
                   begin
                      FieldListBox^.SetRange(0);
                      FieldListBox^.List:=nil;
                      FieldListBox^.NewList(DS^.FieldDefs);
                   end;
      end;
      exit;
    end;
  else
    exit;
  end;
{  ClearEvent(Event);}
end;


procedure NewFieldEditor(D:PDBSourse);
var P:PView;
begin
  if D=nil then exit;
  P:=Message(Application, evBroadcast, cmFindFieldEditor, D);
  if P<>nil then P^.Select
  else Application^.InsertWindow(New(PFieldEditor, Init(D)));
end;

{constructor TTabbedEditor.Init(AControls:PView; OnGetText:TGetTextEvent;
         OnFocusItem:TItemEvent);
var R:TRect;
    ScrollBar:PScrollBar;
begin
   R.Assign( 24,  3, 51, 18);
   inherited Init(R, '', GetWindowNumber)
   Controls:=AControls;
   R.Assign( 26,  1, 27, 14);
     ScrollBar:=New(PScrollBar, Init( R));
     Insert(ScrollBar);
   R.Assign(  1,  1, 26, 14);
     FieldListBox:=New(PFieldListBox, Init( R ,1,ScrollBar));
     FieldListBox^.GrowMode:=gfGrowHiX + gfGrowHiY;
     FieldListBox^.NewList(DS^.FieldDefs);
     Insert(FieldListBox);
OnGetText:TGetTextEvent;
         OnFocusItem:TItemEventend;
    Controls:PView;
    ListBox:PListBox;
    procedure HandleEvent(var Event:TEvent);virtual;}
end.
