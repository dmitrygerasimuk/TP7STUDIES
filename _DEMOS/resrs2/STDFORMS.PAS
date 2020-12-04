{$O+}
{$I Define.inc}
unit StdForms;
interface
uses Objects, Views, Dialogs, Drivers, AddCntrl, DBGrids, DAE, DataCtrl,
     DBFTable, Cursors, Querys, ColorSel, Register, DAE_Type;
const
  cmAddField       = 200;
  cmDellField      = 201;
  cmAddAllField    = 202;
  cmMoveUpField    = 203;
  cmMoveDownField  = 204;
  cmApply          = 205;
  cmFocusField     = 206;
  cmAddIndex       = 207;
  cmNewIndex       = 208;
  cmDeleteIndex    = 209;
  cmFAdd           = 210;
  cmFAddAll        = 211;
  cmFDel           = 212;
  cmFDelAll        = 213;
  cmFEdit          = 214;

type
   PResourceList = ^TResourceList;
   TResourceList = object(TListViewer)
     List:PResourceFile;
     function GetText(Item: Integer; MaxLen: Integer): String; virtual;
     procedure GetData(var Rec);virtual;
     procedure SetData(var Rec);virtual;
     function DataSize: Word; virtual;
   end;

type
   PCustomListBox = ^TCustomListBox;
   TCustomListBox = object(TListBox)
     procedure FocusItem(Item: Integer); virtual;
   end;

type
   PFDBGridListBox = ^TFDBGridListBox;
   TFDBGridListBox = object(TCustomListBox)
     function GetText(Item: Integer; MaxLen: Integer): String; virtual;
   end;

type
   PDBGridCollumnEditor = ^TDBGridCollumnEditor;
   TDBGridCollumnEditor = object(TDialog)
     DBGrid:PDBGrid;
     TitleInputLine:PInputLine;
     FiAlign:PRadioButtons;
     ListBox:PListBox;
     CurField:PDBGridField;
     constructor Init(ADBGrid:PDBGrid);
     procedure HandleEvent(var Event:TEvent);virtual;
     procedure AddField;
     procedure DellField;
     procedure AddAllField;
     procedure MoveUpField;
     procedure MoveDownField;
     procedure Apply;
     procedure FocusField;
     procedure UpdateComands;
   private
     Locked:boolean;
   end;


type
   PIDbfListBox = ^TIDbfListBox;
   TIDbfListBox = object(TCustomListBox)
     function GetText(Item: Integer; MaxLen: Integer): String; virtual;
   end;

type
   PIndexDefsDlg = ^TIndexDefsDlg;
   TIndexDefsDlg = object(TDialog)
     ListBox:PIDbfListBox;
     Dbf:PDataSet;
     DS:PDBSourse;
     constructor Init(ADS:PDBSourse);
     procedure UpdateCmd;
     procedure HandleEvent(var Event:TEvent);virtual;
     procedure AddIndex;
     procedure NewIndex;
     procedure DeleteIndex;
   end;

type
   PDataBaseWindow = ^TDataBaseWindow;
   TDataBaseWindow = object(TDialog)
     DBGrid:PDBGrid;
     DataSourse:PDBSourse;
     constructor Load(var S:TStream);
     procedure Store(var S:TStream);
     function GetTitle(MaxSize: Integer): TTitleStr; virtual;
   end;

type
   PDualListBox = ^TDualListBox;
   TDualListBox = object(TDialog)
     List1:PListBox;
     List2:PListBox;
     constructor Load(var S:TStream);
     procedure Store(var S:TStream);
     procedure HandleEvent(var Event:TEvent);virtual;
     procedure UpdataCmd;
     procedure SetData(var Rec);virtual;
   end;

type
  PParamListBox = ^TParamListBox;
  TParamListBox = object(TCustomListBox)
     function GetText(Item: Integer; MaxLen: Integer): String; virtual;
  end;

type
  PParamEditorDialog = ^TParamEditorDialog;
  TParamEditorDialog = object(TDialog)
    Query:PQuery;
    ParamListBox:PParamListBox;
    constructor Init(AQuery:PQuery);
    procedure HandleEvent(var Event:TEvent);virtual;
  end;

type
  PColorDialogBox = ^TColorDialogBox;
  TColorDialogBox = object(TDialog)
    Foreground:PColorSelector;
    Background:PColorSelector;
    ColorDisplay:PColorDisplay;
    constructor Init;
    function DataSize:word;virtual;
    procedure GetData(var Rec);virtual;
    procedure SetData(var Rec);virtual;
  end;

type
  PCreateTableDialog = ^TCreateTableDialog;
  TCreateTableDialog = object(TDialog)
    ListBox:PListBox;
    constructor Init;
    procedure HandleEvent(var Event:TEvent);virtual;
  end;

type
  PNewIndexDialog = ^TNewIndexDialog;
  TNewIndexDialog = object(TDialog)
    Label1:PLabel;
    Label2:PLabel;
    SimpleIndex:PLockUpInputLine;
    CalcIndex:PInputLine;
    procedure HandleEvent(var Event:TEvent);virtual;
    constructor Load(var S:TStream);
    procedure Store(var S:TStream);
  end;

