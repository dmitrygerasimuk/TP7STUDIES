
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
{	Eyes that follow the mouse				}
{---------------------------------------------------------------}

program Eyes;

uses Graph, Crt, Mouse;

var
  grDriver  : Integer;
  grMode    : Integer;
  ErrorCode : Integer;
  X, Y      : Integer;

begin
  if not MouseInstalled then  { if a mouse driver is not installed }
  begin                       { then halt program }
    WriteLn('Sorry, mouse is not available');
    Halt(1)
  end;

  { Initialize graphics }
  grDriver := Detect;
  InitGraph(grDriver, grMode, ' ');
  ErrorCode := GraphResult;
  if ErrorCode <> grOk then   { if an error occurs then halt program }
  begin
    Writeln('Graphics error : ', GraphErrorMsg(ErrorCode));
    Halt(2)
  end;
  OutTextXY(1, 450, 'Right button ends.');
  Randomize;

  { Draw eyes }
  SetColor(15);
  Circle(100, 120, 70);
  Circle(300, 120, 70);
  Arc(100, 80, 0, 180, 70);
  Arc(300, 80, 0, 180, 70);
  Ellipse(200, 270, 180, 0, 100, 80);

  ShowMouse;                  { show mouse cursor }
  repeat
    ReadMouse;                { read mouse state }

    if LeftButtonPressed then { if left button pressed then }
    begin
      SetColor(15);
      Line(120, 300, 280, 300);
      Delay(2);
      SetColor(0);
      Line(120, 300, 280, 300)
    end;

    if (Abs(MouseX - X) > 30 ) or (Abs(MouseY - Y) > 30) then
    begin         { if the mouse have moved with at least 30 pixels }

      HideMouse;                { temporarily hide the mouse cursor }

      { Clears the last position of the eyes }
      SetColor(0);
      SetFillStyle(1, 0);
      FillEllipse(X div 20 +  90, Y div 20 + 120, 15, 15);
      FillEllipse(X div 20 + 290, Y div 20 + 120, 15, 15);

      X := MouseX;
      Y := MouseY;

      { Redraws the eyes }
      SetFillStyle(1, 11);
      FillEllipse(X div 20 +  90, Y div 20 + 120, 15, 15);
      FillEllipse(X div 20 + 290, Y div 20 + 120, 15, 15);

      ShowMouse               { show the mouse cursor again }
    end
  until RightButtonPressed;   { repeat until user clicks the right button }
  HideMouse;                  { hide mouse cursor }
  CloseGraph                  { close graphics }
end.