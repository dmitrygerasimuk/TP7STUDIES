{$O+}
unit RMacros;
interface
uses Parser, Intrpret, Ext_Edit, Objects, Ext_Type;
type
  TExecProc = procedure(const Sender:PParser; var p1,p2,p3, Value:string);
  PMacroProc = ^TMacroProc;
  TMacroProc = record
    Name:PString;
    Proc:TExecProc;
  end;
type
  PControlBlock = ^TControlBlock;
  TControlBlock = object(TSortedCollection)
    EditWin:PExtEditWindow;
    TempPos:TLargePoint;
    Forms:PCollection;
    constructor Init;
    destructor Done;virtual;
    procedure Execute(const Sender:PParser; AName:string;  var p1,p2,p3, Value:string);
    function Compare(Key1, Key2: Pointer): Integer; virtual;
    procedure FreeItem(Item: Pointer); virtual;
  end;

procedure ExecuteScript(ScriptName:FNameStr);
procedure ScripFunction(Owner:PObject; Sender:PParser; const Name:String; var p1,p2,p3, Value:string);far;
function RegisterMacroExecuterProc(const AName:string; Proc:TExecProc):PMacroProc;
procedure SetValue(Sender:PInterpretator; const Name:String; var Value:TParserValue);far;
var
  ControlBlock:PControlBlock;
implementation
uses Clases, Global, ResTools, ResStrs, Register, Views, MsgBox, Ext_Dos,
     Ext_Math, Ext_Str, Std_Str, App, Prperty;

procedure ExecuteScript(ScriptName:FNameStr);
var I:PInterpretator;
    F,T,E:PStrings;
    Rec:TListBoxRec;
    P:PString;
    EditWindow:PExtEditWindow;
    S:string;
    X,Y:Longint;
begin
{  I:=New(PInterpretator, Init);
  I^.Parser.OnFunction:=ScripFunction;
  I^.OnSetValue:=SetValue;
  F:=New(PStrings, Init);
  T:=New(PStrings, Init);
  E:=New(PStrings, Init);
  F^.LoadFromFile(ScriptName);
  I^.PrepareScript(F^, T^, E^);
  if not I^.Error then
  begin
    New(ControlBlock, Init);
    I^.DoScript(T^);
    Dispose(ControlBlock, Done);
  end
  else
  begin
    EditWindow:=CreateEditWindow(ScriptName, hcNoContext);
    if E^.Count >0 then
    begin
      Rec.List:=E;
      Rec.Selection:=0;
      S:=E^.Str(0);
      Delete(S,1, Length(sErrorLine));
      X:=Pos('/',S);
      Y:=StrToInt( trim( Copy(S, 1, X-1)));
      X:=StrToInt(trim(Copy(S, X+1, Pos(':',S)-X-1)));
      with EditWindow^.Editor^ do
      begin
        SetCurPos(X,Y-1);
        TrackCursor(true);
      end;
      RExecDialog(sAppWizardDlg, @Rec)
    end
    else
    begin
      P:=@ScriptName;
      RMessageBox(sErrorExecMacro, @P, mfError+mfOkButton);
    end;
  end;
  Dispose(F, Done);
  Dispose(T, Done);
  Dispose(E, Done);
  Dispose(I, Done);}
end;

procedure ScripFunction(Owner:PObject; Sender:PParser; const Name:String; var p1,p2,p3, Value:string);
begin
  ControlBlock^.Execute(Sender, Name, p1,p2,p3, Value);
end;

procedure SetValue(Sender:PInterpretator; const Name:String; var Value:TParserValue);
var s,s1:string;
    i:integer;
    P:PView;

function SetPropValue(Name, Value:string):boolean;
var List:PCollection;
    i:integer;
    Prop,R:PProperty;