const
  RResourceList: TStreamRec = (
     ObjType: 10050;
     VmtLink: Ofs(TypeOf(TResourceList)^);
     Load:    @TResourceList.Load;
     Store:   @TResourceList.Store
  );
const
  RDataBaseWindow: TStreamRec = (
     ObjType: 10051;
     VmtLink: Ofs(TypeOf(TDataBaseWindow)^);
     Load:    @TDataBaseWindow.Load;
     Store:   @TDataBaseWindow.Store
  );
const
  RDualListBox: TStreamRec = (
     ObjType: 10052;
     VmtLink: Ofs(TypeOf(TDualListBox)^);
     Load:    @TDualListBox.Load;
     Store:   @TDualListBox.Store
  );
const
  RNewIndexDialog: TStreamRec = (
     ObjType: 10053;
     VmtLink: Ofs(TypeOf(TNewIndexDialog)^);
     Load:    @TNewIndexDialog.Load;
     Store:   @TNewIndexDialog.Store
  );

procedure RegisterStdForms;
procedure NewIndex(DS:PDBSourse);
procedure CreateDataBase;
implementation
uses CmdConst, RsCllt, Ext_Dos, Dos, ResTools, ResStrs, MsgBox, App, Ext_Str,
     Ext_Type, Clases, Global, TVI_Unit, Ntx_Unit, IND_Unit, DBT_Unit,
     FPT_Unit, Ext_Math;

   { TFDBGridListBox }
function TFDBGridListBox.GetText(Item: Integer; MaxLen: Integer): String;
var P:PDBGridField;
    R:array [1..2] of PString;
    S:string;
begin
  P:=List^.At(Item);
  r[1]:=P^.FieldName;
  R[2]:=P^.Name;
  FormatStr(S,'%-15s :%s',R);
  GetText:=S;
end;

procedure TCustomListBox.FocusItem(Item: Integer);
begin
  inherited FocusItem(Item);
  Message(Owner, evCommand, cmFocusField, @Self);
end;

   { TDBGridCollumnEditor }
constructor TDBGridCollumnEditor.Init(ADBGrid:PDBGrid);
var R:TRect;
    P:PView;
    Form1:PDialog;
begin
   R.Assign(  7,  2, 71, 20);
   inherited Init(R,'Collumn editor');
   DBGrid:=ADBGrid;
   R.Assign( 36,  1, 37, 14);
     P:=New(PScrollBar, Init( R));
     Insert(P);
   R.Assign(  1,  1, 36, 14);
     ListBox:=New(PFDBGridListBox, Init( R, 1, PScrollBar(P)));
     ListBox^.NewList(DBGrid^.FieldDefs);
     Insert(ListBox);
   R.Assign( 38,  2, 62,  3);
     TitleInputLine:=New(PInputLine, Init( R,255));
     Insert(TitleInputLine);
   R.Assign( 44,  3, 58,  10);
     FiAlign:=Insert(New(PRadioButtons, Init(R,
        NewSItem('alNone',
        NewSItem('alTop',
        NewSItem('alBottom',
        NewSItem('alL~e~ft',
        NewSItem('al~R~ight',
        NewSItem('alClient',
        NewSItem('al~C~enter',
        nil))))))))));
     FiAlign^.EnableMask:=$59;
   R.Assign( 37,  3, 44,  4);
     Insert(New(PLabel, Init( R,'Align', FiAlign)));
   R.Assign( 51, 13, 61, 15);
     Insert(New(PButton, Init( R, '~O~k', cmOK, bfNormal)));
   R.Move(0,2);
     Insert(New(PButton, Init( R, '~H~elp', cmHelp, bfNormal)));
   R.Assign( 37,  1, 56,  2);
     Insert(New(PLabel, Init( R,'~T~itle', TitleInputLine)));
   R.Assign(  1, 15, 12, 17);
     Insert(New(PButton, Init( R, '~A~dd', cmAddField, bfNormal)));
   R.Assign( 12, 15, 23, 17);
     Insert(New(PButton, Init( R, '~D~ell', cmDellField, bfNormal)));
   R.Assign( 24, 15, 35, 17);
     Insert(New(PButton, Init( R, 'Add a~l~l', cmAddAllField, bfNormal)));
   R.Assign( 38,  11, 50, 13);
     Insert(New(PButton, Init( R, '~M~ove up', cmMoveUpField, bfNormal)));
   R.Move(0,2);
     Insert(New(PButton, Init( R, 'M~o~ve down', cmMoveDownField, bfNormal)));
   R.Move(0,2);
     Insert(New(PButton, Init( R, 'A~p~ply', cmApply, bfDefault)));
   SelectNext(false);
   UpdateComands;
   ListBox^.FocusItem(0);
end;

procedure TDBGridCollumnEditor.AddField;
var Rec:TListBoxRec;
procedure DoAdd(P:PField);far;
function DoFind(GrF:PDBGridField):boolean;far;
begin
  DoFind:=stUpCase(GrF^.FieldName^)=stUpCase(P^.Name^);
