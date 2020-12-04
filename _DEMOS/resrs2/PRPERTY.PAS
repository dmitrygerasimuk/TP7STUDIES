{$O+}
{$I Define.inc}
unit Prperty;
interface

uses Objects, Ext_Type, Clases, Dialogs, Views, GlType, Register;

const
   NilName = '(nil)';

const
{$IFDEF PASCAL16}
   VMTOffset = 2;
{$ELSE}
   VMTOffset = SizeOf(TObject);
{$ENDIF}

type
  PLockupRecord = ^TLockupRecord;
  TLockupRecord = record
    Name:PString;
    Value:longint;
    Next:PLockupRecord;
  end;
type
  PProperty = ^TProperty;

  TGetTextEvent=function(Sender:PProperty; View:PView):string;
  TEditEvent=procedure(Sender:PProperty; View:PView; Owner:PListBox);
  TPropertyNotifyEvent=procedure(Sender:PProperty; View:PView);
  TPropertyValidateEvent=function(Sender:PProperty; View:PView; Info:Pointer):boolean;

  TProperty = object(TObject)
    Name:PString;
    Offset:integer;
    Info:Pointer;
    HelpCtx:Word;
    OnGetText:TGetTextEvent;
    OnEdit:TEditEvent;
    OnBeforeEdit:TPropertyNotifyEvent;
    OnAfterEdit:TPropertyNotifyEvent;
    OnValidate:TPropertyValidateEvent;
    ReadOnly:boolean;
    constructor Init(AName:string; AOffset:Integer; AHelpCtx:word; AReadOnly:boolean);
    destructor Done;virtual;
    constructor Load(var S:TStream);
    procedure Store(var S:TStream);
    function AsText:string;virtual;
    procedure SetAsText(S:string);virtual;
    procedure EditProperty(ListBox:PListBox);virtual;
    procedure SetPointer(P:Pointer; V:Pointer);virtual;
  private
    Obj:PObject;
    PViews:PView;
  end;


type
  PLinkProperty = ^TLinkProperty;
  TLinkProperty = object(TProperty)
    ValidSet:TTypeSet;
    DeleteForAll:boolean;
    constructor Init(AName:string; AOffset:Integer; AHelpCtx:word;
                     AValidSet:TTypeSet; ADeleteForAll:boolean; AReadOnly:boolean);
    constructor Load(var S:TStream);
    procedure Store(var S:TStream);
    function AsText:string;virtual;
    procedure EditProperty(ListBox:PListBox);virtual;
  end;

type
  PBooleanProperty = ^TBooleanProperty;
  TBooleanProperty = object(TProperty)
    function AsText:string;virtual;
    procedure EditProperty(ListBox:PListBox);virtual;
  end;


type
  PPStringProperty = ^TPStringProperty;
  TPStringProperty = object(TProperty)
    function AsText:string;virtual;
    procedure EditProperty(ListBox:PListBox);virtual;
  end;

type
  PStringProperty = ^TStringProperty;
  TStringProperty = object(TPStringProperty)
    MaxLen:Byte;
    constructor Init(AName:string; AOffset:Integer; AHelpCtx:word; AMaxLen:Byte; AReadOnly:boolean);
    constructor Load(var S:TStream);
    procedure Store(var S:TStream);
    function AsText:string;virtual;
    procedure EditProperty(ListBox:PListBox);virtual;
  end;

type
  TVariantRecord = record
    case itType:TNumericType of
      0:(Result:Pointer);
      1:(LongResult:PLongint);
      2:(IntResult:PInteger);
      3:(WordResult:PWord);
      4:(ByteResult:PByte);
      5:(ShortIntResult:PShortInt);
      6:(CharResult:PChar);
      7:(DateTimeResult:PDateTime);
      8:(DoubleResult:PDouble);
      9:(RealResult:PReal);
      10:(Int16Result:PInt16)
  end;

type
  PIntegerProperty = ^TIntegerProperty;
  TIntegerProperty = object(TProperty)
    fResult:TVariantRecord;
    constructor Init(AName:string; AOffset:Integer; AHelpCtx:word; itType:TNumericType;
                AReadOnly:boolean);
    constructor Load(var S:TStream);
    procedure Store(var S:TStream);
    function AsText:string;virtual;
    procedure EditProperty(ListBox:PListBox);virtual;
    procedure SetPointer(P:Pointer; V:Pointer);virtual;
  end;

type
  PBitMapProperty = ^TBitMapProperty;
  TBitMapProperty = object(TProperty)
    Value:PStrings;
    EditValue:Longint;
    constructor Init(AName:string; AOffset:Integer; AHelpCtx:word;
                 Item:PSItem; AEditValue:Longint);
    destructor Done;virtual;
    constructor Load(var S:TStream);
    procedure Store(var S:TStream);
    function AsText:string;virtual;
    procedure EditProperty(ListBox:PListBox);virtual;
  private
    BitList:PCollection;
  end;

type
  PBitBolProperty = ^TBitBolProperty;
  TBitBolProperty = object(TProperty)
    Owner:PBitMapProperty;
    BitVal:byte;
    constructor Init(AName:string; AOffset:Integer;
               AHelpCtx:word;ABitVal:byte; AReadOnly:boolean; AOwner:PBitMapProperty);
    function AsText:string;virtual;
    procedure EditProperty(ListBox:PListBox);virtual;
  end;

