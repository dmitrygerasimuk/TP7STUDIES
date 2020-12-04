{$F-}
uses {$IFDEF VER70} {$IFNDEF DPMI} Overlay, {$ENDIF} {$ENDIF}
     Drivers, Objects, Views, Dialogs, Menus, App, CmdConst, ResTools,
     StdDlg, RESSTRS, Global, Editors, AddCntrl, CrElem, ResHelp, GauGes,
     MouseDlg, AsciiTab, ColorSel, Calendar, StdForms, Reports, Puzzle,
     NodeObj, CmdNamer, Ext_Type, AboutPn, DAE, Prperty, Clases, Ext_Mous,
     Dos, Ext_Dos, Ext_Math, DBFTable, DataCtrl, DBGrids, TabNotbk, GL_Proc,
     El_Lists, Validate, Ext_Str, DBT_Unit, Fpt_Unit,
{$IFDEF VER70}
     PXTable,
{$ENDIF}
     OutLine,
     Ext_Sys, CrString, Ext_Hlp, Register, Std_Str, ShardEdt, DAEQuery;

{$O Views}
{$O Strings}
{$O Objects}
{$O Dialogs}
{$O App}
{$O Cursors}
{.$O Querys}
{.$O SQL_Pars}
{.$O MathEval}
{$O Ext_Mous}
{$O Editors}
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
{$O Field_Ed}

{$O IniFile}
{$O Ext_mous}
{$O Ext_Crt}
{$O Ext_Prn}
{$O Ext_Help}
{$O Ext_Clp}
{$O Ext_App}
{$O Ext_Edit}
{$O ShardEdt}
{$O Ext_Clp}
{$O Forms}
{$O Clases}
{$O AddCntrl}
{$O Gauges}
{$O MultiSel}
{$O AboutPn}
{$O TabNotbk}
{$O El_Lists}
{$O Grids}

{$O PXEngine}
{$O PXDATA}
{$O PXINTER}
{$O PXISAM1}
{$O PXISAM2}
{$O PXOS}
{$O PXSORT}
{$O DBGrids}
{$O DBCtrls}
{$O DataCtrl}
{O DBTable}
{$O Reports}

{$O Global}
{$O StdForms}
{$O PropEdit}
{$O GL_Proc}
{$O Property}
{$O StdForms}
{$O Set_Opt}
{$O CmdNamer}
{$O PrgMng}
{$O NodeObj}
{$O _DBTUnit}
{$O _FPTUnit}

procedure CreateFileOpenDialog;
var
  P: PView;
begin
  P := New(PFileDialog, Init(sExtPas, 'Open a File',
    '~N~ame', fdOpenButton + fdHelpButton + fdNoLoadDir, 100));
    P^.HelpCtx := hcFOFileOpenDBox;
  ResourseFile.Put(P, 'FileOpenDialog');
  P^.Free;

  P:=New(PFileDialog, Init(sExtPas,
    {$IFNDEF RUS}'Save File As'{$ELSE}'Сохранить файл как'{$ENDIF},
    {$IFNDEF RUS}'Save File As'{$ELSE}'~С~охранить файл как'{$ENDIF},
    fdOkButton + fdHelpButton + fdNoLoadDir, 100));
    P^.HelpCtx := hcFOFileOpenDBox;
  ResourseFile.Put(P, 'SaveAsDialog');
  P^.Free;


  P := New(PFileDialog, Init(sExtFrm, 'Open a File',
    '~N~ame', fdOpenButton + fdHelpButton + fdNoLoadDir, 100));
    P^.HelpCtx := hcFOFileOpenDBox;
    ResourseFile.Put(P, sFormOpenDialog);
    P^.Free;

  P := New(PFileDialog, Init(sExtFrm, 'Save a File',
    '~N~ame', fdOkButton + fdHelpButton + fdNoLoadDir, 100));
    P^.HelpCtx := hcFOFileOpenDBox;
    ResourseFile.Put(P, sFormSaveDialog);
    P^.Free;
  P := New(PFileDialog, Init(sExtText, 'Open a text file','~N~ame',
    fdOpenButton + fdHelpButton + fdNoLoadDir, 102));
    ResourseFile.Put(P, sOpenText);
    P^.Free;
  P := New(PFileDialog, Init(sExtText, 'Save a text file','~N~ame',
    fdOkButton + fdHelpButton + fdNoLoadDir, 103));
    ResourseFile.Put(P, sSaveText);
    P^.Free;
  P := New(PFileDialog, Init(sExtText,
        'Save report as', '~N~ame', fdOkButton + fdHelpButton + fdNoLoadDir, 103));
    ResourseFile.Put(P, 'SaveAsReport');
    P^.Free;

  P := New(PFileDialog, Init('*.dbf', 'Open a table',
    '~N~ame', fdOpenButton + fdHelpButton + fdNoLoadDir, 106));
  P^.HelpCtx := hcFOFileOpenDBox;
  ResourseFile.Put(P, 'DBFOpenDialog');
    P^.Free;

  P := New(PFileDialog, Init(sExtDbf, 'Create a table',
    '~N~ame', fdOkButton + fdHelpButton + fdNoLoadDir, 106));
  P^.HelpCtx := hcFOFileOpenDBox;
  ResourseFile.Put(P, 'DBFCreateDialog');
    P^.Free;

  P := New(PFileDialog, Init('*.dsk', 'Open a Desktop file',
    '~N~ame', fdOpenButton + fdHelpButton + fdNoLoadDir, 107));
  P^.HelpCtx := hcFOFileOpenDBox;
  ResourseFile.Put(P, 'DSKOpenDialog');
    P^.Free;

  P := New(PFileDialog, Init('*.dsk', 'Save a Desktop file',
    '~N~ame', fdOkButton + fdHelpButton + fdNoLoadDir, 108));
  P^.HelpCtx := hcFOFileOpenDBox;
  ResourseFile.Put(P, 'DSKSaveDialog');
    P^.Free;

  P:= New(PFileDialog, Init(sExtPrg, 'Open Project',
    '~N~ame', fdOpenButton + fdHelpButton + fdNoLoadDir, 109));
  ResourseFile.Put(P, 'ProgectDialog');
    P^.Free;

  P:= New(PFileDialog, Init('*.prj', 'Save Project',
    '~N~ame', fdOkButton + fdHelpButton + fdNoLoadDir, 110));
  ResourseFile.Put(P, 'ProgectSaveDialog');
    P^.Free;

  P := New(PFileDialog, Init('*.itv', 'Open a index',
    '~N~ame', fdOpenButton + fdHelpButton + fdNoLoadDir, 111));
    P^.HelpCtx := hcOpenDBox_ITV;
    ResourseFile.Put(P, '.ITV');
    P^.Free;
  P := New(PFileDialog, Init('*.ntx', 'Open a index',
    '~N~ame', fdOpenButton + fdHelpButton + fdNoLoadDir, 111));
    P^.HelpCtx := hcOpenDBox_NTX;
    ResourseFile.Put(P, '.NTX');
    P^.Free;
  P := New(PFileDialog, Init('*.ind', 'Open a index',
    '~N~ame', fdOpenButton + fdHelpButton + fdNoLoadDir, 111));
    P^.HelpCtx := hcOpenDBox_IND;
    ResourseFile.Put(P, '.IND');
    P^.Free;
  P := New(PFileDialog, Init('*.ndx', 'Open a index',
    '~N~ame', fdOpenButton + fdHelpButton + fdNoLoadDir, 111));
    P^.HelpCtx := hcOpenDBox_NDX;
    ResourseFile.Put(P, '.NDX');
    P^.Free;
  P := New(PFileDialog, Init('*.idx', 'Open a index',
    '~N~ame', fdOpenButton + fdHelpButton + fdNoLoadDir, 111));
    P^.HelpCtx := hcOpenDBox_IDX;
    ResourseFile.Put(P, '.IDX');
    P^.Free;
  P := New(PFileDialog, Init('*.hlp', 'Open a help file',
    '~N~ame', fdOpenButton + fdHelpButton + fdNoLoadDir, 112));
    P^.HelpCtx := hcOpenDBox_IDX;
    ResourseFile.Put(P, 'OpenHelpFileDialog');
    P^.Free;
  P := New(PFileDialog, Init('*.cfg', 'Open config file',
    '~N~ame', fdOpenButton + fdHelpButton + fdNoLoadDir, 116));
    P^.HelpCtx := hcOpenDBox_IDX;
    ResourseFile.Put(P, 'DAE_CFG_LOAD');
    P^.Free;
  P := New(PFileDialog, Init('*.cfg', 'Store config file',
    '~N~ame', fdOkButton + fdHelpButton + fdNoLoadDir, 117));
    P^.HelpCtx := hcOpenDBox_IDX;
    ResourseFile.Put(P, 'DAE_CFG_STORE');
    P^.Free;

  P := New(PFileDialog, Init(sExtPas, 'Open a SQL text',
    '~N~ame', fdOpenButton + fdHelpButton + fdNoLoadDir, 118));
    ResourseFile.Put(P, sOpenSQL);
    P^.Free;

  P := New(PFileDialog, Init(sExtPas,
      {$IFNDEF RUS}'Save a SQL text'{$ELSE}'Сохранить текст SQL'{$ENDIF},
      {$IFNDEF RUS}'~N~ame'{$ELSE}'~И~мя'{$ENDIF},
      fdOpenButton + fdHelpButton + fdNoLoadDir, 119));
    ResourseFile.Put(P, sSaveSQL);

  P := New(PFileDialog, Init('*.tph', 'Help files',
    '~H~elp file name', fdOpenButton + fdHelpButton + fdNoLoadDir, 120));
    ResourseFile.Put(P, 'OpenTPH');
  P^.Free;
  P := New(PFileDialog, Init(sExtPas,
     {$IFDEF RUS}'Читать блок из файла'
     {$ELSE}'Read Block from File'
     {$ENDIF},
     {$IFDEF RUS}'Читать блок из файла'
     {$ELSE}'~R~ead block from'
     {$ENDIF},fdOpenButton + fdHelpButton + fdNoLoadDir, 121));
    ResourseFile.Put(P, 'ReadBlock');
  P^.Free;
  P := New(PFileDialog, Init(sExtPas,
     {$IFDEF RUS}'Записать блок в файл'
     {$ELSE}'Write Block to File'
     {$ENDIF},
     {$IFDEF RUS}'Записать блок в файл'
     {$ELSE}'~W~rite block to'
     {$ENDIF}, fdOkButton + fdHelpButton + fdNoLoadDir, 122));
    ResourseFile.Put(P, 'WriteBlock');
  P^.Free;
end;

procedure CreateProjectOpenDialog;
var R:TRect;
    Form:PDialog;
begin
   R.Assign( 18,  3, 60, 15);
   Form:=New(PDialog,Init(R,{$IFDEF RUS}'Об авторе...'{$ELSE}'About...'{$ENDIF}));
   with Form^ do
   begin
      R.Assign( 14,  9, 25, 11);
        Insert(New(PButton, Init( R, strOk, cmOK, bfDefault)));
      GetExtent(R);
      R.Grow(-1,0);
      R.A.Y:=2; R.B.Y:=R.A.Y+1;
        Insert(New(PStaticText, Init( R,
        {$IFDEF RUS}^C'Редакт форм для Turbo Vision'
        {$ELSE}^C'Turbo Vision form maker.'{$ENDIF})));
      R.Move(0,2);
        Insert(New(PStaticText, Init( R,^C'v '+FloatToStr(VerNum))));
      R.Move(0,2);
        Insert(New(PStaticText, Init( R,^C'(c) 1995-'+IntToStr(CurrentYear)+' by Alexs. ')));
      GetExtent(R);
      R.Grow(-1,-1);
      Dec(R.B.Y,3);
      Insert(New(PAboutPanel,Init(R,'Об авторе...',
             NewSItem(^C'Задуман в 1995 году.',
             NewSItem(^C'Начал делать в декабре',
             NewSItem(^C'1995 года.',
             NewSItem(^C'Конкретно многие идеи',
             NewSItem(^C'оформились после работы',
             NewSItem(^C'с BORLAND DELPHI v 1.0',
             NewSItem(^C'поэтому можно найти',
             NewSItem(^C'много схожего.',
             NewSItem(^C'Версия 0.91 была написана',
             NewSItem(^C'к июню 1996 года.',
             NewSItem(^C'Продолжение было начато',
             NewSItem(^C'уже в сентябре 1996 года.',
             NewSItem(^C'Версия 0.96 написана в октябре',
             NewSItem(^C'Версия 2.0 начала испытываться в 1998',
             NewSItem(^C'с 1996 года',
             NewSItem(^C'на проект стало оказывать влияние',
             NewSItem(^C'DELPHI 2.0.',
             NewSItem(^C'На данный момент существует только верися',
             NewSItem(^C'для Borland pascal 7.0',
             NewSItem(^C'планируется осуществить',
             NewSItem(^C'перенос на FreePascal',
             NewSItem(^C'С уважением',
             NewSItem(^C'Лагунов Алексей Анатольевич (Alexs).',
             NewSItem(^C' ',
             NewSItem(^C' ',
             NewSItem(^C' ',
             nil)))))))))))))))))))))))))))));
   end;
  ResourseFile.Put(Form, 'About');
  Form^.Free;
end;

procedure CreateGetForm;
var R:TRect;
    ScrollBar:PScrollBar;
    ElementGroupList1:PElementGroupList;
    ElementItemList1:PElementItemList;
    Form1:PDialog;
begin
   R.Assign( 12,  3, 67, 19);
   Form1:=New(PDialog,Init(R,{$IFNDEF RUS}'Select component'
                             {$ELSE}'Выберите компонент'{$ENDIF}));
   with Form1^ do
   begin
      R.Assign( 24,  3, 25, 12);
        ScrollBar:=New(PScrollBar, Init( R));
        Insert(ScrollBar);
      R.Assign(  1,  3, 24, 12);
        ElementGroupList1:=New(PElementGroupList, Init( R, ScrollBar,
           ElementGroup({$IFNDEF RUS}'Standart'{$ELSE}'Стандарт'{$ENDIF},
                ElementItem('StaticText',
                ElementItem('Label',
                ElementItem('Horizontal Scroll Bar',
                ElementItem('Vertical Scroll Bar',
                ElementItem('InputLine',
                ElementItem('Button',
                ElementItem('ListViewer',
                ElementItem('ListBox',
                ElementItem('RadioButtons',
                ElementItem('CheckBoxes',
                ElementItem('Memo',
                ElementItem('Indicator',
                nil)))))))))))),
           ElementGroup({$IFNDEF RUS}'Extended'{$ELSE}'Расширено'{$ENDIF},
                ElementItem('MultiCheckBoxes',
                ElementItem('PercentGauge',
                ElementItem('BarGauge',
                ElementItem('ParamText',
                ElementItem('MultiSelBox',
                ElementItem('Outline',
                ElementItem('ElementGroupList',
                ElementItem('ElementItemList',
                ElementItem('ColorText',
                nil))))))))),
           ElementGroup({$IFNDEF RUS}'Additional'{$ELSE}'Дополнительно'{$ENDIF},
                ElementItem('SortedListBox',
                ElementItem('InputLineUC',
                ElementItem('InputLineLC',
                ElementItem('InputLinePS',
                ElementItem('FilterInput',
                ElementItem('DateEdit',
                ElementItem('RangeILine',
                ElementItem('AboutPanel',
                ElementItem('OkListBox',
                ElementItem('LockUpInputLine',
                ElementItem('History',
                ElementItem('DrawGrid',
                ElementItem('StringGrid',
                nil))))))))))))),
           ElementGroup({$IFNDEF RUS}'Samples'{$ELSE}'Прмеры'{$ENDIF},
                ElementItem('ASCIITable',
                ElementItem('ASCIIReport',
                ElementItem('ClockView',
                ElementItem('TabbedNotebook',
                ElementItem('ColorSelector',
                ElementItem('MonoSelector',
                ElementItem('ColorDisplay',
                ElementItem('DirListBox',
                nil)))))))),
           ElementGroup({$IFNDEF RUS}'Data Control'{$ELSE}'Отображение данных'{$ENDIF},
                ElementItem('DBGrid',
                ElementItem('DataScroller',
                ElementItem('DBNavigatorBtn',
                ElementItem('DBText',
                ElementItem('DBLockUpText',
                ElementItem('DBLookupCombo',
                ElementItem('DBEdit',
                ElementItem('DBRadioButtons',
                ElementItem('DBCheckBox',
                ElementItem('DBLookupEdit',
                ElementItem('DBMemo',
                ElementItem('DBDateEdit',
                nil)))))))))))),
           ElementGroup({$IFNDEF RUS}'Data sourse'{$ELSE}'Источники данных'{$ENDIF},
                ElementItem('DBSourse',
                ElementItem('Query',
                ElementItem('VirtualDataSet',
                ElementItem('UserDataSet',
                nil)))),
           ElementGroup({$IFNDEF RUS}'DB Report''s'{$ELSE}'Отчёты'{$ENDIF},
                ElementItem('Report',
                ElementItem('ReportBand',
                ElementItem('GroupBand',
                ElementItem('ReportLabel',
                ElementItem('ReportMemo',
                ElementItem('ReportShape',
                nil)))))),
           nil)))))))));
        Insert(ElementGroupList1);
      R.Assign(  1,  2, 15,  3);
        Insert(New(PLabel, Init( R,{$IFNDEF RUS}'~C~omponents group'
                                   {$ELSE}'~Г~руппы компонент'{$ENDIF}, ElementGroupList1)));
      R.Assign( 51,  3, 52, 12);
        ScrollBar:=New(PScrollBar, Init( R));
        Insert(ScrollBar);
      R.Assign( 28,  3, 51, 12);
        ElementItemList1:=New(PElementItemList, Init( R,ScrollBar, nil));
        Insert(ElementItemList1);
      R.Assign( 28,  2, 37,  3);
        Insert(New(PLabel, Init( R,{$IFNDEF RUS}'C~o~mponents'
                                   {$ELSE}'~К~омпоненты'{$ENDIF}, ElementItemList1)));
      R.Assign(  4, 13, 15, 15);
        Insert(New(PButton, Init( R, strOk, cmOK, bfDefault)));
      R.Assign( 23, 13, 34, 15);
        Insert(New(PButton, Init( R, strCancel, cmCancel, bfNormal)));
      SelectNext(False);
   end;
  ResourseFile.Put(Form1, 'ObjectInspector');
  Dispose(Form1, Done);
