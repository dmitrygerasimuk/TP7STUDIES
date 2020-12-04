{$O+}
{$I Define.inc}
unit Ext_Hlp;

interface

uses Objects,Drivers,Views, WHelp, Clases, Ext_Clp, Register;

const
  CHelpColor      = #$37#$3F#$3A#$13#$13#$30#$3E#$1E;
  CHelpBlackWhite = #$07#$0F#$07#$70#$70#$07#$0F#$70;
  CHelpMonochrome = #$07#$0F#$07#$70#$70#$07#$0F#$70;
  CHelpViewer     = #6#7#8#9;

const
     MaxLineLength = 255;
     cmPrevTopic         = 90;
     HistorySize         = 30;
     ToClipCmds          = [cmCut,cmCopy];
     NulClipCmds         = [cmClear];

     cmHelpFilesChanged  = 57340;

type
      PHelpLink = ^THelpLink;
      THelpLink = record
        Bounds   : TRect;
        FileID   : longint;
        Context  : THelpCtx;
      end;

      PHelpColorArea = ^THelpColorArea;
      THelpColorArea = record
        Color    : byte;
        Bounds   : TRect;
      end;

      PHelpKeyword = ^THelpKeyword;
      THelpKeyword = record
        KWord    : PString;
        Index    : integer;
      end;

      PLinkCollection = ^TLinkCollection;
      TLinkCollection = object(TCollection)
        procedure FreeItem(Item: Pointer); virtual;
      end;

      PColorAreaCollection = ^TColorAreaCollection;
      TColorAreaCollection = object(TCollection)
        procedure FreeItem(Item: Pointer); virtual;
      end;

      PKeywordCollection = ^TKeywordCollection;
      TKeywordCollection = object({TSorted}TCollection)
        function  At(Index: Integer): PHelpKeyword;
        procedure FreeItem(Item: Pointer); virtual;
        function  Compare(Key1, Key2: Pointer): Integer; virtual;
      end;


      PHelpTopic = ^THelpTopic;
      THelpTopic = object(TObject)
        Topic: PTopic;
        Lines: PStrings;
        Links: PLinkCollection;
        ColorAreas: PColorAreaCollection;
        constructor Init(ATopic: PTopic);
        procedure   SetParams(AMargin, AWidth: integer); virtual;
        function    GetLineCount: Integer; virtual;
        function    GetLineText(Line: Integer): string; virtual;
        function    GetLinkCount: integer; virtual;
        procedure   GetLinkBounds(Index: integer; var R: TRect); virtual;
        function    GetLinkFileID(Index: integer): word; virtual;
        function    GetLinkContext(Index: integer): THelpCtx; virtual;
        function    GetColorAreaCount: integer; virtual;
        procedure   GetColorAreaBounds(Index: integer; var R: TRect); virtual;
        function    GetColorAreaColor(Index: integer): word; virtual;
        destructor  Done; virtual;
      private
        Width,Margin: integer;
        StockItem: boolean;
        procedure  ReBuild;
      end;

      THelpHistoryEntry = record
        Context_     : THelpCtx;
        Delta_       : TPoint;
        CurPos_      : TPoint;
        CurLink_     : integer;
        FileID_      : word;
      end;

      PHelpViewer = ^THelpViewer;
      THelpViewer = object(TScroller)
        CurPos     : TPoint;
        Margin: integer;
        HelpTopic: PHelpTopic;
        CurLink: integer;
        SelStart   : TPoint;
        SelEnd     : TPoint;
        NoSelect   : Boolean;

        constructor Init(var Bounds: TRect; AHScrollBar, AVScrollBar: PScrollBar);
        procedure   ChangeBounds(var Bounds: TRect); virtual;
        procedure   Draw; virtual;
        procedure   HandleEvent(var Event: TEvent); virtual;
        procedure   SetCurPtr(X,Y: integer); virtual;
        function    GetLineCount: Integer; virtual;
        function    GetLineText(Line: Integer): string; virtual;
        function    GetLinkCount: integer; virtual;
        procedure   GetLinkBounds(Index: integer; var R: TRect); virtual;
        function    GetLinkFileID(Index: integer): word; virtual;
        function    GetLinkContext(Index: integer): THelpCtx; virtual;
        function    GetLinkText(Index: integer): string; virtual;
        function    GetColorAreaCount: integer; virtual;
        procedure   GetColorAreaBounds(Index: integer; var R: TRect); virtual;
        function    GetColorAreaColor(Index: integer): word; virtual;
        procedure   SelectNextLink(ANext: boolean); virtual;
        procedure   SwitchToIndex; virtual;
        procedure   SwitchToTopic(SourceFileID: word; Context: THelpCtx); virtual;
        procedure   SetTopic(Topic: PTopic); virtual;
        procedure   SetCurLink(Link: integer); virtual;
        procedure   SelectLink(Index: integer); virtual;
        procedure   PrevTopic; virtual;
        procedure   RenderTopic; virtual;
        procedure   Lookup(S: string); virtual;
        function    GetPalette: PPalette; virtual;
        destructor  Done; virtual;
        procedure DrawCursor;
        procedure ScrollTo(X, Y: Integer);
      private
        History    : array[0..HistorySize] of THelpHistoryEntry;
        HistoryPtr : integer;
        WordList   : PKeywordCollection;
        Lookupword : string;
        InLookUp   : boolean;
        IndexTopic : PTopic;
        IndexHelpTopic: PHelpTopic;
        DrawLock: Byte;
        DrawFlag: Boolean;
        function    LinkContainsPoint(var R: TRect; var P: TPoint): boolean;
        procedure   ISwitchToTopic(SourceFileID: word; Context: THelpCtx; RecordInHistory: boolean);
        procedure   ISwitchToTopicPtr(P: PTopic; RecordInHistory: boolean);
        procedure   BuildTopicWordList;
        procedure TrackCursor(Center: boolean);
        procedure CheckSels;
        procedure SetSelection(A, B: TPoint);
        procedure SelectionChanged;
        procedure CheckDraw;
      end;


