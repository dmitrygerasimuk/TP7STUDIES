
 Program TextWinDemo;

   Uses Crt, TextWin;

   Var I, X, Y : integer;
       Answer  : byte;
       S       : string;
       Info    : MenuInfo;

   Procedure WaitKey;
     Begin
       Repeat Until InKey<>Empty
     End;

   Procedure WriteTitle (Title:string);
     Begin
       TextColor (Yellow);
       TextBackground (Blue);
       ClrScr;
       GoToXY (40-Length (Title) div 2,2);
       Write (Title)
     End;

     Begin
       TextColor (Yellow);
       TextBackground (Blue);
       OpenWindow (0,1,1,80,25,Attribute (White,Green),DontSave);
       WriteTitle ('You can open up to 10 windows (or more if you change MaxWindow constant).');
       Randomize;
       For I:=1 to MaxWindow do
         Begin
           Str (I,S);
           TextColor (I+1);
           TextBackground (7-(I+1) mod 8);
           OpenWindow (I,8+Random (30),5+Random (5),12+Random (30),7+Random (8),Attribute (I,7-I mod 8),Save);
           Writeln ('Window #',S);
           Delay (100)
         End;
       Writeln;
       Write ('Any key...');
       WaitKey;
       For I:=1 to MaxWindow do
         Begin
           CloseWindow;
           Delay (100)
         End;
       WriteTitle ('Press any key to hide cursor...');
       WaitKey;
       HideCursor;
       WriteTitle ('Press any key to show cursor...');
       WaitKey;
       ShowCursor;
       WriteTitle ('Menu demo');
       With Info do
         Begin
           Border:=Attribute (Black,LightGray);
           Text:=Attribute (Black,LightGray);
           Bar:=Attribute (White,Blue);
           Hot:=Attribute (Red,LightGray)
         End;
       OpenMenu (30,10,LeftUp,'An item,Also an item,One more',Answer,Info);
       If Answer<>0 then
         Begin
           OpenMenu (32,11+Answer,LeftUp,'New first option,New second option,New third option',Answer,Info);
           CloseTemp
         End;
       CloseTemp;
       TextColor (Yellow);
       TextBackground (Blue);
       Writeln;
       Writeln;
         Case Answer of
           0 : Write ('You choosed nothing...');
           1 : Write ('You choosed first option...');
           2 : Write ('You choosed second option...');
           3 : Write ('You choosed third option...')
         End;
       WaitKey;
       WriteTitle ('Box demo...');
       OpenBox (30,11,20,3,LeftUp,Attribute (Black,LightGray));
       Write (' This is a box...');
       WaitKey;
       CloseTemp;
       WriteTitle ('Any key to exit...');
       WaitKey;
       Window (1,1,TextModeInfo.Wid,25);
       TextColor (LightGray);
       TextBackground (Black);
       ClrScr
     End.