end;

procedure CreateTools;
var
  D: PDialog;
  P:PView;
begin
  P := New(PAsciiChart, Init);
    P^.HelpCtx := hcAsciiTable;
    ResourseFile.Put(P, 'AsciiTable');
    Dispose(P, Done);
  P := New(PCalendarWindow, Init);
    P^.HelpCtx := hcCalendar;
    ResourseFile.Put(P, 'CalendarWindow');
    Dispose(P, Done);
  D := New(PChDirDialog, Init(cdNormal + cdHelpButton, 101));
    D^.HelpCtx := hcFCChDirDBox;
    ResourseFile.Put(D, 'ChDirDialog');
    Dispose(D, Done);
  P := New(PPuzzleWindow, Init);
    P^.HelpCtx := hcPuzzle;
    ResourseFile.Put(P, 'Puzzle');
    Dispose(P, Done);
  D := New(PExtMouseDlg, Init);
    D^.HelpCtx := hcOMMouseDBox;
    ResourseFile.Put(D, 'MouseDlg');
    Dispose(D, Done);
  D := New(PColorDialog, Init('',
    ColorGroup({$IFNDEF RUS}'Desktop'{$ELSE}'Экран'{$ENDIF},       DesktopColorItems(nil),
    ColorGroup({$IFNDEF RUS}'Menus'{$ELSE}'Меню'{$ENDIF},         MenuColorItems(nil),
    ColorGroup({$IFNDEF RUS}'Gray Dialogs'{$ELSE}'Диалог сер.'{$ENDIF},  DialogColorItems(dpGrayDialog, nil),
    ColorGroup({$IFNDEF RUS}'Blue Dialogs'{$ELSE}'Диалог гол.'{$ENDIF},  DialogColorItems(dpBlueDialog, nil),
    ColorGroup({$IFNDEF RUS}'Cyan Dialogs'{$ELSE}'Диалог бир.'{$ENDIF},  DialogColorItems(dpCyanDialog, nil),
    ColorGroup({$IFNDEF RUS}'Editor/Puzzle'{$ELSE}'Редактор'{$ENDIF}, WindowColorItems(wpBlueWindow, nil),
    ColorGroup({$IFNDEF RUS}'Ascii table'{$ELSE}'Таблица Ascii'{$ENDIF},   WindowColorItems(wpGrayWindow, nil),
    ColorGroup({$IFNDEF RUS}'Help'{$ELSE}'Помощь'{$ENDIF},
      ColorItem('Frame passive',hsNumbers,
      ColorItem('Frame active',hsNumbers,
      ColorItem('Frame icons',hsNumbers,
      ColorItem('Scroll bar page',hsNumbers,
      ColorItem('Scroll bar icons',hsNumbers,
      ColorItem('Normal text',hsNumbers,
      ColorItem('Normal example',hsNumbers,
      ColorItem('Normal keyword',hsNumbers,
      ColorItem('Highlight keyword',hsNumbers,
      ColorItem('Selected text',hsNumbers,
      ColorItem('Selected example',hsNumbers,
      ColorItem('Selected keyword',hsNumbers,
      ColorItem('Sel/high keyword',hsNumbers,
      nil))))))))))))),
    ColorGroup({$IFNDEF RUS}'Calendar'{$ELSE}'Календарь'{$ENDIF},
      WindowColorItems(wpCyanWindow,
      ColorItem('Current day',       22, nil)),
    ColorGroup({$IFNDEF RUS}'Help syntax'{$ELSE}'Синтаксис помощи'{$ENDIF},
      ColorItem({$IFNDEF RUS}'Reserved words'{$ELSE}'Служ.слова'{$ENDIF},    hsReservedWords,
      ColorItem({$IFNDEF RUS}'Cross ref.'{$ELSE}'Ссылки'{$ENDIF},        hsCrossRef,
      ColorItem({$IFNDEF RUS}'Numbers'{$ELSE}'Номера'{$ENDIF},           hsNumbers,
      ColorItem({$IFNDEF RUS}'Comments'{$ELSE}'Коментарии'{$ENDIF},          hsComments,
      nil)))),
    ColorGroup({$IFNDEF RUS}'Pascal syntax'{$ELSE}'Синтаксис паскаля'{$ENDIF},
      ColorItem({$IFNDEF RUS}'Whitespace'{$ELSE}'Пробелы'{$ENDIF},        psWhitespace,
      ColorItem({$IFNDEF RUS}'Comments'{$ELSE}'Коментарии'{$ENDIF},          psComments,
      ColorItem({$IFNDEF RUS}'Reserved words'{$ELSE}'Служ.слова'{$ENDIF},    psReservedWords,
      ColorItem({$IFNDEF RUS}'Identifiers'{$ELSE}'Идентификаторы'{$ENDIF},       psIdentifiers,
      ColorItem({$IFNDEF RUS}'Symbols'{$ELSE}'Символы'{$ENDIF},           psSymbols,
      ColorItem({$IFNDEF RUS}'Strings'{$ELSE}'Строки'{$ENDIF},           psStrings,
      ColorItem({$IFNDEF RUS}'Numbers'{$ELSE}'Числа'{$ENDIF},           psNumbers,
      ColorItem({$IFNDEF RUS}'Assembler'{$ELSE}'Ассемблер'{$ENDIF},         psAssembler,
      nil)))))))),
      nil)))))))))))));
  D^.HelpCtx := hcOCColorsDBox;
    ResourseFile.Put(D, 'ColorDlg');
    Dispose(D, Done);
  P:=CreateObjectWin;
    ResourseFile.Put(P, 'NodeObj');
    Dispose(P, Done);
    CommandDB:=New(PCommandCollection,Init(10,5));
    CommandNameDB:=New(PCommandNameCollection,Init(10,5));
    BuiltInCommandNames;
    ResourseFile.Put(CommandDB, 'CommandDB');
    Dispose(CommandDB, Done);
    ResourseFile.Put(CommandNameDB, 'CommandNameDB');
    Dispose(CommandNameDB, Done);
end;

procedure CreateResurseListDialog;
var R:TRect;
    ScrollBar1:PScrollBar;
    Form1:PDialog;
begin
   R.Assign( 10,  3, 69, 19);
   Form1:=New(PDialog,Init(R,'Select resurse...'));
   with Form1^ do
   begin
      R.Assign( 41,  1, 42, 15);
        ScrollBar1:=New(PScrollBar, Init( R));
        Insert(ScrollBar1);
      R.Assign(  1,  1, 41, 15);
        Insert(New(PListBox, Init( R,1, ScrollBar1)));
      R.Assign( 44,  1, 55,  3);
        Insert(New(PButton, Init( R, strOk, cmOK, bfDefault)));
      R.Assign( 44,  4, 55,  6);
        Insert(New(PButton, Init( R, strCancel, cmCancel, bfNormal)));
      R.Assign( 44, 10, 55, 12);
        Insert(New(PButton, Init( R, strHelp, cmHelp, bfNormal)));
   end;
  ResourseFile.Put( Form1, 'SelectRes');
  Dispose( Form1, Done);
end;

procedure CreateInfoDialog;
var R:TRect;
    Form1:PDialog;
begin
   R.Assign( 10,  5, 70, 20);
   Form1:=New(PDialog,Init(R,'Information'));
   with Form1^ do
   begin
      R.Assign( 15,  2, 44,  3);
        Insert(New(PParamText, Init( R,'CPU - %d',1)));
      R.Assign(  3,  4, 25,  5);
        Insert(New(PParamText, Init( R,'All mem - %d',1)));
      R.Assign( 31,  4, 54,  5);
        Insert(New(PParamText, Init( R,'Free mem - %d',1)));
      R.Assign( 14,  7, 44,  8);
        Insert(New(PParamText, Init( R,'OS -  %s',1)));
      R.Assign( 23, 12, 33, 14);
        Insert(New(PButton, Init( R, strOk, cmOK, bfDefault)));
      R.Assign( 34, 12, 44, 14);
        Insert(New(PButton, Init( R, strCancel, cmCancel, bfNormal)));
      R.Assign( 47, 12, 57, 14);
        Insert(New(PButton, Init( R, strHelp, cmHelp, bfNormal)));
      SelectNext(false);
   end;
  ResourseFile.Put( Form1, 'InfoDlg');
  Dispose( Form1, Done);
end;



procedure CreateSetClusterOpt;
var R:TRect;
    V:PInputLine;
    HS,VS:PScrollBar;
    I:PIndicator;
    Form1:PDialog;
begin
   R.Assign(  4,  1, 75, 22);
   Form1:=New(PDialog,Init(R,{$IFNDEF RUS}'Text editor'{$ELSE}'Редактор текстов'{$ENDIF}));
   with Form1^ do
   begin
      R.Assign(  1, 19, 10, 20);
        I:=New(PIndicator, Init( R));
        Insert(I);
      R.Assign( 11, 19, 51, 20);
        VS:=New(PScrollBar, Init( R));
        Insert(VS);
      R.Assign( 51,  1, 52, 19);
        HS:=New(PScrollBar, Init( R));
        Insert(HS);
      R.Assign(  1,  1, 51, 19);
        Insert(New(PMemo, Init( R, HS, VS, I, 4096)));
      R.Assign( 58,  2, 69,  4);
        Insert(New(PButton, Init( R, strOk, cmOK, bfDefault)));
      R.Assign( 58,  4, 69,  6);
        Insert(New(PButton, Init( R, strCancel, cmCancel, bfNormal)));
      R.Assign( 58,  8, 69, 10);
        Insert(New(PButton, Init( R, {$IFNDEF RUS}'~L~oad'{$ELSE}'~О~ткрыть'{$ENDIF}, cmYes, bfNormal)));
      R.Assign( 58, 10, 69, 12);
        Insert(New(PButton, Init( R, {$IFNDEF RUS}'~S~ave'{$ELSE}'~С~охранить'{$ENDIF}, cmNo, bfNormal)));
      SelectNext(false);
   end;
  ResourseFile.Put(Form1, sTextEditor);
  Dispose(Form1, Done);
end;

procedure CreateCompOpt;
var R:TRect;
    P:PView;
    Form1:PDialog;
begin
   R.Assign( 10,  1, 70, 22);
   Form1:=New(PDialog,Init(R,{$IFNDEF RUS}'Compiler Options'
                             {$ELSE}'Опции компилятора'{$ENDIF}));
   with Form1^ do
   begin
      R.Assign(  3,  2, 57,  5);
        P:=New(PCheckBoxes, Init( R,
                  NewSItem('~F~orce far calls',
                  NewSItem('~O~verlays allowed',
                  NewSItem('Word ~a~lign data',
                  NewSItem('~2~86 instructions',
                  NewSItem('Smart callbac~k~s',
                  NewSItem('~W~indows stack frames',
                  nil))))))));
        PCluster(P)^.EnableMask:=$FFFFFFCF;
        P^.HelpCtx:=hcForceFarCalls;
        Insert(P);
      R.Assign(  2,  1, 19,  2);
        Insert(New(PLabel, Init( R,{$IFNDEF RUS}'Code generation'
                                   {$ELSE}'Генерация кода'{$ENDIF}, P)));
      R.Assign(  3,  6, 27, 10);
        P:=New(PCheckBoxes, Init( R,
                  NewSItem('~R~ange checking',
                  NewSItem('~S~tack checking',
                  NewSItem('~I~/O checking',
                  NewSItem('Overflow ~c~hecking',
                  nil))))));
        P^.HelpCtx:=hcRangeChecking;
        Insert(P);
      R.Assign(  2,  5, 22,  6);
        Insert(New(PLabel, Init( R,{$IFNDEF RUS}'Runtime errors'
                                   {$ELSE}'Ошибки выполнения'{$ENDIF}, P)));
      R.Assign( 30,  6, 57, 11);
        P:=New(PCheckBoxes, Init( R,
                  NewSItem('Strict ~v~ar-strings',
                  NewSItem('Complete ~b~oolean eval',
                  NewSItem('E~x~tended syntax',
                  NewSItem('~T~yped @ operator',
                  NewSItem('Open ~p~arameters',
                  nil)))))));
        Insert(P);
        P^.HelpCtx:=hcStrictVarStrings;
      R.Assign( 29,  5, 57,  6);
        Insert(New(PLabel, Init( R,{$IFNDEF RUS}'Syntax options'
                                   {$ELSE}'Синтаксис'{$ENDIF}, P)));
      R.Assign(  3, 11, 27, 14);
        P:=New(PCheckBoxes, Init( R,
                  NewSItem('~D~ebug information',
                  NewSItem('~L~ocal symbols',
                  NewSItem('S~y~mbol information',
                  nil)))));
        P^.HelpCtx:=hcDebugInformation;
        Insert(P);
      R.Assign(  2, 10, 28, 11);
        Insert(New(PLabel, Init( R,{$IFNDEF RUS}'Debugging'
                                   {$ELSE}'Отладка'{$ENDIF}, P)));
      R.Assign( 30, 12, 57, 14);
        P:=New(PCheckBoxes, Init( R,
                  NewSItem('~8~087/80287',
                  NewSItem('~E~mulation',
                  nil))));
        P^.HelpCtx:=hc_8087_80287;
        Insert(P);
      R.Assign( 29, 11, 57, 12);
        Insert(New(PLabel, Init( R,{$IFNDEF RUS}'Numeric processing'
                                   {$ELSE}'Сопроцесор'{$ENDIF}, P)));
      R.Assign(  3, 16, 54, 17);
        P:=New(PInputLine, Init( R, 60));
        P^.HelpCtx:=hcConditDefine;
        Insert(P);
      R.Assign(  54, 16, 57, 17);
        Insert(New(PHistory, Init(R, PInputLine(P), 1)));
      R.Assign(  2, 15, 24, 16);
        Insert(New(PLabel, Init( R,{$IFNDEF RUS}'Conditio~n~al defines'
                                   {$ELSE}'Ди~р~ективы компилятора'{$ENDIF}, P)));
      R.Assign( 25, 18, 35, 20);
        P:=New(PButton, Init( R, strOk, cmOK, bfDefault));
        P^.HelpCtx:=hcOkBtn;
        Insert(P);
      R.Assign( 35, 18, 45, 20);
        P:=New(PButton, Init( R, strCancel, cmCancel, bfNormal));
        P^.HelpCtx:=hcCancleBtn;
        Insert(P);
      R.Assign( 48, 18, 58, 20);
        P:=New(PButton, Init( R, strHelp, cmHelp, bfNormal));
        P^.HelpCtx:=hcHelpBtn;
        Insert(P);
      SelectNext(false);
   end;
   ResourseFile.Put( Form1, 'CompOpt');
   Dispose( Form1, Done);
end;

procedure CreatePrefDlg;
var R:TRect;
    P:PView;
    Form1:PDialog;
