{$O+,F-,X+,I-,S-}
unit SelElem;
interface
uses Objects, GlType, Views, Register;

function BuildList:PStringCollection;
function ANameType( ObjType:TComponentType):String;

implementation
uses Dialogs, App, Global, Ext_App, Editors, GauGes, DataCtrl, AddCntrl,
     OutLine, Grids, DBGrids, StdDlg, Multisel, Menus, AboutPn, DBCtrls,
     ASCIITab, GadGets, Reports, Cursors, TabNotbk, El_Lists, Querys,
     ColorSel;


function ANameType( ObjType:TComponentType):String;
begin
  ANameType:='';
  case ObjType of
    ctUknow           :ANameType:='Uknow type';
    ctView            :ANameType:='View';
    ctFrame           :ANameType:='Frame';
    ctScrollBar       :ANameType:='ScrollBar';
    ctScroller        :ANameType:='Scroller';
    ctListViewer      :ANameType:='ListViewer';
    ctGroup           :ANameType:='Group';
    ctWindow          :ANameType:='Window';
    ctDialog          :ANameType:='Dialog';
    ctInputLine       :ANameType:='InputLine';
    ctButton          :ANameType:='Button';
    ctCluster         :ANameType:='Cluster';
    ctRadioButtons    :ANameType:='RadioButtons';
    ctCheckBoxes      :ANameType:='CheckBoxes';
    ctMultiCheckBoxes :ANameType:='MultiCheckBoxes';
    ctListBox         :ANameType:='ListBox';
    ctStaticText      :ANameType:='StaticText';
    ctParamText       :ANameType:='ParamText';
    ctLabel           :ANameType:='Label';
    ctHistoryViewer   :ANameType:='HistoryViewer';
    ctHistoryWindow   :ANameType:='HistoryWindow';
    //ctHistory         :ANameType:='History';
    ctIndicator       :ANameType:='Indicator';
    ctEditor          :ANameType:='Editor';
    ctMemo            :ANameType:='Memo';
    ctFileEditor      :ANameType:='FileEditor';
    ctEditWindow      :ANameType:='EditWindow';
    ctPercentGauge    :ANameType:='PercentGauge';
    ctBarGauge        :ANameType:='BarGauge';
    ctOutlineViewer   :ANameType:='OutlineViewer';
    ctOutline         :ANameType:='Outline';
    ctGridInputLine   :ANameType:='GridInputLine';
    ctDrawGrid        :ANameType:='DrawGrid';
    ctStringGrid      :ANameType:='StringGrid';
    ctFileInputLine   :ANameType:='FileInputLine';
    ctSortedListBox   :ANameType:='SortedListBox';
    ctFileList        :ANameType:='FileList';
    ctFileInfoPane    :ANameType:='FileInfoPane';
    ctFileDialog      :ANameType:='FileDialog';
    ctDirListBox      :ANameType:='DirListBox';
    ctChDirDialog     :ANameType:='ChDirDialog';
    ctMultiSelBox     :ANameType:='MultiSelBox';
    ctMenuView        :ANameType:='MenuView';
    ctMenuBar         :ANameType:='MenuBar';
    ctMenuBox         :ANameType:='MenuBox';
    ctMenuPopup       :ANameType:='MenuPopup';
    ctStatusLine      :ANameType:='StatusLine';
    ctAboutPanel      :ANameType:='AboutPanel';
    ctDataSourse      :ANameType:='DataSourseObj';
    ctDBSourse       :ANameType:='DBSourse';
    ctElementGroupList:ANameType:='ElementGroupList';
    ctElementItemList :ANameType:='ElementItemList';
    ctInputLineUC     :ANameType:='InputLineUC';
    ctInputLinePS     :ANameType:='InputLinePS';
    ctInputLineLC     :ANameType:='InputLineLC';
    ctFilterInput     :ANameType:='FilterInput';
    ctColorText       :ANameType:='ColorText';
    ctRangeILine      :ANameType:='RangeILine';
    ctInputSegOfs     :ANameType:='InputSegOfs';
    ctLockUpBox       :ANameType:='LockUpBox';
    ctLockUpInputLine :ANameType:='LockUpInputLine';
    ctOkListBox       :ANameType:='OkListBox';
    ctOutputViewer    :ANameType:='OutputViewer';
    ctCalenPanel      :ANameType:='CalenPanel';
    ctDateEdit        :ANameType:='DateEdit';
    ctDBLookupCombo   :ANameType:='DBLookupCombo';
    ctDBText          :ANameType:='DBText';
    ctDBEdit          :ANameType:='DBEdit';
    ctDBGrid          :ANameType:='DBGrid';
    ctASCIITable      :ANameType:='ASCIITable';
    ctASCIIReport     :ANameType:='ASCIIReport';
    ctASCIIChart      :ANameType:='ASCIIChart';
    ctClockView       :ANameType:='ClockView';
    ctHeapView        :ANameType:='HeapView';
    ctCursor          :ANameType:='Cursor';
    ctReportBandBackground:ANameType:='ReportBandBackground';
    ctReportBand      :ANameType:='ReportBand';
    ctReport          :ANameType:='Report';
    ctReportLabel     :ANameType:='ReportLabel';
    ctDBLockUpText    :ANameType:='DBLockUpText';
    ctDBCluster       :ANameType:='DBCluster';
    ctDBRadioButtons  :ANameType:='DBRadioButtons';
    ctDBCheckBox      :ANameType:='DBCheckBox';
    ctHistory         :ANameType:='History';
    ctTabbedNotebook  :ANameType:='TabbedNotebook';
    ctDBLookupEdit    :ANameType:='DBLookupEdit';
    ctDataScroller    :ANameType:='DataScroller';
    ctQuery           :ANameType:='Query';
    ctDBNavigatorBtn  :ANameType:='DBNavigatorBtn';
    ctColorSelector   :ANameType:='ColorSelector';
    ctMonoSelector    :ANameType:='MonoSelector';
    ctColorDisplay    :ANameType:='ColorDisplay';
    ctReportMemo      :ANameType:='ReportMemo';
    ctDBMemo          :ANameType:='DBMemo';
    ctDBDateEdit      :ANameType:='DBDateEdit';
    ctReportShape     :ANameType:='ReportShape';
    ctVirtualDataSet  :ANameType:='VirtualDataSet';
    ctUserDataSet     :ANameType:='UserDataSet';
    ctMenuButton      :ANameType:='MenuButton';
    ctGroupBand       :ANameType:='GroupBand';
  else
    writeln(ObjType, '  Error!!!');
  end;
end;

function BuildList:PStringCollection;
var
  List:PStringCollection;
  i:TComponentType;
begin
  List:=New(PStringCollection, init( CountComponents, 0));
  for i:=0 to CountComponents do List^.AtInsert( Ord(i), NewStr(ANameType(i)));
  BuildList:=List;
end;

end.
