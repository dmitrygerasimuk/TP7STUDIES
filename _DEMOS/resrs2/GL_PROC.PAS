{$O+}
{$I Define.inc}
unit GL_Proc;
interface
uses Ext_Type, Prperty, Views, Dialogs, Clases, Objects, Drivers, Global,
     VMM, Reports;

function GetViewNameReordr(Sender:PListViewer;Item:Integer;MaxLen:Integer):string;far;

function Views_GetTextHlpCtx(Sender:PProperty; View:PView):string;far;
procedure Views_EditHelpCtx(Sender:PProperty; View:PView; Owner:PListBox);far;
procedure AfterEditGrowMode(Sender:PProperty; View:PView);far;
procedure AfterEditStaticText_Text(Sender:PProperty; View:PView);far;

function GetTextDBTextField(Sender:PProperty; View:PView):string;far;
procedure EditDBTextField(Sender:PProperty; View:PView; Owner:PListBox);far;

function GetTextDBMemoField(Sender:PProperty; View:PView):string;far;
procedure EditDBMemoField(Sender:PProperty; View:PView; Owner:PListBox);far;

function GetTextReportMemoField(Sender:PProperty; View:PView):string;far;
procedure EditReportMemoField(Sender:PProperty; View:PView; Owner:PListBox);far;

function GetTextDBLookupComboField(Sender:PProperty; View:PView):string;far;
procedure EditDBLookupComboField(Sender:PProperty; View:PView; Owner:PListBox);far;

procedure EditReports_Band(Sender:PProperty; View:PView);far;
procedure AfterEditRB_Detail(Sender:PProperty; View:PView);far;
procedure AfterEditGroupBand_GroupExpresion(Sender:PProperty; View:PView);far;

function GetTextDBEditField(Sender:PProperty; View:PView):string;far;
procedure EditDBEditField(Sender:PProperty; View:PView; Owner:PListBox);far;

procedure AfterEditDBGrid_DS(Sender:PProperty; View:PView);far;
procedure EditView_State(Sender:PProperty; View:PView; Owner:PListBox);far;

function GetTextDataSourseActive(Sender:PProperty; View:PView):string;far;
procedure EditDataSourseActive(Sender:PProperty; View:PView; Owner:PListBox);far;

{procedure AfterEditLabel_Link(Sender:PProperty; View:PView);far;}
procedure AfterEditListBox_ScrollBar(Sender:PProperty; View:PView);far;

function GetTextDataSourse_RecordCount(Sender:PProperty; View:PView):string;far;

function GetTextDBGrid_FieldDefs(Sender:PProperty; View:PView):string;far;
procedure EditDBGrid_FieldDefs(Sender:PProperty; View:PView; Owner:PListBox);far;

procedure Edit_TableName(Sender:PProperty; View:PView; Owner:PListBox);far;
function GetText_TableName(Sender:PProperty; View:PView):string;far;
procedure Edit_DatabaseName(Sender:PProperty; View:PView; Owner:PListBox);far;

function GetTextDBSourse_IndexName(Sender:PProperty; View:PView):string;far;
procedure EditDBSourse_IndexName(Sender:PProperty; View:PView; Owner:PListBox);far;
procedure EditDBSourse_IndexDefs(Sender:PProperty; View:PView; Owner:PListBox);far;
function GetTextDataSourse_MasterField(Sender:PProperty; View:PView):string;far;
procedure EditDataSourse_MasterField(Sender:PProperty; View:PView; Owner:PListBox);
procedure AfterEditDS_Master(Sender:PProperty; View:PView);far;
procedure Edit_FieldDefs(Sender:PProperty; View:PView; Owner:PListBox);far;

procedure AfterEditButton_Flags(Sender:PProperty; View:PView);far;
procedure AfterEditButton_Command(Sender:PProperty; View:PView);far;

procedure AE_ReportLabel_RLStyle(Sender:PProperty; View:PView);far;

function GetTextInputLine_Validator(Sender:PProperty; View:PView):string;far;
procedure EditInputLine_Validator(Sender:PProperty; View:PView; Owner:PListBox);far;
procedure AfterEditInputLine_MaxLen(Sender:PProperty; View:PView);far;
procedure BeforeEditInputLine_MaxLen(Sender:PProperty; View:PView);far;

function GetTextDBClusterField(Sender:PProperty; View:PView):string;far;
procedure EditDBClusterField(Sender:PProperty; View:PView; Owner:PListBox);far;
procedure DBCB_AfterE_VC(Sender:PProperty; View:PView);far;
function GetTextDBCB_Strings(Sender:PProperty; View:PView):string;far;
procedure EditDBCB_Strings(Sender:PProperty; View:PView; Owner:PListBox);far;

function GetTextForm_ProcName(Sender:PProperty; View:PView):string;far;
procedure EditForm_ProcName(Sender:PProperty; View:PView; Owner:PListBox);far;
function GetTextForm_UnitName(Sender:PProperty; View:PView):string;far;
procedure EditForm_UnitName(Sender:PProperty; View:PView; Owner:PListBox);far;
function GetTextForm_ResName(Sender:PProperty; View:PView):string;far;
procedure EditForm_ResName(Sender:PProperty; View:PView; Owner:PListBox);far;
procedure AfterEditComponentNameDialog(Sender:PProperty; View:PView);far;
function GetTextForm_Current(Sender:PProperty; View:PView):string;far;
procedure EditForm_Current(Sender:PProperty; View:PView; Owner:PListBox);far;

procedure CreateIndexPageDlg(Sender:PObject);far;
procedure DestroyIndexPageDlg(Sender:PObject);far;
function IndDldGetText(Sender:PListViewer;Item:Integer;MaxLen:Integer):string;far;

procedure HandleEventDBWindow(Sender: PView; var Event: TEvent;
                                         EventTime:TEventTime);far;

procedure HandleEventTabOrderListBox(Sender: PView; var Event: TEvent;
                                         EventTime:TEventTime);far;

procedure HandleEventAddHelpFileListBox(Sender: PView; var Event: TEvent;
                                         EventTime:TEventTime);far;

function ValidComponentName(Sender:PProperty; View:PView; Info:Pointer):boolean;far;

procedure AfterEditParamText_Text(Sender:PProperty; View:PView);far;

function GetTextQuery_Text(Sender:PProperty; View:PView):string;far;
procedure EditQuery_Text(Sender:PProperty; View:PView; Owner:PListBox);far;
function GetTextQuery_ParamCount(Sender:PProperty; View:PView):string;far;
function GetTextQuery_Params(Sender:PProperty; View:PView):string;far;
procedure EditQuery_Params(Sender:PProperty; View:PView; Owner:PListBox);far;
procedure EditColorText(Sender:PProperty; View:PView; Owner:PListBox);far;

function AliasViewGetTextEvent(Sender:PListViewer;Item:Integer;MaxLen:Integer):string;far;
procedure AliasViewSetData(Sender:PView; var Data);far;
procedure AliasViewHandleEvent(Sender:PView;var Event:TEvent;EventTime:TEventTime);far;

procedure AfterEditDirListBox_Dir(Sender:PProperty; View:PView);far;

procedure PrinterSetupEvent(Report:PReport);

procedure HandleEventCodeEditor(Sender: PView; var Event: TEvent;
                                         EventTime:TEventTime);far;

procedure RegisterGL_Proc;
implementation
uses DataCtrl, DBCtrls, AddCntrl, DAE, Ext_Str, DBGrids, Ext_Dos,
     Ext_Math, App, StdForms, DBFTable, ResTools, Validate, RsCllt, Dos,
     ResStrs, MsgBox, CmdConst, CrElem, PropEdit, Cursors, RESHELP,
     Ext_App, Set_Opt, GlType, Ext_Help, Querys, Strings, Editors,
     StdDlg, Field_Ed, Ext_Hlp, Res2Help, Register, Ext_Edit;

var temp:integer;

function GetTextDBTextField(Sender:PProperty; View:PView):string;
var DBText:PDBText absolute View;
begin
  if DBText^.Field<>nil then GetTextDBTextField:=DBText^.Field^.Name^
  else GetTextDBTextField:='';
end;

