{$O+}
{$I Define.inc}
unit Ext_Unit;
interface
uses GLType, ResTools, Objects, Views, Register;

var
  CountChar:integer;

function CaseUnit(ComponentType:TComponentType):word;{Преобразует тип элемента в тип моуля}
procedure WriteSubView(V:PView);{Пишем элементы}
function SplitFileName(AFileName:FNameStr):FNameStr;
procedure MakeGroup(P:PGroup; WriteWith:boolean);

implementation
uses Ext_Str, GLOBAL, RESSTRS, Dialogs, AddCntrl, Ext_Math, StdDlg,
     AboutPn, DAE, CmdNamer, Drivers, DBGrids, RsCllt, GauGes, Editors,
     DataCtrl, Grids, MultiSel, Outline, DBCtrls, GadGets, AsciiTab, Reports,
     El_Lists, Dos, Ext_Dos, ColorSel;

function SplitFileName(AFileName:FNameStr):FNameStr;
var Dir,S1: DirStr;
    AName: NameStr;
    Ext: ExtStr;
begin
  if AFileName<>'' then
  begin
    FSplit(AFileName, Dir, AName, Ext);
    S1:=CurrentDir(CurrentDrive);
    if Dir=S1 then AFileName:=AName+Ext
    else
      if ASCIICompare(S1,Dir)=0 then
         Delete(AFileName,1,Length(S1));
  end;
  SplitFileName:=AFileName;
end;

function CaseUnit(ComponentType:TComponentType):word;
begin
  case ComponentType of
    ctScrollBar,
    ctFrame                   : CaseUnit:=1; {Views}
    ctStaticText, ctLabel,
    ctInputLine, ctButton,
    ctListBox, ctRadioButtons,
    ctCheckBoxes, ctMultiCheckBoxes,
    ctParamText, ctDialog     : CaseUnit:=2; {Dialogs}
    ctMemo, ctIndicator       : CaseUnit:=3; {Editors}
    ctPercentGauge, ctBarGauge: CaseUnit:=4; {GauGes}
    ctDataScroller,
    ctDBGrid                  : CaseUnit:=5; {DBGrid}
    ctMultiSelBox             : CaseUnit:=6; {MultiSel}
    ctOutline                 : CaseUnit:=7; {Outline}
    ctInputLineUC, ctInputLineLC,
    ctInputLinePS, ctFilterInput,
    ctColorText, ctLockUpInputLine,
    ctOkListBox, ctDateEdit,
    ctRangeILine              : CaseUnit:=8; {AddCntrl}
    ctDBSourse               : CaseUnit:=9; {DataCtrl}
    ctSortedListBox           : CaseUnit:=10; {StdDlg}
    ctAboutPanel              : CaseUnit:=11; {AboutPn}
    ctDBMemo, ctDBDateEdit,
    ctDBLookupCombo, ctDBEdit,
    ctDBRadioButtons, ctDBCheckBox,
    ctDBLockUpText,ctDBLookupEdit,
    ctDBText                  : CaseUnit:=12; {DBCtrls}
    ctClockView               : CaseUnit:=13; {GadGets}
    ctASCIITable,
    ctASCIIReport             : CaseUnit:=14; {ASCIITab}
    ctDrawGrid,
    ctStringGrid              : CaseUnit:=15; {Grids}
    ctElementGroupList,
    ctElementItemList         : CaseUnit:=16; {El_Lists}
    ctReportShape,
    ctReportBand,ctReport,
    ctReportMemo,
    ctReportLabel             : CaseUnit:=17; {Reports}
    ctColorSelector,
    ctMonoSelector,
    ctColorDisplay            : CaseUnit:=18; {ColorSel}
  else
    CaseUnit:=0;
  end;
end;

