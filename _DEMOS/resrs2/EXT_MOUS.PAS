unit Ext_mous;{Extended mouse dlg.}
interface
{$F-,O+,D-}

uses Objects, Views, Dialogs, MouseDlg, Drivers, CmdConst, Clases, Register;

const
  RightMoussBtn:word = 1;
const
  EventArray:array [0..5] of TEvent =
  ((What:evNothing),
   (What:evCommand;
    Command:cmHelp),
   (What:evCommand;
    Command:cmTestForm),
   (What:evCommand;
    Command:cmLocalMenu),
   (What:evCommand;
    Command:cmNewElement),
   (What:evCommand;
    Command:cmViewProject));
type
  PExtMouseDlg = ^TExtMouseDlg;
  TExtMouseDlg = object(TMouseDialog)
    RadioButtons1:PRadioButtons;
    constructor Init;
    constructor Load(var S:TStream);
    procedure Store(var S:TStream);
    function Valid(Command: Word): Boolean; virtual;
  end;

const
  RMouseDialog: TStreamRec = (
     ObjType: 2019;
     VmtLink: Ofs(TypeOf(TExtMouseDlg)^);
     Load:    @TExtMouseDlg.Load;
     Store:   @TExtMouseDlg.Store
  );

procedure RegistersExtMouseDlg;

implementation

constructor TExtMouseDlg.Init;
var R:TRect;
begin
   inherited Init;
   Options := Options or ofCentered;
   R.Assign( 0,  0, 58, 12);
   SetBounds(R);
   GetExtent(R);
   Frame^.SetBounds(R);
   R.Assign(  32,  3, 55,  9);
   RadioButtons1:=New(PRadioButtons, Init( R,
                      NewSItem('~Н~ичего',
                      NewSItem('~К~онтекстная помощь',
                      NewSItem('~Т~ест',
                      NewSItem('~Л~окальное меню',
                      NewSItem('~Н~овый элемент',
                      NewSItem('~М~енеджер проекта',
                      nil))))))));
   Insert(RadioButtons1);
   R.Assign(33, 2, 55, 3);
     Insert(New(PLabel,Init(R,'Правая кнопка мыши',RadioButtons1)));
end;

constructor TExtMouseDlg.Load(var S:TStream);
begin
  inherited Load(S);
  GetSubViewPtr(S,RadioButtons1);
  RadioButtons1^.SetData(RightMoussBtn);
end;

procedure TExtMouseDlg.Store(var S:TStream);
begin
  inherited Store(S);
  PutSubViewPtr(S,RadioButtons1);
end;

function TExtMouseDlg.Valid(Command: Word): Boolean;
begin
  if Command = cmOk then
     RadioButtons1^.GetData(RightMoussBtn);
end;

procedure RegistersExtMouseDlg;
begin
  RegisterType(RMouseDialog);
end;

end.
