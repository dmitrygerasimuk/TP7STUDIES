{$O+}
{$I Define.inc}
unit Res2UNIT;
interface
uses App, Drivers, RsCllt, Objects, ResTools, CmdNamer;

type
   TResApplication = object(TApplication)
     Modified:Boolean;
     constructor Init;
     destructor Done;virtual;
     procedure HandleEvent(var Event:TEvent);virtual;
     procedure NewForm;
     procedure SaveProgect;
     procedure OpenProgect;
     procedure InsertElement;
     procedure Idle;virtual;
     procedure MouseRightButton(var Event:TEvent);
     procedure CloseResurse;
     procedure CreateUnit;
     procedure TestForm;
     function Valid(Command: Word): Boolean; virtual;
     procedure DelElement;
     procedure CreateForm;
     procedure WriteUnitList(F:PFormMain);
     procedure WriteVar(F:PFormMain);
     procedure FindforSetOptions(var Event:Tevent);
     procedure ElementList;
     procedure NewProject;
     procedure ObjectRepository;
     procedure AddToRepository;
     procedure ModifyProgect(Info:pointer);
     procedure CreateDataTransferType(F:PFormMain);
     procedure LocalMenu;
     procedure StoreCurentForm;
   end;

implementation
uses Views, CmdConst, Global, Dos, Ext_Dos, Cursors, ResStrs,
     MsgBox, Ext_Math, AddCntrl, Dialogs, Ext_str, Ext_Unit, Set_Opt,
     StdForms, Ext_App, DAE, GlType, PropEdit, Type_Rec, ShardEdt,
     Ext_Type, Register, {FORMWRT, }Storage, IniFile;

constructor TResApplication.Init;
begin
  inherited Init;
  ProjectCollection:=New(PResCollection,Init);
  _Cursor:=New(PCursor,Init);
  DisableCommands([ cmNewElement,cmCreateForm, cmFindElement,cmTestForm]);
end;

destructor TResApplication.Done;
begin
  if ProjectCollection<>nil then Dispose(ProjectCollection, Done);
  inherited Done;
  if _Cursor<>nil then _Cursor^.Free;
end;

function TResApplication.Valid(Command: Word): Boolean;
begin
  Valid:=false;
  if (Command=cmQuit) and Modified then
  case RMessageBox(sProgectNotSave,nil,mfYesNoCancel) of
       cmYes:SaveProgect;
       cmCancel:exit;
       cmNo:FreeProject:=true;
  end;
  Valid:=inherited Valid(Command);
end;

procedure TResApplication.NewForm;
var
  ACF:PFormMain;
begin
  ACF:=ProjectCollection^.NewForm(nil);
  InsertWindow( ACF^.FormPtr);
  Modified:=true;
end;

procedure TResApplication.Idle;
begin
  inherited Idle;
  if (ProjectCollection<>nil) then
  begin
   if (DeskTop^.Current<>nil) and
      ProjectCollection^.InCollect(DeskTop^.Current) then
      EnableCommands([ cmNewElement,cmCreateForm, cmFindElement,
                       cmTestForm, cmAddToRepository])
   else
     DisableCommands([ cmNewElement,cmCreateForm, cmFindElement,cmTestForm,
                          cmAddToRepository]);
  if GetHelpCtx=hcDragging then
     if ProjectCollection^.InCollect(DeskTop^.Current) then
     begin
        ProjectCollection^.CurentUpDate(nil);
        Modified:=true;
     end;
  end;
end;


procedure TResApplication.OpenProgect;
var
  S:TBufStream;
  Name:FNameStr;
  P:PString;
  Dir: DirStr;
  AName: NameStr;
  Ext: ExtStr;
