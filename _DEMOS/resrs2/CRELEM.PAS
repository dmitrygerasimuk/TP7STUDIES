{$O+}
{$I Define.inc}
{Модуль - создаются интерфейсные элементы}
unit CrElem;
interface
uses Dialogs, Objects, Prperty, Clases;
const
  ofsTView              : word = 0;
  ofsTViewOptions       : word = 0;
  ofsTViewEventMask     : word = 0;
  ofsTViewComponentName : word = 0;
  ofsTGroup             : word = 0;
  ofsTStaticText        : word = 0;
  ofsTInputLine         : word = 0;
  ofsTListView          : word = 0;
  ofsTScroller          : word = 0;
  ofsTCluster           : word = 0;
  ofsTDBText            : word = 0;
  ofsTMemo              : word = 0;
  ofsDataSourse         : word = 0;
  ofsDataSourseMaster   : word = 0;
  ofsTEditor            =  62;
  ofsTDBEdit            : word = 0;
  ofsReportBand         : word = 0;

  ofsTField             : word = 0;

procedure CreateElement(var RezFile:TResourceFile);
function MakeCommandLis:PSItem;
procedure CreatePropertyLists(var RezFile:TResourceFile);
implementation
uses Dos, GlType, Views, OutLine, StdDlg, Global, Editors, Ext_App, GL_Proc,
     GauGes, AddCntrl, DataCtrl, MultiSel, DAE,  DBFTable, DBGrids,
     SelElem, ResStrs, AboutPn, Ext_Str, DBCtrls, ResHelp, TabNotbk,
     GadGets, ASCIITab, Grids, Ext_Type, App, Reports, ColorSel,
     El_Lists, Querys, Register, Validate;


function MakeMultiSelListBoxRec:PStringCollection;
var
  S:PStringCollection;
begin
  S:=New(PStringCollection,Init(5,5));
  with S^ do
  begin
    AtInsert(0,NewStr(' Это'));
    AtInsert(1,NewStr(' демонстрация'));
    AtInsert(2,NewStr(' MultiSelListBox''а'));
    AtInsert(3,NewStr(' Demo'));
    AtInsert(4,NewStr(' MultiSelListBox'));
  end;
  MakeMultiSelListBoxRec:=S;
end;

procedure CreateElement(var RezFile:TResourceFile);
var
  P: PView;
  R: TRect;
{  DS:PDBSourse;}
  GR:PDrawGrid;