end;
begin
  if ListBox^.List^.FirstThat(@DoFind)=nil then
     PStrings(Rec.List)^.Insert(NewStr(P^.Name^))
end;
begin
  ListBox^.SetRange(ListBox^.List^.Count);
  Rec.List:=New(PStrings, Init);
  Rec.Selection:=0;
  DBGrid^.DataSourse^.FieldDefs^.ForEach(@DoAdd);
  if ExecDialog(sFieldListDlg, @Rec)<>cmCancel then
  begin
     ListBox^.List^.Insert(New(PDBGridField, Init(DBGrid,
        DBGrid^.DataSourse^.FieldByName(PStrings(Rec.List)^.Str(Rec.Selection)))));
     ListBox^.SetRange(ListBox^.List^.Count);
     ListBox^.FocusItem(ListBox^.List^.Count-1);
  end;
  UpdateComands;
end;

procedure TDBGridCollumnEditor.DellField;
begin
  ListBox^.List^.AtFree(ListBox^.Focused);
  ListBox^.SetRange(ListBox^.List^.Count);
  UpdateComands;
end;

procedure TDBGridCollumnEditor.AddAllField;
procedure DoAdd(P:PField);far;
function DoFind(GrF:PDBGridField):boolean;far;
begin
  DoFind:=stUpCase(GrF^.FieldName^)=stUpCase(P^.Name^);
end;
begin
  if ListBox^.List^.FirstThat(@DoFind)=nil then
     ListBox^.List^.Insert(New(PDBGridField, Init(DBGrid, P)));
end;
begin
  if not DBGrid^.DataSourse^.Active then exit;
  DBGrid^.DataSourse^.FieldDefs^.ForEach(@DoAdd);
  ListBox^.SetRange(ListBox^.List^.Count);
  UpdateComands;
end;

procedure TDBGridCollumnEditor.MoveUpField;
var i:integer;
begin
  i:=ListBox^.List^.IndexOf(CurField);
  ListBox^.List^.Delete(CurField);
  ListBox^.List^.AtInsert(i-1,CurField);
  ListBox^.FocusItem(i-1);
  UpdateComands;
end;

procedure TDBGridCollumnEditor.MoveDownField;
var i:integer;
begin
  i:=ListBox^.List^.IndexOf(CurField);
  ListBox^.List^.Delete(CurField);
  ListBox^.List^.AtInsert(i+1,CurField);
  ListBox^.FocusItem(i+1);
  UpdateComands;
end;

procedure TDBGridCollumnEditor.Apply;
begin
  if TitleInputLine^.Data^<>'' then
  AssignStr(CurField^.Name,TitleInputLine^.Data^);
  if ListBox^.List^.Count-1>ListBox^.Focused then
     ListBox^.FocusItem(ListBox^.Focused+1);
   UpdateComands;
end;

procedure TDBGridCollumnEditor.FocusField;
begin
  if ListBox^.List^.Count<>0 then
  begin
    CurField:=ListBox^.List^.At(ListBox^.Focused);
    TitleInputLine^.Show;
    TitleInputLine^.Data^:=CurField^.Name^;
    TitleInputLine^.SelectAll(True);
    Locked:=true;
    FiAlign^.Press(ord(CurField^.Align));
    Locked:=false;
  end
  else
  begin
    CurField:=nil;
    TitleInputLine^.Hide;
  end;
  if DBGrid^.FieldDefs^.Count<>0 then
  begin
    SetCmdState([cmMoveUpField], ListBox^.Focused<>0);
    SetCmdState([cmMoveDownField], ListBox^.Focused<>ListBox^.List^.Count-1);
  end;
  ReDraw;
end;

procedure TDBGridCollumnEditor.HandleEvent(var Event:TEvent);
procedure SetAlign;
begin
  if CurField<>nil then
     CurField^.Align:=TAlign(FiAlign^.Value);
end;
begin
  inherited HandleEvent( Event);
  case Event.What of
    evCommand:
    case Event.Command of
      cmAddField:AddField;
      cmDellField:DellField;
      cmAddAllField:AddAllField;
      cmMoveUpField:MoveUpField;
      cmMoveDownField:MoveDownField;
      cmApply   :Apply;
      cmFocusField:FocusField;
    else
      exit;
    end;
    evBroadcast:
    begin
      case Event.Command of
        cmDefault:EndModal(cmOk);
        cmClusterPress:if (Event.InfoPtr=FiAlign) and not Locked then SetAlign;
      end;
      exit;
    end;
  else
    exit;
  end;
  ClearEvent(Event);
end;

procedure TDBGridCollumnEditor.UpdateComands;
begin
   SetCmdState([cmAddField, cmAddAllField],
                DBGrid^.FieldDefs^.Count<>DBGrid^.DataSourse^.FieldDefs^.Count);
   SetCmdState([cmDellField, cmMoveUpField, cmMoveDownField, cmApply],
                            DBGrid^.FieldDefs^.Count<>0);
  if DBGrid^.FieldDefs^.Count<>0 then
  begin
    SetCmdState([cmMoveUpField], ListBox^.Focused<>0);
    SetCmdState([cmMoveDownField], ListBox^.Focused<>ListBox^.List^.Count-1);
  end;
  FocusField;
  ReDraw;
  Message(Application, evBroadcast, cmCurentChang, DBGrid^.Owner);
