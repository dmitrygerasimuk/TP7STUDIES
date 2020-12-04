{$O+}
{$I Define.inc}
unit RsCllt;
interface
uses Objects, Dialogs, Views, Dos, IniFile;
type
   PFormMain = ^TFormMain;
   TFormMain = record
      Options:word;
      Flags:Byte;
      DragMode:byte;
      GrowMode:byte;
      Number:Byte;
      ProcName:string[60];
      UnitName:FNameStr;
      ResName:FNameStr;
      Modified:boolean;
      FormPtr:PDialog;
      FormName:PString;
   end;

const
  FreeProject: boolean = false;
type
  PResCollection = ^TResCollection;
  TResCollection = object(TStringCollection)
    HelpFile:PString;
    OutputHelpFileDir:PString;
    constructor Init;
    constructor LoadProgect(S:PIniFile);
    procedure SaveProgect(S:PIniFile);
    destructor Done;virtual;
    constructor Load(var S:TStream);
    procedure Store(var S:TStream);
    procedure FreeItem(Item: Pointer); virtual;
    function GetItem(var S: TStream): Pointer; virtual;
    procedure PutItem(var S: TStream; Item: Pointer); virtual;
    function KeyOf(Item: Pointer): Pointer; virtual;
    function NewForm(Dialog:PDialog):PFormMain;
    function InCollect( Item:PView):boolean;
    procedure DeleteForm( Item:PGroup);
    procedure InsertElement( Item:PView);
    procedure CurentUpDate(Info:pointer);
    function FindForm(D:PGroup):PFormMain;
    function GetHelpFile:String;
    function GetOutputHelpFileDir:string;
  private
    Look:boolean;
  end;

function NewFormNil(P:PDialog):PFormMain;
procedure LoadForm(Form:PFormMain);
procedure StoreForm(Form:PFormMain);
function FindByName( Form:PFormMain; Name:string):PView;
procedure CurentSelect;
function GetName(Form:PFormMain; AView:PView):string;
function FindFormByName(Name:string):PFormMain;
const
    ProjectCollection:PResCollection = nil;

implementation
uses Ext_Dos, Ext_Math, App, Drivers, CmdConst, Cursors, ResTools,
     GLType, Global, ResStrs, MsgBox, Reports, Ext_Str, Register;

procedure CurentSelect;
begin
  if (_Cursor=nil) then exit;
  Message(Application, evBroadcast, cmCurSelect, _Cursor^.EditView);
end;

function NewFormNil(P:PDialog):PFormMain;
var
  ACF:PFormMain;
begin
  New(ACF);
  With ACF^ do
  begin
     FormPtr:=P;
     Modified:=true;
     if P<>nil then
     begin
       Flags:=P^.Flags;
       DragMode:=P^.DragMode;
       GrowMode:=P^.GrowMode;
       Options:=P^.Options;
     end;
  end;
  NewFormNil:=ACF;
end;

 { TResCollection }

constructor TResCollection.Init;
begin
  inherited Init(10,5);
  Look:=true;
end;

destructor TResCollection.Done;
var i,c:integer;
    P:Pointer;
begin
  c:=Count-1;
  for i:=0 to c do
  begin
    p:=At(0);
    AtDelete(0);
    Message(Application, evBroadcast, cmCurSelect, nil);
    FreeItem(P);
  end;
  inherited Done;
end;

constructor TResCollection.Load(var S:TStream);
begin
  inherited Load(S);
  Look:=true;
  HelpFile:=S.ReadStr;
  OutputHelpFileDir:=S.ReadStr;
end;

constructor TResCollection.LoadProgect(S:PIniFile);
var ACount, i:integer;

function ReadItem:PFormMain;
var
  {$IFDEF VER70} Result:PFormMain;{$ENDIF}
  Form:PFormMain;
  f:boolean;
  SectName:string;
begin
  New(Result);
  FillChar(Form^, SizeOf(TFormMain), 0);
  SectName:=sForm+IntToStr(i);
  F:=S^.ReadBoolean(SectName, sVisible, false);
  Form^.Options:=S^.ReadInteger(SectName, sOptions, 0);
  Form^.GrowMode:=S^.ReadInteger(SectName, sGrowMode, 0);
  Form^.DragMode:=S^.ReadInteger(SectName, sDragMode, 0);
  Form^.Flags:=S^.ReadInteger(SectName, sFlags, 0);
  Form^.Number:=S^.ReadInteger(SectName, sNumber, 0);
  Form^.ProcName:=S^.ReadString(SectName, sProcName, '');
  Form^.UnitName:=S^.ReadString(SectName, sUnitName, '');
  Form^.ResName:=S^.ReadString(SectName, sResName, '');
  AssignStr(Form^.FormName, S^.ReadString(SectName, sFormName, ''));
  if F then LoadForm(Result);
  {$IFDEF VER70} ReadItem:=Result;{$ENDIF}