function GetTextDBMemoField(Sender:PProperty; View:PView):string;
var DBMemo:PDBMemo absolute View;
begin
  if DBMemo^.Field<>nil then GetTextDBMemoField:=DBMemo^.Field^.Name^
  else GetTextDBMemoField:='';
end;

function GetTextReportMemoField(Sender:PProperty; View:PView):string;
var DBText:PReportMemo absolute View;
begin
  if DBText^.Field<>nil then GetTextReportMemoField:=DBText^.Field^.Name^
  else GetTextReportMemoField:='';
end;

function CreateListField(Sender:PProperty; DS:PDataSourse; CurField:PField;
                         Owner:PListBox; var PL:PLockUpInputLine):Longint;
var i,l:longint;
    R:TRect;
procedure DoAdd(P:PField);far;
begin
  if P=CurField then L:=i;
  PL^.List^.AtInsert(i, NewStr(P^.Name^));
  inc(i);
end;
begin
  with Owner^ do
  R.Assign(Origin.X+Length(Sender^.Name^)+2, Origin.Y+Focused-TopItem,
           Origin.X+Size.X, Origin.Y+Focused-TopItem+1);
  PL:=New(PLockUpInputLine, Init(R,nil));
  CreateListField:=-1;
  if (DS=nil) or not DS^.Active then exit;
  i:=0;
  DS^.FieldDefs^.ForEach(@DoAdd);
  PL^.SetData(L);
  CreateListField:=L;
end;

procedure EditDBTextField(Sender:PProperty; View:PView; Owner:PListBox);
var L:longint;
    i:integer;
    P:PLockUpInputLine;
    DBText:PDBText absolute View;
    S:string;
begin
  L:=CreateListField(Sender, DBText^.DS, DBText^.Field, Owner, P);
  if Owner^.Owner^.ExecView(P)=cmOk then
  begin
    P^.GetData(L);
    if L=-1 then DBText^.Field:=nil
    else
    if DBText^.DS^.Active then DBText^.Field:=DBText^.DS^.Fields(L)
    else DBText^.Field:=nil;
    if DBText^.Field=nil then
    begin
      DisposeStr(DBText^.FieldName);
      DBText^.FieldName:=nil;
      S:='';
    end
    else
    begin
      AssignStr(DBText^.FieldName, DBText^.Field^.Name^);
      S:=DBText^.Field^.Name^;
    end;
    AssignStr(DBText^.Text, S);
  end;
  P^.Free;
end;

procedure EditDBMemoField(Sender:PProperty; View:PView; Owner:PListBox);
var L:longint;
    i:integer;
    P:PLockUpInputLine;
    DBMemo:PDBMemo absolute View;
begin
  L:=CreateListField(Sender, DBMemo^.DataSourse, DBMemo^.Field, Owner, P);
  if Owner^.Owner^.ExecView(P)=cmOk then
  begin
    P^.GetData(L);
    if L=-1 then DBMemo^.Field:=nil
    else
    if DBMemo^.DataSourse^.Active then DBMemo^.Field:=DBMemo^.DataSourse^.Fields(L)
    else DBMemo^.Field:=nil;
    if DBMemo^.Field=nil then
    begin
      DisposeStr(DBMemo^.FieldName);
      DBMemo^.FieldName:=nil;
    end
    else
      AssignStr(DBMemo^.FieldName, DBMemo^.Field^.Name^);
  end;
  P^.Free;
end;

procedure EditReportMemoField(Sender:PProperty; View:PView; Owner:PListBox);
var L:longint;
    i:integer;
    P:PLockUpInputLine;
    ReportMemo:PReportMemo absolute View;
    S:string;
begin
  L:=CreateListField(Sender, ReportMemo^.DS, ReportMemo^.Field, Owner, P);
  if Owner^.Owner^.ExecView(P)=cmOk then
  begin
    P^.GetData(L);
    if L=-1 then ReportMemo^.Field:=nil
    else
    if ReportMemo^.DS^.Active then ReportMemo^.Field:=ReportMemo^.DS^.Fields(L)
    else ReportMemo^.Field:=nil;
    if ReportMemo^.Field=nil then
    begin
      DisposeStr(ReportMemo^.FieldName);
      ReportMemo^.FieldName:=nil;
      S:='';
    end
    else
    begin
      AssignStr(ReportMemo^.FieldName, ReportMemo^.Field^.Name^);
      S:=ReportMemo^.Field^.Name^;
    end;
{    AssignStr(DBText^.Text, S);}
    ReportMemo^.UpDate;
  end;
  P^.Free;
end;

function GetTextDBLookupComboField(Sender:PProperty; View:PView):string;
var P:PDBLookupCombo absolute View;
    F:PField;
begin
{  case Sender^.Offset of
    ofsTView+8 :F:=P^.DataField;
    ofsTView+12:F:=P^.LookupField;
    ofsTView+16:F:=P^.LookupDisplay;
  end;}
  if F<>nil then GetTextDBLookupComboField:=F^.Name^
  else GetTextDBLookupComboField:='';
end;

procedure EditDBLookupComboField(Sender:PProperty; View:PView; Owner:PListBox);
var DBL:PDBLookupCombo absolute View;
    DS:PDataSourse;
    F:PField;
    L:longint;
    i:integer;
    P:PLockUpInputLine;
begin
{  case Sender^.Offset of
    ofsTView+8 :DS:=DBL^.DataSourse;
    ofsTView+12,
    ofsTView+16:DS:=DBL^.LookupSourse;
  end;
  case Sender^.Offset of
    ofsTView+8 :F:=DBL^.DataField;
    ofsTView+12:F:=DBL^.LookupField;
    ofsTView+16:F:=DBL^.LookupDisplay;
  end;}
  if DS=nil then exit;
  L:=CreateListField(Sender, DS, F, Owner, P);
  if Owner^.Owner^.ExecView(P)=cmOk then
  begin
    P^.GetData(L);
    if L=-1 then F:=nil
    else
    if DS^.Active then F:=DS^.Fields(L)
    else F:=nil;
  end;
  P^.Free;
{  case Sender^.Offset of
    ofsTView+8 :DBL^.DataSourse:=DS;
    ofsTView+12,
    ofsTView+16:DBL^.LookupSourse:=DS;
  end;
  case Sender^.Offset of
    ofsTView+8 :begin
                  DBL^.DataField:=F;
                  if F=nil then
                  begin
                    DisposeStr(DBL^.DataFieldName);
                    DBL^.DataFieldName:=nil;
                  end
                  else AssignStr(DBL^.DataFieldName, F^.Name^)
                end;
    ofsTView+12:begin
                  DBL^.LookupField:=F;
                  if F=nil then
                  begin
                    DisposeStr(DBL^.LookupFieldName);
                    DBL^.LookupFieldName:=nil;
                  end
                  else AssignStr(DBL^.LookupFieldName, F^.Name^)
                end;
    ofsTView+16:begin
                  DBL^.LookupDisplay:=F;
                  if F=nil then
                  begin
                    DisposeStr(DBL^.LookupDisplayName);
                    DBL^.LookupDisplayName:=nil;
                  end
                  else AssignStr(DBL^.LookupDisplayName, F^.Name^)
                end;
  end;}
end;

procedure EditReports_Band(Sender:PProperty; View:PView);
var Report:PReport absolute View;
begin
{  case Sender^.Offset of
     ofsTView:Report^.SetReportBand(Report^.DocHeaderBand, rbtDocHeader);
     ofsTView+4:Report^.SetReportBand(Report^.PageHeaderBand,  rbtPageHeader);
     ofsTView+8:Report^.SetReportBand(Report^.PageFooterBand,  rbtPageFooter);
     ofsTView+12:Report^.SetReportBand(Report^.DocFooterBand,  rbtDocFooter);
     ofsTView+16:Report^.SetReportBand(Report^.MainBand,  rbtMain);
  end;       }
end;

function GetTextDBEditField(Sender:PProperty; View:PView):string;
var DBEdit:PDBEdit absolute View;
begin
  if DBEdit^.Field<>nil then GetTextDBEditField:=DBEdit^.Field^.Name^
  else GetTextDBEditField:='';
end;
procedure EditDBEditField(Sender:PProperty; View:PView; Owner:PListBox);
var P:PLockUpInputLine;
    L:longint;
    DBEdit:PDBEdit absolute View;
