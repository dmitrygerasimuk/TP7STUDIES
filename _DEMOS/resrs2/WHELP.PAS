{$O+}
{$I DEFINE.inc}
unit WHelp;
interface
uses Objects;
const
      MinFormatVersion  = $34;

      Signature      = '$*$* &&&&$*$'#0;
      ncRawChar      = $F;
      ncRepChar      = $E;

      rtFileHeader   = Byte ($0);
      rtContext      = Byte ($1);
      rtText         = Byte ($2);
      rtKeyWord      = Byte ($3);
      rtIndex        = Byte ($4);
      rtCompression  = Byte ($5);
      rtIndexTags    = Byte ($6);

      ctNone         = $00;
      ctNibble       = $02;

      hscLineBreak   = #0;
      hscLink        = #2;
      hscLineStart   = #3;
      hscCode        = #5;
      hscCenter      = #10;
      hscRight       = #11;

type
      FileStamp      = array [0..32] of char; {+ null terminator + $1A }
      FileSignature  = array [0..12] of char; {+ null terminator }

      THelpCtx = longint;

      THLPVersion = packed record
        FormatVersion : byte;
        TextVersion   : byte;
      end;

      THLPRecordHeader = packed record
        RecType       : byte; {TPRecType}
        RecLength     : word;
      end;

      THLPContextPos = packed record
        LoW: word;
        HiB: byte;
      end;

      THLPContexts = packed record
        ContextCount : word;
        Contexts     : array[0..0] of THLPContextPos;
      end;

      THLPFileHeader = packed record
        Options         : word;
        MainIndexScreen : word;
        MaxScreenSize   : word;
        Height          : byte;
        Width           : byte;
        LeftMargin      : byte;
      end;

      THLPCompression = packed record
        CompType      : byte;
        CharTable     : array [0..13] of byte;
      end;

      THLPIndexDescriptor = packed record
        LengthCode    : byte;
        UniqueChars   : array [0..0] of byte;
        Context       : word;
      end;

      THLPIndexTable = packed record
        IndexCount    : word;
        Entries       : record end;
      end;

      THLPKeywordDescriptor = packed record
        KwContext     : word;
      end;

      THLPKeyWordRecord = packed record
        UpContext     : word;
        DownContext   : word;
        KeyWordCount  : word;
        Keywords      : array[0..0] of THLPKeywordDescriptor;
      end;

      TRecord = packed record
        SClass   : byte;
        Size     : word;
        Data     : pointer;
      end;

      PIndexEntry = ^TIndexEntry;
      TIndexEntry = packed record
        Tag        : PString;
        HelpCtx    : THelpCtx;
        FileID     : word;
      end;

      PKeywordDescriptor = ^TKeywordDescriptor;
      TKeywordDescriptor = packed record
        FileID     : word;
        Context    : THelpCtx;
      end;

      PKeywordDescriptors = ^TKeywordDescriptors;
      TKeywordDescriptors = array[0..10900] of TKeywordDescriptor;

      PTopic = ^TTopic;
      TTopic = object
        HelpCtx       : THelpCtx;
        FileOfs       : longint;
        TextSize      : word;
        Text          : PByteArray;
        LinkCount     : word;
        Links         : PKeywordDescriptors;
        LastAccess    : longint;
        FileID        : word;
        Param         : PString;
        function LinkSize: word;
      end;

      PTopicCollection = ^TTopicCollection;
      TTopicCollection = object(TSortedCollection)
        function   At(Index: Integer): PTopic;
        procedure  FreeItem(Item: Pointer); virtual;
        function   Compare(Key1, Key2: Pointer): Integer; virtual;
        function   SearchTopic(AHelpCtx: THelpCtx): PTopic;
      end;

      PIndexEntryCollection = ^TIndexEntryCollection;
      TIndexEntryCollection = object(TSortedCollection)
        function   At(Index: Integer): PIndexEntry;
        procedure  FreeItem(Item: Pointer); virtual;
        function   Compare(Key1, Key2: Pointer): Integer; virtual;
      end;

      PHelpFile = ^THelpFile;
      THelpFile = object(TObject)
        ID           : word;
        Topics       : PTopicCollection;
        IndexEntries : PIndexEntryCollection;
        constructor Init(AID: word);
        function    LoadTopic(HelpCtx: THelpCtx): PTopic; virtual;
        destructor  Done; virtual;
      public
        function    LoadIndex: boolean; virtual;
        function    SearchTopic(HelpCtx: THelpCtx): PTopic; virtual;
        function    ReadTopic(T: PTopic): boolean; virtual;
      private
        procedure MaintainTopicCache;
      end;

      POAHelpFile = ^TOAHelpFile;
      TOAHelpFile = object(THelpFile)
        Version      : THLPVersion;
        Header       : THLPFileHeader;
        Compression  : THLPCompression;
        constructor Init(AFileName: string; AID: word);
        destructor  Done; virtual;
      public
        function    LoadIndex: boolean; virtual;
        function    ReadTopic(T: PTopic): boolean; virtual;
      public { protected }
        F: PStream;
        TopicsRead     : boolean;
        IndexTableRead : boolean;
        CompressionRead: boolean;
        IndexTagsRead  : boolean;
        IndexTagsPos   : longint;
        IndexTablePos  : longint;
        function  ReadHeader: boolean;
        function  ReadTopics: boolean;
        function  ReadIndexTable: boolean;
        function  ReadCompression: boolean;
        function  ReadIndexTags: boolean;
        function  ReadRecord(var R: TRecord; ReadData: boolean): boolean;
      end;

      PHelpFileCollection = PCollection;

      PHelpFacility = ^THelpFacility;
      THelpFacility = object(TObject)
        HelpFiles: PHelpFileCollection;
        IndexTabSize: Integer;
        constructor Init;
        function    AddOAHelpFile(FileName: string): boolean;
        function    AddHTMLHelpFile(FileName, TOCEntry: string): boolean;
        function    LoadTopic(SourceFileID: word; Context: THelpCtx): PTopic; virtual;
        function    TopicSearch(Keyword: string; var FileID: word; var Context: THelpCtx): boolean; virtual;
        function    BuildIndexTopic: PTopic; virtual;
        destructor  Done; virtual;
      private
        LastID: word;
        function  SearchFile(ID: byte): PHelpFile;
        function  SearchTopicInHelpFile(F: PHelpFile; Context: THelpCtx): PTopic;
        function  SearchTopicOwner(SourceFileID: word; Context: THelpCtx): PHelpFile;
        function  AddFile(H: PHelpFile): boolean;
      end;

