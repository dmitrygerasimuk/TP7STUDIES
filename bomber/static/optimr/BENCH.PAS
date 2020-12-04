{$A+}
program Bench;

uses
  OpTimer,
  OpString,
  OpRoot,
  OpCrt,
  OpDos,
  OpLArray;

const
  ArrayNames : Array[lRamArray..lVirtualArray] of String[7] = ('RAM',
                                                               'EMS',
                                                               'VIRTUAL');

  {$IFDEF Dpmi}
  RPriorities : AutoPriority = (lRamArray,lNoArray);
  VPriorities : AutoPriority = (lVirtualArray,lNoArray);
  APriorities : AutoPriority = (lRamArray,lVirtualArray);
  {$ELSE}
  RPriorities : AutoPriority = (lRamArray,lNoArray,lNoArray);
  EPriorities : AutoPriority = (lEMSArray,lNoArray,lNoArray);
  VPriorities : AutoPriority = (lVirtualArray,lNoArray,lNoArray);
  APriorities : AutoPriority = (lRamArray,lEMSArray,lVirtualArray);
  {$ENDIF}

type
  Str80 = String[80];
  ByteArray    = Array[1..11] of Array[1..11] of Byte;
  WordArray    = Array[1..11] of Array[1..11] of Word;
  RealArray    = Array[1..11] of Array[1..11] of Real;
  StrArray     = Array[1..11] of Array[1..11] of Str80;

var
  Priorities : AutoPriority;
var
  Arr : OpArrayPtr;
var
  HeapToUse,Start,Stop,EmptyLoopTime : LongInt;
var
  RowNum,ColNum,MaximumRows,MaximumCols,ElementSize : Word;
var
  BA : ByteArray;
var
  WA : WordArray;
var
  RA : RealArray;
var
  SA : StrArray;
var
  AType : ArrayType;
var
  NumToDo : Word;

procedure Abort(A : OpArrayPtr);

begin
  Dispose(A,Done);
  Halt;
end;

function GetArrayType : ArrayType;

var
  C : Char;