begin
  L:=CreateListField(Sender, DBEdit^.DS, DBEdit^.Field, Owner, P);
  if Owner^.Owner^.ExecView(P)=cmOk then
  begin
    P^.GetData(L);
    if L=-1 then DBEdit^.Field:=nil
    else
      if DBEdit^.DS^.Active then DBEdit^.Field:=DBEdit^.DS^.Fields(L)
      else DBEdit^.Field:=nil;
    if DBEdit^.Field=nil then
    begin
      DisposeStr(DBEdit^.FieldName);
      DBEdit^.FieldName:=nil;
    end
    else AssignStr(DBEdit^.FieldName, DBEdit^.Field^.Name^)
  end;
  P^.Free;
  DBEdit^.UpData;
end;


procedure AfterEditDBGrid_DS(Sender:PProperty; View:PView);
var DBGrid:PDBGrid absolute View;
begin
  DBGrid^.NewTable(DBGrid^.DataSourse);
end;

procedure EditView_State(Sender:PProperty; View:PView; Owner:PListBox);
var P:PBitBolProperty absolute Sender;
    W:word;
begin
  W:=1 shl (P^.BitVal);
  View^.SetState(W, (View^.State and W)<>W);
end;

{procedure AfterEditLabel_Link(Sender:PProperty; View:PView);
var P:PLabel absolute View;
    G:PGroup;
begin
  if P^.Link=nil then exit;
  G:=P^.Owner;
  G^.Delete(P);
  G^.InsertBefore(P, P^.Link);
end;}

procedure AfterEditListBox_ScrollBar(Sender:PProperty; View:PView);
var P:PListViewer absolute View;
    G:PGroup;
    SB:PScrollBar;
begin
{  case Sender^.Offset of
    95:SB:=P^.HScrollBar;
    99:SB:=P^.VScrollBar;
  end;
  if SB=nil then exit;
  G:=P^.Owner;
  G^.Delete(P);
  P^.Owner^.InsertBefore(P, SB);}
end;

function GetTextDataSourse_RecordCount(Sender:PProperty; View:PView):string;
var DS:PDataSourse absolute View;
begin
  if DS^.Active then GetTextDataSourse_RecordCount:=IntToStr(DS^.RecordCount)
  else GetTextDataSourse_RecordCount:='';
end;

function GetTextDBGrid_FieldDefs(Sender:PProperty; View:PView):string;
begin
  GetTextDBGrid_FieldDefs:='Items';
end;

procedure EditDBGrid_FieldDefs(Sender:PProperty; View:PView; Owner:PListBox);
var DBGrid:PDBGrid absolute View;
begin
  if (DBGrid^.DataSourse=nil) or (DBGrid^.FieldDefs^.Count=0) then exit;
  Application^.ExecuteDialog(New(PDBGridCollumnEditor, Init(DBGrid)),nil);
end;

function GetTextDataSourseActive(Sender:PProperty; View:PView):string;
var DS:PDataSourse absolute View;
begin
  GetTextDataSourseActive:=BooleanToStr(DS^.Active);
end;

procedure EditDataSourseActive(Sender:PProperty; View:PView; Owner:PListBox);
var DS:PDataSourse absolute View;
begin
  DS^.SetActive(not DS^.Active)
end;

function GetTextDBSourse_IndexName(Sender:PProperty; View:PView):string;
var DS:PDBSourse absolute View;
    Dir: DirStr;
    Name: NameStr;
    Ext: ExtStr;
begin
  GetTextDBSourse_IndexName:='';
  if DS^.Active then
     if DS^.DataSet^.Index<>nil then
     begin
        FSplit(PIndexObject(DS^.DataSet^.Index)^.FileName^, Dir, Name, Ext);
        GetTextDBSourse_IndexName:=Name;
     end;
end;

procedure EditDBSourse_IndexName(Sender:PProperty; View:PView; Owner:PListBox);
var PL:PLockUpInputLine;
    DS:PDBSourse absolute View;
    i,l:longint;
    R:TRect;
    Dir: DirStr;
    Name: NameStr;
    Ext: ExtStr;
procedure DoAdd(P:PIndexObject);far;
begin
  if P=DS^.DataSet^.Index then L:=i;
  FSplit(P^.FileName^, Dir, Name, Ext);
  PL^.List^.AtInsert(i, NewStr(Name));
  inc(i);
end;
begin
  if not DS^.Active then exit;
  with Owner^ do
  R.Assign(Origin.X+Length(Sender^.Name^)+2, Origin.Y+Focused-TopItem,
           Origin.X+Size.X, Origin.Y+Focused-TopItem+1);
  PL:=New(PLockUpInputLine, Init(R,nil));
  i:=0;L:=-1;
  DS^.IndexDefs^.ForEach(@DoAdd);
  PL^.SetData(L);
  if Owner^.Owner^.ExecView(PL)=cmOk then
  begin
    PL^.GetData(L);
    if L=-1 then DS^.DataSet^.Index:=nil
    else DS^.DataSet^.Index:=DS^.IndexDefs^.At(L)
  end;
  PL^.Free;
end;

procedure EditDBSourse_IndexDefs(Sender:PProperty; View:PView; Owner:PListBox);
var
  DS:PDBSourse absolute View;
begin
  if not DS^.Active then exit;
  Application^.ExecuteDialog(New(PIndexDefsDlg, Init(DS)),nil);
end;

procedure Edit_DatabaseName(Sender:PProperty; View:PView; Owner:PListBox);
var PL:PLockUpInputLine;
    DS:PDBSourse absolute View;
    i,l:longint;
    R:TRect;
procedure DoAdd(P:PAliasRecord);far;
begin
  if (DS^.DatabaseName<>nil) and (stUpCase(P^.AliasName^)=stUpCase(DS^.DatabaseName^)) then L:=i;
  PL^.List^.AtInsert(i, NewStr(P^.AliasName^));
  inc(i);
end;
begin
  if DS^.Active then
  begin
    RMessageBox(sDataSetOpen, nil, mfError+mfOkButton);
    exit;
  end;
  with Owner^ do
  R.Assign(Origin.X+Length(Sender^.Name^)+2, Origin.Y+Focused-TopItem,
           Origin.X+Size.X, Origin.Y+Focused-TopItem+1);
  PL:=New(PLockUpInputLine, Init(R,nil));
  i:=0;L:=-1;
  Session^.AliasCollection^.ForEach(@DoAdd);
  PL^.SetData(L);
  if Owner^.Owner^.ExecView(PL)=cmOk then
  begin
    PL^.GetData(L);
    if L=-1 then AssignStr(DS^.DataBaseName, '')
    else AssignStr(DS^.DataBaseName, PString(PL^.List^.At(L))^);
  end;
  PL^.Free;
end;

function GetText_TableName(Sender:PProperty; View:PView):string;
var
  DS:PDBSourse absolute View;
  Dir: DirStr;
  FName: NameStr;
  Ext: ExtStr;
  L:integer;
begin
  if DS^.TableName<>nil then
  begin
    if PropertyWindow<>nil then L:=PropertyWindow^.Size.X-5 else L:=20;
    FSplit( DS^.TableName^, Dir, FName, Ext);
    if CurrentDir(CurrentDrive)<>Dir then
       GetText_TableName:=FNameReduce(DS^.TableName^,Max(20,L-Length(Sender^.Name^)))
    else GetText_TableName:=FName+Ext;
  end
  else GetText_TableName:='';
end;

procedure Edit_TableName(Sender:PProperty; View:PView; Owner:PListBox);
var
  DS:PDBSourse absolute View;
  R:TRect;
  Path:PathStr;
  S:string;
  DirInfo:SearchRec;
  PL:PLockUpInputLine;
    i,l:longint;