begin
  Name:=sExtPrg;
  P:=@Name;
  if ExecDialog(sProgectDialog,P)=cmCancel then Exit;
  if not FileExists(Name) then
  begin
    RMessageBox(ResStrs.sFileNotFound, @P, mfError+mfOkButton);
    exit;
  end;
  if ProjectCollection^.Count<>0 then  SaveProgect;
  ProjectCollection^.FreeAll;
  if PrefRec.Options and $04 <>0 then
  begin
    FSplit(Name, Dir, AName, Ext);
    {$I-}
    ChDir(Dir);
    {$I+}
    if IOResult<>0 then
    begin
      P:=@Dir;
      RMessageBox(sNotChDir, @P, mfError+mfOkButton);
      exit;
    end;
  end;
  Dispose(ProjectCollection, Done);
  ProgectName:=Name;
  S.Init( Name, stOpen, 2048);
  ProjectCollection:=New(PResCollection, Load(S));
  S.Done;
  UpDateMenuBar;
end;

procedure TResApplication.SaveProgect;
var
  S:TBufStream;
  Name:FNameStr;
  D:PGroup;
  SS:PIniFile;
begin
  if ProgectName='' then
  begin
    Name:=sExtPrg;
    if ExecDialog(sProgectSaveDialog,@Name)=cmCancel then Exit;
    ProgectName:=Name;
  end;
  D:=_Cursor^.Owner;
  if D<>nil then begin
   D^.Lock;
   D^.Delete(_Cursor);
  end;
  BakUpFile(ProgectName, sExtPrgBack,true);
  S.Init( ProgectName, stCreate, 2048);
  ProjectCollection^.Store(S);
  S.Done;
  SS:=New(PIniFile, Init('c:\demo.iii'));
  ProjectCollection^.SaveProgect(SS);
  SS^.Free;
  if D<>nil then
  begin
    D^.Insert(_Cursor);
    D^.UnLock;
  end;
  UpDateMenuBar;
  Modified:=false;
end;

procedure TResApplication.InsertElement;
var
  S:String;
begin
  if ExecDialog(sObjectInspector, @S)<> cmCancel then
  begin
     ProjectCollection^.InsertElement(PView(ResourseFile.Get(S)));
     Modified:=true;
  end;
end;

procedure TResApplication.FindforSetOptions(var Event:Tevent);
var
  T:word;
  P:PView;
  Form:PFormMain;
  AOwner:PGroup;
begin
  if _Cursor^.Owner=nil then exit;
  if ProjectCollection^.InCollect(Desktop^.Current) then
  begin
    if _Cursor^.Owner^.ComponentType in GroupControl then
       AOwner:=_Cursor^.Owner^.Owner
    else AOwner:=_Cursor^.Owner;
    Form:=ProjectCollection^.FindForm(AOwner);
    P:=_Cursor^.FindView(Form^.FormPtr, Event);
    if P=PView(Form^.FormPtr^.Frame) then
        Message(Application, evBroadcast, cmCurSelect, Form^.FormPtr)
     else SetOptions( P, Form, Event.Where);
     AOwner^.ReDraw;
     ClearEvent(Event);
  end;
end;

procedure TResApplication.MouseRightButton(var Event:TEvent);
var
  D:PGroup;
begin
  if ProjectCollection^.InCollect(Desktop^.Current) then
     if Event.Double then
         FindforSetOptions( Event)
     else
     begin
         D:=PGroup(Desktop^.Current);
         _Cursor^.SelectView(D, Event);
         D^.Redraw;
     end;
end;

procedure TResApplication.CloseResurse;
begin
  if Modified then SaveProgect;
  ProjectCollection^.FreeAll;
  ProgectName:='';
  Modified:=false;
  UpDateMenuBar;
end;

procedure TResApplication.CreateUnit;
var
  S:FNameStr;
  Dir: DirStr;
  Name: NameStr;
  Ext: ExtStr;
  F:boolean;
  P:PSTring;
  A:array [1..5] of longint;
  D:DateTime;
