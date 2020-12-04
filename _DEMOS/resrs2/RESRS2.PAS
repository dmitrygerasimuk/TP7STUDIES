{$V-,P-,F-,A+}
uses {$IFDEF VER70} {$IFNDEF DPMI} Overlay, {$ENDIF} {$ENDIF}
     App, Objects, DAE,  Views, Drivers, Dos, Memory, Ext_Dos, Ext_Math,
     Ext_Prn, ResStrs, CmdConst, Menus, Global, GlType, AddCntrl,
     MsgBox, RSCllt, Res2Unit, ResTools, Ext_Edit, CmdNamer, Ext_mous,
     Ext_Hlp, ResHelp, Ext_Type, GadGets, HistList, Ext_Crt,
     PropEdit, ListWind, StdForms, Experts, Reports, ColorSel, GL_Proc, VMM,
     PrgMng, Ext_Clp, Prn_Mng, Cursors, Ext_Str, Clases, IniFile, ShardEdt,
{$IFDEF DPMI}
     PXTable, Ext_Help,
{$ENDIF}
     Res2Help, Register, DBT_Unit, Fpt_Unit, Ext_Sys, Ext_Win,
     FormWrt, Dialogs, Storage, DAEQuery{, DemoHelp};


{$O Dialogs}
{$O App}
{$O Cursors}
{$O RsCllt}
{$O Res2UNIT}
{$O DBConstructor}
{$O Ext_Win}

{$O Editors}
{.$O Ext_Edit}
{$O ShardEdt}
{$O Ext_Clp}
{$O StdDlg}
{$O MsgBox}
{$O HelpFile}
{$O Gadgets}
{$O Calendar}
{$O AsciiTab}
{$O Calc}
{$O ColorSel}
{$O MouseDlg}
{$O Outline}
{$O HistList}
{$O Validate}
{$O Menus}
{$O Res2Help}
{$O WHelp}
{$O Ext_Hlp}

{$O IniFile}
{$O Ext_mous}
{$O Ext_Crt}
{$O Forms}
{$O Clases}
{$O AddCntrl}
{$O Gauges}
{$O MultiSel}
{$O AboutPn}
{$O ListWind}
{$O TabNotbk}
{$O El_Lists}
{$O Grids}
{$O Ext_Prn}

{$O Field_Ed}
{$O Ext_Help}
{$O DBGrids}
{$O DBCtrls}
{$O DataCtrl}
{$O Reports}
{$O Type_Rec}

{$O Global}
{$O PropEdit}
{$O GL_Proc}
{$O Property}
{$O StdForms}
{$O Ext_Unit}
{$O Set_Opt}
{.$O Querys}
{.$O DAEQuery}
{.$O SQL_Pars}
{.$O MathEval}

{$O _DBTUnit}
{$O _FPTUnit}

{$O StdForms}
{$O CmdNamer}
{$O PrgMng}
{$O Experts}
{$O FormWrt}
{$O Storage}
{$O RMacros}

{const
  HeapSize = 240 * (1024 div 16);}

function DBErrorProc(Code:TErrorCode; var Info):word;far;
var
  S:string;
begin
  S:=GetString(byte(Code)+2500);
  if S='' then S:=GetString(2500);
  if Code = edbDataSetNotClosed then Writeln(S)
  else MessageBox(S, @Info, mfError+mfOkButton);
  HasError:=true;
end;

type
  TResourseApp = object(TResApplication)
    NewEvent:Boolean;
    constructor Init;
    destructor Done;virtual;
    procedure InitMenuBar; virtual;
    procedure InitStatusLine; virtual;
    procedure HandleEvent(var Event:TEvent);virtual;
    procedure Idle;virtual;
    procedure OpenFile;
    procedure WriteShellMsg;virtual;
    procedure GetEvent(var Event: TEvent);virtual;
    function GetPalette: PPalette; virtual;
    procedure Preferences;
    procedure ReadDesktop;
    procedure WriteDesktop;
    procedure UserScreen;
  end;


constructor TResourseApp.Init;
var
  R:TRect;