type
  PLockUpProperty = ^TLockUpProperty;
  TLockUpProperty = object(TBitMapProperty)
    IntegerType:TNumericType;
    IntegerShift:integer;
    constructor Init(AName:string; AOffset:Integer; AHelpCtx:word;
                 Item:PSItem; AReadOnly:boolean;
                 AIntegerType:TNumericType; AIntegerShift:integer);
    constructor Load(var S:TStream);
    procedure Store(var S:TStream);
    procedure EditProperty(ListBox:PListBox);virtual;
    function AsText:string;virtual;
  end;

type
  PPStrCollectionProperty = ^TPStrCollectionProperty;
  TPStrCollectionProperty = object(TProperty)
    function AsText:string;virtual;
    procedure EditProperty(ListBox:PListBox);virtual;
  end;

type
  PTStrCollectionProperty = ^TTStrCollectionProperty;
  TTStrCollectionProperty = object(TProperty)
    function AsText:string;virtual;
    procedure EditProperty(ListBox:PListBox);virtual;
  end;

type
  TFunType = (fntBoolean, fntShortint, fntChar, fntByte, fntInteger, fntWord,
              fntLongint);
  TFunResultRecord = record
    case TFunType of
    fntBoolean:(BooleanResult:Boolean);
    fntShortint:(ShortIntResult:ShortInt);
    fntInteger:(IntegerResult:Integer);
    fntLongint:(LongintResult:Longint);
    fntByte:(ByteResult:Byte);
    fntWord:(WordResult:Word);
    fntChar:(CharResult:Char);
  end;

type
  PFunctionsProperty = ^TFunctionsProperty;
  TFunctionsProperty = object(TProperty)
    GetProc:Pointer;
    SetProc:Pointer;
    fType:TFunType;
    constructor Init(AName:string; AHelpCtx:word; AReadOnly:boolean;
                                   AGetProc, ASetProc:Pointer; AType:TFunType);
    constructor Load(var S:TStream);
    procedure Store(var S:TStream);
    function AsText:string;virtual;
    procedure EditProperty(ListBox:PListBox);virtual;
  end;


type
  PPropertyCollections = ^TPropertyCollections;
  TPropertyCollections = object(TSortedCollection)
    function Compare(Key1, Key2: Pointer): Integer; virtual;
  end;
const
  RProperty: TStreamRec = (
    ObjType: 20000;
    VmtLink: Ofs(TypeOf(TProperty)^);
    Load: @TProperty.Load;
    Store: @TProperty.Store);
const
  RPStringProperty: TStreamRec = (
    ObjType: 20001;
    VmtLink: Ofs(TypeOf(TPStringProperty)^);
    Load: @TPStringProperty.Load;
    Store: @TPStringProperty.Store);
const
  RStringProperty: TStreamRec = (
    ObjType: 20002;
    VmtLink: Ofs(TypeOf(TStringProperty)^);
    Load: @TStringProperty.Load;
    Store: @TStringProperty.Store);
const
  RIntegerProperty: TStreamRec = (
    ObjType: 20004;
    VmtLink: Ofs(TypeOf(TIntegerProperty)^);
    Load: @TIntegerProperty.Load;
    Store: @TIntegerProperty.Store);
const
  RBitMapProperty: TStreamRec = (
    ObjType: 20005;
    VmtLink: Ofs(TypeOf(TBitMapProperty)^);
    Load: @TBitMapProperty.Load;
    Store: @TBitMapProperty.Store);
const
  RBooleanProperty: TStreamRec = (
    ObjType: 20006;
    VmtLink: Ofs(TypeOf(TBooleanProperty)^);
    Load: @TBooleanProperty.Load;
    Store: @TBooleanProperty.Store);
const
  RLockUpProperty: TStreamRec = (
    ObjType: 20007;
    VmtLink: Ofs(TypeOf(TLockUpProperty)^);
    Load: @TLockUpProperty.Load;
    Store: @TLockUpProperty.Store);
const
  RPStrCollectionProperty: TStreamRec = (
    ObjType: 20003;
    VmtLink: Ofs(TypeOf(TPStrCollectionProperty)^);
    Load: @TPStrCollectionProperty.Load;
    Store: @TPStrCollectionProperty.Store);
const
  RTStrCollectionProperty: TStreamRec = (
    ObjType: 20008;
    VmtLink: Ofs(TypeOf(TTStrCollectionProperty)^);
    Load: @TTStrCollectionProperty.Load;
    Store: @TTStrCollectionProperty.Store);
const
  RLinkProperty: TStreamRec = (
    ObjType: 20009;
    VmtLink: Ofs(TypeOf(TLinkProperty)^);
    Load: @TLinkProperty.Load;
    Store: @TLinkProperty.Store);
const
  RPropertyCollections: TStreamRec = (
    ObjType: 20010;
    VmtLink: Ofs(TypeOf(TPropertyCollections)^);
    Load: @TPropertyCollections.Load;
    Store: @TPropertyCollections.Store);