procedure MakeButtons(var S:string; P:PView); forward;
procedure MakeRangeILine(var S:string; P:PRangeILine); forward;
procedure MakeLabel(var S:string; P:PLabel); forward;
procedure MakeInputLinePS(var S:string; P:PInputLinePS); forward;
procedure MakeListBox(var S:string; P:PListBox); forward;
procedure MakeMultiSelListBox(var S:string; P:PMultiSelBox); forward;
procedure MakeDBGrid(var S:string; P:PDBGrid); forward;
procedure MakeCluster(var S:string; V:PCluster); forward;
procedure MakePPercentGauge(var S:string; P:PPercentGauge);forward;
procedure MakeColorText(var S:string; P:PColorText);forward;
procedure MakeMemo(var S:string; P:PMemo);forward;
procedure MakeGrid(var S:string; P:PDrawGrid);forward;
procedure MakeDBSourse(var S:string; P:PDBSourse);forward;
procedure MakeLockUpInputLine(var S:string; P:PLockUpInputLine);forward;
procedure MakeReportBand(var S:string;  P:PReportBand);forward;
procedure MakeReport(var S:string;  P:PReport);forward;
procedure MakeListViewer(var S:string;  P:PListViewer);forward;
procedure MakeDBLockUpText(var S:string;  P:PDBLockUpText);forward;
procedure MakeReportLabel(var S:string;  P:PReportLabel);forward;
procedure MakeDBText(var S:string;  P:PDBText);forward;
procedure MakeStaticText(var S:string;  P:PStaticText);forward;
procedure MakeHistory(var S:string;  P:PHistory);forward;
procedure MakeDBLookupCombo(var S:string;  P:PDBLookupCombo);forward;
procedure MakeDBEdit(var S:string;  P:PDBEdit);forward;
procedure MakeDBNavigatorBtn(var S:string;  P:PDBNavigatorBtn);forward;
procedure MakeDBRadioButtons(var S:string;  P:PDBRadioButtons);forward;
procedure MakeDBCheckBox(var S:string;  P:PDBCheckBox);forward;
procedure MakeColorDisplay(var S:string;  P:PColorDisplay);forward;
procedure MakeDBMemo(var S:string;  P:PDBMemo);forward;
procedure MakeReportShape(var S:string;  P:PReportShape);forward;


procedure WriteSubView(V:PView);
var
   S1,S,S2,S3:string;
   Name,NN:string;
   Pr:pointer;
   param:array [1..4] of longint;
