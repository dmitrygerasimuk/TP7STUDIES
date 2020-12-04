{$S-,R-,I-,V-,B-}

{*********************************************************}
{*                   OPTIMER.PAS 1.0                     *}
{*                by TurboPower Software                 *}
{*********************************************************}

unit OpTimer;
  {-Allows events to be timed with 1 microsecond resolution}

interface

uses
  Dpmi;

procedure InitializeTimer;
  {-Reprogram the timer chip to allow 1 microsecond resolution}

procedure RestoreTimer;
  {-Restore the timer chip to its normal state}

function ReadTimer : LongInt;
  {-Read the timer with 1 microsecond resolution}

function ElapsedTime(Start, Stop : LongInt) : Real;
  {-Calculate time elapsed (in milliseconds) between Start and Stop}

function ElapsedTimeString(Start, Stop : LongInt) : string;
  {-Return time elapsed (in milliseconds) between Start and Stop as a string}

  function SecondIs(Start, Stop : LongInt) : string;

  {==========================================================================}

implementation

const
  TimerResolution = 1193181.667;
var
  SaveExitProc : Pointer;
  Delta : LongInt;

  function Cardinal(L : LongInt) : Real;
    {-Return the unsigned equivalent of L as a real}
  begin                      {Cardinal}
    if L < 0 then
      Cardinal := 4294967296.0+L
    else
      Cardinal := L;
  end;                       {Cardinal}

  function ElapsedTime(Start, Stop : LongInt) : Real;
    {-Calculate time elapsed (in milliseconds) between Start and Stop}
  begin                      {ElapsedTime}
    ElapsedTime := 1000.0*Cardinal(Stop-(Start+Delta))/TimerResolution;
  end;                       {ElapsedTime}

  function ElapsedTimeString(Start, Stop : LongInt) : string;
    {-Return time elapsed (in milliseconds) between Start and Stop as a string}
  var
    R : Real;
    S : string;
  begin                      {ElapsedTimeString}
    R := ElapsedTime(Start, Stop);
    Str(R:0:3, S);
    ElapsedTimeString := S;
  end;      
  
  
  function SecondIs(Start, Stop : LongInt) : string;
    {-Return time elapsed (in milliseconds) between Start and Stop as a string}
  var
    R : Real;
    S : string;
  begin                      {ElapsedTimeString}
    R := 10*ElapsedTime(Start, Stop);
    Str(R:0:3, S);
    ElapsedTimeString := S;
  end;                     {ElapsedTimeString}

  procedure InitializeTimer;
    {-Reprogram the timer chip to allow 1 microsecond resolution}
  begin                      {InitializeTimer}
    {select timer mode 2, read/write channel 0}
    Port[$43] := $34;        {00110100b}
    inline($EB/$00);         {jmp short $+2 ;delay}
    Port[$40] := $00;        {LSB = 0}
    inline($EB/$00);         {jmp short $+2 ;delay}
    Port[$40] := $00;        {MSB = 0}
  end;                       {InitializeTimer}

  procedure RestoreTimer;
    {-Restore the timer chip to its normal state}
  begin                      {RestoreTimer}
    {select timer mode 3, read/write channel 0}
    Port[$43] := $36;        {00110110b}
    inline($EB/$00);         {jmp short $+2 ;delay}
    Port[$40] := $00;        {LSB = 0}
    inline($EB/$00);         {jmp short $+2 ;delay}
    Port[$40] := $00;        {MSB = 0}
  end;                       {RestoreTimer}

  function ReadTimer : LongInt;
    {-Read the timer with 1 microsecond resolution}
  begin                      {ReadTimer}
    inline(
      $FA/                   {cli             ;Disable interrupts}
      $BA/$20/$00/           {mov  dx,$20     ;Address PIC ocw3}
      $B0/$0A/               {mov  al,$0A     ;Ask to read irr}
      $EE/                   {out  dx,al}
      $B0/$00/               {mov  al,$00     ;Latch timer 0}
      $E6/$43/               {out  $43,al}
      $EC/                   {in   al,dx      ;Read irr}
      $89/$C7/               {mov  di,ax      ;Save it in DI}
      $E4/$40/               {in   al,$40     ;Counter --> bx}
      $88/$C3/               {mov  bl,al      ;LSB in BL}
      $E4/$40/               {in   al,$40}
      $88/$C7/               {mov  bh,al      ;MSB in BH}
      $F7/$D3/               {not  bx         ;Need ascending counter}
      $E4/$21/               {in   al,$21     ;Read PIC imr}
      $89/$C6/               {mov  si,ax      ;Save it in SI}
      $B0/$FF/               {mov  al,$0FF    ;Mask all interrupts}
      $E6/$21/               {out  $21,al}
     { $B8/$40/$00/}         {mov  ax,$40}                            {!!.20}
      $A1/>BiosDataSele/     {mov  ax,$40     ;read low word of time}
      $8E/$C0/               {mov  es,ax      ;from BIOS data area}
      $26/$8B/$16/$6C/$00/   {mov  dx,es:[$6C]}
      $89/$F0/               {mov  ax,si      ;Restore imr from SI}
      $E6/$21/               {out  $21,al}
      $FB/                   {sti             ;Enable interrupts}
      $89/$F8/               {mov  ax,di      ;Retrieve old irr}
      $A8/$01/               {test al,$01     ;Counter hit 0?}
      $74/$07/               {jz   done       ;Jump if not}
      $81/$FB/$FF/$00/       {cmp  bx,$FF     ;Counter > $FF?}
      $77/$01/               {ja   done       ;Done if so}
      $42/                   {inc  dx         ;Else count int req.}
      {done:}
      $89/$5E/$FC/           {mov [bp-4],bx   ;set function result}
      $89/$56/$FE);          {mov [bp-2],dx}
  end;                       {ReadTimer}

  procedure Calibrate;
    {-Calibrate the timer}
  const
    Reps = 1000;
  var
    I : Word;
    L1, L2, Diff : LongInt;
  begin                      {Calibrate}
    Delta := MaxInt;
    for I := 1 to Reps do begin
      L1 := ReadTimer;
      L2 := ReadTimer;
      {use the minimum difference}
      Diff := L2-L1;
      if Diff < Delta then
        Delta := Diff;
    end;
  end;                       {Calibrate}

  {$F+}
  procedure OurExitProc;
    {-Restore timer chip to its original state}
  begin                      {OurExitProc}
    ExitProc := SaveExitProc;
    RestoreTimer;
  end;                       {OurExitProc}
  {$F-}

begin
  {set up our exit handler}
  SaveExitProc := ExitProc;
  ExitProc := @OurExitProc;

  {reprogram the timer chip}
  InitializeTimer;

  {adjust for speed of machine}
  Calibrate;
end.
