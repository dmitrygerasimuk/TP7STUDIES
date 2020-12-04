{$O+}
{$I Define.inc}
unit DBConstr;
interface
uses Objects, Drivers, Views, DAE, Dialogs, TVForms;
type
  PLinkRecord = ^TLinkRecord;
  TLinkRecord = record
    Start:TPoint;
    Stop:TPoint;
    Master:PDataSet;
    Second:PDataSet;
    Next:PLinkRecord;
  end;

type
  PDBConstBkgrnd = ^TDBConstBkgrnd;
  PDBConstDataSet = ^TDBConstDataSet;

  PDBConstructor = ^TDBConstructor;
  TDBConstructor = object(TForm)
    LinkRecord:PLinkRecord;
    DBConstBkgrnd:PDBConstBkgrnd;
    DBConstDataSets:PCollection;
    constructor Init;
    destructor Done;virtual;
    procedure UpdateMasterPos;
    procedure HandleEvent(var Event:TEvent);virtual;
    procedure NewDataSet(A:FNameStr);
  end;

  TDBConstBkgrnd = object(TView)
    constructor Init(var R:TRect);
    constructor Load(var S:TStream);
    destructor Done;virtual;
    procedure Draw;virtual;
    procedure ChangeBounds(var Bounds: TRect); virtual;
    procedure ReDrawLinks;
    procedure SetState(AState: Word; Enable: Boolean); virtual;
  private
    DrawBuf:PWordArray;
    BufSize:Word;
    procedure DrawSpishialChar(X,Y:integer; c:char);
  end;

  TDBConstDataSet = object(TView)
    DataSet:PDataSet;
    constructor Init(var Bounds:TRect; ADataSet:PDataSet);
    destructor Done;virtual;
    procedure Draw;virtual;
    procedure HandleEvent(var Event:TEvent);virtual;
  end;

type
  PDBConstructorLabel = ^TDBConstructorLabel;
  TDBConstructorLabel = object(TLabel)
    procedure DragLinkView(Event: TEvent; Mode: Byte;
              var Limits: TRect; MinSize, MaxSize: TPoint);
    procedure HandleEvent(var Event:TEvent);virtual;
    procedure RecalcBounds;
    procedure Draw;virtual;
  end;

function NewLinkRecord(Next:PLinkRecord; DS:PDataSet):PLinkRecord;
const
  RDBConstructor: TStreamRec = (
     ObjType: 20100;
     VmtLink: Ofs(TypeOf(TDBConstructor)^);
     Load:    @TDBConstructor.Load;
     Store:   @TDBConstructor.Store
  );
const
  RDBConstBkgrnd: TStreamRec = (
     ObjType: 20101;
     VmtLink: Ofs(TypeOf(TDBConstBkgrnd)^);
     Load:    @TDBConstBkgrnd.Load;
     Store:   @TDBConstBkgrnd.Store
  );
const
  RDBConstDataSet: TStreamRec = (
     ObjType: 20102;
     VmtLink: Ofs(TypeOf(TDBConstDataSet)^);
     Load:    @TDBConstDataSet.Load;
     Store:   @TDBConstDataSet.Store
  );
const
  RDBConstructorLabel: TStreamRec = (
     ObjType: 20103;
     VmtLink: Ofs(TypeOf(TDBConstructorLabel)^);
     Load:    @TDBConstructorLabel.Load;
     Store:   @TDBConstructorLabel.Store
  );

procedure RegisterDBConstructor;
implementation
uses App, Ext_Math, DBFTable, Ext_Type, Menus, ResTools, ResStrs, El_Lists;

function NewLinkRecord(Next:PLinkRecord; DS:PDataSet):PLinkRecord;
var P:PLinkRecord;
begin
  New(P);
  P^.Next:=Next;
  if (DS<>nil) and (DS^.Master<>nil) and (DS^.MasterField<>nil) then
  begin
    P^.Master:=DS^.Master;
    P^.Second:=DS;
  end;
  NewLinkRecord:=P;
end;

  { TDBConstructor }
constructor TDBConstructor.Init;
var R:TRect;
    P:PView;
    D,MasterD:PDbfTable;