begin
  SetPropValue:=false;
  if P<>nil then
     List:=PCollection(ResourseFile.Get('Property_'+NameComponentType(P)))
  else List:=nil;
  if List<>nil then
  begin
    R:=nil;
    for i:=0 to List^.Count-1 do
    begin
      Prop:=PProperty(List^.At(i));
      Prop^.SetPointer(P, P);
      if stUpCase(Prop^.Name^)=Name then R:=Prop;
    end;
    if R<>nil then
    begin
      R^.SetAsText(Value);
      SetPropValue:=true;
    end;
    Dispose(List, Done);
  end
end;

begin
  if Pos('.',Name)<>0 then
  begin
    S1:=stUpCase(Name);
    S:=Copy(S1, 1, Pos('.',S1)-1);
    Delete(S1, 1, Pos('.',S1));
    for i:=0 to ControlBlock^.Forms^.Count-1 do
    begin
      if stUpCase(S)=stUpCase(PView(ControlBlock^.Forms^.At(i))^.ComponentName^) then
      begin
        P:=ControlBlock^.Forms^.At(i);
        SetPropValue(S1,Value.AsString);
        exit;
      end;
    end;
  end
  else Sender^.Variables^.SetVariable(Name, Value);
end;


function RegisterMacroExecuterProc(const AName:string; Proc:TExecProc):PMacroProc;
var R:PMacroProc;
begin
  New(R);
  R^.Name:=NewStr(stUpCase(AName));
  R^.Proc:=Proc;
  RegisterMacroExecuterProc:=R;
end;

procedure MInsertText(const Sender:PParser; var p1,p2,p3, Value:string);far;
var R:TParserValue;
begin
  if ControlBlock^.EditWin=nil then exit;
  R.Init;
  Sender^.Calc(P1,R);
  ControlBlock^.EditWin^.Editor^.InsertLine(R.AsString+sEol, false);
  R.Done;
end;

procedure MInsertChars(const Sender:PParser; var p1,p2,p3, Value:string);far;
var R:TParserValue;
begin
  if ControlBlock^.EditWin=nil then exit;
  R.Init;
  Sender^.Calc(P1,R);
  ControlBlock^.EditWin^.Editor^.InsertLine(R.AsString, false);
  R.Done;
end;


procedure MOpenWindow(const Sender:PParser; var p1,p2,p3, Value:string);far;
var R:TParserValue;
begin
  R.Init;
  Sender^.Calc(P1,R);
  ControlBlock^.EditWin:=CreateEditWindow(R.AsString, hcNoContext);
  R.Done;
end;

procedure MLiteralChar(const Sender:PParser; var p1,p2,p3, Value:string);far;
var R:TParserValue;
    S:string;
begin
  if ControlBlock^.EditWin=nil then exit;
  R.Init;
  Sender^.Calc(P1,R);
  if R.AsNumeric=13 then S:=sEol else S:=Char(Round(R.AsNumeric));
  ControlBlock^.EditWin^.Editor^.InsertLine(S, false);
  R.Done;
end;

procedure MSaveFile(const Sender:PParser; var p1,p2,p3, Value:string);far;
var R:TParserValue;
begin
  if ControlBlock^.EditWin=nil then exit;
  if P1<>'' then
  begin
    R.Init;
    Sender^.Calc(P1,R);
    ControlBlock^.EditWin^.Editor^.SaveFile(R.AsString);
    R.Done;
  end
  else ControlBlock^.EditWin^.Editor^.Save;
end;

procedure MInputBox(const Sender:PParser; var p1,p2,p3, Value:string);far;
var R:TParserValue;
    S1,S2:string;
    L:integer;
begin
  R.Init;
  Sender^.Calc(P1,R);
  S1:=R.AsString;
  R.Clear;
  Sender^.Calc(P2,R);
  S2:=R.AsString;
  if P3<>'' then
  begin
    R.Clear;
    Sender^.Calc(P3,R);
    L:=Min(Round(R.AsNumeric), 255);
  end else L:=255;
  if InputBox('Введите данные.', S1, S2, L)<>cmOk then S2:='';
  Value:=S2;
  R.Done;
end;