implementation

uses Ext_Crt, Ext_Str, Ext_Math, App;

const CommentColor = Blue;

function NewLink(FileID: longint; Topic: THelpCtx; StartP, EndP: TPoint): PHelpLink;
var P: PHelpLink;
begin
  New(P); FillChar(P^, SizeOf(P^), 0);
  P^.FileID:=FileID;
  P^.Context:=Topic; P^.Bounds.A:=StartP; P^.Bounds.B:=EndP;
  NewLink:=P;
end;

procedure DisposeLink(P: PHelpLink);
begin
  if P<>nil then Dispose(P);
end;

function NewColorArea(Color: byte; StartP, EndP: TPoint): PHelpColorArea;
var P: PHelpColorArea;
begin
  New(P); FillChar(P^, SizeOf(P^), 0);
  P^.Color:=Color; P^.Bounds.A:=StartP; P^.Bounds.B:=EndP;
  NewColorArea:=P;
end;

procedure DisposeColorArea(P: PHelpColorArea);
begin
  if P<>nil then Dispose(P);
end;

function NewKeyword(Index: integer; KWord: string): PHelpKeyword;
var P: PHelpKeyword;
begin
  New(P); FillChar(P^, SizeOf(P^), 0);
  P^.Index:=Index; P^.KWord:=NewStr(KWord);
  NewKeyword:=P;
end;

procedure DisposeKeyword(P: PHelpKeyword);
begin
  if P<>nil then
  begin
    if P^.KWord<>nil then DisposeStr(P^.KWord);
    Dispose(P);
  end;
end;

procedure TLinkCollection.FreeItem(Item: Pointer);
begin
  if Item<>nil then DisposeLink(Item);
end;

procedure TColorAreaCollection.FreeItem(Item: Pointer);
begin
  if Item<>nil then DisposeColorArea(Item);
end;

function TKeywordCollection.At(Index: Integer): PHelpKeyword;
begin
  At:=inherited At(Index);
end;

procedure TKeywordCollection.FreeItem(Item: Pointer);
begin
  if Item<>nil then DisposeKeyword(Item);
end;

function TKeywordCollection.Compare(Key1, Key2: Pointer): Integer;
var R: integer;
    K1: PHelpKeyword absolute Key1;
    K2: PHelpKeyword absolute Key2;
    S1,S2: string;
begin
  S1:=stUpcase(K1^.KWord^); S2:=stUpCase(K2^.KWord^);
  if S1<S2 then R:=-1 else
  if S1>S2 then R:=1 else
  R:=0;
  Compare:=R;
end;

 { THelpTopic }

constructor THelpTopic.Init(ATopic: PTopic);
begin
  inherited Init;
  Topic:=ATopic;
  Lines:=New(PStrings, Init);
  New(Links, Init(50,50));
  ColorAreas:=New(PColorAreaCollection, Init(50,50));
end;

destructor THelpTopic.Done;
begin
  inherited Done;
  Dispose(Lines, Done);
  Dispose(Links, Done);
  Dispose(ColorAreas, Done);
  if (Topic<>nil) then DisposeTopic(Topic);
end;

procedure THelpTopic.SetParams(AMargin, AWidth: integer);
begin
  if Width<>AWidth then
  begin
    Width:=AWidth; Margin:=AMargin;
    ReBuild;
  end;
end;

procedure THelpTopic.ReBuild;
var TextPos,LinkNo: word;
    Line,CurWord: string;
    C: char;
    InLink,InColorArea: boolean;
    LinkStart,LinkEnd,ColorAreaStart,ColorAreaEnd: TPoint;
    CurPos: TPoint;
    ZeroLevel: integer;
    LineStart,NextLineStart: integer;
    LineAlign : (laLeft,laCenter,laRight);
    FirstLink,LastLink: integer;
procedure ClearLine;
begin
  Line:='';
end;
procedure AddWord(TheWord: string); forward;
procedure NextLine;
var P: Integer;
    I,Delta: integer;