begin
  S1:=DupChar(' ',CountChar);
  S:=S1+RectToStr(V)+#13#10;
  Name:=NameComponentType(V);
  S:=S+S1+sNew;
  param[1]:=LongInt(V^.ComponentName);
  param[2]:=LongInt(@Name);
  S:=StrFormat(S,Param);
  S:=S+',';
  case V^.ComponentType of
    ctStaticText : MakeStaticText(S,PStaticText(V));
    ctParamText  : S:=S+#39+QuteString(PParamText(V)^.Text^)+#39','+IntToStr(PParamText(V)^.ParamCount);
    ctInputLineUC,
    ctInputLineLC,
    ctInputLine  : S:=S+IntToStr(PInputLine(V)^.MaxLen);
    ctButton     : MakeButtons(S, V);
    ctLabel      : MakeLabel(S,PLabel(V));
    ctHistory    : MakeHistory(S,PHistory(V));
    ctDateEdit,
    ctScrollBar,
    ctIndicator,
    ctClockView,
    ctMonoSelector,
    ctASCIITable,
    ctASCIIReport: Dec(S[0],2);
    ctInputLinePS: MakeInputLinePS(S, PInputLinePS(V));
    ctRangeILine : MakeRangeILine(S, PRangeILine(V));
    ctOkListBox,
    ctSortedListBox,
    ctElementGroupList,
    ctElementItemList,
    ctListBox    : MakeListBox(S, PListBox(V));
    ctMultiSelBox: MakeMultiSelListBox(S, PMultiSelBox(V));
    ctListViewer : MakeListViewer(S, PListViewer(V));
    ctDBGrid     : MakeDBGrid(S, PDBGrid(V));
    ctLockUpInputLine : MakeLockUpInputLine(S, PLockUpInputLine(V));
    ctCheckBoxes, ctRadioButtons,
    ctMultiCheckBoxes: MakeCluster(S,PCluster(V));
    ctBarGauge,
    ctPercentGauge : MakePPercentGauge(S,PPercentGauge(V));
    //ctRangeILine   : MakeRangeILine(S, PRangeILine(V));
    ctColorText    : MakeColorText(S, PColorText(V));
    ctMemo         : MakeMemo(S, PMemo(V));
    ctDBSourse    : MakeDBSourse(S, PDBSourse(V));
    ctDrawGrid,
    ctStringGrid   : MakeGrid(S, PDrawGrid(V));
    ctReportBand   : MakeReportBand(S, PReportBand(V));
    ctDBText       : MakeDBText(S, PDBText(V));
    ctReport       : MakeReport(S, PReport(V));
    ctDBLookupEdit,
    ctDBLockUpText : MakeDBLockUpText(S, PDBLockUpText(V));
    ctReportLabel  : MakeReportLabel(S,PReportLabel(V));
    ctDBLookupCombo: MakeDBLookupCombo(S, PDBLookupCombo(V));
    ctDBDateEdit,
    ctDBEdit       : MakeDBEdit(S, PDBEdit(V));
    ctDBRadioButtons : MakeDBRadioButtons(S, PDBRadioButtons(V));
    ctDBCheckBox     : MakeDBCheckBox(S, PDBCheckBox(V));

    ctDBNavigatorBtn : MakeDBNavigatorBtn(S, PDBNavigatorBtn(V));

    ctColorSelector  : S:=S+GetString(byte(PColorSelector(V)^.SelType)+546);
    ctColorDisplay   : MakeColorDisplay(S, PColorDisplay(V));
    ctDBMemo         : MakeDBMemo(S, PDBMemo(V));
    ctReportShape    : MakeReportShape(S, PReportShape(V));
  else
    exit;
  end;
  if S<>'' then WriteForm( S+'));');
  WriteForm(DupChar(' ',CountChar)+StrFormat(sInsert,Param));
  if V^.Options and ofFramed<>0 then
     WriteForm(DupChar(' ',CountChar)+V^.ComponentName^+'^.Options:='+
      V^.ComponentName^+'^.Options'+' or ofFramed;');
end;

procedure MakeGroup(P:PGroup; WriteWith:boolean);
var V:PView;
    C:integer;

procedure DoWrite(StepSet:TTypeSet);
var V:PView;
begin
  if P^.Last <> nil then
  begin
     V := P^.Last;
     repeat
       if V^.ComponentType in StepSet then WriteSubView(V);
       V := V^.Prev;
     until V = P^.Last;
  end;
end;

begin
  C:=CountChar;
  if WriteWith then
  begin
    CountChar:=CountChar+5;
    WriteForm(StrFormat(GetString(526),P^.ComponentName));
  end;
  DoWrite(Step1);
  DoWrite(Step2);
  DoWrite(Step3);
  DoWrite(Step4);

  if WriteWith then WriteForm(GetString(527));
  CountChar:=C;
end;

procedure MakeRangeILine(var S:string; P:PRangeILine);
begin
  S:=S+IntToStr(P^.Min)+', '+IntToStr(P^.Max);
end;

procedure MakeLabel(var S:string; P:PLabel);
begin
  S:=S+#39+PLabel(P)^.Text^+#39', '+ComponentName(P^.Link);
end;

procedure MakeInputLinePS(var S:string; P:PInputLinePS);
begin
  S:=S+IntToStr(P^.MaxLen)+', '#39+P^.PassChar+#39;
end;

procedure MakeButtons(var S:string; P:PView);
var
  S1,S2:string;
  param:array [1..4] of longint;
begin
  S2:=CommandName(PButton(P)^.Command);
  S1:=NameFlag(PButton(P)^.Flags);
  Param[1]:=Longint(PButton(P)^.Title);
  Param[2]:=Longint(@S2);
  Param[3]:=Longint(@S1);
  S:=S+StrFormat(GetString(511),Param);
end;