const
  RFunctionsProperty : TStreamRec = (
    ObjType: 20011;
    VmtLink: Ofs(TypeOf(TFunctionsProperty)^);
    Load: @TFunctionsProperty.Load;
    Store: @TFunctionsProperty.Store);

procedure RegisterProperty;
implementation
uses Drivers, Ext_Math, Cursors, Validate, ResTools, RESSTRS, Ext_Str,
     Ext_App, AddCntrl, RsCllt, Set_Opt, Ext_Dos, Ext_Sys;

function ConverCtrlCodeToString(S:string):string;
var i:integer;
    S1:string;
begin
  i:=1;
  S1:='';
  while i<=Length(S) do
  begin
    if (S[i]='^') and (I<length(S)) then
    begin
      inc(i);
      if S[i]<>'^' then S1:=S1+Char(byte(s[i])-64)
      else S1:=S1+S[i];
    end
    else
    S1:=S1+S[i];
    inc(i);
  end;
  ConverCtrlCodeToString:=S1;
end;

function ConverStringToCtrlCode(S:string):string;
var S1:string;
    i:integer;
begin
  S1:='';
  for i:=1 to Length(S) do
    if byte(S[i])<26 then S1:=S1+'^'+char(byte(S[i])+64)
    else
    if s[i]='^' then S1:=S1+'^^' else S1:=S1+S[i];
  ConverStringToCtrlCode:=S1;
end;

 {TProperty}
constructor TProperty.Init(AName:string; AOffset:Integer; AHelpCtx:word;
                      AReadOnly:boolean);
begin
  inherited Init;
  Name:=NewStr(AName);
  Offset:=AOffset;
  HelpCtx:=AHelpCtx;
  ReadOnly:=AReadOnly;
end;

destructor TProperty.Done;
begin
  DisposeStr(NAme);
  inherited Done;
end;

constructor TProperty.Load(var S:TStream);
begin
  inherited Init;
  Name:=S.ReadStr;
  S.Read(Offset, SizeOf(Integer));
  S.Read(HelpCtx, SizeOf(Word));
  S.Read(ReadOnly, SizeOf(boolean));
  LoadProcedure(S,@OnGetText);
  LoadProcedure(S,@OnEdit);
  LoadProcedure(S,@OnBeforeEdit);
  LoadProcedure(S,@OnAfterEdit);
  LoadProcedure(S,@OnValidate);
end;

procedure TProperty.Store(var S:TStream);
begin
  S.WriteStr(Name);
  S.Write(Offset, SizeOf(Integer));
  S.Write(HelpCtx, SizeOf(Word));
  S.Write(ReadOnly, SizeOf(boolean));
  StoreProcedure(S,@OnGetText);
  StoreProcedure(S,@OnEdit);
  StoreProcedure(S,@OnBeforeEdit);
  StoreProcedure(S,@OnAfterEdit);
  StoreProcedure(S,@OnValidate);
end;

function TProperty.AsText:string;
begin
  if Assigned(OnGetText) then AsText:=OnGetText(@Self, PViews)
  else AsText:='';
end;

procedure TProperty.EditProperty(ListBox:PListBox);
begin
  if ReadOnly then exit;
  if Assigned(OnBeforeEdit) then OnBeforeEdit(@Self, PViews);
  if Assigned(OnEdit) then OnEdit(@Self, PViews, ListBox);
  if Assigned(OnAfterEdit) then OnAfterEdit(@Self, PViews);
end;

procedure TProperty.SetPointer(P:Pointer; V:Pointer);
begin
  PViews:=V;
  Obj:=P;
{$IFDEF VER70}
  Info:=Ptr(PtrRec(P).Seg,PtrRec(P).Ofs+Offset+VMTOffset);
{$ELSE}
{$IFDEF VIRTUALPASCAL}
  Info:=Pointer(Longint(P)+Offset+VMTOffset);
{$ELSE}
  Info:=0;
{$ENDIF}
{$ENDIF}
end;

procedure TProperty.SetAsText(S:string);
begin
end;

function EditeDate(var S:string; ListBox:PListBox; MaxLen:byte; V:PValidator):boolean;
var R:TRect;
    P:PInputLine;
    Prop:PProperty;
    ModalResult:word;
begin
  with ListBox^ do
  begin
    Prop:=List^.At(Focused);
    S:=Prop^.AsText;
    R.Assign(Origin.X+Length(Prop^.Name^)+2, Origin.Y+Focused-TopItem,
             Origin.X+Size.X, Origin.Y+Focused-TopItem+1);
    P:=New(PInputLine, Init(R, MaxLen));
    P^.SetValidator(V);
    P^.SetData(S);
    ModalResult:=Owner^.ExecView(P);
  end;
  if ModalResult=cmOk then P^.GetData(S);
  EditeDate:=ModalResult=cmOk;
  P^.Free;
end;

 {TPStringProperty}
function TPStringProperty.AsText:string;
begin
  if PString(Info^)<>nil then AsText:=ConverStringToCtrlCode(PString(Info^)^)
  else AsText:='';
end;