begin
  Line:=DupChar(' ',Margin)+Line;
  repeat
    P:=Pos(#255,Line);
    if P>0 then Line[P]:=#32;
  until P=0;
  while copy(Line,length(Line),1)=' ' do Delete(Line,length(Line),1);
  Delta:=0;
  if Line<>'' then
  case LineAlign of
    laLeft    : ;
    laCenter  : if Margin+length(Line)+Margin<Width then
                  begin
                    Delta:=(Width-(Margin+length(Line)+Margin)) div 2;
                    Line:=DupChar(' ',Delta)+Line;
                  end;
    laRight   : if Margin+length(Line)+Margin<Width then
                  begin
                    Delta:=Width-(Margin+length(Line)+Margin);
                    Line:=DupChar(' ',Delta)+Line;
                  end;
  end;
  if (Delta>0) and (FirstLink<>LastLink) then
  for I:=FirstLink to LastLink-1 do
    with PHelpLink(Links^.At(I))^ do
      Bounds.Move(Delta,0);
  if Line='' then Line:=' ';
  Lines^.Add(Line);
  ClearLine;
  LineStart:=NextLineStart;
  CurPos.X:=Margin+LineStart; Line:=DupChar(#255,LineStart); Inc(CurPos.Y);
  if InLink then LinkStart:=CurPos;
  FirstLink:=LastLink;
end;
procedure FlushLine;
var W: string;
begin
  if CurWord<>'' then begin W:=CurWord; CurWord:=''; AddWord(W); end;
  NextLine;
end;
procedure AddWord(TheWord: string);
var W: string;
begin
  W:=TheWord;
  while (length(W)>0) and (W[length(W)] in [' ',#255]) do
     Delete(W,length(W),1);
  if (copy(Line+TheWord,1,1)<>' ') then
    if (Line<>'') and (Margin+length(Line)+length(W)+Margin>Width) then
       NextLine;
  Line:=Line+TheWord;
  CurPos.X:=Margin+length(Line);
end;
procedure CheckZeroLevel;
begin
  if ZeroLevel<>0 then
     begin
       if CurWord<>'' then AddWord(CurWord+' ');
       CurWord:='';
       ZeroLevel:=0;
     end;
end;
begin
  Lines^.FreeAll; Links^.FreeAll;
  if Topic=nil then Lines^.Add('No help available for this topic.') else
  begin
    LineStart:=0; NextLineStart:=0;
    TextPos:=0; ClearLine; CurWord:=''; Line:='';
    CurPos.X:=Margin+LineStart; CurPos.Y:=0; LinkNo:=0;
    InLink:=false; InColorArea:=false; ZeroLevel:=0;
    LineAlign:=laLeft;
    FirstLink:=0; LastLink:=0;
    while (TextPos<Topic^.TextSize) do
    begin
      C:=chr(PByteArray(Topic^.Text)^[TextPos]);
      case C of
        hscLineBreak :
            {if ZeroLevel=0 then ZeroLevel:=1 else
                begin FlushLine; FlushLine; ZeroLevel:=0; end;}
             if InLink then CurWord:=CurWord+' ' else
               begin
                 NextLineStart:=0;
                 FlushLine;
                 LineStart:=0;
                 LineAlign:=laLeft;
               end;
        #1 : Break;
        hscLink :
             begin
               CheckZeroLevel;
               if InLink=false then
                  begin LinkStart:=CurPos; InLink:=true; end else
                begin
                  if CurWord<>'' then AddWord(CurWord); CurWord:='';
                  LinkEnd:=CurPos; Dec(LinkEnd.X);
                  if Topic^.Links<>nil then
                    begin
                      Inc(LastLink);
                      if LinkNo<Topic^.LinkCount then
                      Links^.Insert(NewLink(Topic^.Links^[LinkNo].FileID,
                        Topic^.Links^[LinkNo].Context,LinkStart,LinkEnd));
                      Inc(LinkNo);
                    end;
                  InLink:=false;
                end;
              end;
        hscLineStart :
             begin
               NextLineStart:=length(Line)+length(CurWord);
{               LineStart:=LineStart+(NextLineStart-LineStart);}
             end;
        hscCode :
             begin
               if InColorArea=false then
                  ColorAreaStart:=CurPos else
                begin
                  if CurWord<>'' then AddWord(CurWord); CurWord:='';
                  ColorAreaEnd:=CurPos; Dec(ColorAreaEnd.X);
                  ColorAreas^.Insert(NewColorArea(CommentColor,ColorAreaStart,ColorAreaEnd));
                end;
               InColorArea:=not InColorArea;
             end;
        hscCenter :
             LineAlign:=laCenter;
        hscRight  :
             LineAlign:=laCenter;
        #32: if InLink then CurWord:=CurWord+C else
                begin CheckZeroLevel; AddWord(CurWord+C); CurWord:=''; end;
      else begin CheckZeroLevel; CurWord:=CurWord+C; end;
      end;
      CurPos.X:=Margin+length(Line)+length(CurWord);
      Inc(TextPos);
    end;
    if (Line<>'') or (CurWord<>'') then FlushLine;
  end;
end;

function THelpTopic.GetLineCount: Integer;
begin
  GetLineCount:=Lines^.Count;
end;

function THelpTopic.GetLineText(Line: Integer): string;
var S: string;
begin
  if Line<GetLineCount then S:=PString(Lines^.At(Line))^ else S:='';
  GetLineText:=S;
end;

function THelpTopic.GetLinkCount: integer;
begin
  GetLinkCount:=Links^.Count;
end;

procedure THelpTopic.GetLinkBounds(Index: integer; var R: TRect);
var P: PHelpLink;
begin
  P:=Links^.At(Index);
  R:=P^.Bounds;
end;

function THelpTopic.GetLinkFileID(Index: integer): word;
var P: PHelpLink;
begin
  P:=Links^.At(Index);
  GetLinkFileID:=P^.FileID;
end;

function THelpTopic.GetLinkContext(Index: integer): THelpCtx;
var P: PHelpLink;
begin
  P:=Links^.At(Index);
  GetLinkContext:=P^.Context;
end;

function THelpTopic.GetColorAreaCount: integer;
begin
  GetColorAreaCount:=ColorAreas^.Count;
end;

procedure THelpTopic.GetColorAreaBounds(Index: integer; var R: TRect);
var P: PHelpColorArea;
begin
  P:=ColorAreas^.At(Index);
  R:=P^.Bounds;
end;

function THelpTopic.GetColorAreaColor(Index: integer): word;
var P: PHelpColorArea;
begin
  P:=ColorAreas^.At(Index);
  GetColorAreaColor:=P^.Color;
end;


constructor THelpViewer.Init(var Bounds: TRect; AHScrollBar, AVScrollBar: PScrollBar);
begin
  inherited Init(Bounds, AHScrollBar, AVScrollBar);
  New(WordList, Init(50,50));
  Margin:=1; CurLink:=-1;
  SetState(sfCursorVis,true);
  EventMask:=$FFFF;
end;

destructor THelpViewer.Done;
begin
  inherited Done;
  if (IndexHelpTopic<>nil) and (IndexHelpTopic<>HelpTopic) then
      Dispose(IndexHelpTopic, Done);
  if (HelpTopic<>nil) then Dispose(HelpTopic, Done);
  if assigned(WordList) then
    Dispose(WordList, Done);
end;


procedure THelpViewer.ChangeBounds(var Bounds: TRect);
begin
  if Owner<>nil then Owner^.Lock;
  inherited ChangeBounds(Bounds);
  if (HelpTopic<>nil) and (HelpTopic^.Topic<>nil) and
     (HelpTopic^.Topic^.FileID<>0) then RenderTopic;
  if Owner<>nil then Owner^.UnLock;
end;

procedure THelpViewer.RenderTopic;
begin
  if HelpTopic<>nil then
    HelpTopic^.SetParams(Margin,Size.X);
  SetLimit(255,GetLineCount);
  DrawView;
end;


procedure THelpViewer.CheckDraw;
begin
  if (DrawLock = 0) and DrawFlag then
  begin
    DrawFlag := False;
    DrawView;
  end;
end;

function THelpViewer.LinkContainsPoint(var R: TRect; var P: TPoint): boolean;
var OK: boolean;
begin
  if (R.A.Y=R.B.Y) then
    OK:= (P.Y=R.A.Y) and (R.A.X<=P.X) and (P.X<=R.B.X) else
    OK:=
    ( (R.A.Y=P.Y) and (R.A.X<=P.X) ) or
    ( (R.A.Y<P.Y) and (P.Y<R.B.Y)  ) or
    ( (R.B.Y=P.Y) and (P.X<=R.B.X) );
  LinkContainsPoint:=OK;
end;

procedure THelpViewer.TrackCursor(Center: boolean);
var D: TPoint;
begin
  D:=Delta;
  if CurPos.Y<Delta.Y then D.Y:=CurPos.Y else
   if CurPos.Y>Delta.Y+Size.Y-1 then D.Y:=CurPos.Y-Size.Y+1;
  if CurPos.X<Delta.X then D.X:=CurPos.X else
   if CurPos.X>Delta.X+Size.X-1 then D.X:=CurPos.X-Size.X+1;
  if {((Delta.X<>D.X) or (Delta.Y<>D.Y)) and }Center then
  begin
     { loose centering for debugger PM }
     while (CurPos.Y-D.Y)<(Size.Y div 3) do Dec(D.Y);
     while (CurPos.Y-D.Y)>2*(Size.Y div 3) do Inc(D.Y);
  end;
  if (Delta.X<>D.X) or (Delta.Y<>D.Y) then
    ScrollTo(D.X,D.Y);
  DrawCursor;
end;

procedure THelpViewer.ScrollTo(X, Y: Integer);
begin
  inherited ScrollTo(X,Y);
  if (HScrollBar=nil) or (VScrollBar=nil) then
     begin Delta.X:=X; Delta.Y:=Y; end;
  DrawView;
end;

procedure THelpViewer.DrawCursor;
begin
  SetCursor(CurPos.X-Delta.X,CurPos.Y-Delta.Y);
  SetState(sfCursorIns,false);
end;

function ShouldExtend : boolean;
begin
  ShouldExtend:=((GetShiftState and (kbRightShift+kbLeftShift)<>0)) {and
    not DontConsiderShiftState};
end;

procedure THelpViewer.CheckSels;
begin
  if (SelStart.Y>SelEnd.Y) or
     ( (SelStart.Y=SelEnd.Y) and (SelStart.X>SelEnd.X) ) then
       SetSelection(SelEnd,SelStart);
end;

procedure THelpViewer.SelectionChanged;
var Enable: boolean;
begin
  Enable:=((SelStart.X<>SelEnd.X) or (SelStart.Y<>SelEnd.Y)) and (Clp<>nil);
  SetCmdState(ToClipCmds,Enable);
  SetCmdState(NulClipCmds,Enable);
  Message(Application,evBroadcast,cmCommandSetChanged,nil);
end;

procedure THelpViewer.SetSelection(A, B: TPoint);
begin
  SelStart:=A; SelEnd:=B;
  SelectionChanged;
end;

procedure THelpViewer.SetCurPtr(X,Y: integer);
var OldCurLink,I: integer;
    OldPos,P: TPoint;
    R: TRect;
procedure ASetCurPtr(X,Y: integer);
var OldPos,OldSEnd,OldSStart: TPoint;
    Extended: boolean;
begin
{  Lock;}
  X:=Max(0,Min(MaxLineLength+1,X));
  Y:=Max(0,Min(GetLineCount-1,Y));
  OldPos:=CurPos;
  OldSEnd:=SelEnd;
  OldSStart:=SelStart;
  CurPos.X:=X;
  CurPos.Y:=Y;
  TrackCursor(false);
  if (NoSelect=false) and (ShouldExtend) then
  begin
    CheckSels;
    Extended:=false;
    if ((OldPos.X=SelStart.X) and (OldPos.X=SelStart.X)) then
      begin SetSelection(CurPos,SelEnd); Extended:=true; end;
    CheckSels;
    if Extended=false then
     if ((OldPos.X=SelEnd.X) and (OldPos.X=SelEnd.X)) then
   begin SetSelection(SelStart,CurPos); Extended:=true; end;
    CheckSels;
    if (Extended=false) then
       if ((OldPos.X<=CurPos.X) or (OldPos.Y<=CurPos.Y))
     then begin SetSelection(OldPos,CurPos); Extended:=true; end
     else begin SetSelection(CurPos,OldPos); Extended:=true; end;
    DrawView;
  end else
{   if (Flags and efPersistentBlocks)=0 then
      begin HideSelect; DrawView; end;}
{  if PointOfs(SelStart)=PointOfs(SelEnd) then
     SetSelection(CurPos,CurPos);}
{  if (Flags and (efHighlightColumn+efHighlightRow))<>0 then
     DrawView;}
{  if ((CurPos.X<>OldPos.X) or (CurPos.Y<>OldPos.Y)) and
     ((Highlight.A.X<>HighLight.B.X) or (Highlight.A.Y<>HighLight.B.Y)) then
     HideHighlight;}
{  if (OldPos.Y<>CurPos.Y) and (0<=OldPos.Y) and (OldPos.Y<GetLineCount) then
     SetLineText(OldPos.Y,TrimRight(GetLineText(OldPos.Y)));
  if ((CurPos.X<>OldPos.X) or (CurPos.Y<>OldPos.Y)) and (GetErrorMessage<>'') then
    SetErrorMessage('');
  if ((CurPos.X<>OldPos.X) or (CurPos.Y<>OldPos.Y)) and (HighlightRow<>-1) then
    SetHighlightRow(-1);
  if ((CurPos.X<>OldPos.X) or (CurPos.Y<>OldPos.Y)) then
    AddAction(eaMoveCursor,OldPos,CurPos,'');}
{  UnLock;}
end;

begin
  OldPos:=CurPos;
  OldCurLink:=CurLink;
  ASetCurPtr(X,Y);
  CurLink:=-1;
  P:=CurPos;
  for I:=0 to GetLinkCount-1 do
  begin
    GetLinkBounds(I,R);
    if LinkContainsPoint(R,P) then
       begin CurLink:=I; Break; end;
  end;
  if OldCurLink<>CurLink then DrawView;
  if ((OldPos.X<>CurPos.X) or (OldPos.Y<>CurPos.Y)) and (InLookup=false) then
     Lookup('');
end;

function THelpViewer.GetLineCount: Integer;
var Count: integer;
begin
  if HelpTopic=nil then Count:=0 else Count:=HelpTopic^.GetLineCount;
  GetLineCount:=Count;
end;

function THelpViewer.GetLineText(Line: Integer): string;
var S: string;
begin
  if HelpTopic=nil then S:='' else S:=HelpTopic^.GetLineText(Line);
  GetLineText:=S;
end;

function THelpViewer.GetLinkCount: integer;
var Count: integer;
begin
  if HelpTopic=nil then Count:=0 else Count:=HelpTopic^.GetLinkCount;
  GetLinkCount:=Count;
end;

procedure THelpViewer.GetLinkBounds(Index: integer; var R: TRect);
begin
  HelpTopic^.GetLinkBounds(Index,R);
end;

function THelpViewer.GetLinkFileID(Index: integer): word;
begin
  GetLinkFileID:=HelpTopic^.GetLinkFileID(Index);
end;

function THelpViewer.GetLinkContext(Index: integer): THelpCtx;
begin
  GetLinkContext:=HelpTopic^.GetLinkContext(Index);
end;

function THelpViewer.GetLinkText(Index: integer): string;
var S: string;
    R: TRect;
    Y,StartX,EndX: integer;
begin
  S:=''; GetLinkBounds(Index,R);
  Y:=R.A.Y;
  while (Y<=R.B.Y) do
  begin
    if Y=R.A.Y then StartX:=R.A.X else StartX:=Margin;
    if Y=R.B.Y then EndX:=R.B.X else EndX:=255;
    S:=S+copy(GetLineText(Y),StartX+1,EndX-StartX+1);
    Inc(Y);
  end;
  GetLinkText:=S;
end;

function THelpViewer.GetColorAreaCount: integer;
var Count: integer;
begin
  if HelpTopic=nil then Count:=0 else Count:=HelpTopic^.GetColorAreaCount;
  GetColorAreaCount:=Count;
end;

procedure THelpViewer.GetColorAreaBounds(Index: integer; var R: TRect);
begin
  HelpTopic^.GetColorAreaBounds(Index,R);
end;

function THelpViewer.GetColorAreaColor(Index: integer): word;
begin
  GetColorAreaColor:=HelpTopic^.GetColorAreaColor(Index);
end;

procedure THelpViewer.SelectNextLink(ANext: boolean);
var I,Link: integer;
    R: TRect;
begin
  if HelpTopic=nil then Exit;
  Link:=CurLink;
  if Link<>-1 then
  begin
    if ANext then
       begin Inc(Link); if Link>=GetLinkCount then Link:=0; end else
       begin Dec(Link); if Link=-1 then Link:=GetLinkCount-1; end;
  end else
  for I:=0 to GetLinkCount-1 do
  begin
    GetLinkBounds(I,R);
    if (R.A.Y>CurPos.Y) or
       (R.A.Y=CurPos.Y) and (R.A.X>CurPos.X) then
       begin Link:=I; Break; end;
  end;
  if (Link=-1) and (GetLinkCount>0) then
     if ANext then Link:=0
              else Link:=GetLinkCount-1;
  SetCurLink(Link);
end;

procedure THelpViewer.SetCurLink(Link: integer);
var R: TRect;
begin
  if Link<>-1 then
  begin
    GetLinkBounds(Link,R);
    SetCurPtr(R.A.X,R.A.Y);
    TrackCursor(true);
  end;
end;

procedure THelpViewer.SwitchToIndex;
begin
  if IndexTopic=nil then
     IndexTopic:=HelpFacility^.BuildIndexTopic;
  ISwitchToTopicPtr(IndexTopic,true);
end;

procedure THelpViewer.SwitchToTopic(SourceFileID: word; Context: THelpCtx);
begin
  ISwitchToTopic(SourceFileID,Context,true);
end;

procedure THelpViewer.ISwitchToTopic(SourceFileID: word; Context: THelpCtx; RecordInHistory: boolean);
var P: PTopic;
begin
  if HelpFacility=nil then P:=nil else
    if (SourceFileID=0) and (Context=0) and (HelpTopic<>nil) then
       P:=IndexTopic else
     P:=HelpFacility^.LoadTopic(SourceFileID, Context);
  ISwitchToTopicPtr(P,RecordInHistory);
end;

procedure THelpViewer.ISwitchToTopicPtr(P: PTopic; RecordInHistory: boolean);
var HistoryFull: boolean;
begin
  if (P<>nil) and RecordInHistory and (HelpTopic<>nil) then
  begin
    HistoryFull:=HistoryPtr>=HistorySize;
    if HistoryFull then
       Move(History[1],History[0],SizeOf(History)-SizeOf(History[0]));
    with History[HistoryPtr] do
    begin
      {SourceTopic_:=SourceTopic; }Context_:=HelpTopic^.Topic^.HelpCtx;
      FileID_:=HelpTopic^.Topic^.FileID;
      Delta_:=Delta; CurPos_:=CurPos; CurLink_:=CurLink;
    end;
    if HistoryFull=false then Inc(HistoryPtr);
  end;

  if Owner<>nil then Owner^.Lock;
  SetTopic(P);
  DrawView;
  if Owner<>nil then Owner^.UnLock;
end;

procedure THelpViewer.PrevTopic;
begin
  if HistoryPtr>0 then
  begin
    if Owner<>nil then Owner^.Lock;
    Dec(HistoryPtr);
    with History[HistoryPtr] do
    begin
      ISwitchToTopic(FileID_,Context_,false);
      ScrollTo(Delta_.X,Delta_.Y);
      SetCurPtr(CurPos_.X,CurPos_.Y);
      TrackCursor(false);
      if CurLink<>CurLink_ then SetCurLink(CurLink_);
    end;
    DrawView;
    if Owner<>nil then Owner^.UnLock;
  end;
end;

procedure THelpViewer.SetTopic(Topic: PTopic);
begin
  CurLink:=-1;
  if (HelpTopic=nil) or (Topic<>HelpTopic^.Topic) then
  begin
   if (HelpTopic<>nil) and (HelpTopic<>IndexHelpTopic) then
      Dispose(HelpTopic, Done);
   HelpTopic:=nil;
   if Topic<>nil then
      begin
        if (Topic=IndexTopic) and (IndexHelpTopic<>nil) then
           HelpTopic:=IndexHelpTopic else
        New(HelpTopic, Init(Topic));
        if Topic=IndexTopic then
           IndexHelpTopic:=HelpTopic;
      end;
  end;
  if Owner<>nil then Owner^.Lock;
  SetCurPtr(0,0); TrackCursor(false);
  RenderTopic;
  BuildTopicWordList;
  Lookup('');
  SetSelection(CurPos,CurPos);
  DrawView;
  if Owner<>nil then Owner^.UnLock;
end;

procedure THelpViewer.BuildTopicWordList;
var I: integer;
begin
  WordList^.FreeAll;
  for I:=0 to GetLinkCount-1 do
    WordList^.Insert(NewKeyword(I,Trim(GetLinkText(I))));
end;

procedure THelpViewer.Lookup(S: string);
var Index, I: Integer;
    W: string;
    OldLookup: string;
    R: TRect;
    P: PHelpKeyword;
begin
  InLookup:=true;
  OldLookup:=LookupWord;
  S:=stUpCase(S);
  Index:=-1;
  I:=0; {J:=0;
  while (J<GetLinkCount) do
    begin
      GetLinkBounds(J,R);
      if (R.A.Y<CurPos.Y) or ((R.A.Y=CurPos.Y) and (R.B.X<CurPos.X))
         then Inc(J) else
           begin I:=J; Break; end;
    end;}
  if S='' then LookupWord:='' else
  begin
    while (Index=-1) and (I<WordList^.Count) do
      begin
        P:=WordList^.At(I);
        if P^.KWord<>nil then
          begin
            W:=stUpCase(Trim(P^.KWord^));
            if copy(W,1,length(S))=S then Index:=I;
          end;
{        if W>S then Break else}
        Inc(I);
      end;
    if Index<>-1 then
    begin
      W:=Trim(WordList^.At(Index)^.KWord^);
      LookupWord:=copy(W,1,length(S));
    end;
  end;

  if LookupWord<>OldLookup then
  begin
    if Index=-1 then SetCurLink(CurLink) else
    begin
      if Owner<>nil then Owner^.Lock;
      P:=WordList^.At(Index);
      S:=GetLinkText(P^.Index);
      I:=Pos(LookupWord,S); if I=0 then I:=1;
      GetLinkBounds(P^.Index,R);
      SetCurPtr(R.A.X+(I-1)+length(Lookupword),R.A.Y);
      CurLink:=P^.Index; DrawView;
      TrackCursor(true);
      if Owner<>nil then Owner^.UnLock;
    end;
  end;
  InLookup:=false;
end;

procedure THelpViewer.SelectLink(Index: integer);
var ID: word;
    Ctx: THelpCtx;
begin
  if Index=-1 then Exit;
  if HelpTopic=nil then begin ID:=0; Ctx:=0; end else
     begin
       ID:=GetLinkFileID(Index);
       Ctx:=GetLinkContext(Index);
     end;
  SwitchToTopic(ID,Ctx);
end;

procedure THelpViewer.HandleEvent(var Event: TEvent);
var DontClear: boolean;
procedure GetMousePos(var P: TPoint);
begin
  MakeLocal(Event.Where,P);
  Inc(P.X,Delta.X); Inc(P.Y,Delta.Y);
end;

procedure PageUp;
begin
  ScrollTo(Delta.X,Max(Delta.Y-Size.Y,0));
  SetCurPtr(CurPos.X,Max(0,CurPos.Y-(Size.Y)));
end;

procedure PageDown;
begin
  ScrollTo(Delta.X,Min(Delta.Y+Size.Y,GetLineCount-1));
  SetCurPtr(CurPos.X,Min(GetLineCount-1,CurPos.Y+(Size.Y{-1})));
end;

begin
  inherited HandleEvent(Event);
  case Event.What of
    evMouseDown :
      if MouseInView(Event.Where) then
      if (Event.Buttons=mbLeftButton) and (Event.Double) then
      begin
        inherited HandleEvent(Event);
        if CurLink<>-1 then
           SelectLink(CurLink);
      end;
    evBroadcast :
      case Event.Command of
        cmHelpFilesChanged :
          begin
            if HelpTopic=IndexHelpTopic then HelpTopic:=nil;
            IndexTopic:=nil;
            if IndexHelpTopic<>nil then Dispose(IndexHelpTopic, Done);
            IndexHelpTopic:=nil;
          end;
      end;
    evCommand :
      begin
        DontClear:=false;
        case Event.Command of
          cmPrevTopic : PrevTopic;
{          cmCopy:}
        else DontClear:=true;
        end;
        if DontClear=false then ClearEvent(Event);
      end;
    evKeyDown :
      begin
        DontClear:=false;
        case Event.KeyCode of
          kbTab :
            SelectNextLink(true);
          kbShiftTab :
            begin NoSelect:=true; SelectNextLink(false); NoSelect:=false; end;
          kbEnter :
            if CurLink<>-1 then
              SelectLink(CurLink);
          kbUp:SetCurPtr(CurPos.X,CurPos.Y-1);
          kbDown:SetCurPtr(CurPos.X,CurPos.Y+1);
          kbLeft:SetCurPtr(CurPos.X-1,CurPos.Y);
          kbRight:SetCurPtr(CurPos.X+1,CurPos.Y);
          kbPgUp:PageUp;
          kbPgDn:PageDown;
          kbCtrlPgUp:SetCurPtr(0,0);
          kbCtrlPgDn:SetCurPtr(1,GetLineCount-1);
        else
          case Event.CharCode of
             #32..#255 :
               begin NoSelect:=true; Lookup(LookupWord+Event.CharCode); NoSelect:=false; end;
          else DontClear:=true;
          end;
        end;
        TrackCursor(false);
        if DontClear=false then ClearEvent(Event);
      end;
  end;
end;

procedure THelpViewer.Draw;
var NormalColor, LinkColor,
    SelectColor, SelectionColor: word;
    B: TDrawBuffer;
    DX,DY,X,Y,I,MinX,MaxX,ScreenX: integer;
    LastLinkDrawn,LastColorAreaDrawn: integer;
    S: string;
    R: TRect;
    SelR : TRect;
    C: word;
    CurP: TPoint;
begin
  NormalColor:=GetColor(1); LinkColor:=GetColor(2);
  SelectColor:=GetColor(3); SelectionColor:=GetColor(4);
  SelR.A:=SelStart; SelR.B:=SelEnd;
  LastLinkDrawn:=0; LastColorAreaDrawn:=0;
  for DY:=0 to Size.Y-1 do
  begin
    Y:=Delta.Y+DY;
    MoveChar(B,' ',NormalColor,Size.X);
    if Y<GetLineCount then
    begin
      S:=copy(GetLineText(Y),Delta.X+1,255);
      S:=copy(S,1,MaxViewWidth);
      MoveStr(B,S,NormalColor);

      for I:=LastColorAreaDrawn to GetColorAreaCount-1 do
      begin
        GetColorAreaBounds(I,R);
        if R.A.Y>Y then Break;
        LastColorAreaDrawn:=I;
        if Y=R.B.Y then MaxX:=R.B.X else MaxX:=(length(S)-1);
        if Y=R.A.Y then MinX:=R.A.X else MinX:=0;
        if (R.A.Y<=Y) and (Y<=R.B.Y) then
        begin
          C:=GetColorAreaColor(I);
          for DX:=MinX to MaxX do
          begin
            X:=DX;
            ScreenX:=X-(Delta.X);
            if (ScreenX>0) and (ScreenX<=High(B)) then
            begin
              B[ScreenX]:=(B[ScreenX] and $f0ff) or (C shl 8);
            end;
          end;
        end;
      end;

      for I:=LastLinkDrawn to GetLinkCount-1 do
      begin
        GetLinkBounds(I,R);
        if R.A.Y>Y then Break;
        LastLinkDrawn:=I;
        if Y=R.B.Y then MaxX:=R.B.X else MaxX:=(length(S)-1);
        if Y=R.A.Y then MinX:=R.A.X else MinX:=0;
        if (R.A.Y<=Y) and (Y<=R.B.Y) then
          for DX:=MinX to MaxX do
          begin
            X:=DX;
            ScreenX:=X-(Delta.X);
            if (ScreenX>=0) and (ScreenX<=High(B)) then
            begin
              CurP.X:=X; CurP.Y:=Y;
              if LinkContainsPoint(R,CurP) then
                if I=CurLink then C:=SelectColor else C:=LinkColor;
              B[ScreenX]:=(B[ScreenX] and $ff) or (C shl 8);
            end;
          end;
      end;

      if ((SelR.A.X<>SelR.B.X) or (SelR.A.Y<>SelR.B.Y)) and (SelR.A.Y<=Y) and (Y<=SelR.B.Y) then
      begin
        if Y=SelR.A.Y then MinX:=SelR.A.X else MinX:=0;
        if Y=SelR.B.Y then MaxX:=SelR.B.X-1 else MaxX:=255;
        for DX:=MinX to MaxX do
        begin
          X:=DX;
          ScreenX:=X-(Delta.X);
          if (ScreenX>=0) and (ScreenX<High(B)) then
            B[ScreenX]:=(B[ScreenX] and $0fff) or ((SelectionColor and $f0) shl 8);
        end;
      end;

    end;
    WriteLine(0,DY,Size.X,1,B);
  end;
  DrawCursor;
end;

function THelpViewer.GetPalette: PPalette;
const P: string[length(CHelpViewer)] = CHelpViewer;
begin
  GetPalette:=@P;
end;

end.