procedure MakeListBox(var S:string; P:PListBox);
begin
  S:=S+IntToStr(P^. NumCols )+','+ComponentName(P^.VScrollBar);
end;

procedure MakeMultiSelListBox(var S:string; P:PMultiSelBox);
var ss:string;
begin
  if not (byte(P^.SelectChar) in [32..127]) then sS:='#$'+IntToHex(byte(P^.SelectChar),2)
  else Ss:=''''+P^.SelectChar+'''';
  S:=S+IntToStr(P^. NumCols )+','+ComponentName(P^.VScrollBar)+', '+ss;
end;

procedure MakeListViewer(var S:string;  P:PListViewer);
begin
  S:=S+IntToStr(P^. NumCols )+','+ComponentName(P^.HScrollBar)+','+ComponentName(P^.VScrollBar);
end;

procedure MakeCluster(var S:string; V:PCluster);
var
  i:integer;
  S1,S2:string;
  W:Word;

procedure PrintItem( Item:PString);far;
begin
  S:=S1+StrFormat(GetString(512),Item);
  WriteForm( S);
end;

begin
  WriteForm(S);
  S1:=DupChar(' ', CountChar+12);
  V^.Strings.ForEach(@PrintItem);
  S:=S1+'nil'+DupChar(')',V^.Strings.Count);
end;

procedure MakeLockUpInputLine(var S:string; P:PLockUpInputLine);
var S1:string;
procedure PrintItem( Item:PString);far;
begin
  S:=S1+StrFormat(GetString(512),Item);
  WriteForm( S);
end;
begin
  WriteForm(S);
  S1:=DupChar(' ', CountChar+12);
  P^.List^.ForEach(@PrintItem);
  S:=S1+'nil'+DupChar(')',P^.List^.Count);
end;


procedure MakePPercentGauge(var S:string; P:PPercentGauge);
begin
  S:=S+IntToStr(P^.MaxValue);
end;

procedure MakeColorText(var S:string; P:PColorText);
begin
  S:=S+#39+P^.Text^+#39', $'+IntToHex(P^.Color,2);
end;

procedure MakeMemo(var S:string; P:PMemo);
begin
  S:=S+ComponentName(P^.HScrollBar)+', '+
       ComponentName(P^.VScrollBar)+', '+
       ComponentName(P^.Indicator)+', '+IntToStr(P^.BufSize);
end;

procedure MakeGrid(var S:string; P:PDrawGrid);
begin
  S:=S+ComponentName(P^.HScrollBar)+', '+
       ComponentName(P^.VScrollBar)+', '+
       ComponentName(P^.Indicator);
end;

procedure MakeDBSourse(var S:string; P:PDBSourse);
var SS,S1:string;
    PP:PString;
    i:Integer;
    R:array [0..5] of PString;
procedure DoCreateIndex(PP:PIndexObject);far;
begin
  WriteForm(DupChar(' ',4+CountChar)+ComponentName(P)+StrFormat(GetString(545),PP^.FileName));
end;
procedure DoAssignField(F:PField);
begin
  R[2]:=F^.Name;S1:=GetString(4030+byte(F^.FieldType)); R[5]:=R[2];
  WriteForm(RFormat(554,R));
end;
begin
  Delete(S, 1, 4+CountChar+26);
  Dec(S[0],3);
  PP:=@SS;
  SS:=SplitFileName(DinamicStr(P^.TableName));
  if P^.DatabaseName<>nil then SS:='<'+P^.DatabaseName^+'>\'+SS;
  S:=S+StrFormat(GetString(510),PP);
  WriteForm(S);
  if P^.Active then P^.DataSet^.IndexDefs^.ForEach(@DoCreateIndex);
  if P^.Active and (GeneratorOptions.CodeGeneration and $08<>0) then
  begin
    SS:=DupChar(' ',CountChar);
    R[0]:=@SS; R[1]:=P^.ComponentName;R[3]:=@S1; R[4]:=R[1];
    for i:=0 to P^.FieldDefs^.Count-1 do DoAssignField(P^.FieldDefs^.At(i));
  end;
  S:='';
