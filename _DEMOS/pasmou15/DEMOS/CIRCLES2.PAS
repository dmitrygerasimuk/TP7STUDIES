
{---------------------------------------------------------------}
{								}
{	Pascal Mouse						}
{	Mouse Interface for Turbo/Borland Pascal 6.0/7.0	}
{	Version 1.5						}
{       June 17 1997						}
{								}
{	Copyright (c) 1996-1997 Horatiu A. Tanescu		}
{								}
{---------------------------------------------------------------}
{	Force mouse to "move around"				}
{---------------------------------------------------------------}

program Circles2;

uses Graph, Crt, Mouse;

var
  grDriver  : Integer;
  grMode    : Integer;
  ErrorCode : Integer;
  X, Y      : Integer;
  DelayTime : Word;
  IncOrDec  : Byte;
  C         : Char;

begin
  if not MouseInstalled then  { if a mouse driver is not installed }
  begin                       { then halt program }
    WriteLn('Sorry, mouse is not available');
    Halt(1)
  end;

  { Initialize graphics }
  grDriver := Detect;
  InitGraph(grDriver, grMode, '');
  ErrorCode := GraphResult;
  if ErrorCode <> grOk then   { if an error occurs then halt program }
  begin
    Writeln('Graphics error : ', GraphErrorMsg(ErrorCode));
    Halt(2)
  end;
  OutTextXY(1, 1, 'Left mouse button clears the screen, right mouse button ends.');
  OutTextXY(1, 12, '+ move faster  - move slower');
  Randomize;
  DelayTime := 20;

  ShowMouse;                  { show mouse cursor }
  repeat
    if KeyPressed then        { if a key is pressed }
    begin
      C := ReadKey;
      if (C = '+') and (DelayTime > 0) then
        Dec(DelayTime);       { increments mouse drawing speed }
      if (C = '-') then
        Inc(DelayTime)        { decrements mouse drawing speed }
    end;

    { Calculate a new position for the mouse }
    IncOrDec := Random(2);
    case IncOrDec of
      0 : begin
            if X < GetMaxX then Inc(X, Random(30))
            else X := 0;
            if Y < GetMaxY then Inc(Y, Random(30))
            else Y := 0
          end;
      1 : begin
            if X > 10 then Dec(X, Random(30))
            else X := GetMaxX;
            if Y > 10 then Dec(Y, Random(30))
            else Y := GetMaxY
          end
    end;

    { Move mouse to that position. Also reads mouse state }
    MouseTo(X, Y);

    HideMouse;                { temporarily hide the mouse cursor }
    SetColor(Random(GetMaxColor) + 1); { set a random drawing color }

    { Draw a circle having the center point at the mouse current position }
    Circle(MouseX, MouseY, 10);

    { If left button pressed then clear the screen }
    if LeftButtonPressed then
    begin
      ClearDevice;
      OutTextXY(1, 1, 'Left mouse button clears the screen, right mouse button ends.');
      OutTextXY(1, 12, '+ move faster  - move slower')
    end;

    ShowMouse;                { show the mouse cursor again }
    Delay(DelayTime)          { wait a few moments }

  until RightButtonPressed;   { repeat until user clicks the right button }
  HideMouse;                  { hide mouse cursor }
  CloseGraph                  { close graphics }
end.