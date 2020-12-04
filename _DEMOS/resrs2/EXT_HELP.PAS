{$O+}
{$I Define.inc}
unit Ext_Help;
interface
uses Objects, HelpFile, Dialogs, Clases, Register;
const
  BegXRef = '{';
  EndXRef = '}';
  AliasCh = ':';
  CommandChar = '.';

type
  PCrossRefNode = ^TCrossRefNode;
  TCrossRefNode = record
    Topic: PString;
    Offset: Integer;
    Length: Byte;
    Next: PCrossRefNode;
  end;

const
  BufferSize = 4096;

type
  PBuffer = ^TBuffer;
  TBuffer = array[0..BufferSize-1] of Byte;

type
  PWarningWindow = ^TWarningWindow;
  TWarningWindow = object(TDialog)
    View:PListBox;
    constructor Init;
    destructor Done;virtual;
  end;

type
  PFixUp = ^TFixUp;
  TFixUp = record
    Pos: LongInt;
    Next: PFixUp;
  end;

  PReference = ^TReference;
  TReference = record
    Topic: PString;
    case Resolved: Boolean of
      True:  (Value: Word);
      False: (FixUpList: PFixUp);
  end;

  PRefTable = ^TRefTable;
  TRefTable = object(TSortedCollection)
    function GetItem(var S: TStream): Pointer; virtual;
    procedure PutItem(var S: TStream; Item: Pointer); virtual;
    function Compare(Key1, Key2: Pointer): Integer; virtual;
    procedure FreeItem(Item: Pointer); virtual;
    function GetReference(var Topic: String): PReference;
    function KeyOf(Item: Pointer): Pointer; virtual;
    function Find(Value:word; var S:string):boolean;
  end;

const
  RefTable: PRefTable = nil;
  WarningWindow:PWarningWindow = nil;

procedure DisposeFixUps(P: PFixUp);
procedure LoadRefFromFile(const FileName:FNameStr);
procedure InitRefTable;
procedure BuildHlpFile;
implementation
uses Ext_Str, Ext_Dos, Global, RsCllt, ResTools, ResStrs, MsgBox,
     Ext_Crt, Views, App, Strings, Dos, Drivers, Ext_Math, Editors;

  { TWarningWindow }
constructor TWarningWindow.Init;
var R:TRect;
begin
  R.Assign(0,16,80,23);
  inherited Init(R,'Warning list');
  Number:=GetWindowNumber;
  Palette:=dpCyanDialog;
  GetExtent(R);
  R.Grow(-1,-1);
  View:=New(PListBox, Init(R, 1, StandardScrollBar(sbVertical)));
  Insert(View);
  View^.NewList(New(PStrings, Init));
end;

destructor TWarningWindow.Done;
begin
  View^.NewList(nil);
  inherited Done;
  WarningWindow:=nil;
end;

type
  TBuiltInContext = record
    Text: PChar;
    Number: Word;
  end;

{ A list of all the help contexts defined in APP }
const
  BuiltInContextTable: array[0..21] of TBuiltInContext = (
    (Text: 'Cascade';   Number: $FF21),
    (Text: 'ChangeDir'; Number: $FF06),
    (Text: 'Clear';     Number: $FF14),
    (Text: 'Close';     Number: $FF27),
    (Text: 'CloseAll';  Number: $FF22),
    (Text: 'Copy';      Number: $FF12),
    (Text: 'Cut';       Number: $FF11),
    (Text: 'DosShell';  Number: $FF07),
    (Text: 'Dragging';  Number: 1),
    (Text: 'Exit';      Number: $FF08),
    (Text: 'New';       Number: $FF01),
    (Text: 'Next';      Number: $FF25),
    (Text: 'Open';      Number: $FF02),
    (Text: 'Paste';     Number: $FF13),
    (Text: 'Prev';      Number: $FF26),
    (Text: 'Resize';    Number: $FF23),
    (Text: 'Save';      Number: $FF03),
    (Text: 'SaveAll';   Number: $FF05),
    (Text: 'SaveAs';    Number: $FF04),
    (Text: 'Tile';      Number: $FF20),
    (Text: 'Undo';      Number: $FF10),
    (Text: 'Zoom';      Number: $FF24)
    );