end;

type
  TNewIndexRec = record
    FileName:FNameStr;
    CalcIndex:Boolean;
    Reserv:byte;
    Dup:boolean;
    Reserv1:byte;
    FieldNum:Longint;
    IndexField:string;
  end;

procedure NewIndex(DS:PDBSourse);
var Rec:TNewIndexRec;
    SRec:TStatusRec;
    D:PDataSet;
    P:PNewIndexDialog;
    Line:PLockUpInputLine;
    IO:TIndexOptions;
    S:string;
    i:integer;

procedure DoAdd(P:PField);far;
begin
  if not P^.Calculated then
    Line^.List^.AtInsert(Line^.List^.Count, NewStr(P^.Name^));
end;

begin
  D:=DS^.DataSet;
  if D=nil then exit;
  P:=PNewIndexDialog(ResourseFile.Get(sCreateIndexDlg));

  Line:=P^.FindComponent('SimpleIndex');
  Line^.List^.FreeAll;
  DS^.FieldDefs^.ForEach(@DoAdd);
  FillChar(Rec, SizeOf(TNewIndexRec), 0);
  FillChar(SRec, SizeOf(TStatusRec), 0);
  Rec.Dup:=true;
  if Application^.ExecuteDialog(P, @Rec)<>cmCancel then
    if (Rec.FileName<>'') and ValidFileName(FullName(Rec.FileName)) and
       ((Rec.IndexField<>'') or (Rec.FieldNum<>-1)) then
    begin
      DoReindex:=ReIndex;
      if DS^.DatabaseName<>nil then
         S:=Session^.ByAlias(DS^.DatabaseName^)+Rec.FileName
      else S:=Rec.FileName;
      SatatusDialog:=PWindow(ResourseFile.Get(sReindexsForm));
      SRec.P:=@(S);
      SRec.MaxValue:=D^.RecordCount; SRec.MaxValue1:=D^.RecordCount;
      SatatusDialog^.SetData(SRec);
      Application^.Insert(SatatusDialog);
      IO:=[];
      if Rec.Dup then IO:=IO+[ixUnique];
      if not Rec.CalcIndex then Rec.IndexField:=DS^.Fields(Rec.FieldNum)^.Name^;
      D^.CreateIndex(S, Rec.IndexField, io);
      SatatusDialog^.free;
      SatatusDialog:=nil;
      DoReindex:=nil;
      DS^.RecalcIndexList;
    end;
end;

   { TIDbfListBox }
function TIDbfListBox.GetText(Item: Integer; MaxLen: Integer): String;
var P:PIndexObject;
    S,S1:String;
    A:array [1..2] of PString;
    Dir: DirStr;
    Name: NameStr;
    Ext: ExtStr;
begin
   P:=List^.At(Item);
   A[1]:=@Name; A[2]:=@S1;
   FSplit(P^.FileName^, Dir, Name, Ext);
   S1:=FNameReduce(P^.FileName^, 26);
   FormatStr(S,'%-8s in %s',A);
   GetText:=S;
end;

   { TIndexDefsDlg }
constructor TIndexDefsDlg.Init(ADS:PDBSourse);
var R:TRect;
    ScrollBar1:PScrollBar;
    Form1:PDialog;
begin
   R.Assign( 10,  5, 66, 20);
   inherited Init(R,'Index defs...');
   DS:=ADS;
   Dbf:=DS^.DataSet;
   R.Assign( 38,  1, 39, 14);
     ScrollBar1:=New(PScrollBar, Init( R));
     Insert(ScrollBar1);
   R.Assign(  1,  1, 38, 14);
     ListBox:=New(PIDbfListBox, Init( R,1,ScrollBar1));
     ListBox^.NewList(Dbf^.IndexDefs);
     Insert(ListBox);
   R.Assign( 41,  2, 52,  4);
     Insert(New(PButton, Init( R, '~A~dd', cmAddIndex, bfNormal)));
   R.Assign( 41,  4, 52,  6);
     Insert(New(PButton, Init( R, '~N~ew', cmNewIndex, bfNormal)));
   R.Assign( 41,  6, 52,  8);
     Insert(New(PButton, Init( R, '~D~elete', cmDeleteIndex, bfNormal)));
   R.Assign( 41, 10, 52, 12);
     Insert(New(PButton, Init( R, '~O~k', cmOk, bfDefault)));
   R.Assign( 41, 12, 52, 14);
     Insert(New(PButton, Init( R, '~H~elp', cmError, bfNormal)));
   SelectNext(false);
end;

procedure TIndexDefsDlg.UpdateCmd;
begin
   DS^.RecalcIndexList;
   SetCmdState([cmDeleteIndex], Dbf^.IndexDefs^.Count<>0);
   ReDraw;
end;

