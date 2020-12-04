{------------ Модуль для профессиональной работы с текстом ------------}
                                Unit ProfText;
{----------------------------------------------------------------------}


{----------------------------------------------------------------------}
                                  Interface
{----------------------------------------------------------------------}

Function Font8x8Yes   : Boolean;
Function GetScreenPtr : Pointer;
Function GetScreenSize: Word;
Function CurrentMode  : Byte;
Function GetColNum    : Byte;
Function GetRowNum    : Byte;
Procedure GetCursorLines (Var UpLine, DownLine: Byte);
Procedure CursorOn           (UpLine, DownLine: Byte);
Procedure CursorOff;

Procedure WriteChar (Col, Row, CharToPrint: Byte; CharToFill: Char;
                     Var AddrOfTable_2);
Procedure WriteLargeString (X, Y: Byte; C, T: Char; S: String);

{----------------------------------------------------------------------}
                                Implementation
{----------------------------------------------------------------------}

Uses
  CRT, DOS;

{--------- Функция возвращает True, если включен режим Font8x8 --------}
Function Font8x8Yes   : Boolean;
Begin
  Font8x8Yes := (LastMode and Font8x8) = Font8x8
End;

{-------- Функция возвращает адрес видеопамяти в режеме текста --------}
Function GetScreenPtr : Pointer;
Begin
  If (Mem[0:$410] and $30) = $30
    then GetScreenPtr := Ptr ($B000, 0)
    else GetScreenPtr := Ptr ($B800, 0)
End;

{-------- Функция возвращает длину видеопамяти в режеме текста --------}
Function GetScreenSize: Word;
Var
  R: Byte absolute 0:$484;
  C: Byte absolute 0:$44A;
Begin
  If Hi (LastMode) = 1
    then GetScreenSize := Succ (R) * C * 2
    else GetScreenSize := C * 50;
End;

{------------ Функция возвращает номер текущего видеорежима -----------}
Function CurrentMode  : Byte;
Begin
  CurrentMode := Lo (LastMode)
End;

{------------ Функция возвращает число столбцов - 40 или 80 -----------}
Function GetColNum    : Byte;
Begin
  GetColNum := Mem[0:$44A]
End;

{----------- Функция возвращает число строк - 25, 43 или 50 -----------}
Function GetRowNum    : Byte;
Begin
  GetRowNum := GetScreenSize div GetColNum div 2
End;

{ Процедура возвращает в переменные UpLine и DownLine верхнюю и нижнюю }
{---------------------- строки развертки курсора ----------------------}
Procedure GetCursorLines (Var UpLine, DownLine: Byte);
Var
  Reg:Registers;
Begin
  With Reg do
    Begin
      AH := 3;
      BH := 0;
      Intr ($10, Reg);
      UpLine := CH;
      DownLine := CL
    End
End;

{------ Процедура включает курсор.  Параметры - строки разверток ------}
Procedure CursorOn (UpLine, DownLine: Byte);
Var
  Reg:Registers;
Begin
  With Reg do
    Begin
      AH := 1;
      CH := UpLine;
      CL := DownLine
    End;
  Intr ($10, Reg)
End;

{--------------------- Процедура отключает курсор ---------------------}
Procedure CursorOff;
Var
  Reg:Registers;
Begin
  With Reg do
    Begin
      AH := 1;
      CH := $20
    End;
  Intr($10, Reg)
End;


{----------------- Процедура выводит большой символ. ------------------}
Procedure WriteChar (Col, Row, CharToPrint: Byte; CharToFill: Char;
                     Var AddrOfTable_2);
Type
  CharDim  = Array [1..8] of Byte;
  TableDim = Array [0..127] of CharDim;
Var
  X, Y   : Byte;
  Table_1: TableDim absolute $F000:$FA6E;
  Table_2: TableDim absolute AddrOfTable_2;
  Pattern: CharDim;
Begin
  Case CharToPrint of
      0..127: Pattern := Table_1[CharToPrint];
    128..255: Pattern := Table_2[CharToPrint - 128];
  End;
  Inc (Col, 7);
  Dec (Row, 8);
  For X := 1 to 8 do
    For Y := 7 downto 0 do
      Begin
        GotoXY (Col - Y, Row + X);
        If (Odd (Pattern[X] shr Y)) then Write (CharToFill)
      End
End;


{------------- Процедура выводит строку больших символов. -------------}
Procedure WriteLargeString (X, Y: Byte; C, T: Char; S: String);
Var
  I  : Byte;
  Del: ShortInt;
  P  : Pointer;
Begin
  Inc (Y);
  GetIntVec ($1F, P);
  If Y < 9 then Y := 9;
  If Y > Hi (WindMax) then Y := Hi (WindMax) + 1;
  I := Lo (WindMax) - Lo (WindMin) + 1;
  Repeat
    Del := I - (8 * Length (S) + X - 1);
    If Del < 0 then Delete (S, Length (S), 1)
  Until Del >= 0;
  For I := 1 to Length (S) do
    Begin
      WriteChar (X + I * 8 - 7, Y, Ord (S[I]), T, P^);
      WriteChar (X + I * 8 - 8, Y - 1, Ord (S[I]), C, P^)
    End
End;

End.