procedure TPStringProperty.EditProperty(ListBox:PListBox);
var PS:PString;
    S:String;
    B:Boolean;
begin
  if ReadOnly then exit;
  _Cursor^.Owner^.Lock;
  PS:=PString(Info^);
  if PS<>nil then S:=ConverStringToCtrlCode(PS^) else S:='';
  if Assigned(OnBeforeEdit) then OnBeforeEdit(@Self, PViews);
  if Assigned(OnEdit) then OnEdit(@Self, PViews, ListBox)
  else
  if EditeDate(S, ListBox, 255, nil) then
  begin
    if Assigned(OnValidate) then B:=OnValidate(@Self, PViews, @S)
    else B:=true;
    if B then
    begin
      AssignStr(PS,ConverCtrlCodeToString(S));
      PString(Info^):=PS;
    end;
  end;
  if Assigned(OnAfterEdit) then OnAfterEdit(@Self, PViews);
  _Cursor^.Owner^.UnLock;
end;

  { TStringProperty }
constructor TStringProperty.Init(AName:string; AOffset:Integer;
            AHelpCtx:word; AMaxLen:Byte; AReadOnly:boolean);
begin
  inherited Init(AName, AOffset, AHelpCtx, AReadOnly);
  MaxLen:=AMaxLen;
end;

constructor TStringProperty.Load(var S:TStream);
begin
  inherited Load(S);
  S.Read(MaxLen, SizeOf(Byte));
end;

procedure TStringProperty.Store(var S:TStream);
begin
  inherited Store(S);
  S.Write(MaxLen, SizeOf(Byte));
end;

function TStringProperty.AsText:string;
begin
  AsText:=ConverStringToCtrlCode(PString(Info)^);
end;

procedure TStringProperty.EditProperty;
var S:String;
begin
  if ReadOnly then exit;
  S:=ConverStringToCtrlCode(PString(Info)^);
  if Assigned(OnBeforeEdit) then OnBeforeEdit(@Self, PViews);
  if Assigned(OnEdit) then OnEdit(@Self, PViews, ListBox)
  else
  if EditeDate(S, ListBox, MaxLen, nil) then
  begin
    S:=ConverCtrlCodeToString(S);
    move(S, PString(Info)^, MaxLen+1);
  end;
  if Assigned(OnAfterEdit) then OnAfterEdit(@Self, PViews);
end;

 { TBitMapProperty }
constructor TBitMapProperty.Init(AName:string; AOffset:Integer;AHelpCtx:word;
                         Item:PSItem; AEditValue:Longint);
var I:PSItem;
begin
  inherited Init('+'+AName, AOffset, AHelpCtx, false);
  Value:=New(PStrings, Init);
  while Item<>nil do
  begin
    Value^.Insert(Item^.Value);
    I:=Item;
    Item:=Item^.Next;
    Dispose(I);
  end;
  EditValue:=AEditValue;
end;

destructor TBitMapProperty.Done;
begin
  Dispose(Value, Done);
  if BitList<>nil then
  begin
    BitList^.DeleteAll;
    Dispose(BitList, Done);
  end;
  inherited Done;
end;

constructor TBitMapProperty.Load(var S:TStream);
begin
  inherited Load(S);
  S.Read(EditValue, SizeOf(Longint));
  Value:=PStrings(S.Get);
end;

procedure TBitMapProperty.Store(var S:TStream);
begin
  inherited Store(S);
  S.Write(EditValue, SizeOf(Longint));
  S.Put(Value);
end;

function TBitMapProperty.AsText:string;
var i:integer;
    S:string;
begin
  if BitList<>nil then S:='[' else S:='[';
  for I:=0 to Value^.Count-1 do
      if (i in PByteSet(Info)^) and (Value^.Str(i)<>'!') then S:=S+Value^.Str(i)+',';
  if Length(S)>2 then dec(s[0]);
  AsText:=S+']';
end;

procedure TBitMapProperty.EditProperty(ListBox:PListBox);
var P:PBitBolProperty;
    Pos,i:integer;
    W:longint;
function DoFind(P:Pointer):boolean;far;
begin
  DoFind:=P=@Self;
  inc(Pos);
end;
begin
  Pos:=-1;
  ListBox^.List^.FirstThat(@DoFind);
  if BitList<>nil then
  begin
    for I:=0 to Value^.Count-1 do
      if Value^.Str(i)<>'!' then
         ListBox^.List^.AtDelete(Pos+1);
    Dispose(BitList, Done);
    BitList:=nil;
    Name^[1]:='+';
  end
  else
  begin
    Name^[1]:='-';
    W:=1;
    BitList:=New(PCollection, Init(20,10));
    for I:=Value^.Count-1 downto 0 do
    if Value^.Str(i)<>'!' then
    begin
      P:=New(PBitBolProperty, Init('  '+Value^.Str(i),Offset,HelpCtx,i,
             (EditValue and (W shl i))<>0, @Self));
      P^.SetPointer(Obj, PViews);
      BitList^.Insert(P);
      ListBox^.List^.AtInsert(Pos+1,P);
    end;
  end;
  ListBox^.SetRange(ListBox^.List^.Count);
end;

  { TBitBolProperty }