procedure TIndexDefsDlg.HandleEvent(var Event:TEvent);
begin
  inherited HandleEvent( Event);
  case Event.What of
    evCommand:
    case Event.Command of
      cmAddIndex:AddIndex;
      cmNewIndex:NewIndex;
      cmDeleteIndex:DeleteIndex;
    else
      exit;
    end;
  else
    exit;
  end;
  ClearEvent(Event);
end;

procedure TIndexDefsDlg.AddIndex;
var FName:FNameStr;
    P:Pointer;
begin
  FName:='*'+DefIndexExt;
  if DS^.DatabaseName<>nil then
     FName:=Session^.ByAlias(DS^.DatabaseName^)+FName;
  if ExecDialog(stUpCase(DefIndexExt),@FName)<>cmCancel then
  begin
     Dbf^.OpenIndex( FName);
     ListBox^.SetRange(ListBox^.List^.Count);
     UpdateCmd;
  end;
end;

procedure TIndexDefsDlg.NewIndex;
begin
  StdForms.NewIndex(DS);
  ListBox^.SetRange(ListBox^.List^.Count);
  UpdateCmd;
end;

procedure TIndexDefsDlg.DeleteIndex;
var P:PIndexObject;
begin
  P:=ListBox^.List^.At(ListBox^.Focused);
  if Dbf^.Index=P then
     Dbf^.Index:=nil;
  ListBox^.List^.AtFree(ListBox^.Focused);
  ListBox^.SetRange(ListBox^.List^.Count);
  UpdateCmd;
end;

 { TResourceList }
function TResourceList.GetText(Item: Integer; MaxLen: Integer): String;
begin
  GetText:=List^.KeyAt(Item);
end;

procedure TResourceList.GetData(var Rec);
var A:TListBoxRec absolute Rec;
begin
  A.Selection:=Focused;
end;

procedure TResourceList.SetData(var Rec);
var A:TListBoxRec absolute Rec;
begin
  List:=A.List;
  if List<>nil then SetRange(List^.Count)
  else SetRange(0);
  FocusItem(A.Selection);
end;

function TResourceList.DataSize: Word;
begin
  DataSize:=SizeOf(TListBoxRec);
end;

   { TDataBaseWindow }
constructor TDataBaseWindow.Load(var S:TStream);
begin
  inherited Load(S);
  GetSubViewPtr(S,DBGrid);
  GetSubViewPtr(S,DataSourse);
end;

procedure TDataBaseWindow.Store(var S:TStream);
begin
  inherited Store(S);
  PutSubViewPtr(S,DBGrid);
  PutSubViewPtr(S,DataSourse);
end;

function TDataBaseWindow.GetTitle(MaxSize: Integer): TTitleStr;
begin
  if (DataSourse<>nil) and DataSourse^.Active then
  begin
{     if DataSourse^.DeletedRec then GetTitle:=DataSourse^.TableName^+'  Удалена'
     else }
     GetTitle:=DataSourse^.TableName^;
  end
  else GetTitle:=inherited GetTitle(MaxSize);
end;


 { TDualListBox }
constructor TDualListBox.Load(var S:TStream);
begin
  inherited Load(S);
  GetSubViewPtr(S,List1);
  GetSubViewPtr(S,List2);
end;

procedure TDualListBox.Store(var S:TStream);
begin
  inherited Store(S);
  PutSubViewPtr(S,List1);
  PutSubViewPtr(S,List2);
end;

procedure TDualListBox.UpdataCmd;
begin
  if (List1<>nil) and (List2<>nil) then
  begin
    SetCmdState([cmFAdd,cmFAddAll], List1^.List^.Count<>0);
    SetCmdState([cmFDel,cmFDelAll], List2^.List^.Count<>0);
    List1^.SetRange(List1^.LIst^.Count);
    List2^.SetRange(List2^.LIst^.Count);
  end
  else SetCmdState([cmFAdd,cmFAddAll, cmFDel,cmFDelAll], false);
  ReDraw;
end;

procedure TDualListBox.HandleEvent(var Event:TEvent);
procedure FAdd;
begin
  if List1^.List^.Count=0 then exit;
  List2^.List^.Insert(List1^.List^.At(List1^.Focused));
  List1^.List^.AtDelete(List1^.Focused);
  UpdataCmd;
end;

procedure FAddAll;
procedure DoAdd(Item:Pointer);far;
begin
  List2^.List^.Insert(Item);
end;
begin
  if List1^.List^.Count=0 then exit;
  List1^.List^.ForEach(@DoAdd);
  List1^.List^.DeleteAll;
  UpdataCmd;
end;

procedure FDel;
begin
  if List2^.List^.Count=0 then exit;
  List1^.List^.Insert(List2^.List^.At(List2^.Focused));
  List2^.List^.AtDelete(List2^.Focused);
  UpdataCmd;
end;

procedure FDelAll;
procedure DoAdd(Item:Pointer);far;
begin
  List1^.List^.Insert(Item);
end;
begin
  if List2^.List^.Count=0 then exit;
  List2^.List^.ForEach(@DoAdd);
  List2^.List^.DeleteAll;
  UpdataCmd;
end;