begin
  if DS^.Active then RMessageBox(sDataSetOpen, nil, mfError+mfOkButton)
  else
  begin
    if DS^.DataBaseName=nil then
    begin
      if DS^.TableName<>nil then S:=DS^.TableName^ else S:=sExtDBF;
      if ExecDialog(sDBFOpenDialog,@S)<>cmCancel then
      begin
        if (DS^.TableName=nil) or (DS^.TableName^<>S) then
           DS^.IndexLists^.FreeAll;
        AssignStr(DS^.TableName, S);
      end;
    end
    else
    begin
      with Owner^ do
      R.Assign(Origin.X+Length(Sender^.Name^)+2, Origin.Y+Focused-TopItem,
               Origin.X+Size.X, Origin.Y+Focused-TopItem+1);
      PL:=New(PLockUpInputLine, Init(R,nil));
      Path:=Session^.ByAlias(DS^.DataBaseName^);
      FindFirst(Path+'*.dbf',Archive,DirInfo);
      i:=0;L:=-1;
      while DosError = 0 do
      begin
        PL^.List^.AtInsert(i, NewStr(DirInfo.Name));
        if (DS^.TableName<>nil) and
           (stUpCase(DirInfo.Name)=stUpCase(DS^.TableName^)) then
           L:=i;
        inc(i);
        FindNext(DirInfo);
      end;
      PL^.SetData(L);
      if Owner^.Owner^.ExecView(PL)=cmOk then
      begin
        PL^.GetData(L);
        if L<>-1 then S:=PString(PL^.List^.At(L))^ else S:='';
        if (DS^.TableName=nil) or (DS^.TableName^<>S) then
           DS^.IndexLists^.FreeAll;
        AssignStr(DS^.TableName, S);
      end;
      PL^.Free;
    end;
  end;
end;

function GetTextDataSourse_MasterField(Sender:PProperty; View:PView):string;
var
  DS:PDBSourse absolute View;
  P:PField;
begin
  P:=DS^.MasterField;
  if P<>nil then
     GetTextDataSourse_MasterField:=P^.Name^
  else GetTextDataSourse_MasterField:='';
end;

procedure Edit_FieldDefs(Sender:PProperty; View:PView; Owner:PListBox);
var
  DS:PDBSourse absolute View;
begin
  if DS^.Active then NewFieldEditor(DS);
end;


procedure EditDataSourse_MasterField(Sender:PProperty; View:PView; Owner:PListBox);
var DS:PDBSourse absolute View;
    P:PLockUpInputLine;
    L:longint;
begin
  if DS^.Master=nil then exit;
  L:=CreateListField(Sender, DS^.Master, DS^.MasterField, Owner, P);
  if Owner^.Owner^.ExecView(P)=cmOk then
  begin
    P^.GetData(L);
    if L=-1 then DS^.DataSet^.MasterField:=nil
    else
      if DS^.Active then DS^.DataSet^.MasterField:=DS^.Master^.Fields(L)
      else DS^.DataSet^.MasterField:=nil;
    if DS^.DataSet^.MasterField<>nil then AssignStr(DS^.DataSet^.MasterFieldName, DS^.DataSet^.MasterField^.Name^);
  end;
  P^.Free;
end;

procedure AfterEditDS_Master(Sender:PProperty; View:PView);
var
  DS:PDBSourse absolute View;
begin
  if (PDBSourse(DS^.Master)=DS) or (not DS^.Active) or
     (DS^.DataSet^.Index=nil) or (not DS^.Master^.Active) then DS^.Master:=nil
  else DS^.DataSet^.SetMaster(PDBSourse(DS^.Master)^.DataSet,'');
end;

procedure AfterEditButton_Flags(Sender:PProperty; View:PView);
var P:PButton absolute View;
begin
  P^.AmDefault:=(P^.Flags and bfDefault) <> 0;
end;

procedure AfterEditButton_Command(Sender:PProperty; View:PView);
var P:PButton absolute View;
begin
{  if P^.Command in [cmHelp,cmOK,cmCancel,cmYes,cmNo] then
  begin
     AssignStr(P^.Title,GetString(P^.Command+sCmdBase));
     if P^.Command=cmOk then P^.Flags:=P^.Flags or bfDefault
     else P^.Flags:=P^.Flags and not bfDefault;
     AfterEditButton_Flags(Sender, View);
  end;}
end;

procedure AE_ReportLabel_RLStyle(Sender:PProperty; View:PView);
var P:PReportLabel absolute View;
    S:string;
begin
  S:=GetString(byte(P^.RLStyle)+515);
  P^.SetParam(S);
end;

function GetTextInputLine_Validator(Sender:PProperty; View:PView):string;
var P:PInputLine absolute View;
begin
  if P^.Validator=nil then GetTextInputLine_Validator:=''
  else
  if TypeOf(P^.Validator^)=TypeOf(TValidator) then
     GetTextInputLine_Validator:=GetString(520)
  else
  if TypeOf(P^.Validator^)=TypeOf(TPXPictureValidator) then
     GetTextInputLine_Validator:=GetString(521)
  else
  if TypeOf(P^.Validator^)=TypeOf(TLookupValidator) then
     GetTextInputLine_Validator:=GetString(522)
  else
  if TypeOf(P^.Validator^)=TypeOf(TFilterValidator) then
     GetTextInputLine_Validator:=GetString(523)
  else
  if TypeOf(P^.Validator^)=TypeOf(TStringLookupValidator) then
     GetTextInputLine_Validator:=GetString(524)
  else
  if TypeOf(P^.Validator^)=TypeOf(TRangeValidator) then
     GetTextInputLine_Validator:=GetString(525)
  else GetTextInputLine_Validator:=''
end;

procedure EditInputLine_Validator(Sender:PProperty; View:PView; Owner:PListBox);
var P:PInputLine absolute View;
begin
end;

function GetTextDBClusterField(Sender:PProperty; View:PView):string;
var DBCluster:PDBCluster absolute View;
begin
  if DBCluster^.Field<>nil then
     GetTextDBClusterField:=DBCluster^.Field^.Name^
  else GetTextDBClusterField:='';
end;

procedure EditDBClusterField(Sender:PProperty; View:PView; Owner:PListBox);
var DBCluster:PDBCluster absolute View;
    P:PLockUpInputLine;
    L:longint;
begin
  L:=CreateListField(Sender, DBCluster^.DS, DBCluster^.Field, Owner, P);
  if Owner^.Owner^.ExecView(P)=cmOk then
  begin
    P^.GetData(L);
    if L=-1 then DBCluster^.Field:=nil
    else
      if DBCluster^.DS^.Active then DBCluster^.Field:=DBCluster^.DS^.Fields(L)
      else DBCluster^.Field:=nil;
    if DBCluster^.Field=nil then
    begin
      DisposeStr(DBCluster^.FieldName);
      DBCluster^.FieldName:=nil;
    end
    else AssignStr(DBCluster^.FieldName, DBCluster^.Field^.Name^)
  end;
  P^.Free;
end;

procedure DBCB_AfterE_VC(Sender:PProperty; View:PView);
var P:PPStringProperty absolute Sender;
begin
  if PString(P^.Info^)<>nil then
  PString(P^.Info^)^:=stUpCase(PString(P^.Info^)^);
end;

function GetTextDBCB_Strings(Sender:PProperty; View:PView):string;
var DBCheckBox:PDBCheckBox absolute View;
begin
  GetTextDBCB_Strings:=PString(DBCheckBox^.Strings.At(0))^;
end;

procedure EditDBCB_Strings(Sender:PProperty; View:PView; Owner:PListBox);
var DBCheckBox:PDBCheckBox absolute View;
    PL:PInputLine;
    S:string;
    R:TRect;
begin
  with Owner^ do
  R.Assign(Origin.X+Length(Sender^.Name^)+2, Origin.Y+Focused-TopItem,
           Origin.X+Size.X, Origin.Y+Focused-TopItem+1);
  PL:=New(PInputLine, Init(R, 255));
  S:=PString(DBCheckBox^.Strings.At(0))^;
  PL^.SetData(S);
  if Owner^.Owner^.ExecView(PL)=cmOk then
  begin
    PL^.GetData(S);
    DBCheckBox^.Strings.AtFree(0);
    DBCheckBox^.Strings.Insert(NewStr(S));
  end;
  PL^.Free;
end;

procedure BeforeEditInputLine_MaxLen(Sender:PProperty; View:PView);
var IL:PInputLine absolute View;
begin
  Temp:=IL^.MaxLen;
end;

procedure AfterEditInputLine_MaxLen(Sender:PProperty; View:PView);
var IL:PInputLine absolute View;
    S:string;
begin
  S:=IL^.Data^;
  FreeMem(IL^.Data, Temp);
  GetMem(IL^.Data, IL^.MaxLen);
  if Length(S)>IL^.MaxLen then byte(s[0]):=IL^.MaxLen;
  IL^.Data^:=S;