const TopicCacheSize    : Integer = 10;
      HelpStreamBufSize : Integer = 4096;
      HelpFacility      : PHelpFacility = nil;
      MaxHelpTopicSize  : word = 65520;

function  NewTopic(FileID: byte; HelpCtx: THelpCtx; Pos: longint; Param: string): PTopic;
procedure DisposeTopic(P: PTopic);

function  NewIndexEntry(Tag: string; FileID: word; HelpCtx: THelpCtx): PIndexEntry;
procedure DisposeIndexEntry(P: PIndexEntry);

implementation
uses Dos, Ext_Str, Clases;

{function RExpand(const S: string; MinLen: byte): string;
begin
  if length(S)<MinLen then
    RExpand:=S+DupChar(' ',MinLen-length(S))
  else
    RExpand:=S;
end;}

Function GetDosTicks:longint; { returns ticks at 18.2 Hz, just like DOS }
{$IFDEF LINUX}
  var
    tv : TimeVal;
    tz : TimeZone;
  begin
    GetTimeOfDay(tv,tz);
    GetDosTicks:=((tv.Sec mod 86400) div 60)*1092+((tv.Sec mod 60)*1000000+tv.USec) div 54945;
  end;
{$endif Linux}
{$ifdef Win32}
  begin
    //GetDosTicks:=(Windows.GetTickCount*5484) div 100;
  end;
{$endif Win32}
{$ifdef go32v2}
  begin
    GetDosTicks:=MemL[$40:$6c];
  end;
{$endif go32v2}
{  begin
    //GetDosTicks:=MemL[$40:$6c];
  end;}

procedure DisposeRecord(var R: TRecord);
begin
  with R do
  if (Size>0) and (Data<>nil) then FreeMem(Data, Size);
  FillChar(R, SizeOf(R), 0);
end;

function NewTopic(FileID: byte; HelpCtx: THelpCtx; Pos: longint; Param: string): PTopic;
var P: PTopic;
begin
  New(P); FillChar(P^,SizeOf(P^), 0);
  P^.HelpCtx:=HelpCtx; P^.FileOfs:=Pos; P^.FileID:=FileID;
  P^.Param:=NewStr(Param);
  NewTopic:=P;