end;

begin
  inherited Init(10,5);
  ACount:=S^.ReadInteger(sProgect, sCount, 0);
  for i:=1 to ACount do Insert(ReadItem);
end;

procedure TResCollection.SaveProgect(S:PIniFile);
var i:integer;

procedure StoreItem(Form:PFormMain);
var
  Dir: DirStr;
  AName: NameStr;
  Ext: ExtStr;
  SectName:string;
begin
  SectName:=sForm+IntToStr(i);
  S^.WriteBoolean(SectName, sVisible, Form^.FormPtr<>nil);
  S^.WriteInteger(SectName, sOptions, Form^.Options);
  S^.WriteInteger(SectName, sGrowMode, Form^.GrowMode);
  S^.WriteInteger(SectName, sDragMode, Form^.DragMode);
  S^.WriteInteger(SectName, sFlags, Form^.Flags);
  S^.WriteInteger(SectName, sNumber, Form^.Number);
  S^.WriteString(SectName, sProcName, Form^.ProcName);
  S^.WriteString(SectName, sUnitName, Form^.UnitName);
  FSplit(Form^.ResName, Dir, AName, Ext);
  if Dir='' then
  begin
    Dir:=CurrentDir(CurrentDrive);
    Form^.ResName:=Dir+AName+Ext;
  end;
  S^.WriteString(SectName, sResName, Form^.ResName);
  S^.WriteString(SectName, sFormName, Form^.FormName^);
end;

begin
  S^.WriteInteger(sProgect, sCount, Count);
  for i:=0 to Count-1 do StoreItem(At(i));
end;

procedure TResCollection.Store(var S:TStream);
begin
  inherited Store(S);
  S.WriteStr(HelpFile);
  S.WriteStr(OutputHelpFileDir);
end;

procedure StoreForm(Form:PFormMain);
var
  S1:TBufStream;
  i:integer;
  Dir: DirStr;
  AName: NameStr;
  Ext: ExtStr;
  S:FNameStr;
  P:Pointer;
begin
  with Form^ do
  if Modified then
  begin
     if ResName='' then
     begin
        S:=UnitName;
        if ExecDialog(sFormSaveDialog,@S)=cmCancel then exit;
        ResName:=S;
     end;
     FSplit(ResName, Dir, AName, Ext);
     S:=CurrentDir(CurrentDrive);
     if Dir=S then
        ResName:=AName+Ext
     else
     if ASCIICompare(S,Dir)=0 then
        Delete(ResName,1,Length(S));
     if FileExists(ResName) {and (EditOpt and $01 <> 0)} then
        BakUpFile(ResName,'.~fm',true);
     S1.Init(ResName,stCreate,2048);
     S1.Put(FormPtr);
     S1.Done;
     Modified:=false;
  end;
end;

procedure LoadForm(Form:PFormMain);
var S1:TBufStream;
    P:PString;
begin
   S1.Init(Form^.ResName,stOpenRead,2048);
   Form^.FormPtr:=PDialog(S1.Get);
   if S1.Status<>stOk then
   begin
     P:=@Form^.FormName;
     RMessageBox(sNoLoadForm, P, mfError+mfOkButton);
     Form^.FormPtr^.Free;
     Form^.FormPtr:=nil;
   end
   else DeskTop^.Insert(Form^.FormPtr);
   S1.Done;
end;

function TResCollection.GetItem(var S: TStream): Pointer;
var
  Form:PFormMain;
  f:boolean;
begin
  New(Form);
  FillChar(Form^, SizeOf(TFormMain), 0);
  S.Read(Form^.Options, SizeOf(Word)+SizeOf(Byte)*4);
  with Form^ do
  begin
     ProcName:=ReadString(S);
     UnitName:=ReadString(S);
     ResName:=ReadString(S);
     S.Read(f,SizeOf(Boolean));
     FormName:=S.ReadStr;
  end;
  if F then LoadForm(Form);
  GetItem:=Form;
end;

procedure TResCollection.PutItem(var S: TStream; Item: Pointer);
var
  Form:PFormMain absolute Item;
  f:boolean;
  Dir: DirStr;
  AName: NameStr;
  Ext: ExtStr;