constructor TBitBolProperty.Init(AName:string; AOffset:Integer;
                  AHelpCtx:word;ABitVal:byte; AReadOnly:boolean; AOwner:PBitMapProperty);
begin
  inherited Init(AName, AOffset, AHelpCtx, AReadOnly);
  BitVal:=ABitVal;
  Owner:=AOwner;
  OnGetText:=Owner^.OnGetText;
  OnEdit:=Owner^.OnEdit;
  OnBeforeEdit:=Owner^.OnBeforeEdit;
  OnAfterEdit:=Owner^.OnAfterEdit;
end;

function TBitBolProperty.AsText:string;
begin
  if BitVal in PByteSet(Info)^ then AsText:='true'
  else AsText:='false'
end;

procedure TBitBolProperty.EditProperty(ListBox:PListBox);
begin
  if ReadOnly then exit;
  if Assigned(OnBeforeEdit) then OnBeforeEdit(@Self, PViews);
  if Assigned(OnEdit) then OnEdit(@Self, PViews, ListBox)
  else
  if BitVal in PByteSet(Info)^ then PByteSet(Info)^:=PByteSet(Info)^-[BitVal]
  else PByteSet(Info)^:=PByteSet(Info)^+[BitVal];
  if Assigned(OnAfterEdit) then OnAfterEdit(@Self, PViews);
end;

  { TLockUpProperty }
constructor TLockUpProperty.Init(AName:string; AOffset:Integer; AHelpCtx:word;
                 Item:PSItem; AReadOnly:boolean;
                 AIntegerType:TNumericType; AIntegerShift:integer);
var I:PSItem;
begin
  TProperty.Init(AName, AOffset, AHelpCtx, AReadOnly);
  Value:=New(PStrings, Init);
  IntegerType:=AIntegerType;
  IntegerShift:=AIntegerShift;
  while Item<>nil do
  begin
    Value^.Insert(Item^.Value);
    I:=Item;
    Item:=Item^.Next;
    Dispose(I);
  end;
end;
constructor TLockUpProperty.Load(var S:TStream);
begin
  inherited Load(S);
  S.Read(IntegerType, SizeOf(TNumericType));
  S.Read(IntegerShift, SizeOf(integer));
end;

procedure TLockUpProperty.Store(var S:TStream);
begin
  inherited Store(S);
  S.Write(IntegerType, SizeOf(TNumericType));
  S.Write(IntegerShift, SizeOf(integer));
end;

function TLockUpProperty.AsText:string;
var L:integer;
begin
  case IntegerType of
       itShortint,itByte:L:=PByte(Info)^-IntegerShift;
       itInteger, itWord:L:=PInteger(Info)^-IntegerShift;
       itLongint:L:=PLongint(Info)^-IntegerShift;
  else
    L:=-1;
  end;
  if (L>-1) and (L<Value^.Count) then
     case IntegerType of
       itShortint,itByte:AsText:=Value^.Str(PByte(Info)^-IntegerShift);
       itInteger, itWord:AsText:=Value^.Str(PInteger(Info)^-IntegerShift);
       itLongint:AsText:=Value^.Str(PLongint(Info)^-IntegerShift);
     else
       AsText:='';
     end
  else AsText:='';
end;

procedure TLockUpProperty.EditProperty(ListBox:PListBox);
var P:PLockUpInputLine;
    R:TRect;
    L:longint;
    i:integer;
begin
  if ReadOnly then exit;
  if Assigned(OnBeforeEdit) then OnBeforeEdit(@Self, PViews);
  if Assigned(OnEdit) then OnEdit(@Self, PViews, ListBox)
  else
  with ListBox^ do
  begin
     R.Assign(Origin.X+Length(Name^)+2, Origin.Y+Focused-TopItem,
              Origin.X+Size.X, Origin.Y+Focused-TopItem+1);
     L:=0;
     case IntegerType of
       itShortint,itByte:L:=PByte(Info)^-IntegerShift;
       itInteger, itWord:L:=PInteger(Info)^-IntegerShift;
       itLongint:L:=PLongint(Info)^-IntegerShift;
     end;
     P:=New(PLockUpInputLine, Init(R,nil));
     for i:=0 to Value^.Count-1 do
           P^.List^.AtInsert(i, NewStr(Value^.Str(i)));
     P^.SetData(L);
     if ListBox^.Owner^.ExecView(P)=cmOk then
     begin
       P^.GetData(L);
       case IntegerType of
         itShortint,itByte:PByte(Info)^:=L+IntegerShift;
         itInteger, itWord:PInteger(Info)^:=L+IntegerShift;
         itLongint:PLongint(Info)^:=L+IntegerShift;
       end
     end;
     P^.Free;
  end;
  if Assigned(OnAfterEdit) then OnAfterEdit(@Self, PViews);
end;


  { TItegerProperty }
constructor TIntegerProperty.Init(AName:string; AOffset:Integer;
                     AHelpCtx:word; itType:TNumericType; AReadOnly:boolean);
begin
  inherited Init(AName,AOffset, AHelpCtx, AReadOnly);
  fResult.itType:=itType;
end;