end;

procedure DisposeTopic(P: PTopic);
begin
  if P<>nil then
  begin
    if (P^.TextSize>0) and (P^.Text<>nil) then
       FreeMem(P^.Text,P^.TextSize);
    P^.Text:=nil;
    if (P^.LinkCount>0) and (P^.Links<>nil) then
       FreeMem(P^.Links,P^.LinkSize);
    P^.Links:=nil;
    if P^.Param<>nil then DisposeStr(P^.Param); P^.Param:=nil;
    Dispose(P);
  end;
end;

function CloneTopic(T: PTopic): PTopic;
var NT: PTopic;
begin
  New(NT); Move(T^,NT^,SizeOf(NT^));
  if NT^.Text<>nil then
     begin GetMem(NT^.Text,NT^.TextSize); Move(T^.Text^,NT^.Text^,NT^.TextSize); end;
  if NT^.Links<>nil then
     begin GetMem(NT^.Links,NT^.LinkSize); Move(T^.Links^,NT^.Links^,NT^.LinkSize); end;
  if NT^.Param<>nil then
     NT^.Param:=NewStr(T^.Param^);
  CloneTopic:=NT;
end;

function NewIndexEntry(Tag: string; FileID: word; HelpCtx: THelpCtx): PIndexEntry;
var P: PIndexEntry;
begin
  New(P); FillChar(P^,SizeOf(P^), 0);
  P^.Tag:=NewStr(Tag); P^.FileID:=FileID; P^.HelpCtx:=HelpCtx;
  NewIndexEntry:=P;
end;

procedure DisposeIndexEntry(P: PIndexEntry);
begin
  if P<>nil then
  begin
    if P^.Tag<>nil then DisposeStr(P^.Tag);
    Dispose(P);
  end;
end;

function TTopic.LinkSize: word;
begin
  LinkSize:=LinkCount*SizeOf(Links^[0]);
end;

function TTopicCollection.At(Index: Integer): PTopic;
begin
  At:=inherited At(Index);
end;

procedure TTopicCollection.FreeItem(Item: Pointer);
begin
  if Item<>nil then DisposeTopic(Item);
end;

function TTopicCollection.Compare(Key1, Key2: Pointer): Integer;
var K1: PTopic absolute Key1;
    K2: PTopic absolute Key2;
    R: Integer;
begin
  if K1^.HelpCtx<K2^.HelpCtx then R:=-1 else
  if K1^.HelpCtx>K2^.HelpCtx then R:= 1 else
  R:=0;
  Compare:=R;
end;

function TTopicCollection.SearchTopic(AHelpCtx: THelpCtx): PTopic;
var T: TTopic;
    P: PTopic;
    Index: Integer;
begin
  T.HelpCtx:=AHelpCtx;
  if Search(@T,Index) then
    P:=At(Index)
  else
    P:=nil;
  SearchTopic:=P;
end;

function TIndexEntryCollection.At(Index: Integer): PIndexEntry;
begin
  At:=inherited At(Index);
end;

procedure TIndexEntryCollection.FreeItem(Item: Pointer);
begin
  if Item<>nil then DisposeIndexEntry(Item);
end;

function TIndexEntryCollection.Compare(Key1, Key2: Pointer): Integer;
var K1: PIndexEntry absolute Key1;
    K2: PIndexEntry absolute Key2;
    R: Integer;
    S1,S2: string;
begin
  S1:=stUpCase(K1^.Tag^); S2:=stUpCase(K2^.Tag^);
  if S1<S2 then R:=-1 else
  if S1>S2 then R:=1 else
  R:=0;
  Compare:=R;
end;

constructor THelpFile.Init(AID: word);
begin
  inherited Init;
  ID:=AID;
  New(Topics, Init(500,500));
  New(IndexEntries, Init(200,100));
end;

function THelpFile.LoadTopic(HelpCtx: THelpCtx): PTopic;
var T: PTopic;
begin
  T:=SearchTopic(HelpCtx);
  if (T<>nil) then
     if T^.Text=nil then
     begin
       MaintainTopicCache;
       if ReadTopic(T)=false then T:=nil;
       if (T<>nil) and (T^.Text=nil) then T:=nil;
     end;
  if T<>nil then
     begin T^.LastAccess:=GetDosTicks; T:=CloneTopic(T); end;
  LoadTopic:=T;
