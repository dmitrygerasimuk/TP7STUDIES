Program Snake;

Uses CRT, DOS, ProfText;                             {-‘‹‡“…›… „“‹.-}

Const                                                {----------------------}
  TO1 = '               ‚ΰ¥¬ο Άλθ«®.             ';  {                      }
  TO2 = '     ‘£®«®¤γε¨ ‚λ γªγα¨«¨ α ¬¨ α¥΅ο.    ';  {‘‚……  ‘’€’€}
  TO3 = '          ‘β¥­ª  ªΰ¥―η¥ £®«®Άλ!         ';  {       ‡€—…‰.      }
  TO4 = '              £ΰ  ―ΰ¥ΰΆ ­ .            ';  {                      }
  TO5 = '      ‚λ ―®― «¨ Ά «γηθγξ ¤Ά ¤ζ βªγ.     ';  {----------------------}
  Rekl : Array [1..10] of String[6] =
  ('Mars  ','Topic ','Lipton','Duru  ','UPSA  ','Tampax','PEPSI ','Signal','Tide  ','TWIX  ');

Var                                                  {----------------------}
  EXIT:Boolean;                                      {                      }
  LM:Word;                                           {                      }
  C1, C2:Char;                                       {                      }
  X0, Y0, DX, DY, EX, EY, HX, HY, Q, W,              {  ‡€„€—€  ………›•  }
    SC, HI, LO, A, P{, T}:Integer;                        {                      }
  X, Y:Array [1..400] of integer;                    {                     }
  F:Text;                                            {                      }
  SCORES:Array [1..21] of string[10];                {       €‘‘‚‚.      }
  SCORE:String[10];                                  {                      }
  Len:Byte;                                          {                      }
                                                     {                      }
Label                                                {                      }
  L2, L3;                                            {----------------------}

Function Stri (XN:Longint):String;             {----------------------------}
Var                                            {             ’€            }
  S:String;                                    {           ”“–          }
BEGIN                                          {…€‡“…’ —‘‹  ‚ ‘’“.}
  Str (XN, S);                                 {                            }
  Stri := S                                    {                            }
END;                                           {----------------------------}

Function Valu (SG:String):Longint;             {----------------------------}
Var                                            {                            }
  ERR:Integer;                                 {             ’€            }
  V:Longint;                                   {           ”“–          }
BEGIN                                          {…€‡“…’ ‘’“  ‚ —‘‹.}
  Val (SG, V, ERR);                            {                            }
  Valu := V                                    {                            }
END;                                           {----------------------------}

Procedure ScreenMode;                                {----------------------}
BEGIN                                                { –…„“€  ‡…… }
  LM:=LastMode;                                      {  …†€  ’…‘’‚ƒ  }
  TextMode (Co40)                                    {        ‚›‚„€.       }
END;                                                 {----------------------}

Procedure Color (B, T:Word);                         {----------------------}
BEGIN                                                { –…„“€  ‡…… }
  TextColor (T);                                     {    –‚…’€ ‚ …†…    }
  TextBackGround (B)                                 {  ’…‘’‚ƒ ‚›‚„€.  }
END;                                                 {----------------------}

Procedure Picture;
Var
  N: Byte;
Begin
  For N := 1 to 5 do
    Begin
      Delay (175);
      TextColor (Red);
      TextBackGround (Black);
      WriteLargeString (1 + (N - 1) * 8, 25, 'Ϋ', ' ', Copy ('Snake', N, 1));
      Sound (500 * N);
      Delay (15);
      Nosound
    End
End;

Procedure ReadScores;                                {----------------------}
BEGIN                                                {                      }
  Assign (F, 'snake.res');                           {                      }
  {$I-}                                              {                      }
  ReSet (F);                                         {                      }
  {$I+}                                              {      –…„“€       }
  If IOResult = 0 then                               {  ‘‡„€ / —’…   }
    BEGIN                                            {  ’€‹–› …„‚.   }
      For A := 1 to 20 do ReadLn (F, SCORES[A]);     {                      }
      Close (F)                                      {                      }
    END                                              {                      }
  Else                                               {                      }
    For A := 1 to 20 do                              {                      }
      SCORES[A] := ('0 '+Rekl[1+Random(10)])         {                      }
