{$O+}
{$I Define.inc}
unit PropEdit;
interface
uses Objects, Views, Drivers, Prperty, Dialogs, TVForms, Register;
type
   PPropertyListBox = ^TPropertyListBox;
   TPropertyListBox = object(TListBox)
      constructor Init(var Bounds: TRect; AScrollBar: PScrollBar);
      function GetText(Item: Integer; MaxLen: Integer): String; virtual;
   end;
type
   PPropertyWindow = ^TPropertyWindow;
   TPropertyWindow = object(TForm)
     PropertyListBox:PPropertyListBox;
     constructor Init;
     destructor Done;virtual;
     procedure HandleEvent(var Event:TEvent);virtual;
     procedure ReadPropertyList(P:PView);
     procedure ReadPropertyListObj(P:Pointer);
     procedure EditCur;
     function GetHelpCtx: Word; virtual;
   end;

var
  PropertyWindow:PWindow;

implementation

uses Ext_dos, App, Ext_Type, ResTools, CmdConst, MsgBox, Ext_Math, Grids,
     Cursors, RsCllt, GlType, DAE, ResStrs, Global;

  {TPropertyListBox}
constructor TPropertyListBox.Init(var Bounds: TRect; AScrollBar: PScrollBar);
begin
  inherited Init(Bounds, 1, AScrollBar);
  GrowMode := gfGrowHiX + gfGrowHiY;
end;

function TPropertyListBox.GetText(Item: Integer; MaxLen: Integer): String;
var P:PProperty;
begin
   P:=List^.At(Item);
   GetText:=P^.Name^+': '+P^.AsText;
end;

   { TPropertyWindow }
constructor TPropertyWindow.Init;
var R:TRect;
    SB:PScrollBar;
begin
  R.Assign(  0,  7, 30, 23);
  inherited Init(R,GetString(sPropertylist));
  PropertyWindow:=@Self;
  Number:=GetWindowNumber;
  Palette:=dpBlueDialog;
  GetExtent(R);
  SB:=StandardScrollBar(sbVertical or sbHandleKeyboard);
  R.Grow(-1, -1);
  PropertyListBox:=New(PPropertyListBox, Init(R, SB));
  Insert(PropertyListBox);
end;

destructor TPropertyWindow.Done;
begin
  PropertyWindow:=nil;
  PropertyListBox^.NewList(nil);
  inherited Done;
end;

procedure TPropertyWindow.EditCur;
var R:TRect;
    P:PGridInputLine;
    Prop:PProperty;
    S:String;
    Form:PFormMain;
function Test(AItem:PFormMain):Boolean;far;
begin
  if _Cursor^.Owner^.ComponentType in GroupControl then
     Test:=AItem^.FormPtr=PDialog(_Cursor^.Owner^.Owner)
  else Test:=AItem^.FormPtr=PDialog(_Cursor^.Owner);
end;
begin
  Prop:=PropertyListBox^.List^.At(PropertyListBox^.Focused);
  Prop^.EditProperty(PropertyListBox);
  if _Cursor^.EditView^.ComponentType in GroupControl then
     PGroup(_Cursor^.EditView)^.ReDraw
  else _Cursor^.EditView^.DrawView;
  Form:=ProjectCollection^.FirstThat(@Test);
  Form^.FormPtr^.ReDraw;
  Form^.Modified:=true;
  Message(Application, evBroadcast, cmCurentChang, nil);
end;

procedure TPropertyWindow.HandleEvent(var Event:TEvent);
begin
  inherited HandleEvent(Event);
  case Event.What of
    evBroadcast:
    case Event.Command of
      cmCurSelect:ReadPropertyList(Event.InfoPtr);
      cmCurObjSelect:ReadPropertyListObj(Event.InfoPtr);
      cmListItemSelected:if Event.InfoPtr=PropertyListBox then
                         EditCur;
    else
      exit
    end;
  else
    exit;
  end;
end;

procedure TPropertyWindow.ReadPropertyList(P:PView);
var List:PCollection;
    i:integer;
begin
  if P<>nil then
{     List:=PCollection(ResourseFile.Get(GetString(P^.ComponentType+300)))}
     List:=PCollection(ResourseFile.Get('Property_'+NameComponentType(P)))
  else List:=nil;
  if List<>nil then
    for i:=0 to List^.Count-1 do PProperty(List^.At(i))^.SetPointer(P, P);
  PropertyListBox^.NewList(List);
end;

procedure TPropertyWindow.ReadPropertyListObj(P:Pointer);
var Rec:PObjectToEditMsgRec absolute P;
    List:PCollection;
    i:integer;
begin
  if P<>nil then
     List:=PCollection(ResourseFile.Get('Property_'+GetString(Rec^.Code+4000)))
  else List:=nil;
  if List<>nil then
    for i:=0 to List^.Count-1 do PProperty(List^.At(i))^.SetPointer(Rec^.Obj, Rec^.View);
  PropertyListBox^.NewList(List);
end;

function TPropertyWindow.GetHelpCtx: Word;
begin
  if PropertyListBox^.List<>nil then
     GetHelpCtx:=PProperty(PropertyListBox^.List^.At(PropertyListBox^.Focused))^.HelpCtx
  else GetHelpCtx:=inherited GetHelpCtx;
end;

end.