end;

function GetTextForm_ProcName(Sender:PProperty; View:PView):string;
var D:PDialog absolute View;
    F:PFormMain;
begin
  F:=ProjectCollection^.FindForm(D);
  GetTextForm_ProcName:=F^.ProcName;
end;

procedure EditForm_ProcName(Sender:PProperty; View:PView; Owner:PListBox);
var D:PDialog absolute View;
    F:PFormMain;
    PL:PInputLine;
    R:TRect;
begin
  with Owner^ do
  R.Assign(Origin.X+Length(Sender^.Name^)+2, Origin.Y+Focused-TopItem,
           Origin.X+Size.X, Origin.Y+Focused-TopItem+1);
  PL:=New(PInputLine, Init(R, 60));
  F:=ProjectCollection^.FindForm(D);
  PL^.SetData(F^.ProcName);
  if Owner^.Owner^.ExecView(PL)=cmOk then PL^.GetData(F^.ProcName);
  PL^.Free;
end;

function GetTextForm_UnitName(Sender:PProperty; View:PView):string;
var D:PDialog absolute View;
    F:PFormMain;
begin
  F:=ProjectCollection^.FindForm(D);
  GetTextForm_UnitName:=F^.UnitName;
end;

procedure EditForm_UnitName(Sender:PProperty; View:PView; Owner:PListBox);
var D:PDialog absolute View;
    F:PFormMain;
    PL:PInputLine;
    R:TRect;
begin
  with Owner^ do
  R.Assign(Origin.X+Length(Sender^.Name^)+2, Origin.Y+Focused-TopItem,
           Origin.X+Size.X, Origin.Y+Focused-TopItem+1);
  PL:=New(PInputLine, Init(R, 79));
  F:=ProjectCollection^.FindForm(D);
  PL^.SetData(F^.UnitName);
  if Owner^.Owner^.ExecView(PL)=cmOk then
  begin
    PL^.GetData(F^.UnitName);
  end;
  PL^.Free;
end;

function GetTextForm_ResName(Sender:PProperty; View:PView):string;
var D:PDialog absolute View;
    F:PFormMain;
begin
  F:=ProjectCollection^.FindForm(D);
  GetTextForm_ResName:=F^.ResName;
end;

procedure EditForm_ResName(Sender:PProperty; View:PView; Owner:PListBox);
var D:PDialog absolute View;
    F:PFormMain;
    PL:PInputLine;
    R:TRect;
begin
  with Owner^ do
  R.Assign(Origin.X+Length(Sender^.Name^)+2, Origin.Y+Focused-TopItem,
           Origin.X+Size.X, Origin.Y+Focused-TopItem+1);
  PL:=New(PInputLine, Init(R, 79));
  F:=ProjectCollection^.FindForm(D);
  PL^.SetData(F^.ResName);
  if Owner^.Owner^.ExecView(PL)=cmOk then PL^.GetData(F^.ResName);
  PL^.Free;
end;

function GetTextForm_Current(Sender:PProperty; View:PView):string;
var D:PDialog absolute View;
begin
  if D^.Current=nil then GetTextForm_Current:=''
  else
  if D^.Current=PView(_Cursor) then GetTextForm_Current:=_Cursor^.EditView^.ComponentName^
  else GetTextForm_Current:=D^.Current^.ComponentName^
end;

procedure EditForm_Current(Sender:PProperty; View:PView; Owner:PListBox);
var D:PDialog absolute View;
    P:PLockUpInputLine;
    L:longint;
    Form:PFormMain;
    R:TRect;
    List:TListBoxRec;
    PC:PView;
begin
  with Owner^ do
  R.Assign(Origin.X+Length(Sender^.Name^)+2, Origin.Y+Focused-TopItem,
           Origin.X+Size.X, Origin.Y+Focused-TopItem+1);
  Form:=ProjectCollection^.FindForm(D);
  if D^.Current=PView(_Cursor) then PC:=_Cursor^.EditView
  else PC:=D^.Current;
  FillRecord( Form, PC, AllType-SystemTypeSet, false, List);
  P:=New(PLockUpInputLine, Init(R,nil));
  for l:=0 to PStrings(List.List)^.Count-1 do
        P^.List^.AtInsert(l, NewStr(PStrings(List.List)^.Str(L)));
  L:=List.Selection;
  Dispose(PStrings(List.List), Done);
  P^.SetData(L);
  if Owner^.Owner^.ExecView(P)=cmOk then
  begin
    if Trim(P^.Data^)<>'' then
      D^.Current:=FindByName( Form, P^.Data^);
  end;
  P^.Free;
end;

procedure AfterEditGroupBand_GroupExpresion(Sender:PProperty; View:PView);
var RB:PGroupBand absolute View;
begin
  RB^.SetGroupExpresion(DinamicStr(RB^.GroupExpresion));
end;

procedure AfterEditRB_Detail(Sender:PProperty; View:PView);
var RB:PReportBand absolute View;
begin
{  case Sender^.Offset of
   ofsTGroup+4:begin
                 if RB^.Detail<>nil then
                    if RB^.Detail=RB then RB^.Detail:=nil
                    else RB^.SetDetail(RB^.Detail, rbtDetail);
               end;
   ofsTGroup+18:begin
                 if RB^.Header<>nil then
                    if RB^.Header=RB then RB^.Header:=nil
                    else RB^.SetDetail(RB^.Header, rbtBandHeader);
               end;
   ofsTGroup+22:begin
                 if RB^.Footer<>nil then
                    if RB^.Footer=RB then RB^.Footer:=nil
                    else RB^.SetDetail(RB^.Footer, rbtBandFooter);
               end;
  end;}
end;

procedure AfterEditComponentNameDialog(Sender:PProperty; View:PView);
var Dialog:PDialog absolute View;
    Form:PFormMain;
begin
   Form:=ProjectCollection^.FindForm(Dialog);
   DisposeStr(Form^.FormName);
   Form^.FormName:=NewStr(Dialog^.ComponentName^);
end;

procedure CreateIndexPageDlg(Sender:PObject);
begin
  IndexPageWnd:=PListViewer(Sender);
end;

procedure DestroyIndexPageDlg(Sender:PObject);
begin
  IndexPageWnd:=nil;
end;

function IndDldGetText(Sender:PListViewer;Item:Integer;MaxLen:Integer):string;
var Node:PNode;
    S:String;
begin
  Node:=Nodes^.At(Item);
  if TypeOf(Node^)<>TypeOf(TVMMPage) then S:=Node^.Stream^.FileName^
  else S:='Virtual memory';
  with Node^ do
  IndDldGetText:=IntToStr(BufferSize)+' '+
                 IntToStr(Handle)+' '+
                 BooleanToStr(Modified)+' '+S;

end;
type
  TInfoStruRecord = record
    List:PStrings;
    S:word;
    Count:longint;
    D:PString;
  end;

procedure HandleEventDBWindow(Sender:PView;var Event:TEvent;EventTime:TEventTime);
var P:PDataBaseWindow absolute Sender;
procedure InfoStru;
var
  Rec:TInfoStruRecord;
  D:TDateTime;
  i:integer;
procedure DoAdd(P:PField);far;
var A:Array [1..4] of Longint;
    S:string;
begin
  A[1]:=Longint(P^.Name);
  A[2]:=Longint(fTypeToChar(P^.FieldType));
  A[3]:=Longint(P^.Size);
  A[4]:=Longint(P^.Dec);
  S:='%-10s | %2c | %4d ';
  if P^.FieldType in [ftSmallint, ftInteger, ftWord,
                      ftFloat,  ftCurrency] then S:=S+'| %4d';
  Rec.List^.Insert(NewStr(StrFormat(S,A)));
end;
begin
  FillChar(Rec, sizeOf(TInfoStruRecord), 0);
{  D:=P^.DataSourse^.LastUpDate;}
  Rec.List:=New(PStrings, Init);
  P^.DataSourse^.FieldDefs^.ForEach(@DoAdd);
  for i:=0 to P^.DataSourse^.FieldDefs^.Count-1 do
  Rec.Count:=P^.DataSourse^.RecordCount;
  Rec.D:=NewStr(DateToStr(D));
  ExecDialog(sInfoStruDialog, @Rec);
  DisposeStr(Rec.D);
  Dispose(Rec.List, Done);
