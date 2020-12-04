unit JoinBase;
interface
uses Dialogs;
type
   PJoinBaseDlg = ^TJoinBaseDlg;
   TJoinBaseDlg = object(TDialog)
     ListBox3:PListBox;
     ListBox2:PListBox;
     ListBox1:PListBox;
     constructor Init;
   end;

implementation
uses Objects, Views;

   { TJoinBaseDlg }
constructor TJoinBaseDlg.Init;
var R:TRect;
    ScrollBar:PScrollBar;
begin
   R.Assign( 11,  1, 71, 19);
   inherited Init(R,'Field Link Designer');
   R.Assign( 20,  2, 21,  9);
     ScrollBar:=New(PScrollBar, Init( R));
     Insert(ScrollBar);
   R.Assign(  1,  2, 20,  9);
     ListBox1:=New(PListBox, Init( R ,1,ScrollBar));
     Insert(ListBox1);
   R.Assign(  1,  1, 20,  2);
     Insert(New(PLabel, Init( R ,'D~e~tail Fields', ListBox1)));
   R.Assign( 58,  2, 59,  9);
     ScrollBar:=New(PScrollBar, Init( R));
     Insert(ScrollBar);
   R.Assign( 38,  2, 58,  9);
     ListBox2:=New(PListBox, Init( R ,1,ScrollBar));
     Insert(ListBox2);
   R.Assign( 38,  1, 57,  2);
     Insert(New(PLabel, Init( R ,'~M~aster Fields', ListBox2)));
   R.Assign( 44, 10, 45, 17);
     ScrollBar:=New(PScrollBar, Init( R));
     Insert(ScrollBar);
   R.Assign(  1, 10, 44, 17);
     ListBox3:=New(PListBox, Init( R ,1,ScrollBar));
     Insert(ListBox3);
   R.Assign(  1,  9, 20, 10);
     Insert(New(PLabel, Init( R ,'~J~oined Fields', ListBox3)));
   R.Assign( 24,  3, 35,  5);
     Insert(New(PButton, Init( R , '~A~dd', cmYes, bfNormal)));
   R.Assign( 24,  8, 35, 10);
     Insert(New(PButton, Init( R , '~D~elete', cmNo, bfNormal)));
   R.Assign( 47, 10, 58, 12);
     Insert(New(PButton, Init( R , '~O~k', cmOK, bfDefault)));
   R.Assign( 47, 12, 58, 14);
     Insert(New(PButton, Init( R , 'Cancel', cmCancel, bfNormal)));
   R.Assign( 47, 15, 58, 17);
     Insert(New(PButton, Init( R , '~H~elp', cmHelp, bfNormal)));
   SelectNext(false);
end;

end.