begin
  inherited HandleEvent(Event);
  case Event.What of
    evCommand:
    case Event.Command of
       cmFAdd:FAdd;
       cmFAddAll:FAddAll;
       cmFDel:FDel;
       cmFDelAll:FDelAll;
    else
      exit;
    end;
  else
    exit;
  end;
  ClearEvent(Event);
end;

procedure TDualListBox.SetData(var Rec);
begin
  inherited SetData(Rec);
  UpdataCmd;
end;

  { TParamListBox }
function TParamListBox.GetText(Item: Integer; MaxLen: Integer): String;
{var P:PParam;
    S1,S2:string;
    A:array [1..2] of PString;}
begin
{  if List=nil then} GetText:=''
{  else
  begin
    A[1]:=@S1;A[2]:=@S2;
    P:=List^.At(Item);
    S1:=P^.Name;
    S2:=P^.AsString;
    GetText:=StrFormat('%-22s = %-20s',A);
  end;}
end;

{type
   TAddParamRecord = record
      Name:string[80];
      Value:string[80];
   end;}

  { TParamEditorDialog }
constructor TParamEditorDialog.Init(AQuery:PQuery);
var R:TRect;
    ScrollBar:PScrollBar;
begin
   R.Assign( 11,  2, 73, 17);
   if AQuery=nil then fail;
   inherited Init(R,'Params list');
   Query:=AQuery;
   R.Assign( 49,  1, 50, 14);
     ScrollBar:=New(PScrollBar, Init( R));
     Insert(ScrollBar);
{   R.Assign(  1,  1, 49, 14);
     ParamListBox:=New(PParamListBox, Init( R ,1, ScrollBar));
     ParamListBox^.NewList(Query^.Params);
     Insert(ParamListBox);}
   R.Assign( 50,  2, 61,  4);
     Insert(New(PButton, Init( R , '~O~k', cmOK, bfDefault)));
   R.Assign( 50,  6, 61,  8);
     Insert(New(PButton, Init( R , '~I~nsert', cmAddField, bfNormal)));
   R.Assign( 50,  8, 61, 10);
     Insert(New(PButton, Init( R , '~D~elete', cmDellField, bfNormal)));
   R.Assign( 50, 12, 61, 14);
     Insert(New(PButton, Init( R , '~H~elp', cmHelp, bfNormal)));
   SelectNext(false);
   SetCmdState([cmDellField],ParamListBox^.List^.Count<>0);
end;

procedure TParamEditorDialog.HandleEvent(var Event:TEvent);
{procedure UpdateComands;
begin
   SetCmdState([cmDellField],ParamListBox^.List^.Count<>0);
   ParamListBox^.SetRange(Query^.Params^.Count);
   ParamListBox^.DrawView;
   Message(Application, evBroadcast, cmCurentChang, Query^.Owner);
end;

procedure EditCur;
var Rec:TAddParamRecord;
    P:PParam;
begin
  P:=ParamListBox^.List^.At(ParamListBox^.Focused);
  Rec.Name:=P^.Name;
  Rec.Value:=P^.AsString;
  if (RExecDialog(sParamsProperty, @Rec)<>cmCancel) and (Rec.Name<>'') then
  begin
    Query^.Params^.Delete(P);
    P^.Free;
    P:=New(PParam, Init(Rec.Name));
    P^.SetAsString(Rec.Value);
    Query^.Params^.Insert(P);
  end;
  UpdateComands;
end;

procedure AddParam;
var Rec:TAddParamRecord;
    P:PParam;
begin
  FillChar(Rec, SizeOf(TAddParamRecord), 0);
  if (RExecDialog(sParamsProperty, @Rec)<>cmCancel) and (Rec.Name<>'') then
  begin
    P:=New(PParam, Init(Rec.Name));
    P^.SetAsString(Rec.Value);
    Query^.Params^.Insert(P);
  end;
  UpdateComands;
end;

procedure DelParam;
var Rec:TAddParamRecord;
    P:PParam;
    S:String;
    PS:PString;
begin
  if ParamListBox^.List^.Count=0 then exit;
  P:=ParamListBox^.List^.At(ParamListBox^.Focused);
  S:=P^.Name;
  PS:=@S;
  if RMessageBox(sConfirmDeleteParam, @PS, mfConfirmation+mfOkCancel)<>cmCancel then
  begin
    Query^.Params^.Delete(P);
    P^.Free;
  end;
  UpdateComands;
end;}

begin
  inherited HandleEvent(Event);
{  case Event.What of
    evBroadcast:
    case Event.Command of
      cmListItemSelected:EditCur;
    else
      exit;
    end;
    evCommand:
    case Event.Command of
      cmAddField:AddParam;
      cmDellField:DelParam;
    else
      exit;
    end;
  else
    exit;
  end;
  ClearEvent(Event);}
end;

procedure RegisterStdForms;
begin
  RegisterType(RResourceList);
  RegisterType(RDataBaseWindow);
  RegisterType(RDualListBox);
  RegisterType(RNewIndexDialog);
end;

  { TColorDialogBox }
constructor TColorDialogBox.Init;
var R:TRect;
    Label2:PLabel;
    P:PView;