begin
    R.Assign(1,1,20,2);
    P:= New(PStaticText, Init(R,''));
    PStaticText(P)^.AutoSize:=true;
        RezFile.Put(P,'StaticText');
        Dispose( P, Done);
    P:=New(PLabel,Init(R,'~L~abel',nil));
        RezFile.Put(P,'Label');
        Dispose( P, Done);
    P:=New(PScrollBar,Init(R));
        RezFile.Put(P,'Horizontal Scroll Bar');
        Dispose( P, Done);
    P:=New(PInputLine,Init(R,255));
        P^.HelpCtx:=hcTInputLine;
        RezFile.Put(P,'InputLine');
        Dispose( P, Done);
    P:=New(PListViewer,Init(R,1,nil,nil));
        P^.HelpCtx:=hcTListViewer;
        RezFile.Put(P,'ListViewer');
        Dispose( P, Done);
    P:=New(PListBox,Init(R,1,nil));
        P^.HelpCtx:=hcTListBox;
        RezFile.Put(P,'ListBox');
        Dispose( P, Done);
    P:=New(POkListBox,Init(R,1,nil));
        RezFile.Put(P,'OkListBox');
        Dispose( P, Done);
    P:=New(PSortedListBox,Init(R,1,nil));
        RezFile.Put(P,'SortedListBox');
        Dispose( P, Done);
    P:=New(PRadioButtons,Init(R, nil));
        RezFile.Put(P,'RadioButtons');
        Dispose( P, Done);
    P:=New(PCheckBoxes,Init(R, nil));
        RezFile.Put(P,'CheckBoxes');
        Dispose( P, Done);
    P:=New(PDBRadioButtons,Init(R, nil, '', nil, false));
        P^.HelpCtx:=hcTDBRadioButtons;
        RezFile.Put(P,'DBRadioButtons');
        Dispose( P, Done);

    P:=New(PDBCheckBox,Init(R, nil, '', 'DBCheckBox', false,
       'AValueChecked','AValueUnchecked'));
        P^.HelpCtx:=hcTDBCheckBox;
        RezFile.Put(P,'DBCheckBox');
        Dispose( P, Done);
    P:=New(PMultiCheckBoxes,Init(R, nil, 4, cfTwoBits, 'ABCD'));
        RezFile.Put(P,'MultiCheckBoxes');
        Dispose( P, Done);
    P:=New(PIndicator, Init(R));
        RezFile.Put(P,'Indicator');
        Dispose( P, Done);
    P:=New(PPercentGauge,Init(R,2));
        RezFile.Put(P,'PercentGauge');
        Dispose( P, Done);
    P:=New(PBarGauge,Init(R,2));
        RezFile.Put(P,'BarGauge');
        Dispose( P, Done);
    P:=New(PClockView,Init(R));
        RezFile.Put(P,'ClockView');
        Dispose( P, Done);
    P:=New(PParamText, Init(R,'Param Text %d',1));
        RezFile.Put(P,'ParamText');
        Dispose( P, Done);
    P:=New(PInputLineUC,Init(R, 255));
        P^.HelpCtx:=hcTInputLine;
        RezFile.Put(P,'InputLineUC');
        Dispose( P, Done);
    P:=New(PInputLineLC,Init(R, 255));
        P^.HelpCtx:=hcTInputLine;
        RezFile.Put(P,'InputLineLC');
        Dispose( P, Done);
    P:=New(PInputLinePS,Init(R, 255, '*'));
        RezFile.Put(P,'InputLinePS');
        Dispose( P, Done);
    P:=New(PRangeILine,Init(R, -2147483647,2147483647 ));
        RezFile.Put(P,'RangeILine');
        Dispose( P, Done);
    P:=New(PFilterInput,Init(R, 255, [#32..#255]));
        RezFile.Put(P,'FilterInput');
        Dispose( P, Done);
    P:=New(PDateEdit,Init(R));
        RezFile.Put(P,'DateEdit');
        Dispose( P, Done);
    P:=New(PColorText,Init(R, 'Color text.', 8));
        RezFile.Put(P,'ColorText');
        Dispose( P, Done);
    P:=New(PDBText, Init(R, nil, 'DBText'));
        P^.HelpCtx:=hcTDBText;
        RezFile.Put(P,'DBText');
        Dispose( P, Done);
    P:=New(PDBLockUpText, Init(R, nil, 'DBLockUpText',
        NewSItem('DBLockUpText',nil)));
        RezFile.Put(P,'DBLockUpText');
        Dispose( P, Done);
    P:=New(PDBLookupEdit, Init(R, nil, 'DBLookupEdit',
        NewSItem('PDBLookupEdit',nil)));
        RezFile.Put(P,'DBLookupEdit');
        Dispose( P, Done);
    P:=New(PDBEdit, Init(R, nil, 'DBEdit'));
        RezFile.Put(P,'DBEdit');
        Dispose( P, Done);
    P:=New(PDBDateEdit, Init(R, nil, 'DBDateEdit'));
        RezFile.Put(P,'DBDateEdit');
        Dispose( P, Done);
    P:=New(PDBLookupCombo, Init(R, nil, nil, '','','','',false));
        P^.HelpCtx:=hcTDBLookupCombo;
        RezFile.Put(P,'DBLookupCombo');
        Dispose( P, Done);
    P:=New(PLockUpInputLine, Init(R,
        NewSItem('LockUpInputLine',
        NewSItem('-----------------',
        NewSItem('Это',
        NewSItem('демонстрация',
        NewSItem('LockUpInputLine',
        NewSItem('Demo',
        NewSItem('LockUpInputLine',
        nil)))))))));
        PInputLine(P)^.Data^:='LockUpInputLine';
        RezFile.Put(P,'LockUpInputLine');
        Dispose( P, Done);
    P:=New(PASCIIReport,Init(R));
        RezFile.Put(P,'ASCIIReport');
        Dispose( P, Done);
    R.Assign(6,0,13,1);
    P:=New(PReport, Init);
        RezFile.Put(P,'Report');
        Dispose( P, Done);
    R.Assign(5,0,15,1);
    P:=New(PReportLabel, Init(R, nil, rlsDate, 'Дата - %s'));
        RezFile.Put(P,'ReportLabel');
        Dispose( P, Done);
    R.Assign(1,1,20,4);
    P:=New(PReportBand, Init(R, nil, nil, nil));
        RezFile.Put(P,'ReportBand');
        Dispose( P, Done);
    P:=New(PGroupBand, Init(R, nil, ''));
        RezFile.Put(P,'GroupBand');
        Dispose( P, Done);
    R.Assign(1,1,5,5);
    P:=New(PReportShape, Init(R, rsRectangle, psSingleLine));
        RezFile.Put(P,'ReportShape');
        Dispose( P, Done);
    R.Assign(1,1,12,3);
    P:=New(PAboutPanel, Init( R, 'Демонстрация',
             NewSItem('Demo1',
             NewSItem('Demo2',
             NewSItem('Demo3',
             NewSItem('Demo4',
             NewSItem('Demo5',
             NewSItem('Demo6',
             NewSItem('Demo7',
             NewSItem('Demo8',
             NewSItem('Demo9',
             NewSItem('Demo10',
             NewSItem('Demo11',
             NewSItem('Demo12',
             NewSItem('Demo13',
             NewSItem('Demo14',
             NewSItem('Demo15',
             NewSItem('Demo16',
             NewSItem('Demo17',
             NewSItem('Demo18',
             nil))))))))))))))))))));
        RezFile.Put(P,'AboutPanel');
        Dispose( P, Done);
    P:=New(PMemo,init(R, nil, nil, nil, 256*16));
        RezFile.Put(P,'Memo');
        Dispose( P, Done);
    P:=New(PDBMemo, Init(R, nil, nil, nil, nil, ''));
        RezFile.Put(P,'DBMemo');
        Dispose( P, Done);
    P:=New(PReportMemo,init(R, nil, 'ReportMemo'));
        RezFile.Put(P,'ReportMemo');
        Dispose( P, Done);
    P:=New(PButton,Init(R,'',cmError,bfNormal));
        RezFile.Put(P,'Button');
        Dispose( P, Done);
    P:=New(PDBNavigatorBtn,Init(R,'~D~BNavigatorBtn',cmNextRec,bfNormal,nil));
        RezFile.Put(P,'DBNavigatorBtn');
        Dispose( P, Done);
    P:=New(PDBGrid,Init(R, nil, nil, nil));
        P^.HelpCtx:=hcTDBGrid;
        RezFile.Put(P,'DBGrid');
        Dispose( P, Done);
    GR:=New(PDrawGrid,Init(R, nil, nil, nil));
        GR^.grOptions:=GR^.grOptions or grAutoSize;
        RezFile.Put(GR,'DrawGrid');
        GR^.Free;
    GR:=New(PStringGrid,Init(R, nil, nil, nil));
        GR^.grOptions:=GR^.grOptions or grAutoSize;
        RezFile.Put(GR,'StringGrid');
        GR^.Free;
    P:=New(PMultiSelBox,Init(R,1,nil,#251));
        RezFile.Put(P,'MultiSelBox');
        Dispose( P, Done);
    P:=New(POutLine,Init(R,nil,nil,
         NewNode('Node 1',
          NewNode('Node 11',nil,nil),
         nil)));
        RezFile.Put(P,'Outline');
        Dispose( P, Done);
    P:=New(PElementGroupList,Init(R,nil,
       ElementGroup('Group 1',
            ElementItem('Element 1.1',
            ElementItem('Element 1.2',
            ElementItem('Element 1.3',
            nil))),
       ElementGroup('Group 2',
            ElementItem('Element 2.1',
            ElementItem('Element 2.2',
            ElementItem('Element 2.3',
            nil))),
       ElementGroup('Group 3',
            ElementItem('Element 3.1',
            ElementItem('Element 3.2',
            ElementItem('Element 3.3',
            nil))),
         nil)))));
        RezFile.Put(P,'ElementGroupList');
        Dispose( P, Done);
    P:=New(PElementItemList,Init(R,nil,nil));
        RezFile.Put(P,'ElementItemList');
        Dispose( P, Done);
    P:=New(PASCIITable,Init(R));
        RezFile.Put(P,'ASCIITable');
        Dispose( P, Done);
    R.Assign(1,1,2,10);
    P:=New(PScrollBar,Init(R));
        RezFile.Put(P,'Vertical Scroll Bar');
        Dispose( P, Done);
    P:=New(PDataScroller,Init(R,nil));
        RezFile.Put(P,'DataScroller');
        Dispose( P, Done);
    P:=New(PDBSourse,Init(nil));
        RezFile.Put(P,'DBSourse');
        Dispose( P, Done);
    P:=New(PVirtualDataSet,Init(1));
        RezFile.Put(P,'VirtualDataSet');
        Dispose( P, Done);
    P:=New(PUserDataSet,Init);
        RezFile.Put(P,'UserDataSet');
        Dispose( P, Done);
{    P:=New(PQuery, Init(''));
        PQuery(P)^.dbOptions:=PQuery(P)^.dbOptions - [dboAutoOpen];
        RezFile.Put(P,'Query');
        Dispose( P, Done);}
    R.Assign( 10, 3, 70, 22);
    P:=New(PDialog,Init(R,'Report form'));
        RezFile.Put(P,'Report form');
        Dispose( P, Done);
    R.Assign(1,1,4,2);
    P:=New(PHistory, Init(R, nil, 100));
        RezFile.Put(P,'History');
        Dispose( P, Done);
    R.Assign(1,1,5,4);
    P:=New(PTabbedNotebook, Init(R));
        P^.helpCtx:=hcTTabbedNotebook;
        RezFile.Put(P,'TabbedNotebook');
        Dispose( P, Done);
  R.Assign( 1, 1, 13, 4);
  P := New(PColorSelector, Init(R, csForeground));
        RezFile.Put(P,'ColorSelector');
        Dispose( P, Done);

  R.Assign( 1, 1, 13, 4);
  P := New(PColorDisplay, Init(R, NewStr('Текст ')));
        RezFile.Put(P,'ColorDisplay');
        Dispose( P, Done);
  P:= New(PDirListBox, Init(R,nil));
        RezFile.Put(P,'DirListBox');
        Dispose( P, Done);
  R.Assign(1, 1, 15, 5);
  P := New(PMonoSelector, Init(R));
        RezFile.Put(P,'MonoSelector');
        Dispose( P, Done);

end;

function MakeCommandLis:PSItem;
begin
  MakeCommandLis:=
     NewSItem('cmValid',
     NewSItem('cmQuit',
     NewSItem('cmError',
     NewSItem('cmMenu',
     NewSItem('cmClose',
     NewSItem('cmZoom',
     NewSItem('cmResize',
     NewSItem('cmNext',
     NewSItem('cmPrev',
     NewSItem('cmHelp',
     NewSItem('cmOK',
     NewSItem('cmCancel',
     NewSItem('cmYes',
     NewSItem('cmNo',
     NewSItem('cmDefault',
     nil)))))))))))))));
end;

function CreateViewsProperty:PCollection;
var P:PCollection;
    RP:PProperty;
    Ofs:word;
begin
  P:=New(PPropertyCollections, Init(10,5));
  Ofs:=SizeOf(PGroup)+SizeOf(PView);
  P^.Insert(New(PIntegerProperty, Init('Origin.X', Ofs, hcTViewOrigin, itInteger, false)));
  Ofs:=Ofs+SizeOf(integer);
  P^.Insert(New(PIntegerProperty, Init('Origin.Y',Ofs, hcTViewOrigin, itInteger, false)));
  Ofs:=Ofs+SizeOf(integer);
  P^.Insert(New(PIntegerProperty, Init('Size.X', Ofs, hcTViewSize, itInteger, false)));
  Ofs:=Ofs+SizeOf(integer);
  P^.Insert(New(PIntegerProperty, Init('Size.Y', Ofs, hcTViewSize, itInteger, false)));
  Ofs:=Ofs+SizeOf(integer);
  P^.Insert(New(PIntegerProperty, Init('Cursor.X', Ofs, hcTViewCursor, itInteger, false)));
  Ofs:=Ofs+SizeOf(integer);
  P^.Insert(New(PIntegerProperty, Init('Cursor.Y', ofs, hcTViewCursor, itInteger, false)));
  Ofs:=Ofs+SizeOf(integer);
  RP:=New(PBitMapProperty, Init('GrowMode', Ofs, hcTViewGrowMode,
                 NewSItem('gfGrowLoX',
                 NewSItem('gfGrowLoY',
                 NewSItem('gfGrowHiX',
                 NewSItem('gfGrowHiY',
                 NewSItem('gfGrowRel',
                          nil))))), 0));
     RP^.OnAfterEdit:=AfterEditGrowMode;
  P^.Insert(RP);
  Ofs:=Ofs+SizeOf(byte);
  P^.Insert(New(PBitMapProperty, Init('DragMode', Ofs, hcTViewDragMode,
                 NewSItem('dmDragMove',
                 NewSItem('dmDragGrow',
                 NewSItem('dmLimitLoX',
                 NewSItem('dmLimitLoY',
                 NewSItem('dmLimitHiX',
                 NewSItem('dmLimitHiY',
                          nil)))))), 0)));
  Ofs:=Ofs+SizeOf(byte);
  RP:=New(PProperty, Init('HelpCtx', ofs, hcTViewHelpCtx, false));
     RP^.OnGetText:=Views_GetTextHlpCtx;
     RP^.OnEdit:=Views_EditHelpCtx;
  P^.Insert(RP);
  Ofs:=Ofs+SizeOf(Word);
  RP:=New(PBitMapProperty, Init('State', Ofs, hcTViewState,
                 NewSItem('sfVisible',
                 NewSItem('sfCursorVis',
                 NewSItem('sfCursorIns',
                 NewSItem('sfShadow',
                 NewSItem('sfActive',
                 NewSItem('sfSelected',
                 NewSItem('sfFocused',
                 NewSItem('sfDragging',
                 NewSItem('sfDisabled',
                 NewSItem('sfModal',
                 NewSItem('sfDefault',
                 NewSItem('sfExposed',
                          nil)))))))))))),
                          sfActive {or sfDisabled} or sfDefault or sfExposed));
    RP^.OnEdit:=EditView_State;
  P^.Insert(RP);
  Ofs:=Ofs+SizeOf(Word);
  ofsTViewOptions:=ofs;
  P^.Insert(New(PBitMapProperty, Init('Options', Ofs, hcTViewOptions,
                 NewSItem('ofSelectable',
                 NewSItem('ofTopSelect',
                 NewSItem('ofFirstClick',
                 NewSItem('ofFramed',
                 NewSItem('ofPreProcess',
                 NewSItem('ofPostProcess',
                 NewSItem('ofBuffered',
                 NewSItem('ofTileable',
                 NewSItem('ofCenterX',
                 NewSItem('ofCenterY',
                 NewSItem('ofCentered',
                 NewSItem('ofValidate',
                 NewSItem('!',
                 NewSItem('ofVersion20',
                 NewSItem('ofVersion30',
                 nil))))))))))))))), 0)));
  Ofs:=Ofs+SizeOf(Word);
  ofsTViewEventMask := Ofs;
  P^.Insert(New(PBitMapProperty, Init('EventMask', Ofs, hcTViewEventMask,
                 NewSItem('evMouseDown',
                 NewSItem('evMouseUp',
                 NewSItem('evMouseMove',
                 NewSItem('evMouseAuto',
                 NewSItem('evKeyDown',
                 NewSItem('!',
                 NewSItem('!',
                 NewSItem('!',
                 NewSItem('evCommand',
                 NewSItem('evBroadcast',
                          nil)))))))))), 0)));
  Ofs:=Ofs+SizeOf(Word) + SizeOf(Byte); //Componet type
  ofsTViewComponentName:= Ofs;
  RP:=New(PPStringProperty, Init('ComponentName', Ofs, hcTViewComponentName, false));
    RP^.OnValidate:=ValidComponentName;
    P^.Insert(RP);
  ofsTView:=Ofs+SizeOf(PString)+SizeOf(TNotifyEvent)*9;
  CreateViewsProperty:=P;
end;

function CreateGroupProperty:PCollection;
var P:PCollection;
    Ofs:word;
begin
  P:=CreateViewsProperty;
  Ofs:=ofsTView+SizeOf(PView);{  Last: PView;}
  P^.Insert(New(PLinkProperty, Init('Current', Ofs, 0, LabelSet, false, false)));
  ofsTGroup:=Ofs+SizeOf(PView)+SizeOf(byte)+SizeOf(PVideoBuf)+SizeOf(Word)+
                 SizeOf(TRect)+SizeOf(Byte);
  {  Phase: (phFocused, phPreProcess, phPostProcess); - ofsTView + 8}
  {  Buffer: PVideoBuf;                               - ofsTView + 9}
  {  EndState: Word;                                  - ofsTView + 13}
  {  Clip: TRect;                                     - ofsTView + 15}
  {  LockFlag: Byte;                                  - ofsTView + 23}
  CreateGroupProperty:=P;
end;

function CreateStaticTextProperty:PCollection;
var P:PCollection;
    PR:PProperty;
    Ofs:word;
begin
  P:=CreateViewsProperty;
  Ofs:=ofsTView;
  PR:=New(PPStringProperty, Init('Text', ofs, hcTStaticTextText, false));
     PR^.OnAfterEdit:=AfterEditStaticText_Text;
  P^.Insert(PR);
  Ofs:=Ofs+SizeOf(PString);
  P^.Insert(New(PBooleanProperty, Init('AutoSize', ofs, 0, false)));
  ofsTStaticText:=Ofs+SizeOf(boolean);
  CreateStaticTextProperty:=P;
end;

function CreateParamTextProperty:PCollection;
var P:PCollection;
    PR:PProperty;
    Ofs:word;
begin
  P:=CreateStaticTextProperty;
  Ofs:=ofsTStaticText;
  P^.Insert(New(PIntegerProperty, Init('ParamCount', ofs, 0, itInteger, true)));
  CreateParamTextProperty:=P;
end;

function CreateLabelProperty:PCollection;
var P:PCollection;
    PR:PProperty;
    Ofs:word;
begin
  P:=CreateStaticTextProperty;
  Ofs:=ofsTStaticText;
{  PR:=New(PLinkProperty, Init('Link', ofsTStaticText, 0,LabelSet, false, false));
    PR^.OnAfterEdit:=AfterEditLabel_Link;
    P^.Insert(PR);}
  P^.Insert(New(PLinkProperty, Init('Link', ofs, 0,LabelSet, false, false)));
  Ofs:=Ofs+SizeOf(PView);
  P^.Insert(New(PBooleanProperty, Init('Light', ofs, 0, false)));
  CreateLabelProperty:=P;
end;

function CreateInputLineProperty:PCollection;
var P:PCollection;
    PR:PProperty;
    Ofs:word;
begin
  P:=CreateViewsProperty;
  Ofs:=ofsTView;
  P^.Insert(New(PPStringProperty, Init('Data', ofs, hcTInputLineData, true)));
  Ofs:=Ofs+SizeOf(PString);
  PR:=New(PIntegerProperty, Init('MaxLen', ofs, hcTInputLineMaxLen, itInteger, false));
    PR^.OnAfterEdit:=AfterEditInputLine_MaxLen;
    PR^.OnBeforeEdit:=BeforeEditInputLine_MaxLen;
    P^.Insert(PR);
  Ofs:=Ofs+SizeOf(Integer);
  P^.Insert(New(PIntegerProperty, Init('CurPos', ofs, hcTInputLineCurPos, itInteger, false)));
  Ofs:=Ofs+SizeOf(Integer);
  P^.Insert(New(PIntegerProperty, Init('FirstPos', ofs, hcTInputLineFirstPos, itInteger, false)));
  Ofs:=Ofs+SizeOf(Integer);
  P^.Insert(New(PIntegerProperty, Init('SelStart', ofs, hcTInputLineSelStart, itInteger, false)));
  Ofs:=Ofs+SizeOf(Integer);
  P^.Insert(New(PIntegerProperty, Init('SelEnd', ofs, hcTInputLineSelEnd, itInteger, false)));
  Ofs:=Ofs+SizeOf(Integer);
  PR:=New(PProperty, Init('Validator', ofsTView+14, hcTInputLineValidator, true));
     PR^.OnGetText:=GetTextInputLine_Validator;
     PR^.OnEdit:=EditInputLine_Validator;
  P^.Insert(PR);
  ofsTInputLine:=Ofs+SizeOf(PValidator)+SizeOf(Word); //  EndState: Word;
  CreateInputLineProperty:=P;
end;

function CreateLockUpInputLineProperty:PCollection;
var P:PCollection;
    Ofs:word;
begin
  P:=CreateInputLineProperty;
  Ofs:=ofsTInputLine;
  P^.Insert(New(PPStrCollectionProperty, Init('List', Ofs, hcTInputLineData, false)));
  CreateLockUpInputLineProperty:=P;
end;

function CreateDateEditProperty:PCollection;
var P:PCollection;
    Ofs:word;
begin
  P:=CreateInputLineProperty;
  Ofs:=ofsTInputLine;
  P^.Insert(New(PPStringProperty, Init('DisplayFormat', ofs, hcTInputLineData, false)));
  CreateDateEditProperty:=P;
end;

function CreateRangeILineProperty:PCollection;
var P:PCollection;
    Ofs:word;
begin
  P:=CreateInputLineProperty;
  Ofs:=ofsTInputLine;
  P^.Insert(New(PIntegerProperty, Init('Min', ofs, 0, itLongint, false)));
  Ofs:=Ofs+SizeOf(Longint);
  P^.Insert(New(PIntegerProperty, Init('Max', ofs, 0, itLongint, false)));
  Ofs:=Ofs+SizeOf(Longint);
  CreateRangeILineProperty:=P;
end;

function CreateInputLinePSProperty:PCollection;
var P:PCollection;
    Ofs:word;
begin
  P:=CreateInputLineProperty;
  Ofs:=ofsTInputLine;
  P^.Insert(New(PIntegerProperty, Init('NEChar', ofs, 0, itChar, false)));
  CreateInputLinePSProperty:=P;
end;

function CreatePercentGaugeProperty:PCollection;
var P:PCollection;
    Ofs:word;
begin
  P:=CreateViewsProperty;
  Ofs:=ofsTView;
  P^.Insert(New(PIntegerProperty, Init('MaxValue', Ofs, 0, itLongint, false)));
  Ofs:=Ofs+SizeOf(Longint);
  P^.Insert(New(PIntegerProperty, Init('CurValue', ofs, 0, itLongint, false)));
  CreatePercentGaugeProperty:=P;
end;

function CreateScrollBarProperty:PCollection;
var P:PCollection;
    Ofs:word;
begin
  P:=CreateViewsProperty;
  Ofs:=ofsTView;
  P^.Insert(New(PIntegerProperty, Init('Value', ofs, 0, itInteger, false)));
  Ofs:=Ofs+SizeOf(Integer);
  P^.Insert(New(PIntegerProperty, Init('Min', ofs, 0, itInteger, false)));
  Ofs:=Ofs+SizeOf(Integer);
  P^.Insert(New(PIntegerProperty, Init('Max', ofs, 0, itInteger, false)));
  Ofs:=Ofs+SizeOf(Integer);
  P^.Insert(New(PIntegerProperty, Init('PgStep', ofs, 0, itInteger, false)));
  Ofs:=Ofs+SizeOf(Integer);
  P^.Insert(New(PIntegerProperty, Init('ArStep', ofs, 0, itInteger, false)));
  CreateScrollBarProperty:=P;
end;

function CreateButtonProperty:PCollection;
var P:PCollection;
    PR:PProperty;
    Ofs:word;
begin
  P:=CreateViewsProperty;
  Ofs:=ofsTView;
  P^.Insert(New(PPStringProperty, Init('Title', ofs, hcTButtonTitle , false)));
  Ofs:=Ofs+SizeOf(PString);
  PR:=New(PLockUpProperty, Init('Command', ofs, hcTButtonCommand,
                 NewSItem('cmValid',
                 NewSItem('cmQuit',
                 NewSItem('cmError',
                 NewSItem('cmMenu',
                 NewSItem('cmClose',
                 NewSItem('cmZoom',
                 NewSItem('cmResize',
                 NewSItem('cmNext',
                 NewSItem('cmPrev',
                 NewSItem('cmHelp',
                 NewSItem('cmOK',
                 NewSItem('cmCancel',
                 NewSItem('cmYes',
                 NewSItem('cmNo',
                 NewSItem('cmDefault',
                 NewSItem('cm15',
                 NewSItem('cm16',
                 NewSItem('cm17',
                 NewSItem('cm18',
                 NewSItem('cm19',
                 NewSItem('cmCut',
                 NewSItem('cmCopy',
                 NewSItem('cmPaste',
                 NewSItem('cmUndo',
                 NewSItem('cmClear',
                 NewSItem('cmTile',
                 NewSItem('cmCascade',
                 nil))))))))))))))))))))))))))), false, itWord, 0));
     PR^.OnAfterEdit:=AfterEditButton_Command;
     P^.Insert(PR);
  Ofs:=Ofs+SizeOf(Word);
  PR:=New(PBitMapProperty, Init('Flags',ofs, hcTButtonFlags,
                 NewSItem('bfDefault',
                 NewSItem('bfLeftJust',
                 NewSItem('bfBroadcast',
                 NewSItem('bfGrabFocus',
                          nil)))), 0));
     PR^.OnAfterEdit:=AfterEditButton_Flags;
     P^.Insert(PR);
  Ofs:=Ofs+SizeOf(byte);
  P^.Insert(New(PBooleanProperty, Init('AmDefault', ofs, hcTButtonAmDefault , true)));
  CreateButtonProperty:=P;
end;

function CreateListViewProperty:PCollection;
var P:PCollection;
    RP:PProperty;
    Ofs:word;
begin
  P:=CreateViewsProperty;
  Ofs:=ofsTView;
  RP:=New(PLinkProperty, Init('HScrollBar', ofs, 0,[ctScrollBar], true, false));
     RP^.OnAfterEdit:=AfterEditListBox_ScrollBar;
     P^.Insert(RP);
  Ofs:=Ofs+SizeOf(PScrollBar);
  RP:=New(PLinkProperty, Init('VScrollBar', ofs, 0,[ctScrollBar], true, false));
     RP^.OnAfterEdit:=AfterEditListBox_ScrollBar;
     P^.Insert(RP);
  Ofs:=Ofs+SizeOf(PScrollBar);
  P^.Insert(New(PIntegerProperty, Init('NumCols', ofs, 0 , itInteger, false)));
  Ofs:=Ofs+SizeOf(integer);
  P^.Insert(New(PIntegerProperty, Init('TopItem', ofs, 0 , itInteger, false)));
  Ofs:=Ofs+SizeOf(integer);
  P^.Insert(New(PIntegerProperty, Init('Focused', ofs, 0 , itInteger, false)));
  Ofs:=Ofs+SizeOf(integer);
  P^.Insert(New(PIntegerProperty, Init('Range', ofs, 0 , itInteger, false)));
  ofsTListView:=Ofs+SizeOf(integer);
  CreateListViewProperty:=P;
end;

function CreateMultiSelectListViewProperty:PCollection;
var P:PCollection;
    Ofs:word;
begin
  P:=CreateListViewProperty;
  Ofs:=ofsTListView;
  P^.Insert(New(PIntegerProperty, Init('SelectChar', ofs, 0 , itChar, false)));
  CreateMultiSelectListViewProperty:=P;
end;

function CreateClockViewProperty:PCollection;
var P:PCollection;
    Ofs:word;
begin
  P:=CreateViewsProperty;
  Ofs:=ofsTView;
  P^.Insert(New(PIntegerProperty, Init('Refresh', ofs, 0 , itByte, false)));
  Ofs:=Ofs+SizeOf(Byte);
  P^.Insert(New(PIntegerProperty, Init('LastTime',ofs, 0 , itTime, false)));
  Ofs:=Ofs+SizeOf(DateTime);
  P^.Insert(New(PStringProperty, Init('TimeStr', ofs, 0 , 10, false)));
  CreateClockViewProperty:=P;
end;

function CreateASCIIReportProperty:PCollection;
var P:PCollection;
begin
  P:=CreateViewsProperty;
  P^.Insert(New(PIntegerProperty, Init('ASCIIChar',ofsTView, 0, itChar, false)));
  CreateASCIIReportProperty:=P;
end;

function CreateColorTextProperty:PCollection;
var P:PCollection;
    RP:PProperty;
    Ofs:word;
begin
  P:=CreateViewsProperty;
  Ofs:=ofsTView;
  RP:=New(PIntegerProperty, Init('Color',ofs, 0 ,itByte, false));
  RP^.OnEdit:=EditColorText;
  P^.Insert(RP);
  Ofs:=Ofs+SizeOf(Byte);
  P^.Insert(New(PPStringProperty, Init('Text', ofs, 0 , false)));
  CreateColorTextProperty:=P;
end;

function CreateScrollerProperty:PCollection;
var P:PCollection;
    Ofs:word;
begin
  P:=CreateViewsProperty;
  Ofs:=ofsTView;
  P^.Insert(New(PLinkProperty, Init('HScrollBar', ofs, 0,[ctScrollBar], true, false)));
  Ofs:=Ofs+SizeOf(PScrollBar);
  P^.Insert(New(PLinkProperty, Init('VScrollBar', ofs, 0,[ctScrollBar], true, false)));
  Ofs:=Ofs+SizeOf(PScrollBar);
  P^.Insert(New(PIntegerProperty, Init('Delta.X', ofs, 0 , itInteger, false)));
  Ofs:=Ofs+SizeOf(integer);
  P^.Insert(New(PIntegerProperty, Init('Delta.Y', ofs, 0 , itInteger, false)));
  Ofs:=Ofs+SizeOf(integer);
  P^.Insert(New(PIntegerProperty, Init('Limit.X', ofs, 0 , itInteger, false)));
  Ofs:=Ofs+SizeOf(integer);
  P^.Insert(New(PIntegerProperty, Init('Limit.Y', ofs, 0 , itInteger, false)));
  {  DrawLock: Byte;     }
  {  DrawFlag: Boolean;  }
  ofsTScroller:=Ofs+SizeOf(Integer)+SizeOf(Byte)+SizeOf(Boolean);
  CreateScrollerProperty:=P;
end;

function CreateClusterProperty:PCollection;
var P:PCollection;
    Ofs:word;
begin
  P:=CreateViewsProperty;
  Ofs:=ofsTView;
  P^.Insert(New(PIntegerProperty, Init('Value',ofs, 0 ,itLongint, false)));
  Ofs:=Ofs+SizeOf(Longint);
  P^.Insert(New(PIntegerProperty, Init('Sel',  ofs, 0,itInteger, false)));
  Ofs:=Ofs+SizeOf(integer);
  P^.Insert(New(PIntegerProperty, Init('EnableMask',ofs, 0,itLongint, false)));
  Ofs:=Ofs+SizeOf(Longint);
  P^.Insert(New(PTStrCollectionProperty, Init('Strings', ofsTView+10, 0, false)));
  ofsTCluster:=Ofs+SizeOf(TStringCollection);
  CreateClusterProperty:=P;
end;

function CreateMultiCheckBoxesProperty:PCollection;
var P:PCollection;
    Ofs:word;
begin
  P:=CreateClusterProperty;
  Ofs:=ofsTCluster;
  P^.Insert(New(PIntegerProperty, Init('SelRange', ofs, 0, itByte, false)));
  Ofs:=Ofs+SizeOf(byte);
  P^.Insert(New(PIntegerProperty, Init('Flags', ofsTCluster+1, 0,itWord, false)));
  Ofs:=Ofs+SizeOf(Word);
  P^.Insert(New(PPStringProperty, Init('States', ofsTCluster+3, 0, false)));
  Ofs:=Ofs+SizeOf(PString);
  CreateMultiCheckBoxesProperty:=P;
end;

function CreateMemoProperty:PCollection;
var P:PCollection;
    Ofs:word;
begin
  P:=CreateViewsProperty;
  Ofs:=ofsTView;
  P^.Insert(New(PLinkProperty, Init('HScrollBar', ofs, 0,[ctScrollBar], true, false)));
  Ofs:=Ofs+SizeOf(PScrollBar);
  P^.Insert(New(PLinkProperty, Init('VScrollBar', ofs, 0,[ctScrollBar], true, false)));
  Ofs:=Ofs+SizeOf(PScrollBar);
  P^.Insert(New(PLinkProperty, Init('Indicator', ofs, 0,[ctIndicator], true, false)));
  {Buffer: PEditBuffer;}
  {BufSize: Word;}
  Ofs:=Ofs+SizeOf(PIndicator)+SizeOf(PEditBuffer)+SizeOf(Word);

  P^.Insert(New(PIntegerProperty, Init('BufLen', ofs, 0, itWord, true)));
  {  GapLen: Word;}
  {  SelStart: Word;}
  {  SelEnd: Word;}
  {  CurPtr: Word;}
  Ofs:=Ofs+SizeOf(Word)*5;
  P^.Insert(New(PIntegerProperty, Init('CurPos.X', ofs, 0, itInteger, false)));
  Ofs:=Ofs+SizeOf(integer);
  P^.Insert(New(PIntegerProperty, Init('CurPos.Y', ofs, 0, itInteger, false)));
  {  Delta: TPoint;}
  {  Limit: TPoint;}
  {  DrawLine: Integer;}
  {  DrawPtr: Word;}
  {  DelCount: Word;}
  {  InsCount: Word;}
  {  IsValid: Boolean;}
  {  CanUndo: Boolean;}
  Ofs:=Ofs+SizeOf(integer)+SizeOf(TPoint)*2+SizeOf(integer)+SizeOf(word)*3+SizeOf(Boolean)*2;

  P^.Insert(New(PBooleanProperty, Init('Modified', ofs, 0, true)));
  Ofs:=Ofs+SizeOf(boolean);
  P^.Insert(New(PBooleanProperty, Init('Selecting', ofs, 0, true)));
  Ofs:=Ofs+SizeOf(boolean);
  P^.Insert(New(PBooleanProperty, Init('Overwrite', ofs, 0, true)));
  Ofs:=Ofs+SizeOf(boolean);
  P^.Insert(New(PBooleanProperty, Init('AutoIndent', ofs, 0, true)));
  Ofs:=Ofs+SizeOf(boolean);
  {  LockCount: Byte;  }
  {  UpdateFlags: Byte;}
  {  KeyState: Integer;}
  ofsTMemo:=Ofs+SizeOf(Byte)*2+SizeOf(Integer);
  CreateMemoProperty:=P;
end;

function CreateDBMemoProperty:PCollection;
var P:PCollection;
    PR:PProperty;
    Ofs:word;
begin
  P:=CreateMemoProperty;
  Ofs:=ofsTMemo;
  P^.Insert(New(PLinkProperty, Init('DataSourse', ofs, 0, DSSet, false, false)));
  Ofs:=Ofs+SizeOf(PDataSourse);
  PR:=New(PProperty, Init('Field', ofs, 0, false));
    PR^.OnGetText:=GetTextDBMemoField;
    PR^.OnEdit:=EditDBMemoField;
  P^.Insert(PR);
  Ofs:=Ofs+SizeOf(PField);
  P^.Insert(New(PPStringProperty, Init('FieldName', ofs, 0, false)));
  Ofs:=Ofs+SizeOf(PString);
  CreateDBMemoProperty:=P;
end;

function CreateIndicatorProperty:PCollection;
var P:PCollection;
    Ofs:word;
begin
  P:=CreateViewsProperty;
  Ofs:=ofsTView;
  P^.Insert(New(PIntegerProperty, Init('Location.X', ofs, 0, itInteger, false)));
  Ofs:=Ofs+SizeOf(Integer);
  P^.Insert(New(PIntegerProperty, Init('Location.Y', ofs, 0, itInteger, false)));
  Ofs:=Ofs+SizeOf(Integer);
  P^.Insert(New(PBooleanProperty, Init('Modified', ofs, 0, false)));
  CreateIndicatorProperty:=P;
end;

function CreateAboutPanelProperty:PCollection;
var P:PCollection;
    Ofs:word;
begin
  P:=CreateViewsProperty;
  Ofs:=ofsTView;
  P^.Insert(New(PPStrCollectionProperty, Init('AboutString', ofs, 0, false)));
  Ofs:=Ofs+SizeOf(PStringCollection);
  P^.Insert(New(PIntegerProperty, Init('DeltaY', ofs, 0, itInteger, false)));
  Ofs:=Ofs+SizeOf(Integer);
  P^.Insert(New(PIntegerProperty, Init('Ticks', ofs, 0, itInteger, false)));
  Ofs:=Ofs+SizeOf(Integer);
  P^.Insert(New(PPStringProperty, Init('Caption', ofs, 0, false)));
  CreateAboutPanelProperty:=P;
end;

function CreateDrawGridProperty:PCollection;
var P:PCollection;
    Ofs:word;
begin
  P:=CreateViewsProperty;
  Ofs:=ofsTView;
  P^.Insert(New(PLinkProperty, Init('VScrollBar', ofs, 0,[ctScrollBar], true, false)));
  Ofs:=ofs+SizeOf(PScrollBar);
  P^.Insert(New(PLinkProperty, Init('HScrollBar', ofs, 0,[ctScrollBar], true, false)));
  Ofs:=ofs+SizeOf(PScrollBar);
  P^.Insert(New(PLinkProperty, Init('Indicator', ofs, 0,[ctIndicator], true, false)));
  Ofs:=ofs+SizeOf(PIndicator);
  P^.Insert(New(PIntegerProperty, Init('CurPos.X', ofs, 0, itInteger, false)));
  Ofs:=ofs+SizeOf(integer);
  P^.Insert(New(PIntegerProperty, Init('CurPos.Y', ofs, 0, itInteger, false)));
  Ofs:=ofs+SizeOf(integer);
  P^.Insert(New(PIntegerProperty, Init('Delta.X',  ofs, 0, itInteger, false)));
  Ofs:=ofs+SizeOf(integer);
  P^.Insert(New(PIntegerProperty, Init('Delta.Y',  ofs, 0, itInteger, false)));
  Ofs:=ofs+SizeOf(integer);
  P^.Insert(New(PIntegerProperty, Init('Limit.X',  ofs, 0, itInteger, false)));
  Ofs:=ofs+SizeOf(integer);
  P^.Insert(New(PIntegerProperty, Init('Limit.Y',  ofs, 0, itInteger, false)));
  Ofs:=ofs+SizeOf(integer);
  P^.Insert(New(PIntegerProperty, Init('SelectStart.X', ofs, 0, itInteger, false)));
  Ofs:=ofs+SizeOf(integer);
  P^.Insert(New(PIntegerProperty, Init('SelectStart.Y', ofs, 0, itInteger, false)));
  Ofs:=ofs+SizeOf(integer);
  P^.Insert(New(PIntegerProperty, Init('SelectEnd.X', ofs, 0, itInteger, false)));
  Ofs:=ofs+SizeOf(integer);
  P^.Insert(New(PIntegerProperty, Init('SelectEnd.Y', ofs, 0, itInteger, false)));
  Ofs:=ofs+SizeOf(integer);
  P^.Insert(New(PBooleanProperty, Init('Selecting', ofs, 0, false)));
  Ofs:=ofs+SizeOf(boolean);
  P^.Insert(New(PIntegerProperty, Init('DrawLine', ofs, 0, itInteger, false)));
  Ofs:=ofs+SizeOf(integer);
  P^.Insert(New(PBooleanProperty, Init('Modified',  ofs, 0, false)));
  Ofs:=ofs+SizeOf(boolean);
  P^.Insert(New(PIntegerProperty, Init('ScrollMode:', ofs, 0, itChar, false)));
  Ofs:=ofs+SizeOf(Char);
  P^.Insert(New(PBitMapProperty, Init('grOptions', ofs, 0 ,
                 NewSItem('grAutoCalc',
                 NewSItem('grEdit',
                 NewSItem('grNotEdit',
                 NewSItem('grAutoSize',
                 nil)))), 0)));
  Ofs:=ofs+SizeOf(byte);
  P^.Insert(New(PIntegerProperty, Init('WidthTitle', ofs, 0, itInteger, false)));
  Ofs:=ofs+SizeOf(integer);
  CreateDrawGridProperty:=P;
end;

function CreateReportBandProperty(EditReportProp:boolean):PCollection;
var P:PCollection;
    PR:PProperty;
begin
  P:=CreateGroupProperty;
  P^.Insert(New(PLinkProperty, Init('Report', ofsTGroup, hcTReportBandReport,[ctReport], false, EditReportProp)));
  PR:=New(PLinkProperty, Init('Detail', ofsTGroup+4, hcTReportBandDetail,[ctReportBand], true, false));
    PR^.OnAfterEdit:=AfterEditRB_Detail;
    P^.Insert(PR);
  P^.Insert(New(PLockUpProperty, Init('RBType', ofsTGroup+8, hcTReportBandRBType,
                 NewSItem('rbtDocHeader',
                 NewSItem('rbtPageHeader',
                 NewSItem('rbtPageFooter',
                 NewSItem('rbtDocFooter',
                 NewSItem('rbtMain',
                 NewSItem('rbtDetail',
                 NewSItem('rbtBandHeader',
                 NewSItem('rbtBandFooter',
                 NewSItem('rbtGroupHeader',
                 NewSItem('rbtGroupFooter',
                 nil)))))))))), true, itByte, 0)));
  P^.Insert(New(PLinkProperty, Init('DataSourse', ofsTGroup+9, hcTReportBandDataSourse, DSSet, false, false)));
  P^.Insert(New(PBitMapProperty, Init('rbOption', ofsTGroup+13, hcTReportBandrbOption,
                 NewSItem('rbFramed',
                 NewSItem('rbColored',
                 NewSItem('rbHScrollBar',
                 NewSItem('rbVScrollBar',
                 NewSItem('rbNewPagePrint',
                 NewSItem('rbStreched',
                 NewSItem('rbBreaked',
                 nil))))))),0)));
  PR:=New(PLinkProperty, Init('Header', ofsTGroup+14, hcTReportBandHeader, [ctReportBand], false, false));
    PR^.OnAfterEdit:=AfterEditRB_Detail;
    P^.Insert(PR);
  PR:=New(PLinkProperty, Init('Footer', ofsTGroup+18, hcTReportBandFooter, [ctReportBand], false, false));
    PR^.OnAfterEdit:=AfterEditRB_Detail;
    P^.Insert(PR);
  CreateReportBandProperty:=P;
end;

function CreateGroupBandProperty:PCollection;
var P:PCollection;
    PR:PProperty;
begin
  P:=CreateReportBandProperty(false);
  PR:=New(PPStringProperty, Init('GroupExpresion', ofsReportBand, 0, false));
    PR^.OnAfterEdit:=AfterEditGroupBand_GroupExpresion;
    P^.Insert(PR);
  CreateGroupBandProperty:=P;
end;

function CreateReportProperty:PCollection;
var P:PCollection;
    RP:PProperty;
begin
  P:=New(PPropertyCollections, Init(10,5));
  P^.Insert(New(PBitMapProperty, Init('Options', 26, hcTViewOptions,
                 NewSItem('ofSelectable',
                 NewSItem('ofTopSelect',
                 NewSItem('!',            {'ofFirstClick',}
                 NewSItem('!',            {'ofFramed',}
                 NewSItem('ofPreProcess',
                 NewSItem('ofPostProcess',
                 NewSItem('!',            {'ofBuffered',}
                 NewSItem('!',            {'ofTileable',}
                 NewSItem('!',            {'ofCenterX',}
                 NewSItem('!',            {'ofCenterY',}
                 NewSItem('!',            {'ofCentered',}
                 NewSItem('!',            {'ofValidate',}
                 NewSItem('!',
                 NewSItem('ofVersion20',
                 NewSItem('ofVersion30',
                 nil))))))))))))))), 0)));
  P^.Insert(New(PBitMapProperty, Init('EventMask', 28, hcTViewEventMask,
                 NewSItem('!',{'evMouseDown',}
                 NewSItem('!',{evMouseUp',}
                 NewSItem('!',{evMouseMove',}
                 NewSItem('!',{evMouseAuto',}
                 NewSItem('!',{evKeyDown',}
                 NewSItem('!',
                 NewSItem('!',
                 NewSItem('!',
                 NewSItem('evCommand',
                 NewSItem('evBroadcast',
                          nil)))))))))), 0)));
  RP:=New(PPStringProperty, Init('ComponentName',31, hcTViewComponentName, false));
    RP^.OnValidate:=ValidComponentName;
    P^.Insert(RP);
  RP:=New(PLinkProperty, Init('DocHeaderBand', ofsTView, hcTReportDocHeaderBand,[ctReportBand], true, false));
    RP^.OnAfterEdit:=EditReports_Band;
    P^.Insert(RP);
  RP:=New(PLinkProperty, Init('PageHeaderBand', ofsTView+4, hcTReportPageHeaderBand,[ctReportBand], true, false));
    RP^.OnAfterEdit:=EditReports_Band;
    P^.Insert(RP);
  RP:=New(PLinkProperty, Init('PageFooterBand', ofsTView+8, hcTReportPageFooterBand,[ctReportBand], true, false));
    RP^.OnAfterEdit:=EditReports_Band;
    P^.Insert(RP);
  RP:=New(PLinkProperty, Init('DocFooterBand', ofsTView+12, hcTReportDocFooterBand,[ctReportBand], true, false));
    RP^.OnAfterEdit:=EditReports_Band;
    P^.Insert(RP);
  RP:=New(PLinkProperty, Init('MainBand', ofsTView+16, hcTReportMainBand,[ctReportBand], true, false));
    RP^.OnAfterEdit:=EditReports_Band;
    P^.Insert(RP);
  P^.Insert(New(PIntegerProperty, Init('PageHight', ofsTView+20, hcTReportLineInPage, itInteger, false)));
  P^.Insert(New(PIntegerProperty, Init('PageWidth', ofsTView+22, hcTReportLineInPage, itInteger, false)));
  P^.Insert(New(PBooleanProperty, Init('ShowProgres', ofsTView+24, hcTReportShowProgres, false)));
  P^.Insert(New(PBooleanProperty, Init('DoublePass', ofsTView+25, hcTReportShowProgres, false)));
  P^.Insert(New(PIntegerProperty, Init('LeftMargin', ofsTView+26, hcTReportLeftMargin, itInteger, false)));
  P^.Insert(New(PIntegerProperty, Init('RightMargin', ofsTView+28, hcTReportLeftMargin, itInteger, false)));
  P^.Insert(New(PIntegerProperty, Init('TopMargin', ofsTView+30, hcTReportLeftMargin, itInteger, false)));
  P^.Insert(New(PIntegerProperty, Init('BottomMargin', ofsTView+32, hcTReportLeftMargin, itInteger, false)));
  P^.Insert(New(PIntegerProperty, Init('ColumnCount', ofsTView+34, hcTReportLeftMargin, itInteger, false)));
  P^.Insert(New(PIntegerProperty, Init('ColumnMargin', ofsTView+36, hcTReportLeftMargin, itInteger, false)));
  CreateReportProperty:=P;
end;

function CreateReportLabelProperty:PCollection;
var P:PCollection;
    PR:PProperty;
begin
  P:=CreateViewsProperty;
  PR:=New(PLockUpProperty, Init('RLStyle', ofsTView, 0 ,
                 NewSItem('rlsDate',
                 NewSItem('rlsTime',
                 NewSItem('rlsDateTime',
                 NewSItem('rlsPageNo',
                 NewSItem('rlsLineNo',
                 nil))))), false, itByte, 0));
    PR^.OnAfterEdit:=AE_ReportLabel_RLStyle;
  P^.Insert(PR);
  P^.Insert(New(PLinkProperty, Init('Report', ofsTView+1, 0,[ctReport], false, false)));
  P^.Insert(New(PPStringProperty, Init('ParamStr',ofsTView+5, 0, false)));
  CreateReportLabelProperty:=P;
end;

function CreateDBGridProperty:PCollection;
var P:PCollection;
    PR:PProperty;
    Ofs:word;
begin
  P:=CreateViewsProperty;
  Ofs:=OfsTView;
  P^.Insert(New(PLinkProperty, Init('DataScroller', ofs, hcTDBGridDataScroller,[ctDataScroller], true, false)));
  Ofs:=Ofs+SizeOf(PDataScroller);
  PR:=New(PLinkProperty, Init('DataSourse', ofs, hcTDBGridDS, DSSet, false, false));
    PR^.OnAfterEdit:=AfterEditDBGrid_DS;
  P^.Insert(PR);
  Ofs:=Ofs+SizeOf(PDataSourse);
  PR:=New(PProperty, Init('FieldDefs', ofs, hcTDBGridFieldDefs, false));
    PR^.OnGetText:=GetTextDBGrid_FieldDefs;
    PR^.OnEdit:=EditDBGrid_FieldDefs;
  P^.Insert(PR);
  Ofs:=Ofs+SizeOf(PCollection);
  P^.Insert(New(PLinkProperty, Init('ScrollBar', ofs, hcTDBGridScrollBar,[ctScrollBar], true, false)));
  Ofs:=Ofs+SizeOf(PScrollBar);
  P^.Insert(New(PIntegerProperty, Init('TopItem', ofs, hcTDBGrid, itLongint, false)));
  Ofs:=Ofs+SizeOf(Longint);
  P^.Insert(New(PIntegerProperty, Init('Focused', ofs, hcTDBGrid, itLongint, false)));
  Ofs:=Ofs+SizeOf(Longint);
  P^.Insert(New(PBitMapProperty, Init('DBGridOptions', ofs, hcTDBGridMode,
                 NewSItem('dgEditing',
                 NewSItem('dgAlwaysShowEditor',
                 NewSItem('dgTitles',
                 NewSItem('dgIndicator',
                 NewSItem('dgColumnResize',
                 NewSItem('dgColLines',
                 NewSItem('dgRowLines',
                 NewSItem('dgTabs',
                 NewSItem('dgRowSelect',
                 NewSItem('dgAlwaysShowSelection',
                 NewSItem('dgConfirmDelete',
                 NewSItem('dgCancelOnExit',
                 NewSItem('dgMultiSelect',
                          nil))))))))))))), 0)));
  Ofs:=Ofs+SizeOf(TDBGridOptions);
  { NoUpData:Boolean;
    Delta:TPoint;
    CurPos:TPoint;
    NormalColor, SelectedColor, FocusedColor, Color: Word;
    LockFlag:integer;
    DoReDraw:boolean;
    EditPos:integer;
    EditDBPos:Longint;
    UpdateFlag:word;
    SelfEvent:boolean;
  public
    OnColEnter:TNotifyEvent;
    OnColExit:TNotifyEvent;
    OnColumnMoved:TNotifyEvent;
    OnDblClick:TNotifyEvent;
    OnDragDrop:TNotifyEvent;
    OnDragOver:TNotifyEvent;
    OnEditButtonClick:TNotifyEvent;
    OnEndDrag:TNotifyEvent;
    OnEnter:TNotifyEvent;
    OnExit:TNotifyEvent;
    OnKeyDown:TDBGridKeyEvent;
    OnStartDrag:TNotifyEvent;
  }

  {P^.Insert(New(PBooleanProperty, Init('NoUpData', ofsTView+26, hcTDBGridNoUpData, false)));}
  CreateDBGridProperty:=P;
end;

function CreateDBTextProperty:PCollection;
var P:PCollection;
    PR:PProperty;
    Ofs:word;
begin
  P:=CreateStaticTextProperty;
  Ofs:=OfsTStaticText;
  PR:=New(PProperty, Init('Field', ofs, hcTDBTextField, false));
    PR^.OnGetText:=GetTextDBTextField;
    PR^.OnEdit:=EditDBTextField;
  P^.Insert(PR);
  Ofs:=Ofs+SizeOf(PField);
  P^.Insert(New(PLinkProperty, Init('DS', ofs, hcTDBTextDS, DSSet, false, false)));
  Ofs:=Ofs+SizeOf(PDataSourse);
  P^.Insert(New(PPStringProperty, Init('FieldName',ofs, hcTDBTextFieldName, true)));
  Ofs:=Ofs+SizeOf(PString);
  PR:=New(PLockUpProperty, Init('DisplayType', ofs, 0 ,
                 NewSItem('fdNative',
                 NewSItem('fdFloat',
                 NewSItem('fdCurrency',
                 nil))), false, itByte, 0));
  P^.Insert(PR);
  Ofs:=Ofs+SizeOf(TDisplayType);
  CreateDBTextProperty:=P;
end;

function CreateReportMemoProperty:PCollection;
var P:PCollection;
    PR:PProperty;
begin
  P:=CreateViewsProperty;
  PR:=New(PProperty, Init('Field', ofsTView, 0, false));
    PR^.OnGetText:=GetTextReportMemoField;
    PR^.OnEdit:=EditReportMemoField;
  P^.Insert(PR);
  P^.Insert(New(PLinkProperty, Init('DS', ofsTView+4, 0, DSSet, false, false)));
  P^.Insert(New(PPStringProperty, Init('FieldName',ofsTView+8, 0, true)));
  P^.Insert(New(PBooleanProperty, Init('AutoSize', ofsTView+12, 0, false)));
  CreateReportMemoProperty:=P;
end;

function CreateDBLockUpTextProperty:PCollection;
var P:PCollection;
    PR:PProperty;
begin
  P:=CreateDBTextProperty;
  P^.Insert(New(PPStrCollectionProperty, Init('Items', ofsTDBText, 0, false)));
  CreateDBLockUpTextProperty:=P;
end;


function CreateDBLookupComboProperty:PCollection;
var P:PCollection;
    PR:PProperty;
begin
  P:=CreateViewsProperty;
  P^.Insert(New(PLinkProperty, Init('DataSourse', ofsTView, hcTDBLookupComboDataSourse,DSSet, false, false)));
  P^.Insert(New(PLinkProperty, Init('LookupSourse', ofsTView+4, hcTDBLookupComboLookupSourse,DSSet, false, false)));
  PR:=New(PProperty, Init('DataField', ofsTView+8, hcTDBLookupComboDataField, false));
    PR^.OnGetText:=GetTextDBLookupComboField;
    PR^.OnEdit:=EditDBLookupComboField;
  P^.Insert(PR);
  PR:=New(PProperty, Init('LookupField', ofsTView+12, hcTDBLookupComboLookupField, false));
    PR^.OnGetText:=GetTextDBLookupComboField;
    PR^.OnEdit:=EditDBLookupComboField;
  P^.Insert(PR);
  PR:=New(PProperty, Init('LookupDisplay', ofsTView+16, hcTDBLookupComboLookupDisplay, false));
    PR^.OnGetText:=GetTextDBLookupComboField;
    PR^.OnEdit:=EditDBLookupComboField;
  P^.Insert(PR);
  P^.Insert(New(PPStringProperty, Init('DataFieldName',ofsTView+20, hcTDBLookupComboDataFieldName, true)));
  P^.Insert(New(PPStringProperty, Init('LookupFieldName',ofsTView+24, hcTDBLookupComboLookupFieldName, true)));
  P^.Insert(New(PPStringProperty, Init('LookupDisplayName',ofsTView+28, hcTDBLookupComboLookupDisplayName, true)));
  P^.Insert(New(PPStringProperty, Init('DisplayListName',ofsTView+32, hcTDBLookupComboFieldName, false)));
  P^.Insert(New(PBooleanProperty, Init('ReadOnly', ofsTView+36, hcTDBLookupComboReadOnly, false)));

  CreateDBLookupComboProperty:=P;
end;

function CreateDBEditProperty:PCollection;
var P:PCollection;
    PR:PProperty;
begin
  P:=CreateInputLineProperty;
  P^.Insert(New(PLinkProperty, Init('DS', ofsTInputLine, 0,DSSet, false, false)));
  PR:=New(PProperty, Init('Field', ofsTInputLine+4, 0, false));
    PR^.OnGetText:=GetTextDBEditField;
    PR^.OnEdit:=EditDBEditField;
  P^.Insert(PR);
  CreateDBEditProperty:=P;
end;

function CreateDBDateEditProperty:PCollection;
var P:PCollection;
    PR:PProperty;
begin
  P:=CreateDBEditProperty;
  P^.Insert(New(PBooleanProperty, Init('DefaultToday ', ofsTDBEdit, 0, false)));
  CreateDBDateEditProperty:=P;
end;

function CreateDataSourseProperty:PCollection;
var P:PCollection;
    PR:PProperty;
    Ofs:word;
begin
  P:=New(PPropertyCollections, Init(10,5));
  Ofs:=ofsTView;
  PR:=New(PProperty, Init('Active', 0, 0, false));
    PR^.OnGetText:=GetTextDataSourseActive;
    PR^.OnEdit:=EditDataSourseActive;
    P^.Insert(PR);
//  P^.Insert(New(PFunctionsProperty, Init('Active', 0, true, @TDataSourse.GetActive, @TDataSourse.SetActive, fntBoolean)));
  P^.Insert(New(PBitMapProperty, Init('Options', ofsTViewOptions, hcTViewOptions,
                 NewSItem('ofSelectable',
                 NewSItem('ofTopSelect',
                 NewSItem('!',            {'ofFirstClick',}
                 NewSItem('!',            {'ofFramed',}
                 NewSItem('ofPreProcess',
                 NewSItem('ofPostProcess',
                 NewSItem('!',            {'ofBuffered',}
                 NewSItem('!',            {'ofTileable',}
                 NewSItem('!',            {'ofCenterX',}
                 NewSItem('!',            {'ofCenterY',}
                 NewSItem('!',            {'ofCentered',}
                 NewSItem('!',            {'ofValidate',}
                 NewSItem('!',
                 NewSItem('ofVersion20',
                 NewSItem('ofVersion30',
                 nil))))))))))))))), 0)));
  P^.Insert(New(PBitMapProperty, Init('EventMask', ofsTViewEventMask, hcTViewEventMask,
                 NewSItem('!',{'evMouseDown',}
                 NewSItem('!',{evMouseUp',}
                 NewSItem('!',{evMouseMove',}
                 NewSItem('!',{evMouseAuto',}
                 NewSItem('!',{evKeyDown',}
                 NewSItem('!',
                 NewSItem('!',
                 NewSItem('!',
                 NewSItem('evCommand',
                 NewSItem('evBroadcast',
                          nil)))))))))), 0)));
  PR:=New(PPStringProperty, Init('ComponentName', ofsTViewComponentName, hcTViewComponentName, false));
    PR^.OnValidate:=ValidComponentName;
    P^.Insert(PR);
  P^.Insert(New(PBitMapProperty, Init('dbOptions', ofs, 0 ,
                 NewSItem('dboFreeTable',
                 NewSItem('dboAutoOpen',
                 nil)), 0)));
  Ofs:=Ofs+SizeOf(TDataSourseOptions);
  PR:=New(PProperty, Init('TableName', ofs, 0, false));
    PR^.OnEdit:=Edit_TableName;
    PR^.OnGetText:=GetText_TableName;
  P^.Insert(PR);
  ofsDataSourseMaster:=Ofs+SizeOf(PString);
  Ofs:=Ofs+SizeOf(PString)+SizeOf(PDataSourse)+SizeOf(PString)+SizeOf(PCollection);
    {  Master:PDataSourse;
      IndexLists:PStrings;
    private
      WraperList:PCollection;
    }
  PR:=New(PProperty, Init('ReadOnly', 0, 0, true));
  P^.Insert(PR);
//  P^.Insert(New(PFunctionsProperty, Init('ReadOnly', 0, true, @TDBSourse.ReadOnly, nil, fntBoolean)));
  PR:=New(PPStringProperty, Init('DatabaseName',ofs, 0, false));
    PR^.OnEdit:=Edit_DatabaseName;
    P^.Insert(PR);
  PR:=New(PProperty, Init('FieldDefs', 0, 0, false));
    PR^.OnGetText:=GetTextDBGrid_FieldDefs;
    PR^.OnEdit:=Edit_FieldDefs;
  P^.Insert(PR);
  ofsDataSourse:=Ofs;
  CreateDataSourseProperty:=P;
end;

function CreateDBSourseProperty:PCollection;
var P:PCollection;
    PR:PProperty;
    Ofs:word;
begin
  P:=CreateDataSourseProperty;
  Ofs:=ofsDataSourse;
  PR:=New(PProperty, Init('IndexName', 0, 0, false));
    PR^.OnGetText:=GetTextDBSourse_IndexName;
    PR^.OnEdit:=EditDBSourse_IndexName;
  P^.Insert(PR);
  PR:=New(PProperty, Init('IndexDefs', 0, 0, false));
    PR^.OnGetText:=GetTextDBGrid_FieldDefs;
    PR^.OnEdit:=EditDBSourse_IndexDefs;
  P^.Insert(PR);
  PR:=New(PLinkProperty, Init('Master', ofsDataSourseMaster, 0,DSSet, false, false));
    PR^.OnAfterEdit:=AfterEditDS_Master;
    P^.Insert(PR);
  PR:=New(PProperty, Init('MasterField', 0, 0, false));
    PR^.OnGetText:=GetTextDataSourse_MasterField;
    PR^.OnEdit:=EditDataSourse_MasterField;
  P^.Insert(PR);
  PR:=New(PProperty, Init('RecordCount', 0, 0, true));
    PR^.OnGetText:=GetTextDataSourse_RecordCount;
  P^.Insert(PR);
  PR:=New(PProperty, Init('Filter', 0, 0, true));
  P^.Insert(PR);
{  PR:=New(PFunctionsProperty, Init('Filtred', 0, true, @TDBSourse.Filtred, @TDBSourse.SetFiltred, fntBoolean));
  P^.Insert(PR);}
  CreateDBSourseProperty:=P;
end;


function CreateQueryProperty:PCollection;
var P:PCollection;
    PR:PProperty;
begin
  P:=CreateDataSourseProperty;
  PR:=New(PProperty, Init('Text', 0, 0, false));
    PR^.OnGetText:=GetTextQuery_Text;
    PR^.OnEdit:=EditQuery_Text;
  P^.Insert(PR);
  PR:=New(PProperty, Init('Params', 0, 0, false));
    PR^.OnGetText:=GetTextQuery_Params;
    PR^.OnEdit:=EditQuery_Params;
  P^.Insert(PR);
  PR:=New(PProperty, Init('ParamCount', 0, 0, true));
    PR^.OnGetText:=GetTextQuery_ParamCount;
  P^.Insert(PR);
  PR:=New(PBooleanProperty, Init('Prepared', ofsDataSourse+4, 0, true));
     P^.Insert(PR);
  CreateQueryProperty:=P;
end;

function CreateVirtualDataSetProperty:PCollection;
var P:PCollection;
begin
  P:=CreateDataSourseProperty;
  P^.Insert(New(PIntegerProperty, Init('RecordCount', ofsDataSourse, 0 ,itLongint, false)));
  CreateVirtualDataSetProperty:=P;
end;

function CreateDBClusterProperty:PCollection;
var P:PCollection;
    PR:PProperty;
begin
  P:=CreateClusterProperty;
  PR:=New(PProperty, Init('Field', ofsTCluster, 0, false));
    PR^.OnGetText:=GetTextDBClusterField;
    PR^.OnEdit:=EditDBClusterField;
  P^.Insert(PR);
  P^.Insert(New(PLinkProperty, Init('DS', ofsTCluster+4, 0, DSSet, false, false)));
  {FieldName - ofsTCluster+8}
  P^.Insert(New(PBooleanProperty, Init('ReadOnly', ofsTCluster+12, 0, false)));
  CreateDBClusterProperty:=P;
end;

function CreateDBCheckBoxProperty:PCollection;
var P:PCollection;
    PR:PProperty;
begin
  P:=CreateViewsProperty;
  P^.Insert(New(PIntegerProperty, Init('Value',ofsTView, 0 ,itLongint, true)));
  P^.Insert(New(PIntegerProperty, Init('Sel',  ofsTView+4, 0,itInteger, true)));
  PR:=New(PProperty, Init('Field', ofsTCluster, 0, false));
    PR^.OnGetText:=GetTextDBClusterField;
    PR^.OnEdit:=EditDBClusterField;
  P^.Insert(PR);
  P^.Insert(New(PLinkProperty, Init('DS', ofsTCluster+4, 0,DSSet, false, false)));
  {FieldName - ofsTCluster+8}
  P^.Insert(New(PBooleanProperty, Init('ReadOnly', ofsTCluster+12, 0, false)));
  PR:=New(PPStringProperty, Init('ValueChecked', ofsTCluster+13, 0, false));
    PR^.OnAfterEdit:=DBCB_AfterE_VC;
  P^.Insert(PR);
  PR:=New(PPStringProperty, Init('ValueUnchecked', ofsTCluster+17, 0, false));
    PR^.OnAfterEdit:=DBCB_AfterE_VC;
  P^.Insert(PR);
  PR:=New(PProperty, Init('Strings', 0, 0, false));
    PR^.OnGetText:=GetTextDBCB_Strings;
    PR^.OnEdit:=EditDBCB_Strings;
  P^.Insert(PR);
  CreateDBCheckBoxProperty:=P;
end;

function CreateDialogProperty:PCollection;
var P:PCollection;
    PR:PProperty;
begin
  P:=New(PPropertyCollections, Init(10,5));
  P^.Insert(New(PIntegerProperty, Init('Origin.X', 8, hcTViewOrigin, itInteger, false)));
  P^.Insert(New(PIntegerProperty, Init('Origin.Y',10, hcTViewOrigin, itInteger, false)));
  P^.Insert(New(PIntegerProperty, Init('Size.X', 12, hcTViewSize, itInteger, false)));
  P^.Insert(New(PIntegerProperty, Init('Size.Y', 14, hcTViewSize, itInteger, false)));
  P^.Insert(New(PIntegerProperty, Init('Cursor.X', 16, hcTViewCursor, itInteger, false)));
  P^.Insert(New(PIntegerProperty, Init('Cursor.Y', 18, hcTViewCursor, itInteger, false)));
  P^.Insert(New(PBitMapProperty, Init('GrowMode',20, hcTViewGrowMode,
                 NewSItem('gfGrowLoX',
                 NewSItem('gfGrowLoY',
                 NewSItem('gfGrowHiX',
                 NewSItem('gfGrowHiY',
                 NewSItem('gfGrowRel',
                          nil))))), 0)));
  P^.Insert(New(PBitMapProperty, Init('DragMode',21, hcTViewDragMode,
                 NewSItem('dmDragMove',
                 NewSItem('dmDragGrow',
                 NewSItem('dmLimitLoX',
                 NewSItem('dmLimitLoY',
                 NewSItem('dmLimitHiX',
                 NewSItem('dmLimitHiY',
                          nil)))))), 0)));
  PR:=New(PBitMapProperty, Init('State', 24, hcTViewState,
                 NewSItem('sfVisible',
                 NewSItem('sfCursorVis',
                 NewSItem('sfCursorIns',
                 NewSItem('sfShadow',
                 NewSItem('sfActive',
                 NewSItem('sfSelected',
                 NewSItem('sfFocused',
                 NewSItem('sfDragging',
                 NewSItem('sfDisabled',
                 NewSItem('sfModal',
                 NewSItem('sfDefault',
                 NewSItem('sfExposed',
                          nil)))))))))))),
                          sfActive or sfDisabled or sfDefault or sfExposed));
    PR^.OnEdit:=EditView_State;
  P^.Insert(PR);
  PR:=New(PProperty, Init('HelpCtx', 22, hcTViewHelpCtx, false));
     PR^.OnGetText:=Views_GetTextHlpCtx;
     PR^.OnEdit:=Views_EditHelpCtx;
  P^.Insert(PR);
  P^.Insert(New(PBitMapProperty, Init('Options', 26, hcTViewOptions,
                 NewSItem('ofSelectable',
                 NewSItem('ofTopSelect',
                 NewSItem('ofFirstClick',
                 NewSItem('ofFramed',
                 NewSItem('ofPreProcess',
                 NewSItem('ofPostProcess',
                 NewSItem('ofBuffered',
                 NewSItem('ofTileable',
                 NewSItem('ofCenterX',
                 NewSItem('ofCenterY',
                 NewSItem('ofCentered',
                 NewSItem('ofValidate',
                 NewSItem('!',
                 NewSItem('ofVersion20',
                 NewSItem('ofVersion30',
                 nil))))))))))))))), 0)));
  P^.Insert(New(PBitMapProperty, Init('EventMask', 28, hcTViewEventMask,
                 NewSItem('evMouseDown',
                 NewSItem('evMouseUp',
                 NewSItem('evMouseMove',
                 NewSItem('evMouseAuto',
                 NewSItem('evKeyDown',
                 NewSItem('!',
                 NewSItem('!',
                 NewSItem('!',
                 NewSItem('evCommand',
                 NewSItem('evBroadcast',
                          nil)))))))))), 0)));
  PR:=New(PPStringProperty, Init('ComponentName',31, hcTViewComponentName, false));
      PR^.OnAfterEdit:=AfterEditComponentNameDialog;
      P^.Insert(PR);
  P^.Insert(New(PBitMapProperty, Init('Flags', ofsTGroup, hcTWindowFlags,
                 NewSItem('wfMove',
                 NewSItem('wfGrow',
                 NewSItem('wfClose',
                 NewSItem('wfZoom',
                 nil)))), 0)));
  P^.Insert(New(PIntegerProperty, Init('ZoomRect.A.X',  ofsTGroup+1, hcTWindowZoomRect, itInteger, false)));
  P^.Insert(New(PIntegerProperty, Init('ZoomRect.A.Y',  ofsTGroup+3, hcTWindowZoomRect, itInteger, false)));
  P^.Insert(New(PIntegerProperty, Init('ZoomRect.B.X',  ofsTGroup+5, hcTWindowZoomRect, itInteger, false)));
  P^.Insert(New(PIntegerProperty, Init('ZoomRect.B.Y',  ofsTGroup+7, hcTWindowZoomRect, itInteger, false)));
  P^.Insert(New(PIntegerProperty, Init('Number',  ofsTGroup+9, hcTWindowNumber, itInteger, false)));
  PR:=New(PLockUpProperty, Init('Palette', ofsTGroup+11, hcTWindowPalette, {size -2}
                 NewSItem('dpBlueDialog',
                 NewSItem('dpCyanDialog',
                 NewSItem('dpGrayDialog',
                 nil))), false, itByte, 0));
  P^.Insert(PR);
  PR:=New(PProperty, Init('ProcName', 0, hcNoContext, false));
    PR^.OnGetText:=GetTextForm_ProcName;
    PR^.OnEdit:=EditForm_ProcName;
  P^.Insert(PR);
  PR:=New(PProperty, Init('UnitName', 0, hcNoContext, false));
    PR^.OnGetText:=GetTextForm_UnitName;
    PR^.OnEdit:=EditForm_UnitName;
  P^.Insert(PR);
  PR:=New(PProperty, Init('ResName', 0, hcNoContext, false));
    PR^.OnGetText:=GetTextForm_ResName;
    PR^.OnEdit:=EditForm_ResName;
  P^.Insert(PR);
  {  Frame: PFrame; - 132}
  P^.Insert(New(PPStringProperty, Init('Title', ofsTGroup+17, hcTWindowTitle, false)));
  PR:=New(PProperty, Init('Current', 0, 0, false));
    PR^.OnGetText:=GetTextForm_Current;
    PR^.OnEdit:=EditForm_Current;
  P^.Insert(PR);
  CreateDialogProperty:=P;
end;

function CreateHistoryProperty:PCollection;
var P:PCollection;
    PR:PProperty;
begin
  P:=CreateViewsProperty;
  P^.Insert(New(PLinkProperty, Init('Link', ofsTView, 0,[ctInputLine,ctInputLineUC,
                               ctInputLinePS, ctInputLineLC, ctFilterInput,
                               ctRangeILine, ctInputSegOfs, ctDBEdit
                               ], false, false)));
  P^.Insert(New(PIntegerProperty, Init('HistoryId',  ofsTView+4, 0, itWord, false)));
  CreateHistoryProperty:=P;
end;

function CreateTabbedNotebookProperty:PCollection;
var P:PCollection;
    PR:PProperty;
begin
  P:=CreateViewsProperty;
  P^.Insert(New(PIntegerProperty, Init('CurPageNum',  ofsTView+4, 0, itInteger, true)));
{    PageCollection:PCollection;}
  CreateTabbedNotebookProperty:=P;
end;

function CreateDataScrollerProperty:PCollection;
var P:PCollection;
    PR:PProperty;
begin
  P:=CreateViewsProperty;
  P^.Insert(New(PLinkProperty, Init('DS', ofsTView, 0, DSSet, false, false)));
  CreateDataScrollerProperty:=P;
end;

function CreateDBNavigatorBtnProperty:PCollection;
var P:PCollection;
    PR:PProperty;
begin
{  P:=CreateButtonProperty;}
  P:=CreateViewsProperty;
  P^.Insert(New(PPStringProperty, Init('Title', ofsTView, 0 , false)));
  PR:=New(PLockUpProperty, Init('Command', ofsTView+4, 0 ,
                 NewSItem('cmPrevRec',
                 NewSItem('cmNextRec',
                 NewSItem('cmFirstRec',
                 NewSItem('cmLastRec',
                 NewSItem('cmMoveBy',
                 NewSItem('cmDeleteRec',
                 NewSItem('cmRecalRec',
                 NewSItem('cmEditRec',
                 NewSItem('cmAppendRec',
                 NewSItem('cmPostRec',
                 NewSItem('cmCancelRec',
                 nil))))))))))), false, itWord, cmPrevRec));
{     PR^.OnAfterEdit:=AfterEditButton_Command;}
     P^.Insert(PR);
  PR:=New(PBitMapProperty, Init('Flags',ofsTView+6, 0 ,
                 NewSItem('bfDefault',
                 NewSItem('bfLeftJust',
                 NewSItem('bfBroadcast',
                 NewSItem('bfGrabFocus',
                          nil)))), 0));
     PR^.OnAfterEdit:=AfterEditButton_Flags;
     P^.Insert(PR);
  P^.Insert(New(PBooleanProperty, Init('AmDefault', ofsTView+7, 0 , true)));
  P^.Insert(New(PLinkProperty, Init('DS', ofsTView+8, 0, DSSet, false, false)));
  CreateDBNavigatorBtnProperty:=P;
end;

function CreateColorSelectorProperty:PCollection;
var P:PCollection;
begin
  P:=CreateViewsProperty;
  P^.Insert(New(PIntegerProperty, Init('Color',  ofsTView, 0, itByte, true)));
  P^.Insert(New(PLockUpProperty, Init('SelType', ofsTView+1, 0 ,
                 NewSItem('csBackground',
                 NewSItem('csForeground',
                 nil)), false, itWord, 0)));
  CreateColorSelectorProperty:=P;
end;

function CreateColorDisplayProperty:PCollection;
var P:PCollection;
begin
  P:=CreateViewsProperty;
{    Color: ^Byte; +4}
  P^.Insert(New(PPStringProperty, Init('Text', ofsTView+4, 0 , false)));
  CreateColorDisplayProperty:=P;
end;

function CreateReportShapeProperty:PCollection;
var P:PCollection;
begin
  P:=CreateViewsProperty;
  P^.Insert(New(PLockUpProperty, Init('Shape', ofsTView, 0 ,
                 NewSItem('rsRectangle',
                 NewSItem('rsTopAndBottom',
                 NewSItem('rsRightAndLeft',
                 nil))), false, itByte, 0)));
  P^.Insert(New(PLockUpProperty, Init('PenStyle', ofsTView+1, 0 ,
                 NewSItem('psSingleLine',
                 NewSItem('psDoubleLine',
                 nil)), false, itByte, 0)));
  CreateReportShapeProperty:=P;
end;

function CreateDirListBoxProperty:PCollection;
var P:PCollection;
    PR:PProperty;
begin
  P:=CreateListViewProperty;
     PR:=New(PStringProperty, Init('Dir', ofsTView+32, 0 , 67, false));
     PR^.OnAfterEdit:=AfterEditDirListBox_Dir;
  P^.Insert(PR);
  CreateDirListBoxProperty:=P;
end;

function CreateFieldProperty:PCollection;
var P:PCollection;
    RP:PProperty;
    Ofs:word;
begin
  P:=New(PPropertyCollections, Init(10,5));
  Ofs:=SizeOf(PDataSet);
  P^.Insert(New(PIntegerProperty, Init('FieldNo', Ofs, 0, itInt16, true)));
  Ofs:=Ofs+SizeOf(Int16);
  P^.Insert(New(PPStringProperty, Init('Name',  Ofs, 0, true)));
  Ofs:=Ofs+SizeOf(PString);
  P^.Insert(New(PIntegerProperty, Init('Size', Ofs, 0, itWord, true)));
  Ofs:=Ofs+SizeOf(Word);
  P^.Insert(New(PIntegerProperty, Init('Dec', ofs, 0, itbyte, true)));
  Ofs:=Ofs+SizeOf(Byte);
  P^.Insert(New(PLockUpProperty, Init('FieldType', Ofs, 0 ,
                 NewSItem('ftUnknown',
                 NewSItem('ftString',
                 NewSItem('ftSmallint',
                 NewSItem('ftInteger',
                 NewSItem('ftWord',
                 NewSItem('ftBoolean',
                 NewSItem('ftFloat',
                 NewSItem('ftCurrency',
                 NewSItem('ftBCD',
                 NewSItem('ftDate',
                 NewSItem('ftTime',
                 NewSItem('ftDateTime',
                 NewSItem('ftBytes',
                 NewSItem('ftVarBytes',
                 NewSItem('ftAutoInc',
                 NewSItem('ftBlob',
                 NewSItem('ftMemo',
                 NewSItem('ftGraphic',
                 NewSItem('ftFmtMemo',
                 NewSItem('ftParadoxOle',
                 NewSItem('ftDBaseOle',
                 NewSItem('ftTypedBinary',
                 nil)))))))))))))))))))))), true, itByte, 0)));
  Ofs:=Ofs+SizeOf(TFieldType);
  P^.Insert(New(PIntegerProperty, Init('PtrInBuf', Ofs, 0, itWord, true)));
  Ofs:=Ofs+SizeOf(word);
  P^.Insert(New(PLockUpProperty, Init('Align', 16, 0 ,
                 NewSItem('alNone',
                 NewSItem('alTop',
                 NewSItem('alBottom',
                 NewSItem('alLeft',
                 NewSItem('alRight',
                 NewSItem('alClient',
                 NewSItem('alCenter',
                 nil))))))), false, itByte, 0)));
  ofsTField:=Ofs+SizeOf(TAlign)+SizeOf(Pointer)+SizeOf(boolean);
{     Info:Pointer; - 17}
{  P^.Insert(New(PBooleanProperty, Init('isCurrency', 21, 0 , true)));     }

  CreateFieldProperty:=P;
end;

function CreateStringFieldProperty:PCollection;
var P:PCollection;
    RP:PProperty;
begin
  P:=CreateFieldProperty;
  P^.Insert(New(PPStringProperty, Init('DefaultValue',  ofsTField, 0, false)));
  CreateStringFieldProperty:=P;
end;

function CreateIntegerFieldProperty:PCollection;
var P:PCollection;
    RP:PProperty;
    Ofs:word;
begin
  P:=CreateFieldProperty;
  Ofs:=ofsTField;
  P^.Insert(New(PIntegerProperty, Init('MinRange', ofs, 0, itLongint, false)));
  Ofs:=Ofs+SizeOf(Longint);
  P^.Insert(New(PIntegerProperty, Init('MaxRange', ofs, 0, itLongint, false)));
  Ofs:=Ofs+SizeOf(Longint);
  P^.Insert(New(PBooleanProperty, Init('CheckRange', ofs, 0 , false)));
  CreateIntegerFieldProperty:=P;
end;

function CreateDateFieldProperty:PCollection;
var P:PCollection;
    RP:PProperty;
begin
  P:=CreateFieldProperty;
  P^.Insert(New(PPStringProperty, Init('DisplayFormat',  ofsTField, 0, false)));
  CreateDateFieldProperty:=P;
end;

function CreateFloatFieldProperty:PCollection;
var P:PCollection;
    RP:PProperty;
    Ofs:word;
begin
  P:=CreateFieldProperty;
  Ofs:=ofsTField;
  P^.Insert(New(PBooleanProperty, Init('isCurrency', ofsTField-SizeOf(Boolean), 0 , false)));
  P^.Insert(New(PIntegerProperty, Init('MinValue', ofs, 0, itDouble, false)));
  Ofs:=Ofs+SizeOf(Double);
  P^.Insert(New(PIntegerProperty, Init('MaxValue', ofs, 0, itDouble, false)));
  Ofs:=Ofs+SizeOf(Double);
  P^.Insert(New(PBooleanProperty, Init('CheckRange', ofs, 0 , false)));
  CreateFloatFieldProperty:=P;
end;

function CreateBooleanFieldProperty:PCollection;
var P:PCollection;
    RP:PProperty;
    Ofs:word;
begin
  P:=CreateFieldProperty;
  Ofs:=ofsTField;
  P^.Insert(New(PPStringProperty, Init('TextValuesTrue',  ofs, 0, false)));
  Ofs:=Ofs+SizeOf(PString);
  P^.Insert(New(PPStringProperty, Init('TextValuesFalse',  ofs, 0, false)));
  CreateBooleanFieldProperty:=P;
end;
{
   TLockUpField = object(TIntegerField)
     Items:PStrings;
     ErrorValue:PString;
}
procedure CreatePropertyLists(var RezFile:TResourceFile);
var
  P:PCollection;
begin
  P:=CreateViewsProperty;
  RezFile.Put( P, 'Property_Uknow type');
  RezFile.Put( P, 'Property_ASCIITable');
  Dispose( P, Done);
  P:=CreateStaticTextProperty;
  RezFile.Put( P, 'Property_StaticText');
  Dispose( P, Done);
  P:=CreateParamTextProperty;
  RezFile.Put( P, 'Property_ParamText');
  Dispose( P, Done);
  P:=CreateLabelProperty;
  RezFile.Put( P, 'Property_Label');
  Dispose( P, Done);
  P:=CreateInputLineProperty;
  RezFile.Put( P, 'Property_InputLine');
  RezFile.Put( P, 'Property_InputLineUC');
  RezFile.Put( P, 'Property_InputLineLC');
  RezFile.Put( P, 'Property_InputSegOfs');
  RezFile.Put( P, 'Property_FilterInput');
  Dispose( P, Done);
  P:=CreateLockUpInputLineProperty;
  RezFile.Put( P, 'Property_LockUpInputLine');
  Dispose( P, Done);
  P:=CreateDateEditProperty;
  RezFile.Put( P, 'Property_DateEdit');
  Dispose( P, Done);
  P:=CreateInputLinePSProperty;
  RezFile.Put( P, 'Property_InputLinePS');
  Dispose( P, Done);
  P:=CreatePercentGaugeProperty;
  RezFile.Put( P, 'Property_PercentGauge');
  RezFile.Put( P, 'Property_BarGauge');
  Dispose( P, Done);
  P:=CreateScrollBarProperty;
  RezFile.Put( P, 'Property_ScrollBar');
  Dispose( P, Done);
  P:=CreateButtonProperty;
  RezFile.Put( P, 'Property_Button');
  Dispose( P, Done);
  P:=CreateListViewProperty;
  RezFile.Put( P, 'Property_ListBox');
  RezFile.Put( P, 'Property_ElementGroupList');
  RezFile.Put( P, 'Property_ElementItemList');
  RezFile.Put( P, 'Property_SortedListBox');
  RezFile.Put( P, 'Property_OkListBox');
  RezFile.Put( P, 'Property_ListViewer');
  Dispose( P, Done);
  P:=CreateMultiSelectListViewProperty;
  RezFile.Put( P, 'Property_MultiSelBox');
  Dispose( P, Done);
  P:=CreateClockViewProperty;
  RezFile.Put( P, 'Property_ClockView');
  Dispose( P, Done);
  P:=CreateASCIIReportProperty;
  RezFile.Put( P, 'Property_ASCIIReport');
  Dispose( P, Done);
  P:=CreateRangeILineProperty;
  RezFile.Put( P, 'Property_RangeILine');
  Dispose( P, Done);
  P:=CreateColorTextProperty;
  RezFile.Put( P, 'Property_ColorText');
  Dispose( P, Done);
  P:=CreateScrollerProperty;
  RezFile.Put( P, 'Property_Outline');
  Dispose( P, Done);
  P:=CreateClusterProperty;
  RezFile.Put( P, 'Property_MonoSelector');
  RezFile.Put( P, 'Property_RadioButtons');
  RezFile.Put( P, 'Property_CheckBoxes');
  Dispose( P, Done);
  P:=CreateMultiCheckBoxesProperty;
  RezFile.Put( P, 'Property_MultiCheckBoxes');
  Dispose( P, Done);
  P:=CreateMemoProperty;
  RezFile.Put( P, 'Property_Memo');
  Dispose( P, Done);
  P:=CreateIndicatorProperty;
  RezFile.Put( P, 'Property_Indicator');
  Dispose( P, Done);
  P:=CreateAboutPanelProperty;
  RezFile.Put( P, 'Property_AboutPanel');
  Dispose( P, Done);
  P:=CreateDrawGridProperty;
  RezFile.Put( P, 'Property_DrawGrid');
  RezFile.Put( P, 'Property_StringGrid');
  Dispose( P, Done);
{  P:=CreateReportBandProperty(true);
  RezFile.Put( P, 'Property_ReportBand');
  Dispose( P, Done);
  P:=CreateGroupBandProperty;
  RezFile.Put( P, 'Property_GroupBand');
  Dispose( P, Done);
  P:=CreateReportProperty;
  RezFile.Put( P, 'Property_Report');
  Dispose( P, Done);
  P:=CreateReportLabelProperty;
  RezFile.Put( P, 'Property_ReportLabel');
  Dispose( P, Done);}
  P:=CreateDBGridProperty;
  RezFile.Put( P, 'Property_DBGrid');
  Dispose( P, Done);
  P:=CreateDBTextProperty;
  RezFile.Put( P, 'Property_DBText');
  Dispose( P, Done);
{  P:=CreateDBLockUpTextProperty;
  RezFile.Put( P, 'Property_DBLockUpText');
  RezFile.Put( P, 'Property_DBLookupEdit');
  Dispose( P, Done);
  P:=CreateDBLookupComboProperty;
  RezFile.Put( P, 'Property_DBLookupCombo');
  Dispose( P, Done);
  P:=CreateDBEditProperty;
  RezFile.Put( P, 'Property_DBEdit');
  Dispose( P, Done);
  P:=CreateDBDateEditProperty;
  RezFile.Put( P, 'Property_DBDateEdit');
  Dispose( P, Done);       }
  P:=CreateDataSourseProperty;
  RezFile.Put( P, 'Property_DataSourse');
  Dispose( P, Done);
{  P:=CreateQueryProperty;
  RezFile.Put( P, 'Property_Query');
  Dispose( P, Done);}

  P:=CreateDBSourseProperty;
  RezFile.Put( P, 'Property_DBSourse');
  Dispose( P, Done);
{  P:=CreateDBClusterProperty;
  RezFile.Put( P, 'Property_DBCluster');
  RezFile.Put( P, 'Property_DBRadioButtons');
  P:=CreateDBCheckBoxProperty;
  RezFile.Put( P, 'Property_DBCheckBox');
  Dispose( P, Done);
  P:=CreateDialogProperty;
  RezFile.Put( P, 'Property_Dialog');
  Dispose( P, Done);
  P:=CreateHistoryProperty;
  RezFile.Put( P, 'Property_History');
  Dispose( P, Done);
  P:=CreateTabbedNotebookProperty;
  RezFile.Put( P, 'Property_TabbedNotebook');
  Dispose( P, Done);
  P:=CreateDataScrollerProperty;
  RezFile.Put( P, 'Property_DataScroller');
  Dispose( P, Done);
  P:=CreateDBNavigatorBtnProperty;
  RezFile.Put( P, 'Property_DBNavigatorBtn');
  Dispose( P, Done);
  P:=CreateColorSelectorProperty;
  RezFile.Put( P, 'Property_ColorSelector');
  Dispose( P, Done);
  P:=CreateColorDisplayProperty;
  RezFile.Put( P, 'Property_ColorDisplay');
  Dispose( P, Done);
  P:=CreateReportMemoProperty;
  RezFile.Put( P, 'Property_ReportMemo');
  Dispose( P, Done);
  P:=CreateDirListBoxProperty;
  RezFile.Put( P, 'Property_DirListBox');
  Dispose( P, Done);}
  P:=CreateDBMemoProperty;
  RezFile.Put( P, 'Property_DBMemo');
  Dispose( P, Done);
  P:=CreateFieldProperty;
  RezFile.Put( P, 'Property_ftUnknown');
  RezFile.Put( P, 'Property_ftMemo');
  Dispose( P, Done);
  P:=CreateStringFieldProperty;
  RezFile.Put( P, 'Property_ftString');
  Dispose( P, Done);
  P:=CreateDateFieldProperty;
  RezFile.Put( P, 'Property_ftDate');
  RezFile.Put( P, 'Property_ftTime');
  RezFile.Put( P, 'Property_ftDateTime');
  Dispose( P, Done);
  P:=CreateIntegerFieldProperty;
  RezFile.Put( P, 'Property_ftInteger');
  Dispose( P, Done);
  P:=CreateFloatFieldProperty;
  RezFile.Put( P, 'Property_ftFloat');
  RezFile.Put( P, 'Property_ftCurrency');
  Dispose( P, Done);
  P:=CreateBooleanFieldProperty;
  RezFile.Put( P, 'Property_ftBoolean');
  Dispose( P, Done);
  P:=CreateReportShapeProperty;
  RezFile.Put( P, 'Property_ReportShape');
  Dispose( P, Done);
  P:=CreateVirtualDataSetProperty;
  RezFile.Put( P, 'Property_VirtualDataSet');
  Dispose( P, Done);
end;

end.