begin
  DBError:=DBErrorProc;
  DBText:=DBTextMessageFunc;
  OnPrinterSetupEvent:=PrinterSetupEvent;

  dbDesignTime:=true;
  DesignTime:=true;
  EditorDialog:=EditDialog;
  RegistersSdt;
  RegisterGL_Proc;
  RegisterType(RStringList);
  InitTvrFile(ExePath+LngName);
  ResourseStrings := PStringList(ResourseFile.Get('Strings'));
  HelpStrings := PStringList(ResourseFile.Get('HelpStrings'));
  PrintStr(GetString(sCopyright));
  SaveScreen;
  inherited init;
  InitDataSets;

  ReservedWords:=PStringCollection(ResourseFile.Get('ReservedWords'));
  LoadLocaleInformation;
  New(DirRecord);
  GetPrintForm:=AGetPrintForm;
  PrinterManager:=New(PPrinterManager, Init(pnLpt1));
  PrinterManager^.FreeAllItem:=true;
  GetExtent(R);
    R.A.X := R.B.X - 9; R.B.Y := R.A.Y + 1;
    Clock := New(PClockView, Init(R));
    Insert(Clock);
{  GetExtent(R);
    Dec(R.B.X);
    R.A.X := R.B.X - 9; R.A.Y := R.B.Y - 1;
    Heap := New(PHeapView, Init(R));
    Insert(Heap);}
  InsertWindow(New(PPropertyWindow, Init));
{IFDEF DPMI}
  InitHelpFiles;
  HelpFiles^.Add(ExePath+'Resrs2.tph');
{ENDIF}
  ReadIniFile;
{  if Startup and $100 <> 0 then InitWinClp;
  if Clp = nil then}
  InitStandartClipboard;
{  if Clp = nil then InitTVClipboard;}
  if Startup and $80 <> 0 then
  begin
    StartUpDir:=CurrentDir(CurrentDrive);
    if StartUpDir[Length(StartUpDir)]='\' then dec(StartUpDir[0]);
  end;
  CheckSnow:=Startup and $08<>0;
  CheckConfigRecord;
  CommandDB:=PCommandCollection(ResourseFile.Get('CommandDB'));
  CommandNameDB:=PCommandNameCollection(ResourseFile.Get(sCommandNameDB));
  DisableCommands([cmSave, cmSaveAs, cmCut, cmCopy, cmPaste, cmClear,
    cmUndo, cmFind, cmReplace, cmSearchAgain, cmCloseAll, cmGotoLine,
    cmAddToRepository, cmRunDemoPrg, cmCreateAll]);
  ReadDeskTop;
  if ParamCount<>0 then ParseCmdLine;
{$IFDEF DPMI}
{  if GeneratorOptions.AutoOpen and $02<>0 then
     if ProjectCollection^.HelpFile<>nil then
        LoadRefFromFile(ReplaceExt(ProjectCollection^.HelpFile^,'.ref',true));}
{$ENDIF}
end;

destructor TResourseApp.Done;
var c:integer;
begin
  WriteIniFile;
  DoneClipboard;
  if PropertyWindow<>nil then PropertyWindow^.Free;
  if PrnManager<>nil then PrnManager^.Free;
  Dispose(PrinterManager, Done);
  WriteDesktop;
  if Startup and $80 <> 0 then
  begin
   c:=IOResult;
   {$I-}
   ChDir(StartUpDir);
   {$I+}
   if IOResult<>0 then RMessageBox(sNotReturnDir, nil, mfError+mfOkButton);
  end;
{IFDEF DPMI}
{  if RefTable<>nil then RefTable^.Free;}
  DoneHelpSystem;
  DoneHelpFiles;
{ENDIF}
  inherited Done;
  Dispose(DirRecord);
  RestoreScreen;
  DoneDataSets;
  DIspose(ReservedWords, Done);
end;

function TResourseApp.GetPalette: PPalette;
const
  CNewColor =  CAppColor + CHelpColor + #$1F#$1C#$1A#$17 + #$1E#$17#$1F#$1E#$1E#$1C#$1A#$1E;
  CNewBlackWhite = CAppBlackWhite + CHelpBlackWhite + #$1F#$1A#$1C#$17 + #$1E#$1E#$1E#$1E#$1E#$1E#$1E#$1E;
  CNewMonochrome = CAppMonochrome + CHelpMonochrome + #$1F#$1A#$1C#$17 + #$1E#$1E#$1E#$1E#$1E#$1E#$1E#$1E;
  P: array[apColor..apMonochrome] of string[Length(CNewColor)] =
    (CNewColor, CNewBlackWhite, CNewMonochrome);
begin
  GetPalette := @P[AppPalette];
end;

procedure TResourseApp.OpenFile;
var
  FileName: FNameStr;
  D:PExtEditWindow;