begin
   R.Assign( 0,  0, 60, 18);
   Form1:=New(PDialog,Init(R,{$IFNDEF RUS}'Preferences'{$ELSE}'Настройки'{$ENDIF}));
   with Form1^ do
   begin
      Options := Options or ofCentered;
      R.Assign(  3,  3, 28,  5);
        P:=New(PRadioButtons, Init( R,
                  NewSItem('~2~5 '+{$IFNDEF RUS}'lines'{$ELSE}'строк'{$ENDIF},
                  NewSItem('~4~3/50 '+{$IFNDEF RUS}'lines'{$ELSE}'строк'{$ENDIF},
                  nil))));
        Insert(P);
      R.Assign(  2,  2, 20,  3);
        Insert(New(PLabel, Init( R,{$IFNDEF RUS}'Screen sizes'{$ELSE}'Размер экрана'{$ENDIF}, P)));
      R.Assign( 30,  3, 57,  5);
        P:=New(PRadioButtons, Init( R,
                  NewSItem({$IFNDEF RUS}'~N~ew window'{$ELSE}'Новое окно'{$ENDIF},
                  NewSItem({$IFNDEF RUS}'~C~urrent window'{$ELSE}'Текущее окно'{$ENDIF},
                  nil))));
        Insert(P);
      R.Assign( 29,  2, 47,  3);
        Insert(New(PLabel, Init( R,{$IFNDEF RUS}'Source tracking'{$ELSE}'Исходный текст'{$ENDIF}, P)));
      R.Assign(  3,  7, 28,  9);
        P:=New(PCheckBoxes, Init( R,
                  NewSItem({$IFNDEF RUS}'~C~loc'{$ELSE}'Часы'{$ENDIF},
                  NewSItem({$IFNDEF RUS}'~H~eap'{$ELSE}'Размер кучи'{$ENDIF},
                  nil))));
        Insert(P);
      R.Assign(  2,  6, 19,  7);
        Insert(New(PLabel, Init( R,{$IFNDEF RUS}'Desktop tools'{$ELSE}'Инструменты'{$ENDIF}, P)));
      R.Assign( 30,  7, 57,  9);
        P:=New(PRadioButtons, Init( R,
                  NewSItem({$IFNDEF RUS}'C~u~rrent directory'{$ELSE}'Текущий каталог'{$ENDIF},
                  NewSItem({$IFNDEF RUS}'Conf~i~g file directory'{$ELSE}'Главный каталог'{$ENDIF},
                  nil))));
        Insert(P);
      R.Assign( 29,  6, 54,  7);
        Insert(New(PLabel, Init( R,{$IFNDEF RUS}'Desktop file'{$ELSE}'Файл настроек'{$ENDIF}, P)));
      R.Assign(  3, 11, 28, 14);
        P:=New(PCheckBoxes, Init( R,
                  NewSItem({$IFNDEF RUS}'Editor ~f~iles'{$ELSE}'Файлы редактора'{$ENDIF},
                  NewSItem({$IFNDEF RUS}'~E~nvironment'{$ELSE}'Окружение'{$ENDIF},
                  NewSItem({$IFNDEF RUS}'~D~esktop'{$ELSE}'Экран'{$ENDIF},
                  nil)))));
        Insert(P);
      R.Assign(  2, 10, 28, 11);
        Insert(New(PLabel, Init( R,{$IFNDEF RUS}'Auto save'{$ELSE}'Автосохранять'{$ENDIF}, P)));
      R.Assign( 30, 11, 57, 14);
        P:=New(PCheckBoxes, Init( R,
                  NewSItem({$IFNDEF RUS}'~A~uto track source'{$ELSE}'Исходный текст'{$ENDIF},
                  NewSItem({$IFNDEF RUS}'C~l~ose on go to source'{$ELSE}'Закрывать при открытии'{$ENDIF},
                  NewSItem({$IFNDEF RUS}'C~h~ange dir on open'{$ELSE}'Выбирать каталог файла'{$ENDIF},
                  nil)))));
        Insert(P);
      R.Assign( 29, 10, 55, 11);
        Insert(New(PLabel, Init( R,{$IFNDEF RUS}'Options'{$ELSE}'Опции'{$ENDIF}, P)));
      R.Assign( 25, 15, 35, 17);
        P:=New(PButton, Init( R, strOk, cmOK, bfDefault));
        P^.HelpCtx:=hcOkBtn;
        Insert(P);
      R.Assign( 35, 15, 45, 17);
        P:=New(PButton, Init( R, strCancel, cmCancel, bfNormal));
        P^.HelpCtx:=hcCancleBtn;
        Insert(P);
      R.Assign( 47, 15, 57, 17);
        P:=New(PButton, Init( R, strHelp, cmHelp, bfNormal));
        P^.HelpCtx:=hcHelpBtn;
        Insert(P);
      SelectNext(false);
   end;
   ResourseFile.Put( Form1, 'PrefDlg');
   Dispose( Form1, Done);
end;

procedure CreateGNopt;
var R:TRect;
    P:PView;
    Form1:PDialog;
begin
   R.Assign( 10,  5, 70, 20);
   Form1:=New(PDialog,Init(R,'Generator options'));
   with Form1^ do
   begin
      R.Assign(  4,  2, 27,  4);
        Insert(New(PCheckBoxes, Init( R,
                  NewSItem('~C~oments',
                  NewSItem('Co~m~piler settings',
                  nil)))));
      R.Assign( 4,  1, 23,  2);
        Insert(New(PLabel, Init( R,'Global options', P)));
      R.Assign( 31,  2, 53,  5);
      P:=New(PRadioButtons, Init( R,
                  NewSItem('~N~one',
                  NewSItem('~T~ype only',
                  NewSItem('Type and ~v~ariable',
                  nil)))));
      Insert(P);
      R.Assign( 30,  1, 53,  2);
        Insert(New(PLabel, Init( R,'Create param variable', P)));
      R.Assign(  4,  6, 27,  8);
        P:=New(PCheckBoxes, Init( R,
                  NewSItem('Pro~g~ect',
                  NewSItem('Help ~r~eference',
                  nil))));
        Insert(P);
      R.Assign( 4,  5, 23,  6);
        Insert(New(PLabel, Init( R,'Auto open', P)));
      R.Assign( 31,  7, 57,  11);
      P:=New(PCheckBoxes, Init( R,
                  NewSItem('~I~nitialization form',
                  NewSItem('~D~atatransefer type',
                  NewSItem('O~p~timize text',
                  NewSItem({$IFNDEF RUS}'N~o~t visual components'{$ELSE}'Невизуальные компоненты'{$ENDIF},
                  nil))))));
      Insert(P);
      R.Assign( 30,  6, 53,  7);
        Insert(New(PLabel, Init( R,'Code generation', P)));
      R.Assign(  2, 12, 13, 14);
        P:=New(PButton, Init( R, strOk, cmOK, bfDefault));
        P^.HelpCtx:=hcOkBtn;
        Insert(P);
      R.Assign( 16, 12, 27, 14);
        P:=New(PButton, Init( R, strCancel, cmCancel, bfNormal));
        P^.HelpCtx:=hcCancleBtn;
        Insert(P);
      R.Assign( 42, 12, 53, 14);
        P:=New(PButton, Init( R, strHelp, cmHelp, bfNormal));
        P^.HelpCtx:=hcHelpBtn;
        Insert(P);
      SelectNext(false);
   end;
   ResourseFile.Put( Form1, 'GNOpt');
   Dispose( Form1, Done);
end;

procedure CreateElementList;
var R:TRect;
    ScrollBar1:PScrollBar;
    Form1:PDialog;
    P:PView;
begin
   R.Assign( 15,  2, 61, 20);
   Form1:=New(PDialog,Init(R,{$IFNDEF RUS}'Element list...'{$ELSE}'DDD'{$ENDIF}));
   with Form1^ do
   begin
      R.Assign( 32,  1, 33, 17);
        ScrollBar1:=New(PScrollBar, Init( R));
        Insert(ScrollBar1);
      R.Assign(  1,  1, 32, 17);
        Insert(New(POkListBox, Init( R,1, ScrollBar1)));
      R.Assign( 34,  2, 44,  4);
        P:=New(PButton, Init( R, strOk, cmOK, bfDefault));
        P^.HelpCtx:=hcOkBtn;
        Insert(P);
      R.Assign( 34,  4, 44,  6);
        P:=New(PButton, Init( R, strCancel, cmCancel, bfNormal));
        P^.HelpCtx:=hcCancleBtn;
        Insert(P);
      R.Assign( 34, 10, 44, 12);
        P:=New(PButton, Init( R, strHelp, cmHelp, bfNormal));
        P^.HelpCtx:=hcHelpBtn;
        Insert(P);
      SelectNext(false);
   end;
   ResourseFile.Put( Form1, sElemList);
   Dispose( Form1, Done);
end;

procedure CreateStartUp;
var R:TRect;
    Form1:PDialog;
    P:PView;
    TabbedNotebook:PTabbedNotebook;
const
  SSystemPage  = {$IFDEF RUS}'С~и~стема'  {$ELSE}'S~y~stem'  {$ENDIF};
  SStartUPPage = {$IFDEF RUS}'~Я~зык'{$ELSE}'Languag~e~'{$ENDIF};
begin
   R.Assign( 18,  3, 57, 21);
   Form1:=New(PDialog,Init(R,{$IFDEF RUS}'Опции загрузки'{$ELSE}'Startup options'{$ENDIF}));
   with Form1^ do
   begin
      Options:=Options or ofCentered;
      R.Assign(  1,  1, 38,  4);
        TabbedNotebook:=Insert(New(PTabbedNotebook, Init(R)));
      R.Assign(  4,  4, 35, 13);
        P:=Insert(New(PCheckBoxes, Init( R,
                  NewSItem({$IFDEF RUS}'Использовать 2 монитора'{$ELSE}'~D~ual monitor support'{$ENDIF},
                  NewSItem({$IFDEF RUS}'Хранить графический экран'{$ELSE}'~G~raphics screen save'{$ENDIF},
                  NewSItem({$IFDEF RUS}'Хранить палитру EGA/VGA'{$ELSE}'EGA/VGA ~p~alette save'{$ENDIF},
                  NewSItem({$IFDEF RUS}'Гашение снега CGA'{$ELSE}'CGA s~n~ow checking'{$ENDIF},
                  NewSItem({$IFDEF RUS}'Набор цветов ~L~CD'{$ELSE}'~L~CD color set'{$ENDIF},
                  NewSItem({$IFDEF RUS}'Грузить .~T~PL файл'{$ELSE}'Load .~T~PL file'{$ENDIF},
                  NewSItem({$IFDEF RUS}'Символы'{$ELSE}'Preserve s~y~mbols'{$ENDIF},
                  NewSItem({$IFDEF RUS}'Вернуться в каталог'{$ELSE}'~R~eturn to last dir'{$ENDIF},
                  NewSItem({$IFDEF RUS}'Поддержка Windows'{$ELSE}'~U~se windows cliboard'{$ENDIF},
                  nil))))))))))));
        TabbedNotebook^.AddToPage(SSystemPage, P);

      R.Assign(  35,  5, 36,  13);
        P:=Insert(New(PScrollBar, Init(R)));
        TabbedNotebook^.AddToPage(SStartUPPage, P);
      R.Assign(  3,  5, 35,  13);
        P:=Insert(New(PListBox, Init( R , 1, PScrollBar(P))));
{        P^.HelpCtx:=hcSel_Lang;}
        TabbedNotebook^.AddToPage(SStartUPPage, P);
      R.Assign( 1,  4, 20,  5);
        P:=Insert(New(PLabel, Init( R,{$IFDEF RUS}'~Я~зык'{$ELSE}'~L~anguage'{$ENDIF}, P)));
        TabbedNotebook^.AddToPage(SStartUPPage, P);

        TabbedNotebook^.SelectPage(0);
      R.Assign(  4, 15, 14, 17);
        P:=Insert(New(PButton, Init( R, strOk, cmOk, bfDefault)));
        P^.HelpCtx:=hcHelpBtn;
      R.Assign( 16, 15, 26, 17);
        P:=Insert(New(PButton, Init( R, strCancel, cmCancel, bfNormal)));
        P^.HelpCtx:=hcCancleBtn;
      R.Assign( 28, 15, 38, 17);
        P:=Insert(New(PButton, Init( R, strHelp, cmHelp, bfNormal)));
        P^.HelpCtx:=hcHelpBtn;
      SelectNext(False);
   end;
   ResourseFile.Put( Form1, 'StartupDlg');
   Dispose( Form1, Done);
end;

procedure CreateConfirmDelete;
var R:TRect;
    Form1:PDialog;
begin
   R.Assign( 15,  6, 63, 15);
   Form1:=New(PDialog,Init(R,{$IFNDEF RUS}'Confirm delete'{$ELSE}'Потвердите удаление'{$ENDIF}));
   with Form1^ do
   begin
      R.Assign(  2,  3, 47,  4);
        Insert(New(PParamText, Init( R,{$IFNDEF RUS}'Delete ''%s''?'{$ELSE}'Удалить ''%s''?'{$ENDIF},1)));
      R.Assign(  4,  6, 15,  8);
        Insert(New(PButton, Init( R, strOk, cmOk, bfDefault)));
      R.Assign( 18,  6, 29,  8);
        Insert(New(PButton, Init( R, strCancel, cmCancel, bfNormal)));
      R.Assign( 32,  6, 43,  8);
        Insert(New(PButton, Init( R, strHelp, cmHelp, bfNormal)));
      SelectNext(false);
   end;
   ResourseFile.Put( Form1, 'ConfirmDelete');
   Dispose( Form1, Done);
end;

procedure CreateMenuBox;
var P:PMenuPopup;
    PP:PMenuBar;
    R:TRect;