procedure MSetTempPos(const Sender:PParser; var p1,p2,p3, Value:string);far;
begin
  if ControlBlock^.EditWin=nil then exit;
  ControlBlock^.TempPos:=ControlBlock^.EditWin^.Editor^.CurPos;
end;

procedure MMoveToTempPos(const Sender:PParser; var p1,p2,p3, Value:string);far;
begin
  if ControlBlock^.EditWin=nil then exit;
  with ControlBlock^ do
  begin
    EditWin^.Editor^.SetCurPos(TempPos.X,TempPos.Y);
    EditWin^.Editor^.TrackCursor(true);
  end;
end;

procedure MLoadFrom(const Sender:PParser; var p1,p2,p3, Value:string);far;
var P:PView;
    S:PStream;
    R:TParserValue;
    St:string;
begin
  R.Init;
  Sender^.Calc(P2,R);
  St:=R.AsString;
  R.Clear;
  if FileExists(st) then
  begin
    S:=New(PDosStream, Init(st,stOpenRead));
    P:=PView(S^.Get);
    S^.Free;
  R.Init;
  Sender^.Calc(P1,R);
  St:=R.AsString;
  R.Clear;
    AssignStr(P^.ComponentName, St);
    ControlBlock^.Forms^.Insert(P);
  end;
end;

procedure MShowModal(const Sender:PParser; var p1,p2,p3, Value:string);far;
var P:PView;
    i:integer;
begin
  for i:=0 to ControlBlock^.Forms^.Count-1 do
  begin
    if stUpCase(Value)=stUpCase(PView(ControlBlock^.Forms^.At(i))^.ComponentName^) then
    begin
      Desktop^.ExecView(PView(ControlBlock^.Forms^.At(i)));
      exit;
    end;
  end;
end;


 {TControlBlock}
constructor TControlBlock.Init;
begin
  inherited Init(10,10);
  Forms:=New(PCollection, Init(10,5));
  insert(RegisterMacroExecuterProc('InsertText', MInsertText));
  insert(RegisterMacroExecuterProc('OpenWindow', MOpenWindow));
  insert(RegisterMacroExecuterProc('LiteralChar', MLiteralChar));
  insert(RegisterMacroExecuterProc('SaveFile', MSaveFile));
  insert(RegisterMacroExecuterProc('InputBox', MInputBox));
  insert(RegisterMacroExecuterProc('MoveToTempPos', MMoveToTempPos));
  insert(RegisterMacroExecuterProc('SetTempPos', MSetTempPos));
  insert(RegisterMacroExecuterProc('InsertChars', MInsertChars));
  insert(RegisterMacroExecuterProc('ShowModal',MShowModal));
  insert(RegisterMacroExecuterProc('LoadFrom',MLoadFrom));
end;

destructor TControlBlock.Done;
begin
  Dispose(Forms, Done);
  inherited Done;
end;

procedure TControlBlock.Execute(const Sender:PParser; AName:string;  var p1,p2,p3, Value:string);
var R1:TMacroProc;
    R2:PMacroProc;
    Index: Integer;
begin
  R1.Name:=@AName;
  if Pos('.',AName)<>0 then
  begin
    Value:=Copy(AName, 1, Pos('.',AName)-1);
    System.Delete(AName, 1, Pos('.',AName));
  end;
  if Search(@R1,Index) then
  begin
    R2:=At(Index);
    if Assigned(R2^.Proc) then R2^.Proc(Sender, p1,p2,p3, Value);
  end;
end;

function TControlBlock.Compare(Key1, Key2: Pointer): Integer;
var P1:PMacroProc absolute Key1;
    P2:PMacroProc absolute Key2;
begin
  if P1^.Name^ < P2^.Name^ then Compare:=-1 else
  if P1^.Name^ > P2^.Name^ then Compare:=1 else
  Compare:=0
end;

procedure TControlBlock.FreeItem(Item: Pointer);
var P:PMacroProc absolute Item;
begin
  DisposeStr(P^.Name);
  Dispose(P);
end;

end.