end;

procedure MakeDBGrid(var S:string; P:PDBGrid);
var i:integer;
    Filler:string;
   Field:string;
procedure DoWrite(F:PDBGridField);far;
begin
  WriteForm(Field+':=New(PDBGridField, Init('+
          ComponentName(P)+', '
          +ComponentName(P^.DataSourse)+
     '^.FieldByName('''+DinamicStr(F^.FieldName)+''')));');
  WriteForm(Filler+ComponentName(P)+
     '^.FieldDefs^.Insert('+ComponentName(P)+'_Field);');
  WriteForm(Field+'^.SetWidth('+IntToStr(F^.Width)+');');
  if (F^.Align<>F^.Field^.Align) or
     (GeneratorOptions.CodeGeneration and $04 = 0) then
     WriteForm(Field+'^.Align:='+GetString(110+Ord(F^.Align))+';');
  if (stUpCase(F^.Name^)<>stUpCase(F^.Field^.Name^)) or
     (GeneratorOptions.CodeGeneration and $04 = 0) then
     WriteForm(Field+'^.SetTitle('''+DinamicStr(F^.Name)+''');');
  inc(i);
end;

begin
  S:=S+ComponentName(P^.ScrollBar)+', '+
       ComponentName(P^.DataSourse)+', '+
       ComponentName(P^.DataScroller);
  if P^.DataSourse<>nil then
  begin
    WriteForm(S+'));');
    WriteForm(DupChar(' ',CountChar)+ComponentName(P)+'^.FieldDefs^.FreeAll;');
    i:=0;
    Filler:=DupChar(' ',2+CountChar);
    Field:=Filler+ComponentName(P)+'_Field';
    P^.FieldDefs^.ForEach(@DoWrite);
    S:='';
  end;
end;

procedure MakeReportBand(var S:string;  P:PReportBand);
begin
  S:=S+ComponentName(P^.Report)+', '+ComponentName(P^.DataSourse)+
       ', '+ComponentName(P^.Detail)+'));';
  WriteForm(S);
  MakeGroup(P, true);
  S:='';
end;

procedure MakeReport(var S:string;  P:PReport);
var Param:array[1..2] of PString;
    Name:String;
begin
  S:=DupChar(' ',CountChar-2)+sNew;
  Name:=GetString(sComponentTypeNameBase+P^.ComponentType);
  param[1]:=P^.ComponentName;
  param[2]:=@Name;
  S:=StrFormat(S,Param);
  SetLength(S, Length(S)-3);
  S:=S+');';
  WriteForm(S);
  S:='';
end;

procedure MakeReportLabel(var S:string;  P:PReportLabel);
var S1:string;
begin
  if P^.ParamStr<>nil then S1:=P^.ParamStr^ else S1:='';
  S:=S+ComponentName(P^.Report)+','+GetString(Byte(P^.RLStyle)+530)+','''+S1+'''';
end;

procedure MakeDBLockUpText(var S:string;  P:PDBLockUpText);
var S1:string[60];
procedure PrintItem( Item:PString);far;
begin
  S:=S1+StrFormat(GetString(512),Item);
  WriteForm( S);
end;
begin
  if P^.FieldName<>nil then S1:=P^.FieldName^ else S1:='';
  S:=S+ComponentName(P^.DS)+', '''+S1+''',';
  WriteForm(S);
  S1:=DupChar(' ', CountChar+12);
  P^.Items^.ForEach(@PrintItem);
  S:=S1+'nil'+DupChar(')',P^.Items^.Count);
end;

procedure MakeDBText(var S:string;  P:PDBText);
var SS:string;
begin
  if P^.FieldName<>nil then SS:=P^.FieldName^ else SS:='';
  S:=S+ComponentName(P^.DS)+' ,'#39+SS+#39;
end;

procedure MakeStaticText(var S:string;  P:PStaticText);
var S1:string;
    Count:integer;

begin
   S1:=DinamicStr(P^.Text);

   if (Length(S1)+Length(S))>128 then
   begin
      WriteForm(S);
      S:='';
      repeat
        Count:=128-5-Length(S);
        S:=S+#39+Copy(S1,1,Count)+#39;
        Delete(S1,1,Count);
        if Length(S1)>0 then S:=S+'+'
        else S:=S+'));';
        WriteForm(QuteString(S));
        S:='';
      until (Length(S)+Length(S1))=0;
   end
   else
      S:=S+QuteString(#39+S1+#39);
end;

procedure MakeHistory(var S:string;  P:PHistory);
begin
  S:=S+ComponentName(P^.Link);
end;

procedure MakeDBLookupCombo(var S:string;  P:PDBLookupCombo);
begin
  S:=S+ComponentName(P^.DataSourse)+', '+ComponentName(P^.LookupSourse)+', '''+
       DinamicStr(P^.DataFieldName)+''', '''+
       DinamicStr(P^.LookupFieldName)+''', '''+
       DinamicStr(P^.LookupDisplayName)+''', '''+
       DinamicStr(P^.DisplayListName)+''', '+
     +BooleanToStr(P^.ReadOnly);
end;

procedure MakeDBEdit(var S:string;  P:PDBEdit);
begin
  S:=S+ComponentName(P^.DS)+', '''+DinamicStr(P^.FieldName)+'''';
end;

procedure MakeDBNavigatorBtn(var S:string;  P:PDBNavigatorBtn);
var
  S1,S2,S3:string[64];
  param:array [1..6] of longint;
begin
  S2:=CommandName(P^.Command);
  S1:=NameFlag(P^.Flags);
  Param[1]:=Longint(P^.Title);
  Param[2]:=Longint(@S2);
  Param[3]:=Longint(@S1);
  Param[4]:=Longint(@S3);
  S3:=ComponentName(P^.DataSourse);
  S:=S+StrFormat(GetString(544),Param);
end;

procedure MakeDBRadioButtons(var S:string;  P:PDBRadioButtons);
var S1:string[60];
procedure PrintItem( Item:PString);far;
begin
  S:=S1+StrFormat(GetString(512),Item);
  WriteForm( S);
end;
begin
  S:=S+ComponentName(P^.DS)+', '''+DinamicStr(P^.FieldName)+''',''';
  WriteForm(S);
  S1:=DupChar(' ', CountChar+12);
  P^.Strings.ForEach(@PrintItem);
  S:=DupChar(' ', CountChar+12)+'nil'+DupChar(')',P^.Strings.Count)+', ';
  if P^.ReadOnly then S:=S+'true' else S:=S+'false';
end;

procedure MakeDBCheckBox(var S:string;  P:PDBCheckBox);
var SS,S1:string[128];
begin
   if P^.ReadOnly then SS:='true' else SS:='false';
   if P^.Strings.Count>0 then S1:=PString(P^.Strings.At(0))^
   else S1:='';
   S:=S+ComponentName(P^.DS)+', '''+DinamicStr(P^.FieldName)+''','''+S1+''', '+
        SS+', '''+DinamicStr(P^.ValueChecked)+''', '''+DinamicStr(P^.ValueUnchecked)+'''';
end;

procedure MakeColorDisplay(var S:string;  P:PColorDisplay);
begin
  S:=S+'NewStr('''+DinamicStr(P^.Text)+''')'
end;

procedure MakeDBMemo(var S:string;  P:PDBMemo);
var S1:string;
begin
  if P^.Field<>nil then S1:=P^.Field^.Name^ else S1:='';
  S:=S+ComponentName(P^.HScrollBar)+', '+
       ComponentName(P^.VScrollBar)+', '+
       ComponentName(P^.Indicator)+', '+
       ComponentName(P^.DataSourse)+', '+
       ''''+S1+'''';
end;

procedure MakeReportShape(var S:string;  P:PReportShape);
begin
  S:=S+GetString(548+byte(P^.Shape))+', '+GetString(551+byte(P^.PenStyle));
end;

end.