begin
  Desktop^.GetExtent(R);
  inherited Init(R, 'TDBConstructor');
  GetExtent(R);
  R.Grow(-1,-1);
  DBConstBkgrnd:=Insert(New(PDBConstBkgrnd, Init(R)));
  DBConstDataSets:=New(PCollection, Init(10,5));

  R.Assign(31,2,44,6);
  MasterD:=New(PDbfTable, Init('aa2', stOpen));
  MasterD^.OpenIndex('aa2');
  P:=Insert(New(PDBConstDataSet, Init(R, MasterD)));
  DBConstDataSets^.Insert(P);
  R.Assign(31,1,44,2);
  Insert(New(PDBConstructorLabel, Init(R,'AA2.DBF',P)));

  R.Assign(1,2,14,6);
  D:=New(PDbfTable, Init('aa1', stOpen));
  D^.OpenIndex('aa1');
  D^.SetMaster(MasterD, 'COD_POSTAV');
  P:=Insert(New(PDBConstDataSet, Init(R, D)));
  DBConstDataSets^.Insert(P);
  R.Assign(1,1,14,2);
  Insert(New(PDBConstructorLabel, Init(R,'AA1.DBF',P)));

  LinkRecord:=NewLinkRecord(LinkRecord, D);

  R.Assign(1,11,14,16);
  D:=New(PDbfTable, Init('aa3', stOpen));
  P:=Insert(New(PDBConstDataSet, Init(R, D)));
  DBConstDataSets^.Insert(P);
  R.Assign(1,10,14,11);
  Insert(New(PDBConstructorLabel, Init(R,'AA1.DBF',P)));

  UpdateMasterPos;
  DBConstBkgrnd^.ReDrawLinks;
end;

destructor TDBConstructor.Done;
procedure DoDisposeLinks(P:PLinkRecord);
begin
  if P=nil then exit;
  DoDisposeLinks(P^.Next);
  Dispose(P);
end;
begin
  DoDisposeLinks(LinkRecord);
  Dispose(DBConstDataSets, Done);
  inherited Done;
end;

procedure TDBConstructor.UpdateMasterPos;
var P:PLinkRecord;
    M,S:PDBConstDataSet;
    I:integer;
function DoFindMaster(VV:PDBConstDataSet):Boolean;far;
begin
  DoFindMaster:=P^.Master=VV^.DataSet;
end;
function DoFindSecond(VV:PDBConstDataSet):Boolean;far;
begin
  DoFindSecond:=P^.Second=VV^.DataSet;
end;
begin
  P:=LinkRecord;
  while P<>nil do
  begin
    M:=DBConstDataSets^.FirstThat(@DoFindMaster);
    S:=DBConstDataSets^.FirstThat(@DoFindSecond);
    P^.Start:=M^.Origin;
    P^.Stop:=S^.Origin;
    if M^.Origin.X=S^.Origin.X then
    begin
       Dec(P^.Start.X);
       Dec(P^.Stop.X);
    end
    else
    if M^.Origin.X+M^.Size.X<S^.Origin.X then
       P^.Start.X:=P^.Start.X+M^.Size.X
    else
    if M^.Origin.X>S^.Origin.X+S^.Size.Y then
       P^.Stop.X:=P^.Stop.X+S^.Size.X;
    for i:=0 to M^.DataSet^.FieldDefs^.Count-1 do
      if M^.DataSet^.Fields(i)^.Name^=S^.DataSet^.MasterField^.Name^ then break
      else inc(P^.Start.Y);
    P:=P^.Next;
  end;
end;

procedure TDBConstructor.HandleEvent(var Event:TEvent);
begin
  inherited HandleEvent(Event);
end;

procedure TDBConstructor.NewDataSet(A:FNameStr);
var S:FNameStr;
    D:PDataSet;
    R:TRect;
    P:PView;
begin
  R.Assign(1,2,14,6);
  D:=New(PDbfTable, Init(A, stOpen));
  P:=Insert(New(PDBConstDataSet, Init(R, D)));
  DBConstDataSets^.Insert(P);
  R.Assign(1,1,14,2);
  Insert(New(PDBConstructorLabel, Init(R,D^.TableName^,P)));
end;

 { TDBConstructorLabel }

procedure TDBConstructorLabel.Draw;
var
  Color: Word;
  B: TDrawBuffer;