begin
  S:='NewUnit.pas';
  if ExecDialog(sFileOpenDialog,@S)<>cmCancel then
  begin
    F:=FileExists(S);
    P:=@S;
    if f then f:=RMessageBox(sOwerWriteFile,@P,mfWarning or mfOkCancel)=cmCancel;
    if not f then
    begin
      FSplit(S,Dir,Name,Ext);
      InitEditor(Name+Ext);
      if GeneratorOptions.InsComents and $01<>0 then
      begin
         WriteForm(GetString(sComents1));
         WriteForm(GetString(sComents2));
         WriteForm(GetString(sComents3));
         GetDateTime(D);
         a[4]:=D.Hour;a[5]:=D.Min;
         a[3]:=D.Year;a[2]:=D.Month;a[1]:=D.Day;
         WriteForm(StrFormat(GetString(sComents4),a));
         WriteForm(GetString(sComents1));
      end;
     if GeneratorOptions.InsComents and $01<>0 then
        WriteForm(GetCompilerDefStr);
      P:=@Name;
      S:=StrFormat(GetString(sUnitProto),P);
      WriteForm(S);
    end;
  end;
end;

procedure TResApplication.TestForm;

procedure DoHideProgect(P:PFormMain);far;
begin
  if P^.FormPtr<>nil then P^.FormPtr^.Hide;
end;

procedure DoShowProgect(P:PFormMain);far;
begin
  if P^.FormPtr<>nil then P^.FormPtr^.Show;
end;

var
  P:PFormMain;
  S:PStream;
  F:PGroup;
  PS:PString;
begin
  P:=ProjectCollection^.FindForm(PGroup(Desktop^.Current));
  S:=TempStream(not Target);
  F:=_Cursor^.Owner;
  if F<>nil then F^.Delete(_Cursor);
  S^.Put(P^.FormPtr);
  ProjectCollection^.ForEach(@DoHideProgect);
  if PropertyWindow<>nil then PropertyWindow^.Hide;
  S^.Seek(0);
  dbDesignTime:=false;
  DesignTime:=false;
  PS:=NewStr(CommandName(ExecuteDialog(PDialog(S^.Get),nil)));
  dbDesignTime:=true;
  DesignTime:=true;
  if PropertyWindow<>nil then PropertyWindow^.Show;
  RMessageBox( sReturnCode,@PS,mfInformation+mfOkButton);
  DisposeStr(PS);
  S^.Free;
  if F<>nil then F^.Insert(_Cursor);
  ProjectCollection^.ForEach(@DoShowProgect);
end;

procedure TResApplication.DelElement;
var
  P:PGroup;
  V:PView;
  F:PFormMain;
begin
  if not ProjectCollection^.InCollect(Desktop^.Current) then exit;
  P:=PGroup(Desktop^.Current);
  if (_Cursor^.Owner=P) or
     ((_Cursor^.Owner^.ComponentType in GroupControl) and
      (_Cursor^.Owner^.Owner = P)) then
  begin
    V:=_Cursor^.EditView;
    F:=ProjectCollection^.FindForm(P);
    F^.Modified:=true;
    Message(F^.FormPtr, evBroadcast, cmDestroed, V);
    V^.Owner^.Delete(V);
    _Cursor^.SetLink(nil);
    V^.Free;
  end;
end;

procedure TResApplication.WriteUnitList(F:PFormMain);
var
  S:String;
  Count,i:byte;
  Find:Boolean;
  UnitNumber:word;
  UnitList:array[1..50] of byte;

procedure Test(P:PView);far;
var i:byte;

begin
    if P^.ComponentType in SystemTypeSet then exit;
    find:=false;
    UnitNumber:=CaseUnit(P^.ComponentType);
    for i:=1 to Count do if UnitNumber=UnitList[i] then find:=true;
    if not find then
      if Count=50 then RMessageBox(sToManyUnits,nil,mfError+mfOkButton)
      else
      begin
        inc(Count);
        UnitList[Count]:=UnitNumber;
        S:=S+', '+ResourseStrings^.Get(UnitNumber+sUnit1-3);
      end;
    if Length(S)>62 then
    begin
      WriteForm(S);
      S:='     ';
    end;
