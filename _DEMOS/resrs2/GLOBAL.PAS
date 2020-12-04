{$O+,F-,X+,I-,S-,A+,R-}
unit Global;
interface
uses Objects, Views, DIALOGS, Ext_Edit, Drivers, ResTools, RSCllt,
     MouseDlg, GadGets, Ext_mous, Dos, Ext_Math, DAE, VMM, Ext_Type,
     Res2Help, Memory, Ext_Sys, Reports;

const
  hsReservedWords          = 136;
  hsCrossRef               = 137;
  hsNumbers                = 138;
  hsComments               = 139;
  psWhitespace             = 140;
  psComments               = 141;
  psReservedWords          = 142;
  psIdentifiers            = 143;
  psSymbols                = 144;
  psStrings                = 145;
  psNumbers                = 146;
  psAssembler              = 147;


type
  TStatusRec = record
    MaxValue: Longint;
    CurValue: Longint;
    MaxValue1: Longint;
    CurValue1: Longint;
    P:PString;
  end;
type
  TInfoPCRec = record
    CPUType:longint;
    AllMem,
    FreeMeme:longint;
    OS:PString;
  end;

type
  TPrefRec = record
    ScrSize:word;
    SourcTrack:word;
    DesktopTools:word;
    DesktopFile:word;
    AutoSave:word;
    Options:word;
  end;

type
  PDirRecord = ^TDirRecord;
  TDirRecord = record
    ExeOutput:string;
    TpuOutput:string;
    IncludeDirectories:string;
    UnitDirectories:string;
    ObjectDirectories:string;
    ResourceDirectories:string;
  end;

type
  TGeneratorOptions = record
    InsComents: word;
    CreateVar:word;
    AutoOpen:word;
    CodeGeneration:word;
  end;
type
  TCompilerOptions = record
    CodeGeneration:word;
    RuntimeErrors:word;
    SyntaxOptions:word;
    Debugging:word;
    NumericProcessing:word;
    ConditionalDefines:string[60];
  end;
type
  TMouseDlgRec = record
    MouseReverse:word;
    RightBtn:word;
  end;

type
  TDBPrefRecord = record
    DateSep:string[1];
    TimeSep:string[1];
    ExpandDate:boolean;
    Reserv1:byte;
    IndexPageStackSize:longint;
    DefIndexExt:ExtStr;
    TrueValue:string[10];
    FalseValue:string[10];
    List1:TListBoxRec;
    Path:String[79];
    Items:word;
  end;
type
   ProgectOptionsRecord=record
      ProjectHelpFile:string[78];
      IncludeHelpFile:string[255];
      OutputHelpFileDir:string[255];
   end;

function EditDialog( Dialog: Integer; Info: Pointer): Word; far;
procedure RegistersSdt;
procedure InitEditor( const FileName:FNameStr);
procedure WriteForm( S:String);
function RectToStr( AView:PView):string;
function NewUnit:String;
procedure LineWrite(const S:String);
function StrFormat(const S:string; var Param):string;
function NameFlag(T:Byte):string;
procedure ReadIniFile;
procedure WriteIniFile;
procedure CheckConfigRecord;
function GetCompilerDefStr:string;
{procedure CheckEditorOpt;}
procedure MouseOptions;
procedure UpDateMenuBar;
{function AddCntrlUnitMessageBoxProc(Code:integer; Info:Pointer):word;far;}
procedure OpenDataWnd(S:string);
procedure SetDbPref(Rec:TDBPrefRecord);
procedure GetDbPref(var Rec:TDBPrefRecord);
procedure DoTVHColor(Sender:PExtEditor;const S:string; var B:TDrawBuffer; Y: Longint);far;
procedure DoPASColor(Sender:PExtEditor; const S:string; var B:TDrawBuffer; Y: Longint);far;
function DBTextMessageFunc( Code:TTextMessage):string;far;
function TestComponentName(Name:string; Owner:PGroup):boolean;
procedure ChekPreferense;
procedure AddHelpFileDlg;
procedure TopicSearch;
procedure StartupProc;
procedure LoadLocaleInformation;
procedure AliasEditor;
procedure DBConstructorEditor;
procedure ChangeTarget;
procedure About;
procedure ShowClip;
procedure Output;
procedure PropertyList;
procedure OpenData;
procedure DBPrefProc;
procedure EditorOptions;
procedure ProgectOpt;
procedure Colors;
procedure DirDlg;
function NameComponentType(View:PView):string;
function QuteString(S:string):string;
function ComponentByName( Owner:PGroup; Name:string):PView;
function AGetPrintForm(GetFormType:TGetFormType):PView;far;
procedure DoUpdateTitle(P:PExtFileEditor);

var
  Editor:PExtFileEditor;
  PP:PExtEditWindow;
  DirRec:TDirRecord;
  IncludeHelpFile:PString;
  ReservedWords:PStringCollection;


const
  CompilerOptions:TCompilerOptions =
  ( CodeGeneration:13;
    RuntimeErrors:14;
    SyntaxOptions:5;
    Debugging:7;
    NumericProcessing:0;
    ConditionalDefines:''
  );
  GeneratorOptions:TGeneratorOptions =
    (InsComents: 0;
     CreateVar:2;
     AutoOpen:3;
     CodeGeneration:7);
  PrefRec:TPrefRec =
    (ScrSize:0;
    SourcTrack:0;
    DesktopTools:3;
    DesktopFile:0;
    AutoSave:0;
    Options:0);
  DSKFile:FNameStr = 'RES2.DSK';

  ProgectName:FNameStr = '';
  Startup:word = 128;
  StartUpDir:DirStr = '';
  LngName:FNameStr = '';
  DirRecord:PDirRecord = nil;
const
  Clock: PClockView = nil;
{  Heap: PHeapView = nil;}
  IndexPageWnd:PListViewer = nil;
const
  SatatusDialog:PGroup = nil;

procedure ReIndex(All,Pos:Longint; Info:PString);far;
procedure ParseCmdLine;

implementation
uses MsgBox, App, ResStrs, Menus, Ext_Dos, Ext_Str, StdDlg, AddCntrl,
     AboutPn, DataCtrl, GauGes, HelpFile, Puzzle, Calendar, Calc,
     ASCIITab, ColorSel, MultiSel, Outline, CmdNamer, DBCtrls, Querys,
     DBGrids, GlType, Ext_App, IniFile, Grids, CmdConst,
     StdForms, Prperty, Clases, Validate, GL_Proc,
     TabNotbk, El_Lists, ResHelp, PrgMng, PropEdit, Prn_Mng,
     DBConstr, Register, ShardEdt, Editors,
     Crt_View;

