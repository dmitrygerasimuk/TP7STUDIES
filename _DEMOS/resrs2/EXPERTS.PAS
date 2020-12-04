unit Experts;
{$F-,O+,S-,A+,R-,G+,N+,E+}
interface
uses Clases, Objects;
type
  TResourceListRec = record
    List:PStrings;
    Selection:word;
  end;

type
  TPageTitle = record
    Length: Word;
    Buffer: array [1..255] of char;
  end;

procedure ReportExpert;
procedure DialogExpert;
procedure AppExpert;
implementation
uses ResTools, ResStrs, Ext_Math, Views, DAE, DBFTable, DataCtrl, App,
     Reports, Register, RsCllt, DBCtrls, Dialogs, Ext_Str, TabNotbk,
     Drivers, CmdConst, Cursors, Dos, Ext_Dos, RMacros, Ext_Type;

procedure ReportExpert;
var S:string;
    i,j:integer;
    W,ReportBands:word;
    A:array[1..4] of Pointer;
    Lists:array[1..2] of TResourceListRec;
    D:PDataSet;
    DBText:PDBText;
    F:PFormMain;
    RB:PReportBand;
    DS:PDBSourse;
    Report:PReport;
    R,R1:TRect;

procedure InsertRB(ReportBandType:TReportBandType);
begin
  RB:=New(PReportBand, Init(R, Report, DS, nil));
  RB^.ComponentName:=NewStr(GetName(F, RB));
  F^.FormPtr^.Insert(RB);
  Report^.SetReportBand(RB,ReportBandType);
  R.Move(0,2);
end;

begin
{  W:=0; ReportBands:=$0F;
  S:=sExtDBF;
  A[1]:=@W; A[2]:=@S; A[3]:=@ReportBands; A[4]:=@Lists;
  Lists[1].List:=New(PStrings, Init);
  Lists[1].Selection:=0;
  Lists[2].List:=New(PStrings, Init);
  Lists[2].Selection:=0;
  i:=1;
  while (i<5) and (I>0) do
  begin
     case ExecDialog('RExp_'+intToStr(i),A[i]) of
        cmCancel:break;
        cmYes:dec(i);
     else
        inc(i);
     end;
     if (i=4) and (Lists[1].List^.Count=0) then
     begin
       D:=OpenDataSet(S);
//       D:=New(PDbfTable, Init(S,stOpenRead));
       if D<>nil then
       begin
         for j:=0 to D^.FieldCount-1 do
         Lists[1].List^.Insert(NewStr(D^.Fields(j)^.Name^));
         D^.Free;
       end
       else i:=2;
     end;
  end;
  if i=5 then
  begin
    F:=ProjectCollection^.NewForm(PDialog(GetView(sReportForm)));
    Application^.InsertWindow( F^.FormPtr);
    DS:=New(PDBSourse, Init(New(PDbfTable, Init(S, stOpen))));
    DS^.ComponentName:=NewStr(GetName(F, DS));
    F^.FormPtr^.Insert(DS);
    Report:=New(PReport, Init);
    Report^.ComponentName:=NewStr(GetName(F, Report));
    R.Assign(1,1,50,3);
    F^.FormPtr^.Insert(Report);
    if (ReportBands and 1)<>0 then
       InsertRB(rbtDocHeader);
    if (ReportBands and 2)<>0 then
       InsertRB(rbtPageHeader);
    R1.Assign(1, R.A.Y,
       50, min(F^.FormPtr^.Size.Y-4, Lists[2].List^.Count+R.A.Y+1));
    RB:=New(PReportBand, Init(R1, Report, DS, nil));
    RB^.ComponentName:=NewStr(GetName(F, RB));
    F^.FormPtr^.Insert(RB);
    Report^.SetReportBand(RB,rbtMain);
    for i:=0 to Lists[2].List^.Count-1 do
    begin
      R.Assign(1+3*(i div (RB^.Size.Y-1)),
               i mod (RB^.Size.Y-1),
               20+3*(i div (RB^.Size.Y-1)),
               i mod (RB^.Size.Y-1)+1);
      DBText:=New(PDBText, Init(R, DS, Lists[2].List^.Str(i)));
      DBText^.ComponentName:=NewStr(GetName(F, DBText));
      RB^.Insert(DBText);
    end;
    RB^.ReDraw;
    R.Assign(1,R1.B.Y,50,R1.B.Y+2);
    if (ReportBands and 4)<>0 then
       InsertRB(rbtPageFooter);
    if (ReportBands and 8)<>0 then
       InsertRB(rbtDocFooter);
  end;
  Dispose(Lists[1].List, Done);
  Dispose(Lists[2].List, Done);}