end;

procedure EditCur;
var R:TRect;
    Edit:PDBEdit;
    DBGridField:PDBGridField;
    ModalResult:Word;
    X,Y,I:integer;
begin
  with P^ do
  begin
    DBGridField:=DBGrid^.FieldDefs^.At(DBGrid^.Delta.X+DBGrid^.CurPos.X);
    X:=DBGrid^.Origin.X;
    for i:=DBGrid^.Delta.X to DBGrid^.Delta.X+DBGrid^.CurPos.X-1 do
        inc(X, PDBGridField(DBGrid^.FieldDefs^.At(i))^.GetSize+1);
    Y:=DBGrid^.Origin.Y+DBGrid^.Focused+1;
    R.Assign( X, Y, X+DBGridField^.GetSize, Y+1);
    DataSourse^.Edit;
    DesignTime:=false;
    Edit:=New(PDBEdit, Init(R, DataSourse, DBGridField^.Field^.Name^));
    Insert(Edit);
    Edit^.SetState(sfModal,True);
    ModalResult:=Edit^.Execute;
    Edit^.SetState(sfModal+sfExposed,false);
    if ModalResult<>cmCancel then DataSourse^.Post
    else DataSourse^.Cancel;
    Delete(Edit);
    Edit^.Free;
    DesignTime:=true;
  end;
end;

procedure AppendRec;
begin
  P^.DataSourse^.Append;
  P^.DataSourse^.Post;
end;

procedure DeleteRec;
var S:String;
    PS:PString;
begin
  PS:=@S;
  with P^.DBGrid^ do
  S:=PDBGridField(FieldDefs^.At(Delta.X+CurPos.X))^.Field^.AsString;
  if RMessageBox(sDelRecordConfirm,@PS, mfConfirmation+mfOkCancel)<>cmCancel then
     P^.DataSourse^.DeleteRecord;
  P^.Frame^.DrawView;
end;

procedure RecalCur;
var S:String;
    PS:PString;
begin
  PS:=@S;
  with P^.DBGrid^ do
  S:=PDBGridField(FieldDefs^.At(Delta.X+CurPos.X))^.Field^.AsString;
  if RMessageBox(sRecalRecordConfirm,@PS, mfConfirmation+mfOkCancel)<>cmCancel then
  begin
{    if TypeOf()
    P^.DataSourse^.RecalRecord;}
  end;
  P^.Frame^.DrawView;
end;

begin
  with P^ do
  begin
    case Event.What of
      evCommand:
      case Event.Command of
        cmInfoStructure:InfoStru;
        cmDBWindEdit:EditCur;
        cmDBWindAppend:AppendRec;
        cmDBWindDelete:DeleteRec;
        cmDBWindRecal:RecalCur;
        cmDBWindReindex:begin
                          Application^.ExecuteDialog(
                             New(PIndexDefsDlg, Init(DataSourse)),nil);
                          DataSourse^.FirstRecEx;
                        end;
      else
        exit;
      end;
      evBroadcast:
      case Event.Command of
        cmDBGridSelect:EditCur;
        cmAddToCollect:begin
                         if EventTime=etView then
                            PCollection(Event.InfoPtr)^.Insert(P);
                         Exit;
                       end;
        cmUpDataDS:begin
                     Frame^.DrawView;
                     exit;
                   end;
      else
        exit;
      end;
    else
      exit;
    end;
    ClearEvent(Event);
  end;
end;


procedure AfterEditGrowMode(Sender:PProperty; View:PView);
begin
  if (_Cursor<>nil) and (_Cursor^.EditView=View) then
     _Cursor^.SetGrowMode(View^.GrowMode);
end;

function ValidComponentName(Sender:PProperty; View:PView; Info:Pointer):boolean;
var S:PString absolute Info;
    D:PGroup;
{$IFDEF VER70}
    Result:Boolean;
{$ENDIF}
begin
  Result:=false;
  if S=nil then exit;
  if not CheckIdentificator(S^) then
     RMessageBox(sSyntaxError,@S, mfError+mfOkButton)
  else
  if _Cursor^.EditView<>nil then
  begin
    if (_Cursor^.EditView^.ComponentName=S) or (stUpCase(_Cursor^.EditView^.ComponentName^)=stUpCase(S^)) then
       exit;
    if _Cursor^.EditView^.Owner^.ComponentType=ctReportBand then D:=_Cursor^.EditView^.Owner^.Owner
    else D:=_Cursor^.EditView^.Owner;
    Result:=not TestComponentName(S^, D);
    if not Result then RMessageBox(sDupIdent,@S, mfError+mfOkButton);
  end;
{$IFDEF VER70}
  ValidComponentName:=Result;
{$ENDIF}
end;

procedure AfterEditParamText_Text(Sender:PProperty; View:PView);
var
  P:PParamText absolute View;
begin
  if P^.Text<>nil then P^.ParamCount:=CountParam(P^.Text^)
  else P^.ParamCount:=0;
end;

procedure AfterEditStaticText_Text(Sender:PProperty; View:PView);
var
  P:PStaticText absolute View;
begin
  P^.SetText(P^.Text^);
  _Cursor^.RecalcBounds;
end;

function Views_GetTextHlpCtx(Sender:PProperty; View:PView):string;
var
  S:String;
begin
  if (RefTable<>nil) and RefTable^.Find(View^.HelpCtx, S) then
    Views_GetTextHlpCtx:='hc'+S
  else Views_GetTextHlpCtx:=IntToStr(View^.HelpCtx);
end;

procedure Views_EditHelpCtx(Sender:PProperty; View:PView; Owner:PListBox);
var P:PInputLine;
    R:TRect;
    S,S1:String[64];
    PS:PString;
    Code: Integer;
    Result:word;
    Ref: PReference;
begin
  with Owner^ do
  R.Assign(Origin.X+Length(Sender^.Name^)+2, Origin.Y+Focused-TopItem,
           Origin.X+Size.X, Origin.Y+Focused-TopItem+1);
  P:=New(PInputLine, Init(R, 64));
  S:=Views_GetTextHlpCtx(Sender, View);
  P^.SetData(S);
  if Owner^.Owner^.ExecView(P)=cmOk then
  begin
    P^.GetData(S);
    Val(S,Result,Code);
    if Code<>0 then
    begin
      PS:=@S;
      S1:=Copy(S,3,255);
      if (RefTable<>nil) and RefTable^.Search(@S1, Code) then
      begin
         Ref := RefTable^.At(Code);
         View^.HelpCtx:=Ref^.Value;
      end
      else RMessageBox(sUnknowIdentifier,@PS,mfError+mfOkButton);
    end
    else View^.HelpCtx:=Result;
  end;
  P^.Free;
end;

function GetTextQuery_Text(Sender:PProperty; View:PView):string;
var Q:PQuery absolute View;
    S:string;
    i:integer;
begin
  S:='';
