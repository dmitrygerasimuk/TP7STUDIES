{$A+,D+,F-,G+,O+}
unit Type_Rec;
interface
uses Views;

procedure WriteTypeElements(V:PView);
procedure DoWriteNotVisual(V:PView);
implementation
uses Ext_Math, Global, Dialogs, AddCntrl, MultiSel, StdDlg, DataCtrl, Editors,
     ResTools, DBCtrls, GauGes, Querys, DAE, Objects, Register;

procedure WriteTypeElements(V:PView);
var S:string;
    a:array [1..4] of Longint;
    b:array [1..4] of Pointer absolute a;
begin
  S:='      '+V^.ComponentName^+':';
  case V^.ComponentType of
    ctDBEdit,
    ctInputLinePS,
    ctInputLineUC,
    ctInputLineLC,
    ctFilterInput,
    ctInputLine:S:=S+'string['+IntToStr(V^.DataSize-1)+']';
    ctOkListBox,
    ctMultiSelBox,
    ctSortedListBox,
    ctListBox:S:=S+'TListBoxRec';
    ctCheckBoxes, ctRadioButtons,
    ctMultiCheckBoxes: S:=S+'word';
    ctParamText:S:=S+'array [1..'+IntToStr(PParamText(V)^.ParamCount)+'] of pointer';
    ctDBSourse:S:=S+'PDbf';
    ctLockUpInputLine,
    ctRangeILine:S:=S+'Longint';
    ctMemo:begin
             a[1]:=V^.DataSize-3;
             S:=S+StrFormat(GetString(538),a)
           end;
    ctDateEdit:S:=S+'TDateTime';
    ctPercentGauge,
    ctBarGauge:S:=S+'TPersentRec';
  else
    S:=S+'array [1..'+IntToStr(V^.DataSize)+'] of byte';
  end;
  WriteForm(S+';');
end;
procedure CreateDataSourseFields(P:PDataSourse);forward;
procedure DoWriteNotVisual(V:PView);
begin
  case V^.ComponentType of
    ctDataSourse,
    ctDBSourse,
    ctQuery:CreateDataSourseFields(PDataSourse(V));
  end;
end;

procedure CreateDataSourseFields(P:PDataSourse);
var S,S2:string[128];
    R:array[1..3] of PString;
procedure DoWrite(F:PField);far;
begin
  R[2]:=F^.Name;
  S2:=GetString(4030+byte(F^.FieldType));
  WriteForm(StrFormat(S,R));
end;
begin
  if not P^.Active then exit;
  R[1]:=P^.ComponentName;
  R[3]:=@S2;
  S:=GetString(553);
  P^.FieldDefs^.ForEach(@DoWrite);
end;

end.