end;

begin
  UnitList[1]:=1;
  UnitList[2]:=2;
  Count:=2;
  S:='';
  F^.FormPtr^.ForEach(@Test);
  S:=S+';'+cEoL;
  WriteForm(S);
end;

procedure TResApplication.WriteVar(F:PFormMain);
var
  S,S1:string;
  param:array [1..2] of longint;
procedure Fill(P:PView);far;
procedure DoFill(P:PView);far;
begin
    if not (P^.ComponentType in SystemTypeSet) then
    begin
      S:=P^.ComponentName^;
      S1:=GetString(sComponentTypeNameBase+P^.ComponentType);
      Param[1]:=LongInt(@S);
      Param[2]:=LongInt(@S1);
      WriteForm(StrFormat(s514, Param));
    end;
end;
begin
    if not (P^.ComponentType in SystemTypeSet) then
    begin
      S:=P^.ComponentName^;
      S1:=GetString(sComponentTypeNameBase+P^.ComponentType);
      Param[1]:=LongInt(@S);
      Param[2]:=LongInt(@S1);
      WriteForm(Format(GetString(514), Param));
      if (P^.ComponentType in NotVisualConteyner) and
         (GeneratorOptions.CodeGeneration and $08<>0) then
         DoWriteNotVisual(P);
      if P^.ComponentType in GroupControl then
         PGroup(P)^.ForEach(@DoFill);
    end;
end;
begin
  F^.FormPtr^.ForEach(@Fill);
end;

procedure TResApplication.CreateForm;
var
  P:PString;
  A:array [1..5] of longint;
  Hour, Minute, Second, Sec100: Word;
  Year, Month, Day, DayOfWeek: Word;
  F:PFormMain;
  Dir: DirStr;
  Name: NameStr;
  Ext: ExtStr;
  V:PView;
  CursorOwner:PGroup;
  SaveEditorsFlag:Longint;
begin
  F:=ProjectCollection^.FindForm(PGroup(Desktop^.Current));
  F^.UnitName:=ReplaceExt(F^.UnitName,'.pas',false);
  SaveEditorsFlag := EditorFlags;
  EditorFlags:=EditorFlags and (not efAutoIndent);
  InitEditor(F^.UnitName);
  PP^.Lock;
  FSplit(F^.UnitName,Dir,Name,Ext);
  if GeneratorOptions.InsComents and $01<>0 then
  begin
     WriteForm(GetString(sComents1));
     WriteForm(GetString(sComents2));
     WriteForm(GetString(sComents3));
     GetTime(Hour, Minute, Second, Sec100);
     a[4]:=Hour;a[5]:=Minute;
     GetDate(Year, Month, Day, DayOfWeek);
     a[3]:=Year;a[2]:=Month;a[1]:=Day;
     WriteForm(StrFormat(GetString(sComents4),a));
     WriteForm(GetString(sComents1));
  end;
  if GeneratorOptions.InsComents and $01<>0 then
     WriteForm(GetCompilerDefStr);

  a[1]:=Longint(@Name);
  LineWrite(StrFormat(GetString(504),a));
  WriteUnitList(F);
  if (GeneratorOptions.CodeGeneration and $02<>0) and
     (F^.FormPtr^.DataSize<>0) then
     CreateDataTransferType(F);
  a[1]:=Longint(@F^.ProcName);
  LineWrite(StrFormat(GetString(535),a));
  a[1]:=Longint(@F^.ProcName);
  WriteForm(StrFormat(GetString(501),a));
  WriteVar(F);
  a[1]:=Longint(F^.FormPtr^.ComponentName);
  WriteForm(StrFormat(GetString(503),a));
  WriteForm('   '+RectToStr(F^.FormPtr));
  A[2]:=Longint(PDialog(F^.FormPtr)^.Title);
  WriteForm(StrFormat(GetString(506),a));
  WriteForm(StrFormat(GetString(507),a));
  if F^.FormPtr^.Palette<>dpGrayDialog then
     WriteForm(GetString(508+F^.FormPtr^.Palette));
  CursorOwner:=_Cursor^.Owner;
  if CursorOwner<>nil then
     CursorOwner^.Delete(_Cursor);
  CountChar:=6;
  MakeGroup(F^.FormPtr, false);

  WriteForm(sSelEnd);
  if CursorOwner<>nil then
     CursorOwner^.Insert(_Cursor);
  a[1]:=Longint(@F^.ProcName);
  a[2]:=Longint(F^.FormPtr^.ComponentName);
  if GeneratorOptions.CodeGeneration and $01<>0 then
     WriteForm(StrFormat(GetString(528),a[2]));
  WriteForm(StrFormat(GetString(529),a));
  WriteForm(GetString(505));
  PP^.UnLock;
  EditorFlags:=SaveEditorsFlag;