begin
    R.Assign(0,0,5,17);
    P:=New(PMenuPopup, Init(R,
      NewMenu(
      NewItem({$IFDEF RUS}'Сделать ~п~ервым'{$ELSE}'~B~ring to front'{$ENDIF}, '', kbNoKey, cmLMBringToFront, hcNoContext,
      NewItem({$IFDEF RUS}'Сделать пос~л~едним'{$ELSE}'~S~end to back'{$ENDIF}, '', kbNoKey, cmLMSendToBack, hcNoContext,
      NewLine(
      NewItem({$IFDEF RUS}'~Р~азмер'{$ELSE}'S~i~ze...'{$ENDIF}, '', kbNoKey, cmLMSize,  hcNoContext,
      NewItem({$IFDEF RUS}'~П~орядок обхода'{$ELSE}'~T~ab order...'{$ENDIF}, '', kbNoKey, cmLMTabOrder,  hcNoContext,
      nil))))))));
   ResourseFile.Put( P, 'TViewPopUp');
   Dispose( P, Done);
    R.Assign(0,0,5,17);
    P:=New(PMenuPopup, Init(R,
      NewMenu(
      NewItem({$IFDEF RUS}'П~р~осмотр отчёта'
              {$ELSE}'~P~review report...'{$ENDIF}, '', kbNoKey, cmPreviewReport, hcPreviewReport,
      NewLine(
      NewItem({$IFDEF RUS}'Печать ~о~тчёта'{$ELSE}'P~r~int report'{$ENDIF}, '', kbNoKey, cmPrintReport,  hcPrintReport,
      NewItem({$IFDEF RUS}'~С~охранить отчёт'{$ELSE}'S~a~ve report'{$ENDIF}, '', kbNoKey, cmSaveReport, hcSaveReport,
      NewLine(
      NewItem({$IFNDEF RUS}'Printer ~o~ptions...'{$ELSE}'Па~р~аметры принтeра'{$ENDIF},'',kbNoKey,cmPrinterSetup,hcSaveReport,
      NewLine(
      NewItem({$IFDEF RUS}'Сделать ~п~ервым'{$ELSE}'~B~ring to front'{$ENDIF}, '', kbNoKey, cmLMBringToFront, hcNoContext,
      NewItem({$IFDEF RUS}'Сделать пос~л~едним'{$ELSE}'~S~end to back'{$ENDIF}, '', kbNoKey, cmLMSendToBack, hcNoContext,
      NewLine(
      NewItem({$IFDEF RUS}'~Р~азмер'{$ELSE}'S~i~ze...'{$ENDIF}, '', kbNoKey, cmLMSize,  hcNoContext,
      NewItem({$IFDEF RUS}'~П~орядок обхода'{$ELSE}'~T~ab order...'{$ENDIF}, '', kbNoKey, cmLMTabOrder,  hcNoContext,
      nil)))))))))))))));
   ResourseFile.Put( P, 'TReportPopUp');
   Dispose( P, Done);
    R.Assign(0,0,5,19);
    P:=New(PMenuPopup, Init(R,
      NewMenu(
      NewItem({$IFDEF RUS}'Редактор полей'
              {$ELSE}'~F~ield editor...'{$ENDIF}, '', kbNoKey, cmDBGridFieldEditor, hcDBGridFieldEditor,
      NewLine(
      NewItem({$IFDEF RUS}'Востановить'
              {$ELSE}'~R~estore default'{$ENDIF}, '', kbNoKey, cmError,  hcNoContext,
      NewItem({$IFDEF RUS}'Удалить все поля'
              {$ELSE}'~C~lear all fields'{$ENDIF}, '', kbNoKey, cmClearAllFields,  hcNoContext,
      NewLine(
      NewItem({$IFDEF RUS}'Сделать ~п~ервым'{$ELSE}'~B~ring to front'{$ENDIF}, '', kbNoKey, cmLMBringToFront, hcNoContext,
      NewItem({$IFDEF RUS}'Сделать пос~л~едним'{$ELSE}'~S~end to back'{$ENDIF}, '', kbNoKey, cmLMSendToBack, hcNoContext,
      NewLine(
      NewItem({$IFDEF RUS}'~Р~азмер'{$ELSE}'S~i~ze...'{$ENDIF}, '', kbNoKey, cmLMSize,  hcNoContext,
      NewItem({$IFDEF RUS}'~П~орядок обхода'{$ELSE}'~T~ab order...'{$ENDIF}, '', kbNoKey, cmLMTabOrder,  hcNoContext,
      nil)))))))))))));
   ResourseFile.Put( P, 'TDBGridPopUp');
    P:=New(PMenuPopup, Init(R,
      NewMenu(
      NewItem({$IFDEF RUS}'Редактор полей'
              {$ELSE}'~F~ield editor...'{$ENDIF}, '', kbNoKey, cmDBSourseFieldEditor, hcDbfSFieldEditor,
      NewLine(
      NewItem({$IFDEF RUS}'Индексы...'
              {$ELSE}'~I~ndex field''s'{$ENDIF}, '', kbNoKey, cmDBSourseIndexsEditor,  hcDbfSIndexsEditor,
      NewItem({$IFDEF RUS}'Новый индекс...'{$ELSE}'~N~ew index'{$ENDIF}, '', kbNoKey, cmDBSourseNewIndexs, hcDbfSNewIndexs,
      NewLine(
      NewSubMenu({$IFDEF RUS}'Записи...'{$ELSE}'~R~ecords...'{$ENDIF}, hcFile, NewMenu(
        NewItem({$IFDEF RUS}'Первая'{$ELSE}'~F~irst record'{$ENDIF}, '', kbNoKey, cmFirstRec, hcNoContext,
        NewItem({$IFDEF RUS}'Превыдущая'{$ELSE}'~P~rior record'{$ENDIF}, '', kbNoKey, cmPrevRec, hcNoContext,
        NewItem({$IFDEF RUS}'Следующая'{$ELSE}'~N~ext record'{$ENDIF}, '', kbNoKey, cmNextRec, hcNoContext,
        NewItem({$IFDEF RUS}'Последняя'{$ELSE}'~L~ast record'{$ENDIF}, '', kbNoKey, cmLastRec, hcNoContext,
        nil))))),
      NewLine(
      NewItem({$IFDEF RUS}'Сделать ~п~ервым'{$ELSE}'~B~ring to front'{$ENDIF}, '', kbNoKey, cmLMBringToFront, hcNoContext,
      NewItem({$IFDEF RUS}'Сделать пос~л~едним'{$ELSE}'~S~end to back'{$ENDIF}, '', kbNoKey, cmLMSendToBack, hcNoContext,
      NewLine(
      NewItem({$IFDEF RUS}'~Р~азмер'{$ELSE}'S~i~ze...'{$ENDIF}, '', kbNoKey, cmLMSize,  hcNoContext,
      NewItem({$IFDEF RUS}'~П~орядок обхода'{$ELSE}'~T~ab order...'{$ENDIF}, '', kbNoKey, cmLMTabOrder,  hcNoContext,
      nil)))))))))))))));
   ResourseFile.Put( P, 'TDBSoursePopUp');
   Dispose( P, Done);
    R.Assign(0,0,7,20);
    P:=New(PMenuPopup, Init(R,
      NewMenu(
      NewItem({$IFDEF RUS}'Выполнить SQL'{$ELSE}'~E~xec SQL'{$ENDIF}, '', kbNoKey, cmError, hcNoContext,
      NewLine(
      NewItem({$IFDEF RUS}'Проверить SQL'{$ELSE}'~C~heck SQL'{$ENDIF}, '', kbNoKey, cmError, hcNoContext,
      NewLine(
      NewItem({$IFDEF RUS}'Редактор полей...'{$ELSE}'~F~ield editor...'{$ENDIF}, '', kbNoKey, cmError, hcNoContext,
      NewItem({$IFDEF RUS}'Редактор параметров...'{$ELSE}'~P~aram editor...'{$ENDIF}, '', kbNoKey, cmParamEditor,  hcNoContext,
      NewLine(
      NewSubMenu({$IFDEF RUS}'Записи...'{$ELSE}'~R~ecords...'{$ENDIF}, hcFile, NewMenu(
        NewItem({$IFDEF RUS}'Первая'{$ELSE}'~F~irst record'{$ENDIF}, '', kbNoKey, cmFirstRec, hcNoContext,
        NewItem({$IFDEF RUS}'Превыдущая'{$ELSE}'~P~rior record'{$ENDIF}, '', kbNoKey, cmPrevRec, hcNoContext,
        NewItem({$IFDEF RUS}'Следующая'{$ELSE}'~N~ext record'{$ENDIF}, '', kbNoKey, cmNextRec, hcNoContext,
        NewItem({$IFDEF RUS}'Последняя'{$ELSE}'~L~ast record'{$ENDIF}, '', kbNoKey, cmLastRec, hcNoContext,
        nil))))),
      NewLine(
      NewItem({$IFDEF RUS}'Сделать ~п~ервым'{$ELSE}'~B~ring to front'{$ENDIF}, '', kbNoKey, cmLMBringToFront, hcNoContext,
      NewItem({$IFDEF RUS}'Сделать пос~л~едним'{$ELSE}'~S~end to back'{$ENDIF}, '', kbNoKey, cmLMSendToBack, hcNoContext,
      NewLine(
      NewItem({$IFDEF RUS}'~Р~азмер'{$ELSE}'S~i~ze...'{$ENDIF}, '', kbNoKey, cmLMSize,  hcNoContext,
      NewItem({$IFDEF RUS}'~П~орядок обхода'{$ELSE}'~T~ab order...'{$ENDIF}, '', kbNoKey, cmLMTabOrder,  hcNoContext,
      nil)))))))))))))))));
   ResourseFile.Put( P, 'TQueryPopUp');
   Dispose( P, Done);
   R.Assign(1,1,27,2);
   PP:=New(PMenuBar, Init(R, NewMenu(
      NewItem({$IFNDEF RUS}'~A~dd'{$ELSE}'До~б~авить'{$ENDIF}, '', kbIns, cmAddToProject, hcNoContext,
      NewItem({$IFNDEF RUS}'~R~emove'{$ELSE}'~У~далить'{$ENDIF}, '', kbDel, cmDelFromProject, hcNoContext,
      NewItem({$IFNDEF RUS}'O~p~tions'{$ELSE}'Оп~ц~ии'{$ENDIF}, '', kbNoKey, cmGNOpt, hcNoContext,
    nil))))));
   ResourseFile.Put( PP, 'PrgMngMenu');
   Dispose( PP, Done);
end;

procedure CreateFieldListDlg;
var R:TRect;
    ScrollBar1:PScrollBar;
    Form2:PDialog;
begin
   R.Assign( 22,  4, 57, 19);
   Form2:=New(PDialog,Init(R,{$IFDEF RUS}'Список полей'{$ELSE}'Field list...'{$ENDIF}));
   with Form2^ do
   begin
      R.Assign( 33,  1, 34, 11);
        ScrollBar1:=New(PScrollBar, Init( R));
        Insert(ScrollBar1);
      R.Assign(  1,  1, 33, 11);
        Insert(New(POkListBox, Init( R,1,ScrollBar1)));
      R.Assign( 12, 12, 23, 14);
        Insert(New(PButton, Init( R, strOk, cmOk, bfDefault)));
      SelectNext(false);
   end;
   ResourseFile.Put( Form2, 'FieldListDlg');
   Dispose( Form2, Done);

   R.Assign(  8,  6, 72, 14);
   Form2:=New(PDialog,Init(R,{$IFDEF RUS}'Производим переиндексацию...'{$ELSE}'Reindex...'{$ENDIF}));
   with Form2^ do
   begin
      R.Assign( 23,  1, 41,  2);
        Insert(New(PStaticText, Init( R,'Подождите немного')));
      R.Assign( 58,  5, 62,  6);
        Insert(New(PStaticText, Init( R,'100%')));
      R.Assign(  2,  5,  7,  6);
        Insert(New(PStaticText, Init( R,'0  %')));
      R.Assign( 24,  4, 35,  5);
        Insert(New(PStaticText, Init( R,'Выполнено')));
      R.Assign( 36,  4, 43,  5);
        Insert(New(PPercentGauge, Init( R,0)));
      R.Assign(  7,  5, 57,  6);
        Insert(New(PBarGauge, Init( R,0)));
      R.Assign( 16,  2, 54,  3);
        Insert(New(PParamText, Init( R,'Обновляем файл %s',1)));
   end;
  ResourseFile.Put(Form2, 'ReindexsForm');
  Dispose(Form2, Done);
end;

procedure CreateRepositoryDlg;
var R:TRect;
    ScrollBar1:PScrollBar;
    P:PView;
    Form1:PDialog;
begin
   R.Assign( 10,  4, 70, 19);
   Form1:=New(PDialog,Init(R,'Repository'));
   with Form1^ do
   begin
      R.Assign( 45,  1, 46, 14);
        ScrollBar1:=New(PScrollBar, Init( R));
        Insert(ScrollBar1);
      R.Assign(  1,  1, 45, 14);
        Insert(New(PResourceList, Init( R, 1, nil, ScrollBar1)));
      R.Assign( 48,  2, 59,  4);
        Insert(New(PButton, Init( R, strOk, cmOK, bfDefault)));
      R.Assign( 48,  4, 59,  6);
        Insert(New(PButton, Init( R, strCancel, cmCancel, bfNormal)));
      R.Assign( 48,  8, 59, 10);
        Insert(New(PButton, Init( R, strDelete, cmDelRepository, bfNormal)));
      R.Assign( 48, 12, 59, 14);
        Insert(New(PButton, Init( R, strHelp, cmHelp, bfNormal)));
      SelectNext(false);
   end;
  ResourseFile.Put(Form1, 'RepositoryDlg');
  Dispose(Form1, Done);

   R.Assign( 14,  6, 68, 14);
   Form1:=New(PDialog,Init(R,{$IFNDEF RUS}'Add to repository'{$ELSE}'Добавить в репозитарий'{$ENDIF}));
   with Form1^ do
   begin
      R.Assign(  2,  3, 52,  4);
        P:=New(PInputLine, Init( R,255));
        Insert(P);
      R.Assign(  1,  2, 20,  3);
        Insert(New(PLabel, Init( R,'~E~nter name', P)));
      R.Assign(  2,  5, 13,  7);
        Insert(New(PButton, Init( R, strOk, cmOK, bfDefault)));
      R.Assign( 15,  5, 26,  7);
        Insert(New(PButton, Init( R, strCancel, cmCancel, bfNormal)));
      R.Assign( 39,  5, 50,  7);
        Insert(New(PButton, Init( R, strHelp, cmHelp, bfNormal)));
      SelectNext(false);
   end;
  ResourseFile.Put(Form1, 'AddRepositoryDlg');
  Dispose(Form1, Done);
end;

procedure CreateDataBaseWindow;
var P:PDataBaseWindow;
    DataScroller:PDataScroller;
    R:TRect;
begin
  R.Assign(0,0,60,15);
  P:=New(PDataBaseWindow, Init(R,'Database'));
  with P^ do
  begin
    Palette:=dpBlueDialog;
    GrowMode := gfGrowAll + gfGrowRel;
    Flags := wfMove + wfGrow + wfClose + wfZoom;
    Options := Options or ofTileable or ofCentered;
    DataSourse:=New(PDBSourse, Init(nil));
      Insert(DataSourse);
    R.Assign(2,1,58,2);
    Insert(New(PMenuBar, Init(R, NewMenu(
               NewSubMenu({$IFNDEF RUS}'~R~ecords'
                          {$ELSE}'Записи'{$ENDIF}, hcDBWindRecords, NewMenu(
                  NewItem({$IFNDEF RUS}'~F~istr'
                          {$ELSE}'Первая'{$ENDIF}, '', kbNoKey, cmDBGridFirst, hcDBWindFirst,
                  NewItem({$IFNDEF RUS}'~P~rev'
                          {$ELSE}'Превыдущая'{$ENDIF},  '', kbNoKey, cmDBGridPrev, hcDBWindPrev,
                  NewItem({$IFNDEF RUS}'~N~ext'
                          {$ELSE}'Следующая'{$ENDIF},  '', kbNoKey, cmDBGridNext, hcDBWindNext,
                  NewItem({$IFNDEF RUS}'~L~ast'
                          {$ELSE}'Последняя'{$ENDIF},  '', kbNoKey, cmDBGridLast, hcDBWindLast,
                  NewLine(
                  NewItem({$IFNDEF RUS}'~E~dit'
                          {$ELSE}'Изменить'{$ENDIF}, 'F2', kbF2, cmDBWindEdit, hcDBWindEdit,
                  NewItem({$IFNDEF RUS}'~A~ppend'
                          {$ELSE}'Добавить'{$ENDIF},'Ins',kbIns, cmDBWindAppend, hcDBWindAppend,
                  NewItem( strDelete, 'Del', kbDel, cmDBWindDelete, hcDBWindDelete,
                  NewItem({$IFNDEF RUS}'~R~ecal'
                          {$ELSE}'Востановить'{$ENDIF}, '', kbNoKey, cmDBWindRecal, hcDBWindRecal,
                  nil)))))))))),
               NewSubMenu({$IFNDEF RUS}'~S~earch'
                          {$ELSE}'Поиск'{$ENDIF}, hcDBWindSearch, NewMenu(
                  NewItem({$IFNDEF RUS}'~F~ind'
                          {$ELSE}'Искать'{$ENDIF}, '', kbNoKey, cmDBGridFirst, hcDBWindFind,
                  NewItem({$IFNDEF RUS}'~S~earch again'
                          {$ELSE}'Искать далее'{$ENDIF}, '', kbNoKey, cmError, hcDBWindSearchAgain,
                  nil))),
               NewSubMenu({$IFNDEF RUS}'~T~ools'
                          {$ELSE}'Инструменты'{$ENDIF}, hcDBWindTools, NewMenu(
                  NewItem({$IFNDEF RUS}'~I~nfo structure'
                          {$ELSE}'О структуре'{$ENDIF}, 'F4', kbF4, cmInfoStructure, hcDBWindInfoStruc,
                  NewItem({$IFNDEF RUS}'~R~estructure'
                          {$ELSE}'Изменить структуру'{$ENDIF}, '', kbNoKey, cmError, hcDBWindReStruct,
                  NewItem({$IFNDEF RUS}'R~e~index'
                          {$ELSE}'Переиндексировать'{$ENDIF}, '', kbNoKey, cmDBWindReindex, hcDBWindReIndex,
                  NewLine(
                  NewItem({$IFNDEF RUS}'~C~opy'
                          {$ELSE}'Копировать'{$ENDIF}, '', kbNoKey, cmError, hcDBWindCopy,
                  NewItem({$IFNDEF RUS}'~P~ack'
                          {$ELSE}'Сжать'{$ENDIF}, '', kbNoKey, cmError, hcDBWindPack,
                  NewLine(
                  NewItem({$IFNDEF RUS}'~N~ew database...'
                          {$ELSE}'Новая таблица'{$ENDIF}, '', kbNoKey, cmNewData, hcNewDataBase,
                  NewItem({$IFNDEF RUS}'~O~pen database...'
                          {$ELSE}'Открыть таблицу'{$ENDIF}, '', kbNoKey, cmOpenData, hcOpenDataBase,
                  NewLine(
                  NewItem({$IFNDEF RUS}'~P~references...'
                          {$ELSE}'Настройки'{$ENDIF}, '', kbNoKey, cmDBPref, hcDBPref,
                  nil)))))))))))),
               nil)))))));
    GetExtent(R);
      R.Grow(0,-1);
      R.A.X:=R.B.X-1;
      DataScroller:=New(PDataScroller, Init(R, DataSourse));
      Insert(DataScroller);
    GetExtent(R);
    R.Grow(-1,-1);
    Inc(R.A.Y);
      DBGrid:=New(PDBGrid, Init(R, nil, DataSourse, DataScroller));
      Insert(DBGrid);
    OnCmdEvent:=HandleEventDBWindow;
    OnKeyEvent:=HandleEventDBWindow;
    OnBroadcastEvent:=HandleEventDBWindow;
  end;
  ResourseFile.Put(P, 'DataBaseWindow');
  Dispose(P, Done);