begin
  f:=Form^.FormPtr<>nil;
  if f then StoreForm(Form);
  S.Write(Form^.Options, SizeOf(Word)+SizeOf(Byte)*4);
  with Form^ do
  begin
     WriteString( S, ProcName);
     WriteString( S, UnitName);
     FSplit(ResName, Dir, AName, Ext);
     if Dir='' then
     begin
       Dir:=CurrentDir(CurrentDrive);
       ResName:=Dir+AName+Ext;
     end;
     WriteString( S, ResName);
     S.Write(f,SizeOf(Boolean));
     S.WriteStr(FormName);
  end;
end;


procedure TResCollection.FreeItem(Item: Pointer);
var
  Form:PFormMain absolute Item;
  P:PView;
begin
  if Form^.FormPtr<>nil then
  begin
    if (Form^.Modified) and not FreeProject  then StoreForm(Form);
    P:=Form^.FormPtr;
    Form^.FormPtr:=nil;
    Dispose(P,Done);
  end;
  DisposeStr(Form^.FormName);
  Dispose(Form);
end;

function TResCollection.KeyOf(Item: Pointer): Pointer;
var
  Form:PFormMain absolute Item;
begin
  KeyOf:=Form^.FormName;
end;

function TResCollection.NewForm(Dialog:PDialog):PFormMain;
var
  R:TRect;
  ACF:PFormMain;
  i:word;

function FindNumber(Item:PFormMain):Boolean;far;
begin
  FindNumber:='FORM'+IntToStr(i)=stUpCase(Item^.FormName^);
end;

begin
  I:=1;
  while FirstThat(@FindNumber)<>nil do inc(i);
  if Dialog=nil then
  begin
    R.Assign( 10, 5, 70, 20);
    Dialog:=New(PDialog,Init(R,'Form '+IntToStr(i)));
    AssignStr(Dialog^.ComponentName,'Form'+IntToStr(i));
  end;
  ACF:=NewFormNil(Dialog);
  with ACF^ do
  begin
     FormName:=NewStr(Dialog^.ComponentName^);
     ProcName:='NewForm'+IntToStr(i);
     UnitName:='Unit'+IntToStr(i);
     ResName:='';
     Number:=i;
  end;
  Dialog^.GrowMode:=Dialog^.GrowMode or (gfGrowAll + gfGrowRel);
  Dialog^.Flags:=Dialog^.Flags or wfGrow;
  NewForm:=ACF;
  Insert(ACF);
  Message(Application, evBroadcast, cmCurSelect, nil);
end;

function TResCollection.InCollect( Item:PView):boolean;
function Test(P:PFormMain):boolean;far;
begin
  Test:=Pointer(P^.FormPtr)=Item;
end;
begin
  InCollect:=false;
  if Item=nil then exit;
  if Look then InCollect:=FirstThat(@Test)<>nil
end;

procedure TResCollection.DeleteForm( Item:PGroup);
var
  Form:PFormMain;
function Test(AItem:PFormMain):Boolean;far;
begin
  Test:=AItem^.FormPtr=PDialog(Item);
end;
begin
  Form:=FirstThat(@Test);
  if (Form=nil) or (Form^.FormPtr=nil) then exit;
  if (_Cursor^.Owner<>nil) and
     ((_Cursor^.Owner=Pointer(Form^.FormPtr)) or
     (_Cursor^.Owner^.Owner=Pointer(Form^.FormPtr))) then
  begin
     _Cursor^.Owner^.Delete(_Cursor);
     _Cursor^.SetLink(nil);
  end;
  if Form^.Modified then StoreForm(Form);
  Message(Application, evBroadcast, cmDelCurForm, Form^.FormPtr);
  dispose(Form^.FormPtr,Done);
  Form^.FormPtr:=nil;
end;

function GetName(Form:PFormMain; AView:PView):string;
var S:string;
    i:integer;
function Test(P:PView):boolean;far;
var b:boolean;
function DoTest(AP:PView):boolean;far;
begin
  if AP^.ComponentName<>nil then
     DoTest:=stUpCase(AP^.ComponentName^)=stUpCase(S+IntToStr(i))
  else DoTest:=false;
end;
begin
  if P^.ComponentName<>nil then
     B:=stUpCase(P^.ComponentName^)=stUpCase(S+IntToStr(i))
  else B:=false;
  if not b then
     if P^.ComponentType in GroupControl then
        B:=PGroup(P)^.FirstThat(@DoTest)<>nil;
  Test:=B;
