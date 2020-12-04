
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
{	A minimum mouse program					}
{---------------------------------------------------------------}

program Simple;

uses Mouse;

begin
  if not MouseInstalled then  { if a mouse driver is not installed }
  begin                       { then halt program }
    WriteLn('Sorry, mouse is not available');
    Halt(1)
  end;

  WriteLn('Hello, mouse');
  ShowMouse;                 { show mouse cursor }
  repeat
    ReadMouse                { read the mouse }
  until LeftButtonPressed;   { repeat until user clicks the left button }
  HideMouse                  { hide mouse cursor }
end.