begin
  FileName := sExtPas;
  if ExecDialog(sFileOpenDialog, @FileName) <> cmCancel then
  begin
    D:=CreateEditWindow(FileName, hcEditWindow);
    D^.Editor^.OnKeyEvent:=HandleEventCodeEditor;
  end;
end;


procedure TResourseApp.GetEvent(var Event: TEvent);

{IFDEF DPMI}
procedure HelpWin(HC:word);
begin
{  Help(1,HC,false);}
  HelpTopic('Help_Contents'{0,hcContents,false});

  ClearEvent(Event);
end;

function CasehelpCtx:word;
begin
  case Event.Command of
    cmHelp:CasehelpCtx:=GetHelpCtx;
    cmCompDirect:CasehelpCtx:=hcCompDirect;
    cmProc_Fun:CasehelpCtx:=hcProc_Fun;
    cmReservWords:CasehelpCtx:=hcReservWords;
    cmStdUnits:CasehelpCtx:=hcStdUnit;
    cmBPLang:CasehelpCtx:=hcBPLang;
    cmErrorMessag:CasehelpCtx:=hcErrorMessag;
  else
    CasehelpCtx:=0;
  end;
end;
{ENDIF}

begin
  TApplication.GetEvent(Event);
  if (Event.What =  evMouseDown) and ((Event.Buttons = mbRightButton)
      and (GetShiftState and (kbRightShift + kbLeftShift)<>0)) then
     Event:=EventArray[RightMoussBtn];
{IFDEF DPMI}
  if (Event.What = evCommand) and ((Event.Command = cmHelp)
     or (CaseHelpCtx<>0))then HelpWin(caseHelpCtx);
{ENDIF}
  NewEvent:=Event.What<>evNothing;
end;

procedure TResourseApp.Idle;
function IsTileable(P: PView): Boolean; far;
begin
  IsTileable := P^.Options and ofTileable <> 0;
end;
begin
  inherited Idle;
  Clock^.Update;
{  Heap^.Update;}
  if Desktop^.FirstThat(@IsTileable) <> nil then
     EnableCommands([cmTile, cmCascade,cmCloseAll])
  else
     DisableCommands([cmTile, cmCascade,cmCloseAll]);
  PrinterManager^.Update;
  Message(@Self, evBroadcast, cmIdle, nil);
{  SetCmdState([cmPrintFile], (Desktop^.Current<>nil) and
                           (Desktop^.Current^.ComponentType in [ctEditWindow]));}
  if NewEvent then
  begin
    if PropertyWindow<>nil then PropertyWindow^.ReDRaw;
    NewEvent:=false;
    if IndexPageWnd<>nil then
    begin
      if IndexPageWnd^.Range<>Nodes^.Count then
         IndexPageWnd^.SetRange(Nodes^.Count);
      IndexPageWnd^.DrawView;
    end;
  end;
  IdleCalls;
end;

procedure TResourseApp.WriteShellMsg;
begin
  PrintStr(GetString(sDosShellMsg));
end;

procedure TResourseApp.InitMenuBar;
begin
  MenuBar := PMenuBar(ResourseFile.Get('MenuBar'));
end;


procedure TResourseApp.InitStatusLine;
begin
  StatusLine := PStatusLine(ResourseFile.Get('StatusLine'));
end;

procedure TResourseApp.UserScreen;
begin
  HideMouse;
  DoneVideo;
  RestoreScreen;
  WaitEvent;
  InitVideo;
  Redraw;
  ShowMouse;
end;

procedure TResourseApp.Preferences;
begin
  if ExecDialog('PrefDlg', @PrefRec)<>cmCancel then ChekPreferense;
end;

procedure TResourseApp.HandleEvent(var Event:TEvent);

procedure OpenDskFile;
begin
  if ExecDialog('DSKOpenDialog', @DSKFile)=cmCancel then exit;
  DSKFile:=FExpand(DSKFile);
  ReadDesktop;
  UpDateMenuBar;
end;

procedure SaveAsDskFile;
begin
  if ExecDialog('DSKSaveDialog', @DSKFile)=cmCancel then exit;
  DSKFile:=FExpand(DSKFile);
  WriteDesktop;
  UpDateMenuBar;
end;


procedure DoClose(P:PView);far;
begin
  if ProjectCollection^.InCollect(P) then
  begin
     Message(Desktop, evBroadcast, cmCurSelect, nil);
     ProjectCollection^.DeleteForm(PGroup(P));
     Modified:=true;
     UpDateMenuBar;
  end
  else Message(P, evCommand, cmClose, nil);