begin
    Color := 107;
  MoveChar(B[0], ' ', Byte(Color), Size.X);
  if Text <> nil then MoveCStr(B[1], Text^, 107);
  MoveChar(B[Size.X-2], #$04, 106, 2);
  WriteLine(0, 0, Size.X, 1, B);
end;

procedure TDBConstructorLabel.HandleEvent(var Event:TEvent);
var
  Mouse: TPoint;

procedure DragWindow(Mode: Byte);
var
  Limits: TRect;
  Min, Max: TPoint;
begin
  if Link=nil then exit;
  Link^.Owner^.GetExtent(Limits);
  Link^.SizeLimits(Min, Max);
  DragLinkView(Event, Link^.DragMode or Mode, Limits, Min, Max);
  ClearEvent(Event);
  RecalcBounds;
end;

begin
  TView.HandleEvent(Event);
  case Event.What of
    evMouseDown:begin
                  MakeLocal(Event.Where, Mouse);
                  if (State and sfActive <> 0) then
                    if (Mouse.X >= Size.X - 2) then
                     DragWindow(dmDragGrow)
                    else
                     DragWindow(dmDragMove);
                end;
  end;
end;

procedure TDBConstructorLabel.DragLinkView(Event: TEvent; Mode: Byte;
        var Limits: TRect; MinSize, MaxSize: TPoint);
var
  P, S: TPoint;
  SaveBounds: TRect;

procedure MoveGrow(P, S: TPoint);
var
  R: TRect;
begin
  with Link^ do
  begin
     S.X := Min(Max(S.X, MinSize.X), MaxSize.X);
     S.Y := Min(Max(S.Y, MinSize.Y), MaxSize.Y);
     P.X := Min(Max(P.X, Limits.A.X - S.X + 1), Limits.B.X - 1);
     P.Y := Min(Max(P.Y, Limits.A.Y - S.Y + 1), Limits.B.Y - 1);
     if Mode and dmLimitLoX <> 0 then P.X := Max(P.X, Limits.A.X);
     if Mode and dmLimitLoY <> 0 then P.Y := Max(P.Y, Limits.A.Y);
     if Mode and dmLimitHiX <> 0 then P.X := Min(P.X, Limits.B.X - S.X);
     if Mode and dmLimitHiY <> 0 then P.Y := Min(P.Y, Limits.B.Y - S.Y);
     if P.X<0 then P.X:=0;
     if (P.X+S.X<Owner^.Size.X+1) and (P.Y+S.Y<Owner^.Size.Y+1) then
     begin
       R.Assign(P.X, P.Y, P.X + S.X, P.Y + S.Y);
       Locate(R);
     end;
  end;
  RecalcBounds;
end;

procedure Change(DX, DY: Integer);
begin
  if (Mode and dmDragMove <> 0) and (GetShiftState and $03 = 0) then
  begin
    Inc(P.X, DX);
    Inc(P.Y, DY);
  end else
  if (Mode and dmDragGrow <> 0) and (GetShiftState and $03 <> 0) then
  begin
    Inc(S.X, DX);
    Inc(S.Y, DY);
  end;
end;

procedure Update(X, Y: Integer);
begin
  if Mode and dmDragMove <> 0 then
  begin
    P.X := X;
    P.Y := Y;
  end;
end;

begin
   with Link^ do
   begin
     if Event.What = evMouseDown then
     begin
       if Mode and dmDragMove <> 0 then
       begin
         P.X := Origin.X - Event.Where.X;
         P.Y := Origin.Y - Event.Where.Y;
         repeat
           Inc(Event.Where.X, P.X);
           Inc(Event.Where.Y, P.Y);
           MoveGrow(Event.Where, Size);
         until not MouseEvent(Event, evMouseMove);
       end else
       begin
         P.X := Size.X - Event.Where.X;
         P.Y := Link^.Size.Y - Event.Where.Y;
         repeat
           Inc(Event.Where.X, P.X);
           Inc(Event.Where.Y, P.Y);
           MoveGrow(Origin, Event.Where);
         until not MouseEvent(Event, evMouseMove);
       end;
     end
     else
     begin
          P := Origin;
          S := Size;
          case Event.KeyCode and $FF00 of
            kbLeft: Change(-1, 0);
            kbRight: Change(1, 0);
            kbUp: Change(0, -1);
            kbDown: Change(0, 1);
          end;
          MoveGrow(P, S);
      end;
  end;
end;

procedure TDBConstructorLabel.RecalcBounds;
var
  AX,AY,BX,BY:Byte;
  R:TRect;
begin
   AX:=Link^.Origin.X;
   AY:=Link^.Origin.Y-1;
   BX:=Link^.Size.X+Link^.Origin.X;
   if (BX-AX)<3 then BX:=AX+3;
   R.Assign(AX,AY,BX,AY+1);
   ChangeBounds(R);
   PDBConstructor(Owner)^.UpdateMasterPos;
   PDBConstructor(Owner)^.DBConstBkgrnd^.ReDrawLinks;
   Owner^.Redraw;
end;

 { TDBConstDBDataSet }

constructor TDBConstDataSet.Init(var Bounds:TRect; ADataSet:PDataSet);
begin
  inherited Init(Bounds);
  DataSet:=ADataSet;
  Options:=Options+ofTopSelect;
end;

destructor TDBConstDataSet.Done;
begin
  inherited Done;
  if DataSet<>nil then DataSet^.Free;
end;

procedure TDBConstDataSet.Draw;
var
  Color, iColor: Word;
  B: TDrawBuffer;
  i:integer;
  S:String;
begin
  Color:=63;
  iColor:=46;
  if DataSet<>nil then
  begin
    for i:=0 to Min(DataSet^.FieldDefs^.Count-1,Size.Y) do
    begin
      S:=Copy(DataSet^.Fields(i)^.Name^, 1, Size.X-2);
      if DataSet^.Fields(i)^.IsIndexField then
      begin
         MoveChar(B[0], ' ', iColor, Size.X);
         MoveCStr(B[1], S, iColor)
      end
      else
      begin
        MoveChar(B[0], ' ', Color, Size.X);
        MoveCStr(B[1], S, Color);
      end;
      WriteLine(0, i, Size.X, 1, B);
    end;
    if DataSet^.FieldDefs^.Count<Size.Y then
    begin
      MoveChar(B[0], ' ', Color, Size.X);
      WriteLine(0, DataSet^.FieldDefs^.Count, Size.X, Size.Y-DataSet^.FieldDefs^.Count, B);
    end;
  end
  else
  begin
    MoveChar(B[0], ' ', Color, Size.X);
    WriteLine(0, 0, Size.X, Size.Y, B);
  end;
end;

procedure TDBConstDataSet.HandleEvent(var Event:TEvent);
procedure SelectMaster;
var D:PDialog;
    V:PElementGroupList;
    I,j:integer;
function DoAdd(A:PDBConstDataSet):boolean;far;
var
  Group: PElementGroup;
function DoSubAdd(F:PField):boolean;far;
var
  Item: PElementItem;
begin
  New(Item);
  Item^.Name := NewStr(F^.Name^);
  Item^.Next := Group^.Items;
  Group^.Items := Item;
  DoSubAdd:=false;
end;
begin
  if A<>@Self then
  begin
    Dec(i);
    New(Group);
    Group^.Name := NewStr(A^.DataSet^.TableName^);
    Group^.Items := nil;
    Group^.Index:=0;
    Group^.Next := V^.Groups;
    V^.Groups:=Group;
    A^.DataSet^.FieldDefs^.LastThat(@DoSubAdd);
    if DataSet^.Master=A^.DataSet then
    begin
      j:=i;
      Group^.Index:=A^.DataSet^.FieldDefs^.IndexOf(DataSet^.MasterField);
    end;
  end;
  DoAdd:=false;
end;
begin
   D:=PDialog(ResourseFile.Get(sSelectMaster));
   V:=D^.FindComponent('DatsSetsList');
   i:=PDBConstructor(Owner)^.DBConstDataSets^.Count-1;j:=0;
   PDBConstructor(Owner)^.DBConstDataSets^.LastThat(@DoAdd);
   V^.SetRange(PDBConstructor(Owner)^.DBConstDataSets^.Count-1);
   V^.FocusItem(j);
   Desktop^.ExecView(D);
   D^.Free;
end;
begin
  inherited HandleEvent(Event);
  if (Event.What=evMouseDown) and Event.Double then SelectMaster;
end;

 { TDBConstBkgrnd }
constructor TDBConstBkgrnd.Init(var R:TRect);
begin
  inherited Init(R);
  GrowMode := gfGrowHiX + gfGrowHiY;
  BufSize:=Size.X*Size.Y*SizeOf(Word);
  GetMem(DrawBuf, BufSize);
end;

destructor TDBConstBkgrnd.Done;
begin
  FreeMem(DrawBuf, BufSize);
  inherited Done;
end;

constructor TDBConstBkgrnd.Load(var S:TStream);
begin
  inherited Load(S);
  BufSize:=Size.X*Size.Y*SizeOf(Word);
  GetMem(DrawBuf, BufSize);
  ReDrawLinks;
end;

procedure TDBConstBkgrnd.Draw;
begin
  WriteBuf(0, 0, Size.X, Size.Y, DrawBuf^);
end;

procedure TDBConstBkgrnd.ChangeBounds(var Bounds: TRect);
var P:PWordArray;
begin
  FreeMem(DrawBuf, BufSize);
  SetBounds(Bounds);
  BufSize:=Size.X*Size.Y*SizeOf(Word);
  GetMem(DrawBuf, BufSize);
  ReDrawLinks;
  DrawView;
end;

procedure TDBConstBkgrnd.SetState(AState: Word; Enable: Boolean);
begin
  inherited SetState(AState, Enable);
  if (AState=sfExposed) and Enable then
     ReDrawLinks;
end;

procedure TDBConstBkgrnd.DrawSpishialChar(X,Y:integer; c:char);assembler;
asm
{   LES  DI,Self
   CMP  X,0
   JL   @@End
   MOV  AX,ES:[DI].TDBConstBkgrnd.Size.X
   DEC  AX
   CMP  X,AX
   JG   @@End
   CMP  Y,0
   JL   @@End
   MOV  AX,ES:[DI].TDBConstBkgrnd.Size.Y
   DEC  AX
   CMP  Y,AX
   JG   @@End
   MOV  AX,Y
   MOV  BX,ES:[DI].TDBConstBkgrnd.Size.X
   MUL  BX
   ADD  AX,X
   SHL  AX,1
   LES  DI,ES:[DI].TDBConstBkgrnd.DrawBuf
   ADD  DI,AX
   MOV  AL,C
   MOV  ES:[DI],AL
@@End:}
end;

procedure TDBConstBkgrnd.ReDrawLinks;
var
  Color: Word;

procedure DrawLine(A,B:TPoint);
procedure DrawH(AX,BX,Y:integer);
var i:integer;
begin
  if AX<BX then for i:=AX to BX do DrawSpishialChar(i,Y,'Ä')
  else for i:=AX downto BX do DrawSpishialChar(i,Y,'Ä');
end;
procedure DrawV(X,AY,BY:integer);
var i:integer;
begin
  if AY<BY then for i:=AY to BY do DrawSpishialChar(X,i,'³')
  else for i:=AY downto BY do DrawSpishialChar(X,i,'³');
end;

var i:integer;
    C1,C2:Char;
begin
  //Longint(A):=Longint(A)-$00010001;
  //Longint(B):=Longint(B)-$00010001;
  if A.Y<>B.Y then
  begin
    i:=(A.X+B.X) div 2;
    DrawH(A.X,i,A.Y);
    DrawV(i,A.Y,B.Y);
    if A.Y<B.Y then
       if A.X<I then
       begin
         C1:='¿';
         C2:='À';
       end
       else
       begin
         C1:='Ú';
         C2:='Ù';
       end
    else
       if A.X<I then
       begin
         C2:='Ú';
         C1:='Ù'
       end
       else
       begin
         C2:='¿';
         C1:='À';
       end;
    DrawSpishialChar(i,A.Y,C1);
    DrawSpishialChar(i,B.Y,C2);
    if (A.X=B.X) and (A.Y<>B.Y) then
       DrawSpishialChar(A.X,B.Y,'À')
    else
    begin
      if A.X>B.X then A.X:=i-1 else A.X:=I+1;
      DrawH(A.X,B.X,B.Y);
    end;
  end
  else DrawH(A.X,B.X,B.Y);
end;
var P:PLinkRecord;
begin
  Color := GetColor($0301);
  MoveChar(DrawBuf^, ' ', Byte(Color), Size.X*Size.Y);
  P:=PDBConstructor(Owner)^.LinkRecord;
  while P<>nil do
  begin
    DrawLine(P^.Start,P^.Stop);
    P:=P^.Next;
  end;
end;

procedure RegisterDBConstructor;
begin
  RegisterType(RDBConstructor);
  RegisterType(RDBConstBkgrnd);
  RegisterType(RDBConstDataSet);
  RegisterType(RDBConstructorLabel);
end;
end.
