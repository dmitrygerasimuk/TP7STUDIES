
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
{	Draw colored bars with the mouse			}
{---------------------------------------------------------------}

program Bars;

uses Graph, Mouse;

var
  grDriver  : Integer;
  grMode    : Integer;
  ErrorCode : Integer;
  Color     : Integer;

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
  OutTextXY(1, 1, 'Left mouse button draws bars, right mouse button ends.');
  Randomize;

  ShowMouse;                  { show mouse cursor }
  repeat
    ReadMouse;                { read mouse state }
    if LeftButtonPressed then { if the left button is pressed then }
    begin
      HideMouse;              { temporarily hide the mouse cursor }
      SetFillStyle(1, Random(GetMaxColor) + 1); { select a random drawing color }

      { Draw a bar having the left upper corner at the mouse current position }
      Bar3D(MouseX, MouseY, MouseX + 45, MouseY + 45, 0, TopOn);

      ShowMouse               { show the mouse cursor again }
    end
  until RightButtonPressed;   { repeat until user clicks the right button }
  HideMouse;                  { hide mouse cursor }
  CloseGraph                  { close graphics }
end.