end;

procedure CreateReportExpDld;
var R:TRect;
    P,P1:PView;
    Form1:PDialog;
    Label1,Label2:PLabel;
    ScrollBar:PScrollBar;
    TB:PTabbedNotebook;
const
   DatabaseReportExpert={$IFNDEF RUS}'Database Report expert - step '{$ELSE}'Мастер отчётов - шаг '{$ENDIF};
   SPrior = {$IFNDEF RUS}'< ~P~rev'{$ELSE}'< ~Н~азад'{$ENDIF};
   SNext  = {$IFNDEF RUS}'~N~ext >'{$ELSE}'Дальше'{$ENDIF};
begin
   R.Assign( 16,  4, 68, 19);
   Form1:=New(PDialog,Init(R, DatabaseReportExpert+'1'));
   with Form1^ do
   begin
      R.Assign(  3,  2, 49,  4);
        Insert(New(PStaticText, Init( R,{$IFNDEF RUS}'Choose the type of report that the'+
                        'Expert will create from the options below.'
                        {$ELSE}'Выберите тип отчёта, который будет создавать Мастер отчётов'{$ENDIF})));
      R.Assign(  7,  7, 45,  9);
        P:=New(PRadioButtons, Init( R,
                  NewSItem({$IFNDEF RUS}'~C~reate a simple report'{$ELSE}'Создать простой отчёт'{$ENDIF},
                  NewSItem({$IFNDEF RUS}'~C~reate a master/detail report'{$ELSE}'Создать главный/подчинённый отчёт'{$ENDIF},
                  nil))));
        P^.Options:=P^.Options or ofFramed;
        Insert(P);
      R.Assign(  8,  6, 24,  7);
        Insert(New(PLabel, Init( R,{$IFNDEF RUS}'~R~eport options'{$ELSE}'Опции отчёта'{$ENDIF}, P)));
      R.Assign(  8, 12, 19, 14);
        Insert(New(PButton, Init( R, strCancel, cmCancel, bfNormal)));
      R.Assign( 21, 12, 32, 14);
        Insert(New(PButton, Init( R, strHelp, cmHelp, bfNormal)));
      R.Assign( 36, 12, 48, 14);
        Insert(New(PButton, Init( R, SNext, cmOK, bfDefault)));
      SelectNext(false);
   end;
   ResourseFile.Put(Form1, 'RExp_1');
   Dispose(Form1, Done);
   P := New(PFileDialog, Init('*.dbf', {$IFNDEF RUS}'Open a table - step 2'{$ELSE}'Открыть таблицу - шаг 2'{$ENDIF},
     {$IFNDEF RUS}'~N~ame'{$ELSE}'~И~мя'{$ENDIF}, fdOpenButton + fdHelpButton + fdNoLoadDir, 106));
   P^.HelpCtx := hcFOFileOpenDBox;
   ResourseFile.Put(P, 'RExp_2');
   Dispose(P, Done);

   R.Assign( 11,  3, 71, 18);
   Form1:=New(PDialog,Init(R,DatabaseReportExpert+'3'));
   with Form1^ do
   begin
      R.Assign( 12,  5, 48,  9);
        P:=New(PCheckBoxes, Init( R,
                  NewSItem({$IFNDEF RUS}'~D~ocument Header'{$ELSE}'Заголовок документа'{$ENDIF},
                  NewSItem({$IFNDEF RUS}'Pa~g~e Header'{$ELSE}'Заголовок страницы'{$ENDIF},
                  NewSItem({$IFNDEF RUS}'Page ~F~ooter'{$ELSE}'Конец страницы'{$ENDIF},
                  NewSItem({$IFNDEF RUS}'Doc~u~ment Footer'{$ELSE}'Конец документа'{$ENDIF},
                  nil))))));
        P^.Options:=P^.Options or ofFramed;
        Insert(P);
      R.Assign( 13,  4, 38,  5);
        Insert(New(PLabel, Init( R,{$IFNDEF RUS}'~A~vailabel report panels'{$ELSE}'Доступные панели отчёта'{$ENDIF}, P)));
      R.Assign(  5,  1, 53,  3);
        Insert(New(PStaticText, Init( R,
                {$IFNDEF RUS}'For add bands select his in this form.'{$ELSE}
                'Для добавления в отчёт соответствующих'+
                ' панелей, необходимо отметить их в данной форме.'{$ENDIF})));
      R.Assign(  2, 12, 13, 14);
        Insert(New(PButton, Init( R, strCancel, cmCancel, bfNormal)));
      R.Assign( 13, 12, 24, 14);
        Insert(New(PButton, Init( R, strHelp, cmHelp, bfNormal)));
      R.Assign( 34, 12, 45, 14);
        Insert(New(PButton, Init( R, SPrior, cmYes, bfNormal)));
      R.Assign( 45, 12, 56, 14);
        Insert(New(PButton, Init( R, SNext, cmOK, bfDefault)));
      SelectNext(false);
   end;
   ResourseFile.Put(Form1, 'RExp_3');
   Dispose(Form1, Done);

   R.Assign( 10,  2, 70, 21);
   Form1:=New(PDualListBox,Init(R,DatabaseReportExpert+'4'));
   with PDualListBox(Form1)^ do
   begin
      R.Assign(  1,  1, 59,  4);
        Insert(New(PStaticText, Init( R,
            {$IFNDEF RUS}'To add fields to the report, '+
            'click each one in the Available Fields list and click the ''>'' '+
            'button. To choose all fields, click the ''>>'' button.'
            {$ELSE}
            'Для добавления полей в отчет укажите необходимое поле в списке '+
            'доступных полей и нажмите кнопку ''>''. Для выбора всех полей'+
            'нажмите кнопку ''>>''.'
            {$ENDIF})));
      R.Assign( 22,  5, 23, 14);
        ScrollBar:=New(PScrollBar, Init( R));
        Insert(ScrollBar);
      R.Assign(  1,  5, 22, 14);
        List1:=New(PListBox, Init( R,1,ScrollBar));
        List1^.Options:=List1^.Options or ofFramed;
        Insert(List1);
      R.Assign(  1,  4, 20,  5);
        Insert(New(PLabel, Init( R,{$IFNDEF RUS}'Available Fields:'
                                   {$ELSE}'Доступные поля'{$ENDIF}, List1)));
      R.Assign( 58,  5, 59, 14);
        ScrollBar:=New(PScrollBar, Init( R));
        Insert(ScrollBar);
      R.Assign( 35,  5, 58, 14);
        List2:=New(PListBox, Init( R,1, ScrollBar));
        List2^.Options:=List2^.Options or ofFramed;
        Insert(List2);
      R.Assign( 35,  4, 58,  5);
        Insert(New(PLabel, Init( R,{$IFNDEF RUS}'Ordered Selected Field'
                                   {$ELSE}'Упорядоченые выбранные поля'{$ENDIF}, List2)));
      R.Assign( 24,  5, 33,  7);
        Insert(New(PButton, Init( R, '>', cmFAdd, bfNormal)));
      R.Assign( 24,  7, 33,  9);
        Insert(New(PButton, Init( R, '>>', cmFAddAll, bfNormal)));
      R.Assign( 24, 11, 33, 13);
        Insert(New(PButton, Init( R, '<', cmFDel, bfNormal)));
      R.Assign( 24, 13, 33, 15);
        Insert(New(PButton, Init( R, '<<', cmFDelAll, bfNormal)));
      R.Assign(  2, 16, 13, 18);
        Insert(New(PButton, Init( R, strCancel, cmCancel, bfNormal)));
      R.Assign( 14, 16, 25, 18);
        Insert(New(PButton, Init( R, strHelp, cmHelp, bfNormal)));
      R.Assign( 35, 16, 46, 18);
        Insert(New(PButton, Init( R, '< ~P~rev', cmYes, bfNormal)));
      R.Assign( 46, 16, 57, 18);
        Insert(New(PButton, Init( R, '~F~inish', cmOK, bfDefault)));
      SelectNext(false);
   end;
   ResourseFile.Put(Form1, 'RExp_4');
   Dispose(Form1, Done);

   P := New(PFileDialog, Init('*.dbf', 'Open a detail table - step 5',
     '~N~ame', fdOpenButton + fdHelpButton + fdNoLoadDir, 106));
   P^.HelpCtx := hcFOFileOpenDBox;
   ResourseFile.Put(P, 'RExp_5');
   Dispose(P, Done);

   R.Assign( 11,  3, 71, 18);
   Form1:=New(PDialog,Init(R,DatabaseReportExpert+'6'));
   with Form1^ do
   begin
      R.Assign( 12,  5, 48,  9);
        P:=New(PCheckBoxes, Init( R,
                  NewSItem('~D~ocument Header',
                  NewSItem('Pa~g~e Header',
                  NewSItem('Page ~F~ooter',
                  NewSItem('Doc~u~ment Footer',
                  nil))))));
        P^.Options:=P^.Options or ofFramed;
        Insert(P);
      R.Assign( 13,  4, 38,  5);
        Insert(New(PLabel, Init( R,'~A~vailabel report panels', P)));
      R.Assign(  5,  1, 53,  3);
        Insert(New(PStaticText, Init( R,'Для добавления в отчёт соответствующих'+
                ' панелей, необходимо отметить их в данной форме.')));
      R.Assign(  2, 12, 13, 14);
        Insert(New(PButton, Init( R, strCancel, cmCancel, bfNormal)));
      R.Assign( 13, 12, 24, 14);
        Insert(New(PButton, Init( R, strHelp, cmHelp, bfNormal)));
      R.Assign( 34, 12, 45, 14);
        Insert(New(PButton, Init( R, '< ~P~rev', cmYes, bfNormal)));
      R.Assign( 45, 12, 56, 14);
        Insert(New(PButton, Init( R, '~N~ext >', cmOK, bfDefault)));
      SelectNext(false);
   end;
   ResourseFile.Put(Form1, 'RExp_6');
   Dispose(Form1, Done);

   R.Assign( 10,  2, 70, 21);
   Form1:=New(PDualListBox,Init(R,DatabaseReportExpert+'7'));
   with PDualListBox(Form1)^ do
   begin
      R.Assign(  1,  1, 59,  4);
        Insert(New(PStaticText, Init( R,'To add fields to the report, '+
            'click each one in the Available Fields list and click the ">" '+
            'button. To choose all fields, click the ">>" button.')));
      R.Assign( 22,  5, 23, 14);
        ScrollBar:=New(PScrollBar, Init( R));
        Insert(ScrollBar);
      R.Assign(  1,  5, 22, 14);
        List1:=New(PListBox, Init( R,1,ScrollBar));
        List1^.Options:=List1^.Options or ofFramed;
        Insert(List1);
      R.Assign(  1,  4, 20,  5);
        Insert(New(PLabel, Init( R,'Available Fields:', List1)));
      R.Assign( 58,  5, 59, 14);
        ScrollBar:=New(PScrollBar, Init( R));
        Insert(ScrollBar);
      R.Assign( 35,  5, 58, 14);
        List2:=New(PListBox, Init( R,1, ScrollBar));
        List2^.Options:=List2^.Options or ofFramed;
        Insert(List2);
      R.Assign( 35,  4, 58,  5);
        Insert(New(PLabel, Init( R,'Ordered Selected Field', List2)));
      R.Assign( 24,  5, 33,  7);
        Insert(New(PButton, Init( R, '>', cmFAdd, bfNormal)));
      R.Assign( 24,  7, 33,  9);
        Insert(New(PButton, Init( R, '>>', cmFAddAll, bfNormal)));
      R.Assign( 24, 11, 33, 13);
        Insert(New(PButton, Init( R, '<', cmFDel, bfNormal)));
      R.Assign( 24, 13, 33, 15);
        Insert(New(PButton, Init( R, '<<', cmFDelAll, bfNormal)));
      R.Assign(  2, 16, 13, 18);
        Insert(New(PButton, Init( R, strCancel, cmCancel, bfNormal)));
      R.Assign( 14, 16, 25, 18);
        Insert(New(PButton, Init( R, strHelp, cmHelp, bfNormal)));
      R.Assign( 35, 16, 46, 18);
        Insert(New(PButton, Init( R, '< ~P~rev', cmYes, bfNormal)));
      R.Assign( 46, 16, 57, 18);
        Insert(New(PButton, Init( R, '~F~inish', cmOK, bfDefault)));
      SelectNext(false);
   end;
   ResourseFile.Put(Form1, 'RExp_7');
   Dispose(Form1, Done);

end;

procedure CreateDBEngineOpt;
var R:TRect;
    Label1,Label2:PLabel;
    TB:PTabbedNotebook;
    P,PP:PView;
    Form1:PDialog;
    CheckBoxes1:PCheckBoxes;
    InputLine1:PInputLine;
    ScrollBar1:PScrollBar;
    ListBox1:PListBox;