begin
   R.Assign( 31,  5, 71, 18);
   inherited Init(R,'Select color');
   R.Assign(  5,  2, 17,  6);
     Background:=Insert(New(PColorSelector, Init( R ,csBackground)));
   R.Assign(  5,  1, 10,  2);
     Insert(New(PLabel, Init( R ,'~Ф~он', Background)));
   R.Assign( 24,  2, 36,  6);
     Foreground:=Insert(New(PColorSelector, Init( R ,csForeground)));
     Foreground^.Options:=Foreground^.Options or ofFramed;
   R.Assign( 25,  1, 35,  2);
     Insert(New(PLabel, Init( R ,'~С~имвол', Foreground)));
   R.Assign(  5,  7, 36,  9);
     ColorDisplay:=New(PColorDisplay, Init( R, NewStr(' Образец выбора')));
     Insert(ColorDisplay);
     ColorDisplay^.Options:=ColorDisplay^.Options or ofFramed;
   R.Assign(  3, 10, 14, 12);
     Insert(New(PButton, Init( R , '~O~k', cmOK, bfDefault)));
   R.Assign( 15, 10, 26, 12);
     Insert(New(PButton, Init( R , 'Cancel', cmCancel, bfNormal)));
   R.Assign( 27, 10, 38, 12);
     Insert(New(PButton, Init( R , '~H~elp', cmHelp, bfNormal)));
      SelectNext(false);
end;

function TColorDialogBox.DataSize:word;
begin
  DataSize:=SizeOf(Byte);
end;

procedure TColorDialogBox.GetData(var Rec);
var Color:byte absolute Rec;
begin
  Color:=(Background^.Color shl 4 and $F0) or (Foreground^.Color and $0F)
end;

procedure TColorDialogBox.SetData(var Rec);
var Color:byte absolute Rec;
begin
  Message(@Self, evBroadcast, cmColorSet, Pointer(Color));
end;


type
   Form2Record=record
      InputLine1:string[10];
      RangeILine1:Longint;
      RangeILine2:Longint;
      RadioButtons1:word;
   end;

  { TCreateTableDialog }
constructor TCreateTableDialog.Init;
var R:TRect;
    ScrollBar:PScrollBar;
    P:PView;
begin
   R.Assign( 15,  2, 67, 19);
   inherited Init(R,'Создаём структуру');
   R.Assign( 36,  2, 37, 13);
     ScrollBar:=Insert(New(PScrollBar, Init( R)));
   R.Assign(  1,  2, 36, 13);
     ListBox:=Insert(New(PListBox, Init( R ,1, ScrollBar)));
   R.Assign(  1,  1, 36,  2);
     Insert(New(PLabel, Init( R ,'~И~мя        |Тип|Длинна|Десят.', ListBox)));
   R.Assign(  4, 14, 32, 15);
     P:=Insert(New(PLockUpInputLine, Init( R ,
               NewSItem('DBase II',
               NewSItem('DBase III Plus',
               NewSItem('DBase IV',
               NewSItem('DBase for Windows',
               NewSItem('Foxpro for Dos',
               NewSItem('Foxpro for Windows',
               NewSItem('DBase VII',
               nil))))))))));
   R.Assign(  1, 13, 20, 14);
     Insert(New(PLabel, Init( R ,'~Т~ип таблицы', P)));
   R.Assign(  2, 15, 34, 16);
     Insert(New(PCheckBoxes, Init( R ,
                  NewSItem('~О~тобразить таблицу',
                  nil))));
   R.Assign( 38,  1, 49,  3);
     Insert(New(PButton, Init( R , '~O~k', cmOK, bfDefault)));
   R.Assign( 38,  3, 49,  5);
     Insert(New(PButton, Init( R , 'Cancel', cmCancel, bfNormal)));
   R.Assign( 38,  7, 49,  9);
     Insert(New(PButton, Init( R , '~A~dd', cmFAdd, bfNormal)));
   R.Assign( 38,  9, 49, 11);
     Insert(New(PButton, Init( R , '~D~ell', cmFDel, bfNormal)));
   R.Assign( 38, 11, 49, 13);
     Insert(New(PButton, Init( R , '~E~dit', cmFEdit, bfNormal)));
   R.Assign( 38, 14, 49, 16);
     Insert(New(PButton, Init( R , '~H~elp', cmHelp, bfNormal)));
   SelectNext(false);
end;

procedure TCreateTableDialog.HandleEvent(var Event:TEvent);

procedure Update;
begin
  ListBox^.SetRange(ListBox^.List^.Count);
  ListBox^.DrawView;
end;

procedure FAdd;
var Rec:Form2Record;
    S,S1:string;
begin
  FillChar(Rec, SizeOf(Form2Record), 0);
  if ExecDialog(sNewDBFieldDialog, @Rec)<>cmCancel then
  begin
    S:=FillSpaceA(Rec.InputLine1,11)+'|';
    S1:='CNDLxM';
    S:=S+' '+S1[Rec.RadioButtons1+1]+' |  ';
    Str(Rec.RangeILine1:3,S1);
    S:=S+S1+' | ';
    Str(Rec.RangeILine2:2,S1);
    S:=S+S1;
    ListBox^.List^.Insert(NewStr(S));
  end;