end;

function THelpFile.LoadIndex: boolean;
begin
  Abstract;
  LoadIndex:=false; { remove warning }
end;

function THelpFile.SearchTopic(HelpCtx: THelpCtx): PTopic;
var T: PTopic;
begin
  T:=Topics^.SearchTopic(HelpCtx);
  SearchTopic:=T;
end;

function THelpFile.ReadTopic(T: PTopic): boolean;
begin
  Abstract;
  ReadTopic:=false; { remove warning }
end;

procedure THelpFile.MaintainTopicCache;
var Count: Integer;
    MinP: PTopic;
    MinLRU: longint;
procedure CountThem(P: PTopic); {$ifndef FPC}far;{$endif}
begin if (P^.Text<>nil) or (P^.Links<>nil) then Inc(Count); end;
procedure SearchLRU(P: PTopic); {$ifndef FPC}far;{$endif}
begin if P^.LastAccess<MinLRU then begin MinLRU:=P^.LastAccess; MinP:=P; end; end;
var P: PTopic;
begin
  Count:=0; Topics^.ForEach(@CountThem);
  if (Count>=TopicCacheSize) then
  begin
    MinLRU:=MaxLongint; P:=nil; Topics^.ForEach(@SearchLRU);
    if P<>nil then
    begin
      FreeMem(P^.Text,P^.TextSize); P^.TextSize:=0; P^.Text:=nil;
      FreeMem(P^.Links,P^.LinkSize); P^.LinkCount:=0; P^.Links:=nil;
    end;
  end;
end;

destructor THelpFile.Done;
begin
  if Topics<>nil then Dispose(Topics, Done);
  if IndexEntries<>nil then Dispose(IndexEntries, Done);
  inherited Done;
end;

constructor TOAHelpFile.Init(AFileName: string; AID: word);
var OK: boolean;
    FS,L: longint;
    R: TRecord;
begin
  inherited Init(AID);
  F:=New(PBufStream, Init(AFileName, stOpenRead, HelpStreamBufSize));
  OK:=F<>nil;
  if OK then OK:=(F^.Status=stOK);
  if OK then
    begin
      FS:=F^.GetSize;
      OK:=ReadHeader;
    end;
  while OK do
  begin
    L:=F^.GetPos;
    if (L>=FS) then Break;
    OK:=ReadRecord(R,false);
    if (OK=false) or (R.SClass=0) or (R.Size=0) then Break;
    case R.SClass of
      rtContext     : begin F^.Seek(L); OK:=ReadTopics; end;
      rtText        : {Skip};
      rtKeyword     : {Skip};
      rtIndex       : begin IndexTablePos:=L; {OK:=ReadIndexTable; }end;
      rtCompression : begin F^.Seek(L); OK:=ReadCompression; end;
      rtIndexTags   : begin IndexTagsPos:=L; {OK:=ReadIndexTags; }end;
    else {Skip};
    end;
    if OK then
       begin Inc(L, SizeOf(THLPRecordHeader)); Inc(L, R.Size); F^.Seek(L); OK:=(F^.Status=stOK); end
  end;
  OK:=OK and (TopicsRead=true);
  if OK=false then Fail;
end;

function TOAHelpFile.LoadIndex: boolean;
begin
  LoadIndex:=ReadIndexTable;
end;

function TOAHelpFile.ReadHeader: boolean;
var S: string;
    P: longint;
    R: TRecord;
    OK: boolean;
begin
  F^.Seek(0);
  F^.Read(S[1],128); S[0]:=#255;
  OK:=(F^.Status=stOK); P:=Pos(Signature,S);
  OK:=OK and (P>0);
  if OK then
  begin
    F^.Seek(P+length(Signature)-1);
    F^.Read(Version,SizeOf(Version));
    OK:=(F^.Status=stOK) and (Version.FormatVersion>=MinFormatVersion);
    if OK then OK:=ReadRecord(R,true);
    OK:=OK and (R.SClass=rtFileHeader) and (R.Size=SizeOf(Header));
    if OK then Move(R.Data^,Header,SizeOf(Header));
    DisposeRecord(R);
  end;
  ReadHeader:=OK;
end;

function TOAHelpFile.ReadTopics: boolean;
var OK: boolean;
    R: TRecord;
    L,I: longint;
