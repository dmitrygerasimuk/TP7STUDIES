{$O+}
unit FormWrt;
interface
uses Register, Objects, Views, Clases, Storage;


procedure WriteView(Sender:PWriter; View:PView);far;
procedure WriteDialog(Sender:PWriter; View:PView);far;
procedure WriteStaticText(Sender:PWriter; View:PView);far;
procedure WriteButton(Sender:PWriter; View:PView);far;
procedure WriteInputLine(Sender:PWriter; View:PView);far;
procedure WriteLabel(Sender:PWriter; View:PView);far;
procedure WriteParamText(Sender:PWriter; View:PView);far;
procedure WriteScrollBar(Sender:PWriter; View:PView);far;
procedure WriteInputLinePS(Sender:PWriter; View:PView);far;
procedure WriteRangeILine(Sender:PWriter; View:PView);far;
procedure WriteColorText(Sender:PWriter; View:PView);far;
procedure WriteLockUpInputLine(Sender:PWriter; View:PView);far;
procedure WriteDateEdit(Sender:PWriter; View:PView);far;
procedure WriteDBGrid(Sender:PWriter; View:PView);far;
procedure WriteDataScroller(Sender:PWriter; View:PView);far;
procedure WriteCluster(Sender:PWriter; View:PView);far;
procedure WriteMultiCheckBoxes(Sender:PWriter; View:PView);far;
procedure WriteDBText(Sender:PWriter; View:PView);far;
procedure WriteDBLockUpText(Sender:PWriter; View:PView);far;
procedure WriteDBCluster(Sender:PWriter; View:PView);far;
procedure WriteDBCheckBox(Sender:PWriter; View:PView);far;
procedure WriteDBEdit(Sender:PWriter; View:PView);far;
procedure WriteDBDateEdit(Sender:PWriter; View:PView);far;
procedure WriteDBNavigatorBtn(Sender:PWriter; View:PView);far;
procedure WriteDBMemo(Sender:PWriter; View:PView);far;
procedure WriteDBSourse(Sender:PWriter; View:PView);far;
procedure WriteVirtualDataSet(Sender:PWriter; View:PView);
procedure WriteReportBand(Sender:PWriter; View:PView);
procedure WriteReport(Sender:PWriter; View:PView);
procedure WriteReportLabel(Sender:PWriter; View:PView);
procedure WriteReportMemo(Sender:PWriter; View:PView);
procedure WriteReportShape(Sender:PWriter; View:PView);

procedure ReadView(Sender:PReader;var View:PView; Name:string);
{procedure ReadGroup(Stream:PStream;var View:PView);}
procedure ReadDialog(Sender:PReader;var View:PView; Name:string);far;
procedure ReadStaticText (Sender:PReader;var View:PView; Name:string);far;
procedure ReadParamText(Sender:PReader;var View:PView; Name:string);far;
procedure ReadButton(Sender:PReader;var View:PView; Name:string);far;
procedure ReadLabel(Sender:PReader;var View:PView; Name:string);far;
procedure ReadInputLine(Sender:PReader;var View:PView; Name:string);far;
procedure ReadInputLinePS(Sender:PReader;var View:PView; Name:string);far;
procedure ReadRangeILine(Sender:PReader;var View:PView; Name:string);far;
procedure ReadScrollBar(Sender:PReader;var View:PView; Name:string);far;
procedure ReadColorText(Sender:PReader;var View:PView; Name:string);far;
procedure ReadLockUpInputLine(Sender:PReader;var View:PView; Name:string);far;
procedure ReadDateEdit(Sender:PReader;var View:PView; Name:string);far;

