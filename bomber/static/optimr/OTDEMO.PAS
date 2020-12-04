program OpTimerDemo;
  {-Simple demonstration program for OPTIMER unit}
uses
  OpTimer, Crt;
var
  DelayCount : Word;
  Start, Stop : LongInt;
begin
  repeat
    WriteLn;
    Write('Enter time to delay (in ms), or 0 to quit: ');
    ReadLn(DelayCount);
    if DelayCount > 0 then begin
      Start := ReadTimer;
      Delay(DelayCount);
      Stop := ReadTimer;
      WriteLn('Elapsed time (in ms): ', ElapsedTimeString(Start, Stop));
    end;
  until (DelayCount = 0);
end.