constructor TIntegerProperty.Load(var S:TStream);
begin
  inherited Load(S);
  S.Read(fResult.itType, SizeOf(TNumericType));
end;

procedure TIntegerProperty.Store(var S:TStream);
begin
  inherited Store(S);
  S.Write(fResult.itType, SizeOf(TNumericType));
end;

function TIntegerProperty.AsText:string;
var L:Longint;
begin
  if Assigned(OnGetText) then AsText:=OnGetText(@Self, PViews)
  else
  begin
     with fResult do
     case itType of
        itShortint:L:=ShortIntResult^;
        itInteger:L:=IntResult^;
        itLongint:L:=LongResult^;
        itByte:L:=ByteResult^;
        itWord:L:=WordResult^;
        itChar:begin
                 AsText:=CharResult^;
                 exit;
               end;
        itDate:
               begin
                 AsText:=DateToStr(DateTimeResult^);
                 exit;
               end;
        itTime:
               begin
                 AsText:=TimeToStr(DateTimeResult^);
                 exit;
               end;
        itDouble:
               begin
                 AsText:=FloatToStr(DoubleResult^);
                 exit;
               end;
        itReal:
               begin
                 AsText:=FloatToStr(RealResult^);
                 exit;
               end;
        itInt16:L:=Int16Result^;
     end;
     AsText:=IntToStr(L);
  end;
end;

procedure TIntegerProperty.EditProperty;
var S:String;
    V:PValidator;
    MaxLen:integer;
begin
  if ReadOnly then exit;
  MaxLen:=255;
  V:=nil;
  case fResult.itType of
     itShortInt:begin
                  S:=IntToStr(fResult.ShortIntResult^);
                  V:=New(PRangeValidator, Init(-128,127));
                end;
     itInteger:begin
                  S:=IntToStr(fResult.IntResult^);
                  V:=New(PRangeValidator, Init(-32768,32767));
               end;
     itLongint:begin
                  S:=IntToStr(fResult.LongResult^);
                  V:=New(PRangeValidator, Init(-2147483647-1,2147483647));
               end;
     itByte:begin
               S:=IntToStr(fResult.ByteResult^);
               V:=New(PRangeValidator, Init(0,255));
            end;
     itWord:begin
               S:=IntToStr(fResult.WordResult^);
               V:=New(PRangeValidator, Init(0, 65535));
            end;
     itChar:begin
              S:=fResult.CharResult^;
              MaxLen:=1;
            end;
     itDate:begin
              S:=DateToStr(fResult.DateTimeResult^);
              V:=New(PDateValidatorEx, Init('!',true));
            end;
     itTime:begin
              S:=TimeToStr(fResult.DateTimeResult^);
              V:=New(PPXPictureValidator,
                 Init('{#[#]}'+TimeSeparator+'{#[#]}'+TimeSeparator+'{#[#]}',true))
            end;
     itDouble:begin
              S:=FloatToStr(fResult.DoubleResult^);
              V:=New(PFilterValidator, Init(['0'..'9','-','.',',']));
            end;
     itReal:begin
              S:=FloatToStr(fResult.RealResult^);
              V:=New(PFilterValidator, Init(['0'..'9','-','.',',']));
            end;
     itInt16:begin
              S:=IntToStr(fResult.Int16Result^);
              V:=New(PRangeValidator, Init(-32768,32767));
            end;
  end;
  if Assigned(OnBeforeEdit) then OnBeforeEdit(@Self, PViews);
  if Assigned(OnEdit) then OnEdit(@Self, PViews, ListBox)
  else
    if EditeDate(S, ListBox, MaxLen, V) then
    case fResult.itType of
       itShortint:fResult.ShortIntResult^:=StrToInt(S);
       itInteger:fResult.IntResult^:=StrToInt(S);
       itLongint:fResult.LongResult^:=StrToInt(S);
       itByte:fResult.ByteResult^:=StrToInt(S);
       itWord:fResult.WordResult^:=StrToInt(S);
       itChar:fResult.CharResult^:=S[1];
       itDate:fResult.DateTimeResult^:=StrToDate(S);
       itTime:fResult.DateTimeResult^:=StrToTime(S);
       itDouble:fResult.DoubleResult^:=StrToFloat(S);
       itReal:fResult.RealResult^:=StrToFloat(S);
       itInt16:fResult.int16Result^:=StrToInt(S);
    end;
  if Assigned(OnAfterEdit) then OnAfterEdit(@Self, PViews);
end;

procedure TIntegerProperty.SetPointer(P:Pointer; V:Pointer);
begin
  PViews:=V;
  Obj:=P;
{$IFDEF VER70}
  fResult.Result:=Ptr(PtrRec(P).Seg,PtrRec(P).Ofs+Offset+VMTOffset);
{$ELSE}
{$IFDEF VIRTUALPASCAL}
  fResult.Result:=Pointer(Longint(P)+Offset+VMTOffset);
{$ELSE}
  Error. not implimented.
  fResult.Result:=nil;
  abstract;
{$ENDIF}
{$ENDIF}
end;

  { TBoleanProperty }
function TBooleanProperty.AsText:string;
begin
  if PBoolean(Info)^ then AsText:='true'
  else AsText:='false'
