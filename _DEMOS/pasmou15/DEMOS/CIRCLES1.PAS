
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
{	Draw colored circles with the mouse			}
{---------------------------------------------------------------}

program Circles1;

uses Graph, Mouse;

var
  grDriver  : Integer;
  grMode    : Integer;
  ErrorCode : Integer;

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
  OutTextXY(1, 1, 'Left mouse button draws circles, right mouse button ends.');
  Randomize;

  ShowMouse;                  { show mouse cursor }
  repeat
    ReadMouse;                { read mouse state }
    if LeftButtonPressed then { if the left button is pressed then }
    begin
      HideMouse;              { temporarily hide the mouse cursor }
      SetColor(Random(GetMaxColor) + 1); { set a random drawing color }

      { Draw a circle having the center point at the mouse current position }
      Circle(MouseX, MouseY, 10);
      ShowMouse               { show the mouse cursor again }
    end
  until RightButtonPressed;   { repeat until user clicks the right button }
  HideMouse;                  { hide mouse cursor }
  CloseGraph                  { close graphics }
end.