{Assign proc's}
procedure AssignLabel(V:PView; Owner:PGroup);far;

implementation
uses Ext_Str, Ext_Dos, Ext_Math, Global, ResTools, ResStrs, GlType, Dialogs,
     App, AddCntrl, DAE, DataCtrl, DBCtrls, DBGrids, Reports;



{
procedure DoAssignGroup(V:PView; Owner:PGroup);
var Node:PReadWriteRecord;
    P:PGroup absolute V;
    V1:PView;
begin
  Node:=FindNode(V^.ComponentType);
  if (Node<>nil) and Assigned(Node^.DoAssign) then Node^.DoAssign(V, Owner);
  if (V^.ComponentType in GroupControl+[ctWindow, ctDialog]) then
  if P^.Last <> nil then
  begin
     V1 := P^.Last;
     repeat
       if not (V1^.ComponentType in SystemTypeSet) then
          DoAssignGroup(V1,Owner);
       V1 := V1^.Prev;
     until V1 = P^.Last;
  end;
end;

procedure AssignPointers(V:PView);
begin
  if (V<>nil) and (V^.ComponentType in GroupControl+[ctWindow, ctDialog]) then
     DoAssignGroup(V, PGroup(V));
end;}

 {TView}
procedure WriteView(Sender:PWriter; View:PView);
begin
  Sender^.Write('object '+View^.ComponentName^+':T'+NameComponentType(View));
  with View^, Sender^ do
  begin
    WriteInteger('Origin.X',Origin.X);
    WriteInteger('Origin.Y',Origin.Y);
    WriteInteger('Size.X',Size.X);
    WriteInteger('Size.Y',Size.Y);
    WriteInteger('HelpCtx',HelpCtx);
    WriteHex('EventMask',EventMask,4);
    WriteHex('GrowMode',GrowMode,4);
    WriteHex('DragMode',DragMode,4);
    WriteHex('Options',Options,4);
  end;
end;

  {TDialog}
procedure WriteDialog(Sender:PWriter; View:PView);
begin
  WriteView(Sender, View);
  with PDialog(View)^, Sender^ do
  begin
    WriteHex('Flags ',Flags,2);
    WriteHex('Number ',Number,4);
    WriteHex('Palette ',Palette,4);
    WritePString('Title ',Title);
  end;
  Sender^.WriteGroup(PDialog(View));
end;

  {TStaticText}
procedure WriteStaticText(Sender:PWriter; View:PView);
begin
  WriteView(Sender, View);
  with PStaticText(View)^ do
    Sender^.WritePString('Text',Text);
end;
  {TLabel}
procedure WriteLabel(Sender:PWriter; View:PView);
begin
  WriteStaticText(Sender, View);
  Sender^.WriteLink('Link',PLabel(View)^.Link);
end;

  {TParamText}
procedure WriteParamText(Sender:PWriter; View:PView);
begin
  WriteStaticText(Sender, View);
  with PParamText(View)^ do
    Sender^.WriteInteger('ParamCount',ParamCount);
end;

  {TCluster}
procedure WriteCluster(Sender:PWriter; View:PView);
var Cluster:PCluster absolute View;
begin
  WriteView(Sender, View);
  with Cluster^ do
  begin
    Sender^.WriteInteger('Value',Value);
    Sender^.WriteInteger('Sel',Sel);
    Sender^.WriteHex('EnableMask',EnableMask, 8);
    Sender^.WriteStringCollection('Strings', @Strings);
  end;
end;

  {TMultiCheckBoxes}
procedure WriteMultiCheckBoxes(Sender:PWriter; View:PView);
var Cluster:PMultiCheckBoxes absolute View;
begin
  WriteCluster(Sender, View);
  with Cluster^ do
  begin
    Sender^.WriteInteger('SelRange',SelRange);
    Sender^.WriteHex('Flags', Flags, 4);
    Sender^.WritePString('States',States);
  end;
end;

  {TButton}
procedure WriteButton(Sender:PWriter; View:PView);
var Button:PButton absolute View;
begin
  WriteView(Sender, View);
  with Button^, Sender^ do
  begin
    WritePString('Title',Title);
    WriteHex('Command',Command,4);
    WriteHex('Flags',Flags,2);
  end;
end;

procedure WriteInputLine(Sender:PWriter; View:PView);
var Line:PInputLine absolute View;
begin
  WriteView(Sender, View);
  with Line^, Sender^ do
  begin
    WriteInteger('MaxLen',MaxLen);
    WriteString('Data',Line^.Data^);
  end;
end;

  {TInputLinePS}
procedure WriteInputLinePS(Sender:PWriter; View:PView);
var Line:PInputLinePS absolute View;
begin
  WriteInputLine(Sender, View);
  Sender^.WriteString('PassChar',Line^.PassChar);
end;

 {TRangeILine}
procedure WriteRangeILine(Sender:PWriter; View:PView);
var Line:PRangeILine absolute View;
begin
  WriteInputLine(Sender, View);
  with Line^, Sender^ do
  begin
    WriteInteger('Min ',Line^.Min);
    WriteInteger('Max ',Line^.Max);
  end;
end;

 {TScrollBar}
procedure WriteScrollBar(Sender:PWriter; View:PView);
var V:PScrollBar absolute View;
begin
  WriteView(Sender, View);
  with Sender^, V^ do
  begin
    WriteInteger('Value',V^.Value);
    WriteInteger('Min',V^.Min);
    WriteInteger('Max',V^.Max);
    WriteInteger('PgStep',PgStep);
    WriteInteger('ArStep',ArStep);
  end;
end;

 {TColorText}
procedure WriteColorText(Sender:PWriter; View:PView);
var V:PColorText absolute View;
begin
  WriteView(sender, View);
  with V^, Sender^ do
  begin
    WriteHex('Color',Color,2);
    WritePString('Text',Text);
  end;
end;

  {TLockUpInputLine}
procedure WriteLockUpInputLine(Sender:PWriter; View:PView);
var Line:PLockUpInputLine absolute View;
begin
  WriteInputLine(Sender, View);
  Sender^.WriteStringCollection('List',Line^.List);
end;

   {TDateEdit}
procedure WriteDateEdit(Sender:PWriter; View:PView);
var Line:PDateEdit absolute View;
begin
  WriteInputLine(Sender, View);
  Sender^.WritePString('DisplayFormat', Line^.DisplayFormat);
end;

  {TDataScroller}
procedure WriteDataScroller(Sender:PWriter; View:PView);
var DataScroller:PDataScroller absolute View;
begin
  WriteView(Sender, View);
  with DataScroller^,Sender^ do
  begin
    WriteLink('DataSourse', DataSourse);
    WriteInteger('TopItem', PgStep);
    WriteInteger('ArStep', ArStep);
  end;
end;

{ TDBGrid }
procedure WriteDBGrid(Sender:PWriter; View:PView);
var DBGrid:PDBGrid absolute View;
begin
  WriteView(Sender, View);
  with DBGrid^,Sender^ do
  begin
    WriteLink('DataScroller', DataScroller);
    WriteLink('DataSourse', DataSourse);
    WriteLink('ScrollBar', ScrollBar);
    WriteInteger('TopItem', TopItem);
    WriteInteger('Focused',Focused);
    WriteInteger('Delta.X',Delta.X);
    WriteInteger('Delta.Y',Delta.Y);
    WriteInteger('CurPos.X',CurPos.X);
    WriteInteger('CurPos.Y',CurPos.Y);
{    DBGridOptions: TDBGridOptions;}
  end;
end;

  {TDBText}
procedure WriteDBText(Sender:PWriter; View:PView);
var DBText:PDBText absolute View;
begin
  WriteStaticText(Sender, View);
  with DBText^,Sender^ do
  begin
    WriteLink('DS',DS);
    WritePString('FieldName',FieldName);
{    DisplayType:TDisplayType;}
  end;
end;

  {TDBLockUpText}
procedure WriteDBLockUpText(Sender:PWriter; View:PView);
var DBLockUpText:PDBLockUpText absolute View;
begin
  WriteDBText(Sender, View);
  Sender^.WriteStringCollection('Items', DBLockUpText^.Items);
end;

  {TDBCluster}
procedure WriteDBCluster(Sender:PWriter; View:PView);
var Cluster:PDBCluster absolute View;
begin
  WriteCluster(Sender, View);
  with Cluster^,Sender^ do
  begin
    WriteLink('DS',DS);
    WritePString('FieldName',FieldName);
    WriteBoolean('ReadOnly',ReadOnly);
  end;
end;

  {TDBCheckBox}
procedure WriteDBCheckBox(Sender:PWriter; View:PView);
var Cluster:PDBCheckBox absolute View;
begin
  WriteCluster(Sender, View);
  with Cluster^,Sender^ do
  begin
    WritePString('ValueChecked',ValueChecked);
    WritePString('ValueUnchecked',ValueUnchecked);
  end;
end;

  {TDBLookupCombo}
procedure WriteDBLookupCombo(Sender:PWriter; View:PView);
var DBLookupCombo:PDBLookupCombo absolute View;
begin
  WriteView(Sender, View);
  with DBLookupCombo^,Sender^ do
  begin
    WriteLink('DataSourse', DataSourse);
    WriteLink('LookupSourse', LookupSourse);
    WritePString('DataFieldName',DataFieldName);
    WritePString('LookupFieldName',LookupFieldName);
    WritePString('LookupDisplayName',LookupDisplayName);
    WritePString('DisplayListName',DisplayListName);
    WriteBoolean('ReadOnly',ReadOnly);
  end;
end;

  {TDBEdit}
procedure WriteDBEdit(Sender:PWriter; View:PView);
var Line:PDBEdit absolute View;
begin
  WriteInputLine(Sender, View);
  with Line^,Sender^ do
  begin
    WriteLink('DS',DS);
    WritePString('FieldName',FieldName);
  end
end;

  {TDBDateEdit}
procedure WriteDBDateEdit(Sender:PWriter; View:PView);
var Line:PDBDateEdit absolute View;
begin
  WriteDBEdit(Sender, View);
  Sender^.WriteBoolean('DefaultToday', Line^.DefaultToday);
end;

  {TDBNavigatorBtn}
procedure WriteDBNavigatorBtn(Sender:PWriter; View:PView);
var Btn:PDBNavigatorBtn absolute View;
begin
  WriteButton(Sender, View);
  Sender^.WriteLink('DataSourse', Btn^.DataSourse);
end;

  {TDBMemo}
procedure WriteDBMemo(Sender:PWriter; View:PView);
var Memo:PDBMemo absolute View;
begin
  WriteView(Sender, View);
  with Memo^, Sender^ do
  begin
    WriteLink('DataSourse',DataSourse);
    WritePString('FieldName',FieldName);
  end;
end;

  {TDataSourse}
procedure WriteDataSourse(Sender:PWriter; View:PView);
var DS:PDataSourse absolute View;
begin
  WriteView(Sender, View);
  with Sender^, DS^ do
  begin
    WriteHex('dbOptions',byte(dbOptions), 2);
    WriteLink('Master',Master);
    WritePString('DatabaseName',DatabaseName);
    WriteBoolean('Active', GetActive);
  end;
end;

  {TDBSourse}
procedure WriteDBSourse(Sender:PWriter; View:PView);
var DS:PDBSourse absolute View;
begin
  WriteDataSourse(Sender, View);
  with Sender^, DS^ do
  begin
    WritePString('TableName',TableName);
    WriteStringCollection('IndexLists',IndexLists);
  end;
end;

  {TVirtualDataSet}
procedure WriteVirtualDataSet(Sender:PWriter; View:PView);
var DS:PVirtualDataSet absolute View;
begin
  WriteDataSourse(Sender, View);
  Sender^.WriteInteger('fRecordCount', DS^.fRecordCount);
end;

  {TReportBand}
procedure WriteReportBand(Sender:PWriter; View:PView);
var RB:PReportBand absolute View;
begin
  WriteView(Sender, View);
  with RB^, Sender^ do
  begin
    WriteLink('Report',Report);
    WriteLink('Detail',Detail);
    WriteInteger('RBType',Ord(RBType));
    WriteLink('DataSourse',DataSourse);
{    WriteInteger('rbOption',Ord(rbOption));}
    WriteLink('Header',Header);
    WriteLink('Footer',Footer);
    WriteGroup(RB);
  end;
end;

  {TReport}
procedure WriteReport(Sender:PWriter; View:PView);
var R:PReport absolute View;
begin
  WriteView(Sender, View);
  with R^, Sender^ do
  begin
    WriteLink('DocHeaderBand',DocHeaderBand);
    WriteLink('DocHeaderBand',DocHeaderBand);
    WriteLink('PageHeaderBand',PageHeaderBand);
    WriteLink('PageFooterBand',PageFooterBand);
    WriteLink('DocFooterBand',DocFooterBand);
    WriteLink('MainBand',MainBand);
    WriteInteger('LineInPage',PageHight);
    WriteBoolean('ShowProgres',ShowProgres);
    WriteInteger('LeftMargin',LeftMargin);
  end;
end;

  {TReportLabel}
procedure WriteReportLabel(Sender:PWriter; View:PView);
var RL:PReportLabel absolute View;
begin
  WriteView(Sender, View);
  with RL^, Sender^ do
  begin
    WriteInteger('RLStyle',Ord(RLStyle));
    WriteLink('Report',Report);
    WritePString('ParamStr',ParamStr);
  end;
end;

  {TReportMemo}
procedure WriteReportMemo(Sender:PWriter; View:PView);
var R:PReportMemo absolute View;
begin
  WriteView(Sender, View);
  with R^, Sender^ do
  begin
    WriteLink('DS',DS);
    WritePString('FieldName',FieldName);
    WriteBoolean('AutoSize',AutoSize);
  end;
end;

  {TReportShape}
procedure WriteReportShape(Sender:PWriter; View:PView);
var R:PReportShape absolute View;
begin
  WriteView(Sender, View);
  with R^, Sender^ do
  begin
    WriteInteger('Shape', Ord(Shape));
    WriteInteger('PenStyle', Ord(PenStyle));
  end;
end;

{Read components metods}

function DoRead(Stream:PStream):PView;
var S,S2:string;
    Node:PReadWriteRecord;
    Stop:Boolean;
    I,j:integer;
    X,Y,X1,Y1:integer;
    R:TRect;
    View:PView;
begin
{  View:=nil;
  repeat
    S:=Trim(ReadText(Stream^));
    Node:=nil;
    i:=Pos(';',S);
    if i<>0 then S:=trim(Copy(S,1,i-1));
    if S<>'' then
    begin
      Node:=ReaderTree;
      Stop:=false;
      i:=0;
      S2:=Trim(S);
      J:=Pos(' ',S2);
      if J<>0 then S2:=Copy(S2,1,j-1);
      repeat
        inc(i);
        Stop:=S2='T'+stUpCase(GetString(sComponentTypeNameBase+i));
      until (i>CountComponents) or Stop;
      if Stop then Node:=FindNode(i);
    end;
  until (Node<>nil) or (Stream^.Status<>stOk);
  if Node<>nil then
  begin
    Delete(S,1,Pos(' ',S));
    X:=StrToInt(Trim(Copy(S,1,Pos(',',S)-1)));
    Delete(S,1,Pos(',',S));
    Y:=StrToInt(Trim(Copy(S,1,Pos(',',S)-1)));
    Delete(S,1,Pos(',',S));
    X1:=StrToInt(Trim(Copy(S,1,Pos(',',S)-1)))+X;
    Delete(S,1,Pos(',',S));
    Y1:=StrToInt(Trim(S))+Y;
    R.Assign(X,Y,X1,Y1);
    if Assigned(Node^.DoRead) then Node^.DoRead(Stream, View, R)
    else
    repeat
      S:=Read(Stream);
    until (Stream^.Status<>stOk) or (Copy(S,1,4)='END;');
  end;
  DoRead:=View;}
end;

procedure ReadView(Sender:PReader;var View:PView; Name:string);
var L:Longint;
    S:string;
begin
  if (Sender=nil) or (View=nil) then exit;
  with Sender^ do
  begin

    if Name='origin.x' then View^.Origin.X:=ReadInteger
    else
    if Name='origin.y' then View^.Origin.Y:=ReadInteger
    else
    if Name='size.x' then View^.Size.X:=ReadInteger
    else
    if Name='size.y' then View^.Size.Y:=ReadInteger
    else
    if Name='helpctx' then View^.HelpCtx:=ReadInteger
    else
    if Name='eventmask' then View^.EventMask:=ReadInteger
    else
    if Name='GrowMode' then View^.GrowMode:=ReadInteger
    else
    if Name='dragmode.x' then View^.DragMode:=ReadInteger
    else
    if Name='options' then View^.Options:=ReadInteger
  end;
{  if View=nil then
  begin
    View:=New(PView, Init(R));
    L:=-1;
  end else L:=Stream^.GetPos;
  repeat
    S:=Read(Stream);
    if stUpCase(Copy(S,1,11))='BEGIN GROUP' then SkipGroup(Stream)
    else
    begin
      ReadPStrProp(View^.ComponentName,S,'ComponentName');
      View^.HelpCtx:=ReadIntegerProp(View^.HelpCtx,S,'HelpCtx');
      View^.EventMask:=ReadIntegerProp(View^.EventMask,S,'EventMask');
      View^.GrowMode:=ReadIntegerProp(View^.GrowMode,S,'GrowMode');
      View^.DragMode:=ReadIntegerProp(View^.DragMode,S,'DragMode');
      View^.Options:=ReadIntegerProp(View^.Options,S,'Options');
    end;
  until (Stream^.Status<>stOk) or (Copy(S,1,4)='END;');
  if L<>-1 then Stream^.Seek(L);}
end;

procedure ReadDialog(Sender:PReader;var View:PView; Name:string);
var L:Longint;
    S:string;
    R:TRect;
begin
  if (Sender=nil) then
  begin
    if Name='tdialog' then
    begin
      R.Assign(1,1,10,10);
      View:=New(PDialog, Init(R, ''));
    end;
    exit;
  end;


(*  if View=nil then
  begin
    View:=New(PDialog, Init(R, ''));
    L:=-1;
  end else L:=Stream^.GetPos;
  ReadView(Stream, View, R);
  with PDialog(View)^ do
  repeat
    S:=Read(Stream);
    if stUpCase(Copy(S,1,11))='BEGIN GROUP' then {SkipGroup(Stream)}
       ReadGroup(Stream, View)
    else
    begin
      Flags:=ReadIntegerProp(Flags,S,'Flags');
      ReadPStrProp(Title,S,'Title');
      Number:=ReadIntegerProp(Number,S,'Number');
      Palette:=ReadIntegerProp(Palette,S,'Palette');
    end;
  until (Stream^.Status<>stOk) or (Copy(S,1,4)='END;');
  if L<>-1 then Stream^.Seek(L);*)
end;


procedure ReadInputLine(Sender:PReader;var View:PView; Name:string);
var L:Longint;
    I:integer;
    S:string;
begin
(*  if View=nil then
  begin
    View:=New(PInputLine, Init(R, 255));
    L:=-1;
  end else L:=Stream^.GetPos;
  ReadView(Stream, View, R);
  with PInputLine(View)^ do
  repeat
    S:=Read(Stream);
    if stUpCase(Copy(S,1,6))='MAXLEN' then
    begin
      I:=StrToInt(trim(Copy(S,Pos(':',S)+1,255)));
      if (I<>0) and (MaxLen<>i) then
      begin
        S:=Data^;
        FreeMem(Data, MaxLen+1);
        MaxLen:=I;
        GetMem(Data, MaxLen+1);
        byte(Data^[0]):=Min(MaxLen, Length(S));
        Move(S[1],Data^[1],Length(Data^))
      end;
    end
    else
    if stUpCase(Copy(S,1,4))='DATA' then
    begin
      Data^:=DelQuete(trim(Copy(S,Pos(':',S)+1,Min(MaxLen,255))));
    end;
  until (Stream^.Status<>stOk) or (Copy(S,1,4)='END;');
  if L<>-1 then Stream^.Seek(L);*)
end;

procedure ReadInputLinePS(Sender:PReader;var View:PView; Name:string);
var Line:PInputLinePS absolute View;
    L:Longint;
    I:integer;
    S:string;
begin
(*  if View=nil then
  begin
    View:=New(PInputLinePS, Init(R, 255,' '));
    L:=-1;
  end else L:=Stream^.GetPos;
  ReadInputLine(Stream, View, R);
  with PInputLinePS(View)^ do
  repeat
    S:=Read(Stream);
    if stUpCase(Copy(S,1,8))='PASSCHAR' then
    begin
      S:=DelQuete(trim(Copy(S,Pos(':',S)+1,255)));
      PassChar:=S[1];
    end;
  until (Stream^.Status<>stOk) or (Copy(S,1,4)='END;');
  if L<>-1 then Stream^.Seek(L);*)
end;

procedure ReadRangeILine(Sender:PReader;var View:PView; Name:string);
var Line:PRangeILine absolute View;
    L:Longint;
    I:integer;
    S:string;
begin
(*  if View=nil then
  begin
    View:=New(PRangeILine, Init(R, -MaxLongint-1, MaxLongint));
    L:=-1;
  end else L:=Stream^.GetPos;
  ReadInputLine(Stream, View, R);
  with PRangeILine(View)^ do
  repeat
    S:=Read(Stream);
    Min:=ReadIntegerProp(Min,S,'Min');
    Max:=ReadIntegerProp(Max,S,'Max');
  until (Stream^.Status<>stOk) or (Copy(S,1,4)='END;');
  if L<>-1 then Stream^.Seek(L);*)
end;

procedure ReadStaticText(Sender:PReader;var View:PView; Name:string);
var L:Longint;
    S:string;
begin
(*  if View=nil then
  begin
    View:=New(PStaticText, Init(R, ''));
    L:=-1;
  end else L:=Stream^.GetPos;
  ReadView(Stream, View, R);
  repeat
    S:=Read(Stream);
    ReadPStrProp(PStaticText(View)^.Text,S,'Text');
  until (Stream^.Status<>stOk) or (Copy(S,1,4)='END;');
  if L<>-1 then Stream^.Seek(L);*)
end;

procedure ReadParamText(Sender:PReader;var View:PView; Name:string);
var L:Longint;
    S:string;
begin
(*  if View=nil then
  begin
    View:=New(PParamText, Init(R, '', 0));
    L:=-1;
  end else L:=Stream^.GetPos;
  ReadStaticText(Stream, View, R);
  repeat
    S:=Read(Stream);
    PParamText(View)^.ParamCount:=
      ReadIntegerProp(PParamText(View)^.ParamCount,S,'ParamCount');
  until (Stream^.Status<>stOk) or (Copy(S,1,4)='END;');
  if L<>-1 then Stream^.Seek(L);*)
end;

procedure ReadLabel(Sender:PReader;var View:PView; Name:string);
var L:Longint;
    S:string;
begin
(*  if View=nil then
  begin
    View:=New(PLabel, Init(R, '', nil));
    L:=-1;
  end else L:=Stream^.GetPos;
  ReadStaticText(Stream, View, R);
  with PLabel(View)^ do
  repeat
    S:=Read(Stream);
    if stUpCase(Copy(S,1,4))='LINK' then
      AssignStr(PString(Link),trim(Copy(S,Pos(':',S)+1,255)));
  until (Stream^.Status<>stOk) or (Copy(S,1,4)='END;');
  if L<>-1 then Stream^.Seek(L);  *)
end;

procedure ReadButton(Sender:PReader;var View:PView; Name:string);
var L:Longint;
    S:string;
begin
(*  if View=nil then
  begin
    View:=New(PButton, Init(R, '', cmError, bfNormal));
    L:=-1;
  end else L:=Stream^.GetPos;
  ReadView(Stream, View, R);
  with PButton(View)^ do
  repeat
    S:=Read(Stream);
    ReadPStrProp(Title,S,'Title');
    Command:=ReadIntegerProp(Command,S,'Command');
    Flags:=ReadIntegerProp(Flags,S,'Flags');
  until (Stream^.Status<>stOk) or (Copy(S,1,4)='END;');
  if L<>-1 then Stream^.Seek(L);*)
end;


 {TScrollBar}
procedure ReadScrollBar(Sender:PReader;var View:PView; Name:string);
var L:Longint;
    S:string;
begin
(*  if View=nil then
  begin
    View:=New(PScrollBar, Init(R));
    L:=-1;
  end else L:=Stream^.GetPos;
  ReadView(Stream, View, R);
  with PScrollBar(View)^ do
  repeat
    S:=Read(Stream);
    Value:=ReadIntegerProp(Value,S,'Value');
    Min:=ReadIntegerProp(Min,S,'Min');
    Max:=ReadIntegerProp(Max,S,'Max');
    PgStep:=ReadIntegerProp(PgStep,S,'PgStep');
    ArStep:=ReadIntegerProp(ArStep,S,'ArStep');
  until (Stream^.Status<>stOk) or (Copy(S,1,4)='END;');
  if L<>-1 then Stream^.Seek(L);  *)
end;

 {TColorText}
procedure ReadColorText(Sender:PReader;var View:PView; Name:string);
begin
end;
{
(Stream:PStream; View:PView; Indent:integer);
var V:PColorText absolute View;
begin
  WriteView(Stream, View, Indent);
  Write(Stream, Indent, 'Color : $'+IntToHex(V^.Color,2));
  Write(Stream, Indent, 'Text : '+AddQuete(DinamicStr(V^.Text)));
end;

  {TLockUpInputLine}
procedure ReadLockUpInputLine(Sender:PReader;var View:PView; Name:string);
begin
end;
{
(Stream:PStream; View:PView; Indent:integer);
var Line:PLockUpInputLine absolute View;
    S:string[10];
begin
  WriteInputLine(Stream, View, Indent);
  if Assigned(Line^.List) then S:='' else S:='nil';
  Write(Stream, Indent, 'List : '+S);
  WriteStringCollection(Stream, Indent, Line^.List);
end;

   {TDateEdit}
procedure ReadDateEdit(Sender:PReader;var View:PView; Name:string);
begin
end;
{(Stream:PStream; View:PView; Indent:integer);
var Line:PDateEdit absolute View;
begin
  WriteInputLine(Stream, View, Indent);
  Write(Stream, Indent, 'DisplayFormat : '+AddQuete(DinamicStr(Line^.DisplayFormat)));
end;

}
procedure AssignLabel(V:PView; Owner:PGroup);
var S:string;
    Lab:PLabel absolute V;
begin
  if Lab^.Link<>nil then
  begin
    S:=PString(Lab^.Link)^;
    DisposeStr(PString(Lab^.Link));
    Lab^.Link:=ComponentByName(Owner,S);
  end;
end;

end.

