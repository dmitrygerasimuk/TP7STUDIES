unit Set_Opt;
{$F-,O+,A+,R-,S-}
interface
uses RsCllt, GlType, Views, Objects, Drivers, Dialogs, Ext_Type, Register;

procedure SetOptions( V:PView; F:PFormMain; Mouse:TPoint);

procedure FillRecord( Form:PFormMain; V:PView; ValidSet:TTypeSet;
                      AddType:Boolean; var List:TListBoxRec);

implementation
uses Ext_str, MsgBox, Ext_Math, Global, ResTools, AddCntrl, DAE,
     ResStrs, Editors, Ext_Dos, GauGes, AboutPn, DataCtrl,
     OutLine, App, DBCtrls, Grids, Clases, Dos, Reports, Cursors,
     DBGrids, CmdConst, StdForms, Querys, Menus, Field_Ed;

procedure FillRecord( Form:PFormMain; V:PView; ValidSet:TTypeSet;
                      AddType:Boolean; var List:TListBoxRec);
var
  //I:integer;
  S:string;
procedure Fill(P:PView);far;
procedure DoFill(P:PView);far;
begin
   if P^.ComponentType in ValidSet then
   begin
      S:=P^.ComponentName^;
      if AddType then S:=S+':T'+GetString(sComponentTypeNameBase+P^.ComponentType);
      PCollection(List.List)^.Insert(NewStr(S));
      if P=V then List.Selection:=PCollection(List.List)^.Count-1;
      //inc(i);
    end;
end;

begin
   if P^.ComponentType in ValidSet then
   begin
      S:=P^.ComponentName^;
      if AddType then S:=S+':T'+GetString(sComponentTypeNameBase+P^.ComponentType);
      PCollection(List.List)^.Insert(NewStr(S));
      if P=V then List.Selection:=PCollection(List.List)^.Count-1;
      if P^.ComponentType in GroupControl then
         PGroup(P)^.ForEach(@DoFill);
    end;
end;

begin
  FillChar(List, SizeOf(TListBoxRec), 0);
  List.List:=New(PStrings, Init);
  //I:=0;
  if ctDialog in ValidSet then
  begin
    S:=Form^.FormPtr^.ComponentName^;
    if AddType then S:=S+':T'+GetString(sComponentTypeNameBase+Form^.FormPtr^.ComponentType);
    PCollection(List.List)^.Insert(NewStr(S));
  end;
  Form^.FormPtr^.ForEach(@Fill);
end;

procedure SetReportOpt(P:PReport; Mouse:TPoint);forward;
procedure SetDBGridOpt(P:PDBGrid; Mouse:TPoint);forward;
procedure SetDBSourse(P:PDBSourse; Mouse:TPoint);forward;
{procedure SetQueryOpt(P:PQuery);forward;}
procedure SetTViewOpt(V:PView; Mouse:TPoint);forward;
procedure SetStdOpt(V:PView;var C:word);forward;

procedure SetOptions( V:PView; F:PFormMain; Mouse:TPoint);
var C:PCursor absolute V;
begin
  if (C=_Cursor) and (_Cursor^.EditView<>nil) then V:=_Cursor^.EditView;
  case V^.ComponentType of
    ctReport: SetReportOpt(PReport(V), Mouse);
    ctDBGrid: SetDBGridOpt(PDBGrid(V), Mouse);
    ctDBSourse:SetDBSourse(PDBSourse(V), Mouse);
{    ctQuery:SetQueryOpt(PQuery(V))}
  else
    SetTViewOpt(V, Mouse);
  end;
  Message(Application, evBroadcast, cmCurentChang, V^.Owner);
end;

function PopUpMenu(P:PView;const sMenu:string; Mouse:TPoint):word;
var
  R:TRect;
  PM:PView;
  i:integer;
  MI:PMenuItem;
begin
  PopUpMenu:=cmError;
  PM:=PView(ResourseFile.Get(sMenu));
  if PM=nil then exit;
  I:=3;
  MI:=PMenuBox(PM)^.Menu^.Items;
  while MI<>nil do
  begin
    inc(i);
    MI:=MI^.Next;
  end;
  R.Assign(Mouse.X+1, Mouse.Y+1, Mouse.X+25, Mouse.Y+I);
  if R.B.Y>25 then R.Move(0, 25-R.B.Y);
  PM^.SetBounds(R);
  PopUpMenu:=Application^.ExecView(PM);
  PM^.Free;
end;
type
   Form10Record=record
      ParamText1:PString;
      OrignX:Longint;
      OrignY:Longint;
      SizeX:Longint;
      SizeY:Longint;
   end;

procedure SetStdOpt(V:PView;var C:word);
procedure SetSize;
var S:String;
    Rec:Form10Record;
    R:TRect;