function GetCtxPos(C: THLPContextPos): longint;
begin
  GetCtxPos:=longint(C.HiB) shl 16 + C.LoW;
end;
begin
  OK:=ReadRecord(R, true);
  if OK then
  with THLPContexts(R.Data^) do
  for I:=1 to longint(ContextCount)-1 do
  begin
    if Topics^.Count=MaxCollectionSize then Break;
    L:=GetCtxPos(Contexts[I]);
    if (L and $800000)<>0 then L:=not L;
    if (L=-1) and (Header.MainIndexScreen>0) then
       L:=GetCtxPos(Contexts[Header.MainIndexScreen]);
    if (L>0) then
      Topics^.Insert(NewTopic(ID,I,L,''));
  end;
  DisposeRecord(R);
  TopicsRead:=OK;
  ReadTopics:=OK;
end;

function TOAHelpFile.ReadIndexTable: boolean;
var OK: boolean;
    R: TRecord;
    I: longint;
    LastTag,S: string;
    CurPtr,HelpCtx: word;
    LenCode,CopyCnt,AddLen: byte;
begin
  if IndexTableRead then OK:=true else
 begin
  LastTag:=''; CurPtr:=0;
  OK:=(IndexTablePos<>0);
  if OK then begin F^.Seek(IndexTablePos); OK:=F^.Status=stOK; end;
  if OK then OK:=ReadRecord(R, true);
  if OK then
  with THLPIndexTable(R.Data^) do
  for I:=0 to IndexCount-1 do
  begin
    LenCode:=PByteArray(@Entries)^[CurPtr];
    AddLen:=LenCode and $1f; CopyCnt:=LenCode shr 5;
    S[0]:=chr(AddLen); Move(PByteArray(@Entries)^[CurPtr+1],S[1],AddLen);
    LastTag:=copy(LastTag,1,CopyCnt)+S;
    Move(PByteArray(@Entries)^[CurPtr+1+AddLen],HelpCtx,2);
    IndexEntries^.Insert(NewIndexEntry(LastTag,ID,HelpCtx));
    Inc(CurPtr,1+AddLen+2);
  end;
  DisposeRecord(R);
  IndexTableRead:=OK;
 end;
  ReadIndexTable:=OK;
end;

function TOAHelpFile.ReadCompression: boolean;
var OK: boolean;
    R: TRecord;
begin
  OK:=ReadRecord(R, true);
  OK:=OK and (R.Size=SizeOf(THLPCompression));
  if OK then Move(R.Data^,Compression,SizeOf(Compression));
  DisposeRecord(R);
  CompressionRead:=OK;
  ReadCompression:=OK;
end;

function TOAHelpFile.ReadIndexTags: boolean;
var OK: boolean;
begin
  OK:={ReadRecord(R, true)}true;
  IndexTagsRead:=OK;
  ReadIndexTags:=OK;
end;

function TOAHelpFile.ReadRecord(var R: TRecord; ReadData: boolean): boolean;
var OK: boolean;
    H: THLPRecordHeader;
begin
  FillChar(R, SizeOf(R), 0);
  F^.Read(H,SizeOf(H));
  OK:=F^.Status=stOK;
  if OK then
  begin
    R.SClass:=H.RecType; R.Size:=H.RecLength;
    if (R.Size>0) and ReadData then
    begin
      GetMem(R.Data,R.Size);
      F^.Read(R.Data^,R.Size);
      OK:=F^.Status=stOK;
    end;
    if OK=false then DisposeRecord(R);
  end;
  ReadRecord:=OK;
end;

function TOAHelpFile.ReadTopic(T: PTopic): boolean;
var SrcPtr,DestPtr: word;
    NewR: TRecord;
function ExtractTextRec(var R: TRecord): boolean;
function GetNextNibble: byte;
var B,N: byte;
begin
  B:=PByteArray(R.Data)^[SrcPtr div 2];
  N:=( B and ($0f shl (4*(SrcPtr mod 2))) ) shr (4*(SrcPtr mod 2));
  Inc(SrcPtr);
  GetNextNibble:=N;
end;
procedure AddChar(C: char);
begin
  PByteArray(NewR.Data)^[DestPtr]:=ord(C);
  Inc(DestPtr);
end;
var OK: boolean;
    C: char;
    P: pointer;
function GetNextChar: char;
var C: char;
    I,N,Cnt: byte;