begin
  {$IFDEF Dpmi}
  Write('Enter Array Type (R,V,A): ');
  repeat
    C := UpCase(ReadKey);
  until C in ['R','V','A',^[];
  {$ELSE}
  Write('Enter Array Type (R,E,V,A): ');
  repeat
    C := UpCase(ReadKey);
  until C in ['R','E','V','A',^[];
  {$ENDIF}
  case C of
    'R' : begin
            Priorities := RPriorities;
            GetArrayType := lRamArray;
          end;
    {$IFNDEF Dpmi}
    'E' : begin
            Priorities := EPriorities;
            GetArrayType := lEMSArray;
          end;
    {$ENDIF}
    'V' : begin
            Priorities := VPriorities;
            GetArrayType := lVirtualArray;
          end;
    'A' : begin
            Priorities := APriorities;
            GetArrayType := lNoArray;
          end;
    else Halt;
  end;
  WriteLn(C);
end;

function GetElementType : Word;

var
  C : Char;

begin
  Write('Enter Element Type (Byte,Word,Real,String): ');
  repeat
    C := UpCase(ReadKey);
  until C in ['B','W','R','S',^[];
  case C of
    'B' : GetElementType := SizeOf(Byte);
    'W' : GetElementType := SizeOf(Word);
    'R' : GetElementType := SizeOf(Real);
    'S' : GetElementType := SizeOf(Str80);
    else Halt;
  end;
  WriteLn(C);
end;

function GetAWord(S : String) : Word;
var
  NStr : String;
  N : Word;

begin
  Write(S);
  ReadLn(NStr);
  if (not Str2Word(NStr,N)) or (N = 0) then
    Halt;
  GetAWord := N;
end;

procedure GetMaxRowCol;

begin
  MaximumRows := GetAWord('Enter max rows: ');
  MaximumCols := GetAWord('Enter max cols: ');
end;

procedure GetNumToDo;

begin
  NumToDo := GetAWord('Enter number to do: ');
end;

procedure GetRowCol;

begin
  RowNum := GetAWord('Enter row to read: ');
  ColNum := GetAWord('Enter col to read: ');
end;

function YesNo(Msg : String) : Boolean;
var
  C : Char;

begin
  Write(Msg);
  repeat
    C := UpCase(ReadKey);
  until C in ['Y','N'];
  WriteLn(C);
  YesNo := C = 'Y';
end;

function CalcElapsedTime(Start,Stop : LongInt) : String;
var
  NumMs : Real;
  S : String;
begin
  Stop := Stop - EmptyLoopTime;
  NumMs := 1000*ElapsedTime(Start,Stop)/NumToDo;

  Str(NumMs:8:2,S);
  CalcElapsedTime := S;
end;

procedure DoByteTest;

var
  I : Word;
  B : Byte;
begin
  WriteLn('Performing byte test');
  Start := ReadTimer;
  for I := 1 to NumToDo do
    Arr^.RetA(RowNum,ColNum,B);
  Stop := ReadTimer;
  WriteLn('Time for OpLarray = ',CalcElapsedTime(Start,Stop));
  Start := ReadTimer;
  for I := 1 to NumToDo do
    B := BA[RowNum,ColNum];
  Stop := ReadTimer;
  WriteLn('Time for Turbo    = ',CalcElapsedTime(Start,Stop));
end;

procedure DoWordTest;

var
  W,I : Word;
begin
  WriteLn('Performing word test');
  Start := ReadTimer;
  for I := 1 to NumToDo do
    Arr^.RetA(RowNum,ColNum,W);
  Stop := ReadTimer;
  WriteLn('Time for OpLarray = ',CalcElapsedTime(Start,Stop));
  Start := ReadTimer;
  for I := 1 to NumToDo do
    W := WA[RowNum,ColNum];
  Stop := ReadTimer;
  WriteLn('Time for Turbo    = ',CalcElapsedTime(Start,Stop));
end;

procedure DoRealTest;

var
  I : Word;
  R : Real;
begin
  WriteLn('Performing real test');
  Start := ReadTimer;
  for I := 1 to NumToDo do
    Arr^.RetA(RowNum,ColNum,R);
  Stop := ReadTimer;
  WriteLn('Time for OpLarray = ',CalcElapsedTime(Start,Stop));
  Start := ReadTimer;
  for I := 1 to NumToDo do
    R := RA[RowNum,ColNum];
  Stop := ReadTimer;
  WriteLn('Time for Turbo    = ',CalcElapsedTime(Start,Stop));
end;

procedure DoStringTest;

var
  I : Word;
  S : Str80;
begin
  WriteLn('Performing string test');
  Start := ReadTimer;
  for I := 1 to NumToDo do
    Arr^.RetA(RowNum,ColNum,S);
  Stop := ReadTimer;
  WriteLn('Time for OpLarray = ',CalcElapsedTime(Start,Stop));
  Start := ReadTimer;
  for I := 1 to NumToDo do
    S := SA[RowNum,ColNum];
  Stop := ReadTimer;
  WriteLn('Time for Turbo    = ',CalcElapsedTime(Start,Stop));
end;

procedure Benchmark;
var
  Z : String;
begin
  if YesNo('Read to force page? ') then
    Arr^.RetA(RowNum,ColNum,Z);
  case ElementSize of
    SizeOf(Byte)   : DoByteTest;
    SizeOf(Word)   : DoWordTest;
    SizeOf(Real)   : DoRealTest;
    SizeOf(Str80)  : DoStringTest;
  end;
end;

function TimeEmptyLoop : LongInt;
var
  I : Word;
begin
  Start := ReadTimer;
  for I := 1 to NumToDo do begin
  end;
  Stop := ReadTimer;
  TimeEmptyLoop := Stop - Start;
end;

begin
  FillChar(SA,SizeOf(SA),80);
  AType := GetArrayType;
  GetMaxRowCol;
  GetRowCol;
  GetNumToDo;
  ElementSize := GetElementType;
  if AType in [lNoArray,lRamArray,lVirtualArray] then
    HeapToUse := MaxAvail - 10000
  else
    HeapToUse := 1;
  EmptyLoopTime := TimeEmptyLoop;
  WriteLn('Time for an empty loop ',EmptyLoopTime);
  Arr := New(OpArrayPtr, Init(MaximumRows,MaximumCols,
                              ElementSize,'BENCH.DAT',
                              HeapToUse,0,Priorities));
  if Arr = NIL then begin
    WriteLn('Unable to allocate array');
    Halt;
  end;
  WriteLn('The element size is ', Arr^.GetElementSize);
  Benchmark;
  Dispose(Arr,Done);
end.