begin
  if V^.ComponentName<>nil then s:=V^.ComponentName^ else S:='';
  Rec.ParamText1:=@S;
  Rec.OrignX:=V^.Origin.X;
  Rec.OrignY:=V^.Origin.Y;
  Rec.SizeX:=V^.Size.X;
  Rec.SizeY:=V^.Size.Y;
  if ExecDialog(sSizeDialog, @Rec)<>cmCancel then
  begin
    with Rec do
      R.Assign(OrignX, OrignY, OrignX+SizeX, OrignY+SizeY);
      V^.SetBounds(R);
      _Cursor^.SetLink(V);
  end;
end;

procedure BringToFront(Target:boolean);
var Owner:PGroup;
begin
  Owner:=V^.Owner;
  if Owner<>nil then
  begin
    Owner^.Delete(V);
    if Target then Owner^.Insert(V)
    else Owner^.InsertBefore(V, Owner^.Last);
  end;
  _Cursor^.SetLink(V);
end;

procedure TabOrder;
var List:TListBoxRec;
    Owner:PGroup;
    VV:PView;

procedure DoDel(P: PView);far;
begin
  Owner^.Delete(P);
end;
procedure DoInsert(P: PView);far;
begin
  Owner^.Insert(P);
end;

begin
  Owner:=V^.Owner;
  if Owner<>nil then
  begin
    List.List:=New(PCollection, Init(10,5));
    List.Selection:=0;
    if Owner^.Last <> nil then
    begin
       VV := Owner^.Last;
       repeat
          if (VV^.Options and ofSelectable<>0) and (VV<>PView(_Cursor)) then
{         if VV^.ComponentType in GMainStep then}
          PCollection(List.List)^.Insert(VV);
         VV := VV^.Prev;
       until VV = Owner^.Last;
    end;
    if ExecDialog(sTabOrderDlg, @List)<>cmCancel then
    begin
      PCollection(List.List)^.ForEach(@DoDel);
      PCollection(List.List)^.ForEach(@DoInsert);
      Message(Application, evBroadcast, cmCurentChang, Owner);
    end;
    PCollection(List.List)^.DeleteAll;
    Dispose(PCollection(List.List), Done);
  end;
end;

begin
  case c of
    cmLMBringToFront:BringToFront(true);
    cmLMSendToBack  :BringToFront(false);
    cmLMSize        :SetSize;
    cmLMTabOrder    :TabOrder;
  else
    exit;
  end;
  C:=0;
end;

procedure SetTViewOpt(V:PView; Mouse:TPoint);
var C:word;
begin
  c:=PopUpMenu(V, sTViewPopUp, Mouse);
  SetStdOpt(V,C);
end;

procedure SetReportOpt(P:PReport; Mouse:TPoint);
var c:word;
begin
  C:=PopUpMenu(P, sTReportPopUp, Mouse);
  SetStdOpt(P,C);
  if C<>0 then  Message(P, evCommand, C, nil);
end;

procedure SetDBGridOpt(P:PDBGrid; Mouse:TPoint);
var c:word;
begin
  c:=PopUpMenu(P, sTDBGridPopUp, Mouse);
  case C of
    cmDBGridFieldEditor:Application^.ExecuteDialog(New(PDBGridCollumnEditor, Init(P)),nil);
    cmClearAllFields:begin
                       P^.FieldDefs^.FreeAll;
                       P^.DrawView;
                     end;
  else
    SetStdOpt(P,C);
  end;
end;

procedure SetDBSourse(P:PDBSourse; Mouse:TPoint);
var c:word;
begin
  if not P^.Active then exit;
  c:=PopUpMenu(P, sTDBSoursePopUp, Mouse);
  case C of
    cmPrevRec, cmNextRec,
    cmFirstRec, cmLastRec:Message(P, evCommand, C, nil);
    cmDBSourseFieldEditor:NewFieldEditor(P);
    cmDBSourseNewIndexs:NewIndex(P);
    cmDBSourseIndexsEditor:Application^.ExecuteDialog(
         New(PIndexDefsDlg, Init(P)),nil);
  else
    SetStdOpt(P,C);
  end;
  P^.RecalcIndexList;
end;


{procedure SetQueryOpt(P:PQuery);
var c:word;
begin
  c:=PopUpMenu(P, sTQueryPopUp);
  case C of
    cmParamEditor:Application^.ExecuteDialog(New(PParamEditorDialog, Init(P)), nil);
    cmPrevRec, cmNextRec,
    cmFirstRec, cmLastRec:Message(P, evCommand, C, nil);
  else
    SetStdOpt(P,C);
  end;
end;}
end.