END;                                                 {----------------------}

Procedure WriteScores;                               {----------------------}
BEGIN                                                {                      }
  Assign (F, 'snake.res');                           {      –…„“€       }
  ReWrite (F);                                       {       ‡€‘         }
  For A := 1 to 20 do WriteLn (F, SCORES[A]);        {  ’€‹–› …„‚.   }
  Close (F)                                          {                      }
END;                                                 {----------------------}

Procedure PutScores;                                 {----------------------}
Var                                                  {                      }
  S:String;                                          {                      }
BEGIN                                                {                      }
  Color (Magenta, Yellow);                           {                      }
  GotoXY (33, 1);                                    {                      }
  Write ('¥ª®ΰ¤λ:');                                {                      }
  GotoXY (33, 22);                                   {      –…„“€       }
  Write ('        ');                                {’€†…  € €…}
  For A := 1 to 20 do                                {  ’€‹–› …„‚.   }
    BEGIN                                            {                      }
      GotoXY (33, A + 1);                            {                      }
      S := Copy (SCORES[A], 1, 2);                   {                      }
      TextColor (White);                             {                      }
      Write (S);                                     {                      }
      S := Copy (SCORES[A], 3, 7);                   {                      }
      TextColor (Blue);                              {                      }
      Write (S)                                      {                      }
    END                                              {                      }
END;                                                 {----------------------}

Procedure ScoresSort;                                 {---------------------}
BEGIN                                                 {                     }
  If SC = HI then                                     {                     }
    BEGIN                                             {                     }
      For A := 19 downto 1 do                         {                     }
        SCORES[A+1] := SCORES[A];                     {                     }
      SCORES[1] := SCORE                              {                     }
    END                                               {                     }
  Else                                                {                     }
    BEGIN                                             {–…„„“€ ‘’‚}
      For A := 1 to 19 do                             {     …‡“‹’€’€      }
        BEGIN                                         { ‚ ’€‹–… …„‚. }
          If (SCORES[A][2] <> ' ') and                {                     }
             (SC < Valu (Copy (SCORES[A], 1, 2))) THEN{                     }
              P := A + 1                              {                     }
          Else                                        {                     }
            If SC < Valu (SCORES[A][1]) then          {                     }
              P := A + 1                              {                     }
        END;                                          {                     }
      For A := 20 downto P do                         {                     }
        SCORES[A+1] := SCORES [A];                    {                     }
      SCORES[P] := SCORE                              {                     }
    END                                               {                     }
END;                                                  {---------------------}