(*  i:=0;
  if Q^.Text<>nil then
  while (i<256) and (PCharArray(Q^.Text)^[i]<>#0) do
  begin
    if PCharArray(Q^.Text)^[i]=#13 then
    begin
      S:=S+' ';
      inc(i);
    end
    else S:=S+PCharArray(Q^.Text)^[i];
{    if S[Length(S)]=' '  then
       while (PCharArray(Q^.Text)^[i]=' ') and (PCharArray(Q^.Text)^[i]<>#0) do
             inc(i)
    else} inc(i);
  end;*)
  GetTextQuery_Text:=S;
end;

procedure EditQuery_Text(Sender:PProperty; View:PView; Owner:PListBox);
var Q:PQuery absolute View;
    Command,i,j:integer;
    Rec:PMemoRec;
begin
{   GetMem(Rec,4096+63);
   if Q^.Text=nil then i:=0 else i:=StrLen(Q^.Text);
   Rec^.Length:=Min(I, 4096);
   Move(Q^.Text^,Rec^.Text,Rec^.Length);
   repeat
     command:=RExecDialog(sText_Editor, Rec);
     case command of
        cmOk:begin
               StrDispose(Q^.Text);
               if Rec^.Length<>0 then
               begin
                 GetMem(Q^.Text,Rec^.Length+1);
                 Move(Rec^.Text,Q^.Text^,Rec^.Length);
                 PCharArray(Q^.Text)^[Rec^.Length]:=#0;
               end
               else Q^.Text:=nil;
             end;
        cmYes:LoadText(Rec^.Length, GetView(sOpenSQL), GetString(sTextSQL));
        cmNo:SaveText(Rec^.Length, GetView(sSaveSQL), GetString(sTextSQL));
     end
   until (Command=cmOk) or (Command=cmCancel);
   FreeMem(Rec,4096+63);
   if Command<>cmCancel then Q^.SetActive(false)}
end;

function GetTextQuery_ParamCount(Sender:PProperty; View:PView):string;
{var Q:PQuery absolute View;}
begin
  GetTextQuery_ParamCount:='';{IntToStr(Q^.ParamCount);}
end;

function GetTextQuery_Params(Sender:PProperty; View:PView):string;
{var Q:PQuery absolute View;}
begin
{  if Q^.Text<>nil then GetTextQuery_Params:='(Params)'
  else GetTextQuery_Params:=NilName;}
end;

procedure EditQuery_Params(Sender:PProperty; View:PView; Owner:PListBox);
var P:PQuery absolute View;
begin
  Application^.ExecuteDialog(New(PParamEditorDialog, Init(P)), nil);
end;

procedure EditColorText(Sender:PProperty; View:PView; Owner:PListBox);
var P:PColorText absolute View;
begin
  Application^.ExecuteDialog(New(PColorDialogBox, Init), @P^.Color);
end;

function AliasViewGetTextEvent(Sender:PListViewer;Item:Integer;MaxLen:Integer):string;
var Box:PListViewer absolute Sender;
    Rec:PAliasRecord;
    S:string;
begin
  if (Session^.AliasCollection<>nil) and (Item<Session^.AliasCollection^.Count) then
  begin
    Rec:=Session^.AliasCollection^.At(Item);
    if Rec^.isNet then S:=' Net' else S:='    ';
    AliasViewGetTextEvent:=Rec^.AliasName^+' '+Rec^.WorkDir^+' '+
                 IntToStr(Rec^.WaitTime)+S;
{     isNet:boolean;                      }

  end
  else
    AliasViewGetTextEvent:='';
end;

procedure AliasViewSetData(Sender:PView; var Data);
var Box:PListViewer absolute Sender;
begin
  if (Session<>nil) then
     Box^.SetRange(Session^.AliasCollection^.Count);
  if Box^.Range > 0 then Box^.FocusItem(0);
  Box^.DrawView;
end;
type
  TAliasPropertyRecord = record
    WorkDir:FNameStr;
    AliasName:FNameStr;
    WaitTime:Longint;
    IsNet:word;
  end;
procedure AliasViewHandleEvent(Sender:PView;var Event:TEvent;EventTime:TEventTime);
var Box:PListViewer absolute Sender;

{procedure AddAlias;
var Rec:TAliasPropertyRecord;
    P:PAliasRecord;
begin
  FillChar(Rec, SizeOf(TAliasPropertyRecord), 0);
  if (ExecDialog(sDBAliasProperty, @Rec)<>cmCancel) and
     PathValid(Rec.WorkDir) then
  begin
    P:=New(PAliasRecord, Init(Rec.WorkDir, Rec.AliasName));
    P^.IsNet:=Rec.IsNet and $01 <> 0;
    P^.WaitTime:=Rec.WaitTime;
    Session^.AliasCollection^.Insert(P);
    Box^.SetRange(Session^.AliasCollection^.Count);
    Box^.DrawView;
  end;
end;

procedure EditAlias;
var Rec:TAliasPropertyRecord;
    P:PAliasRecord;
begin
  if Session^.AliasCollection^.Count=0 then exit;
  P:=Session^.AliasCollection^.At(Box^.Focused);
  Rec.WorkDir:=P^.WorkDir^;
  Rec.AliasName:=P^.AliasName^;
  Rec.WaitTime:=P^.WaitTime;
  Rec.IsNet:=byte(P^.IsNet);
  if RExecDialog(sDBAliasProperty, @Rec)<>cmCancel then
  begin
    AssignStr(P^.WorkDir, Rec.WorkDir);
    AssignStr(P^.AliasName, Rec.AliasName);
    P^.IsNet:=Rec.IsNet and $01 <> 0;
    P^.WaitTime:=Rec.WaitTime;
    Box^.DrawView;
  end;
end;

procedure DelAlias;
var PS:PString;
    P:PAliasRecord;
begin
  if Session^.AliasCollection^.Count=0 then exit;
  P:=Session^.AliasCollection^.At(Box^.Focused);
  PS:=@P^.AliasName^;
  if RMessageBox(sConfirmDelAlias, @PS, mfConfirmation+mfYesNo)=cmYes then
  begin
    Session^.AliasCollection^.AtDelete(Box^.Focused);
    P^.Free;
    Box^.SetRange(Session^.AliasCollection^.Count);
    Box^.DrawView;
  end;
end;

procedure SaveAlias;
var FileName:FNameStr;
begin
  FileName:='*.cfg';
  if RExecDialog(sDAE_CFG_STORE,@FileName)<>cmCancel then
     Session^.StoreCfgFile(FileName);
end;

procedure LoadAlias;
var FileName:FNameStr;
begin
  FileName:='*.cfg';
  if RExecDialog(sDAE_CFG_LOAD,@FileName)<>cmCancel then
  begin
    Session^.LoadCfgFile(FileName);
    Box^.SetRange(Session^.AliasCollection^.Count);
    Box^.DrawView;
  end;
end;}

begin
{  case Event.What of
    evBroadcast:
    case Event.Command of
      cmAliasEditorAdd:AddAlias;
      cmListItemSelected,
      cmAliasEditorEdit:EditAlias;
      cmAliasEditorDel:DelAlias;
      cmAliasEditorSave:SaveAlias;
      cmAliasEditorLoad:LoadAlias;
    else
      exit;
    end;
  else
    exit;
  end;}
  Box^.ClearEvent(Event);
end;

procedure AfterEditDirListBox_Dir(Sender:PProperty; View:PView);
var Box:PDirListBox absolute View;
begin
  if PathValid(Box^.Dir) and (Box^.Dir<>'') then
     Box^.NewDirectory(Box^.Dir)
end;

procedure HandleEventTabOrderListBox(Sender: PView; var Event: TEvent;
                                         EventTime:TEventTime);
var Box:PListBox absolute Sender;
procedure UpControl;
var P:PView;
begin
  if Box^.Focused=0 then exit;
  P:=Box^.List^.At(Box^.Focused);
  Box^.List^.Delete(P);
  Box^.List^.AtInsert(Box^.Focused-1, P);
  Box^.FocusItem(Box^.Focused-1);
  Box^.DrawView;
end;
procedure DownControl;
var P:PView;
begin
  if Box^.Focused=Box^.List^.Count-1 then exit;
  P:=Box^.List^.At(Box^.Focused);
  Box^.List^.Delete(P);
  Box^.List^.AtInsert(Box^.Focused+1, P);
  Box^.FocusItem(Box^.Focused+1);
  Box^.DrawView;
end;
begin
  case Event.What of
    evCommand:
    case Event.Command of
      cmUpControl:UpControl;
      cmDownControl:DownControl;
    else
      exit;
    end;
  else
    exit;
  end;
  Sender^.ClearEvent(Event);
end;

function GetViewNameReordr(Sender:PListViewer;Item:Integer;MaxLen:Integer):string;
var List:PCollection;
    View:PView;
begin
  List:=PListBox(Sender)^.List;
  if List<>nil then
     GetViewNameReordr:=PView(List^.At(Item))^.ComponentName^
  else GetViewNameReordr:='';
end;

procedure PrinterSetupEvent(Report:PReport);
var
  Rec:TPrinterOptionsRecord;
begin
  FillChar(Rec, SizeOf(TPrinterOptionsRecord), 0);
  ExecDialog(sPrnOptDlg, @Rec);
end;

procedure HandleEventAddHelpFileListBox(Sender: PView; var Event: TEvent;
                                         EventTime:TEventTime);
var ListBox:PListBox absolute Sender;

procedure DoUpdate;
begin
  ListBox^.SetRange(ListBox^.List^.Count);
  Application^.SetCmdState([cmHelpFileDelete], ListBox^.List^.Count<>0);
  ListBox^.DrawView;
  Message(Application, evBroadcast, cmHelpFilesChanged, nil);
end;

procedure DelHelpFile;
begin
  if ListBox^.List^.Count=0 then exit;
  ListBox^.List^.AtFree(ListBox^.Focused);
  DoUpdate;
end;

procedure AddhelpFile;
var FName:FNameStr;
    i:integer;
begin
  FName:='*.tph';
  if ExecDialog(sOpenTPH,@FName)<>cmCancel then
  begin
    FName:=stUpCase(FName);
    for i:=0 to HelpFiles^.Count-1 do
      if StUpCase(HelpFiles^.Str(i))=FName then
         exit;
    PStrings(ListBox^.List)^.Add(FName);
    DoUpdate;
  end;
end;

begin
  With ListBox^ do
  begin
    case Event.Command of
      cmNew:AddhelpFile;
      cmHelpFileDelete:DelHelpFile;
    else
      exit;
    end;
    ClearEvent(Event);
  end;
end;

procedure HandleEventCodeEditor(Sender: PView; var Event: TEvent;
                                         EventTime:TEventTime);
var Editor:PExtFileEditor absolute Sender;
    FileName:FNameStr;
    D:PExtEditWindow;
    P:Pointer;
    S:string;
begin
  if EventTime<>etView then exit;
  if Event.KeyCode=kbCtrlEnter then
  begin
    FileName:=ReplaceExt(Editor^.GetCurWord,'.PAS',true);
    if DirRecord<>nil then
       S:=DirRecord^.IncludeDirectories + DirRecord^.UnitDirectories
    else S:='';
    S:=S+GetEnv('PATH');
    if FSearch(FileName, S)<>'' then  FileName:=FSearch(FileName,S);
    P:=@FileName;
    if FileExists(FileName) then
    begin
      D:=CreateEditWindow(FileName, hcEditWindow);
      D^.Editor^.OnKeyEvent:=HandleEventCodeEditor;
    end
    else RMessageBox(sFileNotFound,@P,mfError+mfOkButton);
    Editor^.ClearEvent(Event);
  end;
end;

procedure RegisterGL_Proc;
begin
  RegisterProcedure(@GetTextDBTextField, 3, '');
  RegisterProcedure(@EditDBTextField, 4, '');
  RegisterProcedure(@EditReports_Band, 5, '');
  RegisterProcedure(@GetTextDBEditField, 6, '');
  RegisterProcedure(@EditDBEditField, 7, '');
  RegisterProcedure(@AfterEditDBGrid_DS, 8, '');
  RegisterProcedure(@EditView_State, 9, '');
  RegisterProcedure(@GetTextDataSourse_RecordCount, 11,'');
  RegisterProcedure(@AfterEditListBox_ScrollBar, 12, '');
  RegisterProcedure(@GetTextDBGrid_FieldDefs, 13, '');
  RegisterProcedure(@EditDBGrid_FieldDefs, 14, '');
  RegisterProcedure(@GetTextDBSourse_IndexName, 15,'');
  RegisterProcedure(@EditDBSourse_IndexName, 16, '');
  RegisterProcedure(@EditDBSourse_IndexDefs, 17, '');
  RegisterProcedure(@AfterEditButton_Flags, 18, '');
  RegisterProcedure(@Edit_TableName, 19, '');
  RegisterProcedure(@AE_ReportLabel_RLStyle, 20, '');
  RegisterProcedure(@GetTextInputLine_Validator, 21, '');
  RegisterProcedure(@EditInputLine_Validator, 22, '');
  RegisterProcedure(@GetTextDBClusterField, 23, '');
  RegisterProcedure(@EditDBClusterField, 24, '');
  RegisterProcedure(@DBCB_AfterE_VC, 25, '');
  RegisterProcedure(@GetTextDBCB_Strings, 26, '');
  RegisterProcedure(@EditDBCB_Strings, 27, '');
  RegisterProcedure(@AfterEditInputLine_MaxLen, 28, '');
  RegisterProcedure(@BeforeEditInputLine_MaxLen, 29, '');
  RegisterProcedure(@GetTextForm_ProcName, 30, '');
  RegisterProcedure(@EditForm_ProcName, 31, '');
  RegisterProcedure(@GetTextForm_UnitName, 32, '');
  RegisterProcedure(@EditForm_UnitName, 33, '');
  RegisterProcedure(@GetTextForm_ResName, 34, '');
  RegisterProcedure(@EditForm_ResName, 35, '');
  RegisterProcedure(@AfterEditButton_Command, 36, '');
  RegisterProcedure(@GetTextDataSourse_MasterField, 37, '');
  RegisterProcedure(@AfterEditDS_Master, 38, '');
  RegisterProcedure(@AfterEditRB_Detail, 39, '');
  RegisterProcedure(@AfterEditComponentNameDialog, 40, '');
  RegisterProcedure(@GetTextDataSourseActive, 41, '');
  RegisterProcedure(@EditDataSourseActive, 42, '');
  RegisterProcedure(@CreateIndexPageDlg, 46, '');
  RegisterProcedure(@DestroyIndexPageDlg, 47, '');
  RegisterProcedure(@IndDldGetText, 48, '');
  RegisterProcedure(@GetText_TableName, 49, '');
  RegisterProcedure(@GetTextDBLookupComboField, 50, '');
  RegisterProcedure(@EditDBLookupComboField, 51, '');
  RegisterProcedure(@HandleEventDBWindow, 52, '');
  RegisterProcedure(@AfterEditGrowMode, 53, '');
  RegisterProcedure(@ValidComponentName, 54, '');
  RegisterProcedure(@GetTextForm_Current, 55, '');
  RegisterProcedure(@EditForm_Current, 56, '');
  RegisterProcedure(@AfterEditParamText_Text, 57, '');
  RegisterProcedure(@Views_GetTextHlpCtx, 58, '');
  RegisterProcedure(@Views_EditHelpCtx, 59, '');
  RegisterProcedure(@GetTextQuery_Text, 60,'');
  RegisterProcedure(@EditQuery_Text, 61,'');
  RegisterProcedure(@GetTextQuery_ParamCount, 62, '');
  RegisterProcedure(@GetTextQuery_Params, 63, '');
  RegisterProcedure(@EditQuery_Params, 64, '');
  RegisterProcedure(@TDBSourse.ReadOnly, 65, '');
  RegisterProcedure(@TDataSourse.SetActive, 66, '');
  RegisterProcedure(@TDataSourse.GetActive, 67, '');
  RegisterProcedure(@DoTVHColor, 68, 'DoTVHColor');
  RegisterProcedure(@DoPASColor, 69, 'DoPASColor');
  RegisterProcedure(@EditDataSourse_MasterField, 70, '');
  RegisterProcedure(@EditColorText, 71, '');
  RegisterProcedure(@GetTextReportMemoField, 72, '');
  RegisterProcedure(@EditReportMemoField, 73, '');
  RegisterProcedure(@AliasViewGetTextEvent, 74, '');
  RegisterProcedure(@AliasViewSetData, 75, '');
  RegisterProcedure(@AfterEditDirListBox_Dir, 76, '');
  RegisterProcedure(@AliasViewHandleEvent, 77, '');
  RegisterProcedure(@Edit_DatabaseName, 78, '');
  RegisterProcedure(@GetTextDBMemoField, 79, '');
  RegisterProcedure(@EditDBMemoField, 80, '');
  RegisterProcedure(@HandleEventTabOrderListBox, 81, '');
  RegisterProcedure(@Edit_FieldDefs, 82, '');
  RegisterProcedure(@GetViewNameReordr, 83, '');
  RegisterProcedure(@HandleEventAddHelpFileListBox, 84, '');
  RegisterProcedure(@HandleEventCodeEditor, 85, '');
  RegisterProcedure(@AfterEditGroupBand_GroupExpresion, 86, '');
  RegisterProcedure(@TDBSourse.Filtred, 87, '');
  RegisterProcedure(@TDBSourse.SetFiltred, 88, '');
  RegisterProcedure(@AfterEditStaticText_Text, 89, '');
end;

end.