function IsBuiltInContext(Text: String; var Number: Word): Boolean;
var
  Hi, Lo, Mid, Cmp: Integer;
begin
  { Convert Text into a #0 terminted PChar }
  Inc(Text[0]);
  Text[Length(Text)] := #0;

  Hi := High(BuiltInContextTable);
  Lo := Low(BuiltInContextTable);
  while Lo <= Hi do
  begin
    Mid := (Hi + Lo) div 2;
    Cmp := StrComp(@Text[1], BuiltInContextTable[Mid].Text);
    if Cmp > 0 then
      Lo := Mid + 1
    else if Cmp < 0 then
      Hi := Mid - 1
    else
    begin
      Number := BuiltInContextTable[Mid].Number;
      IsBuiltInContext := True;
      Exit;
    end;
  end;
  IsBuiltInContext := False;
end;

procedure DisposeFixUps(P: PFixUp);
var
  Q: PFixUp;
begin
  while P <> nil do
  begin
    Q := P^.Next;
    Dispose(P);
    P := Q;
  end;
end;

function TRefTable.Compare(Key1, Key2: Pointer): Integer;
var
  K1,K2: String;
begin
  K1 := stUpCase(PString(Key1)^);
  K2 := stUpCase(PString(Key2)^);
  if K1 > K2 then Compare := 1
  else if K1 < K2 then Compare := -1
  else Compare := 0;
end;

procedure TRefTable.FreeItem(Item: Pointer);
var
  Ref: PReference absolute Item;
  P, Q: PFixUp;
begin
  if not Ref^.Resolved then DisposeFixUps(Ref^.FixUpList);
  DisposeStr(Ref^.Topic);
  Dispose(Ref);
end;

function TRefTable.GetReference(var Topic: String): PReference;
var
  Ref: PReference;
  I: Integer;
begin
  if Search(@Topic, I) then
    Ref := At(I)
  else
  begin
    New(Ref);
    Ref^.Topic := NewStr(Topic);
    Ref^.Resolved := False;
    Ref^.FixUpList := nil;
    Insert(Ref);
  end;
  GetReference := Ref;
end;

function TRefTable.KeyOf(Item: Pointer): Pointer;
begin
  KeyOf := PReference(Item)^.Topic;
end;

function TRefTable.GetItem(var S: TStream): Pointer;
var Ref:PReference;
begin
  New(Ref);
  GetItem:=Ref;
  FillChar(Ref^, SizeOf(TReference), 0);
  Ref^.Topic:=S.ReadStr;
  S.Read(Ref^.Resolved, SizeOf(Boolean));
  if Ref^.Resolved then S.Read(Ref^.Value, SizeOf(Word));
end;

procedure TRefTable.PutItem(var S: TStream; Item: Pointer);
var Ref:PReference absolute Item;
begin
  S.WriteStr(Ref^.Topic);
  S.Write(Ref^.Resolved, SizeOf(Boolean));
  if Ref^.Resolved then S.Write(Ref^.Value, SizeOf(Word));
end;

function TRefTable.Find(Value:word; var S:string):boolean;
function DoFind(P:PReference):boolean;far;
begin
  DoFind:=P^.Resolved and (P^.Value=Value);
end;
var PP:PReference;
begin
  PP:=FirstThat(@DoFind);
  if PP<>nil then
  begin
    Find:=true;
    S:=PP^.Topic^;
  end
  else Find:=false;
end;

procedure InitRefTable;
begin
  if RefTable = nil then
    RefTable := New(PRefTable, Init(5,5));
end;

procedure LoadRefFromFile(const FileName:FNameStr);
var S:PStream;
begin
  if FileExists(FileName) then
  begin
    S:=New(PDosStream, Init(FileName,stOpenRead));
    RefTable := New(PRefTable, Load(S^));
    S^.Free;
  end
  else InitRefTable;
end;

type
  PTopicDefinition = ^TTopicDefinition;
  TTopicDefinition = object(TObject)
    Topic: PString;
    Value: Word;
    Next: PTopicDefinition;
    constructor Init(var ATopic: String; AValue: Word);
    destructor Done; virtual;
  end;

constructor TTopicDefinition.Init(var ATopic: String; AValue: Word);
begin
  Topic := NewStr(ATopic);
  Value := AValue;
  Next := nil;
end;

destructor TTopicDefinition.Done;
begin
  DisposeStr(Topic);
  if Next <> nil then Dispose(Next, Done);
end;

procedure DisposeXRefs(P: PCrossRefNode);
var
  Q: PCrossRefNode;
begin
  while P <> nil do
  begin
    Q := P;
    P := P^.Next;
    if Q^.Topic <> nil then DisposeStr(Q^.Topic);
    Dispose(Q);
  end;
end;


procedure ReplaceSpacesWithFF(var Line:String; Start:Integer; Length:Byte);
var I: Integer;
begin
  for I := Start to Start + Length do
    if Line[I] = ' ' then Line[I] := #$FF;
end;

type
  TStatRec = record
    MainFile:PString;
    Statist:PString;
    FreeMemory:Longint;
    LineNumber:Longint;
    TotalLines:Longint;
  end;

var
  XRefs: PCrossRefNode;

procedure RecordReference(var Topic: String; var S: TStream);
var
  I: Integer;
  Ref: PReference;
  FixUp: PFixUp;
begin
  InitRefTable;
  Ref := RefTable^.GetReference(Topic);
  if Ref^.Resolved then
    S.Write(Ref^.Value, SizeOf(Ref^.Value))
  else
  begin
    New(FixUp);
    FixUp^.Pos := S.GetPos;
    I := -1;
    S.Write(I, SizeOf(I));
    FixUp^.Next := Ref^.FixUpList;
    Ref^.FixUpList := FixUp;
  end;
end;

procedure HandleCrossRefs(var S: TStream; XRefValue: Integer); far;
var
  P: PCrossRefNode;
begin
  P := XRefs;
  while XRefValue > 1 do
  begin
    if P <> nil then P := P^.Next;
    Dec(XRefValue);
  end;
  if P <> nil then RecordReference(P^.Topic^, S);
end;

procedure BuildHlpFile;
var HelpFile:PDosStream;
    HelpRez: THelpFile;
    W:PWindow;
    Rec:TStatRec;
    MainFile:string[33];
    Stat:String[43];
    CountRecurs:integer;
    Line: String;
    LineInBuffer: Boolean;
    HasError:boolean;
    HelpCounter: Word;
    Buffer:PBuffer;
    Ofs: Integer;
    FIncludeHelpFile:string;
    HelpName:FNameStr;

procedure Warning(const Text: String; Line:integer);
begin
  if WarningWindow=nil then
      PWindow(WarningWindow):=Application^.InsertWindow(New(PWarningWindow, Init));
  WarningWindow^.View^.List^.Insert(NewStr(Text));
  WarningWindow^.View^.SetRange(WarningWindow^.View^.List^.Count);
  WarningWindow^.ReDraw;
end;

procedure Error(const Text: String);
begin
  if WarningWindow=nil then
      PWindow(WarningWindow):=Application^.InsertWindow(New(PWarningWindow, Init));
  WarningWindow^.View^.List^.AtInsert(0,NewStr(Text));
  WarningWindow^.View^.SetRange(WarningWindow^.View^.List^.Count);
  WarningWindow^.ReDraw;
  HasError:=true;
end;

procedure UnGetLine(S: String);
begin
  Line := S;
  LineInBuffer := True;
end;

function GetLine(var S: TStream): String;
var C, I: Byte;
begin
  if S.Status <> stOk then
  begin
    GetLine := #26;
    Exit;
  end;
  if not LineInBuffer then
  begin
    Line := '';
    C := 0;
    I := 0;
    while (Line[I] <> #13) and (I < 254) and (S.Status = stOk) do
    begin
      Inc(I);
      S.Read(Line[I], 1);
    end;
    Dec(I);
    S.Read(C, 1); { Skip #10 }
    Line[0] := Char(I);
    Inc(Rec.LineNumber);
    inc(Rec.TotalLines);
  end;
  { Return a blank line if the line is a comment }
  if Line[1] = ';' then Line[0] := #0;
  GetLine := Line;
  LineInBuffer := False;
end;

function GetWord(var Line: String; var I: Integer): String;
var
  J: Integer;
const WordChars = ['A'..'Z','a'..'z','0'..'9','_'];
procedure SkipWhite;
begin
  while (I <= Length(Line)) and (Line[I] = ' ') or (Line[I] = #8) do
    Inc(I);
end;
procedure SkipToNonWord;
begin
  while (I <= Length(Line)) and (Line[I] in WordChars) do Inc(I);
end;

begin
  SkipWhite;
  J := I;
  if J > Length(Line) then GetWord := ''
  else
  begin
    Inc(I);
    if Line[J] in WordChars then SkipToNonWord;
    GetWord := Copy(Line, J, I - J);
  end;
end;


procedure DoProcessFile(FileName:FNameStr);

function TopicDefinition(var Line: String; var I: Integer): PTopicDefinition;
var
  J,K: Integer;
  TopicDef: PTopicDefinition;
  Value: Word;
  Topic, W: String;
  HelpNumber: Word;
begin
  Topic := GetWord(Line, I);
  if Topic = '' then
  begin
    Error('Expected topic definition');
    TopicDefinition := nil;
  end
  else
  begin
    J := I;
    W := GetWord(Line, J);
    if W = '=' then
    begin
      I := J;
      W := GetWord(Line, I);
      Val(W, J, K);
      if K <> 0 then Error('Expected numeric')
      else
      begin
        HelpCounter := J;
        HelpNumber := J;
      end
    end
    else
      if not IsBuiltInContext(Topic, HelpNumber) then
      begin
        Inc(HelpCounter);
        HelpNumber := HelpCounter;
      end;
    TopicDefinition := New(PTopicDefinition, Init(Topic, HelpNumber));
  end;
end;

{----- TopicDefinitionList----------------------------------------------}
{  Extracts a list of topic definitions from the given line at I.       }
{-----------------------------------------------------------------------}

function TopicDefinitionList(var Line: String; var I: Integer):
  PTopicDefinition;
var
  J: Integer;
  W: String;
  TopicList, P: PTopicDefinition;
begin
  J := I;
  TopicList := nil;
  repeat
    I := J;
    P := TopicDefinition(Line, I);
    if P = nil then
    begin
      if TopicList <> nil then Dispose(TopicList, Done);
      TopicDefinitionList := nil;
      Exit;
    end;
    P^.Next := TopicList;
    TopicList := P;
    J := I;
    W := GetWord(Line, J);
  until W <> ',';
  TopicDefinitionList := TopicList;
end;

procedure ResolveReference(var Topic: String; Value: Word; var S: TStream);
var
  I: Integer;
  Ref: PReference;

procedure DoFixUps(P: PFixUp);
var
  Pos: LongInt;
begin
  Pos := S.GetPos;
  while P <> nil do
  begin
    S.Seek(P^.Pos);
    S.Write(Value, SizeOf(Value));
    P := P^.Next;
  end;
  S.Seek(Pos);
end;

begin
  InitRefTable;
  Ref := RefTable^.GetReference(Topic);
  if Ref^.Resolved then  Error('Redefinition of ' + Ref^.Topic^)
  else
  begin
    DoFixUps(Ref^.FixUpList);
    DisposeFixUps(Ref^.FixUpList);
    Ref^.Resolved := True;
    Ref^.Value := Value;
  end;
end;

function TopicHeader(var Line: String): PTopicDefinition;
var
  I,J: Integer;
  W: String;
  TopicDef: PTopicDefinition;

begin
  I := 1;
  W := GetWord(Line, I);
  if W <> CommandChar then
  begin
    TopicHeader := nil;
    Exit;
  end;
  W := stUpCase(GetWord(Line, I));
  if W = 'TOPIC' then
    TopicHeader := TopicDefinitionList(Line, I)
  else
  if W = 'USES' then
  begin
     DoProcessFile(ReplaceExt(GetWord(Line, I),'.tvh',true));
     TopicHeader := nil;
  end
  else
  begin
    Error('TOPIC expected');
    TopicHeader := nil;
  end;
end;


function ReadParagraph(var TextFile: TStream; var XRefs: PCrossRefNode;
 var Offset: Integer): PParagraph;
var
  Line: String;
  State: (Undefined, Wrapping, NotWrapping);
  P: PParagraph;

procedure CopyToBuffer(var Line: String; Wrapping: Boolean);
begin
  Move(Line[1],Buffer^[Ofs],Length(Line));
  Ofs:=Ofs+Length(Line);
  if Wrapping then Buffer^[Ofs]:=13 else Buffer^[Ofs]:=byte(' ');
  inc(ofs);
end;

procedure AddToBuffer(var Line: String; Wrapping: Boolean);
begin
  if Length(Line) + Ofs > BufferSize - 1 then
     Error('Topic too large.')
  else
    CopyToBuffer(Line, Wrapping);
end;

procedure ScanForCrossRefs(var Line: String);
var
  I, BegPos, EndPos, Alias: Integer;

procedure AddXRef(XRef: String; Offset: Integer; Length: Byte);
var
  P: PCrossRefNode;
  PP: ^PCrossRefNode;
begin
  New(P);
  P^.Topic := NewStr(XRef);
  P^.Offset := Offset;
  P^.Length := Length;
  P^.Next := nil;
  PP := @XRefs;
  while PP^ <> nil do
    PP := @PP^^.Next;
  PP^ := P;
end;

begin
  I := 1;
  repeat
    BegPos := Pos(BegXRef, Copy(Line, I, 255));
    if BegPos = 0 then I := 0
    else
    begin
      Inc(I, BegPos);
      if Line[I] = BegXRef then
      begin
        Delete(Line, I, 1);
        Inc(I);
      end
      else
      begin
        EndPos := Pos(EndXRef, Copy(Line, I, 255));
        if EndPos = 0 then
        begin
          Error('Unterminated topic reference.');
          Inc(I);
        end
        else
        begin
          Alias := Pos(AliasCh, Copy(Line, I, 255));
          if (Alias = 0) or (Alias > EndPos) then
            AddXRef(Copy(Line, I, EndPos - 1), Offset + Ofs + I - 1, EndPos - 1)
          else
          begin
            AddXRef(Copy(Line, I + Alias, EndPos - Alias - 1),
              Offset + Ofs + I - 1, Alias - 1);
            Delete(Line, I + Alias - 1, EndPos - Alias);
            EndPos := Alias;
          end;
          ReplaceSpacesWithFF(Line, I, EndPos-1);
          Delete(Line, I + EndPos - 1, 1);
          Delete(Line, I - 1, 1);
          Inc(I, EndPos - 2);
        end;
      end;
    end;
  until I = 0;
end;

function IsEndParagraph: Boolean;
begin
  IsEndParagraph :=
     (Line = '') or
     (Line[1] = CommandChar) or
     (Line = #26) or
     ((Line[1] =  ' ') and (State = Wrapping)) or
     ((Line[1] <> ' ') and (State = NotWrapping));
end;

begin
  Ofs := 0;
  ReadParagraph := nil;
  State := Undefined;
  Line := GetLine(TextFile);
  while Line = '' do
  begin
    AddToBuffer(Line, State = Wrapping);
    Line := GetLine(TextFile);
  end;

  if IsEndParagraph then
  begin
    ReadParagraph := nil;
    UnGetLine(Line);
    Exit;
  end;
  while not IsEndParagraph do
  begin
    if State = Undefined then
      if Line[1] = ' ' then State := NotWrapping
      else State := Wrapping;
    ScanForCrossRefs(Line);
    AddToBuffer(Line, State = Wrapping);
    Line := GetLine(TextFile);
  end;
  UnGetLine(Line);
  GetMem(P, SizeOf(P^) + Ofs);
  P^.Size := Ofs;
  P^.Wrap := State = Wrapping;
  Move(Buffer^, P^.Text, Ofs);
  Inc(Offset, Ofs);
  ReadParagraph := P;
end;


procedure ReadTopic(var TextFile: TStream; var HelpFile: THelpFile);
var
  Line: String;
  P: PParagraph;
  Topic: PHelpTopic;
  TopicDef: PTopicDefinition;
  I, J, Offset: Integer;
  Ref: TCrossRef;
  RefNode: PCrossRefNode;

procedure SkipBlankLines(var S: TStream);
var
  Line: String;
begin
  Line := '';
  while Line = '' do
    Line := GetLine(S);
  UnGetLine(Line);
end;

function XRefCount: Integer;
var
  I: Integer;
  P: PCrossRefNode;
begin
  I := 0;
  P := XRefs;
  while P <> nil do
  begin
    Inc(I);
    P := P^.Next;
  end;
  XRefCount := I;
end;

procedure RecordTopicDefinitions(P: PTopicDefinition);
begin
  while P <> nil do
  begin
    ResolveReference(P^.Topic^, P^.Value, HelpFile.Stream^);
    HelpFile.RecordPositionInIndex(P^.Value);
    P := P^.Next;
  end;
end;

begin
  SkipBlankLines(TextFile);
  Line := GetLine(TextFile);
  TopicDef := TopicHeader(Line);
  Topic := New(PHelpTopic, Init);
  { Read paragraphs }
  XRefs := nil;
  Offset := 0;
  P := ReadParagraph(TextFile, XRefs, Offset);
  while P <> nil do
  begin
    Topic^.AddParagraph(P);
    P := ReadParagraph(TextFile, XRefs, Offset);
  end;

  I := XRefCount;
  Topic^.SetNumCrossRefs(I);
  RefNode := XRefs;
  for J := 1 to I do
  begin
    Ref.Offset := RefNode^.Offset;
    Ref.Length := RefNode^.Length;
    Ref.Ref := J;
    Topic^.SetCrossRef(J, Ref);
    RefNode := RefNode^.Next;
  end;

  RecordTopicDefinitions(TopicDef);

  HelpFile.PutTopic(Topic);

  if Topic <> nil then Dispose(Topic, Done);
  if TopicDef <> nil then Dispose(TopicDef, Done);
  DisposeXRefs(XRefs);
  SkipBlankLines(TextFile);
  Rec.FreeMemory:=MemAvail div 1024;
  W^.Redraw;
end;

var
  TextFile:PStream;
  PrevLine:Longint;
  P_:PEditor;
  SFileName:FNameStr;
begin
  if CountRecurs>10 then exit;
  inc(CountRecurs);
  PrevLine:=Rec.LineNumber;
  Rec.LineNumber:=0;
  SFileName:=FileName;
  FileName:=stUpCase(FSearch(ReplaceExt(FileName, '.tvh',true),FIncludeHelpFile));
  Stat:='Compiling: '+FNameReduce(FileName, 32);
  W^.SetData(Rec);
  if FileName='' then P_:=nil
  else
  P_:=Message(Application, evBroadcast, cmFindByName, @FileName);
  if P_<>nil then
  begin
    TextFile:=GetTempStream;
    TextFile^.Write(P_^.Buffer^, P_^.CurPtr);
    TextFile^.Write(P_^.Buffer^[P_^.CurPtr + P_^.GapLen], P_^.BufLen - P_^.CurPtr);
    TextFile^.Seek(0);
  end
  else
    TextFile:=New(PDosStream, Init(FileName, stOpenRead));
  if TextFile^.Status<>stOk then
     Error('Ошибка файла "'+SFileNAme+'"');
  while (TextFile^.Status = stOk) and not HasError do
  begin
    Stat:='Compiling: '+FNameReduce(FileName, 32);
    ReadTopic(TextFile^, HelpRez);
    if CtrlBreakHit then Error('Остановлено пользователем.');
  end;
  TextFile^.Free;
  Rec.LineNumber:=PrevLine;
end;

procedure WriteSymbFile;
var
  I, Count: Integer;
  Dir: DirStr;
  Name: NameStr;
  Ext: ExtStr;
  SymbFile: PDosStream;
procedure DoWriteSymbol(P: PReference); far;
var L: array[0..1] of LongInt;
    Line: String;
    I: Word;
begin
  if (P^.Resolved) then
  begin
    if not IsBuiltInContext(P^.Topic^, I) then
    begin
      L[0] := LongInt(P^.Topic);
      L[1] := P^.Value;
      WriteText(SymbFile^,Format(GetString(542), L));
    end
  end
  else Warning(GetString(543) + P^.Topic^ + '"',0);
end;

var SS:PDosStream;
    St:string;
begin
  SymbFile:=New(PDosStream, Init(ReplaceExt(HelpName,'.PAS',true),stCreate));
  WriteText(SymbFile^, 'unit '+ExtractName(HelpName)+';');
  WriteText(SymbFile^, GetString(540));
  RefTable^.ForEach(@DoWriteSymbol);
  SS:=New(PDosStream, Init(ReplaceExt(HelpName,'.ref',true), stCreate));
  RefTable^.Store(SS^);
  SS^.Free;
  WriteText(SymbFile^, GetString(541));
  SymbFile^.Free;
end;

begin
(*  if ProjectCollection^.HelpFile=nil then
  begin
    RMessageBox(sNotHelpName,nil, mfError+mfOkButton);
    exit;
  end;
  if IncludeHelpFile<>nil then FIncludeHelpFile:=IncludeHelpFile^
  else FIncludeHelpFile:='';
  CtrlBreakHit:=false;
  CrossRefHandler := HandleCrossRefs;
  Line:= '';
  LineInBuffer:= False;
  HasError:=false;
  if WarningWindow<>nil then WarningWindow^.Free;
  HelpCounter:= 2; {1 is hcDragging}
  FillChar(Rec, SizeOf(TStatRec), 0);
  Rec.MainFile:=@MainFile;
  MainFile:=stUpCase(FNameReduce(ReplaceExt(ProjectCollection^.HelpFile^,'.tvh',false), 32));
  Dispose(RefTable, Done);
  RefTable:=nil;
  Rec.Statist:=@Stat;
  W:=Application^.InsertWindow(PWindow(GetView(sCompHelpStatDlg)));
  CountRecurs:=0;
  GetMem(Buffer, BufferSize);
  if ProjectCollection^.GetOutputHelpFileDir='' then
     HelpName:=ReplaceExt(ProjectCollection^.GetHelpFile,'.$$$',true)
  else HelpName:=ProjectCollection^.GetOutputHelpFileDir+ExtractName(ProjectCollection^.GetHelpFile)+'.$$$';
  HelpFile:=New(PDosStream, Init(HelpName,stCreate));
  HelpRez.Init(HelpFile);
  DoProcessFile(ProjectCollection^.HelpFile^);
  HelpRez.Done;
  WriteSymbFile;
  FreeMem(Buffer, BufferSize);
  Stat:='Done.';
  W^.SetData(Rec);
  if HasError then
     DeleteFile(ReplaceExt(ProjectCollection^.GetHelpFile,'.$$$',true))
  else
  RenameFile(HelpName,ReplaceExt(HelpName,'.hlp',true));
  if (not HasError) and (WarningWindow=nil) then WaitPress;
  CrossRefHandler:=nil;
  W^.Free;
  if GeneratorOptions.AutoOpen and $02=0 then
  begin
    Dispose(RefTable, Done);
    RefTable:=nil;
  end*)
end;

end.