begin
   R.Assign( 18,  5, 75, 21);
   Form1:=New(PDialog,Init(R,'Database engine preferences'));
   with Form1^ do
   begin
      HelpCtx:=hcDBEnginePref;
      Options:=Options or ofCentered;
      R.Assign(  1,  1, 55,  4);
        TB:=New(PTabbedNotebook, Init( R));
        Insert(TB);
      R.Assign( 20,  4, 24,  5);
        P:=New(PFilterInput, Init( R,1, [':','\','.','/']));
        Insert(P);
      TB^.AddToPage('~G~lobal',P);
      R.Assign(  3,  4, 20,  5);
        Label1:=New(PLabel, Init( R,'~D~ate separator', P));
        Insert(Label1);
      TB^.AddToPage('~G~lobal',Label1);
      R.Assign( 20,  5, 24,  6);
        P:=New(PFilterInput, Init( R,1, [':','\','.','/']));
        Insert(P);
      TB^.AddToPage('~G~lobal',P);
      R.Assign(  3,  5, 20,  6);
        Label1:=New(PLabel, Init( R,'~T~ime separator', P));
        Insert(Label1);
      TB^.AddToPage('~G~lobal',Label1);
      R.Assign( 28,  5, 50,  6);
        P:=New(PCheckBoxes, Init( R,
                  NewSItem('~F~ull data format',
                  nil)));
        Insert(P);
      TB^.AddToPage('~G~lobal',P);
      R.Assign( 28,  4, 47,  5);
        Label1:=New(PLabel, Init( R,'Centure in data', P));
        Insert(Label1);
      TB^.AddToPage('~G~lobal',Label1);
      R.Assign( 27,  7, 35,  8);
        P:=New(PRangeILine, Init( R,20, 1024));
        Insert(P);
      TB^.AddToPage('~G~lobal',P);
      R.Assign(  3,  7, 26,  8);
        Label2:=New(PLabel, Init( R,'~I~ndex page stack size', P));
        Insert(Label2);
      TB^.AddToPage('~G~lobal',Label2);

      R.Assign( 27,  9, 35,  10);
        P:=New(PInputLine, Init( R, 4));
        Insert(P);
      TB^.AddToPage('~G~lobal',P);
      R.Assign(  3,  9, 26,  10);
        Label2:=New(PLabel, Init( R,'~D~efault index extension', P));
        Insert(Label2);
      TB^.AddToPage('~G~lobal',Label2);

      R.Assign( 15,  5, 27,  6);
        P:=New(PInputLine, Init( R,10));
        Insert(P);
      TB^.AddToPage('O~p~tions',P);
      R.Assign(  2,  5, 13,  6);
        Label1:=New(PLabel, Init( R,'T~r~ue value', P));
        Insert(Label1);
      TB^.AddToPage('O~p~tions',Label1);
      R.Assign( 15,  7, 27, 8);
        P:=New(PInputLine, Init( R,10));
        Insert(P);
      TB^.AddToPage('O~p~tions',P);
      R.Assign(  2,  7, 14, 8);
        Label1:=New(PLabel, Init( R,'~F~alse value', P));
        Insert(Label1);
      TB^.AddToPage('O~p~tions',Label1);

      R.Assign( 25,  4, 26, 12);
        ScrollBar1:=New(PScrollBar, Init( R));
        Insert(ScrollBar1);
      TB^.AddToPage('~A~liases',ListBox1);
      R.Assign(  1,  4, 25, 12);
        ListBox1:=New(PListBox, Init( R ,1, ScrollBar1));
        Insert(ListBox1);
      TB^.AddToPage('~A~liases',ListBox1);
      R.Assign( 28,  5, 55,  6);
        InputLine1:=New(PInputLine, Init( R ,79));
        Insert(InputLine1);
      TB^.AddToPage('~A~liases',InputLine1);
      R.Assign( 27,  4, 46,  5);
        Label1:=New(PLabel, Init( R ,'~P~ath for alias', InputLine1));
        Insert(Label1);
      TB^.AddToPage('~A~liases',Label1);
      R.Assign( 28,  7, 55, 12);
        CheckBoxes1:=New(PCheckBoxes, Init( R ,
                  NewSItem('Item1',
                  NewSItem('Item2',
                  NewSItem('Item3',
                  NewSItem('Item4',
                  NewSItem('Item5',
                  NewSItem('Item6',
                  nil))))))));
        Insert(CheckBoxes1);
      TB^.AddToPage('~A~liases',CheckBoxes1);
      R.Assign( 27,  6, 46,  7);
        Label2:=New(PLabel, Init( R ,'~P~references', CheckBoxes1));
        Insert(Label2);
      TB^.AddToPage('~A~liases',Label2);

      R.Assign( 13, 13, 24, 15);
        PP:=New(PButton, Init( R, strOk, cmOK, bfDefault));
        Insert(PP);
      R.Assign( 27, 13, 38, 15);
        Insert(New(PButton, Init( R, strCancel, cmCancel, bfNormal)));
      R.Assign( 42, 13, 53, 15);
        Insert(New(PButton, Init( R, strHelp, cmHelp, bfNormal)));
   end;
   ResourseFile.Put(Form1, 'DEPref');
   Dispose(Form1, Done);
end;

procedure CreateDialogWizardDlg;
var R:TRect;
    P:PView;
    Form1:PDialog;
begin
   R.Assign( 11,  6, 67, 17);
   Form1:=New(PDialog,Init(R,'Dialog wizard'));
   with Form1^ do
   begin
      R.Assign( 11,  3, 46,  5);
        P:=New(PRadioButtons, Init( R,
                  NewSItem('~S~ingle page dialog',
                  NewSItem('~M~ultipage, using page control',
                  nil))));
        Insert(P);
      R.Assign(  6,  2, 28,  3);
        Insert(New(PLabel, Init( R,'Select dialog style:', P)));
      R.Assign(  6,  8, 18, 10);
        Insert(New(PButton, Init( R, strHelp, cmHelp, bfNormal)));
      R.Assign( 18,  8, 30, 10);
        Insert(New(PButton, Init( R, strCancel, cmCancel, bfNormal)));
      R.Assign( 39,  8, 51, 10);
        Insert(New(PButton, Init( R, '~N~ext >', cmOK, bfDefault)));
      SelectNext(false);
   end;
   ResourseFile.Put(Form1, 'DialogWizzard_1');
   Dispose(Form1, Done);

   R.Assign( 14,  4, 65, 19);
   Form1:=New(PDialog,Init(R,'Dialog wizard'));
   with Form1^ do
   begin
      R.Assign( 11,  5, 42,  8);
        P:=New(PRadioButtons, Init( R,
                  NewSItem('~N~o buttons',
                  NewSItem('~V~ertical along right adge',
                  NewSItem('~H~orizontal along button',
                  nil)))));
        Insert(P);
      R.Assign(  4,  3, 30,  4);
        Insert(New(PLabel, Init( R,'Select button placement:', P)));
      R.Assign(  4, 12, 16, 14);
        Insert(New(PButton, Init( R, '< ~B~ack', cmYes, bfNormal)));
      R.Assign( 20, 12, 32, 14);
        Insert(New(PButton, Init( R, '~F~inish', cmOK, bfDefault)));
      R.Assign( 37, 12, 49, 14);
        Insert(New(PButton, Init( R, strCancel, cmCancel, bfNormal)));
      SelectNext(false);
   end;
   ResourseFile.Put(Form1, 'DialogWizzard_2');
   ResourseFile.Put(Form1, 'DialogWizzard_4');
   Dispose(Form1, Done);

   R.Assign( 14,  4, 65, 19);
   Form1:=New(PDialog,Init(R,'Dialog wizard'));
   with Form1^ do
   begin
      R.Assign( 48,  2, 49, 11);
        P:=New(PScrollBar, Init( R));
        Insert(P);
      R.Assign(  2,  2, 48, 11);
        P:=New(PMemo, Init( R,nil, PScrollBar(P), nil, 255));
        Insert(P);
      R.Assign(  1,  1, 41,  2);
        Insert(New(PLabel, Init( R,'Enter pages names for mult-page dialog', P)));
      R.Assign(  4, 12, 16, 14);
        Insert(New(PButton, Init( R, '< ~B~ack', cmYes, bfNormal)));
      R.Assign( 21, 12, 33, 14);
        Insert(New(PButton, Init( R, '~N~ext >', cmOK, bfDefault)));
      R.Assign( 37, 12, 49, 14);
        Insert(New(PButton, Init( R, strCancel, cmCancel, bfNormal)));
      SelectNext(false);
   end;
   ResourseFile.Put(Form1, 'DialogWizzard_3');
   Dispose(Form1, Done);

   R.Assign( 10,  5, 70, 20);
   Form1:=New(PDialog,Init(R,'Form '));
   ResourseFile.Put(Form1, 'DialogWizzardForm_0');
   Dispose(Form1, Done);
   R.Assign( 10,  5, 70, 20);
   Form1:=New(PDialog,Init(R,'Form '));
   with Form1^ do
   begin
      R.Assign( 16, 12, 26, 14);
        P:=New(PButton, Init( R, strOk, cmOK, bfDefault));
        P^.ComponentName:=NewStr('OkButton');
        Insert(P);
      R.Assign( 28, 12, 38, 14);
        P:=New(PButton, Init( R, strCancel, cmCancel, bfNormal));
        P^.ComponentName:=NewStr('CancelButton');
        Insert(P);
      R.Assign( 43, 12, 54, 14);
        P:=New(PButton, Init( R, strHelp, cmHelp, bfNormal));
        P^.ComponentName:=NewStr('HelpButton');
        Insert(P);
      SelectNext(false);
   end;
   ResourseFile.Put(Form1, 'DialogWizzardForm_2');
   Dispose(Form1, Done);
   R.Assign( 10,  5, 70, 20);
   Form1:=New(PDialog,Init(R,'Form '));
   with Form1^ do
   begin
      R.Assign( 45,  2, 56,  4);
        P:=New(PButton, Init( R, strOk, cmOK, bfDefault));
        P^.ComponentName:=NewStr('OkButton');
        Insert(P);
      R.Assign( 45,  4, 56,  6);
        P:=New(PButton, Init( R, strCancel, cmCancel, bfNormal));
        P^.ComponentName:=NewStr('CancelButton');
        Insert(P);
      R.Assign( 46, 11, 57, 13);
        P:=New(PButton, Init( R, strHelp, cmHelp, bfNormal));
        P^.ComponentName:=NewStr('HelpButton');
        Insert(P);
      SelectNext(false);
   end;
   ResourseFile.Put(Form1, 'DialogWizzardForm_1');
   Dispose(Form1, Done);

   R.Assign(  1,  1, 59,  4);
     P:=New(PTabbedNotebook, Init( R));
     P^.ComponentName:=NewStr('TabbedNotebook1');
     ResourseFile.Put(P, 'PTabbedNotebook2');
     ResourseFile.Put(P, 'PTabbedNotebook0');
     Dispose(P, Done);
   R.Assign(  1,  1, 45,  4);
     P:=New(PTabbedNotebook, Init( R));
     P^.ComponentName:=NewStr('TabbedNotebook1');
     ResourseFile.Put(P, 'PTabbedNotebook1');
     Dispose(P, Done);
end;

procedure CreateIndPageStackWind;
var R:TRect;
    ScrollBar1:PScrollBar;
    ListViewer1:PListViewer;
    Form1:PDialog;
begin
   R.Assign( 30, 12, 80, 23);
   Form1:=New(PDialog,Init(R,{$IFNDEF RUS}'Virtual memory'{$ELSE}'Виртуальная память'{$ENDIF}));
   with Form1^ do
   begin
      Palette:=dpBlueDialog;
      GrowMode := gfGrowAll + gfGrowRel;
      Flags := wfMove + wfGrow + wfClose + wfZoom;
      Options := Options or ofTileable;
      R.Assign( 49,  1, 50, 10);
        ScrollBar1:=New(PScrollBar, Init( R));
        Insert(ScrollBar1);
      R.Assign(  1,  1, 49, 10);
        ListViewer1:=New(PListViewer, Init( R,1,nil,ScrollBar1));
        ListViewer1^.GrowMode:=gfGrowHiX + gfGrowHiY;
        ListViewer1^.OnGetText:=IndDldGetText;
        ListViewer1^.OnCreate:=CreateIndexPageDlg;
        ListViewer1^.OnDestroy:=DestroyIndexPageDlg;
        Insert(ListViewer1);
   end;
   ResourseFile.Put(Form1, 'IndexPageStack');
   Dispose(Form1, Done);
end;

procedure CreateInfOstruDialog;
var R:TRect;
    P:PView;
    SB:PScrollBar;
    Form1:PDialog;
begin
   R.Assign( 10,  2, 68, 18);
   Form1:=New(PDialog,Init(R,'Data file info structure'));
   with Form1^ do
   begin
      HelpCtx:=hcInfoStruDbf;
      R.Assign(  37,  2, 38, 12);
        SB:=New(PScrollBar, Init(R));
        Insert(SB);
      R.Assign(  1,  2, 37, 12);
        P:=New(PListBox, Init( R ,1, SB));
        Insert(P);
      R.Assign(  1,  1, 20,  2);
        Insert(New(PLabel, Init( R ,'Field''s', P)));
      R.Assign( 41,  3, 52,  4);
        Insert(New(PParamText, Init( R ,'%d',1)));
      R.Assign( 38,  2, 52,  3);
        Insert(New(PStaticText, Init( R ,'Count records')));
      R.Assign( 38,  4, 54,  5);
        Insert(New(PStaticText, Init( R ,'Last update')));
      R.Assign( 41,  5, 57,  6);
        Insert(New(PParamText, Init( R ,'%s',1)));
      R.Assign( 16, 13, 26, 15);
        Insert(New(PButton, Init( R , strOk, cmOK, bfDefault)));
      R.Assign( 28, 13, 38, 15);
        Insert(New(PButton, Init( R , strCancel, cmCancel, bfNormal)));
      R.Assign( 44, 13, 55, 15);
        Insert(New(PButton, Init( R , strHelp, cmHelp, bfNormal)));
      SelectNext(false);
   end;
   ResourseFile.Put(Form1, 'InfoStruDialog');
   Dispose(Form1, Done);

   R.Assign( 11,  5, 67, 16);
   Form1:=New(PDialog,Init(R,{$IFNDEF RUS}'Create new index'{$ELSE}'Создать новый индекс'{$ENDIF}));
   with Form1^ do
   begin
      HelpCtx:=hcCreateNewInd;
      R.Assign(  4,  2, 54,  3);
        P:=New(PInputLine, Init( R,79));
        P^.HelpCtx:=hcIndFileNameLine;
        Insert(P);
      R.Assign(  1,  1, 20,  2);
        Insert(New(PLabel, Init( R,{$IFNDEF RUS}'~F~ile name'{$ELSE}'~И~мя файла'{$ENDIF}, P)));
      R.Assign(  4,  4, 31,  5);
        P:=New(PInputLine, Init( R, 255));
        P^.HelpCtx:=hcIndexExpr;
        Insert(P);
      R.Assign(  1,  3, 20,  4);
        Insert(New(PLabel, Init( R,{$IFNDEF RUS}'~I~ndex field'{$ELSE}'Индексное ~п~оле'{$ENDIF}, P)));
      R.Assign( 34,  4, 54,  6);
        P:=New(PRadioButtons, Init( R,
                     NewSItem({$IFNDEF RUS}'~N~ot duplicate'{$ELSE}'~Н~е дублир.'{$ENDIF},
                     NewSItem({$IFNDEF RUS}'~D~uplicate'{$ELSE}'~Д~убль.'{$ENDIF},
                     nil))));
        P^.HelpCtx:=hcIndUnique;
        Insert(P);
      R.Assign(  3,  8, 13, 10);
        Insert(New(PButton, Init( R, strOk, cmOk, bfDefault)));
      R.Assign( 15,  8, 25, 10);
        Insert(New(PButton, Init( R, strCancel, cmCancel, bfNormal)));
      R.Assign( 39,  8, 49, 10);
        Insert(New(PButton, Init( R, strHelp, cmHelp, bfNormal)));
      SelectNext(false);
   end;
   ResourseFile.Put(Form1, 'NewIndexDlg');
   Dispose(Form1, Done);
end;

procedure CreateProgectOpt;
var R:TRect;
    InputLine:PInputLine;
    Form3:PDialog;
begin
   R.Assign( 12,  2, 72, 17);
   Form3:=New(PDialog,Init(R,'Progect options'));
   with Form3^ do
   begin
      R.Assign(  3,  2, 45,  3);
        InputLine:=New(PInputLine, Init( R ,78));
        Insert(InputLine);
      R.Assign(  2,  1, 21,  2);
        Insert(New(PLabel, Init( R ,'~P~roject help file', InputLine)));
      R.Assign(  3,  4, 55,  5);
        InputLine:=New(PInputLine, Init( R ,255));
        Insert(InputLine);
      R.Assign(  2,  3, 21,  4);
        Insert(New(PLabel, Init( R ,'~I~nclude help file', InputLine)));
      R.Assign( 55,  4, 58,  5);
        Insert(New(PHistory, Init( R ,InputLine, 114)));
      R.Assign(  3,  6, 55,  7);
        InputLine:=New(PInputLine, Init( R ,255));
        Insert(InputLine);
      R.Assign(  2,  5, 25,  6);
        Insert(New(PLabel, Init( R ,'~O~utput help file dir', InputLine)));
      R.Assign( 55,  6, 58,  7);
        Insert(New(PHistory, Init( R ,InputLine, 115)));
      R.Assign( 47,  2, 58,  4);
        Insert(New(PButton, Init( R , '~B~rowse', cmYes, bfNormal)));
      R.Assign(  4, 12, 15, 14);
        Insert(New(PButton, Init( R , strOk, cmOK, bfDefault)));
      R.Assign( 18, 12, 29, 14);
        Insert(New(PButton, Init( R , strCancel, cmCancel, bfNormal)));
      R.Assign( 43, 12, 54, 14);
        Insert(New(PButton, Init( R , strHelp, cmHelp, bfNormal)));
      SelectNext(false);
   end;
   ResourseFile.Put(Form3, 'ProgectOpt');
   Dispose(Form3, Done);
end;

procedure CreateCompDlg;
var R:TRect;
    Form1:PDialog;
    P:PView;
begin
   R.Assign( 16,  6, 64, 17);
   Form1:=New(PDialog,Init(R,'Compiling help'));
   with Form1^ do
   begin
      R.Assign(  4,  2, 47,  3);
        Insert(New(PParamText, Init( R ,'Main file: %s',1)));
      R.Assign(  4,  3, 47,  4);
        Insert(New(PParamText, Init( R ,'%s',1)));
      R.Assign(  4,  5, 23,  6);
        Insert(New(PParamText, Init( R ,'Free memory: %dK',1)));
      R.Assign( 26,  5, 45,  6);
        Insert(New(PParamText, Init( R ,'Line number: %d',1)));
      R.Assign( 26,  6, 45,  7);
        Insert(New(PParamText, Init( R ,'Total lines: %d',1)));
      R.Assign(  1,  9, 47, 10);
        Insert(New(PColorText, Init( R ,'            Press Ctrl+Break to cancel      ', $1F)));
      Flags:=0;
   end;
   ResourseFile.Put(Form1, 'CompHelpStatDlg');
   Dispose(Form1, Done);

   R.Assign( 19,  5, 65, 17);
   Form1:=New(PDialog,Init(R,'Заполните данные'));
   with Form1^ do
   begin
      R.Assign(  3,  2, 18,  3);
        P:=Insert(New(PInputLine, Init( R ,10)));
        PInputLine(P)^.SetValidator(New(PPXPictureValidator, Init('?[@[@[@[@[@[@[@[@[@]]]]]]]]]',false)));
      R.Assign(  1,  1,  6,  2);
        Insert(New(PLabel, Init( R ,'~N~ame', P)));
      R.Assign( 21,  2, 31,  3);
        P:=Insert(New(PRangeILine, Init( R ,1, 255)));
      R.Assign( 19,  1, 27,  2);
        Insert(New(PLabel, Init( R ,'~L~ength', P)));
      R.Assign( 34,  2, 41,  3);
        P:=Insert(New(PRangeILine, Init( R ,0, 10)));
      R.Assign( 32,  1, 38,  2);
        Insert(New(PLabel, Init( R ,'~D~ec', P)));
      R.Assign(  3,  4, 41,  7);
        P:=Insert(New(PRadioButtons, Init( R ,
                  NewSItem('~C~haracter',
                  NewSItem('~I~nteger',
                  NewSItem('~D~ate',
                  NewSItem('~L~ogical',
                  NewSItem('~F~loat',
                  NewSItem('~M~emo',
                  nil)))))))));
      P^.Options:=P^.Options or ofFramed;
      PRadioButtons(P)^.EnableMask:=$2F;
      R.Assign(  1,  3,  7,  4);
        Insert(New(PLabel, Init( R ,'~T~ype', P)));
      R.Assign(  3,  9, 14, 11);
        Insert(New(PButton, Init( R , strOk, cmOK, bfDefault)));
      R.Assign( 15,  9, 26, 11);
        Insert(New(PButton, Init( R , strCancel, cmCancel, bfNormal)));
      R.Assign( 28,  9, 39, 11);
        Insert(New(PButton, Init( R , strHelp, cmHelp, bfNormal)));
      SelectNext(false);
   end;
   ResourseFile.Put(Form1, 'NewDBFieldDialog');
   Dispose(Form1, Done);
end;

procedure CreateReservedWords;
var P:PStringCollection;
begin
  P:=New(PStringCollection, Init(20,10));
  P^.Insert(NewStr('AND'));
  P^.Insert(NewStr('EXPORTS'));
  P^.Insert(NewStr('MOD'));
  P^.Insert(NewStr('SRH'));
  P^.Insert(NewStr('ARRAY'));
  P^.Insert(NewStr('FILE'));
  P^.Insert(NewStr('NIL'));
  P^.Insert(NewStr('STRING'));
  P^.Insert(NewStr('ASM'));
  P^.Insert(NewStr('FOR'));
  P^.Insert(NewStr('NOT'));
  P^.Insert(NewStr('THEN'));
  P^.Insert(NewStr('BEGIN'));
  P^.Insert(NewStr('FUNCTION'));
  P^.Insert(NewStr('OBJECT'));
  P^.Insert(NewStr('TO'));
  P^.Insert(NewStr('CASE'));
  P^.Insert(NewStr('GOTO'));
  P^.Insert(NewStr('OF'));
  P^.Insert(NewStr('TYPE'));
  P^.Insert(NewStr('CONST'));
  P^.Insert(NewStr('IF'));
  P^.Insert(NewStr('OR'));
  P^.Insert(NewStr('UNIT'));
  P^.Insert(NewStr('CONSTRUCTOR'));
  P^.Insert(NewStr('IMPLEMENTATION'));
  P^.Insert(NewStr('PACKED'));
  P^.Insert(NewStr('UNTIL'));
  P^.Insert(NewStr('DESTRUCTOR'));
  P^.Insert(NewStr('IN'));
  P^.Insert(NewStr('PROCEDURE'));
  P^.Insert(NewStr('USES'));
  P^.Insert(NewStr('DIV'));
  P^.Insert(NewStr('INHERITED'));
  P^.Insert(NewStr('PROGRAM'));
  P^.Insert(NewStr('VAR'));
  P^.Insert(NewStr('DO'));
  P^.Insert(NewStr('INLINE'));
  P^.Insert(NewStr('RECORD'));
  P^.Insert(NewStr('WHILE'));
  P^.Insert(NewStr('DOWNTO'));
  P^.Insert(NewStr('INTERFACE'));
  P^.Insert(NewStr('REPEAT'));
  P^.Insert(NewStr('WITH'));
  P^.Insert(NewStr('ELSE'));
  P^.Insert(NewStr('LABEL'));
  P^.Insert(NewStr('SET'));
  P^.Insert(NewStr('XOR'));
  P^.Insert(NewStr('END'));
  P^.Insert(NewStr('LIBRARY'));
  P^.Insert(NewStr('SHL'));
  P^.Insert(NewStr('CLASS'));
  P^.Insert(NewStr('PROTECTED'));
  P^.Insert(NewStr('PROPERTY'));
  P^.Insert(NewStr('READ'));
  P^.Insert(NewStr('WRITE'));
  P^.Insert(NewStr('OVERRIDE'));
  P^.Insert(NewStr('PCHAR'));
  P^.Insert(NewStr('TRY'));
  P^.Insert(NewStr('FINALLY'));
  P^.Insert(NewStr('EXCEPT'));
  P^.Insert(NewStr('MESSAGE'));
  P^.Insert(NewStr('PRIVATE'));
  P^.Insert(NewStr('VIRTUAL'));

  ResourseFile.Put(P, 'ReservedWords');
  Dispose(P, Done);

  P:=New(PStringCollection, Init(20,10));
  P^.Insert(NewStr('SELECT'));
  P^.Insert(NewStr('ALL'));
  P^.Insert(NewStr('DISTINCT'));
  P^.Insert(NewStr('FROM'));
  P^.Insert(NewStr('WHERE'));
  P^.Insert(NewStr('ORDER'));
  P^.Insert(NewStr('BY'));
  ResourseFile.Put(P, 'ReservedWordsSQL');
  Dispose(P, Done);
end;

procedure CreateParamDlg;
var R:TRect;
    P:PInputLine;
    ScrollBar:PScrollBar;
    ListBox:PListViewer;
    V:PView;
    Form8:PDialog;
begin
   R.Assign( 10,  5, 70, 15);
   Form8:=New(PDialog,Init(R,'Params property'));
   with Form8^ do
   begin
      R.Assign( 10,  2, 57,  3);
        P:=New(PInputLine, Init( R ,80));
        PInputLine(P)^.SetValidator(New(PFilterValidator, Init(WordChars)));
        Insert(P);
      R.Assign(  2,  2,  9,  3);
        Insert(New(PLabel, Init( R ,'~N~ame', P)));
      R.Assign( 10,  4, 57,  5);
        P:=New(PInputLine, Init( R ,80));
        Insert(P);
      R.Assign(  2,  4, 10,  5);
        Insert(New(PLabel, Init( R ,'~V~alue', P)));
      R.Assign(  4,  7, 15,  9);
        Insert(New(PButton, Init( R , strOk, cmOK, bfDefault)));
      R.Assign( 16,  7, 27,  9);
        Insert(New(PButton, Init( R , strCancel, cmCancel, bfNormal)));
      R.Assign( 44,  7, 55,  9);
        Insert(New(PButton, Init( R , strHelp, cmHelp, bfNormal)));
      SelectNext(false);
   end;
  ResourseFile.Put(Form8, 'ParamsProperty');
  Form8^.Free;

   R.Assign( 10,  5, 70, 20);
   Form8:=New(PDialog,Init(R,'Aliases...'));
   with Form8^ do
   begin
      R.Assign( 46,  1, 47, 11);
        ScrollBar:=Insert(New(PScrollBar, Init( R)));
      R.Assign(  1,  1, 46, 11);
        ListBox:=Insert(New(PListViewer, Init( R ,1, nil, ScrollBar)));
        ListBox^.OnGetText:=AliasViewGetTextEvent;
        ListBox^.OnSetData:=AliasViewSetData;
        ListBox^.OnBroadcastEvent:=AliasViewHandleEvent;
        ListBox^.OnMouseEvent:=AliasViewHandleEvent;
        ListBox^.OnKeyEvent:=AliasViewHandleEvent;
      R.Assign( 47,  2, 58,  4);
        Insert(New(PButton, Init( R , '~A~dd', cmAliasEditorAdd, bfNormal+bfBroadcast)));
      R.Move( 0, 2);
        Insert(New(PButton, Init( R , '~E~dit', cmAliasEditorEdit, bfNormal+bfBroadcast)));
      R.Move( 0, 2);
        Insert(New(PButton, Init( R , strDelete, cmAliasEditorDel, bfNormal+bfBroadcast)));
      R.Move( 0, 2);
        Insert(New(PButton, Init( R , '~S~ave', cmAliasEditorSave, bfNormal+bfBroadcast)));
      R.Move( 0, 2);
        Insert(New(PButton, Init( R , '~L~oad', cmAliasEditorLoad, bfNormal+bfBroadcast)));
      R.Assign( 16, 12, 26, 14);
        Insert(New(PButton, Init( R , strOk, cmOK, bfDefault)));
      R.Assign( 28, 12, 38, 14);
        Insert(New(PButton, Init( R , strCancel, cmCancel, bfNormal)));
      R.Assign( 43, 12, 54, 14);
        Insert(New(PButton, Init( R , strHelp, cmHelp, bfNormal)));
      SelectNext(false);
   end;
  ResourseFile.Put(Form8, 'DBAliasEditor');
  Form8^.Free;

   R.Assign( 12,  6, 71, 18);
   Form8:=New(PDialog,Init(R,'Alias property...'));
   with Form8^ do
   begin
      R.Assign( 14,  2, 55,  3);
        V:=Insert(New(PInputLine, Init( R ,79)));
      R.Assign(  4,  2, 13,  3);
        Insert(New(PLabel, Init( R ,'~W~ork dir', V)));
      R.Assign( 14,  4, 55,  5);
        V:=Insert(New(PInputLine, Init( R , 79)));
      R.Assign(  2,  4, 13,  5);
        Insert(New(PLabel, Init( R ,'~A~lias name', V)));
      R.Assign( 14,  6, 29,  7);
        V:=Insert(New(PRangeILine, Init( R , 0, 2147483647)));
      R.Assign(  3,  6, 13,  7);
        Insert(New(PLabel, Init( R ,'Wait ~t~ime', V)));
      R.Assign( 36,  6, 55,  7);
        Insert(New(PCheckBoxes, Init( R ,
                  NewSItem('~I~s net',
                  nil))));
      R.Assign(  9,  9, 20, 11);
        Insert(New(PButton, Init( R , strOk, cmOK, bfDefault)));
      R.Assign( 21,  9, 32, 11);
        Insert(New(PButton, Init( R , strCancel, cmCancel, bfNormal)));
      R.Assign( 45,  9, 56, 11);
        Insert(New(PButton, Init( R , strHelp, cmHelp, bfNormal)));
      SelectNext(false);
   end;
  ResourseFile.Put(Form8, 'DBAliasProperty');
  Form8^.Free;

  R.Assign( 17,  2, 61, 18);
  Form8:=New(PDialog,Init(R,{$IFNDEF RUS}'Tab order...'{$ELSE}'Порядок обхода'{$ENDIF}));
  with Form8^ do
  begin
     R.Assign( 29,  1, 30, 15);
       ScrollBar:=Insert(New(PScrollBar, Init( R)));
     R.Assign(  1,  1, 29, 15);
       ListBox:=Insert(New(PListBox, Init( R ,1, ScrollBar)));
       ListBox^.OnKeyEvent:=HandleEventTabOrderListBox;
       ListBox^.OnCmdEvent:=HandleEventTabOrderListBox;
{       ListBox^.OnBroadcastEvent:=HandleEventTabOrderListBox;}
       ListBox^.OnGetText:=GetViewNameReordr;
     R.Assign( 31,  2, 42,  4);
       Insert(New(PButton, Init( R , {$IFNDEF RUS}'~U~p'{$ELSE}'В~в~ерх'{$ENDIF}, cmUpControl, bfNormal)));
     R.Assign( 31,  5, 42,  7);
       Insert(New(PButton, Init( R , {$IFNDEF RUS}'~D~own'{$ELSE}'В~н~из'{$ENDIF}, cmDownControl, bfNormal)));
     R.Assign( 31,  9, 42, 11);
       Insert(New(PButton, Init( R , strOk, cmOK, bfDefault)));
     R.Assign( 31, 11, 42, 13);
       Insert(New(PButton, Init( R , strCancel, cmCancel, bfNormal)));
     R.Assign( 31, 13, 42, 15);
       Insert(New(PButton, Init( R , strHelp, cmHelp, bfNormal)));
     SelectNext(false);
  end;
  ResourseFile.Put(Form8, 'TabOrderDlg');
  Form8^.Free;

  R.Assign( 10,  5, 62, 16);
  Form8:=New(PDialog,Init(R,{$IFNDEF RUS}'Size dialog'{$ELSE}'Размеры...'{$ENDIF}));
  with Form8^ do
  begin
     R.Assign( 11,  1, 42,  2);
       Insert(New(PParamText, Init( R, {$IFNDEF RUS}'Parametrs for %s'
                                       {$ELSE}'Размеры для %s'{$ENDIF},1)));
     R.Assign( 11,  3, 18,  4);
       V:=Insert(New(PRangeILine, Init( R ,0, 128)));
     R.Assign(  1,  3, 10,  4);
       Insert(New(PLabel, Init( R ,'~O~rigin.X', V)));
     R.Assign( 11,  5, 18,  6);
       V:=Insert(New(PRangeILine, Init( R ,0, 20)));
     R.Assign(  1,  5, 10,  6);
       Insert(New(PLabel, Init( R ,'O~r~igin.Y', V)));
     R.Assign( 34,  3, 44,  4);
       V:=Insert(New(PRangeILine, Init( R ,0, 123)));
     R.Assign( 25,  3, 33,  4);
       Insert(New(PLabel, Init( R ,'Size.~X~', V)));
     R.Assign( 34,  5, 44,  6);
       V:=Insert(New(PRangeILine, Init( R ,-2147483647, 2147483647)));
     R.Assign( 25,  5, 33,  6);
       Insert(New(PLabel, Init( R ,'Size.~Y~', V)));
     R.Assign(  7,  8, 18, 10);
       Insert(New(PButton, Init( R , strOk, cmOK, bfDefault)));
     R.Assign( 18,  8, 29, 10);
       Insert(New(PButton, Init( R , strCancel, cmCancel, bfNormal)));
     R.Assign( 37,  8, 48, 10);
       Insert(New(PButton, Init( R , strHelp, cmHelp, bfNormal)));
     SelectNext(false);
  end;
  ResourseFile.Put(Form8, 'SizeDialog');
  Form8^.Free;
end;

procedure CreateNewIndexDialog;
var P:PNewIndexDialog;
    PP:PDialog;
    R:TRect;
    V:PView;
begin
  R.Assign( 13,  5, 71, 17);
  P:=New(PNewIndexDialog, Init(R,'Create/modify index...'));
  with P^ do
  begin
      R.Assign( 10,  2, 53,  3);
        V:=Insert(New(PInputLine, Init( R ,79)));
      R.Assign(  3,  1, 22,  2);
        Insert(New(PLabel, Init( R ,'~I~ndex file name', V)));
      R.Assign( 53,  2, 56,  3);
        Insert(New(PHistory, Init( R, PInputLine(V), 130)));
      R.Assign(  7,  4, 29,  6);
        V:=Insert(New(PRadioButtons, Init( R ,
                  NewSItem('~S~imple index',
                  NewSItem('~C~alculeted index',
                  nil)))));
        V^.ComponentName:=NewStr('IndexMode');
      R.Assign(  3,  3, 22,  4);
        Insert(New(PLabel, Init( R ,'Index mode', V)));
      R.Assign( 31,  4, 55,  6);
        V:=Insert(New(PRadioButtons, Init( R ,
                  NewSItem('~N~ot duplicate',
                  NewSItem('~D~uplicate',
                  nil)))));
      R.Assign( 30,  3, 49,  4);
        Insert(New(PLabel, Init( R ,'Duplicates', V)));

      R.Assign( 23,  6, 51,  7);
        SimpleIndex:=Insert(New(PLockUpInputLine, Init( R ,
                  NewSItem('-----------------',
                  nil))));
        SimpleIndex^.ComponentName:=NewStr('SimpleIndex');
      R.Assign(  3,  6, 22,  7);
        Label1:=Insert(New(PLabel, Init( R ,'S~e~lect index field', SimpleIndex)));

      R.Assign( 10,  7, 53,  8);
        CalcIndex:=Insert(New(PInputLine, Init( R ,255)));
        CalcIndex^.SetState(sfVisible, false);
      R.Assign(  3,  6, 27,  7);
        Label2:=Insert(New(PLabel, Init( R ,'~E~nter index expresion', CalcIndex)));
        Label2^.SetState(sfVisible, false);


      R.Assign(  8,  9, 19, 11);
        Insert(New(PButton, Init( R , strOk, cmOK, bfDefault)));
      R.Assign( 20,  9, 31, 11);
        Insert(New(PButton, Init( R , strCancel, cmCancel, bfNormal)));
      R.Assign( 44,  9, 55, 11);
        Insert(New(PButton, Init( R , strHelp, cmHelp, bfNormal)));
      SelectNext(false);
  end;
  ResourseFile.Put(P, 'CreateIndexDlg');
  P^.Free;
  R.Assign( 11,  1, 68, 18);
  PP:=New(PDialog,Init(R,'Select master...'));
  with PP^ do
  begin
      R.Assign( 26,  2, 27, 13);
        V:=Insert(New(PScrollBar, Init( R)));
      R.Assign(  1,  2, 26, 13);
        V:=Insert(New(PElementGroupList, Init( R ,PScrollBar(V), nil)));
        V^.ComponentName:=NewStr('DatsSetsList');
      R.Assign(  1,  1, 20,  2);
        Insert(New(PLabel, Init( R ,'~D~atasets', V)));
      R.Assign( 55,  2, 56, 13);
        V:=Insert(New(PScrollBar, Init( R)));
      R.Assign( 29,  2, 55, 13);
        V:=Insert(New(PElementItemList, Init( R , PScrollBar(V), nil)));
      R.Assign( 30,  1, 49,  2);
        Insert(New(PLabel, Init( R ,'~F~ield', V)));
      R.Assign(  2, 14, 13, 16);
        Insert(New(PButton, Init( R , strOk, cmOK, bfDefault)));
      R.Assign( 13, 14, 24, 16);
        Insert(New(PButton, Init( R , strCancel, cmCancel, bfNormal)));
      R.Assign( 43, 14, 54, 16);
        Insert(New(PButton, Init( R , strHelp, cmHelp, bfNormal)));
      SelectNext(false);
   end;
  ResourseFile.Put(PP, 'SelectMaster');
  PP^.Free;
end;

procedure CreatePrnOptDlg;
var P:PView;
    Form1:PDialog;
    R:TRect;
begin
   R.Assign( 12,  3, 70, 18);
   Form1:=New(PDialog,Init(R,'Printer options...'));
   with Form1^ do
   begin
      R.Assign(  4,  7, 26, 11);
        P:=Insert(New(PStaticText, Init( R ,' ')));
        P^.Options:=P^.Options or ofFramed;
      R.Assign(  4,  2, 25,  3);
        Insert(New(PCheckBoxes, Init( R ,
                  NewSItem('~U~se printer code',
                  nil))));
      R.Assign(  4,  4, 19,  6);
        Insert(New(PCheckBoxes, Init( R ,
                  NewSItem('~C~ondensed',
                  NewSItem('~N~LQ',
                  nil)))));
      R.Assign(  5,  6, 14,  7);
        Insert(New(PStaticText, Init( R ,#3'Margins')));
      R.Assign( 13,  7, 25,  8);
        P:=Insert(New(PRangeILine, Init( R ,0, 255)));
      R.Assign(  4,  7, 10,  8);
        Insert(New(PLabel, Init( R ,'~L~eft', P)));
      R.Assign( 13,  8, 25,  9);
        P:=Insert(New(PRangeILine, Init( R ,0, 255)));
      R.Assign(  4,  8, 12,  9);
        Insert(New(PLabel, Init( R ,'~R~ight', P)));
      R.Assign( 13,  9, 25, 10);
        P:=Insert(New(PRangeILine, Init( R ,0, 255)));
      R.Assign(  4,  9, 11, 10);
        Insert(New(PLabel, Init( R ,'~T~op', P)));
      R.Assign( 13, 10, 25, 11);
        P:=Insert(New(PRangeILine, Init( R ,0, 255)));
      R.Assign(  4, 10, 12, 11);
        Insert(New(PLabel, Init( R ,'~B~ottom', P)));
      R.Assign( 43,  2, 56,  3);
        P:=Insert(New(PRangeILine, Init( R ,0, 256)));
      R.Assign( 30,  2, 41,  3);
        Insert(New(PLabel, Init( R ,'N/~2~56 inch', P)));

      R.Assign( 47,  4, 56,  5);
        P:=Insert(New(PRangeILine, Init( R ,0, 5)));
      R.Assign( 30,  4, 47,  5);
        Insert(New(PLabel, Init( R ,'Column count', P)));
      R.Assign( 47,  5, 56,  6);
        P:=Insert(New(PRangeILine, Init( R ,0, 10)));
      R.Assign( 30,  5, 47,  6);
        Insert(New(PLabel, Init( R ,'Column margin', P)));

      R.Assign( 12, 12, 23, 14);
        Insert(New(PButton, Init( R , strOk, cmOK, bfDefault)));
      R.Assign( 25, 12, 36, 14);
        Insert(New(PButton, Init( R , strCancel, cmCancel, bfNormal)));
      R.Assign( 44, 12, 55, 14);
        Insert(New(PButton, Init( R , strHelp, cmHelp, bfNormal)));
      SelectNext(false);
   end;
   ResourseFile.Put(Form1, 'PrnOptDlg');
   Form1^.Free;
end;

procedure CreateAddHelpFilesDlg;
var R:TRect;
    ScrollBar1:PScrollBar;
    ListBox1:PListBox;
    Form6:PDialog;
begin
   R.Assign( 15,  4, 64, 19);
   Form6:=New(PDialog,Init(R,{$IFNDEF RUS}'Install Help Files'
                             {$ELSE}'Справочные файлы'{$ENDIF}));
   with Form6^ do
   begin
      R.Assign( 34,  3, 35, 12);
        ScrollBar1:=Insert(New(PScrollBar, Init( R)));
      R.Assign(  2,  3, 34, 12);
        ListBox1:=Insert(New(PListBox, Init( R ,1, ScrollBar1)));
        ListBox1^.OnCmdEvent:=HandleEventAddHelpFileListBox;
      R.Assign(  1,  2, 20,  3);
        Insert(New(PLabel, Init( R,{$IFNDEF RUS}'~H~elp files'
                                   {$ELSE}'Справочные файлы'{$ENDIF}, ListBox1)));
      R.Assign( 37,  3, 47,  5);
        Insert(New(PButton, Init( R, strOk, cmOK, bfNormal)));
      R.Assign( 37,  5, 47,  7);
        Insert(New(PButton, Init( R, {$IFNDEF RUS}'~N~ew'
                                     {$ELSE}'~Н~овый'{$ENDIF}, cmNew, bfDefault)));
      R.Assign( 37,  7, 47,  9);
        Insert(New(PButton, Init( R, strDelete, cmHelpFileDelete, bfNormal)));
      R.Assign( 37,  9, 47, 11);
        Insert(New(PButton, Init( R, strCancel, cmCancel, bfNormal)));
      R.Assign( 37, 11, 47, 13);
        Insert(New(PButton, Init( R, strHelp, cmHelp, bfNormal)));
      SelectNext(false);
   end;
   ResourseFile.Put(Form6, 'AddHelpFileDlg');
   Form6^.Free;
end;

procedure CreateFilePrintDlg;
var R:TRect;
    Form:PDialog;
begin
   R.Assign( 20,  7, 61, 17);
   Form:=New(PDialog,Init(R,{$IFDEF RUS}'Настройки печати'{$ELSE}'Print setup'{$ENDIF}));
   with Form^ do
   begin
      R.Assign(  7,  2, 34,  4);
        Insert(New(PRadioButtons, Init( R ,
                  NewSItem({$IFDEF RUS}'~В~есь текст'{$ELSE}'~A~ll text'{$ENDIF},
                  NewSItem({$IFDEF RUS}'Выделенный ~ф~рагмент'{$ELSE}'~S~elected text'{$ENDIF},
                  nil)))));
      R.Assign(  7,  5, 34,  6);
        Insert(New(PCheckBoxes, Init( R ,
                  NewSItem({$IFDEF RUS}'Подсветка ~с~интаксиса'{$ELSE}'Syntax ~h~ighlight'{$ENDIF},
                  nil))));
      R.Assign(  3,  7, 14,  9);
        Insert(New(PButton, Init( R , strOk, cmOK, bfDefault)));
      R.Assign( 15,  7, 26,  9);
        Insert(New(PButton, Init( R , strCancel, cmCancel, bfNormal)));
      R.Assign( 28,  7, 39,  9);
        Insert(New(PButton, Init( R , strHelp, cmHelp, bfNormal)));
      SelectNext(false);
   end;
   ResourseFile.Put(Form, 'PrintFileDlg');
   Form^.Free;
end;

procedure CreateStdEditDlg;
var D:PDialog;
begin
  D:=StdEditorGotoLineDlg;
  ResourseFile.Put( D, 'GoLine');
  Dispose( D, Done);
  D:=StrEditorFindDlg;
  ResourseFile.Put( D, 'FindDialog');
  Dispose( D, Done);
  D:=StdEditorReplaseDlg;
  ResourseFile.Put( D, 'ReplaceDialog');
  Dispose( D, Done);
  D:=StdEditorOptionsDlg;
  ResourseFile.Put( D, 'EditorOptions');
  Dispose( D, Done);
end;

procedure CreateDirDialog;
var R:TRect;
    P:PInputLine;
    Form:PDialog;
begin
   R.Assign(  9,  3, 71, 20);
   Form:=New(PDialog,Init(R,'Directories'));
   with Form^ do
   begin
      R.Assign( 23,  2, 56,  3);
        P:=Insert(New(PInputLine, Init( R,255)));
      R.Assign( 56,  2, 59,  3);
        Insert(New(PHistory, Init( R, P, 123)));
      R.Assign(  2,  2, 23,  3);
        Insert(New(PLabel, Init( R ,'~E~XE directory', P)));
      R.Assign( 23,  4, 56,  5);
        P:=Insert(New(PInputLine, Init( R ,255)));
      R.Assign( 56,  4, 59,  5);
        Insert(New(PHistory, Init( R,P,124)));
      R.Assign(  2,  4, 23,  5);
        Insert(New(PLabel, Init( R ,'~T~PU directory', P)));
      R.Assign( 23,  6, 56,  7);
        P:=Insert(New(PInputLine, Init( R ,255)));
      R.Assign( 56,  6, 59,  7);
        Insert(New(PHistory, Init( R,P,125)));
      R.Assign(  2,  6, 23,  7);
        Insert(New(PLabel, Init( R ,'~I~nclude directories', P)));
      R.Assign( 23,  8, 56,  9);
        P:=Insert(New(PInputLine, Init( R ,255)));
      R.Assign( 56,  8, 59,  9);
        Insert(New(PHistory, Init( R, P,126)));
      R.Assign(  2,  8, 21,  9);
        Insert(New(PLabel, Init( R ,'~U~nit directories', P)));
      R.Assign( 23, 10, 56, 11);
        P:=Insert(New(PInputLine, Init( R ,255)));
      R.Assign( 56, 10, 59, 11);
        Insert(New(PHistory, Init( R, P,127)));
      R.Assign(  2, 10, 22, 11);
        Insert(New(PLabel, Init( R ,'~O~bject directories', P)));
      R.Assign( 23, 12, 56, 13);
        P:=Insert(New(PInputLine, Init( R ,255)));
      R.Assign( 56, 12, 59, 13);
        Insert(New(PHistory, Init( R, P,128)));
      R.Assign(  2, 12, 21, 13);
        Insert(New(PLabel, Init( R ,'~R~esource directories', P)));
      R.Assign( 26, 14, 36, 16);
        Insert(New(PButton, Init( R , strOk, cmOK, bfDefault)));
      R.Assign( 38, 14, 48, 16);
        Insert(New(PButton, Init( R , strCancel, cmCancel, bfNormal)));
      R.Assign( 50, 14, 60, 16);
        Insert(New(PButton, Init( R , strHelp, cmHelp, bfNormal)));
      SelectNext(false);
   end;
   ResourseFile.Put(Form, 'DirForm');
   Form^.Free;
end;

procedure CreatePrintPrepringForm;
var R:TRect;
    D:PDialog;
begin
  R.Assign(  9,  7, 69, 14);
  D:=New(PDialog,Init(R,{$IFDEF RUS}'Подготовка отчёта...'{$ELSE}'Preparing report...'{$ENDIF}));
    D^.Flags:=0;
    R.Assign(  5,  3, 56,  4);
    D^.Insert(New(PParamText, Init( R ,{$IFDEF RUS}'Подготовка страницы %d (проход %d).'
    {$ELSE}'Prepring page %d (pass %d).'{$ENDIF},2)));
  ResourseFile.Put(D, 'PrepReport1');
  D^.Free;
  R.Assign(  9,  7, 69, 14);
  D:=New(PDialog,Init(R,{$IFDEF RUS}'Подготовка отчёта...'{$ELSE}'Preparing report...'{$ENDIF}));
    D^.Flags:=0;
    R.Assign(  5,  3, 56,  4);
    D^.Insert(New(PParamText, Init( R ,{$IFDEF RUS}'Подготовка страницы %d.'
    {$ELSE}'Prepring page %d.'{$ENDIF},1)));
  ResourseFile.Put(D, 'PrepReport2');
  D^.Free;
end;

procedure CreateAppWizardDlg;
var R:TRect;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    ScrollBar1:PScrollBar;
    ListBox1:PListBox;
    Form4:PDialog;
begin
   R.Assign( 13,  3, 68, 19);
   Form4:=New(PDialog,Init(R,'Application wizard...'));
   with Form4^ do
   begin
      R.Assign( 54,  1, 55, 12);
        ScrollBar1:=New(PScrollBar, Init( R));
        Insert(ScrollBar1);
      R.Assign(  1,  1, 54, 12);
        ListBox1:=New(POkListBox, Init( R ,1,ScrollBar1));
        Insert(ListBox1);
      R.Assign( 18, 13, 29, 15);
        Button1:=New(PButton, Init( R , strOk, cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 29, 13, 40, 15);
        Button2:=New(PButton, Init( R , strCancel, cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 42, 13, 53, 15);
        Button3:=New(PButton, Init( R , strHelp, cmHelp, bfNormal));
        Insert(Button3);
      SelectNext(false);
   end;
  ResourseFile.Put(Form4, 'AppWizardDlg');
  Form4^.Free;
end;

const
  Bild:longint = 0;
var
  BS:TDosStream;
begin
{$IFDEF VER70}
{$IFNDEF DPMI}
  OvrInit(ExePath+Ext_Dos.ExeName+'.ovr');
  OvrSetBuf(58 * 1024);
  if OvrResult <> ovrOk then
  begin
    PrintStr('No overlays found in .EXE file.'#13#10);
    Halt(1);
  end;
{$ENDIF}
{$ENDIF}
  writeln('Resurse maker for RESRS2.EXE.');
  dbDesignTime:=true;
  DesignTime:=true;
{$IFNDEF RUS}
  ResourseStream := New(PProtectedStream, Init(ExePath+'Resrs2.TVR', stCreate));//, 4096));
{$ELSE}
  ResourseStream := New(PProtectedStream, Init(ExePath+'Res2ru.LNG');//, stCreate, 4096));
{$ENDIF}
  ResourseFile.Init(ResourseStream);

  RegistersSdt;
  RegisterGL_Proc;
  RegisterType(RStrListMaker);
  BS.Init('bild.dat',stOpen);
  BS.Read(Bild, SizeOf(Longint));
{$IFNDEF PM}
{$IFNDEF RUS}
  inc(Bild);
  BS.Seek(0);
  BS.write(Bild, SizeOf(Longint));
{$ENDIF}
{$ENDIF}
  BS.Done;
  BildStr:='                                              Сборка '+IntToStr(Bild)+' от '+ DateToStr(Date);
  PrintStr(BildStr+#13#10);
  CreateMenu;
  CreateStatusLine;
  CreateFileOpenDialog;
  CreateStrings(ResourseFile);
  CreateProjectOpenDialog;
  CreateGetForm;
  CreateElement(ResourseFile);
  CreateTools;
  CreateResurseListDialog;
  CreateInfoDialog;
  CreateSetClusterOpt;
  CreateGNopt;
  CreateCompOpt;
  CreatePrefDlg;
  CreateElementList;
  CreateStartUp;
  CreatePropertyLists(ResourseFile);
  CreateConfirmDelete;
  CreateMenuBox;
  CreateFieldListDlg;
  CreateRepositoryDlg;
  CreateDataBaseWindow;
  CreateReportExpDld;
  CreateDBEngineOpt;
  CreateDialogWizardDlg;
  CreateIndPageStackWind;
  CreateInfOstruDialog;
  CreateProgectOpt;
  CreateCompDlg;
  CreateReservedWords;
  CreateParamDlg;
  CreateNewIndexDialog;
  CreatePrnOptDlg;
  CreateAddHelpFilesDlg;
  CreateFilePrintDlg;
  CreateStdEditDlg;
  CreateDirDialog;
  CreatePrintPrepringForm;
  CreateAppWizardDlg;


  writeln('Status = ',ResourseStream^.Status);
  ResourseFile.Done;
  writeln('Ok.');
end.