end;

procedure FDel;
begin
  if ListBox^.List^.Count=0 then exit;
  ListBox^.List^.AtFree(ListBox^.Focused);
end;

procedure FEdit;
var Rec:Form2Record;
    S,S1:string;
begin
  if ListBox^.List^.Count=0 then exit;
  S:=PString(ListBox^.List^.At(ListBox^.Focused))^;
  case S[14] of
    'C':Rec.RadioButtons1:=0;
    'N':Rec.RadioButtons1:=1;
    'D':Rec.RadioButtons1:=2;
    'L':Rec.RadioButtons1:=3;
    'M':Rec.RadioButtons1:=5;
  end;
  Rec.InputLine1:=Trim(Copy(S,1,10));
  Rec.RangeILine1:=StrToInt(Trim(Copy(S,19,3)));
  Rec.RangeILine2:=StrToInt(Trim(Copy(S,25,2)));
  if ExecDialog(sNewDBFieldDialog, @Rec)<>cmCancel then
  begin
    S:=FillSpaceA(Rec.InputLine1,11)+'|';
    S1:='CNDLxM';
    S:=S+' '+S1[Rec.RadioButtons1+1]+' |  ';
    Str(Rec.RangeILine1:3,S1);
    S:=S+S1+' | ';
    Str(Rec.RangeILine2:2,S1);
    S:=S+S1;
    ListBox^.List^.AtFree(ListBox^.Focused);
    ListBox^.List^.AtInsert(ListBox^.Focused,NewStr(S));
  end;
end;

begin
  inherited HandleEvent(Event);
  case Event.What of
    evCommand:
    case Event.Command of
       cmFAdd:FAdd;
       cmFDel:FDel;
       cmFEdit:FEdit;
    else
      exit;
    end;
  else
    exit;
  end;
  Update;
end;

type
   NewTableRecord=record
      ListBox:TListBoxRec;
      BDType:Longint;
      DisplayTable:word;
   end;

procedure CreateDataBase;
var Rec:NewTableRecord;
    List:PStrings;
    cDBF:PDBFTableConstructor;
    TableName:FNameStr;
    Version:byte;
    i:integer;
procedure DoAddField(P:PString);
var fType:TFieldType;
begin
  case P^[14] of
    'C':fType:=ftString;
    'N':fType:=ftFloat;
    'D':fType:=ftDateTime;
    'L':fType:=ftBoolean;
    'M':fType:=ftMemo;
  end;
  cDbf^.AddField(Trim(Copy(P^,1,10)),fType,StrToInt(Trim(Copy(P^,19,3))),StrToInt(Trim(Copy(P^,25,2))));
end;
begin
  List:=New(PStrings, Init);
  FillChar(Rec, SizeOf(NewTableRecord), 0);
  Rec.ListBox.List:=List;
  TableName:='*.dbf';
  if (Application^.ExecuteDialog(New(PCreateTableDialog, init),@Rec)<>cmCancel) and
     (List^.Count<>0) and
     (ExecDialog(sDBFCreateDialog, @TableName)<>cmCancel) then
  begin
    case Rec.BDType of
      0:Version:=verDBase2;
      6:Version:=verDBase7
    else
      Version:=verDBase3;
    end;
    for i:=0 to List^.Count-1 do
      if ((Copy(List^.Str(i),14,1)='M') and (Rec.BDType in [5,6])) then
        Version:=verFoxPro2XMemo;
    cDBF:=New(PDBFTableConstructor, Init(TableName, Version, 0));
    for i:=0 to List^.Count-1 do DoAddField(List^.At(i));
    if (cDbf^.CreateTable<>nil) and (Rec.DisplayTable<>0) then
       OpenDataWnd(TableName);
    cDBF^.Free;
  end;
  Dispose(List, Done);
end;

  { TNewIndexDialog }
procedure TNewIndexDialog.HandleEvent(var Event:TEvent);

procedure ClusterPress;
var P:PCheckBoxes;
begin
   P:=Event.InfoPtr;
   if P^.ComponentName=nil then exit;
   Lock;
   Label1^.SetState(sfVisible, P^.Value=0);
   SimpleIndex^.SetState(sfVisible, P^.Value=0);
   Label2^.SetState(sfVisible, P^.Value=1);
   CalcIndex^.SetState(sfVisible, P^.Value=1);
   P^.Select;
   UnLock;
end;

begin
  inherited HandleEvent(Event);
  if (Event.What=evBroadcast) and (Event.Command=cmClusterPress) then
     ClusterPress;
end;

constructor TNewIndexDialog.Load(var S:TStream);
begin
  inherited Load(S);
  GetSubViewPtr(S,Label1);
  GetSubViewPtr(S,Label2);
  GetSubViewPtr(S,SimpleIndex);
  GetSubViewPtr(S,CalcIndex);
end;

procedure TNewIndexDialog.Store(var S:TStream);
begin
  inherited Store(S);
  PutSubViewPtr(S,Label1);
  PutSubViewPtr(S,Label2);
  PutSubViewPtr(S,SimpleIndex);
  PutSubViewPtr(S,CalcIndex);
end;

end.
