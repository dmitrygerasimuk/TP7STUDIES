unit UNIT4;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register;

type
   Form4Record=record
      ListBox1:TListBoxRec;
   end;

function NewForm4:PDialog;

implementation
function NewForm4:PDialog;
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
        ListBox1:=New(PListBox, Init( R ,1, ScrollBar1));
        Insert(ListBox1);
      R.Assign( 18, 13, 29, 15);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 29, 13, 40, 15);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 42, 13, 53, 15);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      SelectNext(false);
   end;
   NewForm4:=Form4;
end;
end.