end;

procedure DialogExpert;
var DlgType:Word;
    ButtonAlign:word;
    PageTitle:TPageTitle;
    Param:array [1..4] of pointer;
    Step,j,i:integer;
    F:PFormMain;
    Dlg:PDialog;
    P:PTabbedNotebook;
    S:PStrings;
    St:string;
begin
{  FillChar(Param, SizeOf(Param),0);
  FillChar(PageTitle, SizeOf(TPageTitle),0);
  ButtonAlign:=0;
  Param[1]:=@DlgType;
  Param[2]:=@ButtonAlign;
  Param[3]:=@PageTitle;
  Param[4]:=@ButtonAlign;
  DlgType:=0;
  Step:=1;
  repeat
    j:=Step+DlgType*byte(Step<>1);
    case ExecDialog('DialogWizzard_'+IntToStr(j),
         Param[j]) of
        cmCancel:begin
                   Step:=0;
                   break;
                 end;
        cmYes:dec(Step);
     else
        inc(Step);
     end;
  until (Step<0) or ((Step>2) and (DlgType=0)) or ((Step>3) and (DlgType=1));
  if Step>=2+DlgType*2 then
  begin
    Dlg:=PDialog(GetView(sExpDlgForm+ButtonAlign));
    F:=ProjectCollection^.NewForm(Dlg);
    F^.Modified:=true;
    Message(Application, evBroadcast, cmCurentChang, nil);
    Application^.InsertWindow(Dlg);
    AssignStr(Dlg^.Title, Dlg^.ComponentName^);
    if (DlgType=1) then
    begin
      S:=New(PStrings, Init);
      i:=1;
      St:='';
      with PageTitle do
      while i<=Length+1 do
      begin
        if (Buffer[i]=#13) or (i>Length) then
        begin
          if Trim(St)<>'' then S^.Insert(NewStr(St));
          St:='';
          inc(i);
        end
        else St:=St+Buffer[i];
        inc(i);
      end;
      if S^.Count<>0 then
      begin
        P:=PTabbedNotebook(GetView(sPTabbedNotebook+ButtonAlign));
        Dlg^.Insert(P);
        for i:=0 to S^.Count-1 do P^.AddToPage(S^.Str(i),nil);
      end;
      Dispose(S, Done);
    end;
    Dlg^.ReDraw;
  end;}
end;

  { TMacroItem }
const
 sTitle = '//$TITLE ';

procedure AppExpert;
var Rec:SearchRec;
    RRec:TListBoxRec;
    List:PStrings;
    S:PStream;
    St:String;
    Path:PathStr;
    A:array[1..2] of PString;
begin
  Path:=ExePath;
  FindFirst(Path+'*.RSC', Archive, Rec);
  List:=New(PStrings, Init);
  while DosError = 0 do
  begin
    S:=New(PDosStream, Init(Path+Rec.Name, stOpen));
    St:=ReadText(S^);
    S^.Free;
    if stUpCase(Copy(St, 1, Length(sTitle)))=sTitle then
    begin
      Delete(St, 1, Length(sTitle));
      A[1]:=@St; A[2]:=@Rec.Name;
      List^.Insert(NewStr(Format('%-55s %s',A)))
    end;
    FindNext(Rec);
  end;
  RRec.List:=List;
  RRec.Selection:=0;
  if ExecDialog(sAppWizardDlg, @RRec)<>cmCancel then
     St:=Copy(List^.Str(RRec.Selection), 57, 255)
  else St:='';
  Dispose(List, Done);
  if St<>'' then ExecuteScript(Path+St);
end;

end.