Procedure Menu;                                      {----------------------}
BEGIN                                                {                      }
  Color (Magenta, Blue);                             {                      }
  ClrScr;                                            {                      }
  GotoXY (1, 5);                                     { –…„“€  ‚›‘‚ }
                                                     {       ‡€‘’€‚.      }
  TextColor (LightBlue);                             {                      }
  WriteLn;                                           {                      }
  WriteLn (' ƒ € „   €    …  …   € ');        {                      }
  TextColor (Black);                                 {                      }
  WriteLn ('   ­β¥ΰ―ΰ¥β ζ¨ο ”ΰγ­§¥ €.€.'#13#10+     {                      }
                         '          (1993-1996).');  {                      }
  WriteLn;                                           {                      }
  WriteLn (' γ«¨βμ ―ΰ¥α¬λª ξι¨¬αο ¬®¦­® α'#13#10'―®¬®ιμξ "αβΰ¥«®ª".'); {   }
  WriteLn (' „«ο ®ª®­η ­¨ο ¨£ΰλ ¦¬¨ ESC α®'+                            {   }
            #13#10'Άα¥© ¤γΰ¨,  ¤«ο ¥¥ ―ΰ®¤®«¦¥­¨ο'#13#10'¦¬¨ ENTER.');  {   }
  PutScores                                          {                      }
END;                                                 {----------------------}

Procedure PlayScreen;                                {----------------------}
BEGIN                                                {                      }
  Color (Black, Black);                              {                      }
  ClrScr;                                            {      –…„“€,      }
  Window (1, 1, 32, 22);                             {      ‘‡„€™€       }
  Color (Brown, Black);                              {    ƒ‚‰ €.    }
  ClrScr;                                            {                      }
  GotoXY (3, 1);                                     {                      }
  Write ('‘η¥β:');                                   {                      }
(*  GotoXY (12, 1);                                    {                      }
  Write ('‚ΰ¥¬ο:');                                  {                      }*)
  GotoXY (17, 1);                                    {                      }
  Write ('€΅α. ¥ª®ΰ¤:');                            {                      }
  Window (2, 2, 31, 21);                             {                      }
  Color (Green, Green);                              {                      }
  ClrScr;                                            {                      }
  Window (1, 1, 40, 25)                              {                      }
END;                                                 {----------------------}

Procedure VarSet;                                    {----------------------}
BEGIN                                                {                      }
  Len := 10;                                         {                      }
  SC := 0;                                           {                      }
  X0 := 0;                                           {                      }
  Y0 := -1;                                          {    ’€ –…„“€     }
  EX := 15;                                          {    “‘’€€‚‹‚€…’     }
  EY := 20;                                          {  €—€‹›… ‡€—…  }
  For A := 1 to Len do                               {„€’   …’›•}
    BEGIN                                            {      ………›•.     }
      X[A] := 15;                                    {                      }
      Y[A] := A+10                                   {                      }
    END                                              {                      }
END;                                                 {----------------------}

Procedure PutNewDollar;                              {----------------------}
Label                                                {                      }
  L;                                                 {                      }
BEGIN                                                {                      }
L:Q := Random (20)+2;                                {    ’€ –…„“€     }
  W := Random (30)+2;                                {  ‘“…’  € €…   }
  For A := 1 to Len do                               {    ‚›‰ „‹‹€.     }
    If (X[A] = W) and (Y[A] = Q) then Goto L;        {                      }
  Color (LightGreen, Yellow);                        {                      }
  GotoXY (W, Q);                                     {                      }
  Write ('$')                                        {                      }
END;                                                 {----------------------}

Procedure PutSnakeVars;                              {----------------------}
BEGIN                                                {                      }
  Color (LightGreen, Blue);                          {                      }
  GotoXY (EX, EY);                                   {                      }
  Write (' ');                                       {                      }
  For A := Len downto 1 do                           {                      }
    BEGIN                                            {    ’€ –…„“€     }
      GotoXY (X[A], Y[A]);                           { ’€†€…’ € €… }
      Write ('O')                                    {  ‡…, ‚…  —. }
    END;                                             {                      }
  Color (Brown, Black);                              {                      }
  GotoXY (8, 1);                                     {                      }
  Write (SC);                                        {                      }
(*  GotoXY (18, 1);                                    {                      }
  Write (T, '  ');                                   {                      }*)
  GotoXY (29, 1);                                    {                      }
  Write (HI);                                        {                      }
  DX := X0;                                          {                      }
  DY := Y0                                           {                      }
END;                                                 {----------------------}

Procedure KeyScan;                                   {-----------------------}
BEGIN                                                {’€ –…„“€ ‘—’›‚€…’}
  If KeyPressed then                                 { ‘ ‹€‚€’“›  ‘‚‹› }
    BEGIN                                            { ‚ ‘’‚…’‘’‚ ‘ }
      C1 := ReadKey;                                 { ‡……’  €€‚‹…… }
      If C1 = #0 then                                {    ‘’€’“‘ ‚›•„€ :   }
        BEGIN                                        {                       }
          C2 := ReadKey;                             {                       }
          Case c2 of                                 {                       }
            #75: BEGIN; X0 := -1; Y0 := 0; END;      {        -         LEFT }
            #77: BEGIN; X0 := 1; Y0 := 0; END;       {        -         RIGHT}
            #80: BEGIN; X0 := 0; Y0 := 1; END;       {        -         DOWN }
            #72: BEGIN; X0 := 0; Y0 := -1; END       {        -         UP   }
            END                                      {                       }
        END;                                         {                       }
      If C1 = #27 then EXIT := True                  {        -         EXIT }
      Else EXIT := false                             {                       }
    END                                              {                       }
END;                                                 {-----------------------}

Function CheckRun:Boolean;                           {----------------------}
Var                                                  {                      }
  C:Boolean;                                         {                      }
BEGIN                                                {                      }
  CheckRun := false;                                 {’€ ”“– …„…‹…’}
  If Y[1] = 1 then CheckRun := true;                 {›‹ ‹ ‚›•„ ‡€ €.}
  If X[1] = 1 then CheckRun := true;                 {                      }
  If Y[1] = 22 then CheckRun := true;                {                      }
  If X[1] = 32 then CheckRun := true                 {                      }
END;                                                 {----------------------}

Function CheckEat:Boolean;                           {----------------------}
BEGIN                                                {                      }
  CheckEat := false;                                 {’€ ”“– …„…‹…’}
  For A := 2 to Len do If (X[1] = X[A]) and          {  ›‹ ‹ "‘€““‘".  }
   (Y[1] = Y[A])                                     {                      }
     then CheckEat := true                           {                      }
END;                                                 {----------------------}

Function CheckDollar:Boolean;                        {----------------------}
BEGIN                                                {                      }
  If (W = HX) and (Q = HY) then CheckDollar := true  {’€ ”“– …„…‹…’}
  Else CheckDollar := false                          { ›‹ ‹ ‘…„… „‹‹€.}
END;                                                 {                      }
                                                     {----------------------}
Procedure Move;
BEGIN                                                {----------------------}
  EX := X[Len];                                      {                      }
  EY := Y[Len];                                      {                      }
  For A := Len downto 2 do                           {                      }
    BEGIN                                            {    ’€  –…„“€    }
      X[A] := X[A-1];                                {   ‡‚„’ ‘„‚ƒ   }
      Y[A] := Y[A-1]                                 {    „€’ ‡….   }
    END;                                             {                      }
  X[1] := HX;                                        {                      }
  Y[1] := HY                                         {                      }
END;                                                 {----------------------}

Procedure Fat;                                       {----------------------}
Begin                                                {                      }
  Inc (Len);                                         {                      }
  For A := Len downto 2 do                           {    ’€ –…„“€     }
    Begin                                            {      “„‹…’       }
      X[A] := X[A-1];                                {       ƒ€„“         }
      Y[A] := Y[A-1]                                 {                      }
    End                                              {                      }
End;                                                 {----------------------}

Function Name:String;                                {----------------------}
Var                                                  {                      }
  S:String;                                          {                      }
  X1, X2, X, Y:Integer;                              {                      }
BEGIN                                                {     ’€ ”“–      }
  Window (7, 10, 24, 13);                            { ‚‡‚€™€…’ ‚‚…„…… }
  Color (White, Magenta);                            {      ƒ€.      }
  ClrScr;                                            {                      }
  CursorOn (6, 7);                                   {                      }
  Write (' §®Ά¨αμ (6 ΅γªΆ):');                      {                      }
  Color (White, Red);                                {                      }
  GotoXY (7, 2);                                     {                      }
  ReadLn (S);                                        {                      }
  Window (1, 1, 40, 25);                             {                      }
  CursorOff;                                         {                      }
  Name := S                                          {                      }
END;                                                 {----------------------}

Procedure OverText;                                  {----------------------}
Var                                                  {                      }
  RES, PNAME:String;                                 {                      }
BEGIN                                                {–…„“€ ‚›‚„€ ‘’‚}
  Color (Red, Yellow);                               { ’…‘’€ ‚ –… ƒ›: }
  GotoXY (1, 23);                                    {                      }
(*  If T = 0 then Write (TO1);                         { - —€… ‚……  }*)
  If CheckEat then Write (TO2);                      { - ‘€““‘           }
  If CheckRun then Write (TO3);                      { - ‚›•„ ‡€ …„…‹›   }
  If EXIT then Write (TO4);                          { - ’…€ ƒ›        }
  EXIT := false;                                     {                      }
  If (SC >= LO) and (SC > 0) then                    { ---                  }
    BEGIN                                            {    |                 }
      GotoXY (1, 24);                                {    |                 }
      Color (White, Blue);                           {    |                 }
      Write (TO5);                                   {    |                 }
      PNAME := Name;                                 {    |                 }
      If Length (PNAME) > 6 then                     {    |                 }
        PNAME := Copy (PNAME, 1, 6);                 {    |                 }
      If Length (PNAME) < 6 then                     {    |                 }
        Repeat                                       {    |  €’€,        }
          PNAME := PNAME + ' '                       {     | ‘‚‡€€      }
        Until Length (PNAME) = 6;                    {     | ‘              }
      RES := Stri (SC);                              {     | ‹-‚        }
      If Length (RES) = 1 then                       {    |  —‚          }
        RES := RES + ' ';                            {    |                 }
      SCORE := RES + PNAME;                          {    |                 }
      ScoresSort;                                    {    |                 }
      Color (Black, Black);                          {    |                 }
      Window (1, 1, 32, 25);                         {    |                 }
      ClrScr;                                        {    |                 }
      Window (33, 22, 40, 25);                       {    |                 }
      Clrscr;                                        {    |                 }
      Window (1, 1, 40, 25);                         {    |                 }
      PutScores                                      {    |                 }
    END;                                             { ---                  }
  Delay (1000);                                      { - ‡€„…†€           }
  Repeat                                             { - ‚›•„  €†€’   }
  Until KeyPressed                                   {                      }
END;                                                 {----------------------}

BEGIN                                                {----------------------}
  Randomize;                                         {                      }
  ReadScores;                                        {                      }
  If SCORES[1][2] <> ' ' then                        {                      }
    HI := Valu (Copy (SCORES[1], 1, 2))              {                      }
  Else                                               {                      }
    HI := Valu (SCORES[1][1]);                       {                      }
  If SCORES[20][2] <> ' ' then                       {                      }
    LO := Valu (Copy (SCORES[20], 1, 2))             {                      }
  Else                                               {                      }
    LO := Valu (SCORES[20][1]);                      {                      }
  ScreenMode;                                        {                      }
  CursorOff;                                         {                      }
  Menu;                                              {                      }
  Picture;                                           {                      }
  Repeat                                             {                      }
    KeyScan;                                         {                      }
    If C1 = #13 then                                 {                      }
      BEGIN                                          {                      }
        PlayScreen;                                  {                      }
        PutScores;                                   {                      }
        VarSet;                                      {                      }
        PutNewDollar;                                {                      }
        While true do                                {                      }
(*        For T := 1000 downto 0 do                    {                      }*)
          BEGIN                                      {                      }
            PutSnakeVars;                            { ‘‚€ —€‘’ ƒ›. }
            KeyScan;                                 {                      }
            If DX = -X0 then X0 := DX;               {                      }
            If DY = -Y0 then Y0 := DY;               {                      }
            HX := X[1] + X0;                         {                      }
            HY := Y[1] + Y0;                         {                      }
            If CheckDollar then                      {                      }
              BEGIN                                  {                      }
                Inc (SC);                            {                      }
                If SC > HI then HI := SC;            {                      }
                Fat;                                 {                      }
                PutNewDollar                         {                      }
              END;                                   {                      }
            If CheckRun then Goto L2;                {                      }
            Move;                                    {                      }
            If CheckEat then Goto L2;                {                      }
            If EXIT then Goto L2;                    {                      }
            Delay (75)                               {                      }
          END;                                       {                      }
L2:     OverText;                                    {                      }
        Menu                                         {                      }
      END                                            {                      }
  Until EXIT;                                        {                      }
L3:                                                  {                      }
  TextMode (LM);                                     {                      }
  CursorOn (6, 7);                                   {                      }
  WriteScores                                        {                      }
END.                                                 {----------------------}