end;

procedure TBooleanProperty.EditProperty(ListBox:PListBox);
begin
  if ReadOnly then exit;
  if Assigned(OnBeforeEdit) then OnBeforeEdit(@Self, PViews);
  if Assigned(OnEdit) then OnEdit(@Self, PViews, ListBox)
  else PBoolean(Info)^:=not PBoolean(Info)^;
  if Assigned(OnAfterEdit) then OnAfterEdit(@Self, PViews);
end;


 { TPStrCollectionProperty }
function TPStrCollectionProperty.AsText:string;
begin
  if PCollection(Info^)=nil then AsText:=NilName
  else AsText:='Items';
end;

procedure EditCollection(P:PCollection);
var Command,i,j:integer;
    S:string;
    Rec:PMemoRec;
procedure StoreCollections;
var i: integer;
begin
  P^.FreeAll;
  P^.Delta:=10;
  S:='';
  for i:=0 to Rec^.Length-1 do
    if Rec^.Text[i]<>#13 then  S:=S+Char(Rec^.Text[i])
    else
    begin
       if Trim(S)<>'' then
          P^.AtInsert(P^.Count, NewStr(Trim(S)));
       S:='';
       inc(i);
    end;
  if S<>'' then P^.AtInsert(P^.Count, NewStr(S));
  P^.Delta:=0;
end;

begin
   GetMem(Rec,4096+63);
   Rec^.Length:=0;
   if P^.Count<>0 then
   for i:=0 to P^.Count-1 do
   begin
     S:=PString(P^.At( i))^+#13#10;
     Move(S[1], Rec^.Text[Rec^.Length], Length(S));
     Rec^.Length:=Rec^.Length+Length(S);
   end;
   repeat
     command:=ExecDialog(sTextEditor, Rec);
     case command of
        cmOk:StoreCollections;
        cmYes:LoadText(Rec^.Length, PDialog(ResourseFile.Get(sOpenText)), sExtText);
        cmNo:SaveText(Rec^.Length, PDialog(ResourseFile.Get(sSaveText)), sExtText);
     end
   until (Command=cmOk) or (Command=cmCancel);
   FreeMem(Rec,4096+63);
end;

procedure TPStrCollectionProperty.EditProperty(ListBox:PListBox);
begin
  if ReadOnly then exit;
  EditCollection(PCollection(Info^));
end;
  { TTStrCollectionProperty }
function TTStrCollectionProperty.AsText:string;
begin
  AsText:='Items'
end;

procedure TTStrCollectionProperty.EditProperty(ListBox:PListBox);
begin
  if ReadOnly then exit;
  EditCollection(PCollection(Info));
end;

  { TLinkProperty }
constructor TLinkProperty.Init(AName:string; AOffset:Integer; AHelpCtx:word;
                               AValidSet:TTypeSet; ADeleteForAll:boolean; AReadOnly:boolean);
begin
  inherited Init(AName, AOffset, AHelpCtx, AReadOnly);
  ValidSet:=AValidSet;
  DeleteForAll:=ADeleteForAll;
end;

constructor TLinkProperty.Load(var S:TStream);
begin
  inherited Load(S);
  S.Read(ValidSet, SizeOf(TTypeSet));
  S.Read(DeleteForAll, SizeOf(Boolean));
end;

procedure TLinkProperty.Store(var S:TStream);
begin
  inherited Store(S);
  S.Write(ValidSet, SizeOf(TTypeSet));
  S.Write(DeleteForAll, SizeOf(Boolean));
end;

function TLinkProperty.AsText:string;
begin
  if PView(Info^)=nil then AsText:=''
  else AsText:=PView(Info^)^.ComponentName^;
end;

procedure TLinkProperty.EditProperty(ListBox:PListBox);
var P:PLockUpInputLine;
    R:TRect;
    L:longint;
    Form:PFormMain;
    V:PView;
    List:TListBoxRec;
begin
  if ReadOnly then exit;
  with ListBox^ do
  R.Assign(Origin.X+Length(Name^)+2, Origin.Y+Focused-TopItem,
           Origin.X+Size.X, Origin.Y+Focused-TopItem+1);
  Form:=ProjectCollection^.FindForm(PView(PViews)^.Owner);
  FillRecord( Form, PView(Info^), ValidSet, false, List);
  P:=New(PLockUpInputLine, Init(R,nil));
  L:=List.Selection;
  for l:=0 to PStrings(List.List)^.Count-1 do
        P^.List^.AtInsert(l, NewStr(PStrings(List.List)^.Str(L)));
  Dispose(PStrings(List.List), Done);
  P^.SetData(L);
  if ListBox^.Owner^.ExecView(P)=cmOk then
  begin
    if Trim(P^.Data^)='' then PView(Info^):=nil
    else
    begin
      V:=FindByName( Form, P^.Data^);
{      if DeleteForAll then DoDel(Form, V) else CaseDelete(PViews, V);}
      if DeleteForAll then Message(Form^.FormPtr, evBroadcast, cmDestroed, V)
      else Message(PViews, evBroadcast, cmDestroed, V);

      if Assigned(OnBeforeEdit) then OnBeforeEdit(@Self, PViews);
      if Assigned(OnEdit) then OnEdit(@Self, PViews, ListBox)
      else PView(Info^):=V;
      if Assigned(OnAfterEdit) then OnAfterEdit(@Self, PViews);

    end;
  end;
  P^.Free;