end;

procedure TResApplication.CreateDataTransferType(F:PFormMain);
var
  A:array [1..5] of longint;

procedure DoWriteElements(Group:PGroup);
var V:PView;
begin
   V:=Group^.Last;
   repeat
     if V^.DataSize<>0 then WriteTypeElements(V);
     if V^.ComponentType in GroupControl then
        if PGroup(V)^.Last<>nil then DoWriteElements(PGroup(V));
     V := V^.Prev;
   until V=Group^.Last;
end;
begin
  if F^.FormPtr^.Last <> nil then
  begin
    a[1]:=Longint(F^.FormPtr^.ComponentName);
    WriteForm(StrFormat(GetString(536),a));
    DoWriteElements(F^.FormPtr);
    WriteForm(GetString(537));
  end
end;

procedure TResApplication.ElementList;
var List:TListBoxRec;
    Form:PFormMain;
    S,S1:String;
begin
  Form:=ProjectCollection^.FindForm(PGroup(Desktop^.Current));
  FillRecord( Form, _Cursor^.EditView, AllType-SystemTypeSet+[ctDialog], true, List);
  if ExecDialog(sElemList, @List)<>cmCancel then
  begin
    if List.Selection=0 then
      Message(Application, evBroadcast, cmCurSelect, Form^.FormPtr)
    else
    begin
      S1:=PString(PCollection(List.List)^.At(List.Selection))^;
      S:=Copy(S1, 1, Pos(':',S1)-1);
      _Cursor^.SetLink(FindByName(Form,  S));
      Form^.FormPtr^.ReDraw;
    end;
  end;
  Dispose(PCollection(List.List), Done);
end;

procedure TResApplication.ModifyProgect(Info:pointer);
begin
  ProjectCollection^.CurentUpDate(Info);
  Modified:=true;
end;

procedure TResApplication.HandleEvent(var Event:TEvent);
begin
  if (Event.What=evCommand) and (Event.Command=cmClose)then
     if ProjectCollection^.InCollect(PGroup(Event.InfoPtr)) or
        ((Event.InfoPtr=nil) and ProjectCollection^.InCollect(PGroup(Desktop^.Current))) then
     begin
        Message(Desktop, evBroadcast,cmCurSelect, nil);
        if Event.InfoPtr=nil then
           ProjectCollection^.DeleteForm(PGroup(Desktop^.Current))
        else  ProjectCollection^.DeleteForm(PGroup(Event.InfoPtr));
        ClearEvent(Event);
        Modified:=true;
        UpDateMenuBar;
     end;
  if (Event.What=evMouseDown) and (Event.Buttons=mbRightButton) then
          MouseRightButton(Event);
  inherited HandleEvent(Event);
  case Event.What of
    evCommand:
    case Event.Command of
        cmNew:NewForm;
        cmSaveAll:SaveProgect;
        cmNewElement:InsertElement;
        cmOpenRes:OpenProgect;
        cmCloseRes:CloseResurse;
        cmOpenForm:LoadForm(Event.InfoPtr);
        cmNewUnit:CreateUnit;
        cmTestForm:TestForm;
        cmCreateForm:CreateForm;
        cmFindElement:ElementList;
        cmDeleteElem:DelElement;
        cmNewRes:NewProject;
        cmLocalMenu:LocalMenu;
    else
       exit;
    end;
    evBroadcast:
    case Event.Command of
        cmCurentChang:ModifyProgect(Event.InfoPtr);
    else
       exit;
    end;
    evKeyDown:
    case Event.KeyCode of
      kbDel:DelElement;
    else
      exit;
    end;
  else
    exit;
  end;
  ClearEvent(Event);