end;

procedure Dos_Shell;
begin
  DoneSysError;
  DoneEvents;
  DoneVideo;
  DoneDosMem;
  RestoreScreen;
  WriteShellMsg;
  SwapVectors;
  Exec(GetEnv('COMSPEC'), '');
  SaveScreen;
  SwapVectors;
  InitDosMem;
  InitVideo;
  InitEvents;
  InitSysError;
  UpDateMenuBar;
  Redraw;
end;

procedure ReadForm;
var S:PStream;
    D:PWindow;
    R:TRect;
    V:PView;
begin
{  S:=New(PDosStream, Init('C:\DEMO.TFM', stOpen));
  D:=PWindow(ReadControl(S));
  R.Assign(10,10,50,20);
  D:=New(PDialog, Init(R,''));
  if D<>nil then
    Application^.InsertWindow(D);
  R.Assign(1,1,10,2);
  V:=New(PStaticText, Init(R, 'DEMO!!!'));
  D^.Insert(V);
  S^.Free;}
end;

begin
  if Event.What=evBroadcast then
     if Event.Command=cmUpdateTitle then DoUpdateTitle(Event.InfoPtr);
  inherited HandleEvent(Event);
  case Event.What of
  evCommand:
    case Event.Command of
      cmNewUnit:NewUnit;
      cmBuffer:ChangeTarget;
      cmMouse:MouseOptions;
      cmChangeDir:if ExecDialog('ChDirDialog',nil)<>cmCancel then UpDateMenuBar;
      cmColors:Colors;
      cmOpenFile:OpenFile;
      cmShowClip:ShowClip;
      //cmAsciiTab:InsertWindow(PWindow(GetView(sAsciiTable)));
      //cmCalendar:InsertWindow(PWindow(GetView(sCalendarWindow)));
      //cmNodeObjects:InsertWindow(PWindow(GetView(sNodeObj)));
{      cmIndexPageStack: if IndexPageWnd<>nil then IndexPageWnd^.Owner^.Select
                        else InsertWindow(PWindow(GetView(sIndexPageStack)));}
      cmGNOpt:ExecDialog('GNOpt',@GeneratorOptions);
      cmCompOpt:ExecDialog('CompOpt', @CompilerOptions);
      cmPreferences:Preferences;
      cmOpenDskFile:OpenDskFile;
      cmSaveDskFile:WriteDesktop;
      cmSaveAsDskFile:SaveAsDskFile;
      cmUserScreen:UserScreen;
      cmOutput:Output;
      cmEditorOpt:EditorOptions;
      cmShellDos:Dos_Shell;
      cmStartup:StartupProc;
      cmPropertyList:PropertyList;
      cmListWindow:WindowListDlg;
      cmObjectRepository:ObjectRepository;
      cmAddToRepository:AddToRepository;
      cmOpenData:OpenData;
      cmReportExpert:ReportExpert;
      cmDBPref:DBPrefProc;
      cmDialogExpert:DialogExpert;
      cmViewProject:if ProjectManager<>nil then ProjectManager^.Select else InsertWindow(New(PProjectManager, Init));
      cmPrintManager:if PrnManager<>nil then PrnManager^.Select else InsertWindow(New(PPrnManager, Init));
      cmCloseAll:Desktop^.ForEach(@DoClose);
      cmProgectOpt:ProgectOpt;
{$IFDEF DPMI}
{      cmBuildHlpFile:BuildHlpFile;}
      cmHelpFiles:AddHelpFileDlg;
      cmTopicSearch:TopicSearch;
      cmHelpIndex:HelpIndex('');
{      cmAbout:Help(1,64552,false);}
{$ENDIF}
{$IFNDEF SINGLE}
{      cmBuildHlpFile:ShowHelpWindow11;}
{$ENDIF}
      cmHelpFiles:AddHelpFileDlg;
      cmTopicSearch:TopicSearch;
      cmHelpIndex:HelpIndex('');

      cmNewData:CreateDataBase;
      cmViewAsText:StoreCurentForm;
      cmAliasEditor:AliasEditor;
      cmDBConstructor:DBConstructorEditor;
      cmNewTextFile:CreateEditWindow('',0);
      cmAbout:About;
      cmDir:DirDlg;
      cmAppExpert:AppExpert;
    else
      exit;
    end;
  else
    exit
  end;
  ClearEvent(Event);
end;