procedure ReIndex(All,Pos:Longint; Info:PString);
begin
  Message(SatatusDialog, evBroadcast, cmUpdateGauge, Pointer(Pos));
end;


function StreamErrorMsg(const ACode:Integer):string;
begin
  StreamErrorMsg:=ResourseStrings^.Get(ACode+101)
end;

procedure DoUpdateTitle(P:PExtFileEditor);
begin
  if P=nil then exit;
  P^.OnDrawColorEvent:=nil;
  if (EditorFlags and efSyntaxHighlight<>0) then
  begin
    if (ExtractExt(P^.FileName)='.TVH') then P^.OnDrawColorEvent:=DoTVHColor
    else
    if (ExtractExt(P^.FileName)='.PAS') or
       (ExtractExt(P^.FileName)='.RSC') then P^.OnDrawColorEvent:=DoPASColor
  end;
end;

procedure InitEditor( const FileName:FNameStr);
begin
  if FileExists(FileName) then
     BakUpFile(FileName,'.~pa',true);
  PP:=CreateEditWindow(FileName, hcEditWindow);
  Editor:=PP^.Editor;
  Editor^.OnKeyEvent:=HandleEventCodeEditor;
  if (EditorFlags and efSyntaxHighlight <> 0 ) then
     DoUpdateTitle(Editor);
end;

procedure LineWrite(const S:String);
begin
  Editor^.InsertLine(S, false)
end;

