{$O+}
{$I Define.inc}
unit GlType;
interface
uses Objects, Dos, Ext_App, Editors, Views, DataCtrl, Dialogs, DBGrids,
     AddCntrl, MultiSel, Outline, Grids, StdDlg, DBCtrls, GauGes, GadGets,
     AboutPn, ASCIITab, Cursors, Reports, El_Lists, Querys, ColorSel,
     Ext_Type, Register;

  { Тип - запись для опций метки }
type
  PObjectToEditMsgRec = ^TObjectToEditMsgRec;
  TObjectToEditMsgRec = record
    Code:Longint;
    Obj:PObject;
    View:PView;
  end;

type
  TResourceListRec = record
    List:PResourceFile;
    Selection:word;
  end;

  { Тип - запись для опций формы }
type
  TRecForm=record
    Name:string[60];
    Caption:String[60];
    ProcName:string[60];
    UnitName:string[8];
    HelpCtx:String[5];
    Pallete:word;
  end;

type
  { Startup otpions record}
  TStartUpRecord = record
    StartUpOpt:word;
    Language:TListBoxRec;
  end;
const
  Step1 = [] + DSSet;
  Step4 = [ctLabel, ctHistory];
  Step2 = [ctDataScroller, ctIndicator, ctScrollBar];
  Step3 = AllType - (Step1 + Step2 + Step4 + SystemTypeSet);

const
  GHeaderStep = [ctStaticText, ctParamText, ctScrollBar, ctDBText,
                 ctDBSourse, ctDataSourse, ctReportShape];
  GMainStep   = [ctInputLine, ctListBox, ctRadioButtons, ctCheckBoxes,
                 ctMultiCheckBoxes, ctMemo, ctMultiSelBox, ctOutline,
                 ctElementGroupList, ctElementItemList, ctInputLineUC,
                 ctInputLineLC, ctInputLinePS, ctFilterInput,
                 ctOkListBox, ctDrawGrid, ctStringGrid, ctDateEdit,
                 ctLockUpInputLine, ctRangeILine, ctSortedListBox,
                 ctDBGrid, ctDBLookupCombo, ctDBEdit, ctRadioButtons,
                 ctCheckBoxes, ctMultiCheckBoxes, ctDBMemo, ctDBDateEdit,
                 ctDBLookupEdit,ctReportBand, ctButton,
                 ctColorSelector, ctMonoSelector, ctGroupBand];
  GFooterStep = [ctLabel, ctHistory];
type
   TPrinterOptionsRecord = record
      UsePrinterCodes:word;
      CheckBoxes1:word;
      LeftMargin:Longint;
      RightMargin:Longint;
      TopMargin:Longint;
      BottomMargin:Longint;
      Set216Inch:Longint;
      ColumnCount:Longint;
      ColumnMargin:Longint;
   end;

implementation
end.