end;

  { TFunctionsProperty }
constructor TFunctionsProperty.Init(AName:string; AHelpCtx:word; AReadOnly:boolean;
                                    AGetProc, ASetProc:Pointer; AType:TFunType);
begin
  inherited Init(AName, 0, AHelpCtx, AReadOnly);
  GetProc:=AGetProc;
  SetProc:=ASetProc;
  fType:=AType;
end;

constructor TFunctionsProperty.Load(var S:TStream);
begin
  inherited Load(S);
  LoadProcedure(S,GetProc);
  LoadProcedure(S,SetProc);
  S.Read(fType, SizeOf(TFunType));
end;

procedure TFunctionsProperty.Store(var S:TStream);
begin
  inherited Store(S);
  StoreProcedure(S,GetProc);
  StoreProcedure(S,SetProc);
  S.Write(fType, SizeOf(TFunType));
end;
type
  TObjectGetCaller  = function(Sender:PView):int32;
  TObjectSetCaller  = procedure(Sender:PView; Info:int32);

function TFunctionsProperty.AsText:string;
var Rec:TFunResultRecord;
begin
  if GetProc<>nil then
  begin
  {$IFDEF VER70}
    asm
        LES     DI,Self
        PUSH    WORD PTR ES:[DI+2].TFunctionsProperty.PViews
        PUSH    WORD PTR ES:[DI].TFunctionsProperty.PViews
        CALL    ES:[DI].TFunctionsProperty.GetProc
        MOV     Rec.WORD[0], AX
        MOV     Rec.WORD[2], DX
    end;
  {$ELSE}
    {Rec.LongintResult:=TObjectGetCaller(GetProc)(PViews);}
    //Rec.LongintResult:=PDataSourse(PViews)^.LastRec;
  {$ENDIF}
    with Rec do
    case fType of
       fntBoolean:AsText:=BooleanToStr(BooleanResult);
       fntShortint:AsText:=IntToStr(ShortIntResult);
       fntInteger:AsText:=IntToStr(IntegerResult);
       fntLongint:AsText:=IntToStr(LongintResult);
       fntByte:AsText:=IntToStr(ByteResult);
       fntWord:AsText:=IntToStr(WordResult);
       fntChar:AsText:=CharResult;
    end
  end
  else
  AsText:='';
end;

procedure TFunctionsProperty.EditProperty(ListBox:PListBox);
var Rec:TFunResultRecord;
begin
  FillChar(Rec, SizeOf(TFunResultRecord), 0);
  if Assigned(OnEdit) then OnEdit(@Self, PViews, ListBox)
  else
  if SetProc<>nil then
  begin
    with Rec do
    case fType of
       fntBoolean:BooleanResult:=not StrToBoolean(AsText);
{       fntShortint:AsText:=IntToStr(ShortIntResult);
       fntInteger:AsText:=IntToStr(IntegerResult);
       fntLongint:AsText:=IntToStr(LongintResult);
       fntByte:AsText:=IntToStr(ByteResult);
       fntWord:AsText:=IntToStr(WordResult);
       fntChar:AsText:=CharResult;}
    end;
{$IFDEF VER70}
    asm
        LES     DI,Self
        CMP     ES:[DI].TFunctionsProperty.fType,fntLongint
        JB      @@1
        PUSH    Rec.WORD[2]
@@1:    PUSH    Rec.WORD[0]
        PUSH    WORD PTR ES:[DI+2].TFunctionsProperty.PViews
        PUSH    WORD PTR ES:[DI].TFunctionsProperty.PViews
        CALL    ES:[DI].TFunctionsProperty.SetProc
    end;
{$ENDIF}
  end;
end;

  { TPropertyCollections }
function TPropertyCollections.Compare(Key1, Key2: Pointer): Integer;
var PR1:PProperty absolute Key1;
    PR2:PProperty absolute Key2;
    S1,S2:string;
function DelSign(const S:string):string;
begin
  if (S[1]='-') or (S[1]='+') then DelSign:=Copy(S,2,255)
  else DelSign:=S;
end;

begin
   S1:=DelSign(stUpCase(PR1^.Name^));
   S2:=DelSign(stUpCase(PR2^.Name^));
   if S1<S2 then Compare:=-1
   else
   if S1>S2 then Compare:=1
   else Compare:=0;
end;

procedure RegisterProperty;
begin
  RegisterType(RProperty);
  RegisterType(RPStringProperty);
  RegisterType(RStringProperty);
  RegisterType(RIntegerProperty);
  RegisterType(RBitMapProperty);
  RegisterType(RBooleanProperty);
  RegisterType(RLockUpProperty);
  RegisterType(RPStrCollectionProperty);
  RegisterType(RTStrCollectionProperty);
  RegisterType(RLinkProperty);
  RegisterType(RPropertyCollections);
  RegisterType(RFunctionsProperty);
end;

end.
