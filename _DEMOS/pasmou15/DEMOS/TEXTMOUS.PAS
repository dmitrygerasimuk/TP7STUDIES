
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
{	Using the mouse in text modes				}
{---------------------------------------------------------------}

{	This program shows how to convert virtual mouse		}
{	coordinates into text coordinates when using the mouse	}
{	in text modes. ReadMouse returns the virtual		}
{	coordinates of the mouse so you'll need TextX and TextY	}
{	functions to convert them into text coordinates.	}

program Simple;

uses Mouse, Crt;

var
  X, Y : Integer;

begin
  if not MouseInstalled then  { if a mouse driver is not installed }
  begin                       { then halt program }
    WriteLn('Sorry, mouse is not available');
    Halt(1)
  end;

  { Prepare screen }
  TextBackground(0);
  TextColor(15);
  ClrScr;
  GotoXY(1, 25); Write('Click any button to end...');

  TextBackground(1);
  Window(1, 10, 44, 11);
  ClrScr;
  WriteLn(' Virtual coordinates :    X:         Y:');
  Write(' Text    coordinates :    X:         Y:');

  ShowMouse;                 { show mouse cursor }
  X := 0;
  Y := 0;

  repeat
    ReadMouse;                { read the mouse }
    if (X <> MouseX) or (Y <> MouseY) then { if the mouse has been moved }
    begin
      X := MouseX;
      Y := MouseY;

      { Write mouse position in virtual coordinates }
      GotoXY(29, 1); Write(MouseX : 4);
      GotoXY(40, 1); Write(MouseY : 4);

      { Write mouse position in text coordinates }
      GotoXY(29, 2); Write(TextX(MouseX) : 4);
      GotoXY(40, 2); Write(TextY(MouseY) : 4);
    end;

  { Repeat until user clicks any button }
  until LeftButtonPressed or CenterButtonPressed or RightButtonPressed;
  HideMouse                  { hide mouse cursor }
end.