end;
begin
  i:=1;
  S:=GetString(AView^.ComponentType+sComponentTypeNameBase);
  while Form^.FormPtr^.FirstThat(@Test)<>nil do inc(i);
  GetName:=S+IntToStr(i);
end;

procedure IElement( Form:PFormMain; AView:PView);
var P:PGroup;
begin
  AView^.ComponentName:=NewStr(GetName(Form, AView));
  if (_Cursor^.EditView<>nil) and
     ((_Cursor^.EditView^.Owner=PGroup(Form^.FormPtr)) or
     (_Cursor^.EditView^.Owner^.Owner=PGroup(Form^.FormPtr)))
      and
     ((_Cursor^.EditView^.ComponentType in GroupControl) or
     (_Cursor^.Owner^.ComponentType in GroupControl))
     and
     (AView^.ComponentType in ComponentToGroup) then
     if _Cursor^.EditView^.ComponentType in GroupControl then
        P:=PGroup(_Cursor^.EditView)
     else P:=_Cursor^.Owner
  else P:=Form^.FormPtr;
  if AView^.ComponentType in [ctReportBand] then
     AView^.GrowTo(P^.Size.X-2, AView^.Size.Y);
  P^.Insert(AView);
  P^.ReDraw;
end;

procedure TResCollection.InsertElement( Item:PView);
var
  Form:PFormMain;
  FormPtr:PGroup;

function Test(AItem:PFormMain):Boolean;far;
begin
  Test:=AItem^.FormPtr=PDialog(FormPtr);
end;
begin
  FormPtr:=PGroup(Desktop^.Current);
  Form:=FirstThat(@Test);
  IElement(Form,Item);
end;

procedure TResCollection.CurentUpDate(Info:pointer);
var
  View:PView absolute Info;
  Form:PFormMain;
  FormPtr:PGroup;

function Test(AItem:PFormMain):Boolean;far;
begin
  Test:=AItem^.FormPtr=PDialog(FormPtr);
end;
begin
  if Info<>nil then
     if View^.ComponentType in GroupControl then
        FormPtr:=PGroup(View^.Owner)
     else FormPtr:=Info
  else FormPtr:=PGroup(Desktop^.Current);
  Form:=FirstThat(@Test);
  if Form<>nil then Form^.Modified:=true;
end;

function TResCollection.FindForm(D:PGroup):PFormMain;
function Test(AItem:PFormMain):Boolean;far;
begin
  Test:=AItem^.FormPtr=PDialog(D);
end;
begin
  if D^.ComponentType in GroupControl then D:=D^.Owner;
  FindForm:=FirstThat(@Test);
end;

function TResCollection.GetHelpFile:String;
begin
  if HelpFile<>nil then GetHelpFile:=HelpFile^ else GetHelpFile:='';
end;

function TResCollection.GetOutputHelpFileDir:string;
begin
  if OutputHelpFileDir<>nil then
  begin
    if OutputHelpFileDir^[Length(OutputHelpFileDir^)]<>'\' then
       GetOutputHelpFileDir:=OutputHelpFileDir^+'\'
    else GetOutputHelpFileDir:=OutputHelpFileDir^
  end
  else GetOutputHelpFileDir:='';
end;

function FindByName( Form:PFormMain; Name:string):PView;
var PP:PView;
function Test(P:PView):Boolean;far;
var S:String;
function DoTest(P:PView):Boolean;far;
begin
  if (P^.ComponentName<>nil) and (P^.ComponentName^=Name) then
  begin
    DoTest:=true;
    PP:=P;
  end else DoTest:=false;
end;

begin
  Test:=false;
  if (P^.ComponentName<>nil) and (P^.ComponentName^=Name) then Test:=true
  else
  if P^.ComponentType in GroupControl then
     Test:=PGroup(P)^.FirstThat(@DoTest)<>nil;
end;
begin
  PP:=nil;
  FindByName:=Form^.FormPtr^.FirstThat(@Test);
  if PP<>nil then FindByName:=PP;
end;

function FindFormByName(Name:string):PFormMain;
function Test(P:PFormMain):boolean;far;
begin
  if (P^.FormPtr^.ComponentName<>nil) then
     Test:=stUpCase(P^.FormPtr^.ComponentName^)=Name
  else Test:=false;
end;
begin
  Name:=stUpCase(Name);
  FindFormByName:=ProjectCollection^.FirstThat(@Test);
end;

end.