procedure WriteForm( S:String);
begin
  Editor^.InsertLine(S+#13#10, false);
end;

function RectToStr( AView:PView):string;
var param:array [1..4] of longint;
begin
    param[1]:=AView^.Origin.X;
    param[2]:=AView^.Origin.Y;
    param[3]:=AView^.Origin.X+AView^.Size.X;
    param[4]:=AView^.Origin.Y+AView^.Size.Y;
    RectToStr:=StrFormat(GetString(513),Param);
end;


function EditDialog( Dialog: Integer; Info: Pointer): Word;
var
  R: TRect;
  T: TPoint;
  Re: word;
  Name: string;
begin
  EditDialog:=cmCancel;
  case Dialog of
    edOutOfMemory:Application^.OutOfMemory;
    edReadError:
      EditDialog:=RMessageBox(sErrorReading, @Info, mfError + mfOkButton);
    edWriteError:
      EditDialog:=RMessageBox(sErrorWriting, @Info, mfError + mfOkButton);
    edCreateError:
      EditDialog:=RMessageBox(sErrorCreating, @Info, mfError + mfOkButton);
    edSaveModify:
      EditDialog:=RMessageBox(sModified, @Info,mfInformation+mfYesNoCancel);
    edSaveUntitled:
      EditDialog:=RMessageBox(sSaveUntitled,nil,mfInformation + mfYesNoCancel);
    edSaveAs:
      begin
        Name:=PString(Info)^;
        Re:=ExecDialog('SaveAsDialog',@Name);
        if (Re<>cmCancel) and (Name<>PString(Info)^) then
          begin
            if FileExists(Name) then
              if EditorDialog(edReplaceFile,@Name)<>cmYes then
                Re:=cmCancel;
          end;
        if Re<>cmCancel then PString(Info)^:=Name;
        EditDialog := Re;
      end;
    edFind:
      EditDialog:=ExecDialog('FindDialog',Info);
    edSearchFailed:
      EditDialog:=RMessageBox(sStrNotFound,nil,mfError + mfOkButton);
    edReplace:
      EditDialog:=ExecDialog('ReplaceDialog', Info);
    edReplacePrompt:
      begin
        R.Assign(0, 1, 40, 8);
        R.Move((Desktop^.Size.X - R.B.X) div 2, 0);
        Desktop^.MakeGlobal(R.B, T);
        Inc(T.Y);
        if TPoint(Info).Y <= T.Y then
          R.Move(0, Desktop^.Size.Y - R.B.Y - 2);
        EditDialog:=RMessageBoxRect(R,sReplace,nil,mfYesNoCancel+mfInformation);
      end;
    edPrintFile:EditDialog:=ExecDialog(sPrintFileDlg, info);
    edReplaceFile:EditDialog:=RMessageBox(sOwerWriteFile, @Info,
      mfInsertInApp+mfConfirmation+mfYesButton+mfNoButton);
    edReadBlock :EditDialog:=ExecDialog(sReadBlock, info);
    edGotoLine:EditDialog:=ExecDialog(sGoLine,Info);
    edWriteBlock:
      begin
        Name:=PString(Info)^;
        Re:=ExecDialog(sWriteBlock, @Name);
        if (Re<>cmCancel) and (Name<>PString(Info)^) then
          begin
            if FileExists(Name) then
              if EditorDialog(edReplaceFile,@Name)<>cmYes then
                Re:=cmCancel;
          end;
        if Re<>cmCancel then PString(Info)^:=Name;
        EditDialog := Re;
      end;
  end;
end;

procedure RegistersSdt;
begin
  RegisterObjects;
  RegisterValidate;
  RegisterViews;
  RegisterMenus;
  RegisterDialogs;
  RegisterApp;
  RegisterEditors;
  RegisterStdDlg;
  RegisterAddCntrl;
  RegisterData;
  RegisterGauges;
  RegisterHelpFile;
  RegisterPuzzle;
  RegisterCalendar;
  RegisterAsciiTab;
  RegisterCalc;
  RegisterColorSel;
  RegistersMultiSelect;
  RegisterOutline;
  RegisterType(RAboutPanel);
  RegisterCmdNamer;
  RegisterMouseDlg;
  RegistersExtMouseDlg;
  RegisterDBCtrls;
  RegisterType(RClockView);
  RegisterType(ROutputViewer);
  RegisterDBGrid;
  RegisterGrids;
  RegisterProperty;
  RegisterGlobals;
  RegisterReports;
{  RegisterDBFilter;}
  RegisterClases;
  RegisterStdForms;
  RegisterTabNotbk;
  RegisterEl_Lists;
{  RegisterQuerys;}
  RegisterDBConstructor;
  RegisterExtEditor;

end;

function NewUnit:String;
var
  FileName:FNameStr;
  S,S1:String;
  Dir: DirStr;
  Name: NameStr;
  Ext: ExtStr;
  A:pointer;
  PP:PExtEditWindow;
begin
  FileName := 'NewUnit.pas';
  if ExecDialog(sFileOpenDialog, @FileName) <> cmCancel then
  begin
    if FileExists(FileName) then
    begin
       A:=@FileName;
       if RMessageBox( sOwerWriteFile, @A, mfWarning+mfYesNoCancel)<>cmYes then
          exit
       else
          BakUpFile(FileName,'.~pa',true);
    end;
    InitEditor(FileName);
    FSplit(FileName, Dir, Name, Ext);
    A:=@Name;
    FormatStr(S1, ResourseStrings^.Get(500), A);
    WriteForm(S1);
  end;
end;

function StrFormat(const S:string; var Param):string;
var
  SS:string;
begin
  FormatStr(SS,S,param);
  StrFormat:=SS;
end;

function NameFlag(T:Byte):string;
var
  s:string;
begin
  if t=0 then s:='bfNormal'
  else
  begin
    S:='';
    if t and bfDefault<>0  then s:='bfDefault+';
    if t and bfLeftJust<>0  then s:=S+'bfLeftJust+';
    if t and bfBroadcast<>0  then s:=S+'bfBroadcast+';
    if t and bfGrabFocus<>0  then s:=S+'bfGrabFocus+';
    SetLength(S, Length(S)-1);
  end;
  NameFlag:=S;
end;


procedure ReadIniFile;
var
  F:PIniFile;
  S,s1:FNameStr;
  N,i:integer;
  W:PExtEditWindow;
  V:PView;

procedure ReadViewCoordinate(P:PView; S:string);
var
  R:TRect;
begin
    R.Assign(
    F^.ReadInteger(S, 'Origin.X', P^.Origin.X),
    F^.ReadInteger(S, 'Origin.Y', P^.Origin.Y),
    F^.ReadInteger(S, 'Size.X', P^.Size.X),
    F^.ReadInteger(S, 'Size.Y', P^.Size.Y));
    P^.Locate(R);
end;

begin
  S:=EXEName+'.INI';
  if not FileExists(S) then S:=EXEPath+S;
  F:=New(PIniFile, Init(S));
  with GeneratorOptions do
  begin
    InsComents:=F^.ReadInteger(sGenSection, sInsComents, InsComents);
    CreateVar:=F^.ReadInteger(sGenSection, sCreateVar, CreateVar);
    AutoOpen:=F^.ReadInteger(sGenSection, sAutoOpen , AutoOpen);
    CodeGeneration:=F^.ReadInteger(sGenSection, sCodeGeneration, CodeGeneration);
  end;

  EditorFlags:=F^.ReadInteger(sEditor, 'Editor options', EditorFlags);
  FindStr:=F^.ReadString(sEditor, 'Find string', FindStr);
  ReplaceStr:=F^.ReadString(sEditor, 'Replace string', ReplaceStr);
  FindFlags:=F^.ReadInteger(sEditor, 'Find flags', FindFlags);
  TabSize:=F^.ReadInteger(sEditor, 'Tab size', TabSize);

  HighlightExt:=F^.ReadString(sSystem, 'Highlight extension','*.pas;*.inc;*.tvh;*.sql');

  if DirRecord<>nil then
  begin
    DirRecord^.ExeOutput:=F^.ReadString(sCompiler,'ExeOutput','');
    DirRecord^.TpuOutput:=F^.ReadString(sCompiler,'TpuOutput','');
    DirRecord^.IncludeDirectories:=F^.ReadString(sCompiler,'IncludeDirectories','');
    DirRecord^.UnitDirectories:=F^.ReadString(sCompiler,'UnitDirectories','');
    DirRecord^.ObjectDirectories:=F^.ReadString(sCompiler,'ObjectDirectories','');
    DirRecord^.ResourceDirectories:=F^.ReadString(sCompiler,'ResourceDirectories','');
  end;

  PrefRec.ScrSize:=F^.ReadInteger(sStartUpMode, sScrSize, PrefRec.ScrSize);
  PrefRec.SourcTrack:=F^.ReadInteger(sStartUpMode, sSourcTrack, PrefRec.SourcTrack);
  PrefRec.DesktopTools:=F^.ReadInteger(sStartUpMode, sDesktopTools, PrefRec.DesktopTools);
  PrefRec.DesktopFile:=F^.ReadInteger(sStartUpMode, sDesktopFile, PrefRec.DesktopFile);
  PrefRec.AutoSave:=F^.ReadInteger(sStartUpMode, sAutoSave, PrefRec.AutoSave);
  PrefRec.Options:=F^.ReadInteger(sStartUpMode, sOptionsFl, PrefRec.Options);
  if Prefrec.DesktopFile=1 then
  DSKFile:=F^.ReadString(sStartUpMode, sPathDskFile, DSKFile);
  Startup:=F^.ReadInteger(sStartUpMode, sStartupIDE, Startup);
  MouseReverse:=F^.ReadBoolean(sMouseStartUp, sReverseMouse, MouseReverse);
  DoubleDelay:=F^.ReadInteger(sMouseStartUp, sDoubleDelay, DoubleDelay);
  RightMoussBtn:=F^.ReadInteger(sMouseStartUp, sMouseRightBtn, RightMoussBtn);
  DelayTicks:=F^.ReadInteger(sComponets, sAboutPaneSpeed, DelayTicks);
  if GeneratorOptions.AutoOpen and $01 <> 0 then
  ProgectName:=F^.ReadString(sWork, sCurentProgect, '');
  AssignStr(IncludeHelpFile,F^.ReadString(sWork, sIncHlpFile, ''));
(*
  if F^.CountItem('Project Manager')<>0 then
  begin
    Application^.InsertWindow(New(PProjectManager, Init));
    ReadViewCoordinate(ProjectManager,'Project Manager');
  end;
  if F^.CountItem('Property Window')<>0 then
     ReadViewCoordinate(PropertyWindow,'Property Window');
  if (F^.CountItem('Clipboard Window')<>0) and (Clipboard<>nil) then
  begin
    ReadViewCoordinate(Clipboard^.Owner,'Clipboard Window');
    Clipboard^.Owner^.Show;
    Clipboard^.Owner^.Select;
  end;

  if F^.CountItem('Printer Manager')<>0 then
  begin
     if PrnManager=nil then Application^.InsertWindow(New(PPrnManager, Init));
     ReadViewCoordinate(PrnManager,'Printer Manager');
  end;

  if F^.CountItem('Output Window')<>0 then
  begin
    V:=Message(Desktop, evBroadcast,cmFindOutput, nil);
    if V=nil then V:=Application^.InsertWindow(OutputWindow)
    else V:=V^.Owner;
    if V<>nil then
       ReadViewCoordinate(V,'Output Window');
  end;

{IFDEF DPMI}
  if HelpFiles<>nil then
  for i:=1 to F^.CountItem('Help files') do
    HelpFiles^.Add(F^.ReadString('Help files', 'File'+IntToStr(i), ''));
{ENDIF}

  F^.Free; *)
end;

procedure WriteIniFile;
var
  F:PIniFile;
  S:FNameStr;
  P:PCollection;
  N,i:integer;
  V:PView;

procedure WriteViewCoordinate(P:PView; S:string);
begin
  F^.WriteInteger(S, 'Origin.X', P^.Origin.X);
  F^.WriteInteger(S, 'Origin.Y', P^.Origin.Y);
  F^.WriteInteger(S, 'Size.X', P^.Size.X+P^.Origin.X);
  F^.WriteInteger(S, 'Size.Y', P^.Size.Y+P^.Origin.Y);
end;

procedure DoWriteWindow(EditWindow:PExtEditWindow);far;
var i:integer;
    S:string;
begin
  I:=P^.IndexOf(EditWindow);
  s:='Edit Window '+IntToStr(i+1);
  WriteViewCoordinate(EditWindow, S);
  F^.WriteInteger(S, 'Number', EditWindow^.Number);
  F^.WriteString(S, 'File Name', EditWindow^.Editor^.FileName);
end;

begin
  S:=EXEName+'.INI';
  if PrefRec.DesktopFile<>0 then S:=EXEPath+S;
  F:=New(PIniFile, Init(S));
  F^.WriteString(sSystem,'Language resurse',LngName);
  F^.WriteString(sSystem,'Highlight extension',HighlightExt);

  F^.WriteInteger(sGenSection, sInsComents,GeneratorOptions.InsComents);
  F^.WriteInteger(sGenSection, sCreateVar,GeneratorOptions.CreateVar);
  F^.WriteInteger(sGenSection, sAutoOpen ,GeneratorOptions.AutoOpen);
  F^.WriteInteger(sGenSection, sCodeGeneration ,GeneratorOptions.CodeGeneration);

  F^.WriteInteger(sEditor, 'Editor options', EditorFlags);
  F^.WriteString(sEditor, 'Find string', FindStr);
  F^.WriteString(sEditor, 'Replace string', ReplaceStr);
  F^.WriteInteger(sEditor, 'Find flags', FindFlags);
  F^.WriteInteger(sEditor, 'Tab size', TabSize);

  if DirRecord<>nil then
  begin
    F^.WriteString(sCompiler,'ExeOutput',DirRecord^.ExeOutput);
    F^.WriteString(sCompiler,'TpuOutput',DirRecord^.TpuOutput);
    F^.WriteString(sCompiler,'IncludeDirectories',DirRecord^.IncludeDirectories);
    F^.WriteString(sCompiler,'UnitDirectories',DirRecord^.UnitDirectories);
    F^.WriteString(sCompiler,'ObjectDirectories',DirRecord^.ObjectDirectories);
    F^.WriteString(sCompiler,'ResourceDirectories',DirRecord^.ResourceDirectories);
  end;

  F^.WriteInteger(sStartUpMode, sScrSize, PrefRec.ScrSize);
  F^.WriteInteger(sStartUpMode, sSourcTrack, PrefRec.SourcTrack);
  F^.WriteInteger(sStartUpMode, sDesktopTools, PrefRec.DesktopTools);
  F^.WriteInteger(sStartUpMode, sDesktopFile, PrefRec.DesktopFile);
  F^.WriteInteger(sStartUpMode, sAutoSave, PrefRec.AutoSave);
  F^.WriteInteger(sStartUpMode, sOptionsFl, PrefRec.Options);
  if Prefrec.DesktopFile=1 then
  F^.WriteString(sStartUpMode, sPathDskFile, DSKFile);
  F^.WriteInteger(sStartUpMode, sStartupIDE, Startup);

  F^.WriteBoolean(sMouseStartUp, sReverseMouse, MouseReverse);
  F^.WriteInteger(sMouseStartUp, sDoubleDelay, DoubleDelay);
  F^.WriteInteger(sMouseStartUp, sMouseRightBtn, RightMoussBtn);
  F^.WriteInteger(sComponets, sAboutPaneSpeed, DelayTicks);
  if GeneratorOptions.AutoOpen and $01 <> 0 then
     F^.WriteString(sWork, sCurentProgect, ProgectName);
  if IncludeHelpFile<>nil then F^.WriteString(sWork, sIncHlpFile, IncludeHelpFile^)
  else F^.DeleteKey(sWork, sIncHlpFile);

  if ProjectManager<>nil then
     WriteViewCoordinate(ProjectManager,'Project Manager')
  else F^.EraseSection('Project Manager');
  if PropertyWindow<>nil then
     WriteViewCoordinate(PropertyWindow,'Property Window')
  else F^.EraseSection('Property Window');
  if (Clipboard<>nil) and (Clipboard^.Owner^.State and sfVisible <>0) then
     WriteViewCoordinate(Clipboard^.Owner,'Clipboard Window')
  else F^.EraseSection('Clipboard Window');
  if PrnManager<>nil then
     WriteViewCoordinate(PrnManager,'Printer Manager')
  else F^.EraseSection('Printer Manager');

  V:=Message(Desktop, evBroadcast,cmFindOutput, nil);
  if V<>nil then
  begin
     V:=V^.Owner;
     WriteViewCoordinate(V,'Output Window')
  end
  else F^.EraseSection('Output Window');

{IFDEF DPMI}
  if HelpFiles<>nil then
  for i:=1 to HelpFiles^.Count-1 do
    F^.WriteString('Help files', 'File'+IntToStr(i), HelpFiles^.Str(i));
{ENDIF}

  Dispose(F, Done);
end;

procedure ChekPreferense;
var R:TRect;
begin
  Clock^.SetState(sfVisible, PrefRec.DesktopTools and $01 <> 0);
{  Heap^.SetState(sfVisible, PrefRec.DesktopTools and $02 <> 0);}
  if ScreenMode<>smMono then
  case PrefRec.ScrSize of
    0:if ScreenMode<>smCO80 then Application^.SetScreenMode(smCO80);
    1:Application^.SetScreenMode(ScreenMode xor smFont8x8);
  end;
  Application^.GetExtent(R);
{  Heap^.Reposition(R);}
  Application^.ReDraw;
end;

procedure CheckConfigRecord;
var S:TDosStream;
    Dir: DirStr;
    Name: NameStr;
    Ext: ExtStr;
    c:integer;
    PC:PResCollection;
begin
{    CheckEditorOpt;}
    ChekPreferense;
    if (GeneratorOptions.AutoOpen and $01=1) and (ProgectName<>'') then
       if not FileExists(ProgectName) then
       begin
         GeneratorOptions.AutoOpen:=GeneratorOptions.AutoOpen and $FE;
         ProgectName:='';
       end;
    if (GeneratorOptions.AutoOpen and $01=1) and (ProgectName<>'')
       {and (ParamCount=0)} then
    begin
      if PrefRec.Options and $04 <>0 then
      begin
        FSplit(ProgectName, Dir, Name, Ext);
        if Dir[Length(Dir)]='\' then dec(Dir[0]);
        c:=IOResult;
        {$I-}
        ChDir(Dir);
        {$I+}
        if IOResult<>0 then RMessageBox(sNotChangeDir, nil, mfError+mfOkButton);
      end;
      Dispose(ProjectCollection, Done);
      ProjectCollection:=nil;
      S.Init( ProgectName, stOpen);
      ProjectCollection:=New(PResCollection, Load(S));
      if (S.Status<>stOk) and (ProjectCollection<>nil) then
      begin
        Dispose(ProjectCollection, Done);
        ProjectCollection:=New(PResCollection,Init);
      end;
      S.Done;
    end;
    UpDateMenuBar;
end;

function GetCompilerDefStr:string;
var {$IFDEF VER70} Result:string;{$ENDIF}
    S1,S2:string[60];
    P:PString;
    i:integer;
begin
  Result:='';
{  for i:=0 to 3 do S:=S+GetString(
  (CompilerOptions.CodeGeneration shr i) and $01 + i*2+sCodeGenBase);
  for i:=0 to 3 do S:=S+GetString(
  (CompilerOptions.RuntimeErrors shr i) and $01 + i*2+sRuntimeErrorsBase);
  for i:=0 to 4 do S:=S+GetString(
  (CompilerOptions.SyntaxOptions shr i) and $01 + i*2+sSyntaxOptionsBase);
  for i:=0 to 2 do S:=S+GetString(
  (CompilerOptions.Debugging shr i) and $01 + i*2+sDebuggingBase);
  for i:=0 to 1 do S:=S+GetString(
  (CompilerOptions.NumericProcessing shr i) and $01 + i*2+sNumericProcessingBase);
  if CompilerOptions.ConditionalDefines<>'' then
  begin
    S1:=CompilerOptions.ConditionalDefines;
    P:=@S2;
    repeat
      i:=1;
      while (i<=Length(S1)) and (S1[i]<>';') do inc(i);
      S2:=Copy(S1,1,i-1);
      Delete(S1, 1, i);
      S:=S+StrFormat(GetString(sConditionalDefines),P);
    until S1='';
  end;}
{$IFDEF VER70}
  GetCompilerDefStr:=Result;
{$ENDIF}
end;

{procedure CheckEditorOpt;
begin
  if EditorFlags and efCreateBackupFiles <> 0 then
     EditorFlags:=EditorFlags or efBackupFiles
  else EditorFlags:=EditorFlags and not efBackupFiles
end;}

procedure MouseOptions;
var Rec:TMouseDlgRec;
begin
  Rec.MouseReverse:=word(MouseReverse);
  Rec.RightBtn:=RightMoussBtn;
  if ExecDialog('MouseDlg',@Rec)<>cmCancel then
  begin
    MouseReverse:=boolean(Rec.MouseReverse);
    RightMoussBtn:=Rec.RightBtn;
  end;
end;

procedure UpDateMenuBar;
var
  Dir: DirStr;
  FName: NameStr;
  Ext: ExtStr;
  Name:FNameStr;
  V:PView;
begin
  Name:=ProgectName;
  FSplit( Name, Dir, FName, Ext);
  if CurrentDir(CurrentDrive)<>Dir then ReduceFName(Name,15)
  else Name:=FName+Ext;
  UpDateParam(GetItem(cmSaveAll),NewStr(Name));
  if Target then Name:=GetString(sDisk) else Name:=GetString(sMem);
  UpDateParam(GetItem(cmBuffer),NewStr(Name));
  UpdateParam(GetItem(cmSaveDskFile), NewStr(FNameReduce(DSKFile, 17)));
  Message(Application, evBroadcast, cmUpdateDir, nil);
  V:=Message(Desktop, evBroadcast,cmFindOutput, nil);
  if V<>nil then V^.Owner^.ReDraw;
end;
(*
function AddCntrlUnitMessageBoxProc(Code:integer; Info:Pointer):word;
begin
{  case Code of
    mbpInvalidAdres,
    mbpInvalidRange,
    mbpValueNotInRg,
    mbpNotDate:AddCntrlUnitMessageBoxProc:=RMessageBox(Code+2099,info,mfOkButton);
    mbpSaveAsReport:
      AddCntrlUnitMessageBoxProc:=RExecDialog(Code+2099, Info);
  end;}
  AddCntrlUnitMessageBoxProc:=cmCancel;
end;*)

procedure ParseCommand(S:string);
var E:TEvent;
    P:PString;
    Form:PFormMain;
begin
  S:=Trim(stUpCase(S));
  P:=@S;
  if Copy(S,2,255)='EXIT' then
  begin
    E.What:=evCommand;
    E.Command:=cmQuit;
    Application^.PutEvent(E);
    exit;
  end;
  if Copy(S,2,5)='PRINT' then
  begin
    S:=Trim(copy(S,7,255));
    Form:=FindFormByName(S);
    if Form<>nil then Message(Form^.FormPtr, evCommand, cmPrintReport, nil)
    else RMessageBox(sFormNotFound,@P, mfError+mfOkButton);
    exit;
  end;
  RMessageBox(sUknowCmd,@P, mfError+mfOkButton);
end;

procedure OpenDataWnd(S:string);
var P:PDataBaseWindow;
begin
{  P:=PDataBaseWindow(Application^.InsertWindow(
            PDataBaseWindow(GetView(sDataBaseWindow))));
  if P=nil then exit;
  P^.Number:=GetWindowNumber;
  P^.Options:=P^.Options and (not ofCentered);
  DisposeStr(P^.DataSourse^.TableName);
  P^.DataSourse^.TableName:=NewStr(S);
  P^.DataSourse^.Open;
  P^.ReDraw;}
end;

procedure ParseCmdLine;
var i:integer;
    S:string;
    Dir: DirStr;
    Name: NameStr;
    Ext: ExtStr;
    St:TDosStream;
    D:PExtEditWindow;
begin
  for i:=1 to ParamCount do
  begin
    S:=ParamStr(i);
    if (S[1]='-') or (S[1]='/') then ParseCommand(S)
    else
    begin
      FSplit(S, Dir, Name, Ext);
      if stUpCase(Ext)='.DBF' then OpenDataWnd(S)
      else
      if stUpCase(Ext)='.PRJ' then
      begin
         ProgectName:=S;
         if PrefRec.Options and $04 <>0 then
         begin
           if Dir[Length(Dir)]='\' then dec(Dir[0]);
           {$I-} ChDir(Dir); {$I+}
           if IOResult<>0 then RMessageBox(sNotChangeDir, nil, mfError+mfOkButton);
         end;
         Dispose(ProjectCollection, Done);
         St.Init( ProgectName, stOpen);
         ProjectCollection:=New(PResCollection, Load(St));
         St.Done;
      end
      else
      begin
        D:=CreateEditWindow(S, hcEditWindow);
        D^.Editor^.OnKeyEvent:=HandleEventCodeEditor;
      end;
    end;
  end;
end;

procedure SetDbPref(Rec:TDBPrefRecord);
begin
  DateSeparator:=Rec.DateSep[1];
  TimeSeparator:=Rec.TimeSep[1];
  ExpandDate:=Rec.ExpandDate;
  SetLimit(Rec.IndexPageStackSize);
  BooleanText[true]:=Rec.TrueValue;
  BooleanText[false]:=Rec.FalseValue;
  DefIndexExt:=Rec.DefIndexExt;
end;

procedure GetDbPref(var Rec:TDBPrefRecord);
begin
  FillChar(Rec, SizeOf(TDBPrefRecord), 0);
  Rec.DateSep:=DateSeparator;
  Rec.TimeSep:=TimeSeparator;
  Rec.ExpandDate:=ExpandDate;
  Rec.IndexPageStackSize:=Nodes^.Limit;
  Rec.DefIndexExt:=DefIndexExt;
  Rec.TrueValue:=BooleanText[true];
  Rec.FalseValue:=BooleanText[false];
end;

procedure DoColor(Sender:PExtEditor; Color:byte; Count:integer; var B:TDrawBuffer; X,Y:Longint);
var i:integer;
begin
  with Sender^ do
  if  (SelectStart.X<>SelectEnd.X)
  or (SelectStart.Y<>SelectEnd.Y) then
  begin
    if (Y=SelectStart.Y) and (Y=SelectEnd.Y) then
    begin
      for i:=X to X+Count do
       if (i<SelectStart.X) or (i>SelectEnd.X) then
          WordRec(B[i]).Hi:=Color;
    end
    else
    if (Y=SelectStart.Y) then
      for i:=X to min(X+Count, SelectStart.X) do WordRec(B[i]).Hi:=Color
    else
    if (Y=Sender^.SelectEnd.Y) then
       for i:=max(X,SelectEnd.X) to X+Count do WordRec(B[i]).Hi:=Color
    else
    for i:=X to X+Count do WordRec(B[i]).Hi:=Color
  end
  else for i:=X to X+Count do WordRec(B[i]).Hi:=Color;
end;

procedure SetColor(Sender:PExtEditor; var B:TDrawBuffer; Color:byte; X,Y: Longint);
begin
  if (Y=Sender^.SelectStart.Y) and (Y=Sender^.SelectEnd.Y) then
     if (X<=Sender^.SelectStart.X) or (X>Sender^.SelectEnd.X) then
        WordRec(B[X-1]).Hi:=Color
  else else
  if (Y=Sender^.SelectStart.Y) then
    if X<=Sender^.SelectStart.X then WordRec(B[X-1]).Hi:=Color
  else else
  if (Y=Sender^.SelectEnd.Y) then
    if X>Sender^.SelectEnd.X then WordRec(B[X-1]).Hi:=Color
  else else
  WordRec(B[X-1]).Hi:=Color;
end;

procedure DoTVHColor(Sender:PExtEditor; const S:string; var B:TDrawBuffer; Y: Longint);
var i,l,k:Longint;
    ResWord,Number,CrosRef, Coments:byte;
    isRef:boolean;
begin
  if (Sender^.SelectStart.Y<Y) and (Sender^.SelectEnd.Y>Y) then exit;
  ResWord:=byte(Application^.GetPalette^[hsReservedWords]);
  Number:=byte(Application^.GetPalette^[hsNumbers]);
  CrosRef:=byte(Application^.GetPalette^[hsCrossRef]);
  Coments:=byte(Application^.GetPalette^[hsComments]);
  with Sender^ do
  if S[1]=';' then DoColor(Sender, Coments, Length(S), B, 0, Y)
  else
  if copy(S,1,7)='.TOPIC ' then
  begin
     DoColor(Sender, ResWord, 6, B, 0, Y);
     i:=7;
     with Sender^ do
     repeat
       while (i<Length(s)) and not (s[i] in WordChars+['$']) do inc(i);
       if not (s[i] in ['0'..'9','$']) then
          while (i<Length(s)) and (s[i] in (WordChars)) do inc(i);
       while (i<Length(s)) and (s[i] in ['0'..'9','$']) do
       begin
         SetColor(Sender, B,Number, I, Y);
         inc(i);
       end;
     until i>=Length(s);
  end
  else
  if copy(S,1,6)='.USES ' then
     DoColor(Sender, ResWord, 5, B, 0, Y)
  else
  begin
     isRef:=false;
     for i:=1 to Length(S) do
     begin
       case s[i] of
        '{':isRef:=true;
        '}':isRef:=false;
       end;
       if isRef or (s[i]='}') then
         if (S[i]<>' ') and ((Y>=Sender^.SelectEnd.Y) or
                             (Y<=Sender^.SelectStart.Y)) then
         begin
            if (Y=Sender^.SelectStart.Y) and
               (I>Sender^.SelectStart.X-1) then Continue;
            if (Y=Sender^.SelectEnd.Y) and
               (I<Sender^.SelectEnd.X-1) then Continue;
            WordRec(B[i-1]).Hi:=CrosRef;
        end
     end;
  end;
end;

procedure DoPASColor(Sender:PExtEditor; const S:string; var B:TDrawBuffer; Y: Longint);
var
  isString:boolean;
  i,j,k:integer;
  Test:String;
  StringColor, NumbColor, ComentColor, ReservColor:byte;
begin
  if (Sender^.SelectStart.Y<Y) and (Sender^.SelectEnd.Y>Y) then exit;
  ComentColor:=byte(Application^.GetPalette^[psComments]);
  ReservColor:=byte(Application^.GetPalette^[psReservedWords]);
  StringColor:=byte(Application^.GetPalette^[psStrings]);
  NumbColor:=byte(Application^.GetPalette^[psNumbers]);
  i:=Sender^.Delta.X+1;
  while not (i>=length(S)) do
  begin
    while (i<Length(S)) and not (s[i] in WordChars+['''','{','$','#','/']) do inc(i);
    if s[i]='#' then
    begin
      if s[i+1]='$' then
      while (i<byte(s[0])) and (s[i] in ['0'..'9','a'..'f','A'..'F','$','#']) do
      begin
        SetColor(Sender, B, StringColor, I, Y);
        inc(i);
      end
      else
      while (i<byte(s[0])) and (s[i] in ['0'..'9','#']) do
      begin
        SetColor(Sender, B, StringColor, I, Y);
        inc(i);
      end
    end
    else
    if s[i]='''' then
    begin
      repeat
        SetColor(Sender, B, StringColor, I, Y);
        inc(i);
      until (i>length(S)) or (s[i]='''');
      SetColor(Sender, B, StringColor, I, Y);
      inc(i);
    end
    else
    if s[i]='{' then
    begin
      repeat
        SetColor(Sender, B, ComentColor, I, Y);
        inc(i);
      until (i>length(S)) or (s[i]='}');
      SetColor(Sender, B, ComentColor, I, Y);
      inc(i);
    end
    else
    if (S[i]='/') then
    begin
      if (i<Length(S)) and (S[i+1]='/') then
      begin
        DoColor(Sender, ComentColor, Length(S)-i, B, I-1, Y);
        i:=Length(S)+1;
      end
      else inc(i);
    end
    else
    if s[i] in (WordChars-['0'..'9']) then
    begin
      j:=i;
      while (j<=Length(S)) and (s[j] in WordChars) do inc(j);
      test:=copy(S,i,j-i);
      if ReservedWords^.Search(@Test,k) then
         DoColor(Sender, ReservColor, j-i, B, I-1, Y);
      i:=j;
    end
    else
    if not (s[i] in ['0'..'9','$']) then
       while (i<byte(s[0])) and (s[i] in (WordChars)) do inc(i)
    else
    if s[i] in ['0'..'9','$'] then
    while (i<byte(s[0])) and (s[i] in ['0'..'9','$','A'..'F']) do
    begin
      SetColor(Sender, B, NumbColor, I, Y);
      inc(i);
    end;
  end;
end;

function DBTextMessageFunc( Code:TTextMessage):string;
begin
  DBTextMessageFunc:=GetString(byte(Code)+700);
end;

function TestComponentName(Name:string; Owner:PGroup):boolean;
function DoFind(P:PView):boolean;far;
function DoTest(AP:PView):boolean;far;
begin
  if AP^.ComponentName<>nil then
     DoTest:=stUpCase(AP^.ComponentName^)=stUpCase(Name)
  else DoTest:=false;
end;
begin
  if P^.ComponentName<>nil then
     if stUpCase(P^.ComponentName^)=stUpCase(Name) then DoFind:=true
     else
       if P^.ComponentType in [ctReportBand] then
          DoFind:=PGroup(P)^.FirstThat(@DoTest)<>nil
       else DoFind:=false
  else DoFind:=false;
end;
begin
  TestComponentName:=Owner^.FirstThat(@DoFind)<>nil;
end;

procedure AddHelpFileDlg;
var Rec:TListBoxRec;
    SaveState:boolean;
    i:integer;
    S:string;
begin
  Rec.List:=New(PStrings, Init);
  Rec.Selection:=0;
  PStrings(Rec.List)^.Assign(HelpFiles);
  PStrings(Rec.List)^.AtFree(0);
  SaveState:=Application^.CommandEnabled(cmHelpFileDelete);
  Application^.SetCmdState([cmHelpFileDelete],HelpFiles^.Count<>0);
  if ExecDialog(sAddHelpFileDlg, @Rec)<>cmCancel then
  begin
    S:=HelpFiles^.Str(0);
    HelpFiles^.Assign(PStrings(Rec.List));
    HelpFiles^.AtInsert(0,NewStr(S));
{    for i:=1 to HelpFiles^.Count-1 do HelpFiles^.AtFree(1);
    for i:=0 to PStrings(Rec.List)^.Count-1 do
        HelpFiles^.Add(PStrings(Rec.List)^.Str(i));}
  end;
  Dispose(PStrings(Rec.List), Done);
  Application^.SetCmdState([cmHelpFileDelete],SaveState);
end;

procedure TopicSearch;
var CurEditor:PExtEditWindow;
begin
{  CurEditor:=FindTopEditor;
  if CurEditor<>nil then HelpTopicSearch(CurEditor^.Editor)
  else HelpTopicSearch(nil);}
end;


procedure StartupProc;
var Rec:TStartUpRecord;

procedure DoFindLngFiles;
procedure DoAddNames(FName:FNameStr);
var RFile: TResourceFile;
    RStream: PStream;
    RStrings: PStringList;
begin
  RStream:=New(PBufStream, Init( ExePath+FName, stOpenRead, 4096));
  RFile.Init(RStream);
  RStrings := PStringList(RFile.Get('Strings'));
  if (RStream^.Status=stOk) and (RStrings<>nil) then
  begin
    PStrings(Rec.Language.List)^.Add(FName+DupChar(' ',12-Length(FName))+' - '+RStrings^.Get(sLanguage));
    RStrings^.Free;
  end;
  RFile.Done;
end;
var
  DirInfo: SearchRec;
  I:integer;
begin
  i:=0;
{$IFDEF SINGLE}
  DoAddNames(ExeName+'.EXE');
{$ELSE}
  DoAddNames(ExeName+'.TVR');
{$ENDIF}
  FindFirst(ExePath+'res2*.LNG', Archive, DirInfo);
  while DosError = 0 do
  begin
    DoAddNames(DirInfo.Name);
    inc(i);
    if stUpCase(LngName)=DirInfo.Name then Rec.Language.Selection:=i;
    FindNext(DirInfo);
  end;
end;

begin
  Rec.StartUpOpt:=StartUp;
  Rec.Language.List:=New(PStrings, Init);
  Rec.Language.Selection:=0;
  DoFindLngFiles;
  if ExecDialog(sStartupDlg,@Rec)<>cmCancel then
  begin
    LngName:=Trim(Copy(PStrings(Rec.Language.List)^.Str(Rec.Language.Selection),1,12));
    StartUp:=Rec.StartUpOpt;
    WriteIniFile;
    RMessageBox(sStartupIDEWarning, nil, mfOkButton+mfWarning);
  end;
  Dispose(PStrings(Rec.Language.List), Done);
end;

procedure AliasEditor;
begin
  //RExecDialog(sDBAliasEditor, nil);
end;

procedure DBConstructorEditor;
begin
  Application^.InsertWindow(New(PDBConstructor, Init));
end;

procedure ChangeTarget;
begin
  Target:= not Target;
  UpDateMenuBar;
end;

procedure About;
begin
  DesignTime:=false;
  ExecDialog('About',nil);
  DesignTime:=true;
end;

procedure ShowClip;
begin
  if Ext_Edit.Clipboard<>nil then
  begin
    PWindow(Ext_Edit.Clipboard^.Owner)^.Number:=GetWindowNumber;
    Ext_Edit.Clipboard^.Owner^.Show;
    Ext_Edit.Clipboard^.Owner^.Select;
  end else RMessageBox(sNotDisplayClp, nil, mfError+mfOkButton);
end;

procedure Output;
var P:PView;
begin
  P:=Message(Desktop, evBroadcast,cmFindOutput, nil);
  if P<>nil then P^.Owner^.Select else
  Application^.InsertWindow(OutputWindow);
end;

procedure PropertyList;
begin
  if PropertyWindow<>nil then PropertyWindow^.Select
  else
  begin
    Application^.InsertWindow(New(PPropertyWindow, Init));
    CurentSelect;
  end;
end;

procedure OpenData;
var P:PDataBaseWindow;
    S:String;
begin
  S:=sExtDBF;
  if ExecDialog(sDBFOpenDialog,@S)<>cmCancel then
     OpenDataWnd(S);
end;

procedure DBPrefProc;
var Rec:TDBPrefRecord;
begin
  GetDbPref(Rec);
  if ExecDialog(sDEPref,@Rec)=cmCancel then exit;
  SetDbPref(Rec);
  Application^.ReDraw;
end;


procedure LoadLocaleInformation;
begin
  ButtonName[0]:=GetString(sYes); {'~Д~а'}
  ButtonName[1]:=GetString(sNo); {'~Н~ет'}
  ButtonName[2]:=GetString(sOk); {'~У~гу'}
  ButtonName[3]:=GetString(sCancel); {'Отмена'}
  Titles[0]:=GetString(sWarningStr);
  Titles[1]:=GetString(sErrorStr);
  Titles[2]:=GetString(sInfoStr);
  Titles[3]:=GetString(sConfirmStr);
end;

procedure EditorOptions;
var Rec:TStdEditorOptionsRec;
begin
  Rec.HighlightExt:=HighlightExt;
  Rec.TabSize:=TabSize;
  Rec.EditorFlags:=EditorFlags;
  if ExecDialog('EditorOptions',@Rec)<>cmCancel then
  begin
    HighlightExt:=Rec.HighlightExt;
    TabSize:=Rec.TabSize;
    EditorFlags:=Rec.EditorFlags;
  end;
end;

procedure ProgectOpt;
var Rec:ProgectOptionsRecord;
begin
  Rec.ProjectHelpFile:=ProjectCollection^.GetHelpFile;
  Rec.OutputHelpFileDir:=ProjectCollection^.GetOutputHelpFileDir;
  if IncludeHelpFile<>nil then Rec.IncludeHelpFile:=IncludeHelpFile^
  else Rec.IncludeHelpFile:='';
  if ExecDialog(sProgectOpt, @Rec)<>cmCancel then
  begin
    AssignStr(ProjectCollection^.HelpFile, Rec.ProjectHelpFile);
    AssignStr(ProjectCollection^.OutputHelpFileDir, Rec.OutputHelpFileDir);
    AssignStr(IncludeHelpFile, Rec.IncludeHelpFile);
    Message(Application,evBroadcast, cmCurentChang, nil);
  end
{  RExecDialog(sOpenHelpFileDialog,nil);}
end;

procedure Colors;
begin
  if ExecDialog('ColorDlg', Application^.GetPalette) <> cmCancel then
  begin
    DoneMemory;
    Application^.ReDraw;
  end;
end;

procedure DirDlg;
begin
  ExecDialog('DirForm', DirRecord);
end;

function NameComponentType(View:PView):string;
begin
  NameComponentType:=GetString(sComponentTypeNameBase+View^.ComponentType);
end;

function QuteString(S:string):string;
var S1:string;
    I:integer;
begin
  S1:='';
  for i:=1 to Length(S) do
      if byte(S[i])<32 then
         if (s1<>'') and (S1[Length(s1)]='''') then
         begin
           Delete(S1,Length(S1),1);
           S1:=S1+'#'+IntToStr(byte(S[i]))+''''
         end
         else
           S1:=S1+'''#'+IntToStr(byte(S[i]))+''''
      else S1:=S1+S[i];
  QuteString:=S1;
end;

function ComponentByName( Owner:PGroup; Name:string):PView;
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
  ComponentByName:=Owner^.FirstThat(@Test);
  if PP<>nil then ComponentByName:=PP;
end;

function AGetPrintForm(GetFormType:TGetFormType):PView;
begin
  //AGetPrintForm:=GetView(Ord(GetFormType)+sPrepReport1);
end;

end.