begin
  N:=GetNextNibble;
  case N of
    $00       : C:=#0;
    $01..$0D  : C:=chr(Compression.CharTable[N]);
    ncRawChar : begin
                  I:=GetNextNibble;
                  C:=chr(I+GetNextNibble shl 4);
                end;
    ncRepChar : begin
                  Cnt:=2+GetNextNibble;
                  C:=GetNextChar{$ifdef FPC}(){$endif};
                  for I:=1 to Cnt-1 do AddChar(C);
                end;
  end;
  GetNextChar:=C;
end;
begin
  OK:=Compression.CompType in[ctNone,ctNibble];
  if OK then
  case Compression.CompType of
       ctNone   : ;
       ctNibble :
         begin
           NewR.SClass:=R.SClass;
           NewR.Size:=MaxHelpTopicSize; { R.Size*2 <- bug fixed, i didn't care of RLL codings }
           GetMem(NewR.Data, NewR.Size);
           SrcPtr:=0; DestPtr:=0;
           while SrcPtr<(R.Size*2) do
           begin
             C:=GetNextChar;
             AddChar(C);
           end;
           DisposeRecord(R); R:=NewR;
           if (R.Size>DestPtr) then
           begin
             P:=R.Data; GetMem(R.Data,DestPtr);
             Move(P^,R.Data^,DestPtr); FreeMem(P,R.Size); R.Size:=DestPtr;
           end;
         end;
  else OK:=false;
  end;
  ExtractTextRec:=OK;
end;
var OK: boolean;
    TextR,KeyWR: TRecord;
    I: word;
begin
  OK:=T<>nil;
  if OK and (T^.Text=nil) then
  begin
    FillChar(TextR,SizeOf(TextR),0); FillChar(KeyWR,SizeOf(KeyWR),0);
    F^.Seek(T^.FileOfs); OK:=F^.Status=stOK;
    if OK then OK:=ReadRecord(TextR,true);
    OK:=OK and (TextR.SClass=rtText);
    if OK then OK:=ReadRecord(KeyWR,true);
    OK:=OK and (KeyWR.SClass=rtKeyword);

    if OK then OK:=ExtractTextRec(TextR);
    if OK then
    begin
      if TextR.Size>0 then
      begin
        T^.Text:=TextR.Data; T^.TextSize:=TextR.Size;
        TextR.Data:=nil; TextR.Size:=0;
      end;
      with THLPKeywordRecord(KeyWR.Data^) do
      begin
        T^.LinkCount:=KeywordCount;
        GetMem(T^.Links,T^.LinkSize);
        if KeywordCount>0 then
        for I:=0 to KeywordCount-1 do
        begin
          T^.Links^[I].Context:=Keywords[I].KwContext;
          T^.Links^[I].FileID:=ID;
        end;
      end;
    end;

    DisposeRecord(TextR); DisposeRecord(KeyWR);
  end;
  ReadTopic:=OK;
end;

destructor TOAHelpFile.Done;
begin
  if F<>nil then Dispose(F, Done);
  inherited Done;
end;

constructor THelpFacility.Init;
begin
  inherited Init;
  New(HelpFiles, Init(10,10));
  IndexTabSize:=40;
end;


function THelpFacility.AddOAHelpFile(FileName: string): boolean;
var H: PHelpFile;
begin
  H:=New(POAHelpFile, Init(FileName, LastID+1));
  AddOAHelpFile:=AddFile(H);
end;

function THelpFacility.AddHTMLHelpFile(FileName, TOCEntry: string): boolean;
var H: PHelpFile;
begin
{  H:=New(PHTMLHelpFile, Init(FileName, LastID+1, TOCEntry));
  AddHTMLHelpFile:=AddFile(H);;}
end;

function THelpFacility.AddFile(H: PHelpFile): boolean;
begin
  if H<>nil then
    begin
      HelpFiles^.Insert(H);
      Inc(LastID);
    end;
  AddFile:=H<>nil;
end;

function THelpFacility.SearchTopicOwner(SourceFileID: word; Context: THelpCtx): PHelpFile;
var P: PTopic;
    HelpFile: PHelpFile;
function Search(F: PHelpFile): boolean; {$ifndef FPC}far;{$endif}
begin
  P:=SearchTopicInHelpFile(F,Context); if P<>nil then HelpFile:=F;
  Search:=P<>nil;
end;
begin
  HelpFile:=nil;
  if SourceFileID=0 then P:=nil else
     begin
       HelpFile:=SearchFile(SourceFileID);
       P:=SearchTopicInHelpFile(HelpFile,Context);
     end;
  if P=nil then HelpFiles^.FirstThat(@Search);
  if P=nil then HelpFile:=nil;
  SearchTopicOwner:=HelpFile;
end;

function THelpFacility.LoadTopic(SourceFileID: word; Context: THelpCtx): PTopic;
var P: PTopic;
    H: PHelpFile;
begin
  if (SourceFileID=0) and (Context=0) then
     P:=BuildIndexTopic else
  begin
    H:=SearchTopicOwner(SourceFileID,Context);
    if (H=nil) then P:=nil else
       P:=H^.LoadTopic(Context);
  end;
  LoadTopic:=P;
end;

function THelpFacility.TopicSearch(Keyword: string; var FileID: word; var Context: THelpCtx): boolean;
function ScanHelpFile(H: PHelpFile): boolean; {$ifndef FPC}far;{$endif}
function Search(P: PIndexEntry): boolean; {$ifndef FPC}far;{$endif}
begin
  Search:=copy(stUpCase(P^.Tag^),1,length(Keyword))=Keyword;
end;
var P: PIndexEntry;
begin
  H^.LoadIndex;
  P:=H^.IndexEntries^.FirstThat(@Search);
  if P<>nil then begin FileID:=H^.ID; Context:=P^.HelpCtx; end;
  ScanHelpFile:=P<>nil;
end;
begin
  Keyword:=stUpCase(Keyword);
  TopicSearch:=HelpFiles^.FirstThat(@ScanHelpFile)<>nil;
end;

function THelpFacility.BuildIndexTopic: PTopic;
var T: PTopic;
    Keywords: PIndexEntryCollection;
    Lines: PStrings;
procedure InsertKeywordsOfFile(H: PHelpFile); {$ifndef FPC}far;{$endif}
function InsertKeywords(P: PIndexEntry): boolean; {$ifndef FPC}far;{$endif}
begin
  Keywords^.Insert(P);
  InsertKeywords:=Keywords^.Count>=MaxCollectionSize;
end;
begin
  H^.LoadIndex;
  if Keywords^.Count<MaxCollectionSize then
  H^.IndexEntries^.FirstThat(@InsertKeywords);
end;
procedure AddLine(S: string);
begin
  if S='' then S:=' ';
  Lines^.Insert(NewStr(S));
end;
procedure RenderTopic;
var Size,CurPtr,I: word;
    S: string;
function CountSize(P: PString): boolean; {$ifndef FPC}far;{$endif} begin Inc(Size, length(P^)+1); CountSize:=Size>65200; end;
begin
  Size:=0; Lines^.FirstThat(@CountSize);
  T^.TextSize:=Size; GetMem(T^.Text,T^.TextSize);
  CurPtr:=0;
  for I:=0 to Lines^.Count-1 do
  begin
    S:=Lines^.Str(I);
    Size:=length(S)+1; S[Size]:=hscLineBreak;
    Move(S[1],PByteArray(T^.Text)^[CurPtr],Size);
    Inc(CurPtr,Size);
    if CurPtr>=T^.TextSize then Break;
  end;
end;
var Line: string;
procedure FlushLine;
begin
  if Line<>'' then AddLine(Line); Line:='';
end;
var KWCount,NLFlag: Integer;
    LastFirstChar: char;
procedure NewSection(FirstChar: char);
begin
  if FirstChar<=#64 then FirstChar:=#32;
  FlushLine;
  AddLine('');
  AddLine(FirstChar);
  AddLine('');
  LastFirstChar:=FirstChar;
  NLFlag:=0;
end;
procedure AddKeyword(KWS: string);
begin
  Inc(KWCount); if KWCount=1 then NLFlag:=0;
  if (KWCount=1) or
     ( (Upcase(KWS[1])<>LastFirstChar) and ( (LastFirstChar>#64) or (KWS[1]>#64) ) ) then
     NewSection(Upcase(KWS[1]));
  if (NLFlag mod 2)=0
     then Line:=' '+#2+KWS+#2
     else begin
            Line:=FillSpaceA(Line,IndexTabSize)+#2+KWS+#2;
            FlushLine;
          end;
  Inc(NLFlag);
end;
var KW: PIndexEntry;
    I: Integer;
begin
  New(Keywords, Init(5000,1000));
  HelpFiles^.ForEach(@InsertKeywordsOfFile);
  New(Lines, Init);
  T:=NewTopic(0,0,0,'');
  if HelpFiles^.Count=0 then
    begin
      AddLine('');
      AddLine(' No help files installed.')
    end else
  begin
    AddLine(' Help index');
    KWCount:=0; Line:='';
    T^.LinkCount:=Keywords^.Count;
    GetMem(T^.Links,T^.LinkSize);

    for I:=0 to Keywords^.Count-1 do
    begin
      KW:=Keywords^.At(I);
      AddKeyword(KW^.Tag^);
      T^.Links^[I].Context:=KW^.HelpCtx; T^.Links^[I].FileID:=KW^.FileID;
    end;
    FlushLine;
    AddLine('');
  end;
  RenderTopic;
  Dispose(Lines, Done);
  Keywords^.DeleteAll; Dispose(Keywords, Done);
  BuildIndexTopic:=T;
end;

function THelpFacility.SearchFile(ID: byte): PHelpFile;
function Match(P: PHelpFile): boolean; {$ifndef FPC}far;{$endif}
begin
  Match:=(P^.ID=ID);
end;
begin
  SearchFile:=HelpFiles^.FirstThat(@Match);
end;

function THelpFacility.SearchTopicInHelpFile(F: PHelpFile; Context: THelpCtx): PTopic;
var P: PTopic;
begin
  if F=nil then P:=nil else
  P:=F^.SearchTopic(Context);
  SearchTopicInHelpFile:=P;
end;

destructor THelpFacility.Done;
begin
  inherited Done;
  Dispose(HelpFiles, Done);
end;

END.
{
  $Log: whelp.pas,v $
  Revision 1.14  1999/07/18 16:26:42  florian
    * IDE compiles with for Win32 and basic things are working

  Revision 1.13  1999/04/13 10:47:51  daniel
  * Fixed for Linux

  Revision 1.12  1999/04/07 21:56:00  peter
    + object support for browser
    * html help fixes
    * more desktop saving things
    * NODEBUG directive to exclude debugger

  Revision 1.11  1999/03/16 12:38:16  peter
    * tools macro fixes
    + tph writer
    + first things for resource files

  Revision 1.10  1999/03/08 14:58:19  peter
    + prompt with dialogs for tools

  Revision 1.9  1999/03/03 16:44:05  pierre
   * TPH reader fix from Peter

  Revision 1.8  1999/03/01 15:42:11  peter
    + Added dummy entries for functions not yet implemented
    * MenuBar didn't update itself automatically on command-set changes
    * Fixed Debugging/Profiling options dialog
    * TCodeEditor converts spaces to tabs at save only if efUseTabChars is
 set
    * efBackSpaceUnindents works correctly
    + 'Messages' window implemented
    + Added '$CAP MSG()' and '$CAP EDIT' to available tool-macros
    + Added TP message-filter support (for ex. you can call GREP thru
      GREP2MSG and view the result in the messages window - just like in TP)
    * A 'var' was missing from the param-list of THelpFacility.TopicSearch,
      so topic search didn't work...
    * In FPHELP.PAS there were still context-variables defined as word instead
      of THelpCtx
    * StdStatusKeys() was missing from the statusdef for help windows
    + Topic-title for index-table can be specified when adding a HTML-files

  Revision 1.6  1999/02/20 15:18:35  peter
    + ctrl-c capture with confirm dialog
    + ascii table in the tools menu
    + heapviewer
    * empty file fixed
    * fixed callback routines in fpdebug to have far for tp7

  Revision 1.5  1999/02/19 15:43:22  peter
    * compatibility fixes for FV

  Revision 1.4  1999/02/18 13:44:37  peter
    * search fixed
    + backward search
    * help fixes
    * browser updates

  Revision 1.3  1999/02/08 10:37:46  peter
    + html helpviewer

  Revision 1.2  1998/12/28 15:47:56  peter
    + Added user screen support, display & window
    + Implemented Editor,Mouse Options dialog
    + Added location of .INI and .CFG file
    + Option (INI) file managment implemented (see bottom of Options Menu)
    + Switches updated
    + Run program

  Revision 1.4  1998/12/22 10:39:55  peter
    + options are now written/read
    + find and replace routines

}