procedure TResourseApp.ReadDesktop;
var
  S:PDosStream;
  Sign:string;
  EO:word;
  CO:TCompilerOptions;
  Pal: PString;
  Rec:TDBPrefRecord;
  //Signature:string[23];
  P:PCollection;

procedure DoInsert(P:PWindow);far;
begin
  InsertWindow(P);
end;

begin
  if not FileExists(DSKFile) then exit;
  //Signature:=sSignature;
  S:=New(PDosStream, Init(DSKFile, stOpen));
  if S^.Status=stOk then
  begin
    SetLength(Sign, Length(sSignature));
    //Sign[0]:=#23;
    S^.Read(Sign[1], Length(sSignature));
    if Sign<>sSignature then
       RMessageBox(sErrorInDSK, nil, mfOkButton+mfError)
    else
    begin
      LoadHistory(S^);
      S^.Read(CO, SizeOf(TCompilerOptions));
      Pal := S^.ReadStr;
      if Pal <> nil then
      begin
        Application^.GetPalette^ := Pal^;
        DoneMemory;
        Application^.ReDraw;
        DisposeStr(Pal);
      end;
      if S^.Status=stOk then
      begin
        Move( CO, CompilerOptions,SizeOf(TCompilerOptions));
      end;
      S^.Read(Rec, SizeOf(TDBPrefRecord));
      if S^.Status=stOk then SetDbPref(Rec);
      LoadIndexes(S^);
      P:=PCollection(S^.Get);
      P^.ForEach(@DoInsert);
      P^.DeleteAll;
      Dispose(P, Done);
      if S^.Status<>stOk then
         RMessageBox(sErrorReadDSK, nil, mfOkButton+mfError)
    end;
  end
  else RMessageBox(sErrorOpenDSK, nil, mfOkButton+mfError);
  S^.Free;
end;

procedure TResourseApp.WriteDesktop;
var
  S:PDosStream;
  Pal: PString;
  Dir:DirStr;
  Name: NameStr;
  Ext: ExtStr;
  Rec:TDBPrefRecord;
  Signature:string[23];
  P:PCollection;
begin
  FSplit(DSKFile, Dir, Name, Ext);
  Signature:=sSignature;
  if Dir='' then
    if Prefrec.DesktopFile=1 then DSKFile:=ExePath+Name+Ext
    else DSKFile:=FExpand(DSKFile);
  S:=New(PDosStream, Init(DSKFile, stCreate));
  if S^.Status=stOk then
  begin
    S^.Write( Signature[1], Length(sSignature));
    StoreHistory(S^);
    S^.Write(CompilerOptions, SizeOf(TCompilerOptions));
    Pal := @Application^.GetPalette^;
    S^.WriteStr(Pal);
    GetDbPref(Rec);
    S^.Write(Rec, SizeOf(TDBPrefRecord));
    StoreIndexes(S^);
    P:=New(PCollection, Init(10,5));
    Message(Application, evBroadcast, cmAddToCollect, P);
    S^.Put(P);
    if S^.Status<>stOk then RMessageBox(sErrorWriteDSK, nil, mfOkButton+mfError);
  end
  else RMessageBox(sErrorCreateDSK, nil, mfOkButton+mfError);
  S^.Free;
end;

procedure LoadStartUpIni;
var I:PIniFile;
    S:FNameStr;
begin
  S:=EXEName+'.INI';
  if not FileExists(S) then S:=EXEPath+S;
  I:=New(PIniFile, Init(S));
{$IFDEF SINGLE}
  S:=ExeName+'.EXE';
{$ELSE}
  S:=ExeName+'.TVR';
{$ENDIF}
  LngName:=I^.ReadString('System','Language resurse',S);
  if not FileExists(EXEPath+LngName) then LngName:=S;
  I^.Free;
end;

var
  ResourseApp:TResourseApp;

begin
{$IFDEF VER70}
{$IFNDEF DPMI}
{$IFDEF SINGLE}
  OvrInit(ExePath+Ext_Dos.ExeName+'.exe');
{$ELSE}
  OvrInit(ExePath+Ext_Dos.ExeName+'.ovr');
{$ENDIF}
  OvrSetBuf(58 * 1024);
  if OvrResult <> ovrOk then
  begin
    PrintStr('No overlays found in .EXE file.'#13#10);
    Halt(1);
  end;
{$ENDIF}
{$ENDIF}
  LoadStartUpIni;

  ResourseApp.Init;
  ResourseApp.Run;
  ResourseApp.Done;

  DisposeReaderTree;
end.