end;

procedure TResApplication.NewProject;
begin
  CloseResurse;
  NewForm;
end;

function RepositFile:PResourceFile;
var
  FName:FNameStr;
  Mode:word;
begin
  FName:=ExePath+sRepositFile;
  if FileExists(FName) then Mode:=stOpen else Mode:=stCreate;
  RepositFile:=New(PResourceFile, Init(
      New(PBufStream, Init(FName, Mode, 1024))));
end;

procedure TResApplication.ObjectRepository;
var
  Rec:TResourceListRec;
  Form:PFormMain;
begin
  FillChar(Rec, SizeOf(TResourceListRec), 0);
  Rec.List:=RepositFile;
  if (ExecDialog(sRepositoryDlg, @Rec)<>cmCancel)
     and (Rec.List^.Count<>0) then
  begin
     Form:=ProjectCollection^.NewForm(
        PDialog(Rec.List^.Get(Rec.List^.KeyAt(Rec.Selection))));
     InsertWindow( Form^.FormPtr);
     Modified:=true;
  end;
  Rec.List^.Free;
end;

procedure TResApplication.AddToRepository;
var RFile:PResourceFile;
    Name:string;
    Form:PFormMain;
    CursorOwner:PGroup;
begin
  Form:=ProjectCollection^.FindForm(PGroup(DeskTop^.Current));
  if Form=nil then exit;
  Name:='';
  if (ExecDialog(sAddRepositoryDlg,@Name)<>cmCancel)
     and (Name<>'') then
  begin
    RFile:=RepositFile;
    CursorOwner:=_Cursor^.Owner;
    if CursorOwner<>nil then
       CursorOwner^.Delete(_Cursor);
    RFile^.Put(Form^.FormPtr, Name);
    if CursorOwner<>nil then
       CursorOwner^.Insert(_Cursor);
    RFile^.Free;
  end;
end;

procedure TResApplication.LocalMenu;
var AOwner:PGroup;
    T:TPoint;
begin
  if _Cursor^.Owner=nil then exit;
  if (_Cursor^.Owner<>nil) and
     (ProjectCollection^.InCollect(Desktop^.Current)) then
  begin
    if _Cursor^.Owner^.ComponentType in GroupControl then
       AOwner:=_Cursor^.Owner^.Owner
    else AOwner:=_Cursor^.Owner;
    if AOwner=PGroup(Desktop^.Current) then
    begin
      T.X:=0;T.Y:=0;
      _Cursor^.EditView^.MakeGlobal(T, T);
      SetOptions( _Cursor^.EditView, ProjectCollection^.FindForm(AOwner), T);
      AOwner^.ReDraw;
    end;
  end;
end;

procedure TResApplication.StoreCurentForm;
var Form:PFormMain;
    Writer:PWriter;
begin
  Form:=ProjectCollection^.FindForm(PGroup(Desktop^.Current));
  if (Form<>nil) and (Form^.FormPtr<>nil) then
  begin
    Writer:=New(PWriter, Init('C:\DEMO.TFM'));
    Writer^.WriteControl(Form^.FormPtr);
    Writer^.Free;
  end;
end;

end.
